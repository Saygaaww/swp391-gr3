package dao;

import model.Order;
import model.OrderBook;
import model.Book;
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

public class OrderDAO {
    
    /**
     * Tạo đơn hàng mới từ giỏ hàng
     */
    public Order createOrder(int readerId, List<OrderBook> items) throws SQLException {
        // Tính tổng tiền
        BigDecimal totalAmount = items.stream()
                .map(OrderBook::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        String currency = items.isEmpty() ? "VND" : items.get(0).getCurrency();
        
        String sql = "INSERT INTO [Order] (reader_id, status, total_amount, currency, created_at) " +
                     "VALUES (?, 'pending', ?, ?, SYSUTCDATETIME())";
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            try (PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, readerId);
                ps.setBigDecimal(2, totalAmount);
                ps.setString(3, currency);
                
                ps.executeUpdate();
                
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int orderId = rs.getInt(1);
                        
                        // Thêm order books
                        for (OrderBook item : items) {
                            insertOrderBook(conn, orderId, item);
                        }
                        
                        conn.commit(); // Commit transaction
                        return getOrderById(orderId);
                    }
                }
            }
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback(); // Rollback nếu có lỗi
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
        
        return null;
    }
    
    /**
     * Thêm order book vào database
     */
    private void insertOrderBook(Connection conn, int orderId, OrderBook item) throws SQLException {
        String sql = "INSERT INTO Order_Book (order_id, book_id, quantity, price) " +
                     "VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, item.getBookId());
            ps.setInt(3, item.getQuantity());
            ps.setBigDecimal(4, item.getPrice());
            ps.executeUpdate();
        }
    }
    
    /**
     * Lấy đơn hàng theo ID
     */
    public Order getOrderById(int orderId) throws SQLException {
        String sql = "SELECT order_id, reader_id, status, total_amount, currency, created_at " +
                     "FROM [Order] " +
                     "WHERE order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    order.setItems(getOrderBooks(orderId));
                    return order;
                }
            }
        }
        return null;
    }
    
    /**
     * Lấy danh sách đơn hàng của reader
     */
    public List<Order> getOrdersByReaderId(int readerId, int offset, int limit) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT order_id, reader_id, status, total_amount, currency, created_at " +
                     "FROM [Order] " +
                     "WHERE reader_id = ? " +
                     "ORDER BY created_at DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    orders.add(order);
                }
            }
        }
        return orders;
    }
    
    /**
     * Đếm tổng số đơn hàng của reader
     */
    public int countOrdersByReaderId(int readerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM [Order] WHERE reader_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Cập nhật trạng thái đơn hàng
     */
    public boolean updateOrderStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE [Order] SET status = ? WHERE order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }
    
    /**
     * Lấy tất cả đơn hàng (cho Seller/Admin xem)
     */
    public List<Order> getAllOrders(int offset, int limit) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT order_id, reader_id, status, total_amount, currency, created_at " +
                     "FROM [Order] " +
                     "ORDER BY created_at DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    orders.add(order);
                }
            }
        }
        return orders;
    }
    
    /**
     * Đếm tổng số đơn hàng
     */
    public int countAllOrders() throws SQLException {
        String sql = "SELECT COUNT(*) FROM [Order]";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * Tính tổng doanh thu (từ các đơn hàng đã thanh toán)
     */
    public BigDecimal getTotalRevenue() throws SQLException {
        String sql = "SELECT SUM(total_amount) FROM [Order] WHERE status = 'paid'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                BigDecimal revenue = rs.getBigDecimal(1);
                return revenue != null ? revenue : BigDecimal.ZERO;
            }
        }
        return BigDecimal.ZERO;
    }
    
    /**
     * Đếm số đơn hàng theo trạng thái
     */
    public int countOrdersByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM [Order] WHERE status = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
    
    /**
     * Lấy đơn hàng với filter theo status
     */
    public List<Order> getOrdersByStatus(String status, int offset, int limit) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT order_id, reader_id, status, total_amount, currency, created_at " +
                     "FROM [Order] " +
                     "WHERE status = ? " +
                     "ORDER BY created_at DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapResultSetToOrder(rs);
                    orders.add(order);
                }
            }
        }
        return orders;
    }
    
    /**
     * Lấy danh sách order books
     */
    public List<OrderBook> getOrderBooks(int orderId) throws SQLException {
        List<OrderBook> items = new ArrayList<>();
        String sql = "SELECT ob.order_book_id, ob.order_id, ob.book_id, ob.quantity, ob.price, " +
                     "b.title, b.cover_url " +
                     "FROM Order_Book ob " +
                     "INNER JOIN Book b ON ob.book_id = b.book_id " +
                     "WHERE ob.order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderBook item = new OrderBook();
                    item.setOrderBookId(rs.getInt("order_book_id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setBookId(rs.getInt("book_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getBigDecimal("price"));
                    
                    // Set Book object
                    Book book = new Book();
                    book.setBookId(rs.getInt("book_id"));
                    book.setTitle(rs.getString("title"));
                    book.setCoverUrl(rs.getString("cover_url"));
                    item.setBook(book);
                    
                    items.add(item);
                }
            }
        }
        return items;
    }
    
    /**
     * Map ResultSet sang Order object
     */
    private Order mapResultSetToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setReaderId(rs.getInt("reader_id"));
        order.setStatus(rs.getString("status"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setCurrency(rs.getString("currency"));
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            order.setCreatedAt(createdAt.toLocalDateTime());
        }
        
        return order;
    }
}
