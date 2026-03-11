package controller.customer;

import dao.BookDAO;
import dao.ReaderBookOwnershipDAO;
import dao.ReviewDAO;
import model.Book;
import model.Reader;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import model.Review;

/**
 * Servlet chi tiết sách: hiển thị thông tin sách, danh sách review, và (nếu đăng nhập) review của user + trạng thái đã sở hữu (alreadyOwned) để ẩn nút mua / hiện "Đọc sách".
 */
public class BookDetailServlet extends HttpServlet {

    /**
     * Lấy bookId; getBookById; getByBook reviews; nếu user đăng nhập: getByReaderAndBook myReview, hasOwnership alreadyOwned; set book, reviews, myReview, alreadyOwned; forward book-detail.jsp.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookIdParam = request.getParameter("bookId");
        if (bookIdParam == null || bookIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/browse-books");
            return;
        }

        int bookId;
        try {
            bookId = Integer.parseInt(bookIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/customer/browse-books");
            return;
        }

        BookDAO bookDAO = new BookDAO();
        Book book = bookDAO.getBookById(bookId);
        if (book == null) {
            response.sendRedirect(request.getContextPath() + "/customer/browse-books");
            return;
        }

        ReviewDAO reviewDAO = new ReviewDAO();
        List<Review> reviews = reviewDAO.getByBook(bookId);

        // Nếu đã đăng nhập, lấy review của user và kiểm tra đã sở hữu sách chưa
        Review myReview = null;
        boolean alreadyOwned = false;
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user != null) {
            myReview = reviewDAO.getByReaderAndBook(user.getReaderId(), bookId);
            ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
            alreadyOwned = ownershipDAO.hasOwnership(user.getReaderId(), bookId);
        }

        request.setAttribute("book", book);
        request.setAttribute("alreadyOwned", alreadyOwned);
        request.setAttribute("reviews", reviews);
        request.setAttribute("myReview", myReview);
        request.getRequestDispatcher("/customer/book-detail.jsp").forward(request, response);
    }
}
