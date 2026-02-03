package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.PaymentDAO;
import dao.ReaderDAO;
import model.Cart;
import model.CartItem;
import model.Employee;
import model.Order;
import model.OrderBook;
import model.Payment;
import model.Reader;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "SellerCheckoutServlet", urlPatterns = {
    "/seller/checkout",
    "/seller/checkout/process",
    "/seller/checkout/success"
})
public class SellerCheckoutServlet extends HttpServlet {

    private CartDAO cartDAO;
    private OrderDAO orderDAO;
    private PaymentDAO paymentDAO;
    private ReaderDAO readerDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        orderDAO = new OrderDAO();
        paymentDAO = new PaymentDAO();
        readerDAO = new ReaderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

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

        try {
            if ("/seller/checkout/success".equals(path)) {
                request.getRequestDispatcher("/seller/checkout-success.jsp").forward(request, response);
                return;
            }

            Integer selectedReaderId = (Integer) session.getAttribute("sellerSelectedReaderId");
            if (selectedReaderId == null) {
                response.sendRedirect(request.getContextPath() + "/seller/cart/select-customer?error=no_customer_selected");
                return;
            }

            Reader customer = readerDAO.getReaderById(selectedReaderId);
            if (customer == null) {
                session.removeAttribute("sellerSelectedReaderId");
                response.sendRedirect(request.getContextPath() + "/seller/cart/select-customer?error=customer_not_found");
                return;
            }

            Cart cart = cartDAO.getOrCreateCart(selectedReaderId);
            if (cart.getItems() == null || cart.getItems().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/seller/cart?error=cart_empty");
                return;
            }

            request.setAttribute("cart", cart);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/seller/checkout.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

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
        if (!"/seller/checkout/process".equals(path)) {
            response.sendRedirect(request.getContextPath() + "/seller/checkout");
            return;
        }

        try {
            Integer selectedReaderId = (Integer) session.getAttribute("sellerSelectedReaderId");
            if (selectedReaderId == null) {
                response.sendRedirect(request.getContextPath() + "/seller/cart/select-customer?error=no_customer_selected");
                return;
            }

            String paymentMethod = request.getParameter("paymentMethod");
            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/seller/checkout?error=missing_payment_method");
                return;
            }

            Cart cart = cartDAO.getOrCreateCart(selectedReaderId);
            if (cart.getItems() == null || cart.getItems().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/seller/cart?error=cart_empty");
                return;
            }

            List<OrderBook> orderBooks = new ArrayList<>();
            for (CartItem cartItem : cart.getItems()) {
                if (cartItem.getBook() == null || cartItem.getBook().getPrice() == null) {
                    continue;
                }
                OrderBook ob = new OrderBook();
                ob.setBookId(cartItem.getBookId());
                ob.setQuantity(cartItem.getQuantity());
                ob.setPrice(cartItem.getBook().getPrice());
                orderBooks.add(ob);
            }

            if (orderBooks.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/seller/cart?error=no_valid_items");
                return;
            }

            Order order = orderDAO.createOrder(selectedReaderId, orderBooks);
            if (order == null) {
                response.sendRedirect(request.getContextPath() + "/seller/checkout?error=create_order_failed");
                return;
            }

            Payment payment = paymentDAO.createPayment(order.getOrderId(), paymentMethod, order.getTotalAmount());
            if (payment != null) {
                paymentDAO.updatePaymentStatus(payment.getPaymentId(), "success", "MOCK-" + System.currentTimeMillis());
                orderDAO.updateOrderStatus(order.getOrderId(), "paid");
            }

            cartDAO.markCartAsCheckedOut(cart.getCartId());
            cartDAO.clearCart(cart.getCartId());

            // Cho phép seller tiếp tục bán cho khách khác: giữ customer selection
            response.sendRedirect(request.getContextPath() + "/seller/checkout/success?orderId=" + order.getOrderId());
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}

