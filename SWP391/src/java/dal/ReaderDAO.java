package dal;

import model.Reader;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class ReaderDAO extends DBContext {
    
    public Reader login(String email, String password) {
        String sql = "SELECT r.*, ro.role_name FROM Reader r " +
                     "INNER JOIN Role ro ON r.role_id = ro.role_id " +
                     "WHERE r.email = ? AND r.password_hash = ? AND r.status = 'active'";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, hashPassword(password));
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Reader reader = new Reader();
                reader.setReaderId(rs.getInt("reader_id"));
                reader.setFullName(rs.getString("full_name"));
                reader.setEmail(rs.getString("email"));
                reader.setPasswordHash(rs.getString("password_hash"));
                reader.setPhone(rs.getString("phone"));
                reader.setAvatar(rs.getString("avatar"));
                reader.setStatus(rs.getString("status"));
                Timestamp createdAt = rs.getTimestamp("created_at");
                reader.setCreatedAt(createdAt != null ? new java.util.Date(createdAt.getTime()) : null);
                reader.setRoleId(rs.getInt("role_id"));
                
                return reader;
            }
        } catch (SQLException e) {
            System.out.println("Error logging in reader: " + e.getMessage());
        }
        
        return null;
    }
    
    public Reader getReaderById(int readerId) {
        String sql = "SELECT * FROM Reader WHERE reader_id = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Reader reader = new Reader();
                reader.setReaderId(rs.getInt("reader_id"));
                reader.setFullName(rs.getString("full_name"));
                reader.setEmail(rs.getString("email"));
                reader.setPasswordHash(rs.getString("password_hash"));
                reader.setPhone(rs.getString("phone"));
                reader.setAvatar(rs.getString("avatar"));
                reader.setStatus(rs.getString("status"));
                Timestamp createdAt = rs.getTimestamp("created_at");
                reader.setCreatedAt(createdAt != null ? new java.util.Date(createdAt.getTime()) : null);
                reader.setRoleId(rs.getInt("role_id"));
                
                return reader;
            }
        } catch (SQLException e) {
            System.out.println("Error getting reader by id: " + e.getMessage());
        }
        
        return null;
    }
    
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            System.out.println("Error hashing password: " + e.getMessage());
            return password; // Fallback to plain password (not recommended for production)
        }
    }
}
