/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.auth;

import dao.ReaderDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.GoogleUser;
import model.Reader;
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

        ReaderDAO userDAO = new ReaderDAO();
        Reader user = userDAO.loginByGoogle(googleUser);

        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        response.sendRedirect("home.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=google_login_failed");
    }
}

}
