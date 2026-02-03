package controller;

import dao.BookDAO;
import dao.AuthorDAO;
import dao.CategoryDAO;
import model.Book;
import model.Author;
import model.Category;
import model.Reader;
import model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BookServlet", urlPatterns = {
    "/books",
    "/books/list",
    "/books/view",
    "/books/add",
    "/books/edit",
    "/books/delete",
    "/books/search"
})
public class BookServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    private AuthorDAO authorDAO;
    private CategoryDAO categoryDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        authorDAO = new AuthorDAO();
        categoryDAO = new CategoryDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Bỏ qua các request đến file JSP để tránh vòng lặp forward
        String pathInfo = request.getPathInfo();
        String requestURI = request.getRequestURI();
        if ((pathInfo != null && pathInfo.endsWith(".jsp")) || 
            (requestURI != null && requestURI.endsWith(".jsp"))) {
            // Cho phép container xử lý JSP file trực tiếp
            return;
        }
        
        HttpSession session = request.getSession(false);

        Reader reader = null;
        Employee employee = null;
        String userRole = null;
        boolean isGuest = false;

        // Kiểm tra đăng nhập
        if (session != null) {
            reader = (Reader) session.getAttribute("reader");
            employee = (Employee) session.getAttribute("employee");
            userRole = (String) session.getAttribute("userRole");
        }

        // Nếu không có session hoặc không có user, coi như guest
        if (session == null || (reader == null && employee == null)) {
            isGuest = true;
        }
        
        String action = request.getParameter("action");
        String path = request.getServletPath();

        try {
            // Xử lý các action khác nhau
            if (path.equals("/books/view") || (action != null && action.equals("view"))) {
                // Guest được phép xem sách miễn phí
                handleView(request, response, userRole, isGuest);
            } else if (path.equals("/books/add") || (action != null && action.equals("add"))) {
                if (isGuest) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                handleAddForm(request, response, userRole);
            } else if (path.equals("/books/edit") || (action != null && action.equals("edit"))) {
                if (isGuest) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                handleEditForm(request, response, userRole);
            } else if (path.equals("/books/delete") || (action != null && action.equals("delete"))) {
                if (isGuest) {
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
                }
                handleDelete(request, response, userRole);
            } else if (path.equals("/books/search") || (action != null && action.equals("search"))) {
                // Guest được phép tìm kiếm sách miễn phí
                handleSearch(request, response, isGuest);
            } else {
                // Mặc định: hiển thị danh sách
                handleList(request, response, isGuest);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi truy vấn database: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Guest không được phép thực hiện các thao tác POST
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Reader reader = (Reader) session.getAttribute("reader");
        Employee employee = (Employee) session.getAttribute("employee");
        String userRole = (String) session.getAttribute("userRole");

        if (reader == null && employee == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                handleCreate(request, response, userRole, employee);
            } else if ("update".equals(action)) {
                handleUpdate(request, response, userRole, employee);
            } else {
                response.sendRedirect(request.getContextPath() + "/books");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị danh sách sách
     */
    private void handleList(HttpServletRequest request, HttpServletResponse response, boolean isGuest)
            throws ServletException, IOException, SQLException {
        String pageParam = request.getParameter("page");
        int page = (pageParam != null && !pageParam.isEmpty()) ? Integer.parseInt(pageParam) : 1;
        int pageSize = 12; // Số sách mỗi trang
        int offset = (page - 1) * pageSize;

        List<Book> books;
        int totalBooks;

        if (isGuest) {
            // Guest chỉ xem được sách miễn phí
            books = bookDAO.getFreeBooks(offset, pageSize);
            totalBooks = bookDAO.countFreeBooks();
        } else {
            // User đã đăng nhập xem tất cả sách
            books = bookDAO.getAllBooks(offset, pageSize);
            totalBooks = bookDAO.countBooks();
        }

        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);
        
        request.setAttribute("books", books);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBooks", totalBooks);
        
        // Lấy danh sách authors và categories cho filter (có thể null nếu bảng chưa tồn tại)
        List<Author> authors = new ArrayList<>();
        List<Category> categories = new ArrayList<>();
        try {
            authors = authorDAO.getAllAuthors();
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách authors: " + e.getMessage());
            // Tiếp tục với danh sách rỗng
        }
        try {
            categories = categoryDAO.getAllCategories();
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách categories: " + e.getMessage());
            // Tiếp tục với danh sách rỗng
        }
        request.setAttribute("authors", authors);
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/books/book-list.jsp").forward(request, response);
    }
    
    /**
     * Xem chi tiết sách
     */
    private void handleView(HttpServletRequest request, HttpServletResponse response, String userRole, boolean isGuest)
            throws ServletException, IOException, SQLException {
        String bookIdParam = request.getParameter("id");
        if (bookIdParam == null || bookIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        int bookId = Integer.parseInt(bookIdParam);
        Book book = bookDAO.getBookById(bookId);

        if (book == null) {
            request.setAttribute("error", "Không tìm thấy sách với ID: " + bookId);
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        // Guest chỉ được xem sách miễn phí
        if (isGuest && !isFreeBook(book)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("book", book);
        request.getRequestDispatcher("/books/book-detail.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị form thêm sách (chỉ ADMIN và LIBRARIAN)
     */
    private void handleAddForm(HttpServletRequest request, HttpServletResponse response, String userRole)
            throws ServletException, IOException, SQLException {
        if (!hasManagePermission(userRole)) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }
        
        List<Author> authors = authorDAO.getAllAuthors();
        List<Category> categories = categoryDAO.getAllCategories();
        
        request.setAttribute("authors", authors);
        request.setAttribute("categories", categories);
        request.setAttribute("action", "create");
        
        request.getRequestDispatcher("/books/book-form.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị form sửa sách (chỉ ADMIN và LIBRARIAN)
     */
    private void handleEditForm(HttpServletRequest request, HttpServletResponse response, String userRole)
            throws ServletException, IOException, SQLException {
        if (!hasManagePermission(userRole)) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }
        
        String bookIdParam = request.getParameter("id");
        if (bookIdParam == null || bookIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }
        
        int bookId = Integer.parseInt(bookIdParam);
        Book book = bookDAO.getBookById(bookId);
        
        if (book == null) {
            request.setAttribute("error", "Không tìm thấy sách với ID: " + bookId);
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        List<Author> authors = authorDAO.getAllAuthors();
        List<Category> categories = categoryDAO.getAllCategories();
        
        request.setAttribute("book", book);
        request.setAttribute("authors", authors);
        request.setAttribute("categories", categories);
        request.setAttribute("action", "update");
        
        request.getRequestDispatcher("/books/book-form.jsp").forward(request, response);
    }
    
    /**
     * Xử lý tạo sách mới
     */
    private void handleCreate(HttpServletRequest request, HttpServletResponse response, String userRole, Employee employee)
            throws ServletException, IOException, SQLException {
        if (!hasManagePermission(userRole)) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }
        
        Book book = extractBookFromRequest(request);
        if (employee != null) {
            book.setCreatedByEmployeeId(employee.getEmployeeId());
        }

        // TẠM THỜI BỎ: Workflow duyệt sách (DB chưa có approval_status column)
        // TODO: Khi nào chạy migration script thì uncomment lại
        // Workflow duyệt sách:
        // - SELLER tạo sách: pending_approval (chưa được bán)
        // - ADMIN/LIBRARIAN tạo sách: approved (được bán ngay)
        // if ("SELLER".equalsIgnoreCase(userRole)) {
        //     book.setApprovalStatus("pending_approval");
        // } else {
        //     book.setApprovalStatus("approved");
        // }
        
        Book createdBook = bookDAO.createBook(book);
        
        if (createdBook != null) {
            response.sendRedirect(request.getContextPath() + "/books/view?id=" + createdBook.getBookId());
        } else {
            request.setAttribute("error", "Không thể tạo sách mới. Vui lòng thử lại.");
            handleAddForm(request, response, userRole);
        }
    }
    
    /**
     * Xử lý cập nhật sách
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, String userRole, Employee employee)
            throws ServletException, IOException, SQLException {
        if (!hasManagePermission(userRole)) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }
        
        String bookIdParam = request.getParameter("bookId");
        if (bookIdParam == null || bookIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }
        
        int bookId = Integer.parseInt(bookIdParam);
        Book book = extractBookFromRequest(request);
        book.setBookId(bookId);
        
        if (employee != null) {
            book.setUpdatedByEmployeeId(employee.getEmployeeId());
        }
        
        boolean success = bookDAO.updateBook(book);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/books/view?id=" + bookId);
        } else {
            request.setAttribute("error", "Không thể cập nhật sách. Vui lòng thử lại.");
            handleEditForm(request, response, userRole);
        }
    }
    
    /**
     * Xử lý xóa sách (chỉ ADMIN và LIBRARIAN)
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response, String userRole)
            throws ServletException, IOException, SQLException {
        if (!hasManagePermission(userRole)) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }
        
        String bookIdParam = request.getParameter("id");
        if (bookIdParam == null || bookIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }
        
        int bookId = Integer.parseInt(bookIdParam);
        boolean success = bookDAO.deleteBook(bookId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/books?message=delete_success");
        } else {
            response.sendRedirect(request.getContextPath() + "/books?error=delete_failed");
        }
    }
    
    /**
     * Xử lý tìm kiếm sách
     */
    private void handleSearch(HttpServletRequest request, HttpServletResponse response, boolean isGuest)
            throws ServletException, IOException, SQLException {
        String keyword = request.getParameter("keyword");
        String authorIdParam = request.getParameter("authorId");
        String categoryIdParam = request.getParameter("categoryId");

        Integer authorId = (authorIdParam != null && !authorIdParam.isEmpty())
            ? Integer.parseInt(authorIdParam) : null;
        Integer categoryId = (categoryIdParam != null && !categoryIdParam.isEmpty())
            ? Integer.parseInt(categoryIdParam) : null;

        List<Book> books;
        if (isGuest) {
            // Guest chỉ tìm kiếm sách miễn phí
            books = bookDAO.searchFreeBooks(keyword, authorId, categoryId);
        } else {
            // User đã đăng nhập tìm tất cả sách
            books = bookDAO.searchBooks(keyword, authorId, categoryId);
        }
        
        request.setAttribute("books", books);
        request.setAttribute("keyword", keyword);
        request.setAttribute("authorId", authorId);
        request.setAttribute("categoryId", categoryId);
        
        // Lấy danh sách authors và categories cho filter
        List<Author> authors = authorDAO.getAllAuthors();
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("authors", authors);
        request.setAttribute("categories", categories);
        
        request.getRequestDispatcher("/books/book-list.jsp").forward(request, response);
    }
    
    /**
     * Extract Book object từ request parameters
     */
    private Book extractBookFromRequest(HttpServletRequest request) {
        Book book = new Book();
        
        book.setTitle(request.getParameter("title"));
        book.setSummary(request.getParameter("summary"));
        book.setDescription(request.getParameter("description"));
        book.setCoverUrl(request.getParameter("coverUrl"));
        book.setContentPath(request.getParameter("contentPath"));
        
        String priceParam = request.getParameter("price");
        if (priceParam != null && !priceParam.isEmpty()) {
            try {
                book.setPrice(new BigDecimal(priceParam));
            } catch (NumberFormatException e) {
                // Giữ giá trị null nếu không parse được
            }
        }
        
        book.setCurrency(request.getParameter("currency"));
        
        String totalPagesParam = request.getParameter("totalPages");
        if (totalPagesParam != null && !totalPagesParam.isEmpty()) {
            try {
                book.setTotalPages(Integer.parseInt(totalPagesParam));
            } catch (NumberFormatException e) {
                // Giữ giá trị null nếu không parse được
            }
        }
        
        String previewPagesParam = request.getParameter("previewPages");
        if (previewPagesParam != null && !previewPagesParam.isEmpty()) {
            try {
                book.setPreviewPages(Integer.parseInt(previewPagesParam));
            } catch (NumberFormatException e) {
                // Giữ giá trị null nếu không parse được
            }
        }
        
        book.setStatus(request.getParameter("status") != null ? request.getParameter("status") : "active");
        
        String authorIdParam = request.getParameter("authorId");
        if (authorIdParam != null && !authorIdParam.isEmpty()) {
            try {
                book.setAuthorId(Integer.parseInt(authorIdParam));
            } catch (NumberFormatException e) {
                // Giữ giá trị null nếu không parse được
            }
        }
        
        String categoryIdParam = request.getParameter("categoryId");
        if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
            try {
                book.setCategoryId(Integer.parseInt(categoryIdParam));
            } catch (NumberFormatException e) {
                // Giữ giá trị null nếu không parse được
            }
        }
        
        return book;
    }
    
    /**
     * Kiểm tra quyền quản lý sách (chỉ ADMIN và LIBRARIAN)
     */
    private boolean hasManagePermission(String userRole) {
        if (userRole == null) {
            return false;
        }
        String role = userRole.toUpperCase();
        return "ADMIN".equals(role) || "LIBRARIAN".equals(role) || "SELLER".equals(role);
    }

    /**
     * Kiểm tra sách có miễn phí không
     */
    private boolean isFreeBook(Book book) {
        return book.getPrice() == null || book.getPrice().compareTo(BigDecimal.ZERO) <= 0;
    }
}
