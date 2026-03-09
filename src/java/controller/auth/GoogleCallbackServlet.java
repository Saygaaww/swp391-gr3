package controller.auth;

import dal.ReaderDAO;
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
            response.sendRedirect(request.getContextPath() + "/home");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login?error=google_login_failed");
        }
    }
}