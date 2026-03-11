package controller.seller;

import dao.BookDAO;
import dao.OrderDAO;
import model.Book;
import model.Employee;
import model.Order;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Dashboard seller: thống kê tổng doanh thu (đơn paid), tổng đơn, đơn pending, tổng sách; hiển thị catalog changes (sách cập nhật gần đây). Chỉ hiển thị dữ liệu, không CRUD.
 */
public class DashboardServlet extends HttpServlet {

    /**
     * Kiểm tra employee đăng nhập và role SELLER. Lấy tất cả đơn (getAllOrders), tính totalSales (cộng totalAmount các đơn paid), pendingOrders (số đơn pending), totalBooks (getAllBooksForManagement.size), catalogChanges (getRecentlyUpdatedBooks(10)); set attributes và forward seller/dashboard.jsp.
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

        BookDAO bookDAO = new BookDAO();
        int totalBooks = bookDAO.getAllBooksForManagement().size();
        List<Book> catalogChanges = bookDAO.getRecentlyUpdatedBooks(10);

        request.setAttribute("totalSales", totalSales);
        request.setAttribute("totalOrders", orders.size());
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("catalogChanges", catalogChanges);
        request.setAttribute("employee", employee);

        request.getRequestDispatcher("/seller/dashboard.jsp").forward(request, response);
    }
}
