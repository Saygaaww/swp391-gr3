package util;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * EmailUtil - Gửi email thông báo
 * 
 * CẤU HÌNH: Điền thông tin SMTP của bạn vào các hằng số bên dưới.
 * Hiện tại đang ở chế độ LOG (in ra console thay vì gửi thật).
 * Để bật gửi email thật, cần thêm thư viện javax.mail vào project
 * và đổi SEND_REAL_EMAIL = true.
 */
public class EmailUtil {

    private static final Logger LOGGER = Logger.getLogger(EmailUtil.class.getName());

    // ===== CẤU HÌNH SMTP =====
    private static final boolean SEND_REAL_EMAIL = false; // Đổi thành true khi có SMTP
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;
    private static final String SMTP_USERNAME = "your-email@gmail.com"; // ← Thay thế
    private static final String SMTP_PASSWORD = "your-app-password"; // ← App Password Gmail
    private static final String FROM_NAME = "Digital Library";
    private static final String FROM_EMAIL = "noreply@digitallibrary.vn";
    // ==========================

    /**
     * Gửi email đặt lại mật khẩu
     * 
     * @param toEmail   địa chỉ email người nhận
     * @param toName    tên người nhận
     * @param resetLink link đặt lại mật khẩu (đã có token)
     */
    public static boolean sendPasswordResetEmail(String toEmail, String toName, String resetLink) {
        String subject = "[Digital Library] Đặt lại mật khẩu";
        String htmlBody = buildPasswordResetHTML(toName, resetLink);

        return sendEmail(toEmail, toName, subject, htmlBody);
    }

    /**
     * Gửi email chào mừng sau khi đăng ký
     */
    public static boolean sendWelcomeEmail(String toEmail, String toName) {
        String subject = "[Digital Library] Chào mừng bạn đến với chúng tôi!";
        String htmlBody = "<h2>Xin chào " + escapeHtml(toName) + "!</h2>"
                + "<p>Tài khoản của bạn đã được tạo thành công tại Digital Library.</p>"
                + "<p>Chúc bạn có trải nghiệm đọc sách tuyệt vời!</p>";
        return sendEmail(toEmail, toName, subject, htmlBody);
    }

    // ===================== Private Methods =====================

    private static boolean sendEmail(String toEmail, String toName, String subject, String htmlBody) {
        if (!SEND_REAL_EMAIL) {
            // Chế độ development: log ra console thay vì gửi thật
            LOGGER.info("========== [EMAIL LOG - Dev Mode] ==========");
            LOGGER.info("To: " + toName + " <" + toEmail + ">");
            LOGGER.info("Subject: " + subject);
            LOGGER.info("Body: " + htmlBody.replaceAll("<[^>]+>", ""));
            LOGGER.info("============================================");
            return true; // Giả lập gửi thành công
        }

        // TODO: Implement real SMTP sending khi SEND_REAL_EMAIL = true
        // Cần thêm javax.mail dependency vào project
        // Properties props = new Properties();
        // props.put("mail.smtp.auth", "true");
        // props.put("mail.smtp.starttls.enable", "true");
        // props.put("mail.smtp.host", SMTP_HOST);
        // props.put("mail.smtp.port", SMTP_PORT);
        // ...
        LOGGER.warning("Real email sending not configured yet.");
        return false;
    }

    private static String buildPasswordResetHTML(String toName, String resetLink) {
        return "<!DOCTYPE html><html><body style='font-family:Arial,sans-serif;'>"
                + "<div style='max-width:600px;margin:0 auto;padding:20px;'>"
                + "<h2 style='color:#6366f1;'>Digital Library</h2>"
                + "<p>Xin chào <strong>" + escapeHtml(toName) + "</strong>,</p>"
                + "<p>Chúng tôi nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>"
                + "<p>Nhấn vào nút bên dưới để đặt lại mật khẩu (link có hiệu lực trong <strong>1 giờ</strong>):</p>"
                + "<a href='" + resetLink + "' style='display:inline-block;padding:12px 24px;"
                + "background:#6366f1;color:#fff;text-decoration:none;border-radius:6px;margin:16px 0;'>"
                + "Đặt lại mật khẩu</a>"
                + "<p>Hoặc copy link sau vào trình duyệt:</p>"
                + "<p style='word-break:break-all;color:#6366f1;'>" + escapeHtml(resetLink) + "</p>"
                + "<hr><p style='color:#888;font-size:12px;'>Nếu bạn không yêu cầu đặt lại mật khẩu, "
                + "hãy bỏ qua email này. Link sẽ tự động hết hạn sau 1 giờ.</p>"
                + "</div></body></html>";
    }

    private static String escapeHtml(String text) {
        if (text == null)
            return "";
        return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;");
    }
}
