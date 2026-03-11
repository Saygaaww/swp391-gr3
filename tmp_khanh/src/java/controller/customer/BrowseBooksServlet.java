package controller.customer;

import dao.BookDAO;
import dao.CategoryDAO;
import model.Book;
import model.Category;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class BrowseBooksServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookDAO bookDAO = new BookDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        String keyword = request.getParameter("keyword");
        String categoryIdStr = request.getParameter("category");

        List<Book> books;

        if (keyword != null && !keyword.isBlank()) {
            books = bookDAO.searchBooks(keyword);
        } else if (categoryIdStr != null && !categoryIdStr.isBlank()) {
            int categoryId = Integer.parseInt(categoryIdStr);
            books = bookDAO.getBooksByCategory(categoryId);
        } else {
            books = bookDAO.getAllBooks();
        }

        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategory", categoryIdStr);

        request.getRequestDispatcher("/customer/browse-books.jsp").forward(request, response);
    }
}
