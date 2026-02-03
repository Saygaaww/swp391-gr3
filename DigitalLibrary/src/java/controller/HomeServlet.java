package controller;

import dao.BookDAO;
import model.Book;
import utils.MockDataService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Reader;
import model.Employee;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Nếu đã đăng nhập (Reader hoặc Employee), redirect theo role
        if (session != null) {
            String userRole = (String) session.getAttribute("userRole");
            if (userRole != null) {
                String redirectPath = determineRedirectPath(userRole);
                response.sendRedirect(request.getContextPath() + redirectPath);
                return;
            }
        }
        
        // Nếu chưa đăng nhập, hiển thị trang home công khai với danh sách sách
        try {
            List<Book> featuredBooks = bookDAO.getFreeBooks(0, 6);
            request.setAttribute("featuredBooks", featuredBooks);
        } catch (SQLException e) {
            e.printStackTrace();
            // Fallback mock data khi DB lỗi để trang không bị trống
            request.setAttribute("featuredBooks", MockDataService.getFeaturedBooks());
        }
        
        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
    
    /**
     * Xác định đường dẫn redirect dựa trên role từ database
     */
    private String determineRedirectPath(String roleName) {
        if (roleName == null) {
            return "/user/dashboard";
        }
        
        switch (roleName.toUpperCase()) {
            case "ADMIN":
                return "/admin/dashboard";
            case "LIBRARIAN":
                return "/librarian/dashboard";
            case "SELLER":
                return "/seller/dashboard";
            case "USER":
            default:
                return "/user/dashboard";
        }
    }
}
