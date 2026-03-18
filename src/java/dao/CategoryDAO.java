package dao;

import model.Category;
import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * CategoryDAO - Data Access Object for Category operations - CORRECTED VERSION
 * @author FPT Student Team
 */
public class CategoryDAO {
    
    private static final Logger LOGGER = Logger.getLogger(CategoryDAO.class.getName());
    private Connection connection;
    
    public CategoryDAO() {
        try {
            this.connection = DBUtil.getConnection();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error connecting to database", e);
        }
    }
    
    /**
     * Get all categories
     */
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM Category ORDER BY CategoryName ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all categories", e);
        }
        
        return categories;
    }
    
    /**
     * Get category by ID
     */
    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM Category WHERE CategoryID = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCategory(rs);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting category by ID: " + categoryId, e);
        }
        
        return null;
    }
    
    /**
     * Get categories with active books
     */
    public List<Category> getCategoriesWithBooks() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT c.* FROM Category c " +
                    "INNER JOIN Book b ON c.CategoryID = b.CategoryID " +
                    "WHERE b.Status = 'active' " +
                    "ORDER BY c.CategoryName ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting categories with books", e);
        }
        
        return categories;
    }
    
    /**
     * Search categories by name
     */
    public List<Category> searchCategoriesByName(String name) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM Category " +
                    "WHERE LOWER(CategoryName) LIKE ? " +
                    "ORDER BY CategoryName ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + name.toLowerCase() + "%");
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    categories.add(mapResultSetToCategory(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error searching categories by name: " + name, e);
        }
        
        return categories;
    }
    
    /**
     * Create new category
     * @param category Category object with name and description
     * @return true if created successfully, false otherwise
     */
    public boolean createCategory(Category category) {
        String sql = "INSERT INTO Category (CategoryName, Description) VALUES (?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        category.setCategoryId(rs.getInt(1));
                        LOGGER.info("Category created successfully with ID: " + category.getCategoryId());
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating category: " + category.getCategoryName(), e);
        }
        
        return false;
    }
    
    /**
     * Update existing category
     * @param category Category object with ID, name and description
     * @return true if updated successfully, false otherwise
     */
    public boolean updateCategory(Category category) {
        String sql = "UPDATE Category SET CategoryName = ?, Description = ? WHERE CategoryID = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setInt(3, category.getCategoryId());
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Category updated successfully: ID " + category.getCategoryId());
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating category: ID " + category.getCategoryId(), e);
        }
        
        return false;
    }
    
    /**
     * Check if category name already exists
     * @param categoryName Name to check
     * @param excludeCategoryId Category ID to exclude from check (for update scenarios)
     * @return true if name exists, false otherwise
     */
    public boolean categoryNameExists(String categoryName, Integer excludeCategoryId) {
        String sql = "SELECT COUNT(*) FROM Category WHERE LOWER(CategoryName) = LOWER(?)";
        if (excludeCategoryId != null) {
            sql += " AND CategoryID != ?";
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, categoryName);
            if (excludeCategoryId != null) {
                ps.setInt(2, excludeCategoryId);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking category name existence: " + categoryName, e);
        }
        
        return false;
    }
    
    /**
     * Get top categories by book count
     */
    public List<Category> getTopCategoriesByBookCount(int limit) {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT TOP (?) c.*, COUNT(b.BookID) as book_count " +
                    "FROM Category c " +
                    "LEFT JOIN Book b ON c.CategoryID = b.CategoryID AND b.Status = 'active' " +
                    "GROUP BY c.CategoryID, c.CategoryName, c.Description " +
                    "ORDER BY book_count DESC, c.CategoryName ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    categories.add(mapResultSetToCategory(rs));
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting top categories", e);
        }
        
        return categories;
    }
    
    /**
     * Count books by category
     */
    public int countBooksByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM Book WHERE CategoryID = ? AND Status = 'active'";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting books by category: " + categoryId, e);
        }
        
        return 0;
    }

    /**
     * Map ResultSet to Category object - CORRECTED VERSION
     */
    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        
        // Use PascalCase column names (matching database)
        category.setCategoryId(rs.getInt("CategoryID"));
        category.setCategoryName(rs.getString("CategoryName"));
        category.setDescription(rs.getString("Description"));
        
        return category;
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