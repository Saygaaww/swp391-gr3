package controller;

import dao.CartDAO;
import dao.BookDAO;
import dao.ReaderDAO;
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
import java.util.List;

@WebServlet(name = "SellerCartServlet", urlPatterns = {
    "/seller/cart",
    "/seller/cart/select-customer",
    "/seller/cart/add",
    "/seller/cart/update",
    "/seller/cart/remove",
    "/seller/cart/clear"
})
public class SellerCartServlet extends HttpServlet {
    
    private CartDAO cartDAO;
    private BookDAO bookDAO;
    private ReaderDAO readerDAO;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        bookDAO = new BookDAO();
        readerDAO = new ReaderDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra đăng nhập và quyền SELLER
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Employee employee = (Employee) session.getAttribute("employee");
        String userRole = (String) session.getAttribute("userRole");
        
        if (employee == null || userRole == null || !"SELLER".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String path = request.getServletPath();
        
        try {
            if (path.equals("/seller/cart/select-customer")) {
                handleSelectCustomer(request, response);
            } else {
                // Mặc định: hiển thị giỏ hàng
                handleViewCart(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra đăng nhập và quyền SELLER
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Employee employee = (Employee) session.getAttribute("employee");
        String userRole = (String) session.getAttribute("userRole");
        
        if (employee == null || userRole == null || !"SELLER".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        String path = request.getServletPath();
        
        try {
            if (path.equals("/seller/cart/select-customer") || "select-customer".equals(action)) {
                handleSetCustomer(request, response);
            } else if (path.equals("/seller/cart/add") || "add".equals(action)) {
                handleAddToCart(request, response);
            } else if (path.equals("/seller/cart/update") || "update".equals(action)) {
                handleUpdateCart(request, response);
            } else if (path.equals("/seller/cart/remove") || "remove".equals(action)) {
                handleRemoveFromCart(request, response);
            } else if (path.equals("/seller/cart/clear") || "clear".equals(action)) {
                handleClearCart(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/seller/cart");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị giỏ hàng của khách hàng đã chọn
     */
    private void handleViewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        
        // Lấy readerId từ session (seller đã chọn khách hàng)
        Integer selectedReaderId = (Integer) session.getAttribute("sellerSelectedReaderId");
        
        if (selectedReaderId == null) {
            // Chưa chọn khách hàng, redirect đến trang chọn khách hàng
            response.sendRedirect(request.getContextPath() + "/seller/cart/select-customer");
            return;
        }
        
        // Lấy thông tin khách hàng
        Reader customer = readerDAO.getReaderById(selectedReaderId);
        if (customer == null) {
            session.removeAttribute("sellerSelectedReaderId");
            response.sendRedirect(request.getContextPath() + "/seller/cart/select-customer?error=customer_not_found");
            return;
        }
        
        // Lấy hoặc tạo giỏ hàng
        Cart cart = cartDAO.getOrCreateCart(selectedReaderId);
        
        request.setAttribute("cart", cart);
        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/seller/cart.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị form chọn khách hàng
     */
    private void handleSelectCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String search = request.getParameter("search");
        
        List<Reader> customers = null;
        if (search != null && !search.trim().isEmpty()) {
            // Tìm kiếm khách hàng theo email hoặc tên
            customers = readerDAO.searchReaders(search);
        } else {
            // Lấy danh sách khách hàng gần đây (có thể lấy top 20)
            customers = readerDAO.getAllReaders(0, 20);
        }
        
        request.setAttribute("customers", customers);
        request.setAttribute("search", search);
        request.getRequestDispatcher("/seller/select-customer.jsp").forward(request, response);
    }
    
    /**
     * Set khách hàng được chọn vào session
     */
    private void handleSetCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String readerIdParam = request.getParameter("readerId");
        
        if (readerIdParam == null || readerIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/seller/cart/select-customer?error=missing_reader_id");
            return;
        }
        
        int readerId = Integer.parseInt(readerIdParam);
        Reader customer = readerDAO.getReaderById(readerId);
        
        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/seller/cart/select-customer?error=customer_not_found");
            return;
        }
        
        // Lưu readerId vào session
        HttpSession session = request.getSession();
        session.setAttribute("sellerSelectedReaderId", readerId);
        session.setAttribute("sellerSelectedCustomer", customer);
        
        response.sendRedirect(request.getContextPath() + "/seller/cart");
    }
    
    /**
     * Thêm sách vào giỏ hàng của khách hàng
     */
    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Integer selectedReaderId = (Integer) session.getAttribute("sellerSelectedReaderId");
        
        if (selectedReaderId == null) {
            response.sendRedirect(request.getContextPath() + "/seller/cart/select-customer?error=no_customer_selected");
            return;
        }
        
        String bookIdParam = request.getParameter("bookId");
        String quantityParam = request.getParameter("quantity");
        
        if (bookIdParam == null || bookIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/seller/cart?error=missing_book_id");
            return;
        }
        
        int bookId = Integer.parseInt(bookIdParam);
        int quantity = (quantityParam != null && !quantityParam.isEmpty()) ? 
                       Integer.parseInt(quantityParam) : 1;
        
        // Kiểm tra sách có tồn tại không
        model.Book book = bookDAO.getBookById(bookId);
        if (book == null) {
            response.sendRedirect(request.getContextPath() + "/seller/cart?error=book_not_found");
            return;
        }
        // TẠM THỜI BỎ: Check approval_status (DB chưa có column này)
        // TODO: Khi nào chạy migration script thì uncomment lại
        // if (book.getApprovalStatus() != null && !"approved".equalsIgnoreCase(book.getApprovalStatus())) {
        //     response.sendRedirect(request.getContextPath() + "/seller/cart?error=book_not_approved");
        //     return;
        // }
        
        // Lấy hoặc tạo giỏ hàng
        Cart cart = cartDAO.getOrCreateCart(selectedReaderId);
        
        // Thêm vào giỏ hàng
        boolean success = cartDAO.addToCart(cart.getCartId(), bookId, quantity);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/seller/cart?message=added_to_cart");
        } else {
            response.sendRedirect(request.getContextPath() + "/seller/cart?error=add_to_cart_failed");
        }
    }
    
    /**
     * Cập nhật số lượng sản phẩm trong giỏ hàng
     */
    private void handleUpdateCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Integer selectedReaderId = (Integer) session.getAttribute("sellerSelectedReaderId");
        
        if (selectedReaderId == null) {
            response.sendRedirect(request.getContextPath() + "/seller/cart/select-customer?error=no_customer_selected");
            return;
        }
        
        String cartItemIdParam = request.getParameter("cartItemId");
        String quantityParam = request.getParameter("quantity");
        
        if (cartItemIdParam == null || quantityParam == null) {
            response.sendRedirect(request.getContextPath() + "/seller/cart?error=missing_params");
            return;
        }
        
        int cartItemId = Integer.parseInt(cartItemIdParam);
        int quantity = Integer.parseInt(quantityParam);
        
        boolean success = cartDAO.updateCartItemQuantity(cartItemId, quantity);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/seller/cart?message=cart_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/seller/cart?error=update_failed");
        }
    }
    
    /**
     * Xóa sản phẩm khỏi giỏ hàng
     */
    private void handleRemoveFromCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Integer selectedReaderId = (Integer) session.getAttribute("sellerSelectedReaderId");
        
        if (selectedReaderId == null) {
            response.sendRedirect(request.getContextPath() + "/seller/cart/select-customer?error=no_customer_selected");
            return;
        }
        
        String cartItemIdParam = request.getParameter("cartItemId");
        
        if (cartItemIdParam == null || cartItemIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/seller/cart?error=missing_cart_item_id");
            return;
        }
        
        int cartItemId = Integer.parseInt(cartItemIdParam);
        boolean success = cartDAO.removeCartItem(cartItemId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/seller/cart?message=item_removed");
        } else {
            response.sendRedirect(request.getContextPath() + "/seller/cart?error=remove_failed");
        }
    }
    
    /**
     * Xóa tất cả sản phẩm trong giỏ hàng
     */
    private void handleClearCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        HttpSession session = request.getSession();
        Integer selectedReaderId = (Integer) session.getAttribute("sellerSelectedReaderId");
        
        if (selectedReaderId == null) {
            response.sendRedirect(request.getContextPath() + "/seller/cart/select-customer?error=no_customer_selected");
            return;
        }
        
        Cart cart = cartDAO.getOrCreateCart(selectedReaderId);
        boolean success = cartDAO.clearCart(cart.getCartId());
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/seller/cart?message=cart_cleared");
        } else {
            response.sendRedirect(request.getContextPath() + "/seller/cart?error=clear_failed");
        }
    }
}
