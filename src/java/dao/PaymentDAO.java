package dao;

import model.Payment;
import util.DBContext;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;

/**
 * DAO thanh toán (Payment): tạo bản ghi thanh toán (COD/VNPay), lấy theo order_id, cập nhật trạng thái (success/pending).
 */
public class PaymentDAO {

    /**
     * Tạo bản ghi Payment (order_id, amount, payment_method, transaction_code, status pending). Trả về payment_id hoặc -1.
     */
    public int createPayment(int orderId, BigDecimal amount, String paymentMethod, String transactionCode) {
        String sql = """
            INSERT INTO Payment(order_id, amount, payment_method, payment_status, transaction_code)
            VALUES (?, ?, ?, 'pending', ?)
            """;
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, orderId);
            ps.setBigDecimal(2, amount);
            ps.setString(3, paymentMethod);
            ps.setString(4, transactionCode);
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Lấy payment theo order_id (dùng xem chi tiết đơn, xác nhận thanh toán).
     */
    public Payment getByOrderId(int orderId) {
        String sql = "SELECT * FROM Payment WHERE order_id = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private Payment map(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPaymentId(rs.getInt("payment_id"));
        p.setOrderId(rs.getInt("order_id"));
        p.setAmount(rs.getBigDecimal("amount"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setPaymentStatus(rs.getString("payment_status"));
        p.setTransactionCode(rs.getString("transaction_code"));
        Timestamp paidAt = rs.getTimestamp("paid_at");
        p.setPaidAt(paidAt != null ? paidAt.toLocalDateTime() : null);
        Timestamp createdAt = rs.getTimestamp("created_at");
        p.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
        return p;
    }

    /**
     * Cập nhật payment_status và transaction_code; nếu status = success thì set paid_at = now.
     */
    public boolean updatePaymentStatus(int orderId, String status, String transactionCode) {
        String sql = "UPDATE Payment SET payment_status = ?, transaction_code = ?, paid_at = ? WHERE order_id = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, transactionCode);
            ps.setTimestamp(3, "success".equals(status) ? Timestamp.valueOf(LocalDateTime.now()) : null);
            ps.setInt(4, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
