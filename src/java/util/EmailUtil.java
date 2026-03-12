package util;

import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 * EmailUtil - Gửi email thông báo via SMTP Gmail
 */
public class EmailUtil {

    private static final Logger LOGGER = Logger.getLogger(EmailUtil.class.getName());

    // ===== CẤU HÌNH SMTP =====
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final int SMTP_PORT = 587;
    private static final String SMTP_USERNAME = "tenmamarvall@gmail.com";
    private static final String SMTP_PASSWORD = "elrd qmsa ywxz oryt"; // App Password Gmail
    private static final String FROM_NAME = "Digital Library";
    // ==========================

    /**
     * Gửi OTP xác nhận đăng nhập Google
     */
    public static boolean sendGoogleLoginOtp(String toEmail, String toName, String otp) {
        String subject = "[Digital Library] Mã xác nhận đăng nhập";
        String html = buildOtpHTML(toName, otp);
        return sendEmail(toEmail, toName, subject, html);
    }

    /**
     * Gửi email đặt lại mật khẩu
     */
    public static boolean sendPasswordResetEmail(String toEmail, String toName, String resetLink) {
        String subject = "[Digital Library] Đặt lại mật khẩu";
        String html = buildPasswordResetHTML(toName, resetLink);
        return sendEmail(toEmail, toName, subject, html);
    }

    /**
     * Gửi email chào mừng sau đăng ký
     */
    public static boolean sendWelcomeEmail(String toEmail, String toName) {
        String subject = "[Digital Library] Chào mừng bạn!";
        String html = "<h2>Xin chào " + escapeHtml(toName) + "!</h2>"
                + "<p>Tài khoản của bạn đã được tạo thành công tại Digital Library.</p>"
                + "<p>Chúc bạn có trải nghiệm đọc sách tuyệt vời!</p>";
        return sendEmail(toEmail, toName, subject, html);
    }

    // ===================== Private Methods =====================

    private static boolean sendEmail(String toEmail, String toName, String subject, String htmlBody) {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", String.valueOf(SMTP_PORT));
        props.put("mail.smtp.ssl.trust", SMTP_HOST);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USERNAME, SMTP_PASSWORD);
            }
        });

        try {
            MimeMessage msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(SMTP_USERNAME, FROM_NAME, "UTF-8"));
            msg.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail, toName, "UTF-8"));
            msg.setSubject(subject, "UTF-8");
            msg.setContent(htmlBody, "text/html; charset=UTF-8");
            Transport.send(msg);
            LOGGER.info("Email sent to: " + toEmail + " | Subject: " + subject);
            return true;
        } catch (MessagingException | java.io.UnsupportedEncodingException e) {
            LOGGER.log(Level.SEVERE, "Failed to send email to " + toEmail, e);
            return false;
        }
    }

    private static String buildOtpHTML(String toName, String otp) {
        return "<!DOCTYPE html><html><body style='font-family:Arial,sans-serif;background:#f0f2f5;margin:0;padding:20px;'>"
                + "<div style='max-width:520px;margin:0 auto;background:#fff;border-radius:16px;"
                + "box-shadow:0 4px 20px rgba(0,0,0,0.08);overflow:hidden;'>"
                + "<div style='background:linear-gradient(135deg,#6366f1,#8b5cf6);padding:32px;text-align:center;'>"
                + "<h1 style='color:#fff;margin:0;font-size:24px;'>&#128274; Xác nhận đăng nhập</h1>"
                + "<p style='color:rgba(255,255,255,0.85);margin:8px 0 0;font-size:14px;'>Digital Library</p>"
                + "</div>"
                + "<div style='padding:32px;text-align:center;'>"
                + "<p style='color:#374151;font-size:15px;'>Xin chào <strong>" + escapeHtml(toName) + "</strong>,</p>"
                + "<p style='color:#374151;font-size:14px;'>Mã OTP xác nhận đăng nhập bằng Google của bạn là:</p>"
                + "<div style='display:inline-block;background:#f3f4f6;border:2px dashed #6366f1;"
                + "border-radius:12px;padding:18px 40px;margin:16px 0;'>"
                + "<span style='font-size:36px;font-weight:700;letter-spacing:12px;color:#6366f1;'>" + otp + "</span>"
                + "</div>"
                + "<p style='color:#6b7280;font-size:13px;'>Mã có hiệu lực trong <strong>5 phút</strong>. "
                + "Không chia sẻ mã này với bất kỳ ai.</p>"
                + "<hr style='border:none;border-top:1px solid #e5e7eb;margin:20px 0;'>"
                + "<p style='color:#9ca3af;font-size:12px;'>Nếu bạn không thực hiện đăng nhập, hãy bỏ qua email này.</p>"
                + "</div></div></body></html>";
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
