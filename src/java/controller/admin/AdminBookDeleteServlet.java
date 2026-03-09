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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/books-list");
                return;
            }

            int bookId = Integer.parseInt(idStr.trim());
            if (bookId <= 0 || bookId > 999999999) {
                response.sendRedirect(request.getContextPath() + "/books-list");
                return;
            }

            // Kiem tra sach ton tai truoc khi xoa
            Book book = bookDAO.getBookById(bookId);
            if (book != null) {
                bookDAO.deleteBook(bookId);
            }

            response.sendRedirect(request.getContextPath() + "/books-list");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/books-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}