package dao;

import model.Cart;
import model.CartItem;
import util.DBContext;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO giỏ hàng: Cart và Cart_Item. Giá đơn vị và tổng tiền dùng giá sách hiện tại (Book.price) — đơn vị VND.
 */
public class CartDAO {

    /**
     * Lấy giỏ active của reader; nếu chưa có thì tạo mới (createCart) rồi lấy lại. Trả về Cart kèm danh sách items (getCartItems).
     */
    public Cart getOrCreateCart(int readerId) {
        Cart cart = getActiveCart(readerId);
        if (cart == null) {
            createCart(readerId);
            cart = getActiveCart(readerId);
        }
        return cart;
    }

    /* ================= GET ACTIVE CART ================= */
    public Cart getActiveCart(int readerId) {
        String sql = "SELECT * FROM Cart WHERE reader_id = ? AND status = 'active'";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Cart cart = mapCart(rs);
                cart.setItems(getCartItems(cart.getCartId()));
                return cart;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Tạo giỏ mới cho reader (status active). Trả về cart_id (generated key) hoặc -1 nếu lỗi.
     */
    public int createCart(int readerId) {
        String sql = "INSERT INTO Cart(reader_id, status) VALUES (?, 'active')";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, readerId);
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
     * Lấy tất cả mục trong giỏ (JOIN Book, Author): cart_item_id, book_id, quantity, unit_price; title, cover_url, price (giá hiện tại), author_name, available_stock (ISNULL stock_quantity).
     */
    public List<CartItem> getCartItems(int cartId) {
        List<CartItem> items = new ArrayList<>();
        String sql = """
            SELECT ci.*, b.title, b.cover_url, b.price, a.author_name,
                   ISNULL(b.stock_quantity, 0) AS available_stock
            FROM Cart_Item ci
            JOIN Book b ON ci.book_id = b.book_id
            LEFT JOIN Author a ON b.author_id = a.author_id
            WHERE ci.cart_id = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                items.add(mapCartItem(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    /**
     * Thêm sách vào giỏ: nếu đã có mục cùng book_id thì cộng quantity (updateCartItemQuantity); chưa có thì INSERT Cart_Item. Trả về true nếu thành công.
     */
    public boolean addItemToCart(int cartId, int bookId, int quantity, BigDecimal unitPrice) {
        // Check if item already exists
        String checkSql = "SELECT cart_item_id, quantity FROM Cart_Item WHERE cart_id = ? AND book_id = ?";
        
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(checkSql)) {

            ps.setInt(1, cartId);
            ps.setInt(2, bookId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Update quantity
                int existingQuantity = rs.getInt("quantity");
                int cartItemId = rs.getInt("cart_item_id");
                return updateCartItemQuantity(cartItemId, existingQuantity + quantity);
            } else {
                // Insert new item
                String insertSql = """
                    INSERT INTO Cart_Item(cart_id, book_id, quantity, unit_price)
                    VALUES (?, ?, ?, ?)
                """;
                
                PreparedStatement ps2 = con.prepareStatement(insertSql);
                ps2.setInt(1, cartId);
                ps2.setInt(2, bookId);
                ps2.setInt(3, quantity);
                ps2.setBigDecimal(4, unitPrice);
                
                return ps2.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy một CartItem theo cart_item_id (dùng để kiểm tra available_stock khi update quantity).
     */
    public CartItem getCartItemById(int cartItemId) {
        String sql = """
            SELECT ci.*, b.title, b.cover_url, b.price, a.author_name,
                   ISNULL(b.stock_quantity, 0) AS available_stock
            FROM Cart_Item ci
            JOIN Book b ON ci.book_id = b.book_id
            LEFT JOIN Author a ON b.author_id = a.author_id
            WHERE ci.cart_item_id = ?
        """;
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, cartItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapCartItem(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Cập nhật số lượng của một mục giỏ (Cart_Item) theo cart_item_id.
     */
    public boolean updateCartItemQuantity(int cartItemId, int quantity) {
        String sql = "UPDATE Cart_Item SET quantity = ? WHERE cart_item_id = ?";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, cartItemId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa một mục khỏi giỏ (DELETE Cart_Item theo cart_item_id).
     */
    public boolean removeItemFromCart(int cartItemId) {
        String sql = "DELETE FROM Cart_Item WHERE cart_item_id = ?";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cartItemId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xóa tất cả mục trong giỏ (DELETE Cart_Item WHERE cart_id). Dùng sau khi thanh toán thành công.
     */
    public boolean clearCart(int cartId) {
        String sql = "DELETE FROM Cart_Item WHERE cart_id = ?";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            return ps.executeUpdate() >= 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cập nhật trạng thái giỏ (active / checked_out). Cập nhật updated_at.
     */
    public boolean updateCartStatus(int cartId, String status) {
        String sql = "UPDATE Cart SET status = ?, updated_at = SYSUTCDATETIME() WHERE cart_id = ?";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, cartId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Tính tổng tiền giỏ: SUM(quantity * b.price) từ Cart_Item JOIN Book (dùng giá sách hiện tại, VND).
     */
    public BigDecimal getCartTotal(int cartId) {
        String sql = """
            SELECT SUM(ci.quantity * b.price) as total
            FROM Cart_Item ci
            JOIN Book b ON ci.book_id = b.book_id
            WHERE ci.cart_id = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal("total");
                return total != null ? total : BigDecimal.ZERO;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    /** Ánh xạ ResultSet → Cart (cart_id, reader_id, status). */
    private Cart mapCart(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setCartId(rs.getInt("cart_id"));
        cart.setReaderId(rs.getInt("reader_id"));
        cart.setStatus(rs.getString("status"));
        return cart;
    }

    /** Ánh xạ ResultSet → CartItem; unitPrice dùng b.price (giá hiện tại) nếu có. */
    private CartItem mapCartItem(ResultSet rs) throws SQLException {
        CartItem item = new CartItem();
        item.setCartItemId(rs.getInt("cart_item_id"));
        item.setCartId(rs.getInt("cart_id"));
        item.setBookId(rs.getInt("book_id"));
        item.setQuantity(rs.getInt("quantity"));
        // Dùng giá sách hiện tại (b.price) để hiển thị và tính tổng đúng VND
        BigDecimal currentPrice = rs.getBigDecimal("price");
        item.setUnitPrice(currentPrice != null ? currentPrice : rs.getBigDecimal("unit_price"));
        item.setBookTitle(rs.getString("title"));
        item.setBookCoverUrl(rs.getString("cover_url"));
        item.setAuthorName(rs.getString("author_name"));
        try {
            item.setAvailableStock(rs.getInt("available_stock"));
        } catch (SQLException e) {
            item.setAvailableStock(0);
        }
        return item;
    }
}
