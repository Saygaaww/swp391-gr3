package controller.admin;

import dal.BookDAO;
import dal.AuthorDAO;
import dal.CategoryDAO;
import dal.BorrowDAO;
import model.Book;
import model.Author;
import model.Category;
import model.Employee;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet hien thi chi tiet sach
 * @author Member E - Dung
 */
@WebServlet("/admin/book-detail")
public class AdminBookDetailServlet extends HttpServlet {

    private BookDAO bookDAO;
    private AuthorDAO authorDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        authorDAO = new AuthorDAO();
        categoryDAO = new CategoryDAO();
        System.out.println("AdminBookDetailServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Employee currentEmployee = (Employee) session.getAttribute("user");

        String idStr = request.getParameter("id");

        // Validate ID
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/book-list");
            return;
        }

        try {
            int bookId = Integer.parseInt(idStr.trim());

            if (bookId <= 0 || bookId > 999999999) {
                response.sendRedirect(request.getContextPath() + "/admin/book-list");
                return;
            }

            Book book = bookDAO.getBookById(bookId);

            if (book == null) {
                request.setAttribute("errorMessage", "Khong tim thay sach ID: " + bookId);
                request.setAttribute("currentEmployee", currentEmployee);
                request.getRequestDispatcher("/WEB-INF/jsp/admin/book-detail.jsp").forward(request, response);
                return;
            }

            // Lay thong tin tac gia
            Author author = null;
            if (book.getAuthorId() > 0) {
                author = authorDAO.getAuthorById(book.getAuthorId());
            }

            // Lay thong tin danh muc
            Category category = null;
            if (book.getCategoryId() > 0) {
                category = categoryDAO.getCategoryById(book.getCategoryId());
            }

            // Tinh trang thai hien thi
            String statusLabel = "Khong xac dinh";
            String statusColor = "#6c757d";
            if ("active".equals(book.getStatus())) {
                statusLabel = "Dang hoat dong";
                statusColor = "#28a745";
            } else if ("inactive".equals(book.getStatus())) {
                statusLabel = "Ngung hoat dong";
                statusColor = "#dc3545";
            } else if ("draft".equals(book.getStatus())) {
                statusLabel = "Ban nhap";
                statusColor = "#ffc107";
            }

            request.setAttribute("book", book);
            request.setAttribute("author", author);
            request.setAttribute("category", category);
            request.setAttribute("statusLabel", statusLabel);
            request.setAttribute("statusColor", statusColor);
            request.setAttribute("currentEmployee", currentEmployee);

            request.getRequestDispatcher("/WEB-INF/jsp/admin/book-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("Invalid book ID format: " + idStr);
            response.sendRedirect(request.getContextPath() + "/admin/book-list");
        } catch (Exception e) {
            System.err.println("AdminBookDetailServlet Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/book-list");
        }
    }
}
