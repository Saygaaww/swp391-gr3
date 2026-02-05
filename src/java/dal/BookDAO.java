package dal;

import model.Book;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO extends DBContext {

    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, "
                + "c.category_name, "
                + "a.author_name "
                + "FROM Book b "
                + "LEFT JOIN Category c ON b.category_id = c.category_id "
                + "LEFT JOIN Author a ON b.author_id = a.author_id "
                + "ORDER BY b.created_at DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Book book = extractBookFromResultSet(rs);
                books.add(book);
            }

            System.out.println("BookDAO: Lấy được " + books.size() + " sách");

        } catch (Exception e) {
            System.err.println("Error in getAllBooks: " + e.getMessage());
            e.printStackTrace();
        }

        return books;
    }

    public Book getBookById(int bookId) {
        String sql = "SELECT b.*, "
                + "c.category_name, "
                + "a.author_name "
                + "FROM Book b "
                + "LEFT JOIN Category c ON b.category_id = c.category_id "
                + "LEFT JOIN Author a ON b.author_id = a.author_id "
                + "WHERE b.book_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractBookFromResultSet(rs);
            }

        } catch (Exception e) {
            System.err.println("Error in getBookById: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    public boolean addBook(Book book) {
        String sql = "INSERT INTO Book (title, summary, description, cover_url, "
                + "content_path, price, currency, total_pages, preview_pages, "
                + "status, author_id, category_id, created_by_employee_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

            if (book.getCreatedByEmployeeId() != null && book.getCreatedByEmployeeId() > 0) {
                ps.setInt(13, book.getCreatedByEmployeeId());
            } else {
                ps.setNull(13, Types.INTEGER);
            }

            int rowsAffected = ps.executeUpdate();
            System.out.println("BookDAO: Thêm sách thành công - " + book.getTitle());
            return rowsAffected > 0;

        } catch (Exception e) {
            System.err.println("Error in addBook: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateBook(Book book) {
        String sql = "UPDATE Book SET "
                + "title = ?, summary = ?, description = ?, cover_url = ?, "
                + "content_path = ?, price = ?, currency = ?, total_pages = ?, "
                + "preview_pages = ?, status = ?, author_id = ?, category_id = ?, "
                + "updated_at = SYSUTCDATETIME(), updated_by_employee_id = ? "
                + "WHERE book_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
            System.out.println("BookDAO: Cập nhật sách thành công - ID: " + book.getBookId());
            return rowsAffected > 0;

        } catch (Exception e) {
            System.err.println("Error in updateBook: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteBook(int bookId) {
        String sql = "DELETE FROM Book WHERE book_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookId);
            int rowsAffected = ps.executeUpdate();
            System.out.println("BookDAO: Xóa sách thành công - ID: " + bookId);
            return rowsAffected > 0;

        } catch (Exception e) {
            System.err.println("Error in deleteBook: " + e.getMessage());
            e.printStackTrace();
        }

        return false;
    }

    public List<Book> searchBooks(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, c.category_name, a.author_name "
                + "FROM Book b "
                + "LEFT JOIN Category c ON b.category_id = c.category_id "
                + "LEFT JOIN Author a ON b.author_id = a.author_id "
                + "WHERE b.title LIKE ? OR a.author_name LIKE ? "
                + "ORDER BY b.created_at DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }

            System.out.println("BookDAO: Tìm được " + books.size() + " sách với keyword: " + keyword);

        } catch (Exception e) {
            System.err.println("Error in searchBooks: " + e.getMessage());
            e.printStackTrace();
        }

        return books;
    }

    public int getTotalBooks() {
        String sql = "SELECT COUNT(*) FROM Book";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.err.println("Error in getTotalBooks: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    public List<Book> getBooksByPage(int page, int pageSize) {
        List<Book> books = new ArrayList<>();

        int offset = (page - 1) * pageSize;

        String sql = "SELECT b.*, "
                + "c.category_name, "
                + "a.author_name "
                + "FROM Book b "
                + "LEFT JOIN Category c ON b.category_id = c.category_id "
                + "LEFT JOIN Author a ON b.author_id = a.author_id "
                + "ORDER BY b.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                books.add(extractBookFromResultSet(rs));
            }

            System.out.println("BookDAO: Trang " + page + " - Lấy được " + books.size() + " sách");

        } catch (Exception e) {
            System.err.println("Error in getBooksByPage: " + e.getMessage());
            e.printStackTrace();
        }

        return books;
    }

    public List<Book> searchBooksByPage(String keyword, int page, int pageSize) {
        List<Book> books = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = "SELECT b.*, c.category_name, a.author_name "
                + "FROM Book b "
                + "LEFT JOIN Category c ON b.category_id = c.category_id "
                + "LEFT JOIN Author a ON b.author_id = a.author_id "
                + "WHERE b.title LIKE ? OR a.author_name LIKE ? "
                + "ORDER BY b.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
            System.err.println("Error in searchBooksByPage: " + e.getMessage());
            e.printStackTrace();
        }

        return books;
    }

    public int countBooksByKeyword(String keyword) {
        String sql = "SELECT COUNT(*) FROM Book b "
                + "LEFT JOIN Author a ON b.author_id = a.author_id "
                + "WHERE b.title LIKE ? OR a.author_name LIKE ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.err.println("Error in countBooksByKeyword: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

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

        book.setAuthorId(rs.getInt("author_id"));
        book.setCategoryId(rs.getInt("category_id"));

        int createdBy = rs.getInt("created_by_employee_id");
        if (!rs.wasNull()) {
            book.setCreatedByEmployeeId(createdBy);
        }

        int updatedBy = rs.getInt("updated_by_employee_id");
        if (!rs.wasNull()) {
            book.setUpdatedByEmployeeId(updatedBy);
        }

        book.setCategoryName(rs.getString("category_name"));
        book.setAuthorName(rs.getString("author_name"));

        return book;
    }

    public BigDecimal getMaxPrice() {
        String sql = "SELECT MAX(price) AS max_price FROM Book";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                BigDecimal maxPrice = rs.getBigDecimal("max_price");
                if (maxPrice != null) {
                    return maxPrice;
                }
            }

        } catch (Exception e) {
            System.err.println("getMaxPrice Error: " + e.getMessage());
        }

        return new BigDecimal("100000000");
    }

    public BigDecimal getMinPrice() {
        String sql = "SELECT MIN(price) AS min_price FROM Book WHERE price > 0";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                BigDecimal minPrice = rs.getBigDecimal("min_price");
                if (minPrice != null) {
                    return minPrice;
                }
            }

        } catch (Exception e) {
            System.err.println("getMinPrice Error: " + e.getMessage());
        }

        return BigDecimal.ZERO;
    }

    public int getMaxTotalPages() {
        String sql = "SELECT MAX(total_pages) AS max_pages FROM Book";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                int maxPages = rs.getInt("max_pages");
                if (maxPages > 0) {
                    return maxPages;
                }
            }

        } catch (Exception e) {
            System.err.println("getMaxTotalPages Error: " + e.getMessage());
        }

        return 10000;
    }
}
