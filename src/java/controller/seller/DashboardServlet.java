package controller.seller;

import dao.OrderDAO;
import model.Employee;
import model.Order;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");

        if (employee == null || !"SELLER".equalsIgnoreCase(employee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders = orderDAO.getAllOrders();

        // Calculate statistics
        BigDecimal totalSales = BigDecimal.ZERO;
        int pendingOrders = 0;

        for (Order order : orders) {
            if ("paid".equals(order.getStatus())) {
                totalSales = totalSales.add(order.getTotalAmount());
            } else if ("pending".equals(order.getStatus())) {
                pendingOrders++;
            }
        }

        request.setAttribute("totalSales", totalSales);
        request.setAttribute("totalOrders", orders.size());
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("employee", employee);

        request.getRequestDispatcher("/seller/dashboard.jsp").forward(request, response);
    }
}
