package controller.seller;

import dao.OrderDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import model.Order;
import model.Payment;
import util.AuthUtil;

public class SellerOrderManagementServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SellerOrderManagementServlet.class.getName());
    private final OrderDAO orderDAO = new OrderDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AuthUtil.isLoggedIn(request) || !AuthUtil.isSeller(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Integer employeeId = AuthUtil.getEmployeeId(request);
        if (employeeId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        Integer userId = getSessionUserId(request);

        String view = request.getParameter("view");
        if ("details".equalsIgnoreCase(view)) {
            handleOrderDetails(request, response, employeeId, userId);
            return;
        }

        String status = normalizeStatus(request.getParameter("status"));
        Date fromDate = parseDate(request.getParameter("fromDate"));
        Date toDate = parseDate(request.getParameter("toDate"));

        List<Order> rawOrders = orderDAO.getSellerOrders(employeeId, userId, status, fromDate, toDate);
        LOGGER.info("[SellerOrderMgmt] GET list: employeeId=" + employeeId
                + ", userId=" + userId
                + ", status=" + status
                + ", fromDate=" + fromDate
                + ", toDate=" + toDate
                + ", rawOrders=" + rawOrders.size());
        Map<Integer, Payment> paymentMap = new HashMap<>();

        for (Order order : rawOrders) {
            Payment payment = paymentDAO.getByOrderId(order.getOrderId());
            LOGGER.info("[SellerOrderMgmt] Order #" + order.getOrderId()
                    + " paymentMethod=" + (payment == null ? "null" : payment.getPaymentMethod())
                    + ", paymentStatus=" + (payment == null ? "null" : payment.getPaymentStatus())
                    + ", orderStatus=" + order.getStatus());
            paymentMap.put(order.getOrderId(), payment);
        }
        LOGGER.info("[SellerOrderMgmt] Final list count=" + rawOrders.size());

        request.setAttribute("orders", rawOrders);
        request.setAttribute("paymentMap", paymentMap);
        request.setAttribute("selectedStatus", status == null ? "" : status);
        request.setAttribute("fromDate", request.getParameter("fromDate"));
        request.setAttribute("toDate", request.getParameter("toDate"));

        forwardFlash(request);
        request.getRequestDispatcher("/jsp/seller/order-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AuthUtil.isLoggedIn(request) || !AuthUtil.isSeller(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Integer employeeId = AuthUtil.getEmployeeId(request);
        if (employeeId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        Integer userId = getSessionUserId(request);

        String action = request.getParameter("action");
        int orderId = parseInt(request.getParameter("orderId"));
        LOGGER.info("[SellerOrderMgmt] POST action=" + action
                + ", orderId=" + orderId
                + ", employeeId=" + employeeId
                + ", userId=" + userId);
        if (orderId <= 0) {
            setFlash(request, "error", "Order ID khong hop le.");
            response.sendRedirect(request.getContextPath() + "/seller/order-management");
            return;
        }

        if (!orderDAO.sellerOwnsOrder(orderId, employeeId, userId)) {
            setFlash(request, "error", "Ban khong co quyen xu ly don hang nay.");
            response.sendRedirect(request.getContextPath() + "/seller/order-management");
            return;
        }

        Payment payment = paymentDAO.getByOrderId(orderId);
        if (!isCodPayment(payment)) {
            setFlash(request, "error", "Don nay khong phai COD.");
            response.sendRedirect(request.getContextPath() + "/seller/order-management");
            return;
        }

        if (!"pending".equalsIgnoreCase(payment.getPaymentStatus())) {
            setFlash(request, "error", "Don COD nay da duoc xu ly truoc do.");
            response.sendRedirect(request.getContextPath() + "/seller/order-management");
            return;
        }

        if ("confirm-cod".equals(action)) {
            paymentDAO.updatePaymentStatus(orderId, "success", "COD-RECEIVED");
            orderDAO.updateOrderStatus(orderId, "paid");
            setFlash(request, "message", "Da xac nhan COD thanh cong cho don #" + orderId + ".");
        } else {
            setFlash(request, "error", "Hanh dong khong hop le.");
        }

        response.sendRedirect(request.getContextPath() + "/seller/order-management");
    }

    private void handleOrderDetails(HttpServletRequest request, HttpServletResponse response, int employeeId, Integer userId)
            throws ServletException, IOException {
        int orderId = parseInt(request.getParameter("orderId"));
        if (orderId <= 0) {
            response.sendRedirect(request.getContextPath() + "/seller/order-management");
            return;
        }

        Order order = orderDAO.getSellerOrderById(orderId, employeeId, userId);
        LOGGER.info("[SellerOrderMgmt] VIEW details orderId=" + orderId
                + ", employeeId=" + employeeId
                + ", userId=" + userId
                + ", found=" + (order != null));
        if (order == null) {
            setFlash(request, "error", "Khong tim thay don hang hoac ban khong co quyen xem.");
            response.sendRedirect(request.getContextPath() + "/seller/order-management");
            return;
        }

        Payment payment = paymentDAO.getByOrderId(orderId);
        request.setAttribute("order", order);
        request.setAttribute("payment", payment);
        forwardFlash(request);
        request.getRequestDispatcher("/jsp/seller/order-details.jsp").forward(request, response);
    }

    private boolean isCodPayment(Payment payment) {
        if (payment == null || payment.getPaymentMethod() == null) {
            return false;
        }
        String normalizedMethod = payment.getPaymentMethod().trim().toLowerCase();
        return "cod".equals(normalizedMethod)
                || "cash on delivery".equals(normalizedMethod)
                || "thanh toan khi nhan hang".equals(normalizedMethod);
    }

    private String normalizeStatus(String rawStatus) {
        if (rawStatus == null || rawStatus.isBlank() || "all".equalsIgnoreCase(rawStatus)) {
            return null;
        }
        String value = rawStatus.trim().toLowerCase();
        if ("pending".equals(value) || "paid".equals(value)) {
            return value;
        }
        return null;
    }

    private Date parseDate(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return Date.valueOf(value);
        } catch (Exception e) {
            return null;
        }
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return -1;
        }
    }

    private Integer getSessionUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object raw = session.getAttribute(AuthUtil.SESSION_USER_ID);
        if (raw instanceof Integer) {
            return (Integer) raw;
        }
        if (raw != null) {
            try {
                return Integer.parseInt(raw.toString());
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }

    private void setFlash(HttpServletRequest request, String type, String message) {
        HttpSession session = request.getSession();
        if ("error".equals(type)) {
            session.setAttribute("sellerOrderError", message);
        } else {
            session.setAttribute("sellerOrderMessage", message);
        }
    }

    private void forwardFlash(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }

        Object flashMessage = session.getAttribute("sellerOrderMessage");
        Object flashError = session.getAttribute("sellerOrderError");
        if (flashMessage != null) {
            request.setAttribute("sellerOrderMessage", flashMessage);
            session.removeAttribute("sellerOrderMessage");
        }
        if (flashError != null) {
            request.setAttribute("sellerOrderError", flashError);
            session.removeAttribute("sellerOrderError");
        }
    }
}
