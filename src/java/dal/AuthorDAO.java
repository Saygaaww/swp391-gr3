package dal;

import model.Author;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuthorDAO extends DBContext {
    
    public List<Author> getAllAuthors() {
        List<Author> authors = new ArrayList<>();
        String sql = "SELECT * FROM Author ORDER BY AuthorName";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Author author = new Author();
                author.setAuthorId(rs.getInt("AuthorID"));
                author.setAuthorName(rs.getString("AuthorName"));
                author.setBio(rs.getString("bio"));
                authors.add(author);
            }
            
        } catch (Exception e) {
            System.err.println("Error in getAllAuthors: " + e.getMessage());
            e.printStackTrace();
        }
        
        return authors;
    }
    
    public Author getAuthorById(int authorId) {
        String sql = "SELECT * FROM Author WHERE AuthorID = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, authorId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Author author = new Author();
                author.setAuthorId(rs.getInt("AuthorID"));
                author.setAuthorName(rs.getString("AuthorName"));
                author.setBio(rs.getString("bio"));
                return author;
            }
            
        } catch (Exception e) {
            System.err.println("Error in getAuthorById: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    public boolean addAuthor(Author author) {
        String sql = "INSERT INTO Author (AuthorName, bio) VALUES (?, ?)";
        
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