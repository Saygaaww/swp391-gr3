package controller;

import dao.CartDAO;
import dao.BookDAO;
import model.Cart;
import model.CartItem;
import model.Reader;
import model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "CartServlet", urlPatterns = {
    "/cart",
    "/cart/add",
    "/cart/update",
    "/cart/remove",
    "/cart/clear"
})
public class CartServlet extends HttpServlet {
    
    private CartDAO cartDAO;
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra đăng nhập
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + 
                                 java.net.URLEncoder.encode("/cart", "UTF-8"));
            return;
        }
        
        Reader reader = (Reader) session.getAttribute("reader");
        
        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + 
                                 java.net.URLEncoder.encode("/cart", "UTF-8"));
            return;
        }
        
        String path = request.getServletPath();
        
        // Xử lý remove qua GET (fallback)
        if (path.equals("/cart/remove")) {
            try {
                handleRemoveFromCart(request, response, reader.getReaderId());
                return;
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
        }
        
        try {
            // Lấy hoặc tạo giỏ hàng
            Cart cart = cartDAO.getOrCreateCart(reader.getReaderId());
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("/cart/cart.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải giỏ hàng: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra đăng nhập
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Reader reader = (Reader) session.getAttribute("reader");
        
        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        String path = request.getServletPath();
        
        try {
            if (path.equals("/cart/add") || "add".equals(action)) {
                handleAddToCart(request, response, reader.getReaderId());
            } else if (path.equals("/cart/update") || "update".equals(action)) {
                handleUpdateCart(request, response, reader.getReaderId());
            } else if (path.equals("/cart/remove") || "remove".equals(action)) {
                handleRemoveFromCart(request, response, reader.getReaderId());
            } else if (path.equals("/cart/clear") || "clear".equals(action)) {
                handleClearCart(request, response, reader.getReaderId());
            } else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Thêm sản phẩm vào giỏ hàng
     */
    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response, int readerId)
            throws ServletException, IOException, SQLException {
        String bookIdParam = request.getParameter("bookId");
        String quantityParam = request.getParameter("quantity");
        
        // Validate bookId
        if (bookIdParam == null || bookIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/books?error=missing_book_id");
            return;
        }
        
        int bookId;
        try {
            bookId = Integer.parseInt(bookIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/books?error=invalid_book_id");
            return;
        }
        
        // Validate quantity
        int quantity = 1; // Default
        if (quantityParam != null && !quantityParam.isEmpty()) {
            try {
                quantity = Integer.parseInt(quantityParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/books/view?id=" + bookId + "&error=invalid_quantity");
                return;
            }
        }
        
        // Validate quantity range (1-999)
        if (quantity < 1) {
            response.sendRedirect(request.getContextPath() + "/books/view?id=" + bookId + "&error=quantity_too_small");
            return;
        }
        if (quantity > 999) {
            response.sendRedirect(request.getContextPath() + "/books/view?id=" + bookId + "&error=quantity_too_large");
            return;
        }
        
        // Kiểm tra sách có tồn tại không
        model.Book book = bookDAO.getBookById(bookId);
        if (book == null) {
            response.sendRedirect(request.getContextPath() + "/books?error=book_not_found");
            return;
        }
        
        // Kiểm tra sách có đang active không
        if ("deleted".equalsIgnoreCase(book.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/books?error=book_deleted");
            return;
        }
        
        // Kiểm tra stock (nếu có)
        if (book.getStock() != null && book.getStock() <= 0) {
            response.sendRedirect(request.getContextPath() + "/books/view?id=" + bookId + "&error=out_of_stock");
            return;
        }
        
        // Lấy hoặc tạo giỏ hàng
        Cart cart = cartDAO.getOrCreateCart(readerId);
        
        // Kiểm tra nếu đã có trong cart, tính tổng quantity
        CartItem existingItem = cartDAO.getCartItem(cart.getCartId(), bookId);
        int totalQuantity = quantity;
        if (existingItem != null) {
            totalQuantity = existingItem.getQuantity() + quantity;
        }
        
        // Kiểm tra stock (nếu có)
        if (book.getStock() != null) {
            if (book.getStock() <= 0) {
                response.sendRedirect(request.getContextPath() + "/books/view?id=" + bookId + "&error=out_of_stock");
                return;
            }
            
            // Kiểm tra số lượng có vượt quá stock không
            if (totalQuantity > book.getStock()) {
                String errorMsg = "insufficient_stock&available=" + book.getStock();
                if (existingItem != null) {
                    errorMsg += "&in_cart=" + existingItem.getQuantity();
                }
                response.sendRedirect(request.getContextPath() + "/books/view?id=" + bookId + "&error=" + errorMsg);
                return;
            }
        }
        
        // TẠM THỜI BỎ: Check approval_status (DB chưa có column này)
        // TODO: Khi nào chạy migration script thì uncomment lại
        // if (book.getApprovalStatus() != null && !"approved".equalsIgnoreCase(book.getApprovalStatus())) {
        //     response.sendRedirect(request.getContextPath() + "/books/view?id=" + bookId + "&error=book_not_approved");
        //     return;
        // }
        
        // Thêm vào giỏ hàng
        boolean success = cartDAO.addToCart(cart.getCartId(), bookId, quantity);
        
        if (success) {
            String redirectUrl = request.getParameter("redirect");
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                // Kiểm tra xem redirectUrl đã có query parameters chưa
                String separator = redirectUrl.contains("?") ? "&" : "?";
                response.sendRedirect(request.getContextPath() + redirectUrl + separator + "message=added_to_cart");
            } else {
                response.sendRedirect(request.getContextPath() + "/cart?message=added_to_cart");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/books?error=add_to_cart_failed");
        }
    }
    
    /**
     * Cập nhật số lượng sản phẩm trong giỏ hàng
     */
    private void handleUpdateCart(HttpServletRequest request, HttpServletResponse response, int readerId)
            throws ServletException, IOException, SQLException {
        String cartItemIdParam = request.getParameter("cartItemId");
        String quantityParam = request.getParameter("quantity");
        
        // Validate parameters
        if (cartItemIdParam == null || cartItemIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=missing_cart_item_id");
            return;
        }
        
        if (quantityParam == null || quantityParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=missing_quantity");
            return;
        }
        
        // Parse và validate cartItemId
        int cartItemId;
        try {
            cartItemId = Integer.parseInt(cartItemIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cart?error=invalid_cart_item_id");
            return;
        }
        
        // Parse và validate quantity
        int quantity;
        try {
            quantity = Integer.parseInt(quantityParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cart?error=invalid_quantity");
            return;
        }
        
        // Validate quantity range (0-999, 0 sẽ xóa item)
        if (quantity < 0) {
            response.sendRedirect(request.getContextPath() + "/cart?error=quantity_invalid");
            return;
        }
        if (quantity > 999) {
            response.sendRedirect(request.getContextPath() + "/cart?error=quantity_too_large");
            return;
        }
        
        // Security: Kiểm tra cartItemId có thuộc về reader hiện tại không
        CartItem cartItem = cartDAO.getCartItemById(cartItemId);
        if (cartItem == null) {
            response.sendRedirect(request.getContextPath() + "/cart?error=cart_item_not_found");
            return;
        }
        
        Cart cart = cartDAO.getCartById(cartItem.getCartId());
        if (cart == null || cart.getReaderId() != readerId) {
            response.sendRedirect(request.getContextPath() + "/cart?error=unauthorized");
            return;
        }
        
        // Kiểm tra book có còn tồn tại và active không
        model.Book book = bookDAO.getBookById(cartItem.getBookId());
        if (book == null || "deleted".equalsIgnoreCase(book.getStatus())) {
            // Nếu book đã bị xóa, xóa luôn cart item
            cartDAO.removeCartItem(cartItemId);
            response.sendRedirect(request.getContextPath() + "/cart?error=book_deleted&message=item_removed");
            return;
        }
        
        // Kiểm tra stock nếu có
        if (book.getStock() != null && quantity > book.getStock()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=insufficient_stock&available=" + book.getStock());
            return;
        }
        
        // Cập nhật quantity
        boolean success = cartDAO.updateCartItemQuantity(cartItemId, quantity);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/cart?message=cart_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/cart?error=update_failed");
        }
    }
    
    /**
     * Xóa sản phẩm khỏi giỏ hàng
     */
    private void handleRemoveFromCart(HttpServletRequest request, HttpServletResponse response, int readerId)
            throws ServletException, IOException, SQLException {
        String cartItemIdParam = request.getParameter("cartItemId");
        
        // Validate cartItemId
        if (cartItemIdParam == null || cartItemIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=missing_cart_item_id");
            return;
        }
        
        int cartItemId;
        try {
            cartItemId = Integer.parseInt(cartItemIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cart?error=invalid_cart_item_id");
            return;
        }
        
        // Security: Kiểm tra cartItemId có thuộc về reader hiện tại không
        CartItem cartItem = cartDAO.getCartItemById(cartItemId);
        if (cartItem == null) {
            response.sendRedirect(request.getContextPath() + "/cart?error=cart_item_not_found");
            return;
        }
        
        Cart cart = cartDAO.getCartById(cartItem.getCartId());
        if (cart == null || cart.getReaderId() != readerId) {
            response.sendRedirect(request.getContextPath() + "/cart?error=unauthorized");
            return;
        }
        
        // Xóa item
        boolean success = cartDAO.removeCartItem(cartItemId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/cart?message=item_removed");
        } else {
            response.sendRedirect(request.getContextPath() + "/cart?error=remove_failed");
        }
    }
    
    /**
     * Xóa tất cả sản phẩm trong giỏ hàng
     */
    private void handleClearCart(HttpServletRequest request, HttpServletResponse response, int readerId)
            throws ServletException, IOException, SQLException {
        Cart cart = cartDAO.getOrCreateCart(readerId);
        
        // Security: Kiểm tra cart có thuộc về reader hiện tại không
        if (cart == null || cart.getReaderId() != readerId) {
            response.sendRedirect(request.getContextPath() + "/cart?error=unauthorized");
            return;
        }
        
        boolean success = cartDAO.clearCart(cart.getCartId());
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/cart?message=cart_cleared");
        } else {
            response.sendRedirect(request.getContextPath() + "/cart?error=clear_failed");
        }
    }
}
