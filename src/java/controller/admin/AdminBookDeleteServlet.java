package controller.admin;

import dao.BookDAO;
import model.Book;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.AuthUtil;

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

        if (!AuthUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login?error=unauthorized");
            return;
        }

        try {
            String idStr = request.getParameter("id");
            String mode = request.getParameter("mode");
            if (mode == null || mode.trim().isEmpty()) {
                mode = "soft";
            }
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/book-list");
                return;
            }

            int bookId = Integer.parseInt(idStr.trim());
            if (bookId <= 0 || bookId > 999999999) {
                response.sendRedirect(request.getContextPath() + "/admin/book-list");
                return;
            }

            Book book = bookDAO.getBookByIdForAdmin(bookId);
            if (book != null) {
                boolean success;
                if ("hard".equalsIgnoreCase(mode)) {
                    success = bookDAO.hardDeleteBook(bookId);
                    if (success) {
                        session.setAttribute("successMessage", "Da xoa vinh vien sach: " + book.getTitle());
                    } else {
                        session.setAttribute("errorMessage", "Khong the xoa vinh vien sach nay (co du lieu lien quan).");
                    }
                } else {
                    success = bookDAO.softDeleteBook(bookId);
                    if (success) {
                        session.setAttribute("successMessage", "Da vo hieu hoa sach: " + book.getTitle());
                    } else {
                        session.setAttribute("errorMessage", "Khong the vo hieu hoa sach.");
                    }
                }
            } else {
                session.setAttribute("errorMessage", "Khong tim thay sach de xu ly.");
            }

            response.sendRedirect(request.getContextPath() + "/admin/book-list");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/book-list");
        }
    }
}
