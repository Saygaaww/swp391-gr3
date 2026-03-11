package controller.admin;

import dao.BorrowItemDAO;
import dao.BorrowRequestDAO;
import dao.BookDAO;
import dao.OrderDAO;
import model.Employee;
import model.Order;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Dashboard admin: tổng doanh thu (đơn paid), tổng đơn, số yêu cầu mượn đang chờ, danh sách quá hạn (overdueList), catalog changes (sách cập nhật gần đây). Chỉ hiển thị, không CRUD.
 */
public class DashboardServlet extends HttpServlet {

    /**
     * Kiểm tra employee role ADMIN. Lấy orders (getAllOrders), tính totalRevenue từ đơn paid, pendingBorrowRequests (getPendingRequests.size), overdueList (getOverdueItems), catalogChanges (getRecentlyUpdatedBooks(10)); set attributes, forward admin/dashboard.jsp.
     */
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

        BorrowItemDAO borrowItemDAO = new BorrowItemDAO();
        BookDAO bookDAO = new BookDAO();

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("pendingBorrowRequests", pendingBorrowRequests);
        request.setAttribute("overdueList", borrowItemDAO.getOverdueItems());
        request.setAttribute("catalogChanges", bookDAO.getRecentlyUpdatedBooks(10));
        request.setAttribute("employee", employee);

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
