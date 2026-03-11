package controller.customer;

import dao.CartDAO;
import model.Cart;
import model.CartItem;
import model.Reader;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * Servlet quản lý giỏ hàng: xem giỏ (GET), cập nhật số lượng hoặc xóa mục
 * (POST). Chỉ cho phép khi đã đăng nhập (Reader). Tổng tiền lấy từ
 * CartDAO.getCartTotal (VND).
 */
public class CartServlet extends HttpServlet {

    /**
     * Hiển thị trang giỏ hàng. - Kiểm tra đăng nhập (user trong session); chưa
     * đăng nhập → redirect /login. - Lấy hoặc tạo giỏ cho reader
     * (getOrCreateCart), tính tổng tiền (getCartTotal). - Set cart, cartTotal
     * vào request, forward tới customer/cart.jsp.
     *
     * @param request
     * @param response
     * @throws jakarta.servlet.ServletException
     * @throws java.io.IOException
     */
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

    /**
     * Cập nhật giỏ hàng: update số lượng hoặc remove mục. - action=update:
     * cartItemId, quantity; nếu quantity > availableStock thì giới hạn về
     * stock; gọi updateCartItemQuantity. - action=remove: cartItemId; gọi
     * removeItemFromCart. Sau khi xử lý → redirect /customer/cart.
     *
     * @param request
     * @param response
     * @throws jakarta.servlet.ServletException
     * @throws java.io.IOException
     */
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
