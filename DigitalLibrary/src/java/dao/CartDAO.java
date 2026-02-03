package dao;

import model.Cart;
import model.CartItem;
import model.Book;
import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    
    /**
     * Lấy hoặc tạo giỏ hàng cho reader
     */
    public Cart getOrCreateCart(int readerId) throws SQLException {
        Cart cart = getCartByReaderId(readerId);
        if (cart == null) {
            cart = createCart(readerId);
        }
        return cart;
    }
    
    /**
     * Lấy giỏ hàng theo readerId (chỉ lấy cart có status = 'active')
     */
    public Cart getCartByReaderId(int readerId) throws SQLException {
        String sql = "SELECT cart_id, reader_id, status, created_at, updated_at " +
                     "FROM Cart " +
                     "WHERE reader_id = ? AND status = 'active'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Cart cart = mapResultSetToCart(rs);
                    cart.setItems(getCartItems(cart.getCartId()));
                    return cart;
                }
            }
        }
        return null;
    }
    
    /**
     * Tạo giỏ hàng mới cho reader
     */
    public Cart createCart(int readerId) throws SQLException {
        String sql = "INSERT INTO Cart (reader_id, status, created_at) " +
                     "VALUES (?, 'active', SYSUTCDATETIME())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, readerId);
            ps.executeUpdate();
            
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int cartId = rs.getInt(1);
                    return getCartById(cartId);
                }
            }
        }
        return null;
    }
    
    /**
     * Lấy giỏ hàng theo cartId
     */
    public Cart getCartById(int cartId) throws SQLException {
        String sql = "SELECT cart_id, reader_id, status, created_at, updated_at " +
                     "FROM Cart " +
                     "WHERE cart_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Cart cart = mapResultSetToCart(rs);
                    cart.setItems(getCartItems(cartId));
                    return cart;
                }
            }
        }
        return null;
    }
    
    /**
     * Thêm sản phẩm vào giỏ hàng hoặc cập nhật số lượng nếu đã có
     * @param cartId ID của cart
     * @param bookId ID của sách
     * @param quantity Số lượng (phải > 0 và <= 999)
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean addToCart(int cartId, int bookId, int quantity) throws SQLException {
        // Validate quantity
        if (quantity <= 0 || quantity > 999) {
            return false;
        }
        
        // Kiểm tra xem item đã tồn tại chưa
        CartItem existingItem = getCartItem(cartId, bookId);
        
        if (existingItem != null) {
            // Cập nhật số lượng (tổng không được vượt quá 999)
            int newQuantity = existingItem.getQuantity() + quantity;
            if (newQuantity > 999) {
                newQuantity = 999; // Giới hạn tối đa
            }
            return updateCartItemQuantity(existingItem.getCartItemId(), newQuantity);
        } else {
            // Thêm mới
            String sql = "INSERT INTO Cart_Item (cart_id, book_id, quantity, added_at) " +
                         "VALUES (?, ?, ?, SYSUTCDATETIME())";
            
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, cartId);
                ps.setInt(2, bookId);
                ps.setInt(3, quantity);
                
                int result = ps.executeUpdate();
                if (result > 0) {
                    updateCartTimestamp(cartId);
                    return true;
                }
            }
        }
        return false;
    }
    
    /**
     * Cập nhật số lượng của cart item
     * @param cartItemId ID của cart item
     * @param quantity Số lượng mới (nếu <= 0 sẽ xóa item)
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateCartItemQuantity(int cartItemId, int quantity) throws SQLException {
        // Validate quantity
        if (quantity < 0) {
            return false; // Không cho phép số âm
        }
        
        if (quantity == 0) {
            return removeCartItem(cartItemId);
        }
        
        // Validate quantity không quá lớn (999)
        if (quantity > 999) {
            return false;
        }
        
        String sql = "UPDATE Cart_Item SET quantity = ? WHERE cart_item_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartItemId);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                // Lấy cartId để update timestamp
                CartItem item = getCartItemById(cartItemId);
                if (item != null) {
                    updateCartTimestamp(item.getCartId());
                }
                return true;
            }
        }
        return false;
    }
    
    /**
     * Xóa item khỏi giỏ hàng
     */
    public boolean removeCartItem(int cartItemId) throws SQLException {
        // Lấy cartId trước khi xóa để update timestamp sau
        CartItem item = getCartItemById(cartItemId);
        int cartId = -1;
        if (item != null) {
            cartId = item.getCartId();
        }
        
        String sql = "DELETE FROM Cart_Item WHERE cart_item_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartItemId);
            
            int result = ps.executeUpdate();
            if (result > 0) {
                // Update timestamp của cart
                if (cartId > 0) {
                    updateCartTimestamp(cartId);
                }
                return true;
            }
        }
        return false;
    }
    
    /**
     * Xóa tất cả items trong giỏ hàng
     */
    public boolean clearCart(int cartId) throws SQLException {
        String sql = "DELETE FROM Cart_Item WHERE cart_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.executeUpdate();
            updateCartTimestamp(cartId);
            return true;
        }
    }
    
    /**
     * Đánh dấu cart là checked_out
     */
    public boolean markCartAsCheckedOut(int cartId) throws SQLException {
        String sql = "UPDATE Cart SET status = 'checked_out', updated_at = SYSUTCDATETIME() WHERE cart_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Lấy danh sách cart items
     */
    public List<CartItem> getCartItems(int cartId) throws SQLException {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT ci.cart_item_id, ci.cart_id, ci.book_id, ci.quantity, ci.added_at, " +
                     "b.title, b.cover_url, b.status, b.price, b.currency, b.stock " +
                     "FROM Cart_Item ci " +
                     "INNER JOIN Book b ON ci.book_id = b.book_id " +
                     "WHERE ci.cart_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartItemId(rs.getInt("cart_item_id"));
                    item.setCartId(rs.getInt("cart_id"));
                    item.setBookId(rs.getInt("book_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    
                    Timestamp addedAt = rs.getTimestamp("added_at");
                    if (addedAt != null) {
                        item.setAddedAt(addedAt.toLocalDateTime());
                    }
                    
                    // Set Book object
                    Book book = new Book();
                    book.setBookId(rs.getInt("book_id"));
                    book.setTitle(rs.getString("title"));
                    book.setCoverUrl(rs.getString("cover_url"));
                    book.setStatus(rs.getString("status"));
                    book.setPrice(rs.getBigDecimal("price"));
                    book.setCurrency(rs.getString("currency"));
                    
                    // Set stock (có thể không tồn tại trong DB cũ)
                    try {
                        int stock = rs.getInt("stock");
                        if (!rs.wasNull()) {
                            book.setStock(stock);
                        }
                    } catch (SQLException e) {
                        // Column might not exist yet, ignore
                        book.setStock(null);
                    }
                    
                    item.setBook(book);
                    
                    items.add(item);
                }
            }
        }
        return items;
    }
    
    /**
     * Lấy cart item theo cartId và bookId
     */
    public CartItem getCartItem(int cartId, int bookId) throws SQLException {
        String sql = "SELECT cart_item_id, cart_id, book_id, quantity, added_at " +
                     "FROM Cart_Item " +
                     "WHERE cart_id = ? AND book_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartItemId(rs.getInt("cart_item_id"));
                    item.setCartId(rs.getInt("cart_id"));
                    item.setBookId(rs.getInt("book_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    
                    Timestamp addedAt = rs.getTimestamp("added_at");
                    if (addedAt != null) {
                        item.setAddedAt(addedAt.toLocalDateTime());
                    }
                    return item;
                }
            }
        }
        return null;
    }
    
    /**
     * Lấy cart item theo cartItemId
     */
    public CartItem getCartItemById(int cartItemId) throws SQLException {
        String sql = "SELECT cart_item_id, cart_id, book_id, quantity, added_at " +
                     "FROM Cart_Item " +
                     "WHERE cart_item_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartItemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartItemId(rs.getInt("cart_item_id"));
                    item.setCartId(rs.getInt("cart_id"));
                    item.setBookId(rs.getInt("book_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    
                    Timestamp addedAt = rs.getTimestamp("added_at");
                    if (addedAt != null) {
                        item.setAddedAt(addedAt.toLocalDateTime());
                    }
                    return item;
                }
            }
        }
        return null;
    }
    
    /**
     * Map ResultSet sang Cart object
     */
    private Cart mapResultSetToCart(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setCartId(rs.getInt("cart_id"));
        cart.setReaderId(rs.getInt("reader_id"));
        cart.setStatus(rs.getString("status"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            cart.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            cart.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return cart;
    }
    
    /**
     * Cập nhật timestamp của cart
     */
    private void updateCartTimestamp(int cartId) throws SQLException {
        String sql = "UPDATE Cart SET updated_at = SYSUTCDATETIME() WHERE cart_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.executeUpdate();
        }
    }
}
