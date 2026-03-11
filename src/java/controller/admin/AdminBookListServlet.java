package controller.admin;

import dal.BookDAO;
import dal.AuthorDAO;
import dal.CategoryDAO;
import model.Book;
import model.Author;
import model.Category;
import model.Employee;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({ "/admin/book-list", "/books-list", "/books-ist" })
public class AdminBookListServlet extends HttpServlet {

    private BookDAO bookDAO;
    private AuthorDAO authorDAO;
    private CategoryDAO categoryDAO;
    private static final int DEFAULT_PAGE_SIZE = 5;

    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        authorDAO = new AuthorDAO();
        categoryDAO = new CategoryDAO();
        System.out.println("AdminBookListServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Employee employee = (Employee) session.getAttribute("user");
        request.setCharacterEncoding("UTF-8");

        try {
            int pageSize = DEFAULT_PAGE_SIZE;
            boolean showAll = false;
            String pageSizeStr = request.getParameter("pageSize");
            if (pageSizeStr != null && !pageSizeStr.trim().isEmpty()) {
                if (pageSizeStr.equals("all")) {
                    showAll = true;
                    pageSize = Integer.MAX_VALUE;
                } else {
                    try {
                        pageSize = Integer.parseInt(pageSizeStr);
                        if (pageSize != 5 && pageSize != 10 && pageSize != 20) {
                            pageSize = DEFAULT_PAGE_SIZE;
                        }
                    } catch (NumberFormatException e) {
                        pageSize = DEFAULT_PAGE_SIZE;
                    }
                }
            }

            int currentPage = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1)
                        currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            String keyword = request.getParameter("keyword");
            if (keyword != null) {
                keyword = keyword.trim().replaceAll("\\s+", " ");
                if (keyword.isEmpty())
                    keyword = null;
            }

            String categoryFilter = request.getParameter("categoryId");
            String authorFilter = request.getParameter("authorId");
            String statusFilter = request.getParameter("status");

            int filterCategoryId = 0;
            int filterAuthorId = 0;

            if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                try {
                    filterCategoryId = Integer.parseInt(categoryFilter);
                } catch (NumberFormatException e) {
                    filterCategoryId = 0;
                }
            }

            if (authorFilter != null && !authorFilter.trim().isEmpty()) {
                try {
                    filterAuthorId = Integer.parseInt(authorFilter);
                } catch (NumberFormatException e) {
                    filterAuthorId = 0;
                }
            }

            if (statusFilter != null && statusFilter.trim().isEmpty()) {
                statusFilter = null;
            }

            List<Book> bookList;
            int totalBooks;
            int totalPages;

            totalBooks = bookDAO.countBooksFiltered(keyword, filterCategoryId, filterAuthorId, statusFilter);

            if (showAll) {
                totalPages = 1;
                currentPage = 1;
                bookList = bookDAO.getBooksFiltered(keyword, filterCategoryId, filterAuthorId, statusFilter, 1,
                        totalBooks > 0 ? totalBooks : 1);
            } else {
                totalPages = (int) Math.ceil((double) totalBooks / pageSize);
                if (totalPages < 1)
                    totalPages = 1;
                if (currentPage > totalPages)
                    currentPage = totalPages;

                bookList = bookDAO.getBooksFiltered(keyword, filterCategoryId, filterAuthorId, statusFilter,
                        currentPage, pageSize);
            }

            List<Author> authors = authorDAO.getAllAuthors();
            List<Category> categories = categoryDAO.getAllCategories();

            request.setAttribute("bookList", bookList);
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", showAll ? "all" : String.valueOf(pageSize));
            request.setAttribute("showAll", showAll);
            request.setAttribute("currentEmployee", employee);

            request.setAttribute("authors", authors);
            request.setAttribute("categories", categories);
            request.setAttribute("keyword", keyword);
            request.setAttribute("filterCategoryId", filterCategoryId);
            request.setAttribute("filterAuthorId", filterAuthorId);
            request.setAttribute("filterStatus", statusFilter);

            request.getRequestDispatcher("/WEB-INF/jsp/admin/book-list.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("AdminBookListServlet Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Loi he thong: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/admin/book-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
