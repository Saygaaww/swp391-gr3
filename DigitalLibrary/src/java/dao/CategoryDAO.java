package dao;

import model.Category;
import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    
    /**
     * Lấy danh mục theo ID
     */
    public Category getCategoryById(int categoryId) throws SQLException {
        String sql = "SELECT category_id, category_name, description FROM Category WHERE category_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("category_id"));
                    category.setCategoryName(rs.getString("category_name"));
                    category.setDescription(rs.getString("description"));
                    return category;
                }
            }
        }
        return null;
    }
    
    /**
     * Lấy tất cả danh mục
     */
    public List<Category> getAllCategories() throws SQLException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT category_id, category_name, description FROM Category ORDER BY category_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("category_id"));
                category.setCategoryName(rs.getString("category_name"));
                category.setDescription(rs.getString("description"));
                categories.add(category);
            }
        }
        return categories;
    }
    
    /**
     * Tìm kiếm danh mục theo tên
     */
    public List<Category> searchCategoriesByName(String name) throws SQLException {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT category_id, category_name, description FROM Category WHERE category_name LIKE ? ORDER BY category_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.setCategoryId(rs.getInt("category_id"));
                    category.setCategoryName(rs.getString("category_name"));
                    category.setDescription(rs.getString("description"));
                    categories.add(category);
                }
            }
        }
        return categories;
    }
    
    /**
     * Tạo danh mục mới
     */
    public Category createCategory(String categoryName, String description) throws SQLException {
        String sql = "INSERT INTO Category (category_name, description) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, categoryName);
            ps.setString(2, description);
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int categoryId = rs.getInt(1);
                        return getCategoryById(categoryId);
                    }
                }
            }
        }
        return null;
    }
    
    /**
     * Cập nhật thông tin danh mục
     */
    public boolean updateCategory(Category category) throws SQLException {
        String sql = "UPDATE Category SET category_name = ?, description = ? WHERE category_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setInt(3, category.getCategoryId());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    /**
     * Xóa danh mục (chỉ xóa nếu không có sách nào tham chiếu)
     */
    public boolean deleteCategory(int categoryId) throws SQLException {
        // Kiểm tra xem có sách nào đang sử dụng danh mục này không
        String checkSql = "SELECT COUNT(*) FROM Book WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Có sách đang sử dụng danh mục này, không thể xóa
                    return false;
                }
            }
        }
        
        // Xóa danh mục
        String sql = "DELETE FROM Category WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    /**
     * Kiểm tra danh mục có tồn tại không
     */
    public boolean categoryExists(int categoryId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Category WHERE category_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
}
