/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dao.ReaderDAO;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.GoogleUser;
import model.Reader;
import util.GoogleOAuthUtil;

/**
 * Xử lý callback sau khi user đăng nhập Google: đổi code lấy accessToken, lấy thông tin user (GoogleOAuthUtil.getUserInfo), đăng nhập hoặc tạo Reader (ReaderDAO.loginByGoogle), lưu user vào session và redirect về customer home.
 */
public class GoogleCallbackServlet extends HttpServlet {

    /**
     * Nhận code từ Google; getAccessToken(code) → getUserInfo(accessToken); loginByGoogle(googleUser) trả về Reader (hoặc tạo mới); kiểm tra status ACTIVE; set session user, redirect /customer/home_1.jsp. Lỗi → redirect /login?error=...
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            String code = request.getParameter("code");

            String accessToken = GoogleOAuthUtil.getAccessToken(code);
            GoogleUser googleUser = GoogleOAuthUtil.getUserInfo(accessToken);

            ReaderDAO userDAO = new ReaderDAO();
            Reader user = userDAO.loginByGoogle(googleUser);

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=google_login_failed");
                return;
            }

            if (!"ACTIVE".equalsIgnoreCase(user.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/login?error=account_locked");
                return;
            }

            HttpSession session = request.getSession(true);
            session.setMaxInactiveInterval(60 * 30);
            session.setAttribute("user", user);

            response.sendRedirect(request.getContextPath() + "/customer/home_1.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login?error=google_login_failed");
        }
    }

}
