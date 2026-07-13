package controller.customer;

import dao.CartDAO;
import model.Cart;
import model.CartItem;
import model.Reader;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        HttpSession session = request.getSession();
        Reader user = (Reader) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.getOrCreateCart(user.getReaderId());
        BigDecimal cartTotal = cartDAO.getCartTotal(cart.getCartId());

        request.setAttribute("cart", cart);
        request.setAttribute("cartTotal", cartTotal);

        request.getRequestDispatcher("/customer/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        CartDAO cartDAO = new CartDAO();

        if ("update".equals(action)) {
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            if (quantity > 0) {
                CartItem item = cartDAO.getCartItemById(cartItemId);
                if (item != null && quantity > item.getAvailableStock()) {
                    quantity = Math.max(1, item.getAvailableStock());
                }
                cartDAO.updateCartItemQuantity(cartItemId, quantity);
            }
        } else if ("remove".equals(action)) {
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            cartDAO.removeItemFromCart(cartItemId);
        }

        response.sendRedirect(request.getContextPath() + "/customer/cart");
    }
}
