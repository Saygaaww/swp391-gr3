package controller.customer;

import dao.BookDAO;
import dao.CartDAO;
import dao.OrderDAO;
import dao.PaymentDAO;
import dao.ReaderBookOwnershipDAO;
import model.Cart;
import model.CartItem;
import util.VNPayUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * Xử lý khi VNPay redirect về sau thanh toán.
 * Chỉ khi thanh toán thành công (vnp_ResponseCode=00) mới tạo đơn, trừ stock, xóa giỏ.
 * Thanh toán thất bại/hủy: giỏ hàng vẫn giữ nguyên.
 */
public class VNPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!VNPayUtil.verifyReturn(request)) {
            request.setAttribute("message", "Chữ ký không hợp lệ.");
            request.setAttribute("success", false);
            request.getRequestDispatcher("/vnpay-result.jsp").forward(request, response);
            return;
        }

        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");

        HttpSession session = request.getSession();
        String pendingRef = (String) session.getAttribute("pendingVnPayRef");
        Integer pendingReaderId = (Integer) session.getAttribute("pendingVnPayReaderId");

        // Xóa pending dù thành công hay thất bại (tránh dùng lại)
        session.removeAttribute("pendingVnPayRef");
        session.removeAttribute("pendingVnPayReaderId");

        if ("00".equals(vnp_ResponseCode) && vnp_TxnRef != null && vnp_TxnRef.equals(pendingRef) && pendingReaderId != null) {
            // Thanh toán thành công: tạo đơn, trừ stock, xóa giỏ
            CartDAO cartDAO = new CartDAO();
            Cart cart = cartDAO.getActiveCart(pendingReaderId);
            if (cart == null || cart.getItems().isEmpty()) {
                request.setAttribute("message", "Giỏ hàng không còn hoặc đã hết. Vui lòng kiểm tra đơn hàng.");
                request.setAttribute("success", false);
                request.getRequestDispatcher("/vnpay-result.jsp").forward(request, response);
                return;
            }
            BigDecimal cartTotal = cartDAO.getCartTotal(cart.getCartId());
            BookDAO bookDAO = new BookDAO();
            StringBuilder stockError = new StringBuilder();
            for (CartItem item : cart.getItems()) {
                int available = bookDAO.getAvailableStock(item.getBookId());
                if (item.getQuantity() > available) {
                    stockError.append(item.getBookTitle()).append(" chỉ còn ").append(available).append(" cuốn. ");
                }
            }
            if (stockError.length() > 0) {
                request.setAttribute("message", "Không đủ hàng: " + stockError + " Đơn chưa tạo. Giỏ hàng vẫn giữ.");
                request.setAttribute("success", false);
                request.getRequestDispatcher("/vnpay-result.jsp").forward(request, response);
                return;
            }
            OrderDAO orderDAO = new OrderDAO();
            int orderId = orderDAO.createOrder(pendingReaderId, cartTotal, "USD");
            if (orderId <= 0) {
                request.setAttribute("message", "Tạo đơn hàng thất bại. Liên hệ hỗ trợ. Giỏ hàng vẫn giữ.");
                request.setAttribute("success", false);
                request.getRequestDispatcher("/vnpay-result.jsp").forward(request, response);
                return;
            }
            ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
            for (CartItem item : cart.getItems()) {
                orderDAO.addOrderBook(orderId, item.getBookId(), item.getUnitPrice(), item.getQuantity());
                bookDAO.reduceStock(item.getBookId(), item.getQuantity());
                if (!ownershipDAO.hasOwnership(pendingReaderId, item.getBookId())) {
                    ownershipDAO.grant(pendingReaderId, item.getBookId(), "order");
                }
            }
            cartDAO.clearCart(cart.getCartId());
            cartDAO.updateCartStatus(cart.getCartId(), "checked_out");
            PaymentDAO paymentDAO = new PaymentDAO();
            paymentDAO.createPayment(orderId, cartTotal, "VNPAY", vnp_TransactionNo);
            paymentDAO.updatePaymentStatus(orderId, "success", vnp_TransactionNo);
            orderDAO.updateOrderStatus(orderId, "paid");

            request.setAttribute("message", "Thanh toán thành công. Mã giao dịch: " + vnp_TransactionNo + ". Mã đơn: " + orderId);
            request.setAttribute("success", true);
            request.setAttribute("orderId", orderId);
        } else {
            // Thanh toán thất bại hoặc hủy: không tạo đơn, không trừ stock, giỏ hàng vẫn còn
            request.setAttribute("message", "Thanh toán thất bại hoặc đã hủy. Mã lỗi: " + vnp_ResponseCode + ". Giỏ hàng vẫn giữ nguyên.");
            request.setAttribute("success", false);
            request.setAttribute("orderId", vnp_TxnRef);
        }

        request.getRequestDispatcher("/vnpay-result.jsp").forward(request, response);
    }
}
