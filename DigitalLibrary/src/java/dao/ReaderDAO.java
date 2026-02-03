package dao;

import model.Reader;
import model.Role;
import utils.DBConnection;
import utils.PasswordUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class ReaderDAO {
    
    public Reader getReaderByEmail(String email) throws SQLException {
        String sql = "SELECT r.reader_id, r.full_name, r.email, r.password_hash, r.phone, "
                   + "r.avatar, r.status, r.created_at, r.role_id, "
                   + "ro.role_name, ro.description "
                   + "FROM Reader r "
                   + "LEFT JOIN Role ro ON r.role_id = ro.role_id "
                   + "WHERE r.email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
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
                    if (createdAt != null) {
                        reader.setCreatedAt(createdAt.toLocalDateTime());
                    }
                    
                    reader.setRoleId(rs.getInt("role_id"));
                    
                    Role role = new Role();
                    role.setRoleId(rs.getInt("role_id"));
                    role.setRoleName(rs.getString("role_name"));
                    role.setDescription(rs.getString("description"));
                    reader.setRole(role);
                    
                    return reader;
                }
            }
        }
        return null;
    }
    
    public Reader getReaderById(int readerId) throws SQLException {
        String sql = "SELECT r.reader_id, r.full_name, r.email, r.password_hash, r.phone, "
                   + "r.avatar, r.status, r.created_at, r.role_id, "
                   + "ro.role_name, ro.description "
                   + "FROM Reader r "
                   + "LEFT JOIN Role ro ON r.role_id = ro.role_id "
                   + "WHERE r.reader_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
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
                    if (createdAt != null) {
                        reader.setCreatedAt(createdAt.toLocalDateTime());
                    }
                    
                    reader.setRoleId(rs.getInt("role_id"));
                    
                    Role role = new Role();
                    role.setRoleId(rs.getInt("role_id"));
                    role.setRoleName(rs.getString("role_name"));
                    role.setDescription(rs.getString("description"));
                    reader.setRole(role);
                    
                    return reader;
                }
            }
        }
        return null;
    }
    
    public boolean authenticate(String email, String password) throws SQLException {
        Reader reader = getReaderByEmail(email);
        if (reader != null && reader.getPasswordHash() != null) {
            return PasswordUtil.verifyPassword(password, reader.getPasswordHash());
        }
        return false;
    }
    
    public Reader createReader(String fullName, String email, String password, int roleId) throws SQLException {
        String sql = "INSERT INTO Reader (full_name, email, password_hash, role_id, status, created_at) "
                   + "VALUES (?, ?, ?, ?, 'active', SYSUTCDATETIME())";
        
        String passwordHash = PasswordUtil.hashPassword(password);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, passwordHash);
            ps.setInt(4, roleId);
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int readerId = rs.getInt(1);
                        return getReaderById(readerId);
                    }
                }
            }
        }
        return null;
    }
    
    public Reader createOrUpdateGoogleReader(String email, String fullName, String avatar, String providerUserId) throws SQLException {
        Reader existingReader = getReaderByEmail(email);
        
        if (existingReader != null) {
            // Update existing reader
            String updateSql = "UPDATE Reader SET full_name = ?, avatar = ? WHERE email = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(updateSql)) {
                ps.setString(1, fullName);
                ps.setString(2, avatar);
                ps.setString(3, email);
                ps.executeUpdate();
            }
            return getReaderByEmail(email);
        } else {
            // Create new reader with USER role (assuming role_id = 4 for USER)
            RoleDAO roleDAO = new RoleDAO();
            Role userRole = roleDAO.getRoleByName("USER");
            if (userRole == null) {
                throw new SQLException("USER role not found in database");
            }
            
            String randomPassword = PasswordUtil.generateRandomPassword();
            Reader newReader = createReader(fullName, email, randomPassword, userRole.getRoleId());
            
            if (newReader != null) {
                // Update avatar
                String updateSql = "UPDATE Reader SET avatar = ? WHERE reader_id = ?";
                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setString(1, avatar);
                    ps.setInt(2, newReader.getReaderId());
                    ps.executeUpdate();
                }
                
                // Create Reader_Account entry
                ReaderAccountDAO accountDAO = new ReaderAccountDAO();
                accountDAO.createReaderAccount(newReader.getReaderId(), "google", providerUserId);
                
                return getReaderById(newReader.getReaderId());
            }
        }
        return null;
    }
    
    /**
     * Lấy danh sách tất cả readers (có phân trang)
     */
    public java.util.List<Reader> getAllReaders(int offset, int limit) throws SQLException {
        java.util.List<Reader> readers = new java.util.ArrayList<>();
        String sql = "SELECT r.reader_id, r.full_name, r.email, r.password_hash, r.phone, "
                   + "r.avatar, r.status, r.created_at, r.role_id, "
                   + "ro.role_name, ro.description "
                   + "FROM Reader r "
                   + "LEFT JOIN Role ro ON r.role_id = ro.role_id "
                   + "WHERE r.status = 'active' "
                   + "ORDER BY r.created_at DESC "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    readers.add(mapResultSetToReader(rs));
                }
            }
        }
        return readers;
    }
    
    /**
     * Tìm kiếm readers theo email hoặc tên
     */
    public java.util.List<Reader> searchReaders(String keyword) throws SQLException {
        java.util.List<Reader> readers = new java.util.ArrayList<>();
        String sql = "SELECT r.reader_id, r.full_name, r.email, r.password_hash, r.phone, "
                   + "r.avatar, r.status, r.created_at, r.role_id, "
                   + "ro.role_name, ro.description "
                   + "FROM Reader r "
                   + "LEFT JOIN Role ro ON r.role_id = ro.role_id "
                   + "WHERE r.status = 'active' "
                   + "AND (r.email LIKE ? OR r.full_name LIKE ?) "
                   + "ORDER BY r.created_at DESC";
        
        String searchPattern = "%" + keyword + "%";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    readers.add(mapResultSetToReader(rs));
                }
            }
        }
        return readers;
    }
    
    /**
     * Map ResultSet thành Reader object
     */
    private Reader mapResultSetToReader(ResultSet rs) throws SQLException {
        Reader reader = new Reader();
        reader.setReaderId(rs.getInt("reader_id"));
        reader.setFullName(rs.getString("full_name"));
        reader.setEmail(rs.getString("email"));
        reader.setPasswordHash(rs.getString("password_hash"));
        reader.setPhone(rs.getString("phone"));
        reader.setAvatar(rs.getString("avatar"));
        reader.setStatus(rs.getString("status"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            reader.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        reader.setRoleId(rs.getInt("role_id"));
        
        Role role = new Role();
        role.setRoleId(rs.getInt("role_id"));
        role.setRoleName(rs.getString("role_name"));
        role.setDescription(rs.getString("description"));
        reader.setRole(role);
        
        return reader;
    }
}
