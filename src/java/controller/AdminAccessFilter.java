package controller;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import util.AuthUtil;

@WebFilter(urlPatterns = { "/admin", "/admin/*", "/books-list", "/books-list/*" })
public class AdminAccessFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // No initialization required.
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        if (session == null || session.getAttribute(AuthUtil.SESSION_USER) == null) {
            String target = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
            String query = httpRequest.getQueryString();
            if (query != null && !query.isEmpty()) {
                target += "?" + query;
            }
            String redirect = URLEncoder.encode(target, StandardCharsets.UTF_8);
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth/login?redirect=" + redirect);
            return;
        }

        // Sidebar on librarian dashboard links to several /admin/* management pages.
        // Allow both Admin and Librarian to pass this filter.
        if (!AuthUtil.hasAnyRole(httpRequest, AuthUtil.ROLE_ADMIN, AuthUtil.ROLE_LIBRARIAN)) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth/login?error=unauthorized");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No resources to release.
    }
}

