package dao;

import model.LinkedAccount;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * LinkedAccountDAO - Quản lý tài khoản OAuth liên kết
 * Tên bảng trong DB: Reader_Account
 * Cột: account_id, reader_id, provider, provider_user_id, provider_email,
 * created_at
 */
public class LinkedAccountDAO {

    private static final Logger LOGGER = Logger.getLogger(LinkedAccountDAO.class.getName());
    private Connection connection;

    public LinkedAccountDAO() throws SQLException {
        this.connection = DBUtil.getConnection();
    }

    public void close() {
        DBUtil.releaseConnection(connection);
    }

    /**
     * Liên kết tài khoản OAuth với Reader
     */
    public boolean linkAccount(LinkedAccount account) {
        String sql = "INSERT INTO Reader_Account (reader_id, provider, provider_user_id, provider_email) "
                + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, account.getReaderId());
            ps.setString(2, account.getProvider());
            ps.setString(3, account.getProviderUserId());
            ps.setString(4, account.getProviderEmail());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next())
                        account.setLinkId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error linking account", e);
        }
        return false;
    }

    /**
     * Gỡ liên kết tài khoản
     */
    public boolean unlinkAccount(int linkId, int readerId) {
        String sql = "DELETE FROM Reader_Account WHERE account_id = ? AND reader_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, linkId);
            ps.setInt(2, readerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error unlinking account", e);
        }
        return false;
    }

    /**
     * Lấy tất cả tài khoản liên kết của một Reader
     */
    public List<LinkedAccount> getLinkedAccounts(int readerId) {
        List<LinkedAccount> list = new ArrayList<>();
        String sql = "SELECT * FROM Reader_Account WHERE reader_id = ? ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting linked accounts", e);
        }
        return list;
    }

    /**
     * Tìm Reader theo provider + providerUserId (dùng khi Social Login)
     * 
     * @return readerId hoặc -1 nếu không tìm thấy
     */
    public int findReaderIdByProvider(String provider, String providerUserId) {
        String sql = "SELECT reader_id FROM Reader_Account WHERE provider = ? AND provider_user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, provider);
            ps.setString(2, providerUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt("reader_id");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding reader by provider", e);
        }
        return -1;
    }

    /**
     * Kiểm tra Reader đã liên kết provider này chưa
     */
    public boolean isLinked(int readerId, String provider) {
        // So sánh provider không phân biệt hoa thường để hỗ trợ cả dữ liệu cũ ("Google") và mới ("google")
        String sql = "SELECT COUNT(*) FROM Reader_Account WHERE reader_id = ? AND UPPER(provider) = UPPER(?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setString(2, provider);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking link", e);
        }
        return false;
    }

    private LinkedAccount mapRow(ResultSet rs) throws SQLException {
        LinkedAccount a = new LinkedAccount();
        a.setLinkId(rs.getInt("account_id")); // DB dùng account_id
        a.setReaderId(rs.getInt("reader_id"));
        a.setProvider(rs.getString("provider"));
        a.setProviderUserId(rs.getString("provider_user_id"));
        try {
            a.setProviderEmail(rs.getString("provider_email"));
        } catch (SQLException e) {
            /* cột mới */ }
        Timestamp t = rs.getTimestamp("created_at");
        if (t != null)
            a.setLinkedAt(t.toLocalDateTime());
        return a;
    }
}
