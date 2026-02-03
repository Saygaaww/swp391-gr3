package controller;

import dao.OrderDAO;
import dao.ReaderDAO;
import dao.PaymentDAO;
import model.Order;
import model.Reader;
import model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "SellerOrderServlet", urlPatterns = {
    "/seller/orders",
    "/seller/orders/view",
    "/seller/orders/update-status"
})
public class SellerOrderServlet extends HttpServlet {
    
    private OrderDAO orderDAO;
    private ReaderDAO readerDAO;
    private PaymentDAO paymentDAO;
    
    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        readerDAO = new ReaderDAO();
        paymentDAO = new PaymentDAO();
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
        
        String path = request.getServletPath();
        String action = request.getParameter("action");
        
        try {
            if (path.equals("/seller/orders/view") || "view".equals(action)) {
                handleViewOrder(request, response);
            } else {
                // Mặc định: danh sách đơn hàng
                handleListOrders(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi truy vấn database: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
        
        String action = request.getParameter("action");
        
        try {
            if ("update-status".equals(action)) {
                handleUpdateStatus(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/seller/orders");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị danh sách đơn hàng
     */
    private void handleListOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String pageParam = request.getParameter("page");
        String statusFilter = request.getParameter("status");
        
        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = 20; // Số đơn hàng mỗi trang
        int offset = (page - 1) * pageSize;
        
        List<Order> orders;
        int totalOrders;
        
        if (statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter)) {
            // Filter theo status
            orders = orderDAO.getOrdersByStatus(statusFilter, offset, pageSize);
            totalOrders = orderDAO.countOrdersByStatus(statusFilter);
        } else {
            // Tất cả đơn hàng
            orders = orderDAO.getAllOrders(offset, pageSize);
            totalOrders = orderDAO.countAllOrders();
        }
        
        // Load Reader info cho mỗi order
        for (Order order : orders) {
            try {
                Reader reader = readerDAO.getReaderById(order.getReaderId());
                order.setReader(reader);
            } catch (SQLException e) {
                // Nếu không load được reader, bỏ qua
                System.err.println("Không thể load reader cho order " + order.getOrderId() + ": " + e.getMessage());
            }
        }
        
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
        
        // Tính tổng doanh thu
        java.math.BigDecimal totalRevenue = orderDAO.getTotalRevenue();
        int totalPaidOrders = orderDAO.countOrdersByStatus("paid");
        int pendingOrders = orderDAO.countOrdersByStatus("pending");
        
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalPaidOrders", totalPaidOrders);
        request.setAttribute("pendingOrders", pendingOrders);
        
        request.getRequestDispatcher("/seller/order-list.jsp").forward(request, response);
    }
    
    /**
     * Xem chi tiết đơn hàng
     */
    private void handleViewOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String orderIdParam = request.getParameter("id");
        if (orderIdParam == null || orderIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/seller/orders");
            return;
        }
        
        int orderId = Integer.parseInt(orderIdParam);
        Order order = orderDAO.getOrderById(orderId);
        
        if (order == null) {
            request.setAttribute("error", "Không tìm thấy đơn hàng với ID: " + orderId);
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        // Load Reader info
        try {
            Reader reader = readerDAO.getReaderById(order.getReaderId());
            order.setReader(reader);
        } catch (SQLException e) {
            System.err.println("Không thể load reader: " + e.getMessage());
        }
        
        // Load Payment info
        try {
            order.setPayment(paymentDAO.getPaymentByOrderId(orderId));
        } catch (SQLException e) {
            System.err.println("Không thể load payment: " + e.getMessage());
        }
        
        request.setAttribute("order", order);
        request.getRequestDispatcher("/seller/order-detail.jsp").forward(request, response);
    }
    
    /**
     * Cập nhật trạng thái đơn hàng
     */
    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        String orderIdParam = request.getParameter("orderId");
        String newStatus = request.getParameter("status");
        
        if (orderIdParam == null || newStatus == null) {
            response.sendRedirect(request.getContextPath() + "/seller/orders");
            return;
        }
        
        int orderId = Integer.parseInt(orderIdParam);
        
        // Validate status
        if (!isValidStatus(newStatus)) {
            request.setAttribute("error", "Trạng thái không hợp lệ: " + newStatus);
            response.sendRedirect(request.getContextPath() + "/seller/orders/view?id=" + orderId);
            return;
        }
        
        boolean success = orderDAO.updateOrderStatus(orderId, newStatus);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/seller/orders/view?id=" + orderId + "&message=Trạng thái đã được cập nhật");
        } else {
            request.setAttribute("error", "Không thể cập nhật trạng thái đơn hàng");
            response.sendRedirect(request.getContextPath() + "/seller/orders/view?id=" + orderId);
        }
    }
    
    /**
     * Kiểm tra status có hợp lệ không
     */
    private boolean isValidStatus(String status) {
        if (status == null) return false;
        String s = status.toLowerCase();
        return s.equals("pending") || s.equals("paid") || s.equals("cancelled") || s.equals("refunded");
    }
}
