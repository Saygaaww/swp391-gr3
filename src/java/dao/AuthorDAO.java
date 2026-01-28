package dao;

import model.Author;
import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * AuthorDAO - Data Access Object for Author operations - CORRECTED VERSION
 * @author FPT Student Team
 */
public class AuthorDAO {
    
    private static final Logger LOGGER = Logger.getLogger(AuthorDAO.class.getName());
    private Connection connection;
    
    public AuthorDAO() {
        try {
            this.connection = DBUtil.getConnection();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error connecting to database", e);
        }
    }
    
    /**
     * Get all authors
     */
    public List<Author> getAllAuthors() {
        List<Author> authors = new ArrayList<>();
        String sql = "SELECT * FROM Author ORDER BY AuthorName ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                authors.add(mapResultSetToAuthor(rs));
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all authors", e);
        }
        
        return authors;
    }
    
    /**
     * Get author by ID
     */
    public Author getAuthorById(int authorId) {
        String sql = "SELECT * FROM Author WHERE AuthorID = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, authorId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToAuthor(rs);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting author by ID: " + authorId, e);
        }
        
        return null;
    }
    
    /**
     * Get authors with active books
     */
    public List<Author> getAuthorsWithBooks() {
        List<Author> authors = new ArrayList<>();
        String sql = "SELECT DISTINCT a.* FROM Author a " +
                    "INNER JOIN Book b ON a.AuthorID = b.AuthorID " +
                    "WHERE b.Status = 'active' " +
                    "ORDER BY a.AuthorName ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                authors.add(mapResultSetToAuthor(rs));
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting authors with books", e);
        }
        
        return authors;
    }
    
    /**
     * Search authors by name
     */
    public List<Author> searchAuthorsByName(String name) {
        List<Author> authors = new ArrayList<>();
        String sql = "SELECT * FROM Author " +
                    "WHERE LOWER(AuthorName) LIKE ? " +
                    "ORDER BY AuthorName ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + name.toLowerCase() + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    authors.add(mapResultSetToAuthor(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching authors by name: " + name, e);
        }
        
        return authors;
    }
    
    /**
     * Map ResultSet to Author object - CORRECTED VERSION
     */
    private Author mapResultSetToAuthor(ResultSet rs) throws SQLException {
        Author author = new Author();
        
        // Use PascalCase column names (matching database)
        author.setAuthorId(rs.getInt("AuthorID"));
        author.setAuthorName(rs.getString("AuthorName"));
        author.setBio(rs.getString("bio"));  // bio is lowercase in database
        
        return author;
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