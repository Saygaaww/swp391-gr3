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
import java.math.BigDecimal;

@WebServlet(name = "SellerReportServlet", urlPatterns = {"/seller/reports"})
public class SellerReportServlet extends HttpServlet {
    
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
        
        try {
            // Tính tổng doanh thu
            BigDecimal totalRevenue = orderDAO.getTotalRevenue();
            
            // Đếm đơn hàng theo status
            int totalOrders = orderDAO.countAllOrders();
            int paidOrders = orderDAO.countOrdersByStatus("paid");
            int pendingOrders = orderDAO.countOrdersByStatus("pending");
            int cancelledOrders = orderDAO.countOrdersByStatus("cancelled");
            int refundedOrders = orderDAO.countOrdersByStatus("refunded");
            
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("paidOrders", paidOrders);
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("cancelledOrders", cancelledOrders);
            request.setAttribute("refundedOrders", refundedOrders);
            
        } catch (SQLException e) {
            e.printStackTrace();
            // Nếu có lỗi, set giá trị mặc định
            request.setAttribute("totalRevenue", BigDecimal.ZERO);
            request.setAttribute("totalOrders", 0);
            request.setAttribute("paidOrders", 0);
            request.setAttribute("pendingOrders", 0);
            request.setAttribute("cancelledOrders", 0);
            request.setAttribute("refundedOrders", 0);
        }
        
        request.getRequestDispatcher("/seller/reports.jsp").forward(request, response);
    }
}
