package controller.auth;

import dal.OtpDAO;
import dal.ReaderDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import util.OtpUtil;
import util.PasswordUtil;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ReaderDAO userDAO = new ReaderDAO();

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");

        if (email != null && password != null && !email.isEmpty()
                && !password.isEmpty() && fullName != null && !fullName.isEmpty()) {

            if (userDAO.isEmailExists(email)) {
                request.setAttribute("error", "Email da ton tai");
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }

            boolean success = userDAO.registerByEmail(fullName, email, PasswordUtil.hash(password));
            if (!success) {
                request.setAttribute("error", "Dang ky that bai, vui long thu lai");
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String phone = request.getParameter("phone");
        if (phone != null && !phone.isEmpty()) {
            String otp = OtpUtil.generateOtp();
            OtpDAO otpDAO = new OtpDAO();
            otpDAO.saveOtpForPhone(phone, otp);
            System.out.println("OTP (debug): " + otp);

            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/auth/verify-otp.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/register");
    }
}