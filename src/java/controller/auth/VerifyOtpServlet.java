/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.auth;

import dao.OtpDAO;
import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String phone = request.getParameter("phone");
        String otp = request.getParameter("otp");

        OtpDAO otpDAO = new OtpDAO();
        boolean valid = otpDAO.verifyOtp(phone, otp);

        if (!valid) {
            request.setAttribute("error", "OTP không hợp lệ hoặc đã hết hạn");
            request.getRequestDispatcher("/auth/verify-otp.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        userDAO.createUserByPhone(phone);

        response.sendRedirect("login");
    }
}
