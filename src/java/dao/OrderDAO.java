package dao;

import model.Order;
import model.OrderBook;
import model.TopSellingBook;
import util.DBUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /* ================= CREATE ORDER ================= */
    public int createOrder(int readerId, BigDecimal totalAmount, String currency) {
        String sql = """
                    INSERT INTO [Order](reader_id, total_amount, currency, status)
                    VALUES (?, ?, ?, 'pending')
                """;

        try (Connection con = DBUtil.getConnection();
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

    /* ================= ADD ORDER BOOK ================= */
    public boolean addOrderBook(int orderId, int bookId, BigDecimal price, int quantity) {
        String sql = """
                    INSERT INTO Order_Book(order_id, book_id, price, quantity)
                    VALUES (?, ?, ?, ?)
                """;

        try (Connection con = DBUtil.getConnection();
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

    /* ================= GET ORDER BY ID ================= */
    public Order getOrderById(int orderId) {
        String sql = """
                    SELECT o.*, r.full_name, r.email
                    FROM [Order] o
                    JOIN Reader r ON o.reader_id = r.reader_id
                    WHERE o.order_id = ?
                """;

        try (Connection con = DBUtil.getConnection();
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

    /* ================= GET ORDERS BY READER ================= */
    public List<Order> getOrdersByReader(int readerId) {
        List<Order> orders = new ArrayList<>();
        String sql = """
                    SELECT o.*, r.full_name, r.email
                    FROM [Order] o
                    JOIN Reader r ON o.reader_id = r.reader_id
                    WHERE o.reader_id = ?
                    ORDER BY o.created_at DESC
                """;

        try (Connection con = DBUtil.getConnection();
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

    /* ================= GET ALL ORDERS (Admin/Seller) ================= */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = """
                    SELECT o.*, r.full_name, r.email
                    FROM [Order] o
                    JOIN Reader r ON o.reader_id = r.reader_id
                    ORDER BY o.created_at DESC
                """;

        try (Connection con = DBUtil.getConnection();
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

    /* ================= COUNTS / AGGREGATES (Sales Analytics) ================= */
    public int countAllOrders() {
        String sql = "SELECT COUNT(*) FROM [Order]";
        try (Connection con = DBUtil.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countOrdersByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM [Order] WHERE status = ?";
        try (Connection con = DBUtil.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public BigDecimal sumTotalAmountByStatus(String status) {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM [Order] WHERE status = ?";
        try (Connection con = DBUtil.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    /* ================= GET ORDER BOOKS ================= */
    private List<OrderBook> getOrderBooks(int orderId) {
        List<OrderBook> orderBooks = new ArrayList<>();
        String sql = """
                    SELECT ob.*, b.Title AS title, b.CoverURL AS cover_url, a.AuthorName AS author_name
                    FROM Order_Book ob
                    JOIN Book b ON ob.book_id = b.BookID
                    LEFT JOIN Author a ON b.AuthorID = a.AuthorID
                    WHERE ob.order_id = ?
                """;

        try (Connection con = DBUtil.getConnection();
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

    /* ================= UPDATE ORDER STATUS ================= */
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE [Order] SET status = ? WHERE order_id = ?";

        try (Connection con = DBUtil.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, orderId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /*
     * ================= GET TOP SELLING BOOKS (Sales Analytics) =================
     */
    public List<TopSellingBook> getTopSellingBooks(int limit) {
        List<TopSellingBook> list = new ArrayList<>();
        String sql = """
                SELECT TOP (?) b.BookID AS book_id, b.Title AS title, a.AuthorName AS author_name,
                       SUM(ob.quantity) AS total_quantity,
                       SUM(ob.price * ob.quantity) AS total_revenue
                FROM Order_Book ob
                JOIN [Order] o ON ob.order_id = o.order_id
                JOIN Book b ON ob.book_id = b.BookID
                LEFT JOIN Author a ON b.AuthorID = a.AuthorID
                WHERE o.status = 'paid'
                GROUP BY b.BookID, b.Title, a.AuthorName
                ORDER BY total_quantity DESC
                """;

        try (Connection con = DBUtil.getConnection();
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

    /* ================= MAP RESULTSET ================= */
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
        if (ts != null)
            order.setCreatedAt(ts.toLocalDateTime());
        return order;
    }

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
