package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Payment {
    private int paymentId;
    private int orderId;
    private String paymentMethod; // cash, bank_transfer, credit_card, e_wallet, etc.
    private String paymentStatus; // pending, success, failed
    private BigDecimal amount;
    private String transactionCode; // Mã giao dịch từ payment gateway
    private LocalDateTime paidAt;
    private LocalDateTime createdAt;
    
    // Related objects
    private Order order;
    
    public Payment() {
    }
    
    public Payment(int orderId, String paymentMethod, String paymentStatus, BigDecimal amount) {
        this.orderId = orderId;
        this.paymentMethod = paymentMethod;
        this.paymentStatus = paymentStatus;
        this.amount = amount;
    }
    
    // Getters and Setters
    public int getPaymentId() {
        return paymentId;
    }
    
    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }
    
    public int getOrderId() {
        return orderId;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    
    public String getPaymentMethod() {
        return paymentMethod;
    }
    
    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }
    
    public String getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public String getTransactionCode() {
        return transactionCode;
    }
    
    public void setTransactionCode(String transactionCode) {
        this.transactionCode = transactionCode;
    }
    
    public LocalDateTime getPaidAt() {
        return paidAt;
    }
    
    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public Order getOrder() {
        return order;
    }
    
    public void setOrder(Order order) {
        this.order = order;
        if (order != null) {
            this.orderId = order.getOrderId();
        }
    }
    
    /**
     * Lấy phương thức thanh toán hiển thị bằng tiếng Việt
     */
    public String getPaymentMethodDisplay() {
        switch (paymentMethod != null ? paymentMethod.toLowerCase() : "") {
            case "cash":
                return "Tiền mặt";
            case "bank_transfer":
                return "Chuyển khoản";
            case "credit_card":
                return "Thẻ tín dụng";
            case "e_wallet":
                return "Ví điện tử";
            default:
                return paymentMethod != null ? paymentMethod : "Không xác định";
        }
    }
    
    /**
     * Lấy trạng thái thanh toán hiển thị bằng tiếng Việt
     */
    public String getPaymentStatusDisplay() {
        switch (paymentStatus != null ? paymentStatus.toLowerCase() : "") {
            case "pending":
                return "Chờ thanh toán";
            case "success":
                return "Đã thanh toán";
            case "failed":
                return "Thanh toán thất bại";
            default:
                return paymentStatus != null ? paymentStatus : "Không xác định";
        }
    }
}
