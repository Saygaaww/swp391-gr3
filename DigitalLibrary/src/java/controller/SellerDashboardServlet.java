package controller;

import dao.OrderDAO;
import model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import utils.DemoDataSeeder;

@WebServlet(name = "SellerDashboardServlet", urlPatterns = {"/seller/dashboard"})
public class SellerDashboardServlet extends HttpServlet {
    
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra đăng nhập và quyền SELLER
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Employee employee = (Employee) session.getAttribute("employee");
        String userRole = (String) session.getAttribute("userRole");
        
        if (employee == null || userRole == null || !"SELLER".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Seed demo data 1 lần / session để seller có dữ liệu xem (nếu DB trống)
        if (session.getAttribute("sellerDemoSeeded") == null) {
            DemoDataSeeder.SeedResult seed = DemoDataSeeder.seedIfNeeded();
            session.setAttribute("sellerDemoSeeded", Boolean.TRUE);
            request.setAttribute("seedMessage", seed.message);
            request.setAttribute("seedSuccess", seed.success);
        }
        
        try {
            // Lấy thống kê thực tế
            int totalOrders = orderDAO.countAllOrders();
            int paidOrders = orderDAO.countOrdersByStatus("paid");
            int pendingOrders = orderDAO.countOrdersByStatus("pending");
            java.math.BigDecimal totalRevenue = orderDAO.getTotalRevenue();
            
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("paidOrders", paidOrders);
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("totalRevenue", totalRevenue);
            
        } catch (SQLException e) {
            e.printStackTrace();
            // Nếu có lỗi, set giá trị mặc định
            request.setAttribute("totalOrders", 0);
            request.setAttribute("paidOrders", 0);
            request.setAttribute("pendingOrders", 0);
            request.setAttribute("totalRevenue", java.math.BigDecimal.ZERO);
        }
        
        request.getRequestDispatcher("/seller/dashboard.jsp").forward(request, response);
    }
}
