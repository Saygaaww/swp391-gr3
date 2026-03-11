package controller.customer;

import dao.OrderDAO;
import model.Order;
import model.Reader;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet lịch sử đơn hàng của reader: hiển thị danh sách đơn (GET).
 * Chỉ cho reader đã đăng nhập; lấy danh sách từ OrderDAO.getOrdersByReader(readerId), forward orders.jsp.
 */
public class OrderHistoryServlet extends HttpServlet {

    /**
     * Lấy tất cả đơn hàng của reader đăng nhập (getOrdersByReader), set orders, forward customer/orders.jsp.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader user = (Reader) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders = orderDAO.getOrdersByReader(user.getReaderId());

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/customer/orders.jsp").forward(request, response);
    }
}
