package dao;

import model.Order;
import model.OrderBook;
import model.TopSellingBook;
import util.DBContext;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO đơn hàng (Order, Order_Book): tạo đơn, thêm sách vào đơn, lấy đơn theo reader/date range, cập nhật trạng thái, top sách bán chạy. Tiền VND.
 */
public class OrderDAO {

    /**
     * Tạo đơn mới (status pending). Trả về order_id (generated key) hoặc -1.
     */
    public int createOrder(int readerId, BigDecimal totalAmount, String currency) {
        String sql = """
            INSERT INTO [Order](reader_id, total_amount, currency, status)
            VALUES (?, ?, ?, 'pending')
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, readerId);
            ps.setBigDecimal(2, totalAmount);
            ps.setString(3, currency);

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Thêm một dòng sách vào đơn (Order_Book): book_id, price, quantity.
     */
    public boolean addOrderBook(int orderId, int bookId, BigDecimal price, int quantity) {
        String sql = """
            INSERT INTO Order_Book(order_id, book_id, price, quantity)
            VALUES (?, ?, ?, ?)
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setInt(2, bookId);
            ps.setBigDecimal(3, price);
            ps.setInt(4, quantity);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy đơn theo order_id (JOIN Reader: full_name, email); load OrderBooks (getOrderBooks).
     */
    public Order getOrderById(int orderId) {
        String sql = """
            SELECT o.*, r.full_name, r.email
            FROM [Order] o
            JOIN Reader r ON o.reader_id = r.reader_id
            WHERE o.order_id = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Order order = mapOrder(rs);
                order.setOrderBooks(getOrderBooks(orderId));
                return order;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy tất cả đơn của một reader, sắp xếp created_at DESC; mỗi đơn có danh sách OrderBooks.
     */
    public List<Order> getOrdersByReader(int readerId) {
        List<Order> orders = new ArrayList<>();
        String sql = """
            SELECT o.*, r.full_name, r.email
            FROM [Order] o
            JOIN Reader r ON o.reader_id = r.reader_id
            WHERE o.reader_id = ?
            ORDER BY o.created_at DESC
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Order order = mapOrder(rs);
                order.setOrderBooks(getOrderBooks(order.getOrderId()));
                orders.add(order);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Lấy tất cả đơn (admin/seller), JOIN Reader, ORDER BY created_at DESC; mỗi đơn có OrderBooks.
     */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = """
            SELECT o.*, r.full_name, r.email
            FROM [Order] o
            JOIN Reader r ON o.reader_id = r.reader_id
            ORDER BY o.created_at DESC
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = mapOrder(rs);
                order.setOrderBooks(getOrderBooks(order.getOrderId()));
                orders.add(order);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    /** Lấy danh sách Order_Book của đơn (JOIN Book, Author: title, cover_url, author_name). */
    private List<OrderBook> getOrderBooks(int orderId) {
        List<OrderBook> orderBooks = new ArrayList<>();
        String sql = """
            SELECT ob.*, b.title, b.cover_url, a.author_name
            FROM Order_Book ob
            JOIN Book b ON ob.book_id = b.book_id
            LEFT JOIN Author a ON b.author_id = a.author_id
            WHERE ob.order_id = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                orderBooks.add(mapOrderBook(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderBooks;
    }

    /**
     * Cập nhật trạng thái đơn: pending, paid, cancelled, refunded.
     */
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE [Order] SET status = ? WHERE order_id = ?";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, orderId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy đơn theo khoảng ngày (created_at): fromDate, toDate (format date). Dùng cho báo cáo bán hàng.
     */
    public List<Order> getOrdersByDateRange(String fromDate, String toDate) {
        List<Order> orders = new ArrayList<>();
        String sql = """
            SELECT o.*, r.full_name, r.email
            FROM [Order] o
            JOIN Reader r ON o.reader_id = r.reader_id
            WHERE 1=1
        """;
        if (fromDate != null && !fromDate.isEmpty()) sql += " AND CAST(o.created_at AS DATE) >= ?";
        if (toDate != null && !toDate.isEmpty()) sql += " AND CAST(o.created_at AS DATE) <= ?";
        sql += " ORDER BY o.created_at DESC";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            int idx = 1;
            if (fromDate != null && !fromDate.isEmpty()) ps.setString(idx++, fromDate);
            if (toDate != null && !toDate.isEmpty()) ps.setString(idx++, toDate);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapOrder(rs);
                order.setOrderBooks(getOrderBooks(order.getOrderId()));
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    /**
     * Top sách bán chạy: chỉ đơn paid; GROUP BY book, SUM(quantity), SUM(price*quantity); ORDER BY total_quantity DESC; giới hạn limit.
     */
    public List<TopSellingBook> getTopSellingBooks(int limit) {
        List<TopSellingBook> list = new ArrayList<>();
        String sql = """
            SELECT TOP (?) b.book_id, b.title, a.author_name,
                   SUM(ob.quantity) AS total_quantity,
                   SUM(ob.price * ob.quantity) AS total_revenue
            FROM Order_Book ob
            JOIN [Order] o ON ob.order_id = o.order_id
            JOIN Book b ON ob.book_id = b.book_id
            LEFT JOIN Author a ON b.author_id = a.author_id
            WHERE o.status = 'paid'
            GROUP BY b.book_id, b.title, a.author_name
            ORDER BY total_quantity DESC
            """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit > 0 ? limit : 10);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TopSellingBook t = new TopSellingBook();
                t.setBookId(rs.getInt("book_id"));
                t.setTitle(rs.getString("title"));
                t.setAuthorName(rs.getString("author_name"));
                t.setTotalQuantity(rs.getInt("total_quantity"));
                t.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Ánh xạ ResultSet → Order (kèm full_name, email, created_at). */
    private Order mapOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setReaderId(rs.getInt("reader_id"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setCurrency(rs.getString("currency"));
        order.setStatus(rs.getString("status"));
        order.setReaderName(rs.getString("full_name"));
        order.setReaderEmail(rs.getString("email"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) order.setCreatedAt(ts.toLocalDateTime());
        return order;
    }

    /** Ánh xạ ResultSet → OrderBook (kèm title, cover_url, author_name). */
    private OrderBook mapOrderBook(ResultSet rs) throws SQLException {
        OrderBook ob = new OrderBook();
        ob.setOrderBookId(rs.getInt("order_book_id"));
        ob.setOrderId(rs.getInt("order_id"));
        ob.setBookId(rs.getInt("book_id"));
        ob.setPrice(rs.getBigDecimal("price"));
        ob.setQuantity(rs.getInt("quantity"));
        ob.setBookTitle(rs.getString("title"));
        ob.setBookCoverUrl(rs.getString("cover_url"));
        ob.setAuthorName(rs.getString("author_name"));
        return ob;
    }
}
