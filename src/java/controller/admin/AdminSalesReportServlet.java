package controller.admin;

import dao.OrderDAO;
import dao.PaymentDAO;
import model.Order;
import model.Payment;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({ "/admin/sales-report" })
public class AdminSalesReportServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        List<Order> orders = orderDAO.getAllOrders();
        Map<Integer, Payment> paymentMap = new HashMap<>();
        if (orders != null) {
            for (Order o : orders) {
                Payment p = paymentDAO.getByOrderId(o.getOrderId());
                paymentMap.put(o.getOrderId(), p);
            }
        }

        request.setAttribute("orders", orders);
        request.setAttribute("paymentMap", paymentMap);
        request.setAttribute("pageTitle", "Sales Report - Digital Library");
        request.getRequestDispatcher("/jsp/admin/sales-report.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");

        if (orderIdStr != null && !orderIdStr.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                if ("cancel".equals(action)) {
                    orderDAO.updateOrderStatus(orderId, "cancelled");
                } else if ("refund".equals(action)) {
                    orderDAO.updateOrderStatus(orderId, "refunded");
                    paymentDAO.updatePaymentStatus(orderId, "refunded", "REFUNDED");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/sales-report");
    }
}

