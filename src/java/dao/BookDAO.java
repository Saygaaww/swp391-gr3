package dao;

import model.Book;
import util.DBUtil;
import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * BookDAO - Enhanced Data Access Object for Book operations with Advanced Filtering
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
        String sql = "SELECT b.*, a.AuthorName, c.CategoryName " +
                    "FROM Book b " +
                    "LEFT JOIN Author a ON b.AuthorID = a.AuthorID " +
                    "LEFT JOIN Category c ON b.CategoryID = c.CategoryID " +
                    "WHERE b.Status = 'active' " +
                    "ORDER BY b.CreatedAt DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
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
        String sql = "SELECT b.*, a.AuthorName, c.CategoryName " +
                    "FROM Book b " +
                    "LEFT JOIN Author a ON b.AuthorID = a.AuthorID " +
                    "LEFT JOIN Category c ON b.CategoryID = c.CategoryID " +
                    "WHERE b.BookID = ? AND b.Status = 'active'";
        
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
     * Enhanced search with all filter criteria including language and publication year
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
        
        // Publication year range filter
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
        
        // Add sorting
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
     * Search books by keyword
     */
    public List<Book> searchByKeyword(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, a.AuthorName, c.CategoryName " +
                    "FROM Book b " +
                    "LEFT JOIN Author a ON b.AuthorID = a.AuthorID " +
                    "LEFT JOIN Category c ON b.CategoryID = c.CategoryID " +
                    "WHERE b.Status = 'active' " +
                    "AND (LOWER(b.Title) LIKE ? " +
                    "OR LOWER(b.Summary) LIKE ? " +
                    "OR LOWER(b.Description) LIKE ? " +
                    "OR LOWER(a.AuthorName) LIKE ?) " +
                    "ORDER BY b.CreatedAt DESC";
        
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
        String sql = "SELECT b.*, a.AuthorName, c.CategoryName " +
                    "FROM Book b " +
                    "LEFT JOIN Author a ON b.AuthorID = a.AuthorID " +
                    "LEFT JOIN Category c ON b.CategoryID = c.CategoryID " +
                    "WHERE b.CategoryID = ? AND b.Status = 'active' " +
                    "ORDER BY b.CreatedAt DESC";
        
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
        String sql = "SELECT b.*, a.AuthorName, c.CategoryName " +
                    "FROM Book b " +
                    "LEFT JOIN Author a ON b.AuthorID = a.AuthorID " +
                    "LEFT JOIN Category c ON b.CategoryID = c.CategoryID " +
                    "WHERE b.AuthorID = ? AND b.Status = 'active' " +
                    "ORDER BY b.CreatedAt DESC";
        
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
        String sql = "SELECT TOP (?) b.*, a.AuthorName, c.CategoryName " +
                    "FROM Book b " +
                    "LEFT JOIN Author a ON b.AuthorID = a.AuthorID " +
                    "LEFT JOIN Category c ON b.CategoryID = c.CategoryID " +
                    "WHERE b.Status = 'active' " +
                    "ORDER BY b.CreatedAt DESC";
        
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
        String sql = "SELECT b.*, a.AuthorName, c.CategoryName " +
                    "FROM Book b " +
                    "LEFT JOIN Author a ON b.AuthorID = a.AuthorID " +
                    "LEFT JOIN Category c ON b.CategoryID = c.CategoryID " +
                    "WHERE b.Status = 'active' " +
                    "AND (b.Price IS NULL OR b.Price = 0) " +
                    "ORDER BY b.CreatedAt DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
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
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
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
        String sql = "SELECT MIN(PublicationYear) as MinYear, MAX(PublicationYear) as MaxYear FROM Book " +
                    "WHERE Status = 'active' AND PublicationYear IS NOT NULL";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
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
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting books", e);
        }
        
        return 0;
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
}