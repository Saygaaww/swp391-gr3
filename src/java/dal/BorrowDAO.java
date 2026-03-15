package dal;

import model.BorrowExtendView;
import model.BorrowRequestItem;
import model.BorrowedItemView;
import model.BorrowRequest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BorrowDAO extends DBContext {

    public int getPendingRequestsCount() {
        return countByStatus("pending");
    }

    public int getActiveBorrowsCount() {
        String sql = "SELECT COUNT(*) FROM Borrow WHERE status = 'active'";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            System.err.println("getActiveBorrowsCount Error: " + e.getMessage());
        }
        return 0;
    }

    // Lay danh sach yeu cau dang cho duyet
    public List<BorrowRequest> getPendingRequests() {
        return getRequestsFiltered(null, "pending", 1, Integer.MAX_VALUE);
    }

    // Duyet yeu cau
    public boolean approveRequest(int requestId, int employeeId, String note) {
        return processRequest(requestId, "approved", employeeId, note);
    }

    // Tu choi yeu cau
    public boolean rejectRequest(int requestId, int employeeId, String note) {
        return processRequest(requestId, "rejected", employeeId, note);
    }

    // Xu ly yeu cau (duyet hoac tu choi)
    private boolean processRequest(int requestId, String newStatus, int employeeId, String note) {
        String sql = "UPDATE Borrow_Request SET status = ?, " +
                "processed_by_employee_id = ?, " +
                "processed_at = SYSUTCDATETIME(), " +
                "decision_note = ? " +
                "WHERE request_id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, employeeId);
            ps.setString(3, note);
            ps.setInt(4, requestId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("processRequest Error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Lay chi tiet 1 yeu cau theo ID
    public BorrowRequest getRequestById(int requestId) {
        String sql = "SELECT br.*, r.full_name AS reader_name, r.email, r.phone, " +
                "e.full_name AS employee_name " +
                "FROM Borrow_Request br " +
                "JOIN Reader r ON br.reader_id = r.reader_id " +
                "LEFT JOIN Employee e ON br.processed_by_employee_id = e.employee_id " +
                "WHERE br.request_id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BorrowRequest req = mapResultSet(rs);
                    try {
                        req.setReaderPhone(rs.getString("phone"));
                    } catch (SQLException e) {
                    }
                    return req;
                }
            }
        } catch (Exception e) {
            System.err.println("getRequestById Error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Lay danh sach yeu cau co loc + phan trang
    public List<BorrowRequest> getRequestsFiltered(String keyword, String status,
            int page, int pageSize) {
        List<BorrowRequest> requests = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT br.*, r.full_name AS reader_name, r.email, ");
        sql.append("e.full_name AS employee_name ");
        sql.append("FROM Borrow_Request br ");
        sql.append("JOIN Reader r ON br.reader_id = r.reader_id ");
        sql.append("LEFT JOIN Employee e ON br.processed_by_employee_id = e.employee_id ");
        sql.append("WHERE 1=1 ");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (r.full_name LIKE ? OR r.email LIKE ?) ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append("AND br.status = ? ");
        }

        sql.append("ORDER BY br.requested_at DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (status != null && !status.isEmpty())
                ps.setString(idx++, status);

            int offset = (page - 1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx++, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    requests.add(mapResultSet(rs));
                }
            }

        } catch (Exception e) {
            System.err.println("getRequestsFiltered Error: " + e.getMessage());
            e.printStackTrace();
        }
        return requests;
    }

    // Dem so yeu cau co loc
    public int countRequestsFiltered(String keyword, String status) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Borrow_Request br ");
        sql.append("JOIN Reader r ON br.reader_id = r.reader_id ");
        sql.append("WHERE 1=1 ");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (r.full_name LIKE ? OR r.email LIKE ?) ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append("AND br.status = ? ");
        }

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (status != null && !status.isEmpty())
                ps.setString(idx++, status);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("countRequestsFiltered Error: " + e.getMessage());
        }
        return 0;
    }

    // Dem theo tung trang thai
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Borrow_Request WHERE status = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("countByStatus Error: " + e.getMessage());
        }
        return 0;
    }

    // Map ResultSet thanh BorrowRequest
    private BorrowRequest mapResultSet(ResultSet rs) throws SQLException {
        BorrowRequest req = new BorrowRequest();
        req.setRequestId(rs.getInt("request_id"));
        req.setReaderId(rs.getInt("reader_id"));
        req.setStatus(rs.getString("status"));
        req.setRequestedAt(
                rs.getTimestamp("requested_at") != null ? rs.getTimestamp("requested_at").toLocalDateTime() : null);
        req.setNote(rs.getString("note"));
        req.setDecisionNote(rs.getString("decision_note"));
        req.setReaderName(rs.getString("reader_name"));
        req.setReaderEmail(rs.getString("email"));

        int processedBy = rs.getInt("processed_by_employee_id");
        if (!rs.wasNull())
            req.setProcessedByEmployeeId(processedBy);
        req.setProcessedAt(
                rs.getTimestamp("processed_at") != null ? rs.getTimestamp("processed_at").toLocalDateTime() : null);

        try {
            req.setEmployeeName(rs.getString("employee_name"));
        } catch (SQLException e) {
        }

        return req;
    }

    // =========================
    // Reader-side methods
    // =========================

    public int createBorrowRequest(int readerId, String note, List<BorrowRequestItem> items) {
        if (items == null || items.isEmpty()) {
            return 0;
        }
        String insertReqSql = "INSERT INTO Borrow_Request(reader_id, status, requested_at, note) " +
                "OUTPUT INSERTED.request_id " +
                "VALUES (?, 'pending', SYSUTCDATETIME(), ?)";
        String insertItemSql = "INSERT INTO Borrow_Request_Item(request_id, book_id, quantity) VALUES(?,?,?)";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            int requestId;
            try (PreparedStatement ps = conn.prepareStatement(insertReqSql)) {
                ps.setInt(1, readerId);
                ps.setString(2, note);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return 0;
                    }
                    requestId = rs.getInt(1);
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(insertItemSql)) {
                for (BorrowRequestItem item : items) {
                    ps.setInt(1, requestId);
                    ps.setInt(2, item.getBookId());
                    ps.setInt(3, Math.max(1, item.getQuantity()));
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            conn.commit();
            return requestId;
        } catch (Exception e) {
            System.err.println("createBorrowRequest Error: " + e.getMessage());
            e.printStackTrace();
            return 0;
        }
    }

    public List<BorrowRequest> getRequestsByReader(int readerId) {
        List<BorrowRequest> list = new ArrayList<>();
        String sql = "SELECT br.* " +
                "FROM Borrow_Request br " +
                "WHERE br.reader_id = ? " +
                "ORDER BY br.requested_at DESC";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowRequest req = new BorrowRequest();
                    req.setRequestId(rs.getInt("request_id"));
                    req.setReaderId(rs.getInt("reader_id"));
                    req.setStatus(rs.getString("status"));
                    req.setRequestedAt(rs.getTimestamp("requested_at") != null
                            ? rs.getTimestamp("requested_at").toLocalDateTime()
                            : null);
                    req.setNote(rs.getString("note"));
                    req.setDecisionNote(rs.getString("decision_note"));
                    req.setProcessedAt(rs.getTimestamp("processed_at") != null
                            ? rs.getTimestamp("processed_at").toLocalDateTime()
                            : null);
                    list.add(req);
                }
            }
        } catch (Exception e) {
            System.err.println("getRequestsByReader Error: " + e.getMessage());
        }
        return list;
    }

    public List<BorrowRequestItem> getRequestItems(int requestId) {
        List<BorrowRequestItem> items = new ArrayList<>();
        String sql = "SELECT bri.*, b.title AS book_title, b.cover_url AS book_cover_url " +
                "FROM Borrow_Request_Item bri " +
                "JOIN Book b ON bri.book_id = b.book_id " +
                "WHERE bri.request_id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowRequestItem it = new BorrowRequestItem();
                    try {
                        it.setRequestItemId(rs.getInt("request_item_id"));
                    } catch (SQLException ignore) {
                    }
                    it.setRequestId(rs.getInt("request_id"));
                    it.setBookId(rs.getInt("book_id"));
                    it.setQuantity(rs.getInt("quantity"));
                    it.setBookTitle(rs.getString("book_title"));
                    it.setBookCoverUrl(rs.getString("book_cover_url"));
                    items.add(it);
                }
            }
        } catch (Exception e) {
            System.err.println("getRequestItems Error: " + e.getMessage());
        }
        return items;
    }

    public List<BorrowedItemView> getActiveBorrowedItemsByReader(int readerId) {
        List<BorrowedItemView> list = new ArrayList<>();
        String sql = "SELECT bi.borrow_item_id, bi.borrow_id, bi.copy_id, bc.copy_code, " +
                "b.book_id, b.title AS book_title, b.cover_url AS book_cover_url, " +
                "bi.due_date, bi.returned_at, bi.status " +
                "FROM Borrow br " +
                "JOIN Borrow_Item bi ON br.borrow_id = bi.borrow_id " +
                "JOIN Book_Copy bc ON bi.copy_id = bc.copy_id " +
                "JOIN Book b ON bc.book_id = b.book_id " +
                "WHERE br.reader_id = ? AND br.status = 'active' " +
                "ORDER BY bi.due_date ASC";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowedItemView v = new BorrowedItemView();
                    v.setBorrowItemId(rs.getInt("borrow_item_id"));
                    v.setBorrowId(rs.getInt("borrow_id"));
                    v.setCopyId(rs.getInt("copy_id"));
                    v.setCopyCode(rs.getString("copy_code"));
                    v.setBookId(rs.getInt("book_id"));
                    v.setBookTitle(rs.getString("book_title"));
                    v.setBookCoverUrl(rs.getString("book_cover_url"));
                    Timestamp due = rs.getTimestamp("due_date");
                    v.setDueDate(due != null ? due.toLocalDateTime() : null);
                    Timestamp ret = rs.getTimestamp("returned_at");
                    v.setReturnedAt(ret != null ? ret.toLocalDateTime() : null);
                    v.setStatus(rs.getString("status"));
                    list.add(v);
                }
            }
        } catch (Exception e) {
            System.err.println("getActiveBorrowedItemsByReader Error: " + e.getMessage());
        }
        return list;
    }

    public boolean requestReturn(int readerId, int borrowItemId) {
        String sql = "UPDATE bi SET bi.status = 'return_requested' " +
                "FROM Borrow_Item bi " +
                "JOIN Borrow br ON bi.borrow_id = br.borrow_id " +
                "WHERE br.reader_id = ? AND bi.borrow_item_id = ? " +
                "AND (bi.returned_at IS NULL) " +
                "AND (bi.status IS NULL OR bi.status NOT IN ('returned'))";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, borrowItemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("requestReturn Error: " + e.getMessage());
            return false;
        }
    }

    public boolean createExtendRequest(int readerId, int borrowItemId, int extendDays, String note) {
        if (extendDays < 1) {
            extendDays = 1;
        }
        if (extendDays > 30) {
            extendDays = 30;
        }
        String sql = "INSERT INTO Borrow_Extend(borrow_item_id, old_due_date, requested_due_date, status, requested_at, decision_note) " +
                "SELECT bi.borrow_item_id, bi.due_date, DATEADD(day, ?, bi.due_date), 'pending', SYSUTCDATETIME(), ? " +
                "FROM Borrow_Item bi " +
                "JOIN Borrow br ON bi.borrow_id = br.borrow_id " +
                "WHERE br.reader_id = ? AND bi.borrow_item_id = ? " +
                "AND bi.returned_at IS NULL";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, extendDays);
            ps.setString(2, note);
            ps.setInt(3, readerId);
            ps.setInt(4, borrowItemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("createExtendRequest Error: " + e.getMessage());
            return false;
        }
    }

    public List<BorrowExtendView> getExtendRequestsByReader(int readerId) {
        List<BorrowExtendView> list = new ArrayList<>();
        String sql = "SELECT be.extend_id, be.borrow_item_id, be.old_due_date, be.requested_due_date, be.approved_due_date, " +
                "be.status, be.requested_at, be.processed_at, be.decision_note, " +
                "b.title AS book_title, bc.copy_code " +
                "FROM Borrow_Extend be " +
                "JOIN Borrow_Item bi ON be.borrow_item_id = bi.borrow_item_id " +
                "JOIN Borrow br ON bi.borrow_id = br.borrow_id " +
                "JOIN Book_Copy bc ON bi.copy_id = bc.copy_id " +
                "JOIN Book b ON bc.book_id = b.book_id " +
                "WHERE br.reader_id = ? " +
                "ORDER BY be.requested_at DESC";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowExtendView v = new BorrowExtendView();
                    v.setExtendId(rs.getInt("extend_id"));
                    v.setBorrowItemId(rs.getInt("borrow_item_id"));
                    v.setBookTitle(rs.getString("book_title"));
                    v.setCopyCode(rs.getString("copy_code"));
                    Timestamp oldDue = rs.getTimestamp("old_due_date");
                    v.setOldDueDate(oldDue != null ? oldDue.toLocalDateTime() : null);
                    Timestamp reqDue = rs.getTimestamp("requested_due_date");
                    v.setRequestedDueDate(reqDue != null ? reqDue.toLocalDateTime() : null);
                    Timestamp appDue = rs.getTimestamp("approved_due_date");
                    v.setApprovedDueDate(appDue != null ? appDue.toLocalDateTime() : null);
                    v.setStatus(rs.getString("status"));
                    Timestamp reqAt = rs.getTimestamp("requested_at");
                    v.setRequestedAt(reqAt != null ? reqAt.toLocalDateTime() : null);
                    Timestamp procAt = rs.getTimestamp("processed_at");
                    v.setProcessedAt(procAt != null ? procAt.toLocalDateTime() : null);
                    v.setDecisionNote(rs.getString("decision_note"));
                    list.add(v);
                }
            }
        } catch (Exception e) {
            System.err.println("getExtendRequestsByReader Error: " + e.getMessage());
        }
        return list;
    }
}