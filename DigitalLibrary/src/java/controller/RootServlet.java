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

@WebServlet(name = "RootServlet", urlPatterns = {"/"})
public class RootServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String requestPath = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = requestPath.substring(contextPath.length());
        
        // Chỉ xử lý root path "/" - bỏ qua tất cả static resources và paths khác
        // Kiểm tra nếu là static resource (CSS, JS, images) thì forward đến default servlet
        if (!path.equals("/") && !path.isEmpty()) {
            // Nếu là static resource, forward đến default servlet để serve file
            if (path.startsWith("/css/") || path.startsWith("/js/") || 
                path.startsWith("/images/") || path.startsWith("/img/") ||
                path.endsWith(".css") || path.endsWith(".js") || 
                path.endsWith(".png") || path.endsWith(".jpg") || 
                path.endsWith(".jpeg") || path.endsWith(".gif") || 
                path.endsWith(".svg") || path.endsWith(".ico") ||
                path.endsWith(".woff") || path.endsWith(".woff2") || 
                path.endsWith(".ttf") || path.endsWith(".eot")) {
                // Forward đến default servlet để serve static files
                try {
                    jakarta.servlet.RequestDispatcher rd = 
                        request.getServletContext().getNamedDispatcher("default");
                    if (rd != null) {
                        rd.forward(request, response);
                    }
                } catch (Exception e) {
                    // Nếu forward thất bại, không làm gì - để default servlet tự xử lý
                }
                return;
            }
            // Các paths khác không xử lý
            return;
        }
        
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
        
        // Nếu chưa đăng nhập, hiển thị trang home công khai
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
