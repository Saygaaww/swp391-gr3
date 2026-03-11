package controller.admin;

import dao.BookDAO;
import dao.AuthorDAO;
import dao.CategoryDAO;
import model.Book;
import model.Author;
import model.Category;
import model.Employee;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

public class BookManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");

        // Browse catalog: cho phép ADMIN, LIBRARIAN, SELLER
        String role = employee != null ? employee.getRoleName() : null;
        boolean canView = "ADMIN".equals(role) || "LIBRARIAN".equals(role) || "SELLER".equals(role);
        if (employee == null || !canView) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        BookDAO bookDAO = new BookDAO();
        AuthorDAO authorDAO = new AuthorDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        List<Book> books = bookDAO.getAllBooks();
        List<Author> authors = authorDAO.getAllAuthors();
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("books", books);
        request.setAttribute("authors", authors);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/admin/books.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");

        // Thêm/sửa/xóa sách: chỉ ADMIN
        if (employee == null || !"ADMIN".equals(employee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        BookDAO bookDAO = new BookDAO();

        if ("add".equals(action)) {
            Book book = new Book();
            book.setTitle(request.getParameter("title"));
            book.setSummary(request.getParameter("summary"));
            book.setDescription(request.getParameter("description"));
            book.setCoverUrl(request.getParameter("coverUrl"));
            book.setPrice(new BigDecimal(request.getParameter("price")));
            book.setCurrency("VND");
            book.setTotalPages(Integer.parseInt(request.getParameter("totalPages")));
            book.setPreviewPages(Integer.parseInt(request.getParameter("previewPages")));
            book.setStatus("active");
            book.setAuthorId(Integer.parseInt(request.getParameter("authorId")));
            book.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            book.setCreatedByEmployeeId(employee.getEmployeeId());

            int bookId = bookDAO.createBook(book);
            
            if (bookId > 0) {
                session.setAttribute("successMessage", "Book created successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to create book");
            }
        } else if ("update".equals(action)) {
            Book book = new Book();
            book.setBookId(Integer.parseInt(request.getParameter("bookId")));
            book.setTitle(request.getParameter("title"));
            book.setSummary(request.getParameter("summary"));
            book.setDescription(request.getParameter("description"));
            book.setCoverUrl(request.getParameter("coverUrl"));
            book.setPrice(new BigDecimal(request.getParameter("price")));
            book.setCurrency("VND");
            book.setTotalPages(Integer.parseInt(request.getParameter("totalPages")));
            book.setPreviewPages(Integer.parseInt(request.getParameter("previewPages")));
            book.setStatus(request.getParameter("status"));
            book.setAuthorId(Integer.parseInt(request.getParameter("authorId")));
            book.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
            book.setUpdatedByEmployeeId(employee.getEmployeeId());

            boolean success = bookDAO.updateBook(book);
            
            if (success) {
                session.setAttribute("successMessage", "Book updated successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to update book");
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }
}
