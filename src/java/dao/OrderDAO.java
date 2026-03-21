package dao;

import model.Order;
import model.OrderBook;
import model.TopSellingBook;
import util.DBUtil;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    public List<Order> getSellerOrders(int employeeId, String status, Date fromDate, Date toDate) {
        List<Order> orders = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
                SELECT DISTINCT o.*, r.full_name, r.email
                FROM [Order] o
                JOIN Reader r ON o.reader_id = r.reader_id
                JOIN Order_Book ob ON ob.order_id = o.order_id
                JOIN Book b ON b.BookID = ob.book_id
                LEFT JOIN Payment p ON p.order_id = o.order_id
                WHERE b.CreatedByEmployeeID = ?
                """);

        if (status != null && !status.isBlank()) {
            sql.append(" AND o.status = ?");
        }
        if (fromDate != null) {
            sql.append(" AND CAST(o.created_at AS date) >= ?");
        }
        if (toDate != null) {
            sql.append(" AND CAST(o.created_at AS date) <= ?");
        }
        sql.append(" ORDER BY o.created_at DESC");

        try (Connection con = DBUtil.getConnection();
                PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int idx = 1;
            ps.setInt(idx++, employeeId);
            if (status != null && !status.isBlank()) {
                ps.setString(idx++, status);
            }
            if (fromDate != null) {
                ps.setDate(idx++, fromDate);
            }
            if (toDate != null) {
                ps.setDate(idx++, toDate);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = mapOrder(rs);
                order.setOrderBooks(getOrderBooksBySeller(order.getOrderId(), employeeId));
                orders.add(order);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public Order getSellerOrderById(int orderId, int employeeId) {
        String sql = """
                SELECT o.*, r.full_name, r.email
                FROM [Order] o
                JOIN Reader r ON o.reader_id = r.reader_id
                WHERE o.order_id = ?
                  AND EXISTS (
                      SELECT 1
                      FROM Order_Book ob
                      JOIN Book b ON b.BookID = ob.book_id
                      WHERE ob.order_id = o.order_id
                        AND b.CreatedByEmployeeID = ?
                  )
                """;

        try (Connection con = DBUtil.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setInt(2, employeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order order = mapOrder(rs);
                order.setOrderBooks(getOrderBooksBySeller(orderId, employeeId));
                return order;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean sellerOwnsOrder(int orderId, int employeeId) {
        String sql = """
                SELECT TOP 1 1
                FROM Order_Book ob
                JOIN Book b ON b.BookID = ob.book_id
                WHERE ob.order_id = ?
                  AND b.CreatedByEmployeeID = ?
                """;
        try (Connection con = DBUtil.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, employeeId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Map<String, Object>> getSellerSalesReport(int employeeId, Date fromDate, Date toDate,
            String orderStatus, String groupBy) {
        List<Map<String, Object>> rows = new ArrayList<>();
        boolean byMonth = "month".equalsIgnoreCase(groupBy);

        String periodExpr = byMonth
                ? "FORMAT(o.created_at, 'yyyy-MM')"
                : "CONVERT(varchar(10), CAST(o.created_at AS date), 23)";

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ")
            .append(periodExpr)
            .append(" AS period, ")
            .append("COUNT(DISTINCT o.order_id) AS order_count, ")
            .append("SUM(ob.price * ob.quantity) AS revenue ")
            .append("FROM [Order] o ")
            .append("JOIN Order_Book ob ON ob.order_id = o.order_id ")
            .append("JOIN Book b ON b.BookID = ob.book_id ")
            .append("WHERE b.CreatedByEmployeeID = ?");

        if (orderStatus != null && !orderStatus.isBlank()) {
            sql.append(" AND o.status = ?");
        }
        if (fromDate != null) {
            sql.append(" AND CAST(o.created_at AS date) >= ?");
        }
        if (toDate != null) {
            sql.append(" AND CAST(o.created_at AS date) <= ?");
        }

        sql.append(" GROUP BY ").append(periodExpr).append(" ORDER BY period ASC");

        try (Connection con = DBUtil.getConnection();
                PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, employeeId);
            if (orderStatus != null && !orderStatus.isBlank()) {
                ps.setString(idx++, orderStatus);
            }
            if (fromDate != null) {
                ps.setDate(idx++, fromDate);
            }
            if (toDate != null) {
                ps.setDate(idx++, toDate);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("period", rs.getString("period"));
                row.put("orderCount", rs.getInt("order_count"));
                row.put("revenue", rs.getBigDecimal("revenue"));
                rows.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rows;
    }

    public Map<String, Object> getSellerAnalyticsSummary(int employeeId, Date fromDate, Date toDate) {
        Map<String, Object> summary = new HashMap<>();
        String sql = """
                SELECT
                    COUNT(DISTINCT CASE WHEN o.status IN ('paid', 'delivered') THEN o.order_id END) AS successful_orders,
                    SUM(CASE WHEN o.status IN ('paid', 'delivered') THEN (ob.price * ob.quantity) ELSE 0 END) AS total_revenue
                FROM [Order] o
                JOIN Order_Book ob ON ob.order_id = o.order_id
                JOIN Book b ON b.BookID = ob.book_id
                WHERE b.CreatedByEmployeeID = ?
                  AND (? IS NULL OR CAST(o.created_at AS date) >= ?)
                  AND (? IS NULL OR CAST(o.created_at AS date) <= ?)
                """;

        try (Connection con = DBUtil.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setDate(2, fromDate);
            ps.setDate(3, fromDate);
            ps.setDate(4, toDate);
            ps.setDate(5, toDate);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int successfulOrders = rs.getInt("successful_orders");
                BigDecimal totalRevenue = rs.getBigDecimal("total_revenue");
                if (totalRevenue == null) {
                    totalRevenue = BigDecimal.ZERO;
                }
                BigDecimal avgOrderValue = successfulOrders > 0
                        ? totalRevenue.divide(BigDecimal.valueOf(successfulOrders), 2, java.math.RoundingMode.HALF_UP)
                        : BigDecimal.ZERO;

                summary.put("successfulOrders", successfulOrders);
                summary.put("totalRevenue", totalRevenue);
                summary.put("avgOrderValue", avgOrderValue);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (!summary.containsKey("successfulOrders")) {
            summary.put("successfulOrders", 0);
            summary.put("totalRevenue", BigDecimal.ZERO);
            summary.put("avgOrderValue", BigDecimal.ZERO);
        }
        return summary;
    }

    public List<Map<String, Object>> getSellerRevenueTrend(int employeeId, String groupBy, int rangeLimit) {
        List<Map<String, Object>> rows = new ArrayList<>();
        boolean byMonth = "month".equalsIgnoreCase(groupBy);
        String periodExpr = byMonth
                ? "FORMAT(o.created_at, 'yyyy-MM')"
                : "CONVERT(varchar(10), CAST(o.created_at AS date), 23)";

        String sql = "SELECT " + periodExpr + " AS period, "
            + "SUM(CASE WHEN o.status IN ('paid', 'delivered') THEN (ob.price * ob.quantity) ELSE 0 END) AS revenue "
            + "FROM [Order] o "
            + "JOIN Order_Book ob ON ob.order_id = o.order_id "
            + "JOIN Book b ON b.BookID = ob.book_id "
            + "WHERE b.CreatedByEmployeeID = ? "
            + "GROUP BY " + periodExpr + " "
            + "ORDER BY period DESC "
            + "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection con = DBUtil.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            ps.setInt(2, rangeLimit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("period", rs.getString("period"));
                BigDecimal revenue = rs.getBigDecimal("revenue");
                row.put("revenue", revenue == null ? BigDecimal.ZERO : revenue);
                rows.add(0, row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rows;
    }

    public List<TopSellingBook> getTopSellingBooksBySeller(int employeeId, int limit) {
        List<TopSellingBook> list = new ArrayList<>();
        String sql = """
                SELECT TOP (?) b.BookID AS book_id, b.Title AS title, a.AuthorName AS author_name,
                       SUM(ob.quantity) AS total_quantity,
                       SUM(ob.price * ob.quantity) AS total_revenue
                FROM Order_Book ob
                JOIN [Order] o ON ob.order_id = o.order_id
                JOIN Book b ON ob.book_id = b.BookID
                LEFT JOIN Author a ON b.AuthorID = a.AuthorID
                WHERE b.CreatedByEmployeeID = ?
                  AND o.status IN ('paid', 'delivered')
                GROUP BY b.BookID, b.Title, a.AuthorName
                ORDER BY total_quantity DESC
                """;

        try (Connection con = DBUtil.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit > 0 ? limit : 10);
            ps.setInt(2, employeeId);
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

    private List<OrderBook> getOrderBooksBySeller(int orderId, int employeeId) {
        List<OrderBook> orderBooks = new ArrayList<>();
        String sql = """
                    SELECT ob.*, b.Title AS title, b.CoverURL AS cover_url, a.AuthorName AS author_name
                    FROM Order_Book ob
                    JOIN Book b ON ob.book_id = b.BookID
                    LEFT JOIN Author a ON b.AuthorID = a.AuthorID
                    WHERE ob.order_id = ?
                      AND b.CreatedByEmployeeID = ?
                """;

        try (Connection con = DBUtil.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setInt(2, employeeId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                orderBooks.add(mapOrderBook(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderBooks;
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
