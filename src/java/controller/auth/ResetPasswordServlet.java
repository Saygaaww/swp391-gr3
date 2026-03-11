package controller.auth;

import dao.PasswordResetDAO;
import dao.ReaderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.EmailUtil;
import util.PasswordUtil;

import java.io.IOException;

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
        request.setAttribute("error", "Invalid email");
        request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
        return;
    }

    /* ===== STEP 1: GỬI OTP ===== */
    if (otp == null || otp.isEmpty()) {

        if (!userDAO.isEmailExists(email)) {
            request.setAttribute("error", "Email not found in system");
            request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        String generatedOtp = resetDAO.generateOTP();
        resetDAO.saveOtpForEmail(email, generatedOtp);

        try {
            EmailUtil.sendOtpEmail(email, generatedOtp);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Could not send OTP email");
            request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        request.setAttribute("email", email);
        request.setAttribute("showOtpForm", true);
        request.setAttribute("message", "OTP has been sent to your email");
        request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
        return;
    }

    /* ===== STEP 2: VERIFY OTP + RESET PASSWORD ===== */
    if (!resetDAO.verifyOtpForEmail(email, otp)) {
        request.setAttribute("error", "Invalid or expired OTP");
        request.setAttribute("email", email);
        request.setAttribute("showOtpForm", true);
        request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
        return;
    }

    if (newPassword == null || newPassword.isEmpty()) {
        request.setAttribute("error", "Please enter a new password");
        request.setAttribute("email", email);
        request.setAttribute("showOtpForm", true);
        request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
        return;
    }

    String hashedPassword = PasswordUtil.hash(newPassword);
    boolean updated = userDAO.updatePasswordByEmail(email, hashedPassword);
    System.out.println("RESET HASH = " + hashedPassword);


    response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
}

}
