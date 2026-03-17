package controller.seller;

import dao.OrderDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;
import model.Payment;
import util.AuthUtil;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SalesReportServlet", urlPatterns = {"/seller/sales-report"})
public class SalesReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!AuthUtil.hasAnyRole(request, AuthUtil.ROLE_SELLER, AuthUtil.ROLE_ADMIN)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        PaymentDAO paymentDAO = new PaymentDAO();

        List<Order> orders = orderDAO.getAllOrders();
        for (Order o : orders) {
            Payment p = paymentDAO.getByOrderId(o.getOrderId());
            request.setAttribute("payment_" + o.getOrderId(), p);
        }

        request.setAttribute("orders", orders);
        request.setAttribute("pageTitle", "Sales Report - Seller");
        request.getRequestDispatcher("/jsp/seller/sales-report.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!AuthUtil.hasAnyRole(request, AuthUtil.ROLE_SELLER, AuthUtil.ROLE_ADMIN)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");
        if (action == null || orderIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/seller/sales-report");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/seller/sales-report?msg=invalid");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        PaymentDAO paymentDAO = new PaymentDAO();

        Order order = orderDAO.getOrderById(orderId);
        Payment payment = paymentDAO.getByOrderId(orderId);
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/seller/sales-report?msg=notfound");
            return;
        }

        boolean ok = false;
        if ("cancel".equals(action)) {
            boolean canCancel = "pending".equalsIgnoreCase(String.valueOf(order.getStatus()))
                    && (payment == null || !"success".equalsIgnoreCase(String.valueOf(payment.getPaymentStatus())));
            if (canCancel) {
                ok = orderDAO.updateOrderStatus(orderId, "cancelled");
            }
        } else if ("refund".equals(action)) {
            boolean canRefund = "paid".equalsIgnoreCase(String.valueOf(order.getStatus()))
                    && payment != null
                    && "success".equalsIgnoreCase(String.valueOf(payment.getPaymentStatus()));
            if (canRefund) {
                ok = orderDAO.updateOrderStatus(orderId, "refund_requested");
            }
        }

        response.sendRedirect(request.getContextPath() + "/seller/sales-report?msg=" + (ok ? "ok" : "denied"));
    }
}

