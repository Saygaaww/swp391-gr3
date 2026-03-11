package controller.seller;

import dao.OrderDAO;
import dao.PaymentDAO;
import model.Employee;
import model.Order;
import model.Payment;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Chi tiết đơn hàng (seller): xem một đơn theo orderId, không kiểm tra quyền sở hữu (seller xem mọi đơn).
 */
public class SellerOrderDetailServlet extends HttpServlet {

    /**
     * Kiểm tra employee role SELLER; lấy orderId; getOrderById, getByOrderId payment; set order, payment; forward seller/order-detail.jsp.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Employee employee = (Employee) request.getSession().getAttribute("employee");
        if (employee == null || !"SELLER".equalsIgnoreCase(employee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/seller/orders");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/seller/orders");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/seller/orders");
            return;
        }

        Payment payment = new PaymentDAO().getByOrderId(orderId);

        request.setAttribute("order", order);
        request.setAttribute("payment", payment);
        request.getRequestDispatcher("/seller/order-detail.jsp").forward(request, response);
    }
}
