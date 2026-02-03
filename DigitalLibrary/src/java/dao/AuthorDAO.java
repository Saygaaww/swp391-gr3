package dao;

import model.Author;
import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AuthorDAO {
    
    /**
     * Lấy tác giả theo ID
     */
    public Author getAuthorById(int authorId) throws SQLException {
        String sql = "SELECT author_id, author_name, bio FROM Author WHERE author_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, authorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Author author = new Author();
                    author.setAuthorId(rs.getInt("author_id"));
                    author.setAuthorName(rs.getString("author_name"));
                    author.setBio(rs.getString("bio"));
                    return author;
                }
            }
        }
        return null;
    }
    
    /**
     * Lấy tất cả tác giả
     */
    public List<Author> getAllAuthors() throws SQLException {
        List<Author> authors = new ArrayList<>();
        String sql = "SELECT author_id, author_name, bio FROM Author ORDER BY author_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Author author = new Author();
                author.setAuthorId(rs.getInt("author_id"));
                author.setAuthorName(rs.getString("author_name"));
                author.setBio(rs.getString("bio"));
                authors.add(author);
            }
        }
        return authors;
    }
    
    /**
     * Tìm kiếm tác giả theo tên
     */
    public List<Author> searchAuthorsByName(String name) throws SQLException {
        List<Author> authors = new ArrayList<>();
        String sql = "SELECT author_id, author_name, bio FROM Author WHERE author_name LIKE ? ORDER BY author_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Author author = new Author();
                    author.setAuthorId(rs.getInt("author_id"));
                    author.setAuthorName(rs.getString("author_name"));
                    author.setBio(rs.getString("bio"));
                    authors.add(author);
                }
            }
        }
        return authors;
    }
    
    /**
     * Tạo tác giả mới
     */
    public Author createAuthor(String authorName, String bio) throws SQLException {
        String sql = "INSERT INTO Author (author_name, bio) VALUES (?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, authorName);
            ps.setString(2, bio);
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int authorId = rs.getInt(1);
                        return getAuthorById(authorId);
                    }
                }
            }
        }
        return null;
    }
    
    /**
     * Cập nhật thông tin tác giả
     */
    public boolean updateAuthor(Author author) throws SQLException {
        String sql = "UPDATE Author SET author_name = ?, bio = ? WHERE author_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, author.getAuthorName());
            ps.setString(2, author.getBio());
            ps.setInt(3, author.getAuthorId());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    /**
     * Xóa tác giả (chỉ xóa nếu không có sách nào tham chiếu)
     */
    public boolean deleteAuthor(int authorId) throws SQLException {
        // Kiểm tra xem có sách nào đang sử dụng tác giả này không
        String checkSql = "SELECT COUNT(*) FROM Book WHERE author_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setInt(1, authorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    // Có sách đang sử dụng tác giả này, không thể xóa
                    return false;
                }
            }
        }
        
        // Xóa tác giả
        String sql = "DELETE FROM Author WHERE author_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, authorId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    /**
     * Kiểm tra tác giả có tồn tại không
     */
    public boolean authorExists(int authorId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Author WHERE author_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, authorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
}
