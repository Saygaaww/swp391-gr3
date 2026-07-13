package controller.admin;

import dao.OrderDAO;
import model.Order;
import model.TopSellingBook;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({ "/admin/sales-analytics" })
public class AdminSalesAnalyticsServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        List<Order> orders = orderDAO.getAllOrders();
        int totalVolume = 0;
        BigDecimal totalRevenue = BigDecimal.ZERO;
        
        if (orders != null) {
            for (Order o : orders) {
                if ("paid".equals(o.getStatus()) || "delivered".equals(o.getStatus())) {
                    totalVolume++;
                    if (o.getTotalAmount() != null) {
                        totalRevenue = totalRevenue.add(o.getTotalAmount());
                    }
                }
            }
        }
        
        List<TopSellingBook> topBooks = orderDAO.getTopSellingBooks(10);

        request.setAttribute("totalVolume", totalVolume);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("topBooks", topBooks);
        
        request.setAttribute("pageTitle", "Sales Analytics - Digital Library");
        request.getRequestDispatcher("/jsp/admin/sales-analytics.jsp").forward(request, response);
    }
}

