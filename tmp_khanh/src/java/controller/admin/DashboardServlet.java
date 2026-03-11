package controller.admin;

import dao.OrderDAO;
import dao.BorrowRequestDAO;
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

        if (employee == null || !"ADMIN".equals(employee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        BorrowRequestDAO borrowRequestDAO = new BorrowRequestDAO();

        List<Order> orders = orderDAO.getAllOrders();
        int pendingBorrowRequests = borrowRequestDAO.getPendingRequests().size();

        // Calculate statistics
        BigDecimal totalRevenue = BigDecimal.ZERO;
        int totalOrders = orders.size();

        for (Order order : orders) {
            if ("paid".equals(order.getStatus())) {
                totalRevenue = totalRevenue.add(order.getTotalAmount());
            }
        }

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("pendingBorrowRequests", pendingBorrowRequests);
        request.setAttribute("employee", employee);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
