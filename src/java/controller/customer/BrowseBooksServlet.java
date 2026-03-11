package controller.customer;

import dao.BookDAO;
import dao.CategoryDAO;
import model.Book;
import model.Category;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet duyệt sách: tìm kiếm theo từ khóa, lọc theo category, phân trang.
 * Trả về danh sách sách (books), danh mục (categories), tham số phân trang (currentPage, totalPages, pageSize, totalBooks).
 */
public class BrowseBooksServlet extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 4;

    /**
     * Hiển thị trang duyệt sách có phân trang.
     * - keyword có giá trị → searchBooks(keyword); category có giá trị → getBooksByCategory(categoryId); không thì getAllBooks().
     * - pageSize lấy từ request (hỗ trợ 3 hoặc 5), mặc định 3; page từ request, giới hạn trong [1, totalPages].
     * - Cắt allBooks thành trang hiện tại (subList), set books, categories, keyword, selectedCategory, currentPage, totalPages, pageSize, totalBooks; forward browse-books.jsp.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookDAO bookDAO = new BookDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        String keyword = request.getParameter("keyword");
        String categoryIdStr = request.getParameter("category");

        List<Book> allBooks;

        if (keyword != null && !keyword.isBlank()) {
            allBooks = bookDAO.searchBooks(keyword);
        } else if (categoryIdStr != null && !categoryIdStr.isBlank()) {
            int categoryId = Integer.parseInt(categoryIdStr);
            allBooks = bookDAO.getBooksByCategory(categoryId);
        } else {
            allBooks = bookDAO.getAllBooks();
        }

        int pageSize = DEFAULT_PAGE_SIZE;
        try {
            String ps = request.getParameter("pageSize");
            if (ps != null) pageSize = Integer.parseInt(ps);
            if (pageSize != 4 && pageSize != 8) pageSize = DEFAULT_PAGE_SIZE;
        } catch (NumberFormatException ignored) {}

        int totalBooks = allBooks.size();
        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);
        if (totalPages == 0) totalPages = 1;

        int page = 1;
        try {
            String p = request.getParameter("page");
            if (p != null) page = Integer.parseInt(p);
        } catch (NumberFormatException ignored) {}
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalBooks);
        List<Book> books = allBooks.subList(fromIndex, toIndex);

        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategory", categoryIdStr);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalBooks", totalBooks);

        request.getRequestDispatcher("/customer/browse-books.jsp").forward(request, response);
    }
}
