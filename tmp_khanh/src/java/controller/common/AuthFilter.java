/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.common;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebFilter;
import model.Reader;
import model.Employee;
import java.io.IOException;


public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();

        HttpSession session = request.getSession(false);
        Reader user = (session != null) ? (Reader) session.getAttribute("user") : null;
        Employee employee = (session != null) ? (Employee) session.getAttribute("employee") : null;

        /* ===== PUBLIC ROUTES ===== */
        if (
            uri.equals(contextPath + "/") ||
            uri.equals(contextPath + "/login") ||
            uri.equals(contextPath + "/register") ||
            uri.equals(contextPath + "/LoginServlet") ||
            uri.equals(contextPath + "/RegisterServlet") ||
            uri.equals(contextPath + "/reset-password") ||
            uri.equals(contextPath + "/ResetPasswordServlet") ||
            uri.equals(contextPath + "/ForgotPasswordServlet") ||
            uri.contains("/auth/") ||
            uri.contains("/assets/") ||
            uri.contains("/css/") ||
            uri.contains("/js/") ||
            uri.contains("/images/") ||
            uri.contains("/google-login") ||
            uri.contains("/employee/login") ||
            uri.contains("/vnpay-return") ||
            uri.contains("/vnpay-result") ||
            uri.endsWith(".css") ||
            uri.endsWith(".js") ||
            uri.endsWith(".png") ||
            uri.endsWith(".jpg") ||
            uri.endsWith(".jpeg") ||
            uri.endsWith(".gif")
        ) {
            chain.doFilter(req, res);
            return;
        }

        /* ===== EMPLOYEE ROUTES ===== */
        if (uri.contains("/admin") || uri.contains("/librarian") || uri.contains("/seller")) {
            if (employee == null) {
                response.sendRedirect(contextPath + "/auth/login");
                return;
            }

            // ✅ ADMIN role check (riêng /admin/books cho phép cả SELLER, LIBRARIAN xem catalog)
            String empRole = employee.getRoleName() != null ? employee.getRoleName().toUpperCase() : "";
            if (uri.contains("/admin")) {
                if (uri.contains("/admin/books")) {
                    if (!"ADMIN".equals(empRole) && !"LIBRARIAN".equals(empRole) && !"SELLER".equals(empRole)) {
                        response.sendRedirect(contextPath + "/auth/login");
                        return;
                    }
                } else {
                    if (!"ADMIN".equals(empRole)) {
                        response.sendRedirect(contextPath + "/auth/login");
                        return;
                    }
                }
            }

            // ✅ LIBRARIAN role check
            if (uri.contains("/librarian") && !"LIBRARIAN".equals(empRole)) {
                response.sendRedirect(contextPath + "/auth/login");
                return;
            }

            // ✅ SELLER role check
            if (uri.contains("/seller") && !"SELLER".equals(empRole)) {
                response.sendRedirect(contextPath + "/auth/login");
                return;
            }

            setNoCacheHeaders(response);
            chain.doFilter(req, res);
            return;
        }

        /* ===== READER/USER ROUTES ===== */
        if (uri.contains("/customer") || uri.contains("/user")) {
            if (user == null) {
                response.sendRedirect(contextPath + "/auth/login");
                return;
            }

            // ✅ USER role check (không phân biệt hoa thường)
            String userRole = user.getRoleName() != null ? user.getRoleName().toUpperCase() : "";
            if (!"USER".equals(userRole)) {
                response.sendRedirect(contextPath + "/auth/login");
                return;
            }

            setNoCacheHeaders(response);
            chain.doFilter(req, res);
            return;
        }

        /* ===== DEFAULT: NOT LOGIN ===== */
        if (user == null && employee == null) {
            response.sendRedirect(contextPath + "/auth/login");
            return;
        }

        setNoCacheHeaders(response);
        chain.doFilter(req, res);
    }

    /** Không cho browser cache trang đã login → bấm Back sau logout sẽ gửi lại request và bị redirect về login */
    private void setNoCacheHeaders(HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }
}
