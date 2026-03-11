package controller.auth;

import dao.OtpDAO;
import dao.ReaderDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import util.OtpUtil;
import util.SmsService;
import util.PasswordUtil;

import java.io.IOException;

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

        // ==== EMAIL REGISTER ====
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");

        if (email != null && password != null && !email.isEmpty()
                && !password.isEmpty() && fullName != null && !fullName.isEmpty()) {

            if (userDAO.isEmailExists(email)) {
                request.setAttribute("error", "Email already exists");
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }

            boolean success = userDAO.registerByEmail(fullName, email, util.PasswordUtil.hash(password));
            if (!success) {
                request.setAttribute("error", "Registration failed. Please try again.");
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ==== PHONE REGISTER (OTP) ====
        String phone = request.getParameter("phone");

        if (phone != null && !phone.isEmpty()) {

            String otp = OtpUtil.generateOtp();
            OtpDAO otpDAO = new OtpDAO();
            otpDAO.saveOtpForPhone(phone, otp);

            // ⚠ tạm thời chưa có SMS API thật
            // SmsService.sendOtp(phone, otp);
            System.out.println("OTP (debug): " + otp);

            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/auth/verify-otp.jsp").forward(request, response);
            return;
        }

        // ==== INVALID ====
        response.sendRedirect("register");
    }
}
