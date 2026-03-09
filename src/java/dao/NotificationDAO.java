package dao;

import model.Notification;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * NotificationDAO - Quản lý thông báo cho Reader
 * Cột thực tế: notification_id, reader_id, title, message, type, is_read,
 * created_at
 */
public class NotificationDAO {

    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());
    private Connection connection;

    public NotificationDAO() throws SQLException {
        this.connection = DBUtil.getConnection();
    }

    public void close() {
        DBUtil.releaseConnection(connection);
    }

    /**
     * Lấy danh sách thông báo của Reader (mới nhất trước)
     */
    public List<Notification> getNotifications(int readerId, int limit) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM Notification WHERE reader_id = ? ORDER BY created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting notifications", e);
        }
        return list;
    }

    /**
     * Lấy tất cả thông báo không giới hạn
     */
    public List<Notification> getAllNotifications(int readerId) {
        return getNotifications(readerId, 200);
    }

    /**
     * Đếm thông báo chưa đọc
     */
    public int getUnreadCount(int readerId) {
        String sql = "SELECT COUNT(*) FROM Notification WHERE reader_id = ? AND is_read = 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting unread", e);
        }
        return 0;
    }

    /**
     * Đánh dấu một thông báo đã đọc
     */
    public boolean markAsRead(int notificationId, int readerId) {
        String sql = "UPDATE Notification SET is_read = 1 WHERE notification_id = ? AND reader_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.setInt(2, readerId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking as read", e);
        }
        return false;
    }

    /**
     * Đánh dấu tất cả đã đọc
     */
    public boolean markAllAsRead(int readerId) {
        String sql = "UPDATE Notification SET is_read = 1 WHERE reader_id = ? AND is_read = 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking all as read", e);
        }
        return false;
    }

    /**
     * Tạo thông báo mới
     */
    public boolean createNotification(Notification n) {
        String sql = "INSERT INTO Notification (reader_id, title, message, type) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, n.getReaderId());
            ps.setNString(2, n.getTitle());
            ps.setNString(3, n.getMessage());
            ps.setString(4, n.getNotifType() != null ? n.getNotifType() : "general");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating notification", e);
        }
        return false;
    }

    private Notification mapRow(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getInt("notification_id"));
        n.setReaderId(rs.getInt("reader_id"));
        n.setTitle(rs.getNString("title"));
        n.setMessage(rs.getNString("message"));
        // Cột 'type' trong DB (không phải 'notif_type')
        try {
            n.setNotifType(rs.getString("type"));
        } catch (SQLException e) {
            try {
                n.setNotifType(rs.getString("notif_type"));
            } catch (SQLException e2) {
                n.setNotifType("general");
            }
        }
        n.setRead(rs.getBoolean("is_read"));
        Timestamp t = rs.getTimestamp("created_at");
        if (t != null)
            n.setCreatedAt(t.toLocalDateTime());
        return n;
    }
}
