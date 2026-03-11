package dao;

import model.Book;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO sách: danh sách (active / cho quản lý), tìm kiếm, lọc category, getById, tạo/cập nhật, tồn kho, sách cập nhật gần đây (dashboard).
 */
public class BookDAO {

    /**
     * Lấy tất cả sách đang active (status='active'), JOIN Author, Category; ORDER BY created_at DESC.
     */
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = """
            SELECT b.*, a.author_name, c.category_name
            FROM Book b
            LEFT JOIN Author a ON b.author_id = a.author_id
            LEFT JOIN Category c ON b.category_id = c.category_id
            WHERE b.status = 'active'
            ORDER BY b.created_at DESC
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                books.add(mapBook(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return books;
    }

    /**
     * Lấy tất cả sách (kể cả inactive) cho trang quản lý (admin/seller); ORDER BY created_at DESC.
     */
    public List<Book> getAllBooksForManagement() {
        List<Book> books = new ArrayList<>();
        String sql = """
            SELECT b.*, a.author_name, c.category_name
            FROM Book b
            LEFT JOIN Author a ON b.author_id = a.author_id
            LEFT JOIN Category c ON b.category_id = c.category_id
            ORDER BY b.created_at DESC
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                books.add(mapBook(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return books;
    }

    /**
     * Lấy một sách theo book_id (JOIN Author, Category).
     */
    public Book getBookById(int bookId) {
        String sql = """
            SELECT b.*, a.author_name, c.category_name
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

    /**
     * Tìm sách active: title, author_name hoặc summary LIKE %keyword%.
     */
    public List<Book> searchBooks(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = """
            SELECT b.*, a.author_name, c.category_name
            FROM Book b
            LEFT JOIN Author a ON b.author_id = a.author_id
            LEFT JOIN Category c ON b.category_id = c.category_id
            WHERE b.status = 'active'
              AND (b.title LIKE ? OR a.author_name LIKE ? OR b.summary LIKE ?)
            ORDER BY b.created_at DESC
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                books.add(mapBook(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return books;
    }

    /**
     * Lấy sách active theo category_id.
     */
    public List<Book> getBooksByCategory(int categoryId) {
        List<Book> books = new ArrayList<>();
        String sql = """
            SELECT b.*, a.author_name, c.category_name
            FROM Book b
            LEFT JOIN Author a ON b.author_id = a.author_id
            LEFT JOIN Category c ON b.category_id = c.category_id
            WHERE b.status = 'active' AND b.category_id = ?
            ORDER BY b.created_at DESC
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                books.add(mapBook(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return books;
    }

    /**
     * Thêm sách mới (INSERT Book). Trả về book_id hoặc -1.
     */
    public int createBook(Book book) {
        String sql = """
            INSERT INTO Book(title, summary, description, cover_url, content_path, 
                           price, currency, total_pages, preview_pages, status, stock_quantity,
                           author_id, category_id, created_by_employee_id)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, book.getTitle());
            ps.setString(2, book.getSummary());
            ps.setString(3, book.getDescription());
            ps.setString(4, book.getCoverUrl());
            ps.setString(5, book.getContentPath());
            ps.setBigDecimal(6, book.getPrice());
            ps.setString(7, book.getCurrency());
            ps.setInt(8, book.getTotalPages());
            ps.setInt(9, book.getPreviewPages());
            ps.setString(10, book.getStatus());
            ps.setInt(11, book.getStockQuantity());
            ps.setInt(12, book.getAuthorId());
            ps.setInt(13, book.getCategoryId());
            if (book.getCreatedByEmployeeId() != null) {
                ps.setInt(14, book.getCreatedByEmployeeId());
            } else {
                ps.setNull(14, Types.INTEGER);
            }

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Cập nhật thông tin sách (updated_at = SYSUTCDATETIME).
     */
    public boolean updateBook(Book book) {
        String sql = """
            UPDATE Book
            SET title = ?, summary = ?, description = ?, cover_url = ?,
                price = ?, currency = ?, total_pages = ?, preview_pages = ?,
                status = ?, stock_quantity = ?, author_id = ?, category_id = ?,
                updated_by_employee_id = ?, updated_at = SYSUTCDATETIME()
            WHERE book_id = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, book.getTitle());
            ps.setString(2, book.getSummary());
            ps.setString(3, book.getDescription());
            ps.setString(4, book.getCoverUrl());
            ps.setBigDecimal(5, book.getPrice());
            ps.setString(6, book.getCurrency());
            ps.setInt(7, book.getTotalPages());
            ps.setInt(8, book.getPreviewPages());
            ps.setString(9, book.getStatus());
            ps.setInt(10, book.getStockQuantity());
            ps.setInt(11, book.getAuthorId());
            ps.setInt(12, book.getCategoryId());
            if (book.getUpdatedByEmployeeId() != null) {
                ps.setInt(13, book.getUpdatedByEmployeeId());
            } else {
                ps.setNull(13, Types.INTEGER);
            }
            ps.setInt(14, book.getBookId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Ánh xạ ResultSet → Book (kèm author_name, category_name; created_at, updated_at nếu có). */
    private Book mapBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        
        book.setBookId(rs.getInt("book_id"));
        book.setTitle(rs.getString("title"));
        book.setSummary(rs.getString("summary"));
        book.setDescription(rs.getString("description"));
        book.setCoverUrl(rs.getString("cover_url"));
        book.setContentPath(rs.getString("content_path"));
        book.setPrice(rs.getBigDecimal("price"));
        book.setCurrency(rs.getString("currency"));
        book.setTotalPages(rs.getInt("total_pages"));
        book.setPreviewPages(rs.getInt("preview_pages"));
        book.setStatus(rs.getString("status"));
        book.setAuthorId(rs.getInt("author_id"));
        book.setCategoryId(rs.getInt("category_id"));
        book.setAuthorName(rs.getString("author_name"));
        book.setCategoryName(rs.getString("category_name"));
        if (hasColumn(rs, "stock_quantity")) {
            book.setStockQuantity(rs.getInt("stock_quantity"));
        }
        if (hasColumn(rs, "updated_at")) {
            Timestamp t = rs.getTimestamp("updated_at");
            book.setUpdatedAt(t != null ? t.toLocalDateTime() : null);
        }
        if (hasColumn(rs, "created_at")) {
            Timestamp t = rs.getTimestamp("created_at");
            book.setCreatedAt(t != null ? t.toLocalDateTime() : null);
        }
        return book;
    }

    /** Sách cập nhật gần đây (catalog changes) – chỉ đọc, dùng cho dashboard. */
    public List<Book> getRecentlyUpdatedBooks(int limit) {
        List<Book> list = new ArrayList<>();
        String sql = """
            SELECT TOP (?) b.book_id, b.title, b.status, b.updated_at, b.created_at,
                   a.author_name, c.category_name
            FROM Book b
            LEFT JOIN Author a ON b.author_id = a.author_id
            LEFT JOIN Category c ON b.category_id = c.category_id
            ORDER BY COALESCE(b.updated_at, b.created_at) DESC
            """;
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapBook(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private boolean hasColumn(ResultSet rs, String column) {
        try {
            rs.findColumn(column);
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    /** So luong ton kho kha dung (ban). */
    public int getAvailableStock(int bookId) {
        String sql = "SELECT stock_quantity FROM Book WHERE book_id = ? AND status = 'active'";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("stock_quantity");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Giam so luong ton kho sau khi dat hang thanh cong. Tra false neu khong du hang. */
    public boolean reduceStock(int bookId, int quantity) {
        String sql = "UPDATE Book SET stock_quantity = stock_quantity - ? WHERE book_id = ? AND stock_quantity >= ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, bookId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Hoàn tồn kho khi đơn bị cancel/refund: cộng lại quantity vào stock_quantity.
     */
    public boolean restoreStock(int bookId, int quantity) {
        String sql = "UPDATE Book SET stock_quantity = stock_quantity + ? WHERE book_id = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
