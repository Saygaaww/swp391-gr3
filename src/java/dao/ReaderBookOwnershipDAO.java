package dao;

import model.ReaderBookOwnership;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO quyền sở hữu sách của reader: danh sách sách đã sở hữu, cấp quyền (sau
 * mua), kiểm tra đã sở hữu (chặn mua lại).
 */
public class ReaderBookOwnershipDAO {

    /**
     * Lấy tất cả sách reader đã sở hữu (status active/null), JOIN Book, Author;
     * ORDER BY acquired_at DESC. Dùng cho My Library, Bookmarks.
     */
    public List<ReaderBookOwnership> getByReader(int readerId) {
        List<ReaderBookOwnership> list = new ArrayList<>();
        String sql = """
            SELECT o.*, b.title AS book_title, b.cover_url AS book_cover_url, b.content_path, b.total_pages AS book_total_pages, a.author_name
            FROM Reader_Book_Ownership o
            JOIN Book b ON o.book_id = b.book_id
            LEFT JOIN Author a ON b.author_id = a.author_id
            WHERE o.reader_id = ? AND (o.status IS NULL OR o.status = 'active')
            ORDER BY o.acquired_at DESC
        """;
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Cấp quyền sở hữu (sau khi thanh toán đơn hoặc admin).
     *
     * @param orderId nullable; khi cấp từ đơn hàng thì truyền để sau này
     * cancel/refund thu hồi đúng theo đơn.
     */
    public boolean grant(int readerId, int bookId, String acquiredVia, Integer orderId) {
        String sql = "INSERT INTO Reader_Book_Ownership(reader_id, book_id, acquired_via, status, order_id) VALUES (?, ?, ?, 'active', ?)";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            ps.setString(3, acquiredVia != null ? acquiredVia : "order");
            if (orderId != null) {
                ps.setInt(4, orderId);
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Thu hồi quyền sở hữu của tất cả sách trong đơn (khi seller
     * cancel/refund). Chỉ cập nhật status = 'revoked' cho các bản ghi có
     * order_id = ?.
     */
    public int revokeByOrderId(int orderId) {
        String sql = "UPDATE Reader_Book_Ownership SET status = 'revoked' WHERE order_id = ? AND (status IS NULL OR status = 'active')";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy một bản ghi sở hữu (reader + book), kèm thông tin sách (title,
     * cover_url, content_path, author_name). Dùng cho trang đọc sách.
     */
    public ReaderBookOwnership getByReaderAndBook(int readerId, int bookId) {
        String sql = """
            SELECT o.*, b.title AS book_title, b.cover_url AS book_cover_url, b.content_path, b.total_pages AS book_total_pages, a.author_name
            FROM Reader_Book_Ownership o
            JOIN Book b ON o.book_id = b.book_id
            LEFT JOIN Author a ON b.author_id = a.author_id
            WHERE o.reader_id = ? AND o.book_id = ? AND (o.status IS NULL OR o.status = 'active')
        """;
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return map(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Kiểm tra reader đã sở hữu sách chưa.
     */
    public boolean hasOwnership(int readerId, int bookId) {
        String sql = "SELECT 1 FROM Reader_Book_Ownership WHERE reader_id = ? AND book_id = ? AND (status IS NULL OR status = 'active')";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            return ps.executeQuery().next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private ReaderBookOwnership map(ResultSet rs) throws SQLException {
        ReaderBookOwnership o = new ReaderBookOwnership();
        o.setOwnershipId(rs.getInt("ownership_id"));
        o.setReaderId(rs.getInt("reader_id"));
        o.setBookId(rs.getInt("book_id"));
        Timestamp t = rs.getTimestamp("acquired_at");
        o.setAcquiredAt(t != null ? t.toLocalDateTime() : null);
        o.setAcquiredVia(rs.getString("acquired_via"));
        o.setStatus(rs.getString("status"));
        try {
            int oid = rs.getInt("order_id");
            o.setOrderId(rs.wasNull() ? null : oid);
        } catch (SQLException ignored) {
            /* order_id có thể chưa có trước khi chạy migration */ }
        o.setBookTitle(rs.getString("book_title"));
        o.setBookCoverUrl(rs.getString("book_cover_url"));
        o.setAuthorName(rs.getString("author_name"));
        o.setContentPath(rs.getString("content_path"));
        int tp = rs.getInt("book_total_pages");
        o.setBookTotalPages(rs.wasNull() ? null : tp);
        return o;
    }
}
