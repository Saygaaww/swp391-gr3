package model;

import java.math.BigDecimal;

public class OrderBook {
    private int orderBookId;
    private int orderId;
    private int bookId;
    private int quantity;
    private BigDecimal price; // Giá tại thời điểm đặt hàng
    
    // Related objects
    private Order order;
    private Book book;
    
    public OrderBook() {
    }
    
    public OrderBook(int orderId, int bookId, int quantity, BigDecimal price) {
        this.orderId = orderId;
        this.bookId = bookId;
        this.quantity = quantity;
        this.price = price;
    }
    
    // Getters and Setters
    public int getOrderBookId() {
        return orderBookId;
    }
    
    public void setOrderBookId(int orderBookId) {
        this.orderBookId = orderBookId;
    }
    
    public int getOrderId() {
        return orderId;
    }
    
    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }
    
    public int getBookId() {
        return bookId;
    }
    
    public void setBookId(int bookId) {
        this.bookId = bookId;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
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
    
    public Book getBook() {
        return book;
    }
    
    public void setBook(Book book) {
        this.book = book;
        if (book != null) {
            this.bookId = book.getBookId();
            if (this.price == null && book.getPrice() != null) {
                this.price = book.getPrice();
            }
        }
    }
    
    /**
     * Tính subtotal (price * quantity)
     */
    public BigDecimal getSubtotal() {
        if (price == null || quantity <= 0) {
            return BigDecimal.ZERO;
        }
        return price.multiply(BigDecimal.valueOf(quantity));
    }
    
    /**
     * Lấy currency từ Order hoặc Book
     */
    public String getCurrency() {
        if (order != null && order.getCurrency() != null) {
            return order.getCurrency();
        }
        if (book != null && book.getCurrency() != null) {
            return book.getCurrency();
        }
        return "VND";
    }
}
