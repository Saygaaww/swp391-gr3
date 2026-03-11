package controller.auth;

import dao.ReaderDAO;
import model.Reader;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import util.PasswordUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        String hashedPassword = PasswordUtil.hash(password);
        System.out.println("LOGIN HASH = " + hashedPassword);


        if (email == null || password == null
                || email.isBlank() || password.isBlank()) {
            request.setAttribute("error", "Please enter email and password");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }

        ReaderDAO userDAO = new ReaderDAO();
        Reader user = userDAO.loginByEmailPassword(email, hashedPassword);

        if (user == null) {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }

        if (!"ACTIVE".equalsIgnoreCase(user.getStatus())) {
            request.setAttribute("error", "Account is locked");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }

        // ✅ Lưu session
        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);

        // ✅ Điều hướng theo role
        String role = user.getRoleName();

        switch (role) {
            case "ADMIN":
                response.sendRedirect(request.getContextPath() + "/home.jsp");
                break;

            case "LIBRARIAN":
                response.sendRedirect(request.getContextPath() + "/librarian/home.jsp");
                break;

            case "SELLER":
                response.sendRedirect(request.getContextPath() + "/seller/home");
                break;

            case "USER":
            default:
                response.sendRedirect(request.getContextPath() + "/customer/home_1.jsp");
                break;
        }
    }
}
