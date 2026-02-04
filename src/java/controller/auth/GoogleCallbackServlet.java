/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dao.UserDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.GoogleUser;
import model.User;
import util.GoogleOAuthUtil;

@WebServlet("/google-callback")
public class GoogleCallbackServlet extends HttpServlet {

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException {

    try {
        String code = request.getParameter("code");

        String accessToken = GoogleOAuthUtil.getAccessToken(code);
        GoogleUser googleUser = GoogleOAuthUtil.getUserInfo(accessToken);

        UserDAO userDAO = new UserDAO();
        User user = userDAO.loginByGoogle(googleUser);

        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        response.sendRedirect("home.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=google_login_failed");
    }
}

}
