/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.common;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebFilter;
import model.Reader;
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

        /* ===== PUBLIC ROUTES ===== */
        if (
            uri.equals(contextPath + "/login") ||
            uri.equals(contextPath + "/register") ||
            uri.equals(contextPath + "/LoginServlet") ||
            uri.equals(contextPath + "/RegisterServlet") ||
            uri.equals(contextPath + "/ResetPasswordServlet") ||
            uri.contains("/auth/") ||
            uri.contains("/assets/") ||
            uri.contains("/google-login")
        ) {
            chain.doFilter(req, res);
            return;
        }

        /* ===== NOT LOGIN ===== */
        if (user == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        /* ===== ROLE CHECK ===== */
        if (uri.contains("/admin") && !"ADMIN".equals(user.getRoleName())) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        if (uri.contains("/librarian") && !"LIBRARIAN".equals(user.getRoleName())) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        if (uri.contains("/seller") && !"SELLER".equals(user.getRoleName())) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        if (uri.contains("/user") && !"USER".equals(user.getRoleName())) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        chain.doFilter(req, res);
    }
}
