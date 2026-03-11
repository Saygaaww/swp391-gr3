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

/**
 * Báo cáo bán hàng (seller): lọc đơn theo khoảng ngày (fromDate, toDate); thống kê totalSales, totalOrders, paid/pending/cancelled/refunded; top sách bán chạy (getTopSellingBooks).
 */
public class SalesReportServlet extends HttpServlet {

    /**
     * Kiểm tra employee role SELLER. Lấy fromDate, toDate; nếu có → getOrdersByDateRange, không thì getAllOrders; tính totalSales (cộng totalAmount đơn paid), đếm paid/pending/cancelled/refunded; getTopSellingBooks(10); set attributes, forward sales-report.jsp.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");

        if (employee == null || !"SELLER".equalsIgnoreCase(employee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders;
        if ((fromDate != null && !fromDate.isEmpty()) || (toDate != null && !toDate.isEmpty())) {
            orders = orderDAO.getOrdersByDateRange(fromDate, toDate);
        } else {
            orders = orderDAO.getAllOrders();
        }

        BigDecimal totalSales = BigDecimal.ZERO;
        int totalOrders = 0;
        int paidOrders = 0;
        int pendingOrders = 0;
        int cancelledOrders = 0;
        int refundedOrders = 0;

        for (Order order : orders) {
            totalOrders++;
            String st = order.getStatus();
            if ("paid".equals(st)) {
                paidOrders++;
                totalSales = totalSales.add(order.getTotalAmount());
            } else if ("pending".equals(st)) {
                pendingOrders++;
            } else if ("cancelled".equals(st)) {
                cancelledOrders++;
            } else if ("refunded".equals(st)) {
                refundedOrders++;
            }
        }

        List<TopSellingBook> topBooks = orderDAO.getTopSellingBooks(10);

        request.setAttribute("totalSales", totalSales);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("paidOrders", paidOrders);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("cancelledOrders", cancelledOrders);
        request.setAttribute("refundedOrders", refundedOrders);
        request.setAttribute("orders", orders);
        request.setAttribute("topSellingBooks", topBooks);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);

        request.getRequestDispatcher("/seller/sales-report.jsp").forward(request, response);
    }
}
