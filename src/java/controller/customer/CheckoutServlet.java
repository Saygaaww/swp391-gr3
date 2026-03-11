package controller.customer;

import dao.BookDAO;
import dao.CartDAO;
import dao.OrderDAO;
import dao.PaymentDAO;
import dao.ReaderBookOwnershipDAO;
import model.Cart;
import model.CartItem;
import model.Reader;
import util.VNPayUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * Servlet thanh toán giỏ hàng: GET hiển thị trang checkout, POST xử lý thanh toán (COD hoặc VNPay).
 * COD: tạo đơn ngay, trừ tồn kho, cấp quyền sở hữu, xóa giỏ. VNPay: chỉ redirect sang VNPay; tạo đơn/trừ stock/xóa giỏ khi VNPay return thành công (VNPayReturnServlet).
 */
public class CheckoutServlet extends HttpServlet {

    /**
     * Hiển thị trang checkout (form chọn phương thức thanh toán).
     * - Kiểm tra đăng nhập; giỏ rỗng → redirect /customer/cart.
     * - Kiểm tra không có sách nào trong giỏ mà reader đã sở hữu (nếu có → cartError, redirect cart).
     * - Set cart, cartTotal, forward checkout.jsp.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader user = (Reader) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.getOrCreateCart(user.getReaderId());
        BigDecimal cartTotal = cartDAO.getCartTotal(cart.getCartId());

        if (cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }

        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        for (CartItem item : cart.getItems()) {
            if (ownershipDAO.hasOwnership(user.getReaderId(), item.getBookId())) {
                session.setAttribute("cartError", "Giỏ hàng có sách bạn đã sở hữu. Vui lòng xóa khỏi giỏ rồi thanh toán.");
                response.sendRedirect(request.getContextPath() + "/customer/cart");
                return;
            }
        }

        request.setAttribute("cart", cart);
        request.setAttribute("cartTotal", cartTotal);

        request.getRequestDispatcher("/customer/checkout.jsp").forward(request, response);
    }

    /**
     * Xử lý thanh toán khi user submit form checkout.
     * - Kiểm tra đăng nhập, giỏ không rỗng, không có sách đã sở hữu trong giỏ.
     * - Kiểm tra tồn kho đủ cho từng mục; không đủ → cartError, redirect cart.
     * - paymentMethod=vnpay: lưu pendingVnPayRef, pendingVnPayReaderId vào session; tạo URL VNPay (VNPayUtil.createPaymentUrl) với amount VND; redirect sang VNPay (không tạo đơn ở đây).
     * - paymentMethod khác (COD): tạo đơn (createOrder), addOrderBook từng mục, reduceStock, grant ownership nếu chưa có, clearCart, updateCartStatus checked_out; redirect /customer/orders với successMessage.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader user = (Reader) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String paymentMethod = request.getParameter("paymentMethod");
        CartDAO cartDAO = new CartDAO();
        OrderDAO orderDAO = new OrderDAO();

        Cart cart = cartDAO.getOrCreateCart(user.getReaderId());
        BigDecimal cartTotal = cartDAO.getCartTotal(cart.getCartId());

        if (cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }

        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        for (CartItem item : cart.getItems()) {
            if (ownershipDAO.hasOwnership(user.getReaderId(), item.getBookId())) {
                session.setAttribute("cartError", "Giỏ hàng có sách bạn đã sở hữu. Vui lòng xóa khỏi giỏ rồi thanh toán.");
                response.sendRedirect(request.getContextPath() + "/customer/cart");
                return;
            }
        }

        // Validate stock: neu bat ky sach nao khong du hang -> quay ve gio, khong tao don
        BookDAO bookDAO = new BookDAO();
        StringBuilder stockError = new StringBuilder();
        for (CartItem item : cart.getItems()) {
            int available = bookDAO.getAvailableStock(item.getBookId());
            if (item.getQuantity() > available) {
                stockError.append(item.getBookTitle()).append(" chỉ còn ").append(available).append(" cuốn. ");
            }
        }
        if (stockError.length() > 0) {
            session.setAttribute("cartError", "Không đủ hàng: " + stockError);
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }

        // Thanh toan VNPay: KHONG tao don / tru stock / xoa gio - chi redirect. Don + tru stock + xoa gio khi VNPay return thanh cong.
        if ("vnpay".equals(paymentMethod)) {
            String txnRef = "VN" + System.currentTimeMillis() + "-" + user.getReaderId();
            session.setAttribute("pendingVnPayRef", txnRef);
            session.setAttribute("pendingVnPayReaderId", user.getReaderId());
            try {
                String returnUrl = request.getScheme() + "://" + request.getServerName()
                        + (request.getServerPort() == 80 || request.getServerPort() == 443 ? "" : ":" + request.getServerPort())
                        + request.getContextPath() + "/vnpay-return";
                long amountVnd = cartTotal.longValue(); // Đã lưu VND trong DB
                String orderInfo = "Thanh toan gio hang " + txnRef;
                String ipAddr = request.getRemoteAddr();
                String vnpayUrl = VNPayUtil.createPaymentUrl(amountVnd, txnRef, orderInfo, returnUrl, ipAddr);
                response.sendRedirect(vnpayUrl);
            } catch (Exception e) {
                e.printStackTrace();
                session.removeAttribute("pendingVnPayRef");
                session.removeAttribute("pendingVnPayReaderId");
                session.setAttribute("cartError", "Lỗi VNPay: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/customer/cart");
            }
            return;
        }

        // COD: tạo đơn (pending), trừ tồn kho, xóa giỏ — KHÔNG cấp sở hữu; chỉ cấp khi seller "Xác nhận thanh toán" (markPaid).
        int orderId = orderDAO.createOrder(user.getReaderId(), cartTotal, "VND");
        if (orderId <= 0) {
            session.setAttribute("cartError", "Tạo đơn hàng thất bại. Thử lại.");
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }
        for (CartItem item : cart.getItems()) {
            orderDAO.addOrderBook(orderId, item.getBookId(), item.getUnitPrice(), item.getQuantity());
            bookDAO.reduceStock(item.getBookId(), item.getQuantity());
            // Không grant ở đây — đơn pending chưa thanh toán, chỉ grant khi markPaid.
        }
        cartDAO.clearCart(cart.getCartId());
        cartDAO.updateCartStatus(cart.getCartId(), "checked_out");
        session.setAttribute("successMessage", "Đặt hàng thành công. Mã đơn: " + orderId + ". Sau khi seller xác nhận thanh toán, sách sẽ vào Thư viện của tôi.");
        response.sendRedirect(request.getContextPath() + "/customer/orders");
    }
}
