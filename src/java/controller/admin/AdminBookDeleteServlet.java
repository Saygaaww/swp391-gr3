package controller.admin;

import dal.BookDAO;
import model.Book;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/book-delete")
public class AdminBookDeleteServlet extends HttpServlet {

    private BookDAO bookDAO;

    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/book-list");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/book-list");
                return;
            }

            int bookId = Integer.parseInt(idStr.trim());
            if (bookId <= 0 || bookId > 999999999) {
                response.sendRedirect(request.getContextPath() + "/admin/book-list");
                return;
            }

            Book book = bookDAO.getBookById(bookId);
            if (book != null) {
                bookDAO.softDeleteBook(bookId);
                session.setAttribute("successMessage", "Da vo hieu hoa sach: " + book.getTitle());
            }

            response.sendRedirect(request.getContextPath() + "/admin/book-list");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/book-list");
        }
    }
}
