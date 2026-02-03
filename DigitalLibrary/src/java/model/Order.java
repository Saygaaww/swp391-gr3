package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class Order {
    private int orderId;
    private int readerId; // reader_id từ bảng Reader
    private String status; // pending, paid, cancelled, refunded
    private BigDecimal totalAmount;
    private String currency;
    private LocalDateTime createdAt;
    
    // Related objects
    private List<OrderBook> items;
    private Payment payment;
    private Reader reader;
    
    public Order() {
    }
    
    public Order(int readerId, String status, BigDecimal totalAmount, String currency) {
        this.readerId = readerId;
        this.status = status;
        this.totalAmount = totalAmount;
        this.currency = currency;
    }
    
    // Getters and Setters
    public int getOrderId() {
        return orderId;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    
    public int getReaderId() {
        return readerId;
    }
    
    public void setReaderId(int readerId) {
        this.readerId = readerId;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getCurrency() {
        return currency;
    }
    
    public void setCurrency(String currency) {
        this.currency = currency;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public List<OrderBook> getItems() {
        return items;
    }
    
    public void setItems(List<OrderBook> items) {
        this.items = items;
    }
    
    public Payment getPayment() {
        return payment;
    }
    
    public void setPayment(Payment payment) {
        this.payment = payment;
    }
    
    public Reader getReader() {
        return reader;
    }
    
    public void setReader(Reader reader) {
        this.reader = reader;
    }
    
    /**
     * Lấy trạng thái hiển thị bằng tiếng Việt
     */
    public String getStatusDisplay() {
        switch (status != null ? status.toLowerCase() : "") {
            case "pending":
                return "Chờ thanh toán";
            case "paid":
                return "Đã thanh toán";
            case "cancelled":
                return "Đã hủy";
            case "refunded":
                return "Đã hoàn tiền";
            default:
                return status != null ? status : "Không xác định";
        }
    }
}
