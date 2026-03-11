package dao;

import model.Reader;
import util.DBUtil;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ReaderDAO - Data access cho tài khoản Reader
 * Dùng tên cột snake_case theo schema thực tế của DB:
 * reader_id, full_name, email, password_hash, avatar_url, phone, role_id,
 * status, created_at, updated_at
 */
public class ReaderDAO {

    private static final Logger LOGGER = Logger.getLogger(ReaderDAO.class.getName());
    private Connection connection;

    public ReaderDAO() throws SQLException {
        this.connection = DBUtil.getConnection();
    }

    public void close() {
        DBUtil.releaseConnection(connection);
    }

    // ==================== CREATE ====================

    /**
     * Tạo tài khoản Reader mới
     */
    public boolean createReader(Reader reader) {
        // role_id = 4 là 'USER' theo bảng Role trong DB (1=ADMIN, 2=LIBRARIAN,
        // 3=SELLER, 4=USER)
        String sql = "INSERT INTO Reader (full_name, email, phone, password_hash, avatar_url, status, role_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, 4)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setNString(1, reader.getFullName());
            ps.setString(2, reader.getEmail());
            ps.setString(3, reader.getPhone());
            ps.setString(4, reader.getPasswordHash());
            ps.setString(5, reader.getAvatarUrl());
            ps.setString(6, reader.getStatus() != null ? reader.getStatus() : "active");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        reader.setReaderId(rs.getInt(1));
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating reader: " + reader.getEmail(), e);
        }
        return false;
    }

    // ==================== READ ====================

    /**
     * Tìm Reader theo email
     */
    public Reader findByEmail(String email) {
        String sql = "SELECT * FROM Reader WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapRow(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding reader by email: " + email, e);
        }
        return null;
    }

    /**
     * Tìm Reader theo ID
     */
    public Reader findById(int readerId) {
        String sql = "SELECT * FROM Reader WHERE reader_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapRow(rs);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding reader by id: " + readerId, e);
        }
        return null;
    }

    /**
     * Kiểm tra email đã tồn tại chưa
     */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Reader WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking email: " + email, e);
        }
        return false;
    }

    // ==================== UPDATE ====================

    /**
     * Cập nhật thông tin profile (tên, phone, avatar)
     */
    public boolean updateProfile(Reader reader) {
        String sql = "UPDATE Reader SET full_name = ?, phone = ?, avatar_url = ?, updated_at = GETDATE() "
                + "WHERE reader_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setNString(1, reader.getFullName());
            ps.setString(2, reader.getPhone());
            ps.setString(3, reader.getAvatarUrl());
            ps.setInt(4, reader.getReaderId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating profile: " + reader.getReaderId(), e);
        }
        return false;
    }

    /**
     * Cập nhật password hash
     */
    public boolean updatePasswordHash(int readerId, String newPasswordHash) {
        String sql = "UPDATE Reader SET password_hash = ?, updated_at = GETDATE() WHERE reader_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, readerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating password: " + readerId, e);
        }
        return false;
    }

    // ==================== PASSWORD RESET ====================

    /**
     * Lưu token đặt lại mật khẩu (hết hạn sau 1 giờ)
     */
    public boolean saveResetToken(int readerId, String token) {
        String invalidate = "UPDATE PasswordResetToken SET is_used = 1 WHERE reader_id = ? AND is_used = 0";
        String insert = "INSERT INTO PasswordResetToken (reader_id, token, expires_at) "
                + "VALUES (?, ?, DATEADD(HOUR, 1, GETDATE()))";
        try {
            try (PreparedStatement ps = connection.prepareStatement(invalidate)) {
                ps.setInt(1, readerId);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = connection.prepareStatement(insert)) {
                ps.setInt(1, readerId);
                ps.setString(2, token);
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error saving reset token", e);
        }
        return false;
    }

    /**
     * Xác minh token và lấy readerId
     * 
     * @return readerId nếu hợp lệ, -1 nếu không hợp lệ/hết hạn
     */
    public int validateResetToken(String token) {
        String sql = "SELECT reader_id FROM PasswordResetToken "
                + "WHERE token = ? AND is_used = 0 AND expires_at > GETDATE()";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt("reader_id");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error validating reset token", e);
        }
        return -1;
    }

    /**
     * Đánh dấu token đã sử dụng
     */
    public boolean markTokenUsed(String token) {
        String sql = "UPDATE PasswordResetToken SET is_used = 1 WHERE token = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, token);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking token used", e);
        }
        return false;
    }

    // ==================== Row Mapper ====================

    private Reader mapRow(ResultSet rs) throws SQLException {
        Reader r = new Reader();
        r.setReaderId(rs.getInt("reader_id"));
        r.setFullName(rs.getNString("full_name"));
        r.setEmail(rs.getString("email"));
        r.setPasswordHash(rs.getString("password_hash"));
        r.setPhone(rs.getString("phone"));
        r.setStatus(rs.getString("status"));

        // avatar_url có thể chưa có nếu migration chưa chạy xong
        try {
            r.setAvatarUrl(rs.getString("avatar_url"));
        } catch (SQLException e) {
            /* cột chưa tồn tại */ }

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null)
            r.setCreatedAt(createdAt.toLocalDateTime());

        try {
            Timestamp updatedAt = rs.getTimestamp("updated_at");
            if (updatedAt != null)
                r.setUpdatedAt(updatedAt.toLocalDateTime());
        } catch (SQLException e) {
            /* cột chưa tồn tại */ }

        return r;
    }
}
