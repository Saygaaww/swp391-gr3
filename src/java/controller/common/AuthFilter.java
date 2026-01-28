/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.common;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebFilter;
import model.User;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // PUBLIC
        if (uri.contains("/login") || uri.contains("/register") || uri.contains("/assets")
                || uri.contains("/google-login")) {
            chain.doFilter(req, res);
            return;
        }

        // ADMIN
        if (uri.contains("/admin")) {
            if (user == null || !"ADMIN".equals(user.getRoleName())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        }

        // LIBRARIAN
        if (uri.contains("/librarian")) {
            if (user == null || !"LIBRARIAN".equals(user.getRoleName())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        }

        //seller 
        if (uri.contains("/seller")) {
            if (user == null || !"SELLER".equals(user.getRoleName())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        }
        
        //customer
        if (uri.contains("/user")) {
            if (user == null || !"USER".equals(user.getRoleName())) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        }

        chain.doFilter(req, res);
    }
}
