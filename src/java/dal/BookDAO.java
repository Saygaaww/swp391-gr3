package dal;

import model.Book;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO extends DBContext {

    public Book getBookById(int bookId) {
        String sql = "SELECT b.*, c.category_name, a.author_name " +
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
            System.err.println("getBookById Error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

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

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("addBook Error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

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

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("updateBook Error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteBook(int bookId) {
        String sql = "DELETE FROM Book WHERE book_id = ?";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("deleteBook Error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public int getTotalBooks() {
        String sql = "SELECT COUNT(*) FROM Book";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            System.err.println("getTotalBooks Error: " + e.getMessage());
        }
        return 0;
    }

    public List<Book> getBooksFiltered(String keyword, int categoryId, int authorId,
            String status, int page, int pageSize) {
        List<Book> books = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT b.*, a.author_name, c.category_name ");
        sql.append("FROM Book b ");
        sql.append("LEFT JOIN Author a ON b.author_id = a.author_id ");
        sql.append("LEFT JOIN Category c ON b.category_id = c.category_id ");
        sql.append("WHERE 1=1 ");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (b.title LIKE ? OR b.summary LIKE ? OR a.author_name LIKE ?) ");
        }
        if (categoryId > 0)
            sql.append("AND b.category_id = ? ");
        if (authorId > 0)
            sql.append("AND b.author_id = ? ");
        if (status != null && !status.isEmpty())
            sql.append("AND b.status = ? ");

        sql.append("ORDER BY b.created_at DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (categoryId > 0)
                ps.setInt(idx++, categoryId);
            if (authorId > 0)
                ps.setInt(idx++, authorId);
            if (status != null && !status.isEmpty())
                ps.setString(idx++, status);

            int offset = (page - 1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx++, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(extractBookFromResultSet(rs));
                }
            }

        } catch (Exception e) {
            System.err.println("getBooksFiltered Error: " + e.getMessage());
            e.printStackTrace();
        }
        return books;
    }

    public int countBooksFiltered(String keyword, int categoryId, int authorId, String status) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Book b ");
        sql.append("LEFT JOIN Author a ON b.author_id = a.author_id ");
        sql.append("WHERE 1=1 ");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (b.title LIKE ? OR b.summary LIKE ? OR a.author_name LIKE ?) ");
        }
        if (categoryId > 0)
            sql.append("AND b.category_id = ? ");
        if (authorId > 0)
            sql.append("AND b.author_id = ? ");
        if (status != null && !status.isEmpty())
            sql.append("AND b.status = ? ");

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (categoryId > 0)
                ps.setInt(idx++, categoryId);
            if (authorId > 0)
                ps.setInt(idx++, authorId);
            if (status != null && !status.isEmpty())
                ps.setString(idx++, status);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }

        } catch (Exception e) {
            System.err.println("countBooksFiltered Error: " + e.getMessage());
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
        book.setCreatedAt(
                rs.getTimestamp("created_at") != null ? rs.getTimestamp("created_at").toLocalDateTime() : null);
        book.setUpdatedAt(
                rs.getTimestamp("updated_at") != null ? rs.getTimestamp("updated_at").toLocalDateTime() : null);
        book.setAuthorId(rs.getInt("author_id"));
        book.setCategoryId(rs.getInt("category_id"));

        int createdBy = rs.getInt("created_by_employee_id");
        if (!rs.wasNull())
            book.setCreatedByEmployeeId(createdBy);

        int updatedBy = rs.getInt("updated_by_employee_id");
        if (!rs.wasNull())
            book.setUpdatedByEmployeeId(updatedBy);

        book.setCategoryName(rs.getString("category_name"));
        book.setAuthorName(rs.getString("author_name"));
        return book;
    }

    public BigDecimal getMaxPrice() {
        String sql = "SELECT MAX(price) AS max_price FROM Book";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                BigDecimal val = rs.getBigDecimal("max_price");
                if (val != null)
                    return val;
            }
        } catch (Exception e) {
            System.err.println("getMaxPrice Error: " + e.getMessage());
        }
        return new BigDecimal("100000000");
    }

    public BigDecimal getMinPrice() {
        String sql = "SELECT MIN(price) AS min_price FROM Book WHERE price > 0";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                BigDecimal val = rs.getBigDecimal("min_price");
                if (val != null)
                    return val;
            }
        } catch (Exception e) {
            System.err.println("getMinPrice Error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public int getMaxTotalPages() {
        String sql = "SELECT MAX(total_pages) AS max_pages FROM Book";
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int val = rs.getInt("max_pages");
                if (val > 0)
                    return val;
            }
        } catch (Exception e) {
            System.err.println("getMaxTotalPages Error: " + e.getMessage());
        }
        return 10000;
    }

    /**
     * Trả về số lượng còn lại trong kho (stock = total_pages dùng tạm hoặc
     * dùng cột riêng nếu có). Hiện tại sách số không cần kiểm kho nên luôn
     * trả về 999 để tương thích với CustomerController.
     */
    public int getAvailableStock(int bookId) {
        // Sách số (e-book) không giới hạn số lượng.
        // Nếu DB có cột 'stock', hãy truy vấn cột đó ở đây.
        return 999;
    }

    /**
     * Giảm số lượng trong kho sau khi thanh toán thành công.
     * Với sách số không cần thao tác thực tế – để trống.
     */
    public boolean reduceStock(int bookId, int quantity) {
        // Không làm gì vì sách số không giới hạn số lượng.
        return true;
    }
}