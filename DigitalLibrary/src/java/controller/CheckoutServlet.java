package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.PaymentDAO;
import dao.BookDAO;
import model.Cart;
import model.CartItem;
import model.Order;
import model.OrderBook;
import model.Payment;
import model.Reader;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = {
    "/checkout",
    "/checkout/process",
    "/checkout/success"
})
public class CheckoutServlet extends HttpServlet {
    
    private CartDAO cartDAO;
    private OrderDAO orderDAO;
    private PaymentDAO paymentDAO;
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        orderDAO = new OrderDAO();
        paymentDAO = new PaymentDAO();
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra đăng nhập
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + 
                                 java.net.URLEncoder.encode("/checkout", "UTF-8"));
            return;
        }
        
        Reader reader = (Reader) session.getAttribute("reader");
        
        if (reader == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + 
                                 java.net.URLEncoder.encode("/checkout", "UTF-8"));
            return;
        }
        
        String path = request.getServletPath();
        
        try {
            if (path.equals("/checkout/success")) {
                handleCheckoutSuccess(request, response);
            } else {
                // Hiển thị trang checkout
                handleCheckoutForm(request, response, reader.getReaderId());
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
        
        try {
            handleProcessCheckout(request, response, reader.getReaderId());
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý thanh toán: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị form checkout
     */
    private void handleCheckoutForm(HttpServletRequest request, HttpServletResponse response, int readerId)
            throws ServletException, IOException, SQLException {
        Cart cart = cartDAO.getOrCreateCart(readerId);
        
        if (cart.getItems() == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=cart_empty");
            return;
        }
        
        request.setAttribute("cart", cart);
        request.getRequestDispatcher("/checkout/checkout.jsp").forward(request, response);
    }
    
    /**
     * Xử lý thanh toán
     */
    private void handleProcessCheckout(HttpServletRequest request, HttpServletResponse response, int readerId)
            throws ServletException, IOException, SQLException {
        // Lấy thông tin từ form
        String paymentMethod = request.getParameter("paymentMethod");
        
        // Validation
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn phương thức thanh toán");
            handleCheckoutForm(request, response, readerId);
            return;
        }
        
        // Lấy giỏ hàng
        Cart cart = cartDAO.getOrCreateCart(readerId);
        
        if (cart.getItems() == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart?error=cart_empty");
            return;
        }
        
        // Chuyển CartItems sang OrderBooks
        List<OrderBook> orderBooks = new ArrayList<>();
        for (CartItem cartItem : cart.getItems()) {
            if (cartItem.getBook() == null || cartItem.getBook().getPrice() == null) {
                continue; // Bỏ qua sách không có giá
            }
            
            OrderBook orderBook = new OrderBook();
            orderBook.setBookId(cartItem.getBookId());
            orderBook.setQuantity(cartItem.getQuantity());
            orderBook.setPrice(cartItem.getBook().getPrice()); // Lấy giá từ Book
            orderBooks.add(orderBook);
        }
        
        if (orderBooks.isEmpty()) {
            request.setAttribute("error", "Không có sách hợp lệ để đặt hàng");
            handleCheckoutForm(request, response, readerId);
            return;
        }
        
        // Tạo đơn hàng
        Order order = orderDAO.createOrder(readerId, orderBooks);
        
        if (order == null) {
            request.setAttribute("error", "Không thể tạo đơn hàng. Vui lòng thử lại.");
            handleCheckoutForm(request, response, readerId);
            return;
        }
        
        // Tạo payment (mock payment - luôn thành công)
        Payment payment = paymentDAO.createPayment(order.getOrderId(), paymentMethod, 
                                                   order.getTotalAmount());
        
        if (payment != null) {
            // Mock: tự động thanh toán thành công
            paymentDAO.updatePaymentStatus(payment.getPaymentId(), "success", 
                                         "MOCK-" + System.currentTimeMillis());
            
            // Cập nhật trạng thái đơn hàng
            orderDAO.updateOrderStatus(order.getOrderId(), "paid");
        }
        
        // Đánh dấu cart là checked_out và xóa items
        cartDAO.markCartAsCheckedOut(cart.getCartId());
        cartDAO.clearCart(cart.getCartId());
        
        // Redirect đến trang thành công
        response.sendRedirect(request.getContextPath() + "/checkout/success?orderId=" + order.getOrderId());
    }
    
    /**
     * Hiển thị trang thành công
     */
    private void handleCheckoutSuccess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String orderIdParam = request.getParameter("orderId");
        
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        int orderId = Integer.parseInt(orderIdParam);
        Order order = orderDAO.getOrderById(orderId);
        
        if (order == null) {
            request.setAttribute("error", "Không tìm thấy đơn hàng");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        Payment payment = paymentDAO.getPaymentByOrderId(order.getOrderId());
        order.setPayment(payment);
        
        request.setAttribute("order", order);
        request.getRequestDispatcher("/checkout/success.jsp").forward(request, response);
    }
}
