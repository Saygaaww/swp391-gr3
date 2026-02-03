package model;

import java.time.LocalDateTime;
import java.util.List;

public class Cart {
    private int cartId;
    private int readerId; // reader_id từ bảng Reader
    private String status; // active, checked_out, abandoned
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Related objects
    private List<CartItem> items;
    private Reader reader;
    
    public Cart() {
    }
    
    public Cart(int readerId) {
        this.readerId = readerId;
        this.status = "active";
    }
    
    // Getters and Setters
    public int getCartId() {
        return cartId;
    }
    
    public void setCartId(int cartId) {
        this.cartId = cartId;
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
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public List<CartItem> getItems() {
        return items;
    }
    
    public void setItems(List<CartItem> items) {
        this.items = items;
    }
    
    public Reader getReader() {
        return reader;
    }
    
    public void setReader(Reader reader) {
        this.reader = reader;
    }
    
    /**
     * Tính tổng tiền trong giỏ hàng (lấy giá từ Book)
     */
    public java.math.BigDecimal getTotalAmount() {
        if (items == null || items.isEmpty()) {
            return java.math.BigDecimal.ZERO;
        }
        return items.stream()
                .map(item -> {
                    if (item.getBook() != null && item.getBook().getPrice() != null) {
                        return item.getBook().getPrice().multiply(java.math.BigDecimal.valueOf(item.getQuantity()));
                    }
                    return java.math.BigDecimal.ZERO;
                })
                .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add);
    }
    
    /**
     * Đếm tổng số lượng sản phẩm trong giỏ
     */
    public int getTotalItems() {
        if (items == null || items.isEmpty()) {
            return 0;
        }
        return items.stream()
                .mapToInt(CartItem::getQuantity)
                .sum();
    }
}
