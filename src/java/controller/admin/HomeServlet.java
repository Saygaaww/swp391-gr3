package controller.admin;

import dal.BookDAO;
import dal.CategoryDAO;
import dal.AuthorDAO;
import model.Book;
import model.Category;
import model.Employee;
import model.Reader;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Home Servlet - Trang chủ thư viện số (public, không cần đăng nhập)
 * @author Member E - Dũng
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    private CategoryDAO categoryDAO;
    private AuthorDAO authorDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        categoryDAO = new CategoryDAO();
        authorDAO = new AuthorDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Tìm kiếm
            String search = request.getParameter("search");
            if (search != null) {
                search = search.trim();
                if (search.isEmpty()) search = null;
            }

            List<Book> latestBooks = bookDAO.getBooksFiltered(search, 0, 0, "active", 1, 8);
            int totalBooks = bookDAO.getTotalBooks();
            int totalCategories = categoryDAO.getAllCategories().size();
            int totalAuthors = authorDAO.getTotalAuthors();
            
            request.setAttribute("latestBooks", latestBooks);
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("totalCategories", totalCategories);
            request.setAttribute("totalAuthors", totalAuthors);
            
            // Kiểm tra đăng nhập — Employee hoặc Reader
            HttpSession session = request.getSession(false);
            if (session != null) {
                Employee emp = (Employee) session.getAttribute("user");
                if (emp != null) {
                    request.setAttribute("currentEmployee", emp);
                } else {
                    Reader reader = (Reader) session.getAttribute("user");
                    if (reader != null) {
                        request.setAttribute("currentReader", reader);
                    }
                }
            }
            
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            
        } catch (Exception e) {
            System.err.println("HomeServlet error: " + e.getMessage());
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}
