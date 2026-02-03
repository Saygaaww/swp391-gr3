package dao;

import model.ReaderAccount;
import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class ReaderAccountDAO {
    
    public ReaderAccount getAccountByProvider(String provider, String providerUserId) throws SQLException {
        String sql = "SELECT account_id, reader_id, provider, provider_user_id, created_at "
                   + "FROM Reader_Account "
                   + "WHERE provider = ? AND provider_user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, provider);
            ps.setString(2, providerUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ReaderAccount account = new ReaderAccount();
                    account.setAccountId(rs.getInt("account_id"));
                    account.setReaderId(rs.getInt("reader_id"));
                    account.setProvider(rs.getString("provider"));
                    account.setProviderUserId(rs.getString("provider_user_id"));
                    
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    if (createdAt != null) {
                        account.setCreatedAt(createdAt.toLocalDateTime());
                    }
                    
                    return account;
                }
            }
        }
        return null;
    }
    
    public ReaderAccount createReaderAccount(int readerId, String provider, String providerUserId) throws SQLException {
        String sql = "INSERT INTO Reader_Account (reader_id, provider, provider_user_id, created_at) "
                   + "VALUES (?, ?, ?, SYSUTCDATETIME())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, readerId);
            ps.setString(2, provider);
            ps.setString(3, providerUserId);
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int accountId = rs.getInt(1);
                        return getAccountByProvider(provider, providerUserId);
                    }
                }
            }
        }
        return null;
    }
}
