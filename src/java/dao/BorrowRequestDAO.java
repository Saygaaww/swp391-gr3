package dao;

import model.BorrowRequest;
import model.BorrowRequestItem;
import util.DBContext;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BorrowRequestDAO {

    private static final String PENDING = "pending";
    private static final String APPROVED = "approved";
    private static final String REJECTED = "rejected";

    /** Check if reader already has a pending request that includes this book. */
    public boolean hasPendingRequestForBook(int readerId, int bookId) {
        String sql = """
            SELECT 1 FROM Borrow_Request br
            JOIN Borrow_Request_Item bri ON br.request_id = bri.request_id
            WHERE br.reader_id = ? AND bri.book_id = ? AND br.status = ?
            """;
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            ps.setNString(3, PENDING);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Create a new borrow request with one item (one book, quantity 1). Returns request_id or -1 on failure. */
    public int createRequest(int readerId, int bookId, int quantity, String note) {
        String insertRequest = """
            INSERT INTO Borrow_Request (reader_id, status, note)
            VALUES (?, ?, ?)
            """;
        String insertItem = "INSERT INTO Borrow_Request_Item (request_id, book_id, quantity) VALUES (?, ?, ?)";
        try (Connection con = DBContext.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps = con.prepareStatement(insertRequest, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, readerId);
                ps.setNString(2, PENDING);
                ps.setNString(3, note);
                ps.executeUpdate();
                ResultSet key = ps.getGeneratedKeys();
                if (!key.next()) {
                    con.rollback();
                    return -1;
                }
                int requestId = key.getInt(1);
                try (PreparedStatement psItem = con.prepareStatement(insertItem)) {
                    psItem.setInt(1, requestId);
                    psItem.setInt(2, bookId);
                    psItem.setInt(3, quantity);
                    psItem.executeUpdate();
                }
                con.commit();
                return requestId;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /** List all pending borrow requests for librarian (with reader info and items). */
    public List<BorrowRequest> listPending() {
        String sql = """
            SELECT br.request_id, br.reader_id, br.status, br.requested_at, br.note,
                   br.processed_by_employee_id, br.processed_at, br.decision_note,
                   r.full_name AS reader_name, r.email AS reader_email
            FROM Borrow_Request br
            JOIN Reader r ON br.reader_id = r.reader_id
            WHERE br.status = ?
            ORDER BY br.requested_at ASC
            """;
        List<BorrowRequest> list = new ArrayList<>();
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setNString(1, PENDING);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BorrowRequest req = mapRequest(rs);
                loadItems(con, req);
                list.add(req);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Load items for a request. */
    private void loadItems(Connection con, BorrowRequest req) throws SQLException {
        String sql = """
            SELECT bri.request_item_id, bri.request_id, bri.book_id, bri.quantity, b.title AS book_title
            FROM Borrow_Request_Item bri
            JOIN Book b ON bri.book_id = b.book_id
            WHERE bri.request_id = ?
            """;
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, req.getRequestId());
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BorrowRequestItem item = new BorrowRequestItem();
                item.setRequestItemId(rs.getInt("request_item_id"));
                item.setRequestId(rs.getInt("request_id"));
                item.setBookId(rs.getInt("book_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setBookTitle(rs.getNString("book_title"));
                req.getItems().add(item);
            }
        }
    }

    /** Get single request by id (for approval/reject). */
    public BorrowRequest getById(int requestId) {
        String sql = """
            SELECT br.request_id, br.reader_id, br.status, br.requested_at, br.note,
                   br.processed_by_employee_id, br.processed_at, br.decision_note,
                   r.full_name AS reader_name, r.email AS reader_email
            FROM Borrow_Request br
            JOIN Reader r ON br.reader_id = r.reader_id
            WHERE br.request_id = ?
            """;
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BorrowRequest req = mapRequest(rs);
                loadItems(con, req);
                return req;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Approve: create Borrow + Borrow_Item(s), update BookCopy status, update request.
     *  borrowFrom: ngày giờ bắt đầu mượn; dueDate: ngày giờ hạn trả.
     *  Nếu không set thì mặc định borrowFrom = now, dueDate = now + 7 ngày.
     */
    public boolean approve(int requestId, int librarianReaderId, String decisionNote,
                          LocalDateTime borrowFrom, LocalDateTime dueDate) {
        BorrowRequest req = getById(requestId);
        if (req == null || !PENDING.equals(req.getStatus())) return false;
        if (borrowFrom == null) borrowFrom = LocalDateTime.now();
        if (dueDate == null) dueDate = borrowFrom.plusDays(7);
        if (!dueDate.isAfter(borrowFrom)) dueDate = borrowFrom.plusDays(7);

        try (Connection con = DBContext.getConnection()) {
            con.setAutoCommit(false);
            try {
                // Create Borrow (set borrow_date để thủ thư có thể chọn từ ngày)
                String insertBorrow = """
                    INSERT INTO Borrow (reader_id, request_id, status, approved_by_employee_id, borrow_date)
                    VALUES (?, ?, 'active', NULL, ?)
                    """;
                int borrowId;
                try (PreparedStatement ps = con.prepareStatement(insertBorrow, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, req.getReaderId());
                    ps.setInt(2, requestId);
                    ps.setObject(3, borrowFrom);
                    ps.executeUpdate();
                    ResultSet key = ps.getGeneratedKeys();
                    if (!key.next()) throw new RuntimeException("No borrow id");
                    borrowId = key.getInt(1);
                }

                // For each request item: get available copies, create Borrow_Item, set copy status = 'borrowed'
                for (BorrowRequestItem item : req.getItems()) {
                    List<Integer> copyIds = getAvailableCopyIds(con, item.getBookId(), item.getQuantity());
                    if (copyIds.size() < item.getQuantity()) {
                        con.rollback();
                        return false; // not enough copies
                    }
                    String insertBorrowItem = "INSERT INTO Borrow_Item (borrow_id, copy_id, due_date, status) VALUES (?, ?, ?, 'borrowed')";
                    for (int i = 0; i < item.getQuantity(); i++) {
                        int copyId = copyIds.get(i);
                        try (PreparedStatement ps = con.prepareStatement(insertBorrowItem)) {
                            ps.setInt(1, borrowId);
                            ps.setInt(2, copyId);
                            ps.setObject(3, dueDate);
                            ps.executeUpdate();
                        }
                        try (PreparedStatement up = con.prepareStatement("UPDATE BookCopy SET status = 'borrowed' WHERE copy_id = ?")) {
                            up.setInt(1, copyId);
                            up.executeUpdate();
                        }
                    }
                }

                // Update Borrow_Request
                String updateRequest = """
                    UPDATE Borrow_Request SET status = ?, processed_at = ?, decision_note = ?
                    WHERE request_id = ?
                    """;
                try (PreparedStatement ps = con.prepareStatement(updateRequest)) {
                    ps.setNString(1, APPROVED);
                    ps.setObject(2, LocalDateTime.now());
                    ps.setNString(3, decisionNote);
                    ps.setInt(4, requestId);
                    ps.executeUpdate();
                }

                con.commit();
                return true;
            } catch (Exception e) {
                con.rollback();
                e.printStackTrace();
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private List<Integer> getAvailableCopyIds(Connection con, int bookId, int limit) throws SQLException {
        String sql = "SELECT TOP (?) copy_id FROM BookCopy WHERE book_id = ? AND status = 'available' ORDER BY copy_id";
        List<Integer> ids = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, bookId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ids.add(rs.getInt("copy_id"));
        }
        return ids;
    }

    /** Reject request. */
    public boolean reject(int requestId, int librarianReaderId, String decisionNote) {
        String sql = """
            UPDATE Borrow_Request SET status = ?, processed_at = ?, decision_note = ?
            WHERE request_id = ? AND status = ?
            """;
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setNString(1, REJECTED);
            ps.setObject(2, LocalDateTime.now());
            ps.setNString(3, decisionNote);
            ps.setInt(4, requestId);
            ps.setNString(5, PENDING);
            return ps.executeUpdate() == 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private BorrowRequest mapRequest(ResultSet rs) throws SQLException {
        BorrowRequest r = new BorrowRequest();
        r.setRequestId(rs.getInt("request_id"));
        r.setReaderId(rs.getInt("reader_id"));
        r.setStatus(rs.getNString("status"));
        Timestamp ts = rs.getTimestamp("requested_at");
        if (ts != null) r.setRequestedAt(ts.toLocalDateTime());
        r.setNote(rs.getNString("note"));
        if (rs.getObject("processed_by_employee_id") != null) r.setProcessedByEmployeeId(rs.getInt("processed_by_employee_id"));
        ts = rs.getTimestamp("processed_at");
        if (ts != null) r.setProcessedAt(ts.toLocalDateTime());
        r.setDecisionNote(rs.getNString("decision_note"));
        r.setReaderName(rs.getNString("reader_name"));
        r.setReaderEmail(rs.getNString("reader_email"));
        return r;
    }
}
