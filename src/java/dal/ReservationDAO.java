package dal;

import model.AdminReservationView;
import model.Reservation;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO extends DBContext {

    public static final String STATUS_ACTIVE = "ACTIVE";
    public static final String STATUS_FULFILLED = "FULFILLED";
    public static final String STATUS_CANCELLED = "CANCELLED";
    public static final String STATUS_EXPIRED = "EXPIRED";
    private static final int DEFAULT_HOLD_HOURS = 24;

    private int fetchScopeIdentity(Connection conn) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("SELECT CAST(SCOPE_IDENTITY() AS INT)")) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public int getCurrentBookStock(int bookId) {
        String sql = "SELECT stock_quantity FROM Book WHERE BookID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("stock_quantity");
                }
            }
        } catch (Exception e) {
            System.err.println("getCurrentBookStock Error: " + e.getMessage());
        }
        return -1;
    }

    public boolean createReservation(int readerId, int bookId) {
        String checkStockSql = "SELECT stock_quantity FROM Book WHERE BookID = ?";
        String checkDuplicateSql = "SELECT 1 FROM Reservation WHERE reader_id = ? AND book_id = ? AND UPPER(status) IN ('ACTIVE','PENDING')";
        String insertSql = "INSERT INTO Reservation(reader_id, book_id, status, queued_at, expires_at) "
                + "VALUES(?, ?, 'ACTIVE', SYSUTCDATETIME(), NULL)";
        try (Connection conn = getConnection()) {
            // Reservation is only needed when there is no available stock.
            try (PreparedStatement ps = conn.prepareStatement(checkStockSql)) {
                ps.setInt(1, bookId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next() || rs.getInt("stock_quantity") > 0) {
                        return false;
                    }
                }
            }

            // Avoid duplicate waiting slots for the same reader and book.
            try (PreparedStatement ps = conn.prepareStatement(checkDuplicateSql)) {
                ps.setInt(1, readerId);
                ps.setInt(2, bookId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return false;
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, readerId);
                ps.setInt(2, bookId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            System.err.println("createReservation Error: " + e.getMessage());
            return false;
        }
    }

    public boolean cancelReservation(int readerId, int reservationId) {
        String findBookSql = "SELECT book_id FROM Reservation WHERE reservation_id = ? AND reader_id = ?";
        String sql = "UPDATE Reservation SET status = 'CANCELLED', cancelled_at = SYSUTCDATETIME() "
                + "WHERE reservation_id = ? AND reader_id = ? AND UPPER(status) IN ('ACTIVE','PENDING')";
        try (Connection conn = getConnection()) {
            int bookId = 0;
            try (PreparedStatement ps = conn.prepareStatement(findBookSql)) {
                ps.setInt(1, reservationId);
                ps.setInt(2, readerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        bookId = rs.getInt("book_id");
                    }
                }
            }

            int updated;
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, reservationId);
                ps.setInt(2, readerId);
                updated = ps.executeUpdate();
            }
            if (updated > 0 && bookId > 0) {
                activateNextPendingReservation(bookId);
                return true;
            }
            return false;
        } catch (Exception e) {
            System.err.println("cancelReservation Error: " + e.getMessage());
            return false;
        }
    }

    public List<Reservation> getReservationsByReader(int readerId) {
        List<Reservation> list = new ArrayList<>();
        String sql = """
                     SELECT r.reservation_id, r.reader_id, r.book_id, r.status, r.queued_at, r.expires_at, 
                                     r.fulfilled_at, r.cancelled_at, b.Title AS book_title, b.CoverURL AS book_cover_url  
                                     FROM Reservation r 
                                     JOIN Book b ON r.book_id = b.BookID 
                                     WHERE r.reader_id = ?
                                     ORDER BY r.queued_at DESC""";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setReservationId(rs.getInt("reservation_id"));
                    r.setReaderId(rs.getInt("reader_id"));
                    r.setBookId(rs.getInt("book_id"));
                    r.setStatus(rs.getString("status"));
                    r.setBookTitle(rs.getString("book_title"));
                    r.setBookCoverUrl(rs.getString("book_cover_url"));
                    Timestamp queued = rs.getTimestamp("queued_at");
                    r.setQueuedAt(queued != null ? queued.toLocalDateTime() : null);
                    Timestamp exp = rs.getTimestamp("expires_at");
                    r.setExpiresAt(exp != null ? exp.toLocalDateTime() : null);
                    Timestamp fulfilled = rs.getTimestamp("fulfilled_at");
                    r.setFulfilledAt(fulfilled != null ? fulfilled.toLocalDateTime() : null);
                    Timestamp cancelled = rs.getTimestamp("cancelled_at");
                    r.setCancelledAt(cancelled != null ? cancelled.toLocalDateTime() : null);
                    list.add(r);
                }
            }
        } catch (Exception e) {
            System.err.println("getReservationsByReader Error: " + e.getMessage());
        }
        return list;
    }

    public void expireDueReservations(int bookId) {
        String expireSql = "UPDATE Reservation SET status = 'EXPIRED' "
                + "WHERE book_id = ? AND UPPER(status) = 'ACTIVE' "
                + "AND expires_at IS NOT NULL AND expires_at < SYSUTCDATETIME()";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(expireSql)) {
            ps.setInt(1, bookId);
            ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("expireDueReservations Error: " + e.getMessage());
        }
    }

    public void expireDueReservationsByReader(int readerId) {
        String expireSql = "UPDATE Reservation SET status = 'EXPIRED' "
                + "WHERE reader_id = ? AND UPPER(status) = 'ACTIVE' "
                + "AND expires_at IS NOT NULL AND expires_at < SYSUTCDATETIME()";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(expireSql)) {
            ps.setInt(1, readerId);
            ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("expireDueReservationsByReader Error: " + e.getMessage());
        }
    }

    public Integer getReadyReservationReader(int bookId) {
        String sql = "SELECT TOP 1 reader_id FROM Reservation "
                + "WHERE book_id = ? AND UPPER(status) IN ('ACTIVE','PENDING') "
                + "AND expires_at IS NOT NULL AND expires_at >= SYSUTCDATETIME() "
                + "ORDER BY queued_at ASC, reservation_id ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("reader_id");
                }
            }
        } catch (Exception e) {
            System.err.println("getReadyReservationReader Error: " + e.getMessage());
        }
        return null;
    }

    public boolean markReadyReservationFulfilled(int readerId, int bookId) {
        String sql = """
                UPDATE Reservation
                SET status = 'FULFILLED',
                    fulfilled_at = SYSUTCDATETIME()
                WHERE reservation_id = (
                    SELECT TOP 1 reservation_id
                    FROM Reservation
                    WHERE reader_id = ?
                      AND book_id = ?
                      AND UPPER(status) = 'ACTIVE'
                      AND expires_at IS NOT NULL
                      AND expires_at >= SYSUTCDATETIME()
                    ORDER BY queued_at ASC, reservation_id ASC
                )""";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("markReadyReservationFulfilled Error: " + e.getMessage());
            return false;
        }
    }

    public boolean activateNextPendingReservation(int bookId) {
        String existingReadySql = "SELECT TOP 1 1 FROM Reservation "
                + "WHERE book_id = ? AND UPPER(status) IN ('ACTIVE','PENDING') "
                + "AND expires_at IS NOT NULL AND expires_at >= SYSUTCDATETIME()";
        String pickSql = "SELECT TOP 1 reservation_id, reader_id FROM Reservation "
                + "WHERE book_id = ? AND UPPER(status) IN ('ACTIVE','PENDING') "
                + "AND expires_at IS NULL "
                + "ORDER BY queued_at ASC, reservation_id ASC";
        String activateSql = "UPDATE Reservation "
                + "SET status = 'ACTIVE', expires_at = DATEADD(hour, ?, SYSUTCDATETIME()) "
                + "WHERE reservation_id = ? AND UPPER(status) IN ('ACTIVE','PENDING') AND expires_at IS NULL";
        String notifySql = "INSERT INTO Notification(reader_id, title, message, type) VALUES (?, ?, ?, 'reservation')";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            expireDueReservationsTx(conn, bookId);

            // If someone is already holding a ready slot, keep fairness.
            try (PreparedStatement ps = conn.prepareStatement(existingReadySql)) {
                ps.setInt(1, bookId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        conn.rollback();
                        return false;
                    }
                }
            }

            int stock = getCurrentBookStock(bookId);
            if (stock <= 0) {
                conn.rollback();
                return false;
            }

            int reservationId = 0;
            int readerId = 0;
            try (PreparedStatement ps = conn.prepareStatement(pickSql)) {
                ps.setInt(1, bookId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        reservationId = rs.getInt("reservation_id");
                        readerId = rs.getInt("reader_id");
                    }
                }
            }
            if (reservationId <= 0 || readerId <= 0) {
                conn.rollback();
                return false;
            }

            int updated = 0;
            try (PreparedStatement ps = conn.prepareStatement(activateSql)) {
                ps.setInt(1, DEFAULT_HOLD_HOURS);
                ps.setInt(2, reservationId);
                updated = ps.executeUpdate();
            }
            if (updated <= 0) {
                conn.rollback();
                return false;
            }

            try (PreparedStatement ps = conn.prepareStatement(notifySql)) {
                ps.setInt(1, readerId);
                ps.setString(2, "Sach da den luot muon");
                ps.setString(3, "Sach ban dat truoc da co san. Ban co 24 gio de tao yeu cau muon.");
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            System.err.println("activateNextPendingReservation Error: " + e.getMessage());
            return false;
        }
    }

    private void expireDueReservationsTx(Connection conn, int bookId) throws SQLException {
        String expireSql = "UPDATE Reservation SET status = 'EXPIRED' "
                + "WHERE book_id = ? AND UPPER(status) = 'ACTIVE' "
                + "AND expires_at IS NOT NULL AND expires_at < SYSUTCDATETIME()";
        try (PreparedStatement ps = conn.prepareStatement(expireSql)) {
            ps.setInt(1, bookId);
            ps.executeUpdate();
        }
    }

    public void expireAllDueReservations() {
        String sql = "UPDATE Reservation SET status = 'EXPIRED' "
                + "WHERE UPPER(status) = 'ACTIVE' "
                + "AND expires_at IS NOT NULL AND expires_at < SYSUTCDATETIME()";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("expireAllDueReservations Error: " + e.getMessage());
        }
    }

    public int countBooksNeedingAssignment() {
        String sql = """
                SELECT COUNT(*)
                FROM (
                    SELECT r.book_id
                    FROM Reservation r
                    JOIN Book b ON b.BookID = r.book_id
                    WHERE UPPER(r.status) = 'ACTIVE'
                      AND r.expires_at IS NULL
                      AND b.stock_quantity > 0
                      AND NOT EXISTS (
                          SELECT 1
                          FROM Reservation rr
                          WHERE rr.book_id = r.book_id
                            AND UPPER(rr.status) = 'ACTIVE'
                            AND rr.expires_at IS NOT NULL
                            AND rr.expires_at >= SYSUTCDATETIME()
                      )
                    GROUP BY r.book_id
                ) t
                """;
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("countBooksNeedingAssignment Error: " + e.getMessage());
        }
        return 0;
    }

    public List<AdminReservationView> getReservationsForAdmin(String filterStatus, Integer bookId) {
        List<AdminReservationView> list = new ArrayList<>();
        String normalized = (filterStatus == null || filterStatus.isBlank()) ? "ALL" : filterStatus.toUpperCase();
        String sql = """
                WITH reservation_base AS (
                    SELECT
                        r.reservation_id,
                        r.reader_id,
                        rd.full_name AS reader_name,
                        r.book_id,
                        b.Title AS book_title,
                        r.queued_at,
                        r.expires_at,
                        CASE
                            WHEN UPPER(r.status) = 'ACTIVE' AND r.expires_at IS NULL THEN 'WAITING'
                            WHEN UPPER(r.status) = 'PENDING' THEN 'WAITING'
                            WHEN UPPER(r.status) = 'ACTIVE' AND r.expires_at IS NOT NULL
                                 AND r.expires_at >= SYSUTCDATETIME() THEN 'READY'
                            WHEN UPPER(r.status) = 'ACTIVE' AND r.expires_at IS NOT NULL
                                 AND r.expires_at < SYSUTCDATETIME() THEN 'EXPIRED'
                            WHEN UPPER(r.status) = 'FULFILLED' THEN 'FULFILLED'
                            WHEN UPPER(r.status) = 'CANCELLED' THEN 'CANCELLED'
                            WHEN UPPER(r.status) = 'EXPIRED' THEN 'EXPIRED'
                            ELSE UPPER(r.status)
                        END AS normalized_status
                    FROM Reservation r
                    JOIN Book b ON r.book_id = b.BookID
                    JOIN Reader rd ON r.reader_id = rd.reader_id
                )
                SELECT
                    rb.reservation_id,
                    rb.reader_id,
                    rb.reader_name,
                    rb.book_id,
                    rb.book_title,
                    rb.normalized_status,
                    rb.queued_at,
                    rb.expires_at,
                    CASE
                        WHEN rb.normalized_status IN ('WAITING', 'READY')
                        THEN ROW_NUMBER() OVER (PARTITION BY rb.book_id ORDER BY rb.queued_at ASC, rb.reservation_id ASC)
                        ELSE NULL
                    END AS queue_position
                FROM reservation_base rb
                WHERE (? = 'ALL' OR rb.normalized_status = ?)
                  AND (? IS NULL OR rb.book_id = ?)
                ORDER BY rb.book_title ASC, rb.queued_at ASC, rb.reservation_id ASC
                """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, normalized);
            ps.setString(2, normalized);
            if (bookId == null) {
                ps.setNull(3, java.sql.Types.INTEGER);
                ps.setNull(4, java.sql.Types.INTEGER);
            } else {
                ps.setInt(3, bookId);
                ps.setInt(4, bookId);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AdminReservationView v = new AdminReservationView();
                    v.setReservationId(rs.getInt("reservation_id"));
                    v.setReaderId(rs.getInt("reader_id"));
                    v.setReaderName(rs.getString("reader_name"));
                    v.setBookId(rs.getInt("book_id"));
                    v.setBookTitle(rs.getString("book_title"));
                    v.setStatus(rs.getString("normalized_status"));
                    int qp = rs.getInt("queue_position");
                    v.setQueuePosition(rs.wasNull() ? null : qp);
                    Timestamp queued = rs.getTimestamp("queued_at");
                    v.setQueuedAt(queued != null ? queued.toLocalDateTime() : null);
                    Timestamp expires = rs.getTimestamp("expires_at");
                    v.setExpiresAt(expires != null ? expires.toLocalDateTime() : null);
                    list.add(v);
                }
            }
        } catch (Exception e) {
            System.err.println("getReservationsForAdmin Error: " + e.getMessage());
        }
        return list;
    }

    public boolean skipReservation(int reservationId) {
        String getBookSql = "SELECT book_id FROM Reservation WHERE reservation_id = ?";
        String expireSql = "UPDATE Reservation SET status = 'EXPIRED' WHERE reservation_id = ? AND UPPER(status) = 'ACTIVE'";
        try (Connection conn = getConnection()) {
            int bookId = 0;
            try (PreparedStatement ps = conn.prepareStatement(getBookSql)) {
                ps.setInt(1, reservationId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        bookId = rs.getInt("book_id");
                    }
                }
            }
            int updated;
            try (PreparedStatement ps = conn.prepareStatement(expireSql)) {
                ps.setInt(1, reservationId);
                updated = ps.executeUpdate();
            }
            if (updated > 0 && bookId > 0) {
                activateNextPendingReservation(bookId);
                return true;
            }
        } catch (Exception e) {
            System.err.println("skipReservation Error: " + e.getMessage());
        }
        return false;
    }

    public boolean confirmBorrowFromReady(int reservationId, int employeeId) {
        String getReadySql = """
                SELECT r.reservation_id, r.reader_id, r.book_id
                FROM Reservation r
                WHERE r.reservation_id = ?
                  AND UPPER(r.status) = 'ACTIVE'
                  AND r.expires_at IS NOT NULL
                  AND r.expires_at >= SYSUTCDATETIME()
                """;
        String topReadySql = """
                SELECT TOP 1 reservation_id
                FROM Reservation
                WHERE book_id = ?
                  AND UPPER(status) IN ('ACTIVE', 'PENDING')
                  AND expires_at IS NOT NULL
                  AND expires_at >= SYSUTCDATETIME()
                ORDER BY queued_at ASC, reservation_id ASC
                """;
        String reduceStockSql = "UPDATE Book SET stock_quantity = stock_quantity - 1 WHERE BookID = ? AND stock_quantity >= 1";
        String getCopySql = "SELECT TOP 1 copy_id FROM BookCopy WHERE book_id = ? AND status = 'available' ORDER BY copy_id ASC";
        String updateCopySql = "UPDATE BookCopy SET status = 'borrowed' WHERE copy_id = ?";
        String insertReqSql = "INSERT INTO Borrow_Request(reader_id, status, requested_at, note, processed_by_employee_id, processed_at, decision_note) "
                + "VALUES(?, 'approved', SYSUTCDATETIME(), ?, ?, SYSUTCDATETIME(), ?)";
        String insertBorrowSql = "INSERT INTO Borrow(reader_id, request_id, borrow_date, status, created_at, approved_by_employee_id) "
                + "VALUES (?, ?, SYSUTCDATETIME(), 'borrowed', SYSUTCDATETIME(), ?)";
        String insertBorrowItemSql = "INSERT INTO Borrow_Item(borrow_id, copy_id, due_date, status) "
                + "VALUES (?, ?, DATEADD(day, 7, SYSUTCDATETIME()), 'borrowed')";
        String fulfillSql = "UPDATE Reservation SET status = 'FULFILLED', fulfilled_at = SYSUTCDATETIME() "
                + "WHERE reservation_id = ?";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            int readerId = 0;
            int bookId = 0;
            try (PreparedStatement ps = conn.prepareStatement(getReadySql)) {
                ps.setInt(1, reservationId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        readerId = rs.getInt("reader_id");
                        bookId = rs.getInt("book_id");
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(topReadySql)) {
                ps.setInt(1, bookId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next() || rs.getInt("reservation_id") != reservationId) {
                        conn.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(reduceStockSql)) {
                ps.setInt(1, bookId);
                if (ps.executeUpdate() <= 0) {
                    conn.rollback();
                    return false;
                }
            }

            int copyId = 0;
            try (PreparedStatement ps = conn.prepareStatement(getCopySql)) {
                ps.setInt(1, bookId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        copyId = rs.getInt("copy_id");
                    }
                }
            }
            if (copyId <= 0) {
                conn.rollback();
                return false;
            }

            try (PreparedStatement ps = conn.prepareStatement(updateCopySql)) {
                ps.setInt(1, copyId);
                ps.executeUpdate();
            }

            int requestId = 0;
            try (PreparedStatement ps = conn.prepareStatement(insertReqSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, readerId);
                ps.setString(2, "Created from reservation queue #" + reservationId);
                ps.setInt(3, employeeId);
                ps.setString(4, "Queue confirmed by librarian");
                int affected = ps.executeUpdate();
                if (affected <= 0) {
                    conn.rollback();
                    return false;
                }
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        requestId = keys.getInt(1);
                    } else {
                        requestId = fetchScopeIdentity(conn);
                    }
                }
            }
            if (requestId <= 0) {
                conn.rollback();
                return false;
            }

            int borrowId = 0;
            try (PreparedStatement ps = conn.prepareStatement(insertBorrowSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, readerId);
                ps.setInt(2, requestId);
                ps.setInt(3, employeeId);
                int affected = ps.executeUpdate();
                if (affected <= 0) {
                    conn.rollback();
                    return false;
                }
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        borrowId = keys.getInt(1);
                    } else {
                        borrowId = fetchScopeIdentity(conn);
                    }
                }
            }
            if (borrowId <= 0) {
                conn.rollback();
                return false;
            }

            try (PreparedStatement ps = conn.prepareStatement(insertBorrowItemSql)) {
                ps.setInt(1, borrowId);
                ps.setInt(2, copyId);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(fulfillSql)) {
                ps.setInt(1, reservationId);
                ps.executeUpdate();
            }

            conn.commit();
            activateNextPendingReservation(bookId);
            return true;
        } catch (Exception e) {
            System.err.println("confirmBorrowFromReady Error: " + e.getMessage());
            return false;
        }
    }
}
