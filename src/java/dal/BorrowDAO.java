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
    public boolean approveRequest(int requestId, int employeeId, String note, java.time.LocalDate startDate, java.time.LocalDate dueDate) {
        // 1. Get request and items
        BorrowRequest req = getRequestById(requestId);
        if (req == null) return false;
        
        List<BorrowRequestItem> reqItems = getRequestItems(requestId);
        if (reqItems == null || reqItems.isEmpty()) return false;
        
        String updateReqSql = "UPDATE Borrow_Request SET status = 'approved', processed_by_employee_id = ?, processed_at = SYSUTCDATETIME(), decision_note = ? WHERE request_id = ?";
        String insertBorrowSql = "INSERT INTO Borrow(reader_id, request_id, borrow_date, status, created_at, approved_by_employee_id) " +
                                 "OUTPUT INSERTED.borrow_id VALUES (?, ?, ?, 'borrowed', SYSUTCDATETIME(), ?)";
        String getCopiesSql = "SELECT TOP (?) copy_id FROM BookCopy WHERE book_id = ? AND status = 'available'";
        String insertCopySql = "INSERT INTO BookCopy(book_id, copy_code, status, created_at) OUTPUT INSERTED.copy_id VALUES (?, ?, 'available', SYSUTCDATETIME())";
        String updateCopySql = "UPDATE BookCopy SET status = 'borrowed' WHERE copy_id = ?";
        String insertBorrowItemSql = "INSERT INTO Borrow_Item(borrow_id, copy_id, due_date, status) VALUES (?, ?, ?, 'borrowed')";
        String reduceStockSql = "UPDATE Book SET stock_quantity = stock_quantity - ? WHERE BookID = ? AND stock_quantity >= ?";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            
            // a. Update Borrow_Request
            try (PreparedStatement psUpdateReq = conn.prepareStatement(updateReqSql)) {
                psUpdateReq.setInt(1, employeeId);
                psUpdateReq.setString(2, note);
                psUpdateReq.setInt(3, requestId);
                psUpdateReq.executeUpdate();
            }
            
            // b. Insert Borrow
            int borrowId = 0;
            try (PreparedStatement psBorrow = conn.prepareStatement(insertBorrowSql)) {
                psBorrow.setInt(1, req.getReaderId());
                psBorrow.setInt(2, requestId);
                psBorrow.setDate(3, java.sql.Date.valueOf(startDate));
                psBorrow.setInt(4, employeeId);
                try (ResultSet rs = psBorrow.executeQuery()) {
                    if (rs.next()) borrowId = rs.getInt("borrow_id");
                }
            }
            
            // c. Assign copies
            for (BorrowRequestItem item : reqItems) {
                int neededQuantity = item.getQuantity();
                List<Integer> assignedCopyIds = new ArrayList<>();
                try (PreparedStatement psGetCopies = conn.prepareStatement(getCopiesSql)) {
                    psGetCopies.setInt(1, neededQuantity);
                    psGetCopies.setInt(2, item.getBookId());
                    try (ResultSet rs = psGetCopies.executeQuery()) {
                        while (rs.next()) assignedCopyIds.add(rs.getInt("copy_id"));
                    }
                }
                
                // Create missing dummy copies if needed
                for (int i = 0; i < neededQuantity - assignedCopyIds.size(); i++) {
                    try (PreparedStatement psCopy = conn.prepareStatement(insertCopySql)) {
                        psCopy.setInt(1, item.getBookId());
                        psCopy.setString(2, "COPY-" + item.getBookId() + "-" + System.currentTimeMillis() + "-" + i);
                        try (ResultSet rsCopy = psCopy.executeQuery()) {
                            if (rsCopy.next()) assignedCopyIds.add(rsCopy.getInt("copy_id"));
                        }
                    }
                }
                
                // Link copies to item and update statuses
                for (int copyId : assignedCopyIds) {
                    try (PreparedStatement psUpdateCopy = conn.prepareStatement(updateCopySql)) {
                        psUpdateCopy.setInt(1, copyId);
                        psUpdateCopy.executeUpdate();
                    }
                    try (PreparedStatement psInsertBItem = conn.prepareStatement(insertBorrowItemSql)) {
                        psInsertBItem.setInt(1, borrowId);
                        psInsertBItem.setInt(2, copyId);
                        psInsertBItem.setDate(3, java.sql.Date.valueOf(dueDate));
                        psInsertBItem.executeUpdate();
                    }
                }
                
                // Reduce stock
                try (PreparedStatement psReduceStock = conn.prepareStatement(reduceStockSql)) {
                    psReduceStock.setInt(1, neededQuantity);
                    psReduceStock.setInt(2, item.getBookId());
                    psReduceStock.setInt(3, neededQuantity);
                    int updatedRaw = psReduceStock.executeUpdate();
                    if (updatedRaw == 0) {
                        conn.rollback();
                        return false; // Not enough stock!
                    }
                }
            }
            conn.commit();
            return true;
        } catch (Exception e) {
            System.err.println("approveRequest Error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
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

        if (rs.getDate("expected_start_date") != null) {
            req.setExpectedStartDate(rs.getDate("expected_start_date").toLocalDate());
        }
        if (rs.getDate("expected_return_date") != null) {
            req.setExpectedReturnDate(rs.getDate("expected_return_date").toLocalDate());
        }

        return req;
    }

    // =========================
    // Reader-side methods
    // =========================

    public int createBorrowRequest(int readerId, String note, java.time.LocalDate expectedStartDate, java.time.LocalDate expectedReturnDate, List<BorrowRequestItem> items) {
        if (items == null || items.isEmpty()) {
            return 0;
        }
        String insertReqSql = "INSERT INTO Borrow_Request(reader_id, status, requested_at, note, expected_start_date, expected_return_date) " +
                "OUTPUT INSERTED.request_id " +
                "VALUES (?, 'pending', SYSUTCDATETIME(), ?, ?, ?)";
        String insertItemSql = "INSERT INTO Borrow_Request_Item(request_id, book_id, quantity) VALUES(?,?,?)";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            int requestId;
            try (PreparedStatement ps = conn.prepareStatement(insertReqSql)) {
                ps.setInt(1, readerId);
                ps.setString(2, note);
                if (expectedStartDate != null) {
                    ps.setDate(3, java.sql.Date.valueOf(expectedStartDate));
                } else {
                    ps.setNull(3, java.sql.Types.DATE);
                }
                if (expectedReturnDate != null) {
                    ps.setDate(4, java.sql.Date.valueOf(expectedReturnDate));
                } else {
                    ps.setNull(4, java.sql.Types.DATE);
                }
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
        String sql = "SELECT bri.*, b.Title AS book_title, b.CoverURL AS book_cover_url " +
                "FROM Borrow_Request_Item bri " +
                "JOIN Book b ON bri.book_id = b.BookID " +
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
                "JOIN BookCopy bc ON bi.copy_id = bc.copy_id " +
                "JOIN Book b ON bc.book_id = b.BookID " +
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
                "JOIN BookCopy bc ON bi.copy_id = bc.copy_id " +
                "JOIN Book b ON bc.book_id = b.BookID " +
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
    public List<BorrowedItemView> getReturnRequests() {
        List<BorrowedItemView> list = new ArrayList<>();
        String sql = "SELECT bi.borrow_item_id, bi.borrow_id, r.reader_id, r.first_name + ' ' + r.last_name AS reader_name, r.email AS reader_email, " +
                "bi.copy_id, bc.copy_code, b.BookID AS book_id, b.Title AS book_title, b.CoverURL AS book_cover_url, " +
                "bi.due_date, bi.returned_at, bi.status " +
                "FROM Borrow_Item bi " +
                "JOIN Borrow br ON bi.borrow_id = br.borrow_id " +
                "JOIN Reader r ON br.reader_id = r.reader_id " +
                "JOIN BookCopy bc ON bi.copy_id = bc.copy_id " +
                "JOIN Book b ON bc.book_id = b.BookID " +
                "WHERE bi.status = 'return_requested' " +
                "ORDER BY bi.due_date ASC";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BorrowedItemView v = new BorrowedItemView();
                    v.setBorrowItemId(rs.getInt("borrow_item_id"));
                    v.setBorrowId(rs.getInt("borrow_id"));
                    v.setReaderId(rs.getInt("reader_id"));
                    v.setReaderName(rs.getString("reader_name"));
                    v.setReaderEmail(rs.getString("reader_email"));
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
            System.err.println("getReturnRequests Error: " + e.getMessage());
        }
        return list;
    }

    public boolean processReturn(int borrowItemId) {
        String updateItemSql = "UPDATE Borrow_Item SET status = 'returned', returned_at = SYSUTCDATETIME() WHERE borrow_item_id = ? AND status = 'return_requested'";
        String getCopyIdSql = "SELECT copy_id FROM Borrow_Item WHERE borrow_item_id = ?";
        String updateCopySql = "UPDATE BookCopy SET status = 'available' WHERE copy_id = ?";
        String getBookIdSql = "SELECT book_id FROM BookCopy WHERE copy_id = ?";
        String updateBookSql = "UPDATE Book SET stock_quantity = stock_quantity + 1 WHERE BookID = ?";
        String getBorrowIdSql = "SELECT borrow_id FROM Borrow_Item WHERE borrow_item_id = ?";
        String updateBorrowSql = "UPDATE Borrow SET status = 'returned' WHERE borrow_id = ? AND NOT EXISTS (SELECT 1 FROM Borrow_Item WHERE borrow_id = ? AND status != 'returned')";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            
            // 1. Update Borrow_Item
            int updated = 0;
            try (PreparedStatement ps = conn.prepareStatement(updateItemSql)) {
                ps.setInt(1, borrowItemId);
                updated = ps.executeUpdate();
            }
            if (updated == 0) {
                conn.rollback();
                return false;
            }

            // 2. Get copyId
            int copyId = 0;
            try (PreparedStatement ps = conn.prepareStatement(getCopyIdSql)) {
                ps.setInt(1, borrowItemId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) copyId = rs.getInt("copy_id");
                }
            }

            // 3. Update Book_Copy
            if (copyId > 0) {
                try (PreparedStatement ps = conn.prepareStatement(updateCopySql)) {
                    ps.setInt(1, copyId);
                    ps.executeUpdate();
                }

                // 4. Update Book stock
                int bookId = 0;
                try (PreparedStatement ps = conn.prepareStatement(getBookIdSql)) {
                    ps.setInt(1, copyId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) bookId = rs.getInt("book_id");
                    }
                }
                if (bookId > 0) {
                    try (PreparedStatement ps = conn.prepareStatement(updateBookSql)) {
                        ps.setInt(1, bookId);
                        ps.executeUpdate();
                    }
                }
            }

            // 5. Update Borrow status if all returned
            int borrowId = 0;
            try (PreparedStatement ps = conn.prepareStatement(getBorrowIdSql)) {
                ps.setInt(1, borrowItemId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) borrowId = rs.getInt("borrow_id");
                }
            }
            if (borrowId > 0) {
                try (PreparedStatement ps = conn.prepareStatement(updateBorrowSql)) {
                    ps.setInt(1, borrowId);
                    ps.setInt(2, borrowId);
                    ps.executeUpdate();
                }
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            System.err.println("processReturn Error: " + e.getMessage());
            return false;
        }
    }
}