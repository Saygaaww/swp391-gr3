package controller.admin;

import dal.BookDAO;
import model.Book;
import model.Employee;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet hiển thị danh sách sách cho Admin
 * @author Member E - Dũng
 */
@WebServlet("/books-list")
public class AdminBookListServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            // ✅ FIX: Redirect đến mock-login SERVLET
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }
        
        Employee employee = (Employee) session.getAttribute("employee");
        System.out.println("✅ Employee đã login: " + employee.getFullName());
        
        try {
            // Lấy danh sách sách
            List<Book> bookList = bookDAO.getAllBooks();
            
            System.out.println("📚 Tìm thấy " + bookList.size() + " sách trong DB");
            
            // Gửi dữ liệu sang JSP
            request.setAttribute("bookList", bookList);
            request.setAttribute("totalBooks", bookList.size());
            request.setAttribute("currentEmployee", employee);
            
            // ✅ FIX: Forward đến JSP (ĐÚNG RỒI)
            request.getRequestDispatcher("/book-list.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            System.err.println("❌ LỖI: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách sách: " + e.getMessage());
            request.getRequestDispatcher("/book-list.jsp")
                   .forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        String keyword = request.getParameter("keyword");
        
        try {
            List<Book> bookList;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                bookList = bookDAO.searchBooks(keyword);
                request.setAttribute("keyword", keyword);
                System.out.println("🔍 Tìm kiếm '" + keyword + "': " + bookList.size() + " kết quả");
            } else {
                bookList = bookDAO.getAllBooks();
            }
            
            request.setAttribute("bookList", bookList);
            request.setAttribute("totalBooks", bookList.size());
            request.setAttribute("currentEmployee", session.getAttribute("employee"));
            
            request.getRequestDispatcher("/book-list.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tìm kiếm: " + e.getMessage());
            request.getRequestDispatcher("/book-list.jsp")
                   .forward(request, response);
        }
    }
}