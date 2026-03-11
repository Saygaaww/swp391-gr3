package controller.customer;

import dao.BookDAO;
import dao.CartDAO;
import model.Book;
import model.Cart;
import model.Reader;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AddToCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Reader user = (Reader) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int bookId = Integer.parseInt(request.getParameter("bookId"));
        int quantity = 1;

        if (request.getParameter("quantity") != null) {
            quantity = Integer.parseInt(request.getParameter("quantity"));
        }

        BookDAO bookDAO = new BookDAO();
        Book book = bookDAO.getBookById(bookId);

        if (book == null || !"active".equals(book.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/customer/browse-books");
            return;
        }

        int available = book.getStockQuantity();
        if (available <= 0) {
            session.setAttribute("cartError", "Sách \"" + book.getTitle() + "\" đã hết hàng.");
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.getOrCreateCart(user.getReaderId());
        int alreadyInCart = 0;
        for (var item : cart.getItems()) {
            if (item.getBookId() == bookId) alreadyInCart += item.getQuantity();
        }
        int requestedTotal = alreadyInCart + quantity;
        if (requestedTotal > available) {
            session.setAttribute("cartError", "Sách \"" + book.getTitle() + "\" chỉ còn " + available + " cuốn. Bạn đã có " + alreadyInCart + " trong giỏ.");
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }

        boolean success = cartDAO.addItemToCart(cart.getCartId(), bookId, quantity, book.getPrice());

        if (success) {
            session.setAttribute("cartMessage", "Đã thêm sách vào giỏ.");
        } else {
            session.setAttribute("cartError", "Không thể thêm vào giỏ.");
        }

        response.sendRedirect(request.getContextPath() + "/customer/cart");
    }
}
