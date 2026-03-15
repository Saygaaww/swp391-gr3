package dal;

import model.Reservation;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO extends DBContext {

    public boolean createReservation(int readerId, int bookId) {
        // Basic hold: pending with expiry 48h from now (can be adjusted)
        String sql = "INSERT INTO Reservation(reader_id, book_id, status, queued_at, expires_at) "
                + "VALUES(?, ?, 'pending', SYSUTCDATETIME(), DATEADD(hour, 48, SYSUTCDATETIME()))";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("createReservation Error: " + e.getMessage());
            return false;
        }
    }

    public boolean cancelReservation(int readerId, int reservationId) {
        String sql = "UPDATE Reservation SET status = 'cancelled', cancelled_at = SYSUTCDATETIME() "
                + "WHERE reservation_id = ? AND reader_id = ? AND status IN ('pending','active')";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reservationId);
            ps.setInt(2, readerId);
            return ps.executeUpdate() > 0;
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
}
