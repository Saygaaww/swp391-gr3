package controller.book;

import dao.BookDAO;
import dao.BorrowRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Book;
import model.Reader;

import java.io.IOException;

public class BookDetailServlet extends HttpServlet {
    private final BookDAO bookDAO = new BookDAO();
    private final BorrowRequestDAO borrowRequestDAO = new BorrowRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/BookListServlet");
            return;
        }
        int bookId;
        try {
            bookId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/BookListServlet");
            return;
        }
        Book book = bookDAO.getById(bookId);
        if (book == null) {
            response.sendRedirect(request.getContextPath() + "/BookListServlet");
            return;
        }
        int availableCount = bookDAO.countAvailableCopies(bookId);
        request.setAttribute("book", book);
        request.setAttribute("availableCount", availableCount);

        Reader user = (Reader) request.getSession().getAttribute("user");
        boolean hasPendingRequest = user != null && "USER".equals(user.getRoleName())
                && borrowRequestDAO.hasPendingRequestForBook(user.getReaderId(), bookId);
        request.setAttribute("hasPendingRequest", hasPendingRequest);

        request.getRequestDispatcher("/customer/book-detail.jsp").forward(request, response);
    }
}
