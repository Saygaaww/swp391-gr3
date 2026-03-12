package dao;

import model.Review;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public List<Review> getByReader(int readerId) {
        List<Review> list = new ArrayList<>();
        String sql = """
            SELECT r.*, b.Title AS book_title, b.CoverURL AS book_cover_url, rd.full_name AS reader_name
            FROM Review r
            JOIN Book b ON r.book_id = b.BookID
            JOIN Reader rd ON r.reader_id = rd.reader_id
            WHERE r.reader_id = ?
            ORDER BY COALESCE(r.updated_at, r.created_at) DESC
        """;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Danh sách review theo sách (?? hi?n th? trên trang chi tiết sách). */
    public List<Review> getByBook(int bookId) {
        List<Review> list = new ArrayList<>();
        String sql = """
            SELECT r.*, rd.full_name AS reader_name
            FROM Review r
            JOIN Reader rd ON r.reader_id = rd.reader_id
            WHERE r.book_id = ?
            ORDER BY COALESCE(r.updated_at, r.created_at) DESC
            """;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapForBook(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Review getByReaderAndBook(int readerId, int bookId) {
        String sql = "SELECT r.*, b.Title AS book_title, b.CoverURL AS book_cover_url FROM Review r JOIN Book b ON r.book_id = b.BookID WHERE r.reader_id = ? AND r.book_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    /** Rating 1-5, validate trong servlet. */
    public boolean upsert(int readerId, int bookId, int rating, String comment) {
        Review existing = getByReaderAndBook(readerId, bookId);
        if (existing != null) {
            String sql = "UPDATE Review SET rating = ?, comment = ?, updated_at = SYSUTCDATETIME() WHERE review_id = ?";
            try (Connection con = DBUtil.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, rating);
                ps.setString(2, comment != null ? comment.trim() : null);
                ps.setInt(3, existing.getReviewId());
                return ps.executeUpdate() > 0;
            } catch (Exception e) { e.printStackTrace(); }
        } else {
            String sql = "INSERT INTO Review(reader_id, book_id, rating, comment) VALUES (?, ?, ?, ?)";
            try (Connection con = DBUtil.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, readerId);
                ps.setInt(2, bookId);
                ps.setInt(3, rating);
                ps.setString(4, comment != null ? comment.trim() : null);
                return ps.executeUpdate() > 0;
            } catch (Exception e) { e.printStackTrace(); }
        }
        return false;
    }

    private Review map(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setReviewId(rs.getInt("review_id"));
        r.setReaderId(rs.getInt("reader_id"));
        r.setBookId(rs.getInt("book_id"));
        r.setRating(rs.getObject("rating") != null ? rs.getInt("rating") : null);
        r.setComment(rs.getString("comment"));
        Timestamp c = rs.getTimestamp("created_at");
        r.setCreatedAt(c != null ? c.toLocalDateTime() : null);
        Timestamp u = rs.getTimestamp("updated_at");
        r.setUpdatedAt(u != null ? u.toLocalDateTime() : null);
        r.setBookTitle(rs.getString("book_title"));
        r.setBookCoverUrl(rs.getString("book_cover_url"));
        try { r.setReaderName(rs.getString("reader_name")); } catch (SQLException ignored) {}
        return r;
    }

    private Review mapForBook(ResultSet rs) throws SQLException {
        Review r = new Review();
        r.setReviewId(rs.getInt("review_id"));
        r.setReaderId(rs.getInt("reader_id"));
        r.setBookId(rs.getInt("book_id"));
        r.setRating(rs.getObject("rating") != null ? rs.getInt("rating") : null);
        r.setComment(rs.getString("comment"));
        Timestamp c = rs.getTimestamp("created_at");
        r.setCreatedAt(c != null ? c.toLocalDateTime() : null);
        Timestamp u = rs.getTimestamp("updated_at");
        r.setUpdatedAt(u != null ? u.toLocalDateTime() : null);
        r.setReaderName(rs.getString("reader_name"));
        return r;
    }
}
