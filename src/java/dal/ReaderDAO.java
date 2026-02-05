package dal;

import model.Reader;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReaderDAO extends DBContext {
    
    public List<Reader> getAllReaders() {
        List<Reader> readers = new ArrayList<>();
        String sql = "SELECT * FROM Reader ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                readers.add(mapResultSetToReader(rs));
            }
            System.out.println("ReaderDAO.getAllReaders: " + readers.size() + " readers");
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.getAllReaders Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return readers;
    }
    
    public List<Reader> getReadersByPage(int page, int pageSize) {
        List<Reader> readers = new ArrayList<>();
        String sql = "SELECT * FROM Reader " +
                     "ORDER BY created_at DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            int offset = (page - 1) * pageSize;
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    readers.add(mapResultSetToReader(rs));
                }
            }
            System.out.println("ReaderDAO.getReadersByPage: Page " + page + ", " + readers.size() + " readers");
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.getReadersByPage Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return readers;
    }
    
    public int getTotalReaders() {
        String sql = "SELECT COUNT(*) FROM Reader";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.getTotalReaders Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    public List<Reader> searchReadersByPage(String keyword, int page, int pageSize) {
        List<Reader> readers = new ArrayList<>();
        String sql = "SELECT * FROM Reader " +
                     "WHERE full_name LIKE ? OR email LIKE ? OR phone LIKE ? " +
                     "ORDER BY created_at DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            int offset = (page - 1) * pageSize;
            ps.setInt(4, offset);
            ps.setInt(5, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    readers.add(mapResultSetToReader(rs));
                }
            }
            System.out.println("ReaderDAO.searchReadersByPage: '" + keyword + "', Page " + page + ", " + readers.size() + " readers");
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.searchReadersByPage Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return readers;
    }
    
    public int countReadersByKeyword(String keyword) {
        String sql = "SELECT COUNT(*) FROM Reader " +
                     "WHERE full_name LIKE ? OR email LIKE ? OR phone LIKE ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.countReadersByKeyword Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    public Reader getReaderById(int readerId) {
        String sql = "SELECT * FROM Reader WHERE reader_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, readerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReader(rs);
                }
            }
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.getReaderById Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    public Reader getReaderByEmail(String email) {
        String sql = "SELECT * FROM Reader WHERE email = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToReader(rs);
                }
            }
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.getReaderByEmail Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    public boolean addReader(Reader reader) {
        String sql = "INSERT INTO Reader (full_name, email, password_hash, phone, address, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reader.getFullName());
            ps.setString(2, reader.getEmail());
            ps.setString(3, reader.getPasswordHash());
            ps.setString(4, reader.getPhone());
            ps.setString(5, reader.getAddress());
            ps.setString(6, reader.getStatus() != null ? reader.getStatus() : "active");
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("ReaderDAO.addReader: " + reader.getFullName() + " - " + 
                             (rowsAffected > 0 ? "SUCCESS" : "FAILED"));
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.addReader Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean updateReader(Reader reader) {
        String sql = "UPDATE Reader SET " +
                     "full_name = ?, email = ?, phone = ?, address = ?, status = ?, " +
                     "updated_at = GETDATE() " +
                     "WHERE reader_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reader.getFullName());
            ps.setString(2, reader.getEmail());
            ps.setString(3, reader.getPhone());
            ps.setString(4, reader.getAddress());
            ps.setString(5, reader.getStatus());
            ps.setInt(6, reader.getReaderId());
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("ReaderDAO.updateReader: ID " + reader.getReaderId() + " - " + 
                             (rowsAffected > 0 ? "SUCCESS" : "FAILED"));
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.updateReader Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean updateReaderPassword(int readerId, String newPasswordHash) {
        String sql = "UPDATE Reader SET password_hash = ?, updated_at = GETDATE() " +
                     "WHERE reader_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, newPasswordHash);
            ps.setInt(2, readerId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("ReaderDAO.updateReaderPassword: ID " + readerId + " - " + 
                             (rowsAffected > 0 ? "SUCCESS" : "FAILED"));
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.updateReaderPassword Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean updateReaderStatus(int readerId, String status) {
        String sql = "UPDATE Reader SET status = ?, updated_at = GETDATE() " +
                     "WHERE reader_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, readerId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("ReaderDAO.updateReaderStatus: ID " + readerId + " -> " + status + " - " + 
                             (rowsAffected > 0 ? "SUCCESS" : "FAILED"));
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.updateReaderStatus Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean deleteReader(int readerId) {
        String sql = "DELETE FROM Reader WHERE reader_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, readerId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("ReaderDAO.deleteReader: ID " + readerId + " - " + 
                             (rowsAffected > 0 ? "SUCCESS" : "FAILED"));
            return rowsAffected > 0;
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.deleteReader Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Reader WHERE email = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.isEmailExists Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    public boolean isEmailExistsExcept(String email, int exceptReaderId) {
        String sql = "SELECT COUNT(*) FROM Reader WHERE email = ? AND reader_id != ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setInt(2, exceptReaderId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.isEmailExistsExcept Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    public int countReadersByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Reader WHERE status = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.countReadersByStatus Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    private Reader mapResultSetToReader(ResultSet rs) throws SQLException {
        Reader reader = new Reader();
        reader.setReaderId(rs.getInt("reader_id"));
        reader.setFullName(rs.getString("full_name"));
        reader.setEmail(rs.getString("email"));
        reader.setPasswordHash(rs.getString("password_hash"));
        reader.setPhone(rs.getString("phone"));
        reader.setAddress(rs.getString("address"));
        reader.setStatus(rs.getString("status"));
        reader.setCreatedAt(rs.getTimestamp("created_at"));
        reader.setUpdatedAt(rs.getTimestamp("updated_at"));
        return reader;
    }
}