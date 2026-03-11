package controller.seller;

import dao.OrderDAO;
import model.Employee;
import model.Order;
import model.TopSellingBook;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class SalesReportServlet extends HttpServlet {

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

        // Calculate total sales
        BigDecimal totalSales = BigDecimal.ZERO;
        int totalOrders = 0;
        int paidOrders = 0;
        int pendingOrders = 0;

        for (Order order : orders) {
            totalOrders++;
            if ("paid".equals(order.getStatus())) {
                paidOrders++;
                totalSales = totalSales.add(order.getTotalAmount());
            } else if ("pending".equals(order.getStatus())) {
                pendingOrders++;
            }
        }

        List<TopSellingBook> topBooks = orderDAO.getTopSellingBooks(10);

        request.setAttribute("totalSales", totalSales);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("paidOrders", paidOrders);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("orders", orders);
        request.setAttribute("topSellingBooks", topBooks);

        request.getRequestDispatcher("/seller/sales-report.jsp").forward(request, response);
    }
}
