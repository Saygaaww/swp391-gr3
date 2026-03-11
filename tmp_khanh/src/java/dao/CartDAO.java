package dao;

import model.Cart;
import model.CartItem;
import util.DBContext;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    /* ================= GET OR CREATE CART ================= */
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

    /* ================= CREATE CART ================= */
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

    /* ================= GET CART ITEMS ================= */
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

    /* ================= ADD ITEM TO CART ================= */
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

    /** Lay mot cart item theo id (de biet bookId phuc vu validate stock). */
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

    /* ================= UPDATE CART ITEM QUANTITY ================= */
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

    /* ================= REMOVE ITEM FROM CART ================= */
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

    /* ================= CLEAR CART ================= */
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

    /* ================= UPDATE CART STATUS ================= */
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

    /* ================= GET CART TOTAL ================= */
    public BigDecimal getCartTotal(int cartId) {
        String sql = """
            SELECT SUM(ci.quantity * ci.unit_price) as total
            FROM Cart_Item ci
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

    /* ================= MAP RESULTSET ================= */
    private Cart mapCart(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setCartId(rs.getInt("cart_id"));
        cart.setReaderId(rs.getInt("reader_id"));
        cart.setStatus(rs.getString("status"));
        return cart;
    }

    private CartItem mapCartItem(ResultSet rs) throws SQLException {
        CartItem item = new CartItem();
        item.setCartItemId(rs.getInt("cart_item_id"));
        item.setCartId(rs.getInt("cart_id"));
        item.setBookId(rs.getInt("book_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
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
