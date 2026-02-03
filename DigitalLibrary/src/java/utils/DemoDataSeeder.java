package utils;

import dao.BookDAO;
import dao.OrderDAO;
import dao.PaymentDAO;
import dao.ReaderDAO;
import dao.RoleDAO;
import model.Order;
import model.OrderBook;
import model.Role;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Seed/mock data cho demo (ưu tiên cho SELLER xem dashboard có dữ liệu).
 *
 * An toàn:
 * - Chỉ seed nếu DB đang "đúng schema" (có các cột mà code đang dùng).
 * - Chỉ seed nếu bảng đang trống (0 book hoặc 0 reader hoặc 0 order).
 */
public final class DemoDataSeeder {
    private DemoDataSeeder() {}

    public static class SeedResult {
        public final boolean success;
        public final String message;

        public SeedResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }

    public static SeedResult seedIfNeeded() {
        try {
            if (!hasExpectedBookColumns()) {
                return new SeedResult(false,
                        "DB schema chưa khớp code (thiếu cover_url/currency/...). " +
                        "Hãy chạy script `db_migrate_book_schema_to_match_code.sql` rồi refresh.");
            }

            // Ensure roles
            RoleDAO roleDAO = new RoleDAO();
            Role userRole = roleDAO.getRoleByName("USER");
            if (userRole == null) {
                return new SeedResult(false, "Không tìm thấy role USER. Hãy chạy `database_setup.sql` để tạo Role.");
            }

            ReaderDAO readerDAO = new ReaderDAO();
            BookDAO bookDAO = new BookDAO();
            OrderDAO orderDAO = new OrderDAO();
            PaymentDAO paymentDAO = new PaymentDAO();

            int seeded = 0;

            // Seed readers (customers) nếu không có
            int readerCount = countRows("Reader");
            if (readerCount == 0) {
                readerDAO.createReader("Khách Demo 1", "demo1@digitallibrary.com", "demo123", userRole.getRoleId());
                readerDAO.createReader("Khách Demo 2", "demo2@digitallibrary.com", "demo123", userRole.getRoleId());
                seeded++;
            }

            // Seed books nếu không có
            int bookCount = countRows("Book");
            if (bookCount == 0) {
                seedBooksDirect();
                seeded++;
            }

            // Seed 1 order + payment nếu chưa có order
            int orderCount = countRows("[Order]");
            if (orderCount == 0) {
                // Lấy 1 readerId
                Integer readerId = getAnyInt("SELECT TOP 1 reader_id FROM Reader ORDER BY reader_id ASC");
                Integer bookId = getAnyInt("SELECT TOP 1 book_id FROM Book ORDER BY book_id ASC");
                BigDecimal price = getAnyDecimal("SELECT TOP 1 price FROM Book WHERE book_id = ?", bookId);
                if (readerId != null && bookId != null && price != null) {
                    List<OrderBook> items = new ArrayList<>();
                    OrderBook ob = new OrderBook();
                    ob.setBookId(bookId);
                    ob.setQuantity(1);
                    ob.setPrice(price);
                    items.add(ob);

                    Order order = orderDAO.createOrder(readerId, items);
                    if (order != null) {
                        // mock paid
                        model.Payment payment = paymentDAO.createPayment(order.getOrderId(), "cash", order.getTotalAmount());
                        if (payment != null) {
                            paymentDAO.updatePaymentStatus(payment.getPaymentId(), "success", "MOCK-SEED");
                            orderDAO.updateOrderStatus(order.getOrderId(), "paid");
                        }
                    }
                    seeded++;
                }
            }

            if (seeded == 0) {
                return new SeedResult(true, "Đã có dữ liệu sẵn, không cần seed.");
            }
            return new SeedResult(true, "Đã seed dữ liệu demo cho SELLER (customers/books/orders).");
        } catch (SQLException e) {
            return new SeedResult(false, "Seed demo thất bại: " + e.getMessage());
        }
    }

    private static boolean hasExpectedBookColumns() throws SQLException {
        String sql = "SELECT COUNT(*) FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Book]') AND name IN ('cover_url','currency')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) == 2;
            }
        }
        return false;
    }

    private static int countRows(String tableName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM " + tableName;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private static Integer getAnyInt(String sql) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return null;
    }

    private static BigDecimal getAnyDecimal(String sql, int param) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, param);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        }
        return null;
    }

    private static void seedBooksDirect() throws SQLException {
        // Insert tối thiểu các cột mà code cần
        String sql = "INSERT INTO Book (title, summary, description, cover_url, content_path, price, currency, status, created_at) " +
                     "VALUES (?, ?, ?, ?, NULL, ?, 'VND', 'active', SYSUTCDATETIME())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            insertBook(ps, "Đắc Nhân Tâm", "Nghệ thuật ứng xử", "Cuốn sách kinh điển về giao tiếp.", "", new BigDecimal("89000"));
            insertBook(ps, "Nhà Giả Kim", "Hành trình ý nghĩa", "Tiểu thuyết truyền cảm hứng.", "", new BigDecimal("120000"));
            insertBook(ps, "Sapiens", "Lược sử loài người", "Hành trình tiến hóa của nhân loại.", "", new BigDecimal("200000"));
        }
    }

    private static void insertBook(PreparedStatement ps, String title, String summary, String description, String coverUrl, BigDecimal price) throws SQLException {
        ps.setString(1, title);
        ps.setString(2, summary);
        ps.setString(3, description);
        ps.setString(4, coverUrl);
        ps.setBigDecimal(5, price);
        ps.executeUpdate();
    }
}

