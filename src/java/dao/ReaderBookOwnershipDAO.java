package dao;

import model.ReaderBookOwnership;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReaderBookOwnershipDAO {

    public List<ReaderBookOwnership> getByReader(int readerId) {
        List<ReaderBookOwnership> list = new ArrayList<>();
        String sql = """
            SELECT o.*, b.Title AS book_title, b.CoverURL AS book_cover_url, b.ContentPath AS content_path, b.TotalPages AS book_total_pages, a.AuthorName AS author_name
            FROM Reader_Book_Ownership o
            JOIN Book b ON o.book_id = b.BookID
            LEFT JOIN Author a ON b.AuthorID = a.AuthorID
            WHERE o.reader_id = ? AND (o.status IS NULL OR o.status = 'active')
            ORDER BY o.acquired_at DESC
        """;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Cấp quy??n s? hữu (sau khi thanh toán ?ơn hoặc admin). */
    public boolean grant(int readerId, int bookId, String acquiredVia) {
        String sql = "INSERT INTO Reader_Book_Ownership(reader_id, book_id, acquired_via, status) VALUES (?, ?, ?, 'active')";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            ps.setString(3, acquiredVia != null ? acquiredVia : "order");
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public ReaderBookOwnership getByReaderAndBook(int readerId, int bookId) {
        String sql = """
            SELECT o.*, b.Title AS book_title, b.CoverURL AS book_cover_url, b.ContentPath AS content_path, b.TotalPages AS book_total_pages, a.AuthorName AS author_name
            FROM Reader_Book_Ownership o
            JOIN Book b ON o.book_id = b.BookID
            LEFT JOIN Author a ON b.AuthorID = a.AuthorID
            WHERE o.reader_id = ? AND o.book_id = ? AND (o.status IS NULL OR o.status = 'active')
        """;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    /** Ki?m tra reader ?ã s? hữu sách chưa. */
    public boolean hasOwnership(int readerId, int bookId) {
        String sql = "SELECT 1 FROM Reader_Book_Ownership WHERE reader_id = ? AND book_id = ? AND (status IS NULL OR status = 'active')";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            return ps.executeQuery().next();
        } catch (Exception e) { e.printStackTrace(); }
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
        o.setBookTitle(rs.getString("book_title"));
        o.setBookCoverUrl(rs.getString("book_cover_url"));
        o.setAuthorName(rs.getString("author_name"));
        o.setContentPath(rs.getString("content_path"));
        int tp = rs.getInt("book_total_pages");
        o.setBookTotalPages(rs.wasNull() ? null : tp);
        return o;
    }
}
