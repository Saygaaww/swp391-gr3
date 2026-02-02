package dal;

import model.Book;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO class xử lý các thao tác với bảng Book
 * @author Member E - Dũng
 */
public class BookDAO extends DBContext {
    
    /**
     * Lấy tất cả sách (JOIN với Author, Category)
     * @return List<Book>
     */
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, " +
                     "c.category_name, " +
                     "a.author_name " +
                     "FROM Book b " +
                     "LEFT JOIN Category c ON b.category_id = c.category_id " +
                     "LEFT JOIN Author a ON b.author_id = a.author_id " +
                     "ORDER BY b.created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Book book = extractBookFromResultSet(rs);
                books.add(book);
            }
            
            System.out.println("✅ BookDAO: Lấy được " + books.size() + " sách");
            
        } catch (Exception e) {
            System.err.println("❌ Error in getAllBooks: " + e.getMessage());
            e.printStackTrace();
        }
        
        return books;
    }
    
    /**
     * Lấy sách theo ID
     * @param bookId
     * @return Book object hoặc null
     */
    public Book getBookById(int bookId) {
        String sql = "SELECT b.*, " +
                     "c.category_name, " +
                     "a.author_name " +
                     "FROM Book b " +
                     "LEFT JOIN Category c ON b.category_id = c.category_id " +
                     "LEFT JOIN Author a ON b.author_id = a.author_id " +
                     "WHERE b.book_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractBookFromResultSet(rs);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in getBookById: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Thêm sách mới
     * @param book
     * @return true nếu thành công
     */
    public boolean addBook(Book book) {
        String sql = "INSERT INTO Book (title, summary, description, cover_url, " +
                     "content_path, price, currency, total_pages, preview_pages, " +
                     "status, author_id, category_id, created_by_employee_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
            
            // Kiểm tra null cho author_id
            if (book.getAuthorId() > 0) {
                ps.setInt(11, book.getAuthorId());
            } else {
                ps.setNull(11, Types.INTEGER);
            }
            
            // Kiểm tra null cho category_id
            if (book.getCategoryId() > 0) {
                ps.setInt(12, book.getCategoryId());
            } else {
                ps.setNull(12, Types.INTEGER);
            }
            
            // Kiểm tra null cho created_by_employee_id
            if (book.getCreatedByEmployeeId() != null && book.getCreatedByEmployeeId() > 0) {
                ps.setInt(13, book.getCreatedByEmployeeId());
            } else {
                ps.setNull(13, Types.INTEGER);
            }
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("✅ BookDAO: Thêm sách thành công - " + book.getTitle());
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("❌ Error in addBook: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Cập nhật thông tin sách
     * @param book
     * @return true nếu thành công
     */
    public boolean updateBook(Book book) {
        String sql = "UPDATE Book SET " +
                     "title = ?, summary = ?, description = ?, cover_url = ?, " +
                     "content_path = ?, price = ?, currency = ?, total_pages = ?, " +
                     "preview_pages = ?, status = ?, author_id = ?, category_id = ?, " +
                     "updated_at = SYSUTCDATETIME(), updated_by_employee_id = ? " +
                     "WHERE book_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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
            
            if (book.getAuthorId() > 0) {
                ps.setInt(11, book.getAuthorId());
            } else {
                ps.setNull(11, Types.INTEGER);
            }
            
            if (book.getCategoryId() > 0) {
                ps.setInt(12, book.getCategoryId());
            } else {
                ps.setNull(12, Types.INTEGER);
            }
            
            if (book.getUpdatedByEmployeeId() != null && book.getUpdatedByEmployeeId() > 0) {
                ps.setInt(13, book.getUpdatedByEmployeeId());
            } else {
                ps.setNull(13, Types.INTEGER);
            }
            
            ps.setInt(14, book.getBookId());
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("✅ BookDAO: Cập nhật sách thành công - ID: " + book.getBookId());
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("❌ Error in updateBook: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Xóa sách
     * @param bookId
     * @return true nếu thành công
     */
    public boolean deleteBook(int bookId) {
        String sql = "DELETE FROM Book WHERE book_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookId);
            int rowsAffected = ps.executeUpdate();
            System.out.println("✅ BookDAO: Xóa sách thành công - ID: " + bookId);
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("❌ Error in deleteBook: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Tìm kiếm sách theo tên hoặc tác giả
     * @param keyword
     * @return List<Book>
     */
    public List<Book> searchBooks(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name, a.author_name " +
                     "FROM Book b " +
                     "LEFT JOIN Category c ON b.category_id = c.category_id " +
                     "LEFT JOIN Author a ON b.author_id = a.author_id " +
                     "WHERE b.title LIKE ? OR a.author_name LIKE ? " +
                     "ORDER BY b.created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
            
            System.out.println("✅ BookDAO: Tìm được " + books.size() + " sách với keyword: " + keyword);
            
        } catch (Exception e) {
            System.err.println("❌ Error in searchBooks: " + e.getMessage());
            e.printStackTrace();
        }
        
        return books;
    }
    
    /**
     * Đếm tổng số sách
     * @return số lượng sách
     */
    public int getTotalBooks() {
        String sql = "SELECT COUNT(*) FROM Book";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in getTotalBooks: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Lấy sách theo trang (PHÂN TRANG)
     * 
     * GIẢI THÍCH CHO THẦY:
     * - page: Số trang hiện tại (1, 2, 3, ...)
     * - pageSize: Số sách mỗi trang (ví dụ: 5)
     * - offset: Số sách cần bỏ qua = (page - 1) * pageSize
     * 
     * Ví dụ: page=2, pageSize=5
     * → offset = (2-1) * 5 = 5
     * → Bỏ qua 5 sách đầu, lấy 5 sách tiếp theo (sách 6-10)
     * 
     * @param page Trang hiện tại (bắt đầu từ 1)
     * @param pageSize Số sách mỗi trang
     * @return List<Book> sách của trang đó
     */
    public List<Book> getBooksByPage(int page, int pageSize) {
        List<Book> books = new ArrayList<>();
        
        // Tính offset: số sách cần bỏ qua
        int offset = (page - 1) * pageSize;
        
        // SQL Server dùng OFFSET...FETCH để phân trang
        String sql = "SELECT b.*, " +
                     "c.category_name, " +
                     "a.author_name " +
                     "FROM Book b " +
                     "LEFT JOIN Category c ON b.category_id = c.category_id " +
                     "LEFT JOIN Author a ON b.author_id = a.author_id " +
                     "ORDER BY b.created_at DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, offset);    // Số dòng bỏ qua
            ps.setInt(2, pageSize);  // Số dòng lấy
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
            
            System.out.println("✅ BookDAO: Trang " + page + " - Lấy được " + books.size() + " sách");
            
        } catch (Exception e) {
            System.err.println("❌ Error in getBooksByPage: " + e.getMessage());
            e.printStackTrace();
        }
        
        return books;
    }
    
    /**
     * Tìm kiếm sách có phân trang
     */
    public List<Book> searchBooksByPage(String keyword, int page, int pageSize) {
        List<Book> books = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        
        String sql = "SELECT b.*, c.category_name, a.author_name " +
                     "FROM Book b " +
                     "LEFT JOIN Category c ON b.category_id = c.category_id " +
                     "LEFT JOIN Author a ON b.author_id = a.author_id " +
                     "WHERE b.title LIKE ? OR a.author_name LIKE ? " +
                     "ORDER BY b.created_at DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setInt(3, offset);
            ps.setInt(4, pageSize);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in searchBooksByPage: " + e.getMessage());
            e.printStackTrace();
        }
        
        return books;
    }
    
    /**
     * Đếm tổng số sách theo keyword
     */
    public int countBooksByKeyword(String keyword) {
        String sql = "SELECT COUNT(*) FROM Book b " +
                     "LEFT JOIN Author a ON b.author_id = a.author_id " +
                     "WHERE b.title LIKE ? OR a.author_name LIKE ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in countBooksByKeyword: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Helper method: Tạo object Book từ ResultSet
     */
    private Book extractBookFromResultSet(ResultSet rs) throws SQLException {
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
        book.setCreatedAt(rs.getTimestamp("created_at"));
        book.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Foreign keys
        book.setAuthorId(rs.getInt("author_id"));
        book.setCategoryId(rs.getInt("category_id"));
        
        // Kiểm tra null cho created_by_employee_id
        int createdBy = rs.getInt("created_by_employee_id");
        if (!rs.wasNull()) {
            book.setCreatedByEmployeeId(createdBy);
        }
        
        // Kiểm tra null cho updated_by_employee_id
        int updatedBy = rs.getInt("updated_by_employee_id");
        if (!rs.wasNull()) {
            book.setUpdatedByEmployeeId(updatedBy);
        }
        
        // JOIN data
        book.setCategoryName(rs.getString("category_name"));
        book.setAuthorName(rs.getString("author_name"));
        
        return book;
    }
}