package controller.customer;

import dao.OrderDAO;
import dao.PaymentDAO;
import model.Order;
import model.Payment;
import model.Reader;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Servlet chi tiết đơn hàng (customer): xem một đơn theo orderId.
 * Chỉ cho phép xem đơn thuộc về reader đăng nhập (order.getReaderId() == user.getReaderId()); nếu không thuộc hoặc order null → redirect orders.
 */
public class OrderDetailServlet extends HttpServlet {

    /**
     * Lấy orderId từ request; kiểm tra đăng nhập; getOrderById; kiểm tra order thuộc user; lấy Payment (getByOrderId); set order, payment; forward customer/order-detail.jsp.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/orders");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/customer/orders");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.getOrderById(orderId);
        if (order == null || order.getReaderId() != user.getReaderId()) {
            response.sendRedirect(request.getContextPath() + "/customer/orders");
            return;
        }

        PaymentDAO paymentDAO = new PaymentDAO();
        Payment payment = paymentDAO.getByOrderId(orderId);

        request.setAttribute("order", order);
        request.setAttribute("payment", payment);
        request.getRequestDispatcher("/customer/order-detail.jsp").forward(request, response);
    }
}
