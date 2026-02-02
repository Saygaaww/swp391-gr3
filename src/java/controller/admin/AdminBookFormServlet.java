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
 * Servlet DÙNG CHUNG cho Thêm và Sửa sách
 * 1. doGet(): Hiển thị form
 *    - Nếu có ?id=X → Chế độ SỬA (load data từ DB)
 *    - Nếu không có id → Chế độ THÊM (form trống)
 * 
 * 2. doPost(): Xử lý submit form
 *    - Nếu có bookId (hidden field) → UPDATE database
 *    - Nếu không có bookId → INSERT database
 */
@WebServlet("/admin/book-form")
public class AdminBookFormServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    private AuthorDAO authorDAO;
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        authorDAO = new AuthorDAO();
        categoryDAO = new CategoryDAO();
        System.out.println("✅ AdminBookFormServlet initialized");
    }
    
    /**
     * GET - Hiển thị form thêm hoặc sửa sách
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // BƯỚC 1: Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }
        
        try {
            // BƯỚC 2: Kiểm tra có ID không để xác định chế độ
            String idStr = request.getParameter("id");
            Book book = null;
            String mode = "add";
            
            if (idStr != null && !idStr.trim().isEmpty()) {
                // CHẾ ĐỘ SỬA
                int bookId = Integer.parseInt(idStr);
                book = bookDAO.getBookById(bookId);
                
                if (book == null) {
                    response.sendRedirect(request.getContextPath() + "/books-list");
                    return;
                }
                mode = "edit";
                System.out.println("📝 CHẾ ĐỘ SỬA - Book ID: " + bookId);
            } else {
                // CHẾ ĐỘ THÊM
                book = new Book();
                System.out.println("➕ CHẾ ĐỘ THÊM MỚI");
            }
            
            // BƯỚC 3: Lấy danh sách tác giả và danh mục
            List<Author> authors = authorDAO.getAllAuthors();
            List<Category> categories = categoryDAO.getAllCategories();
            
            // BƯỚC 4: Đẩy dữ liệu sang JSP
            request.setAttribute("book", book);
            request.setAttribute("mode", mode);
            request.setAttribute("authors", authors);
            request.setAttribute("categories", categories);
            request.setAttribute("currentEmployee", session.getAttribute("employee"));
            
            request.getRequestDispatcher("/admin/book-form.jsp").forward(request, response);
                   
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/books-list");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/books-list");
        }
    }
    
    /**
     * POST - Xử lý submit form (Thêm hoặc Cập nhật)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        
        try {
            Employee employee = (Employee) session.getAttribute("employee");
            
            // Kiểm tra THÊM hay SỬA
            String bookIdStr = request.getParameter("bookId");
            boolean isEdit = (bookIdStr != null && !bookIdStr.trim().isEmpty());
            
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
            
            // Validate
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("error", "Tên sách không được để trống!");
                reloadFormWithError(request, response, isEdit, bookIdStr);
                return;
            }
            
            // Tạo object Book
            Book book = new Book();
            book.setTitle(title.trim());
            book.setSummary(summary);
            book.setDescription(description);
            book.setCoverUrl(coverUrl);
            book.setContentPath(contentPath);
            
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
            
            // Gọi DAO
            boolean success;
            
            if (isEdit) {
                book.setBookId(Integer.parseInt(bookIdStr));
                book.setUpdatedByEmployeeId(employee.getEmployeeId());
                success = bookDAO.updateBook(book);
                System.out.println(success ? "✅ UPDATE thành công" : "❌ UPDATE thất bại");
            } else {
                book.setCreatedByEmployeeId(employee.getEmployeeId());
                success = bookDAO.addBook(book);
                System.out.println(success ? "✅ INSERT thành công" : "❌ INSERT thất bại");
            }
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/books-list");
            } else {
                request.setAttribute("error", "Không thể lưu sách. Vui lòng thử lại!");
                reloadFormWithError(request, response, isEdit, bookIdStr);
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Dữ liệu số không hợp lệ!");
            reloadFormWithError(request, response, false, null);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            reloadFormWithError(request, response, false, null);
        }
    }
    
    /**
     * Helper: Load lại form khi có lỗi
     */
    private void reloadFormWithError(HttpServletRequest request, HttpServletResponse response,
                                     boolean isEdit, String bookIdStr) 
            throws ServletException, IOException {
        
        if (isEdit && bookIdStr != null) {
            request.setAttribute("mode", "edit");
            Book existingBook = bookDAO.getBookById(Integer.parseInt(bookIdStr));
            request.setAttribute("book", existingBook);
        } else {
            request.setAttribute("mode", "add");
            request.setAttribute("book", new Book());
        }
        
        request.setAttribute("authors", authorDAO.getAllAuthors());
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/admin/book-form.jsp").forward(request, response);
    }
}