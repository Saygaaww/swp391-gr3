package dao;

import model.Book;
import util.DBUtil;
import util.PaginatedResult;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * BookDAO - Enhanced Data Access Object with Advanced Filtering & Pagination
 *
 * @author FPT Student Team
 */
public class BookDAO {

    private static final Logger LOGGER = Logger.getLogger(BookDAO.class.getName());
    private Connection connection;

    public BookDAO() {
        try {
            this.connection = DBUtil.getConnection();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error connecting to database", e);
        }
    }

    /**
     * Get all active books
     */
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, a.AuthorName, c.CategoryName "
                + "FROM Book b "
                + "LEFT JOIN Author a ON b.AuthorID = a.AuthorID "
                + "LEFT JOIN Category c ON b.CategoryID = c.CategoryID "
                + "WHERE b.Status = 'active' "
                + "ORDER BY b.CreatedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all books", e);
        }

        return books;
    }

    /**
     * Get book by ID
     */
    public Book getBookById(int bookId) {
        String sql = "SELECT b.*, a.AuthorName, c.CategoryName "
                + "FROM Book b "
                + "LEFT JOIN Author a ON b.AuthorID = a.AuthorID "
                + "LEFT JOIN Category c ON b.CategoryID = c.CategoryID "
                + "WHERE b.BookID = ? AND b.Status = 'active'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBook(rs);
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting book by ID: " + bookId, e);
        }

        return null;
    }

    /**
     * Search books with basic filters (legacy method for compatibility)
     */
    public List<Book> searchBooks(String title, Integer authorId, Integer categoryId,
            BigDecimal minPrice, BigDecimal maxPrice) {
        return searchBooksAdvanced(title, authorId, categoryId, minPrice, maxPrice,
                null, null, null, "newest");
    }

    /**
     * Enhanced search with all filter criteria including language and
     * publication year
     */
    public List<Book> searchBooksAdvanced(String title, Integer authorId, Integer categoryId,
            BigDecimal minPrice, BigDecimal maxPrice,
            String language, String yearRange,
            String priceType, String sortBy) {
        List<Book> books = new ArrayList<>();
        StringBuilder sql = new StringBuilder();

        sql.append("SELECT b.*, a.AuthorName, c.CategoryName ");
        sql.append("FROM Book b ");
        sql.append("LEFT JOIN Author a ON b.AuthorID = a.AuthorID ");
        sql.append("LEFT JOIN Category c ON b.CategoryID = c.CategoryID ");
        sql.append("WHERE b.Status = 'active' ");

        List<Object> params = new ArrayList<>();
        buildWhereClause(sql, params, title, authorId, categoryId,
                minPrice, maxPrice, language, yearRange, priceType);
        addSorting(sql, sortBy);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in advanced book search", e);
        }

        return books;
    }

    /**
     * NEW: Search books with pagination support
     */
    public PaginatedResult<Book> searchBooksWithPagination(
            String title, Integer authorId, Integer categoryId,
            BigDecimal minPrice, BigDecimal maxPrice,
            String language, String yearRange, String priceType, String sortBy,
            int page, int pageSize) {

        // Calculate offset
        int offset = (page - 1) * pageSize;

        // Build base query
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT b.*, a.AuthorName, c.CategoryName ");
        sql.append("FROM Book b ");
        sql.append("LEFT JOIN Author a ON b.AuthorID = a.AuthorID ");
        sql.append("LEFT JOIN Category c ON b.CategoryID = c.CategoryID ");
        sql.append("WHERE b.Status = 'active' ");

        List<Object> params = new ArrayList<>();
        buildWhereClause(sql, params, title, authorId, categoryId,
                minPrice, maxPrice, language, yearRange, priceType);
        addSorting(sql, sortBy);

        // Add pagination - SQL Server syntax
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(pageSize);

        List<Book> books = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            // Set all parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in paginated search", e);
        }

        // Get total count for pagination info
        int totalCount = getTotalSearchCount(title, authorId, categoryId,
                minPrice, maxPrice, language, yearRange, priceType);

        return new PaginatedResult<>(books, page, pageSize, totalCount);
    }

    /**
     * NEW: Keyword search with pagination
     */
    public PaginatedResult<Book> searchByKeywordWithPagination(String keyword, int page, int pageSize) {
        int offset = (page - 1) * pageSize;

        String sql = "SELECT b.*, a.AuthorName, c.CategoryName "
                + "FROM Book b "
                + "LEFT JOIN Author a ON b.AuthorID = a.AuthorID "
                + "LEFT JOIN Category c ON b.CategoryID = c.CategoryID "
                + "WHERE b.Status = 'active' "
                + "AND (LOWER(b.Title) LIKE ? "
                + "OR LOWER(b.Summary) LIKE ? "
                + "OR LOWER(b.Description) LIKE ? "
                + "OR LOWER(a.AuthorName) LIKE ?) "
                + "ORDER BY b.CreatedAt DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        String searchPattern = "%" + keyword.toLowerCase() + "%";
        List<Book> books = new ArrayList<>();

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ps.setInt(5, offset);
            ps.setInt(6, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in paginated keyword search", e);
        }

        // Get total count
        int totalCount = getKeywordSearchCount(keyword);

        return new PaginatedResult<>(books, page, pageSize, totalCount);
    }

    /**
     * Search books by keyword (legacy - no pagination)
     */
    public List<Book> searchByKeyword(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, a.AuthorName, c.CategoryName "
                + "FROM Book b "
                + "LEFT JOIN Author a ON b.AuthorID = a.AuthorID "
                + "LEFT JOIN Category c ON b.CategoryID = c.CategoryID "
                + "WHERE b.Status = 'active' "
                + "AND (LOWER(b.Title) LIKE ? "
                + "OR LOWER(b.Summary) LIKE ? "
                + "OR LOWER(b.Description) LIKE ? "
                + "OR LOWER(a.AuthorName) LIKE ?) "
                + "ORDER BY b.CreatedAt DESC";

        String searchPattern = "%" + keyword.toLowerCase() + "%";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching books by keyword: " + keyword, e);
        }

        return books;
    }

    /**
     * Get books by category
     */
    public List<Book> getBooksByCategory(int categoryId) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, a.AuthorName, c.CategoryName "
                + "FROM Book b "
                + "LEFT JOIN Author a ON b.AuthorID = a.AuthorID "
                + "LEFT JOIN Category c ON b.CategoryID = c.CategoryID "
                + "WHERE b.CategoryID = ? AND b.Status = 'active' "
                + "ORDER BY b.CreatedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting books by category: " + categoryId, e);
        }

        return books;
    }

    /**
     * Get books by author
     */
    public List<Book> getBooksByAuthor(int authorId) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, a.AuthorName, c.CategoryName "
                + "FROM Book b "
                + "LEFT JOIN Author a ON b.AuthorID = a.AuthorID "
                + "LEFT JOIN Category c ON b.CategoryID = c.CategoryID "
                + "WHERE b.AuthorID = ? AND b.Status = 'active' "
                + "ORDER BY b.CreatedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, authorId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting books by author: " + authorId, e);
        }

        return books;
    }

    /**
     * Get latest books
     */
    public List<Book> getLatestBooks(int limit) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT TOP (?) b.*, a.AuthorName, c.CategoryName "
                + "FROM Book b "
                + "LEFT JOIN Author a ON b.AuthorID = a.AuthorID "
                + "LEFT JOIN Category c ON b.CategoryID = c.CategoryID "
                + "WHERE b.Status = 'active' "
                + "ORDER BY b.CreatedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapResultSetToBook(rs));
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting latest books", e);
        }

        return books;
    }

    /**
     * Get free books
     */
    public List<Book> getFreeBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, a.AuthorName, c.CategoryName "
                + "FROM Book b "
                + "LEFT JOIN Author a ON b.AuthorID = a.AuthorID "
                + "LEFT JOIN Category c ON b.CategoryID = c.CategoryID "
                + "WHERE b.Status = 'active' "
                + "AND (b.Price IS NULL OR b.Price = 0) "
                + "ORDER BY b.CreatedAt DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                books.add(mapResultSetToBook(rs));
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting free books", e);
        }

        return books;
    }

    /**
     * Get distinct languages from books
     */
    public List<String> getAvailableLanguages() {
        List<String> languages = new ArrayList<>();
        String sql = "SELECT DISTINCT Language FROM Book WHERE Status = 'active' AND Language IS NOT NULL ORDER BY Language";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String language = rs.getString("Language");
                if (language != null && !language.trim().isEmpty()) {
                    languages.add(language);
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting available languages", e);
        }

        return languages;
    }

    /**
     * Get publication year statistics
     */
    public List<Integer> getPublicationYearRange() {
        List<Integer> years = new ArrayList<>();
        String sql = "SELECT MIN(PublicationYear) as MinYear, MAX(PublicationYear) as MaxYear FROM Book "
                + "WHERE Status = 'active' AND PublicationYear IS NOT NULL";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                years.add(rs.getInt("MinYear"));
                years.add(rs.getInt("MaxYear"));
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting publication year range", e);
        }

        return years;
    }

    /**
     * Count total books
     */
    public int getTotalBookCount() {
        String sql = "SELECT COUNT(*) FROM Book WHERE Status = 'active'";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting books", e);
        }

        return 0;
    }

    /**
     * Update book content file path (digital asset)
     */
    public boolean updateBookContentPath(int bookId, String contentPath) {
        String sql = "UPDATE Book SET ContentPath = ?, UpdatedAt = GETDATE() WHERE BookID = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, contentPath);
            ps.setInt(2, bookId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Updated contentPath for BookID: " + bookId);
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating book content path for ID: " + bookId, e);
        }

        return false;
    }

    // ========== PAGINATION HELPER METHODS ==========
    /**
     * Tạo sách mới — trả về BookID vừa tạo, hoặc -1 nếu thất bại
     */
    public int createBook(Book book) {
        String sql = "INSERT INTO Book (Title, Summary, Description, AuthorID, CategoryID, "
                + "Price, Currency, TotalPages, PreviewPages, Language, PublicationYear, "
                + "CoverURL, Status, CreatedAt, UpdatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'active', GETDATE(), GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setNString(1, book.getTitle());
            ps.setNString(2, book.getSummary());
            ps.setNString(3, book.getDescription());
            if (book.getAuthorId() != null) {
                ps.setInt(4, book.getAuthorId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            if (book.getCategoryId() != null) {
                ps.setInt(5, book.getCategoryId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            if (book.getPrice() != null) {
                ps.setBigDecimal(6, book.getPrice());
            } else {
                ps.setNull(6, Types.DECIMAL);
            }
            ps.setString(7, book.getCurrency() != null ? book.getCurrency() : "VND");
            if (book.getTotalPages() != null) {
                ps.setInt(8, book.getTotalPages());
            } else {
                ps.setNull(8, Types.INTEGER);
            }
            if (book.getPreviewPages() != null) {
                ps.setInt(9, book.getPreviewPages());
            } else {
                ps.setNull(9, Types.INTEGER);
            }
            ps.setString(10, book.getLanguage());
            if (book.getPublicationYear() != null) {
                ps.setInt(11, book.getPublicationYear());
            } else {
                ps.setNull(11, Types.INTEGER);
            }
            ps.setString(12, book.getCoverUrl());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        int newId = keys.getInt(1);
                        LOGGER.info("Created new book with ID: " + newId);
                        return newId;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating book: " + book.getTitle(), e);
        }
        return -1;
    }

    /**
     * Cập nhật thông tin sách
     */
    public boolean updateBook(Book book) {
        String sql = "UPDATE Book SET Title=?, Summary=?, Description=?, AuthorID=?, CategoryID=?, "
                + "Price=?, Currency=?, TotalPages=?, PreviewPages=?, Language=?, PublicationYear=?, "
                + "CoverURL=?, UpdatedAt=GETDATE() WHERE BookID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setNString(1, book.getTitle());
            ps.setNString(2, book.getSummary());
            ps.setNString(3, book.getDescription());
            if (book.getAuthorId() != null) {
                ps.setInt(4, book.getAuthorId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            if (book.getCategoryId() != null) {
                ps.setInt(5, book.getCategoryId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            if (book.getPrice() != null) {
                ps.setBigDecimal(6, book.getPrice());
            } else {
                ps.setNull(6, Types.DECIMAL);
            }
            ps.setString(7, book.getCurrency() != null ? book.getCurrency() : "VND");
            if (book.getTotalPages() != null) {
                ps.setInt(8, book.getTotalPages());
            } else {
                ps.setNull(8, Types.INTEGER);
            }
            if (book.getPreviewPages() != null) {
                ps.setInt(9, book.getPreviewPages());
            } else {
                ps.setNull(9, Types.INTEGER);
            }
            ps.setString(10, book.getLanguage());
            if (book.getPublicationYear() != null) {
                ps.setInt(11, book.getPublicationYear());
            } else {
                ps.setNull(11, Types.INTEGER);
            }
            ps.setString(12, book.getCoverUrl());
            ps.setInt(13, book.getBookId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating book: " + book.getBookId(), e);
        }
        return false;
    }

    // ========== PAGINATION HELPER METHODS ==========
    /**
     * Get total count for pagination
     */
    private int getTotalSearchCount(String title, Integer authorId, Integer categoryId,
            BigDecimal minPrice, BigDecimal maxPrice,
            String language, String yearRange, String priceType) {

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Book b ");
        sql.append("LEFT JOIN Author a ON b.AuthorID = a.AuthorID ");
        sql.append("LEFT JOIN Category c ON b.CategoryID = c.CategoryID ");
        sql.append("WHERE b.Status = 'active' ");

        List<Object> params = new ArrayList<>();
        buildWhereClause(sql, params, title, authorId, categoryId,
                minPrice, maxPrice, language, yearRange, priceType);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting search results", e);
        }

        return 0;
    }

    /**
     * Get keyword search count
     */
    private int getKeywordSearchCount(String keyword) {
        String sql = "SELECT COUNT(*) FROM Book b "
                + "LEFT JOIN Author a ON b.AuthorID = a.AuthorID "
                + "WHERE b.Status = 'active' "
                + "AND (LOWER(b.Title) LIKE ? "
                + "OR LOWER(b.Summary) LIKE ? "
                + "OR LOWER(b.Description) LIKE ? "
                + "OR LOWER(a.AuthorName) LIKE ?)";

        String searchPattern = "%" + keyword.toLowerCase() + "%";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting keyword search results", e);
        }

        return 0;
    }

    /**
     * Build WHERE clause dynamically (shared by regular and paginated searches)
     */
    private void buildWhereClause(StringBuilder sql, List<Object> params,
            String title, Integer authorId, Integer categoryId,
            BigDecimal minPrice, BigDecimal maxPrice,
            String language, String yearRange, String priceType) {

        // Title filter
        if (title != null && !title.trim().isEmpty()) {
            sql.append("AND LOWER(b.Title) LIKE ? ");
            params.add("%" + title.toLowerCase() + "%");
        }

        // Author filter
        if (authorId != null && authorId > 0) {
            sql.append("AND b.AuthorID = ? ");
            params.add(authorId);
        }

        // Category filter
        if (categoryId != null && categoryId > 0) {
            sql.append("AND b.CategoryID = ? ");
            params.add(categoryId);
        }

        // Language filter
        if (language != null && !language.trim().isEmpty()) {
            sql.append("AND b.Language = ? ");
            params.add(language);
        }

        // Year range filter
        if (yearRange != null && !yearRange.trim().isEmpty()) {
            switch (yearRange) {
                case "2020-2024":
                    sql.append("AND b.PublicationYear BETWEEN 2020 AND 2024 ");
                    break;
                case "2010-2019":
                    sql.append("AND b.PublicationYear BETWEEN 2010 AND 2019 ");
                    break;
                case "2000-2009":
                    sql.append("AND b.PublicationYear BETWEEN 2000 AND 2009 ");
                    break;
                case "1990-1999":
                    sql.append("AND b.PublicationYear BETWEEN 1990 AND 1999 ");
                    break;
                case "1980-1989":
                    sql.append("AND b.PublicationYear BETWEEN 1980 AND 1989 ");
                    break;
                case "before-1980":
                    sql.append("AND b.PublicationYear < 1980 ");
                    break;
            }
        }

        // Price type filter
        if (priceType != null && !priceType.trim().isEmpty()) {
            switch (priceType) {
                case "free":
                    sql.append("AND (b.Price IS NULL OR b.Price = 0) ");
                    break;
                case "paid":
                    sql.append("AND b.Price > 0 ");
                    break;
            }
        }

        // Price range filter
        if (minPrice != null) {
            sql.append("AND b.Price >= ? ");
            params.add(minPrice);
        }

        if (maxPrice != null) {
            sql.append("AND b.Price <= ? ");
            params.add(maxPrice);
        }
    }

    /**
     * Add sorting clause (shared by regular and paginated searches)
     */
    private void addSorting(StringBuilder sql, String sortBy) {
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            switch (sortBy) {
                case "title":
                    sql.append("ORDER BY b.Title ASC");
                    break;
                case "price-low":
                    sql.append("ORDER BY ISNULL(b.Price, 0) ASC");
                    break;
                case "price-high":
                    sql.append("ORDER BY ISNULL(b.Price, 0) DESC");
                    break;
                case "year":
                    sql.append("ORDER BY ISNULL(b.PublicationYear, 0) DESC");
                    break;
                default: // "newest"
                    sql.append("ORDER BY b.CreatedAt DESC");
                    break;
            }
        } else {
            sql.append("ORDER BY b.CreatedAt DESC");
        }
    }

    /**
     * Map ResultSet to Book object - Enhanced version with new fields
     */
    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book book = new Book();

        // Use PascalCase column names (matching database)
        book.setBookId(rs.getInt("BookID"));
        book.setTitle(rs.getString("Title"));
        book.setSummary(rs.getString("Summary"));
        book.setDescription(rs.getString("Description"));
        book.setCoverUrl(rs.getString("CoverURL"));
        book.setContentPath(rs.getString("ContentPath"));

        BigDecimal price = rs.getBigDecimal("Price");
        if (!rs.wasNull()) {
            book.setPrice(price);
        }

        book.setCurrency(rs.getString("Currency"));

        int totalPages = rs.getInt("TotalPages");
        if (!rs.wasNull()) {
            book.setTotalPages(totalPages);
        }

        int previewPages = rs.getInt("PreviewPages");
        if (!rs.wasNull()) {
            book.setPreviewPages(previewPages);
        }

        book.setStatus(rs.getString("Status"));

        // NEW: Handle Language and PublicationYear columns
        try {
            String language = rs.getString("Language");
            if (language != null) {
                book.setLanguage(language);
            }
        } catch (SQLException e) {
            // Language column might not exist in older queries
        }

        try {
            int publicationYear = rs.getInt("PublicationYear");
            if (!rs.wasNull()) {
                book.setPublicationYear(publicationYear);
            }
        } catch (SQLException e) {
            // PublicationYear column might not exist in older queries
        }

        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            book.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("UpdatedAt");
        if (updatedAt != null) {
            book.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        // Set author info if available
        try {
            String authorName = rs.getString("AuthorName");
            if (authorName != null) {
                model.Author author = new model.Author();
                author.setAuthorId(rs.getInt("AuthorID"));
                author.setAuthorName(authorName);
                book.setAuthor(author);
            }
        } catch (SQLException e) {
            // Author columns might not be present in some queries
        }

        // Set category info if available
        try {
            String categoryName = rs.getString("CategoryName");
            if (categoryName != null) {
                model.Category category = new model.Category();
                category.setCategoryId(rs.getInt("CategoryID"));
                category.setCategoryName(categoryName);
                book.setCategory(category);
            }
        } catch (SQLException e) {
            // Category columns might not be present in some queries
        }

        return book;
    }

    /**
     * Close connection
     */
    public void close() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Error closing connection", e);
            }
        }
    }

    /**
     * Returns available stock for a book from the database.
     */
    public int getAvailableStock(int bookId) {
        String sql = "SELECT ISNULL(stock_quantity, 0) FROM Book WHERE BookID = ?";
        try (Connection con = util.DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting available stock for bookId: " + bookId, e);
        }
        return 0;
    }

    /**
     * Reduces stock after a successful order.
     */
    public boolean reduceStock(int bookId, int quantity) {
        String sql = "UPDATE Book SET stock_quantity = stock_quantity - ? WHERE BookID = ? AND stock_quantity >= ?";
        try (Connection con = util.DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, bookId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error reducing stock for bookId: " + bookId, e);
        }
        return false;
    }

    public List<Book> getBooksFiltered(String keyword, int categoryId, int authorId,
            String status, int page, int pageSize) {

        List<Book> books = new ArrayList<>();

        String sql = """
            SELECT b.*, 
                   a.AuthorName AS author_name,
                   c.CategoryName AS category_name
            FROM Book b
            LEFT JOIN Author a ON b.AuthorID = a.AuthorID
            LEFT JOIN Category c ON b.CategoryID = c.CategoryID
            WHERE 1=1
                """;

        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND (b.Title LIKE ? OR b.Summary LIKE ? OR a.AuthorName LIKE ?) ";
        }
        if (categoryId > 0) {
            sql += "AND b.CategoryID = ? ";
        }
        if (authorId > 0) {
            sql += "AND b.AuthorID = ? ";
        }
        if (status != null && !status.isEmpty()) {
            sql += "AND b.Status = ? ";
        }

        sql += "ORDER BY b.CreatedAt DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int idx = 1;

            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }

            if (categoryId > 0) {
                ps.setInt(idx++, categoryId);
            }

            if (authorId > 0) {
                ps.setInt(idx++, authorId);
            }

            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }

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

        String sql = """
                     SELECT COUNT(*) 
                                     FROM Book b 
                                     LEFT JOIN Author a ON b.AuthorID = a.AuthorID 
                                     WHERE 1=1""";

        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND (b.Title LIKE ? OR b.Summary LIKE ? OR a.AuthorName LIKE ?) ";
        }

        if (categoryId > 0) {
            sql += "AND b.CategoryID = ? ";
        }

        if (authorId > 0) {
            sql += "AND b.AuthorID = ? ";
        }

        if (status != null && !status.isEmpty()) {
            sql += "AND b.Status = ? ";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            int idx = 1;

            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }

            if (categoryId > 0) {
                ps.setInt(idx++, categoryId);
            }

            if (authorId > 0) {
                ps.setInt(idx++, authorId);
            }

            if (status != null && !status.isEmpty()) {
                ps.setString(idx++, status);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            System.err.println("countBooksFiltered Error: " + e.getMessage());
            e.printStackTrace();
        }

        return 0;
    }

    private Book extractBookFromResultSet(ResultSet rs) throws SQLException {

        Book book = new Book();

        book.setBookId(rs.getInt("BookID"));
        book.setTitle(rs.getString("Title"));
        book.setSummary(rs.getString("Summary"));
        book.setDescription(rs.getString("Description"));
        book.setCoverUrl(rs.getString("CoverURL"));
        book.setContentPath(rs.getString("ContentPath"));

        book.setPrice(rs.getBigDecimal("Price"));
        book.setCurrency(rs.getString("Currency"));

        book.setTotalPages(rs.getInt("TotalPages"));
        book.setPreviewPages(rs.getInt("PreviewPages"));

        book.setStatus(rs.getString("Status"));

        if (rs.getTimestamp("CreatedAt") != null) {
            book.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        }

        if (rs.getTimestamp("UpdatedAt") != null) {
            book.setUpdatedAt(rs.getTimestamp("UpdatedAt").toLocalDateTime());
        }

        book.setAuthorId(rs.getInt("AuthorID"));
        book.setCategoryId(rs.getInt("CategoryID"));

        int createdBy = rs.getInt("CreatedByEmployeeID");
        if (!rs.wasNull()) {
            book.setCreatedByEmployeeId(createdBy);
        }

        int updatedBy = rs.getInt("UpdatedByEmployeeID");
        if (!rs.wasNull()) {
            book.setUpdatedByEmployeeId(updatedBy);
        }

        book.setCategoryName(rs.getString("category_name"));
        book.setAuthorName(rs.getString("author_name"));

        return book;
    }

    public BigDecimal getMaxPrice() {
        String sql = "SELECT MAX(price) AS max_price FROM Book";
        try (Connection con = util.DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BigDecimal val = rs.getBigDecimal("max_price");
                if (val != null) {
                    return val;
                }
            }
        } catch (Exception e) {
            System.err.println("getMaxPrice Error: " + e.getMessage());
        }
        return new BigDecimal("100000000");
    }

    public BigDecimal getMinPrice() {
        String sql = "SELECT MIN(price) AS min_price FROM Book WHERE price > 0";
        try (Connection con = util.DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BigDecimal val = rs.getBigDecimal("min_price");
                if (val != null) {
                    return val;
                }
            }
        } catch (Exception e) {
            System.err.println("getMinPrice Error: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

    public int getMaxTotalPages() {
        String sql = "SELECT MAX(TotalPages) AS max_pages FROM Book";
        try (Connection con = util.DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int val = rs.getInt("max_pages");
                if (val > 0) {
                    return val;
                }
            }
        } catch (Exception e) {
            System.err.println("getMaxTotalPages Error: " + e.getMessage());
        }
        return 10000;
    }

    public boolean addBook(Book book) {
        String sql = "INSERT INTO Book (Title, Summary, Description, CoverURL, "
                + "ContentPath, Price, Currency, TotalPages, PreviewPages, "
                + "Status, AuthorID, CategoryID, CreatedByEmployeeID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = util.DBUtil.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, book.getTitle());
            ps.setString(2, book.getSummary());
            ps.setString(3, book.getDescription());
            ps.setString(4, book.getCoverUrl());
            ps.setString(5, book.getContentPath());

            if (book.getPrice() != null) {
                ps.setBigDecimal(6, book.getPrice());
            } else {
                ps.setNull(6, Types.DECIMAL);
            }

            ps.setString(7, book.getCurrency() != null ? book.getCurrency() : "VND");

            if (book.getTotalPages() != null) {
                ps.setInt(8, book.getTotalPages());
            } else {
                ps.setNull(8, Types.INTEGER);
            }

            if (book.getPreviewPages() != null) {
                ps.setInt(9, book.getPreviewPages());
            } else {
                ps.setNull(9, Types.INTEGER);
            }
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
    // Thêm vào BookDAO nếu cần lấy riêng path mà không cần load toàn bộ object

    public String getContentPathById(int bookId) {
        String sql = "SELECT ContentPath FROM Book WHERE BookID = ? AND Status = 'active'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("ContentPath");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting content path", e);
        }
        return null;
    }
}
