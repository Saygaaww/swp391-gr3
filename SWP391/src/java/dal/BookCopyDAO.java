package dal;

import model.BookCopy;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookCopyDAO extends DBContext {
    
    public List<BookCopy> getAvailableCopiesByBookId(int bookId) {
        List<BookCopy> copies = new ArrayList<>();
        String sql = "SELECT * FROM BookCopy WHERE book_id = ? AND status = 'available'";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                BookCopy copy = new BookCopy();
                copy.setCopyId(rs.getInt("copy_id"));
                copy.setBookId(rs.getInt("book_id"));
                copy.setCopyCode(rs.getString("copy_code"));
                copy.setStatus(rs.getString("status"));
                copy.setCreatedAt(rs.getTimestamp("created_at"));
                
                copies.add(copy);
            }
        } catch (SQLException e) {
            System.out.println("Error getting available copies: " + e.getMessage());
        }
        
        return copies;
    }
    
    public int countAvailableCopies(int bookId) {
        String sql = "SELECT COUNT(*) as count FROM BookCopy WHERE book_id = ? AND status = 'available'";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("count");
            }
        } catch (SQLException e) {
            System.out.println("Error counting available copies: " + e.getMessage());
        }
        
        return 0;
    }
    
    public boolean updateCopyStatus(int copyId, String status) {
        String sql = "UPDATE BookCopy SET status = ? WHERE copy_id = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, copyId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating copy status: " + e.getMessage());
            return false;
        }
    }
    
    public BookCopy getCopyById(int copyId) {
        String sql = "SELECT * FROM BookCopy WHERE copy_id = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, copyId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                BookCopy copy = new BookCopy();
                copy.setCopyId(rs.getInt("copy_id"));
                copy.setBookId(rs.getInt("book_id"));
                copy.setCopyCode(rs.getString("copy_code"));
                copy.setStatus(rs.getString("status"));
                copy.setCreatedAt(rs.getTimestamp("created_at"));
                
                return copy;
            }
        } catch (SQLException e) {
            System.out.println("Error getting copy by id: " + e.getMessage());
        }
        
        return null;
    }
}

