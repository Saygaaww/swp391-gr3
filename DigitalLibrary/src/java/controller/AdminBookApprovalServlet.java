package controller;

import dao.BookDAO;
import model.Employee;
import model.Book;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "AdminBookApprovalServlet", urlPatterns = {
    "/admin/books/pending",
    "/admin/books/approve",
    "/admin/books/reject"
})
public class AdminBookApprovalServlet extends HttpServlet {

    private BookDAO bookDAO;

    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Employee employee = (Employee) session.getAttribute("employee");
        String userRole = (String) session.getAttribute("userRole");
        if (employee == null || userRole == null || !"ADMIN".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        if (!"/admin/books/pending".equals(path)) {
            response.sendRedirect(request.getContextPath() + "/admin/books/pending");
            return;
        }

        String pageParam = request.getParameter("page");
        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = 20;
        int offset = (page - 1) * pageSize;

        try {
            List<Book> books = bookDAO.getBooksByApprovalStatus("pending_approval", offset, pageSize);
            int total = bookDAO.countBooksByApprovalStatus("pending_approval");
            int totalPages = (int) Math.ceil((double) total / pageSize);

            request.setAttribute("books", books);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalBooks", total);
            request.getRequestDispatcher("/admin/book-pending-list.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Employee employee = (Employee) session.getAttribute("employee");
        String userRole = (String) session.getAttribute("userRole");
        if (employee == null || userRole == null || !"ADMIN".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String path = request.getServletPath();
        String bookIdParam = request.getParameter("bookId");
        String notes = request.getParameter("notes");

        if (bookIdParam == null || bookIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/books/pending?error=missing_book_id");
            return;
        }

        int bookId = Integer.parseInt(bookIdParam);
        String newStatus;
        if ("/admin/books/approve".equals(path)) {
            newStatus = "approved";
        } else if ("/admin/books/reject".equals(path)) {
            newStatus = "rejected";
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/books/pending");
            return;
        }

        try {
            boolean ok = bookDAO.updateApprovalStatus(bookId, newStatus, employee.getEmployeeId(), notes);
            if (ok) {
                response.sendRedirect(request.getContextPath() + "/admin/books/pending?message=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/books/pending?error=update_failed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/books/pending?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}

