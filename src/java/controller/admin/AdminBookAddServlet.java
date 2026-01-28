package controller.admin;

import dal.BookDAO;
import dal.AuthorDAO;
import dal.CategoryDAO;
import model.Book;
import model.Author;
import model.Category;
import model.Employee;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet thêm sách mới
 * @author Member E - Dũng
 */
@WebServlet("/admin/book-add")
public class AdminBookAddServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    private AuthorDAO authorDAO;
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        authorDAO = new AuthorDAO();
        categoryDAO = new CategoryDAO();
    }
    
    /**
     * GET - Hiển thị form thêm sách
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }
        
        try {
            // Lấy danh sách tác giả và danh mục để hiển thị trong dropdown
            List<Author> authors = authorDAO.getAllAuthors();
            List<Category> categories = categoryDAO.getAllCategories();
            
            request.setAttribute("authors", authors);
            request.setAttribute("categories", categories);
            request.setAttribute("currentEmployee", session.getAttribute("employee"));
            
            request.getRequestDispatcher("/admin/book-add.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/books-list");
        }
    }
    
    /**
     * POST - Xử lý thêm sách
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        
        try {
            // Lấy thông tin employee
            Employee employee = (Employee) session.getAttribute("employee");
            
            // Lấy dữ liệu từ form
            String title = request.getParameter("title");
            String summary = request.getParameter("summary");
            String description = request.getParameter("description");
            String coverUrl = request.getParameter("coverUrl");
            String contentPath = request.getParameter("contentPath");
            String priceStr = request.getParameter("price");
            String currency = request.getParameter("currency");
            String totalPagesStr = request.getParameter("totalPages");
            String previewPagesStr = request.getParameter("previewPages");
            String status = request.getParameter("status");
            String authorIdStr = request.getParameter("authorId");
            String categoryIdStr = request.getParameter("categoryId");
            
            // Validate dữ liệu
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("error", "Tên sách không được để trống!");
                doGet(request, response);
                return;
            }
            
            // Tạo object Book
            Book book = new Book();
            book.setTitle(title.trim());
            book.setSummary(summary);
            book.setDescription(description);
            book.setCoverUrl(coverUrl);
            book.setContentPath(contentPath);
            
            // Parse số
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                book.setPrice(new BigDecimal(priceStr));
            }
            
            book.setCurrency(currency != null && !currency.isEmpty() ? currency : "VND");
            
            if (totalPagesStr != null && !totalPagesStr.trim().isEmpty()) {
                book.setTotalPages(Integer.parseInt(totalPagesStr));
            }
            
            if (previewPagesStr != null && !previewPagesStr.trim().isEmpty()) {
                book.setPreviewPages(Integer.parseInt(previewPagesStr));
            }
            
            book.setStatus(status != null && !status.isEmpty() ? status : "active");
            
            if (authorIdStr != null && !authorIdStr.trim().isEmpty()) {
                book.setAuthorId(Integer.parseInt(authorIdStr));
            }
            
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                book.setCategoryId(Integer.parseInt(categoryIdStr));
            }
            
            // Set employee đã tạo
            book.setCreatedByEmployeeId(employee.getEmployeeId());
            
            // Thêm vào database
            boolean success = bookDAO.addBook(book);
            
            if (success) {
                System.out.println("✅ Thêm sách thành công: " + title);
                // Redirect về danh sách sách
                response.sendRedirect(request.getContextPath() + "/books-list");
            } else {
                request.setAttribute("error", "Không thể thêm sách. Vui lòng thử lại!");
                doGet(request, response);
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Dữ liệu số không hợp lệ!");
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            doGet(request, response);
        }
    }
}