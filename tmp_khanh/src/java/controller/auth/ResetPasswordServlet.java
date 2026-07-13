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
        request.setAttribute("error", "Email không hợp lệ");
        request.getRequestDispatcher("/auth/forgot_password.jsp").forward(request, response);
        return;
    }

    /* ===== STEP 1: GỬI OTP ===== */
    if (otp == null || otp.isEmpty()) {

        if (!userDAO.isEmailExists(email)) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống");
            request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        String generatedOtp = resetDAO.generateOTP();
        resetDAO.saveOtpForEmail(email, generatedOtp);

        try {
            EmailUtil.sendOtpEmail(email, generatedOtp);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể gửi email OTP");
            request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
            return;
        }

        request.setAttribute("email", email);
        request.setAttribute("showOtpForm", true);
        request.setAttribute("message", "OTP đã được gửi về email");
        request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
        return;
    }

    /* ===== STEP 2: VERIFY OTP + RESET PASSWORD ===== */
    if (!resetDAO.verifyOtpForEmail(email, otp)) {
        request.setAttribute("error", "OTP không hợp lệ hoặc đã hết hạn");
        request.setAttribute("email", email);
        request.setAttribute("showOtpForm", true);
        request.getRequestDispatcher("/auth/forgot-password.jsp").forward(request, response);
        return;
    }

    if (newPassword == null || newPassword.isEmpty()) {
        request.setAttribute("error", "Vui lòng nhập mật khẩu mới");
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
