package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.GoogleOAuthUtil;

import java.io.IOException;

@WebServlet(name = "GoogleAuthServlet", urlPatterns = {"/auth/google"})
public class GoogleAuthServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String authUrl = GoogleOAuthUtil.getAuthorizationUrl(request);
        response.sendRedirect(authUrl);
    }
}
