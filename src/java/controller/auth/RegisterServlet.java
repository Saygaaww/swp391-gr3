package controller.auth;

import dao.OtpDAO;
import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import util.OtpUtil;
import util.SmsService;

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

        UserDAO userDAO = new UserDAO();

        // ==== EMAIL REGISTER ====
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");

        if (email != null && password != null) {

            if (userDAO.isEmailExists(email)) {
                request.setAttribute("error", "Email đã tồn tại");
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }

            userDAO.registerByEmail(fullName, email, password);

            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ==== PHONE REGISTER (OTP) ====
        String phone = request.getParameter("phone");

        if (phone != null && !phone.isEmpty()) {

            String otp = OtpUtil.generateOtp();
            OtpDAO otpDAO = new OtpDAO();
            otpDAO.saveOtp(phone, otp);

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
