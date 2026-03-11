package controller.seller;

import dao.BookDAO;
import dao.OrderDAO;
import dao.PaymentDAO;
import dao.ReaderBookOwnershipDAO;
import model.Employee;
import model.Order;
import model.OrderBook;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet quản lý đơn hàng (seller): xem danh sách đơn (GET), hủy/hoàn tiền/xác nhận thanh toán COD (POST).
 */
public class OrderManagementServlet extends HttpServlet {

    /**
     * Hiển thị trang danh sách đơn: kiểm tra employee role SELLER; getAllOrders; set orders; forward seller/orders.jsp.
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

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/seller/orders.jsp").forward(request, response);
    }

    /**
     * Xử lý action: cancel (cập nhật status cancelled), refund (refunded), markPaid (đơn pending → paid, tạo Payment COD nếu chưa có và updatePaymentStatus success). Redirect /seller/orders.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");

        if (employee == null || !"SELLER".equalsIgnoreCase(employee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        int orderId = Integer.parseInt(request.getParameter("orderId"));

        OrderDAO orderDAO = new OrderDAO();

        if ("cancel".equals(action)) {
            Order order = orderDAO.getOrderById(orderId);
            if (order != null && order.getOrderBooks() != null) {
                BookDAO bookDAO = new BookDAO();
                for (OrderBook ob : order.getOrderBooks()) {
                    bookDAO.restoreStock(ob.getBookId(), ob.getQuantity());
                }
                ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
                ownershipDAO.revokeByOrderId(orderId);
            }
            orderDAO.updateOrderStatus(orderId, "cancelled");
            session.setAttribute("successMessage", "Đã hủy đơn. Quyền sở hữu sách đã thu hồi và tồn kho đã hoàn.");
        } else if ("refund".equals(action)) {
            Order order = orderDAO.getOrderById(orderId);
            if (order != null && order.getOrderBooks() != null) {
                BookDAO bookDAO = new BookDAO();
                for (OrderBook ob : order.getOrderBooks()) {
                    bookDAO.restoreStock(ob.getBookId(), ob.getQuantity());
                }
                ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
                ownershipDAO.revokeByOrderId(orderId);
            }
            orderDAO.updateOrderStatus(orderId, "refunded");
            session.setAttribute("successMessage", "Đã hoàn tiền. Quyền sở hữu sách đã thu hồi và tồn kho đã hoàn.");
        } else if ("markPaid".equals(action)) {
            Order order = orderDAO.getOrderById(orderId);
            if (order != null && "pending".equals(order.getStatus())) {
                orderDAO.updateOrderStatus(orderId, "paid");
                PaymentDAO paymentDAO = new PaymentDAO();
                if (paymentDAO.getByOrderId(orderId) == null) {
                    paymentDAO.createPayment(orderId, order.getTotalAmount(), "COD", "COD-" + orderId);
                    paymentDAO.updatePaymentStatus(orderId, "success", "COD-" + orderId);
                }
                // Cấp quyền sở hữu sách khi xác nhận thanh toán COD — sách mới vào My Library và được đọc.
                ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
                if (order.getOrderBooks() != null) {
                    for (OrderBook ob : order.getOrderBooks()) {
                        if (!ownershipDAO.hasOwnership(order.getReaderId(), ob.getBookId())) {
                            ownershipDAO.grant(order.getReaderId(), ob.getBookId(), "order", orderId);
                        }
                    }
                }
                session.setAttribute("successMessage", "Đã xác nhận thanh toán đơn #" + orderId + ". Khách đã có thể đọc sách trong Thư viện.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/seller/orders");
    }
}
