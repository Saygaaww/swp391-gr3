package dal;

import model.Author;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO xử lý tác giả
 * @author Member E - Dũng
 */
public class AuthorDAO extends DBContext {
    
    /**
     * Lấy tất cả tác giả
     */
    public List<Author> getAllAuthors() {
        List<Author> authors = new ArrayList<>();
        String sql = "SELECT * FROM Author ORDER BY author_name";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Author author = new Author();
                author.setAuthorId(rs.getInt("author_id"));
                author.setAuthorName(rs.getString("author_name"));
                author.setBio(rs.getString("bio"));
                authors.add(author);
            }
            
        } catch (Exception e) {
            System.err.println("Error in getAllAuthors: " + e.getMessage());
            e.printStackTrace();
        }
        
        return authors;
    }
    
    /**
     * Lấy tác giả theo ID
     */
    public Author getAuthorById(int authorId) {
        String sql = "SELECT * FROM Author WHERE author_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, authorId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Author author = new Author();
                author.setAuthorId(rs.getInt("author_id"));
                author.setAuthorName(rs.getString("author_name"));
                author.setBio(rs.getString("bio"));
                return author;
            }
            
        } catch (Exception e) {
            System.err.println("Error in getAuthorById: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Thêm tác giả mới
     */
    public boolean addAuthor(Author author) {
        String sql = "INSERT INTO Author (author_name, bio) VALUES (?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, author.getAuthorName());
            ps.setString(2, author.getBio());
            
            return ps.executeUpdate() > 0;
            
        } catch (Exception e) {
            System.err.println("Error in addAuthor: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Đếm tổng số tác giả
     */
    public int getTotalAuthors() {
        String sql = "SELECT COUNT(*) FROM Author";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (Exception e) {
            System.err.println("Error in getTotalAuthors: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
}