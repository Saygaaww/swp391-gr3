package controller.common;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Đặt UTF-8 cho request và response để nhập/hiển thị tiếng Việt đúng.
 */
public class EncodingFilter implements Filter {

    private static final String ENCODING = "UTF-8";

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        req.setCharacterEncoding(ENCODING);
        res.setCharacterEncoding(ENCODING);
        chain.doFilter(request, response);
    }
}
