package dao;

import model.Bookmark;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookmarkDAO {

    public List<Bookmark> getByReader(int readerId) {
        List<Bookmark> list = new ArrayList<>();
        String sql = """
            SELECT bm.*, bk.title AS book_title, bk.cover_url AS book_cover_url, bk.total_pages AS book_total_pages
            FROM Bookmark bm
            JOIN Book bk ON bm.book_id = bk.book_id
            WHERE bm.reader_id = ?
            ORDER BY bm.book_id, bm.page_number
        """;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Bookmark getById(int bookmarkId, int readerId) {
        String sql = """
            SELECT bm.*, bk.title AS book_title, bk.cover_url AS book_cover_url, bk.total_pages AS book_total_pages
            FROM Bookmark bm
            JOIN Book bk ON bm.book_id = bk.book_id
            WHERE bm.bookmark_id = ? AND bm.reader_id = ?
        """;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookmarkId);
            ps.setInt(2, readerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean create(int readerId, int bookId, int pageNumber, String note) {
        if (pageNumber < 1) return false;
        String sql = "INSERT INTO Bookmark(reader_id, book_id, page_number, note) VALUES (?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            ps.setInt(3, pageNumber);
            ps.setString(4, note != null && !note.isBlank() ? note.trim() : null);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(int bookmarkId, int readerId, int pageNumber, String note) {
        if (pageNumber < 1) return false;
        String sql = "UPDATE Bookmark SET page_number = ?, note = ? WHERE bookmark_id = ? AND reader_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, pageNumber);
            ps.setString(2, note != null && !note.isBlank() ? note.trim() : null);
            ps.setInt(3, bookmarkId);
            ps.setInt(4, readerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int bookmarkId, int readerId) {
        String sql = "DELETE FROM Bookmark WHERE bookmark_id = ? AND reader_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookmarkId);
            ps.setInt(2, readerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    private Bookmark map(ResultSet rs) throws SQLException {
        Bookmark b = new Bookmark();
        b.setBookmarkId(rs.getInt("bookmark_id"));
        b.setReaderId(rs.getInt("reader_id"));
        b.setBookId(rs.getInt("book_id"));
        b.setPageNumber(rs.getInt("page_number"));
        b.setNote(rs.getString("note"));
        Timestamp t = rs.getTimestamp("created_at");
        b.setCreatedAt(t != null ? t.toLocalDateTime() : null);
        b.setBookTitle(rs.getString("book_title"));
        b.setBookCoverUrl(rs.getString("book_cover_url"));
        int tp = rs.getInt("book_total_pages");
        b.setBookTotalPages(rs.wasNull() ? null : tp);
        return b;
    }
}
