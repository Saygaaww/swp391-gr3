package controller.seller;

import dao.AuthorDAO;
import dao.BookDAO;
import dao.CategoryDAO;
import model.Author;
import model.Book;
import model.Category;
import model.Employee;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class BookManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Employee employee = getSellerOrRedirect(request, response);
        if (employee == null) return;

        String action = request.getParameter("action");
        BookDAO bookDAO = new BookDAO();

        if ("edit".equals(action)) {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            Book book = bookDAO.getBookById(bookId);
            if (book == null) {
                response.sendRedirect(request.getContextPath() + "/seller/books");
                return;
            }
            request.setAttribute("editBook", book);
        }

        request.setAttribute("books", bookDAO.getAllBooksForManagement());
        request.setAttribute("authors", new AuthorDAO().getAllAuthors());
        request.setAttribute("categories", new CategoryDAO().getAllCategories());
        request.getRequestDispatcher("/seller/books.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Employee employee = getSellerOrRedirect(request, response);
        if (employee == null) return;

        String action = request.getParameter("action");
        BookDAO bookDAO = new BookDAO();
        HttpSession session = request.getSession();

        if ("add".equals(action)) {
            Book book = parseBookFromRequest(request);
            book.setCreatedByEmployeeId(employee.getEmployeeId());
            int id = bookDAO.createBook(book);
            session.setAttribute("successMessage", id > 0 ? "Book added successfully!" : "Failed to add book.");

        } else if ("update".equals(action)) {
            Book book = parseBookFromRequest(request);
            book.setBookId(Integer.parseInt(request.getParameter("bookId")));
            book.setUpdatedByEmployeeId(employee.getEmployeeId());
            boolean ok = bookDAO.updateBook(book);
            session.setAttribute("successMessage", ok ? "Book updated successfully!" : "Failed to update book.");

        } else if ("toggleStatus".equals(action)) {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            Book book = bookDAO.getBookById(bookId);
            if (book != null) {
                book.setStatus("active".equals(book.getStatus()) ? "inactive" : "active");
                book.setUpdatedByEmployeeId(employee.getEmployeeId());
                bookDAO.updateBook(book);
                session.setAttribute("successMessage", "Status updated to " + book.getStatus() + ".");
            }
        }

        response.sendRedirect(request.getContextPath() + "/seller/books");
    }

    private Book parseBookFromRequest(HttpServletRequest request) {
        Book book = new Book();
        book.setTitle(request.getParameter("title").trim());
        book.setSummary(request.getParameter("summary") != null ? request.getParameter("summary").trim() : null);
        book.setDescription(request.getParameter("description") != null ? request.getParameter("description").trim() : null);
        book.setCoverUrl(request.getParameter("coverUrl") != null ? request.getParameter("coverUrl").trim() : null);

        String priceStr = request.getParameter("price");
        book.setPrice(priceStr != null && !priceStr.isEmpty() ? new BigDecimal(priceStr) : BigDecimal.ZERO);
        book.setCurrency(request.getParameter("currency") != null ? request.getParameter("currency").trim() : "VND");

        String totalPages = request.getParameter("totalPages");
        book.setTotalPages(totalPages != null && !totalPages.isEmpty() ? Integer.parseInt(totalPages) : 0);
        String previewPages = request.getParameter("previewPages");
        book.setPreviewPages(previewPages != null && !previewPages.isEmpty() ? Integer.parseInt(previewPages) : 0);

        String stock = request.getParameter("stockQuantity");
        book.setStockQuantity(stock != null && !stock.isEmpty() ? Integer.parseInt(stock) : 0);

        book.setStatus(request.getParameter("status") != null ? request.getParameter("status") : "active");

        String authorId = request.getParameter("authorId");
        book.setAuthorId(authorId != null && !authorId.isEmpty() ? Integer.parseInt(authorId) : 0);
        String categoryId = request.getParameter("categoryId");
        book.setCategoryId(categoryId != null && !categoryId.isEmpty() ? Integer.parseInt(categoryId) : 0);

        return book;
    }

    private Employee getSellerOrRedirect(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Employee employee = (Employee) request.getSession().getAttribute("employee");
        if (employee == null || !"SELLER".equalsIgnoreCase(employee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }
        return employee;
    }
}
