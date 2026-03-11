package dao;

import model.Book;
import util.DBContext;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

    /** List active books for browsing (with author/category names). */
    public List<Book> listActive() {
        String sql = """
            SELECT b.book_id, b.title, b.summary, b.description, b.cover_url, b.content_path,
                   b.price, b.currency, b.total_pages, b.preview_pages, b.status,
                   b.created_at, b.updated_at, b.author_id, b.category_id,
                   a.author_name, c.category_name
            FROM Book b
            LEFT JOIN Author a ON b.author_id = a.author_id
            LEFT JOIN Category c ON b.category_id = c.category_id
            WHERE b.status = 'active'
            ORDER BY b.created_at DESC
            """;
        List<Book> list = new ArrayList<>();
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapBook(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Get book by id with author/category names. */
    public Book getById(int bookId) {
        String sql = """
            SELECT b.book_id, b.title, b.summary, b.description, b.cover_url, b.content_path,
                   b.price, b.currency, b.total_pages, b.preview_pages, b.status,
                   b.created_at, b.updated_at, b.author_id, b.category_id,
                   a.author_name, c.category_name
            FROM Book b
            LEFT JOIN Author a ON b.author_id = a.author_id
            LEFT JOIN Category c ON b.category_id = c.category_id
            WHERE b.book_id = ?
            """;
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapBook(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Count available copies for a book (status = 'available'). */
    public int countAvailableCopies(int bookId) {
        String sql = "SELECT COUNT(*) FROM BookCopy WHERE book_id = ? AND status = 'available'";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Book mapBook(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setBookId(rs.getInt("book_id"));
        b.setTitle(rs.getNString("title"));
        b.setSummary(rs.getNString("summary"));
        b.setDescription(rs.getNString("description"));
        b.setCoverUrl(rs.getNString("cover_url"));
        b.setContentPath(rs.getNString("content_path"));
        if (rs.getObject("price") != null) b.setPrice(rs.getBigDecimal("price"));
        b.setCurrency(rs.getNString("currency"));
        if (rs.getObject("total_pages") != null) b.setTotalPages(rs.getInt("total_pages"));
        if (rs.getObject("preview_pages") != null) b.setPreviewPages(rs.getInt("preview_pages"));
        b.setStatus(rs.getNString("status"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) b.setCreatedAt(ts.toLocalDateTime());
        ts = rs.getTimestamp("updated_at");
        if (ts != null) b.setUpdatedAt(ts.toLocalDateTime());
        if (rs.getObject("author_id") != null) b.setAuthorId(rs.getInt("author_id"));
        if (rs.getObject("category_id") != null) b.setCategoryId(rs.getInt("category_id"));
        b.setAuthorName(rs.getNString("author_name"));
        b.setCategoryName(rs.getNString("category_name"));
        return b;
    }
}
