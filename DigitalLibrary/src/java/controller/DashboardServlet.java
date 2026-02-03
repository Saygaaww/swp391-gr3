package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Reader;
import model.Employee;

import java.io.IOException;

@WebServlet(name = "DashboardServlet", urlPatterns = {
    "/admin/dashboard",
    "/librarian/dashboard", 
    "/seller/dashboard",
    "/user/dashboard"
})
public class DashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra đăng nhập (Reader hoặc Employee)
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
        
        String requestPath = request.getServletPath();
        
        // Kiểm tra quyền truy cập dựa trên role từ database
        if (!hasAccess(userRole, requestPath)) {
            // Redirect về dashboard phù hợp với role
            String redirectPath = determineRedirectPath(userRole);
            response.sendRedirect(request.getContextPath() + redirectPath);
            return;
        }
        
        // Set attributes cho JSP
        if (reader != null) {
            request.setAttribute("reader", reader);
            request.setAttribute("user", reader);
            request.setAttribute("userName", reader.getFullName() != null ? reader.getFullName() : reader.getEmail());
        }
        if (employee != null) {
            request.setAttribute("employee", employee);
            request.setAttribute("user", employee);
            request.setAttribute("userName", employee.getFullName() != null ? employee.getFullName() : employee.getEmail());
        }
        request.setAttribute("role", userRole != null ? userRole : "USER");
        request.setAttribute("userType", session.getAttribute("userType"));
        
        // Forward đến trang dashboard tương ứng
        // requestPath is like "/user/dashboard", we need "user/dashboard.jsp"
        String jspPath = requestPath.substring(1) + ".jsp";
        request.getRequestDispatcher("/" + jspPath).forward(request, response);
    }
    
    /**
     * Kiểm tra quyền truy cập dựa trên role từ database
     * Logic phân quyền:
     * - ADMIN: chỉ truy cập /admin/dashboard
     * - LIBRARIAN: chỉ truy cập /librarian/dashboard
     * - SELLER: chỉ truy cập /seller/dashboard
     * - USER: truy cập /user/dashboard
     */
    private boolean hasAccess(String roleName, String path) {
        if (roleName == null) {
            return "/user/dashboard".equals(path);
        }
        
        String role = roleName.toUpperCase();
        
        switch (path) {
            case "/admin/dashboard":
                return "ADMIN".equals(role);
            case "/librarian/dashboard":
                return "LIBRARIAN".equals(role);
            case "/seller/dashboard":
                return "SELLER".equals(role);
            case "/user/dashboard":
                // USER role có thể truy cập user dashboard
                // Các role khác cũng có thể truy cập user dashboard (nếu cần)
                return "USER".equals(role) || 
                       "ADMIN".equals(role) || 
                       "LIBRARIAN".equals(role) || 
                       "SELLER".equals(role);
            default:
                return false;
        }
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
