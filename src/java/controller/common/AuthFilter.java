package controller.common;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebFilter;
import model.Employee;
import model.Reader;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();
        String ctx = request.getContextPath();

        // Cho phep truy cap tu do (khong can dang nhap)
        if (uri.equals(ctx + "/") ||
            uri.equals(ctx + "/login") ||
            uri.equals(ctx + "/logout") ||
            uri.equals(ctx + "/register") ||
            uri.equals(ctx + "/reset-password") ||
            uri.equals(ctx + "/home") ||
            uri.equals(ctx + "/google-login") ||
            uri.equals(ctx + "/google-callback") ||
            uri.contains("/auth/") ||
            uri.contains("/includes/") ||
            uri.contains("/assets/") ||
            uri.contains("/uploads/") ||
            uri.endsWith(".css") ||
            uri.endsWith(".js") ||
            uri.endsWith(".jpg") ||
            uri.endsWith(".png") ||
            uri.endsWith(".gif") ||
            uri.endsWith(".ico") ||
            uri.equals(ctx + "/index.html")) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession session = request.getSession(false);

        // Trang /admin/* — chi Employee (ADMIN, LIBRARIAN, SELLER) moi vao duoc
        if (uri.contains("/admin") || uri.contains("/books-list") || uri.contains("/book-detail")) {
            Employee emp = (session != null) ? (Employee) session.getAttribute("employee") : null;
            if (emp == null) {
                response.sendRedirect(ctx + "/login");
                return;
            }
            chain.doFilter(req, res);
            return;
        }

        // Trang /librarian/* — ADMIN hoac LIBRARIAN
        if (uri.contains("/librarian")) {
            Employee emp = (session != null) ? (Employee) session.getAttribute("employee") : null;
            if (emp == null) {
                response.sendRedirect(ctx + "/login");
                return;
            }
            String role = emp.getRoleName();
            if (!"ADMIN".equalsIgnoreCase(role) && !"LIBRARIAN".equalsIgnoreCase(role)) {
                response.sendRedirect(ctx + "/login");
                return;
            }
            chain.doFilter(req, res);
            return;
        }

        // Trang /seller/* — ADMIN hoac SELLER
        if (uri.contains("/seller")) {
            Employee emp = (session != null) ? (Employee) session.getAttribute("employee") : null;
            if (emp == null) {
                response.sendRedirect(ctx + "/login");
                return;
            }
            String role = emp.getRoleName();
            if (!"ADMIN".equalsIgnoreCase(role) && !"SELLER".equalsIgnoreCase(role)) {
                response.sendRedirect(ctx + "/login");
                return;
            }
            chain.doFilter(req, res);
            return;
        }

        // Trang /customer/* — chi Reader (USER)
        if (uri.contains("/customer")) {
            Reader reader = (session != null) ? (Reader) session.getAttribute("user") : null;
            if (reader == null) {
                response.sendRedirect(ctx + "/login");
                return;
            }
            chain.doFilter(req, res);
            return;
        }

        // Mac dinh cho qua
        chain.doFilter(req, res);
    }
}