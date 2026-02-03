package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class CartItem {
    private int cartItemId;
    private int cartId;
    private int bookId;
    private int quantity;
    private LocalDateTime addedAt;
    
    // Related objects
    private Cart cart;
    private Book book;
    
    public CartItem() {
    }
    
    public CartItem(int cartId, int bookId, int quantity) {
        this.cartId = cartId;
        this.bookId = bookId;
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public int getCartItemId() {
        return cartItemId;
    }
    
    public void setCartItemId(int cartItemId) {
        this.cartItemId = cartItemId;
    }
    
    public int getCartId() {
        return cartId;
    }
    
    public void setCartId(int cartId) {
        this.cartId = cartId;
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
    
    public LocalDateTime getAddedAt() {
        return addedAt;
    }
    
    public void setAddedAt(LocalDateTime addedAt) {
        this.addedAt = addedAt;
    }
    
    public Cart getCart() {
        return cart;
    }
    
    public void setCart(Cart cart) {
        this.cart = cart;
        if (cart != null) {
            this.cartId = cart.getCartId();
        }
    }
    
    public Book getBook() {
        return book;
    }
    
    public void setBook(Book book) {
        this.book = book;
        if (book != null) {
            this.bookId = book.getBookId();
        }
    }
    
    /**
     * Tính tổng tiền cho item này (lấy giá từ Book)
     */
    public BigDecimal getSubtotal() {
        if (book == null || book.getPrice() == null || quantity <= 0) {
            return BigDecimal.ZERO;
        }
        return book.getPrice().multiply(BigDecimal.valueOf(quantity));
    }
    
    /**
     * Lấy currency từ Book
     */
    public String getCurrency() {
        return book != null && book.getCurrency() != null ? book.getCurrency() : "VND";
    }
}
