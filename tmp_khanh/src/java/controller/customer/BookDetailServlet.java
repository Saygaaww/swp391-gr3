package controller.customer;

import dao.BookDAO;
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

public class BookDetailServlet extends HttpServlet {

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

        // Nếu đã đăng nhập, lấy review của user cho sách này (để hiển thị form chỉnh sửa nếu có)
        Review myReview = null;
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user != null) {
            myReview = reviewDAO.getByReaderAndBook(user.getReaderId(), bookId);
        }

        request.setAttribute("book", book);
        request.setAttribute("reviews", reviews);
        request.setAttribute("myReview", myReview);
        request.getRequestDispatcher("/customer/book-detail.jsp").forward(request, response);
    }
}
