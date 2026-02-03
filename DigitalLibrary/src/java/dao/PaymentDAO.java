package dao;

import model.Payment;
import utils.DBConnection;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {
    
    /**
     * Tạo payment mới
     */
    public Payment createPayment(int orderId, String paymentMethod, BigDecimal amount) throws SQLException {
        String sql = "INSERT INTO Payment (order_id, payment_method, payment_status, amount, created_at) " +
                     "VALUES (?, ?, 'pending', ?, SYSUTCDATETIME())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, orderId);
            ps.setString(2, paymentMethod);
            ps.setBigDecimal(3, amount);
            
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int paymentId = rs.getInt(1);
                    return getPaymentById(paymentId);
                }
            }
        }
        return null;
    }
    
    /**
     * Lấy payment theo ID
     */
    public Payment getPaymentById(int paymentId) throws SQLException {
        String sql = "SELECT payment_id, order_id, payment_method, payment_status, amount, " +
                     "transaction_code, paid_at, created_at " +
                     "FROM Payment " +
                     "WHERE payment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, paymentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Lấy payment theo orderId
     */
    public Payment getPaymentByOrderId(int orderId) throws SQLException {
        String sql = "SELECT payment_id, order_id, payment_method, payment_status, amount, " +
                     "transaction_code, paid_at, created_at " +
                     "FROM Payment " +
                     "WHERE order_id = ? " +
                     "ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToPayment(rs);
                }
            }
        }
        return null;
    }
    
    /**
     * Cập nhật trạng thái thanh toán
     */
    public boolean updatePaymentStatus(int paymentId, String status, String transactionCode) throws SQLException {
        String sql = "UPDATE Payment SET payment_status = ?, transaction_code = ?, " +
                     "paid_at = CASE WHEN ? = 'success' THEN SYSUTCDATETIME() ELSE paid_at END " +
                     "WHERE payment_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, transactionCode);
            ps.setString(3, status);
            ps.setInt(4, paymentId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Lấy danh sách payments của reader (qua orders)
     */
    public List<Payment> getPaymentsByReaderId(int readerId, int offset, int limit) throws SQLException {
        List<Payment> payments = new ArrayList<>();
        String sql = "SELECT p.payment_id, p.order_id, p.payment_method, p.payment_status, p.amount, " +
                     "p.transaction_code, p.paid_at, p.created_at " +
                     "FROM Payment p " +
                     "INNER JOIN [Order] o ON p.order_id = o.order_id " +
                     "WHERE o.reader_id = ? " +
                     "ORDER BY p.created_at DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    payments.add(mapResultSetToPayment(rs));
                }
            }
        }
        return payments;
    }
    
    /**
     * Map ResultSet sang Payment object
     */
    private Payment mapResultSetToPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setOrderId(rs.getInt("order_id"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setPaymentStatus(rs.getString("payment_status"));
        payment.setAmount(rs.getBigDecimal("amount"));
        payment.setTransactionCode(rs.getString("transaction_code"));
        
        Timestamp paidAt = rs.getTimestamp("paid_at");
        if (paidAt != null) {
            payment.setPaidAt(paidAt.toLocalDateTime());
        }
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            payment.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        return payment;
    }
}
