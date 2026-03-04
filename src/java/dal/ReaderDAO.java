package dal;

import model.Reader;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReaderDAO extends DBContext {
    
    
    public List<Reader> getAllReaders() {
        List<Reader> readers = new ArrayList<>();
        String sql = "SELECT r.*, ro.role_name " +
                     "FROM Reader r " +
                     "LEFT JOIN Role ro ON r.role_id = ro.role_id " +
                     "ORDER BY r.created_at DESC";
        
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
        String sql = "SELECT r.*, ro.role_name " +
                     "FROM Reader r " +
                     "LEFT JOIN Role ro ON r.role_id = ro.role_id " +
                     "ORDER BY r.created_at DESC " +
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
        String sql = "SELECT r.*, ro.role_name " +
                     "FROM Reader r " +
                     "LEFT JOIN Role ro ON r.role_id = ro.role_id " +
                     "WHERE r.full_name LIKE ? OR r.email LIKE ? OR r.phone LIKE ? " +
                     "ORDER BY r.created_at DESC " +
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
    
    public List<Reader> getReadersFiltered(String keyword, String status, int roleId, int page, int pageSize) {
        List<Reader> readers = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT r.*, ro.role_name ");
        sql.append("FROM Reader r ");
        sql.append("LEFT JOIN Role ro ON r.role_id = ro.role_id ");
        sql.append("WHERE 1=1 ");
        
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (r.full_name LIKE ? OR r.email LIKE ? OR r.phone LIKE ?) ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append("AND r.status = ? ");
        }
        if (roleId > 0) {
            sql.append("AND r.role_id = ? ");
        }
        
        sql.append("ORDER BY r.created_at DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(paramIndex++, kw);
                ps.setString(paramIndex++, kw);
                ps.setString(paramIndex++, kw);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            if (roleId > 0) {
                ps.setInt(paramIndex++, roleId);
            }
            
            int offset = (page - 1) * pageSize;
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    readers.add(mapResultSetToReader(rs));
                }
            }
            
            System.out.println("ReaderDAO.getReadersFiltered: keyword=" + keyword + 
                             ", status=" + status + ", roleId=" + roleId + 
                             ", page=" + page + " => " + readers.size() + " readers");
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.getReadersFiltered Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return readers;
    }
    
    public int countReadersFiltered(String keyword, String status, int roleId) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Reader r ");
        sql.append("WHERE 1=1 ");
        
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (r.full_name LIKE ? OR r.email LIKE ? OR r.phone LIKE ?) ");
        }
        if (status != null && !status.isEmpty()) {
            sql.append("AND r.status = ? ");
        }
        if (roleId > 0) {
            sql.append("AND r.role_id = ? ");
        }
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(paramIndex++, kw);
                ps.setString(paramIndex++, kw);
                ps.setString(paramIndex++, kw);
            }
            if (status != null && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            if (roleId > 0) {
                ps.setInt(paramIndex++, roleId);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (Exception e) {
            System.err.println("ReaderDAO.countReadersFiltered Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    public Reader getReaderById(int readerId) {
        String sql = "SELECT r.*, ro.role_name " +
                     "FROM Reader r " +
                     "LEFT JOIN Role ro ON r.role_id = ro.role_id " +
                     "WHERE r.reader_id = ?";
        
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
        String sql = "SELECT r.*, ro.role_name " +
                     "FROM Reader r " +
                     "LEFT JOIN Role ro ON r.role_id = ro.role_id " +
                     "WHERE r.email = ?";
        
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
        String sql = "INSERT INTO Reader (full_name, email, password_hash, phone, avatar, status, role_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reader.getFullName());
            ps.setString(2, reader.getEmail());
            ps.setString(3, reader.getPasswordHash());
            ps.setString(4, reader.getPhone());
            ps.setString(5, reader.getAvatar());
            ps.setString(6, reader.getStatus() != null ? reader.getStatus() : "active");
            ps.setInt(7, reader.getRoleId() > 0 ? reader.getRoleId() : 4); // 4 = USER mac dinh
            
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
                     "full_name = ?, email = ?, phone = ?, avatar = ?, status = ?, role_id = ? " +
                     "WHERE reader_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, reader.getFullName());
            ps.setString(2, reader.getEmail());
            ps.setString(3, reader.getPhone());
            ps.setString(4, reader.getAvatar());
            ps.setString(5, reader.getStatus());
            ps.setInt(6, reader.getRoleId() > 0 ? reader.getRoleId() : 4);
            ps.setInt(7, reader.getReaderId());
            
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
        String sql = "UPDATE Reader SET password_hash = ? WHERE reader_id = ?";
        
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
        String sql = "UPDATE Reader SET status = ? WHERE reader_id = ?";
        
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
        reader.setAvatar(rs.getString("avatar"));         
        reader.setStatus(rs.getString("status"));
        reader.setCreatedAt(rs.getTimestamp("created_at"));
        reader.setRoleId(rs.getInt("role_id"));          

        try {
            reader.setRoleName(rs.getString("role_name"));
        } catch (SQLException e) {
        }
        
        return reader;
    }
}