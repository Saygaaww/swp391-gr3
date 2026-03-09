package controller.auth;

import dal.PasswordResetDAO;
import dal.ReaderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.EmailUtil;
import util.PasswordUtil;
import java.io.IOException;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private final ReaderDAO userDAO = new ReaderDAO();
    private final PasswordResetDAO resetDAO = new PasswordResetDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");

        if (email == null || email.isEmpty()) {
            request.setAttribute("error", "Email khong hop le");
            request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        // Buoc 1: Gui OTP
        if (otp == null || otp.isEmpty()) {
            if (!userDAO.isEmailExists(email)) {
                request.setAttribute("error", "Email khong ton tai trong he thong");
                request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            String generatedOtp = resetDAO.generateOTP();
            resetDAO.saveOtpForEmail(email, generatedOtp);

            try {
                EmailUtil.sendOtpEmail(email, generatedOtp);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Khong the gui email OTP");
                request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
                return;
            }

            request.setAttribute("email", email);
            request.setAttribute("showOtpForm", true);
            request.setAttribute("message", "OTP da duoc gui ve email");
            request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        // Buoc 2: Verify OTP + Reset password
        if (!resetDAO.verifyOtpForEmail(email, otp)) {
            request.setAttribute("error", "OTP khong hop le hoac da het han");
            request.setAttribute("email", email);
            request.setAttribute("showOtpForm", true);
            request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || newPassword.isEmpty()) {
            request.setAttribute("error", "Vui long nhap mat khau moi");
            request.setAttribute("email", email);
            request.setAttribute("showOtpForm", true);
            request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        String hashedPassword = PasswordUtil.hash(newPassword);
        userDAO.updatePasswordByEmail(email, hashedPassword);
        response.sendRedirect(request.getContextPath() + "/login");
    }
}