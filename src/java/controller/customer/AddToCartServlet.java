package controller.customer;

import dao.BookDAO;
import dao.CartDAO;
import dao.ReaderBookOwnershipDAO;
import model.Book;
import model.Cart;
import model.Reader;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet thêm sách vào giỏ hàng.
 * Kiểm tra: đã đăng nhập, sách tồn tại và active, chưa sở hữu sách (không cho mua lại), còn hàng, số lượng không vượt tồn kho (kể cả đã có trong giỏ).
 */
public class AddToCartServlet extends HttpServlet {

    /** GET gọi lại doPost (cùng xử lý thêm vào giỏ). */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    /**
     * Thêm sách vào giỏ.
     * 1) Kiểm tra user đăng nhập; chưa → redirect /login.
     * 2) Lấy bookId, quantity (mặc định 1); lấy Book từ DB, nếu null hoặc không active → redirect browse-books.
     * 3) Kiểm tra đã sở hữu (ReaderBookOwnershipDAO.hasOwnership): nếu đã sở hữu → set cartError "Bạn đã mua sách...", redirect /customer/cart.
     * 4) Kiểm tra tồn kho (available <= 0 → cartError "đã hết hàng"); kiểm tra (số trong giỏ + quantity) <= available → nếu vượt set cartError và redirect cart.
     * 5) Gọi cartDAO.addItemToCart(cartId, bookId, quantity, price); set cartMessage hoặc cartError, redirect /customer/cart.
     */
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

        if(request.getParameter("quantity") != null){
            quantity = Integer.parseInt(request.getParameter("quantity"));
        }
        if (request.getParameter("quantity") != null) {
            quantity = Integer.parseInt(request.getParameter("quantity"));
        }

        BookDAO bookDAO = new BookDAO();
        Book book = bookDAO.getBookById(bookId);

        if (book == null || !"active".equals(book.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/customer/browse-books");
            return;
        }

        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        if (ownershipDAO.hasOwnership(user.getReaderId(), bookId)) {
            session.setAttribute("cartError", "Bạn đã mua sách \"" + book.getTitle() + "\" rồi. Không cần mua lại.");
            response.sendRedirect(request.getContextPath() + "/customer/cart");
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
