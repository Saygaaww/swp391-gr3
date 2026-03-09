package controller.auth;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import util.GoogleOAuthUtil;

@WebServlet("/google-login")
public class GoogleLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String googleAuthUrl = GoogleOAuthUtil.getGoogleLoginUrl();
        response.sendRedirect(googleAuthUrl);
    }
}