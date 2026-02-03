package dao;

import model.Book;
import model.Author;
import model.Category;
import model.Employee;
import utils.DBConnection;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    
    /**
     * Lấy sách theo ID (có join với Author và Category)
     */
    public Book getBookById(int bookId) throws SQLException {
        String sql = "SELECT b.book_id, b.title, b.summary, b.description, b.cover_url, b.content_path, "
                   + "b.price, b.currency, b.total_pages, b.preview_pages, b.stock, b.status, "
                   + "b.created_at, b.updated_at, "
                   + "b.author_id, b.category_id, b.created_by_employee_id, b.updated_by_employee_id, "
                   + "a.author_name, a.bio, "
                   + "c.category_name, c.description as category_description "
                   + "FROM Book b "
                   + "LEFT JOIN Author a ON b.author_id = a.author_id "
                   + "LEFT JOIN Category c ON b.category_id = c.category_id "
                   + "WHERE b.book_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBook(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Lấy tất cả sách (có phân trang)
     */
    public List<Book> getAllBooks(int offset, int limit) throws SQLException {
        List<Book> books = new ArrayList<>();
        // Sử dụng DISTINCT để tránh duplicate khi JOIN
        String sql = "SELECT DISTINCT b.book_id, b.title, b.summary, b.description, b.cover_url, b.content_path, "
                   + "b.price, b.currency, b.total_pages, b.preview_pages, b.stock, b.status, "
                   + "b.created_at, b.updated_at, "
                   + "b.author_id, b.category_id, b.created_by_employee_id, b.updated_by_employee_id, "
                   + "a.author_name, a.bio, "
                   + "c.category_name, c.description as category_description "
                   + "FROM Book b "
                   + "LEFT JOIN Author a ON b.author_id = a.author_id "
                   + "LEFT JOIN Category c ON b.category_id = c.category_id "
                   + "WHERE b.status IS NULL OR b.status != 'deleted' "
                   + "ORDER BY b.created_at DESC "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }
    
    /**
     * Lấy tất cả sách (không phân trang)
     */
    public List<Book> getAllBooks() throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT DISTINCT b.book_id, b.title, b.summary, b.description, b.cover_url, b.content_path, "
                   + "b.price, b.currency, b.total_pages, b.preview_pages, b.stock, b.status, "
                   + "b.created_at, b.updated_at, "
                   + "b.author_id, b.category_id, b.created_by_employee_id, b.updated_by_employee_id, "
                   + "a.author_name, a.bio, "
                   + "c.category_name, c.description as category_description "
                   + "FROM Book b "
                   + "LEFT JOIN Author a ON b.author_id = a.author_id "
                   + "LEFT JOIN Category c ON b.category_id = c.category_id "
                   + "WHERE b.status IS NULL OR b.status != 'deleted' "
                   + "ORDER BY b.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }
        }
        return books;
    }
    
    /**
     * Lấy sách theo trạng thái
     */
    public List<Book> getBooksByStatus(String status) throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.book_id, b.title, b.summary, b.description, b.cover_url, b.content_path, "
                   + "b.price, b.currency, b.total_pages, b.preview_pages, b.status, "
                   + "b.created_at, b.updated_at, "
                   + "b.author_id, b.category_id, b.created_by_employee_id, b.updated_by_employee_id, "
                   + "a.author_name, a.bio, "
                   + "c.category_name, c.description as category_description "
                   + "FROM Book b "
                   + "LEFT JOIN Author a ON b.author_id = a.author_id "
                   + "LEFT JOIN Category c ON b.category_id = c.category_id "
                   + "WHERE b.status = ? "
                   + "ORDER BY b.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }
    
    /**
     * Tìm kiếm sách theo tiêu đề
     */
    public List<Book> searchBooksByTitle(String title) throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.book_id, b.title, b.summary, b.description, b.cover_url, b.content_path, "
                   + "b.price, b.currency, b.total_pages, b.preview_pages, b.status, "
                   + "b.created_at, b.updated_at, "
                   + "b.author_id, b.category_id, b.created_by_employee_id, b.updated_by_employee_id, "
                   + "a.author_name, a.bio, "
                   + "c.category_name, c.description as category_description "
                   + "FROM Book b "
                   + "LEFT JOIN Author a ON b.author_id = a.author_id "
                   + "LEFT JOIN Category c ON b.category_id = c.category_id "
                   + "WHERE b.title LIKE ? AND b.status != 'deleted' "
                   + "ORDER BY b.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + title + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }
    
    /**
     * Tìm kiếm sách theo tác giả
     */
    public List<Book> searchBooksByAuthor(int authorId) throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.book_id, b.title, b.summary, b.description, b.cover_url, b.content_path, "
                   + "b.price, b.currency, b.total_pages, b.preview_pages, b.status, "
                   + "b.created_at, b.updated_at, "
                   + "b.author_id, b.category_id, b.created_by_employee_id, b.updated_by_employee_id, "
                   + "a.author_name, a.bio, "
                   + "c.category_name, c.description as category_description "
                   + "FROM Book b "
                   + "LEFT JOIN Author a ON b.author_id = a.author_id "
                   + "LEFT JOIN Category c ON b.category_id = c.category_id "
                   + "WHERE b.author_id = ? AND b.status != 'deleted' "
                   + "ORDER BY b.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, authorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }
    
    /**
     * Tìm kiếm sách theo danh mục
     */
    public List<Book> searchBooksByCategory(int categoryId) throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.book_id, b.title, b.summary, b.description, b.cover_url, b.content_path, "
                   + "b.price, b.currency, b.total_pages, b.preview_pages, b.status, "
                   + "b.created_at, b.updated_at, "
                   + "b.author_id, b.category_id, b.created_by_employee_id, b.updated_by_employee_id, "
                   + "a.author_name, a.bio, "
                   + "c.category_name, c.description as category_description "
                   + "FROM Book b "
                   + "LEFT JOIN Author a ON b.author_id = a.author_id "
                   + "LEFT JOIN Category c ON b.category_id = c.category_id "
                   + "WHERE b.category_id = ? AND b.status != 'deleted' "
                   + "ORDER BY b.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }
    
    /**
     * Tìm kiếm sách tổng hợp (theo tiêu đề, tác giả, danh mục)
     */
    public List<Book> searchBooks(String keyword, Integer authorId, Integer categoryId) throws SQLException {
        List<Book> books = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT DISTINCT b.book_id, b.title, b.summary, b.description, b.cover_url, b.content_path, "
            + "b.price, b.currency, b.total_pages, b.preview_pages, b.status, "
            + "b.created_at, b.updated_at, "
            + "b.author_id, b.category_id, b.created_by_employee_id, b.updated_by_employee_id, "
            + "a.author_name, a.bio, "
            + "c.category_name, c.description as category_description "
            + "FROM Book b "
            + "LEFT JOIN Author a ON b.author_id = a.author_id "
            + "LEFT JOIN Category c ON b.category_id = c.category_id "
            + "WHERE (b.status IS NULL OR b.status != 'deleted') "
        );
        
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (b.title LIKE ? OR b.summary LIKE ? OR b.description LIKE ? OR a.author_name LIKE ?) ");
            String searchPattern = "%" + keyword + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        if (authorId != null) {
            sql.append("AND b.author_id = ? ");
            params.add(authorId);
        }
        
        if (categoryId != null) {
            sql.append("AND b.category_id = ? ");
            params.add(categoryId);
        }
        
        sql.append("ORDER BY b.created_at DESC");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }
    
    /**
     * Tạo sách mới
     */
    public Book createBook(Book book) throws SQLException {
        String sql = "INSERT INTO Book (title, summary, description, cover_url, content_path, "
                   + "price, currency, total_pages, preview_pages, status, "
                   + "author_id, category_id, created_by_employee_id, created_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSUTCDATETIME())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getSummary());
            ps.setString(3, book.getDescription());
            ps.setString(4, book.getCoverUrl());
            ps.setString(5, book.getContentPath());
            
            if (book.getPrice() != null) {
                ps.setBigDecimal(6, book.getPrice());
            } else {
                ps.setNull(6, java.sql.Types.DECIMAL);
            }
            
            ps.setString(7, book.getCurrency());
            
            if (book.getTotalPages() != null) {
                ps.setInt(8, book.getTotalPages());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }
            
            if (book.getPreviewPages() != null) {
                ps.setInt(9, book.getPreviewPages());
            } else {
                ps.setNull(9, java.sql.Types.INTEGER);
            }
            
            ps.setString(10, book.getStatus() != null ? book.getStatus() : "active");
            
            // Bỏ approval_status tạm thời (không có trong DB hiện tại)
            
            if (book.getAuthorId() != null) {
                ps.setInt(11, book.getAuthorId());
            } else {
                ps.setNull(11, java.sql.Types.INTEGER);
            }
            
            if (book.getCategoryId() != null) {
                ps.setInt(12, book.getCategoryId());
            } else {
                ps.setNull(12, java.sql.Types.INTEGER);
            }
            
            if (book.getCreatedByEmployeeId() != null) {
                ps.setInt(13, book.getCreatedByEmployeeId());
            } else {
                ps.setNull(13, java.sql.Types.INTEGER);
            }
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int bookId = rs.getInt(1);
                        return getBookById(bookId);
                    }
                }
            }
        }
        return null;
    }
    
    /**
     * Cập nhật thông tin sách
     */
    public boolean updateBook(Book book) throws SQLException {
        String sql = "UPDATE Book SET title = ?, summary = ?, description = ?, cover_url = ?, content_path = ?, "
                   + "price = ?, currency = ?, total_pages = ?, preview_pages = ?, status = ?, "
                   + "author_id = ?, category_id = ?, updated_by_employee_id = ?, updated_at = SYSUTCDATETIME() "
                   + "WHERE book_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getSummary());
            ps.setString(3, book.getDescription());
            ps.setString(4, book.getCoverUrl());
            ps.setString(5, book.getContentPath());
            
            if (book.getPrice() != null) {
                ps.setBigDecimal(6, book.getPrice());
            } else {
                ps.setNull(6, java.sql.Types.DECIMAL);
            }
            
            ps.setString(7, book.getCurrency());
            
            if (book.getTotalPages() != null) {
                ps.setInt(8, book.getTotalPages());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }
            
            if (book.getPreviewPages() != null) {
                ps.setInt(9, book.getPreviewPages());
            } else {
                ps.setNull(9, java.sql.Types.INTEGER);
            }
            
            ps.setString(10, book.getStatus());
            
            if (book.getAuthorId() != null) {
                ps.setInt(11, book.getAuthorId());
            } else {
                ps.setNull(11, java.sql.Types.INTEGER);
            }
            
            if (book.getCategoryId() != null) {
                ps.setInt(12, book.getCategoryId());
            } else {
                ps.setNull(12, java.sql.Types.INTEGER);
            }
            
            if (book.getUpdatedByEmployeeId() != null) {
                ps.setInt(13, book.getUpdatedByEmployeeId());
            } else {
                ps.setNull(13, java.sql.Types.INTEGER);
            }
            
            ps.setInt(14, book.getBookId());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    /**
     * Xóa sách (soft delete - chỉ đổi status thành 'deleted')
     */
    public boolean deleteBook(int bookId) throws SQLException {
        String sql = "UPDATE Book SET status = 'deleted', updated_at = SYSUTCDATETIME() WHERE book_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    /**
     * Đếm tổng số sách
     */
    public int countBooks() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Book WHERE status IS NULL OR status != 'deleted'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Lấy sách miễn phí (có phân trang)
     */
    public List<Book> getFreeBooks(int offset, int limit) throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT DISTINCT b.book_id, b.title, b.summary, b.description, b.cover_url, b.content_path, "
                   + "b.price, b.currency, b.total_pages, b.preview_pages, b.status, "
                   + "b.created_at, b.updated_at, "
                   + "b.author_id, b.category_id, b.created_by_employee_id, b.updated_by_employee_id, "
                   + "a.author_name, a.bio, "
                   + "c.category_name, c.description as category_description "
                   + "FROM Book b "
                   + "LEFT JOIN Author a ON b.author_id = a.author_id "
                   + "LEFT JOIN Category c ON b.category_id = c.category_id "
                   + "WHERE (b.status IS NULL OR b.status != 'deleted') AND (b.price IS NULL OR b.price <= 0) "
                   + "ORDER BY b.created_at DESC "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }

    /**
     * Đếm số sách miễn phí
     */
    public int countFreeBooks() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Book WHERE (status IS NULL OR status != 'deleted') AND (price IS NULL OR price <= 0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Tìm kiếm sách miễn phí
     */
    public List<Book> searchFreeBooks(String keyword, Integer authorId, Integer categoryId) throws SQLException {
        List<Book> books = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT b.book_id, b.title, b.summary, b.description, b.cover_url, b.content_path, "
            + "b.price, b.currency, b.total_pages, b.preview_pages, b.status, "
            + "b.created_at, b.updated_at, "
            + "b.author_id, b.category_id, b.created_by_employee_id, b.updated_by_employee_id, "
            + "a.author_name, a.bio, "
            + "c.category_name, c.description as category_description "
            + "FROM Book b "
            + "LEFT JOIN Author a ON b.author_id = a.author_id "
            + "LEFT JOIN Category c ON b.category_id = c.category_id "
            + "WHERE b.status != 'deleted' AND (b.price IS NULL OR b.price <= 0) "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (b.title LIKE ? OR b.summary LIKE ? OR b.description LIKE ? OR a.author_name LIKE ?) ");
            String searchPattern = "%" + keyword + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (authorId != null) {
            sql.append("AND b.author_id = ? ");
            params.add(authorId);
        }

        if (categoryId != null) {
            sql.append("AND b.category_id = ? ");
            params.add(categoryId);
        }

        sql.append("ORDER BY b.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }
    
    /**
     * Đếm số sách theo trạng thái
     */
    public int countBooksByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Book WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Map ResultSet thành Book object
     */
    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setBookId(rs.getInt("book_id"));
        book.setTitle(rs.getString("title"));
        book.setSummary(rs.getString("summary"));
        book.setDescription(rs.getString("description"));
        book.setCoverUrl(rs.getString("cover_url"));
        book.setContentPath(rs.getString("content_path"));
        
        BigDecimal price = rs.getBigDecimal("price");
        if (price != null) {
            book.setPrice(price);
        }
        
        book.setCurrency(rs.getString("currency"));
        
        int totalPages = rs.getInt("total_pages");
        if (!rs.wasNull()) {
            book.setTotalPages(totalPages);
        }
        
        int previewPages = rs.getInt("preview_pages");
        if (!rs.wasNull()) {
            book.setPreviewPages(previewPages);
        }
        
        // Stock field (có thể không tồn tại trong DB cũ)
        try {
            int stock = rs.getInt("stock");
            if (!rs.wasNull()) {
                book.setStock(stock);
            }
        } catch (SQLException e) {
            // Column might not exist yet, ignore - set default to null
            book.setStock(null);
        }
        
        book.setStatus(rs.getString("status"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            book.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            book.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        int authorId = rs.getInt("author_id");
        if (!rs.wasNull()) {
            book.setAuthorId(authorId);
            
            // Set Author object if available
            String authorName = rs.getString("author_name");
            if (authorName != null) {
                Author author = new Author();
                author.setAuthorId(authorId);
                author.setAuthorName(authorName);
                author.setBio(rs.getString("bio"));
                book.setAuthor(author);
            }
        }
        
        int categoryId = rs.getInt("category_id");
        if (!rs.wasNull()) {
            book.setCategoryId(categoryId);
            
            // Set Category object if available
            String categoryName = rs.getString("category_name");
            if (categoryName != null) {
                Category category = new Category();
                category.setCategoryId(categoryId);
                category.setCategoryName(categoryName);
                category.setDescription(rs.getString("category_description"));
                book.setCategory(category);
            }
        }
        
        int createdByEmployeeId = rs.getInt("created_by_employee_id");
        if (!rs.wasNull()) {
            book.setCreatedByEmployeeId(createdByEmployeeId);
        }
        
        int updatedByEmployeeId = rs.getInt("updated_by_employee_id");
        if (!rs.wasNull()) {
            book.setUpdatedByEmployeeId(updatedByEmployeeId);
        }
        
        // Approval fields
        try {
            String approvalStatus = rs.getString("approval_status");
            if (approvalStatus != null) {
                book.setApprovalStatus(approvalStatus);
            }
        } catch (SQLException e) {
            // Column might not exist yet, ignore
        }
        
        try {
            int approvedByEmployeeId = rs.getInt("approved_by_employee_id");
            if (!rs.wasNull()) {
                book.setApprovedByEmployeeId(approvedByEmployeeId);
            }
        } catch (SQLException e) {
            // Column might not exist yet, ignore
        }
        
        try {
            String approvalNotes = rs.getString("approval_notes");
            if (approvalNotes != null) {
                book.setApprovalNotes(approvalNotes);
            }
        } catch (SQLException e) {
            // Column might not exist yet, ignore
        }
        
        try {
            Timestamp approvedAt = rs.getTimestamp("approved_at");
            if (approvedAt != null) {
                book.setApprovedAt(approvedAt.toLocalDateTime());
            }
        } catch (SQLException e) {
            // Column might not exist yet, ignore
        }
        
        return book;
    }
    
    /**
     * Lấy sách theo approval status (có phân trang)
     */
    public List<Book> getBooksByApprovalStatus(String approvalStatus, int offset, int pageSize) throws SQLException {
        List<Book> books = new ArrayList<>();
        // TẠM THỜI BỎ: Method này không dùng được vì DB chưa có approval_status
        // TODO: Khi nào chạy migration script thì uncomment lại
        String sql = "SELECT DISTINCT b.book_id, b.title, b.summary, b.description, b.cover_url, b.content_path, "
                   + "b.price, b.currency, b.total_pages, b.preview_pages, b.status, "
                   + "b.created_at, b.updated_at, "
                   + "b.author_id, b.category_id, b.created_by_employee_id, b.updated_by_employee_id, "
                   + "a.author_name, a.bio, "
                   + "c.category_name, c.description as category_description, "
                   + "e.full_name as created_by_name "
                   + "FROM Book b "
                   + "LEFT JOIN Author a ON b.author_id = a.author_id "
                   + "LEFT JOIN Category c ON b.category_id = c.category_id "
                   + "LEFT JOIN Employee e ON b.created_by_employee_id = e.employee_id "
                   + "WHERE (b.status IS NULL OR b.status != 'deleted') "
                   + "ORDER BY b.created_at DESC "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }
    
    /**
     * Đếm số sách theo approval status
     */
    public int countBooksByApprovalStatus(String approvalStatus) throws SQLException {
        // TẠM THỜI BỎ: Method này không dùng được vì DB chưa có approval_status
        // TODO: Khi nào chạy migration script thì uncomment lại
        String sql = "SELECT COUNT(*) FROM Book WHERE (status IS NULL OR status != 'deleted')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Cập nhật approval status của sách
     */
    public boolean updateApprovalStatus(int bookId, String approvalStatus, int adminEmployeeId, String notes) throws SQLException {
        // TẠM THỜI BỎ: Method này không dùng được vì DB chưa có approval_status
        // TODO: Khi nào chạy migration script thì uncomment lại
        // Tạm thời chỉ update updated_at
        String sql = "UPDATE Book SET updated_at = SYSUTCDATETIME() WHERE book_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    /**
     * Lấy sách của một seller cụ thể (theo created_by_employee_id)
     */
    public List<Book> getBooksBySeller(int sellerEmployeeId, int offset, int pageSize) throws SQLException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT DISTINCT b.book_id, b.title, b.summary, b.description, b.cover_url, b.content_path, "
                   + "b.price, b.currency, b.total_pages, b.preview_pages, b.status, "
                   + "b.created_at, b.updated_at, "
                   + "b.author_id, b.category_id, b.created_by_employee_id, b.updated_by_employee_id, "
                   + "a.author_name, a.bio, "
                   + "c.category_name, c.description as category_description "
                   + "FROM Book b "
                   + "LEFT JOIN Author a ON b.author_id = a.author_id "
                   + "LEFT JOIN Category c ON b.category_id = c.category_id "
                   + "WHERE b.created_by_employee_id = ? AND (b.status IS NULL OR b.status != 'deleted') "
                   + "ORDER BY b.created_at DESC "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerEmployeeId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }
        }
        return books;
    }
    
    /**
     * Đếm số sách của một seller
     */
    public int countBooksBySeller(int sellerEmployeeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Book WHERE created_by_employee_id = ? AND (status IS NULL OR status != 'deleted')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerEmployeeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
}
