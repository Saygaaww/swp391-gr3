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

public class CheckoutServlet extends HttpServlet {

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

        request.setAttribute("cart", cart);
        request.setAttribute("cartTotal", cartTotal);

        request.getRequestDispatcher("/customer/checkout.jsp").forward(request, response);
    }

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
                long amountVnd = VNPayUtil.usdToVnd(cartTotal);
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

        // COD: tao don, tru ton kho, xoa gio
        int orderId = orderDAO.createOrder(user.getReaderId(), cartTotal, "USD");
        if (orderId <= 0) {
            session.setAttribute("cartError", "Tạo đơn hàng thất bại. Thử lại.");
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }
        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        for (CartItem item : cart.getItems()) {
            orderDAO.addOrderBook(orderId, item.getBookId(), item.getUnitPrice(), item.getQuantity());
            bookDAO.reduceStock(item.getBookId(), item.getQuantity());
            if (!ownershipDAO.hasOwnership(user.getReaderId(), item.getBookId())) {
                ownershipDAO.grant(user.getReaderId(), item.getBookId(), "order");
            }
        }
        cartDAO.clearCart(cart.getCartId());
        cartDAO.updateCartStatus(cart.getCartId(), "checked_out");
        session.setAttribute("successMessage", "Đặt hàng thành công. Mã đơn: " + orderId);
        response.sendRedirect(request.getContextPath() + "/customer/orders");
    }
}
