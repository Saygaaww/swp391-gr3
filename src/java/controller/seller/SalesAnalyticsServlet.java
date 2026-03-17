package controller.seller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.TopSellingBook;
import util.AuthUtil;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "SalesAnalyticsServlet", urlPatterns = {"/seller/sales-analytics"})
public class SalesAnalyticsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!AuthUtil.hasAnyRole(request, AuthUtil.ROLE_SELLER, AuthUtil.ROLE_ADMIN)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        OrderDAO orderDAO = new OrderDAO();

        int totalOrders = orderDAO.countAllOrders();
        int paidOrders = orderDAO.countOrdersByStatus("paid");
        int pendingOrders = orderDAO.countOrdersByStatus("pending");
        BigDecimal paidRevenue = orderDAO.sumTotalAmountByStatus("paid");

        List<TopSellingBook> topBooks = orderDAO.getTopSellingBooks(10);

        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("paidOrders", paidOrders);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("paidRevenue", paidRevenue);
        request.setAttribute("topBooks", topBooks);
        request.setAttribute("pageTitle", "Sales Analytics - Seller");
        request.getRequestDispatcher("/jsp/seller/sales-analytics.jsp").forward(request, response);
    }
}

