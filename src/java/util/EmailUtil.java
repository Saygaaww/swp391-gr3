package util;

import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

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
        String subject = "[Digital Library] Mã xác nhận liên kết Google";
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
     * Gửi email thông báo yêu cầu mượn sách được duyệt
     */
    public static boolean sendBorrowApprovedEmail(String toEmail, String toName, int requestId, String dueDate, String note) {
        String subject = "[Digital Library] Yêu cầu mượn sách #" + requestId + " đã được duyệt";
        String html = "<!DOCTYPE html><html><body style='font-family:Arial,sans-serif;background:#f0f2f5;margin:0;padding:20px;'>"
                + "<div style='max-width:560px;margin:0 auto;background:#fff;border-radius:16px;"
                + "box-shadow:0 4px 20px rgba(0,0,0,0.08);overflow:hidden;'>"
                + "<div style='background:linear-gradient(135deg,#22c55e,#16a34a);padding:32px;text-align:center;'>"
                + "<h1 style='color:#fff;margin:0;font-size:22px;'>&#9989; Yêu cầu mượn sách được duyệt!</h1>"
                + "<p style='color:rgba(255,255,255,0.85);margin:8px 0 0;font-size:14px;'>Digital Library</p>"
                + "</div>"
                + "<div style='padding:32px;'>"
                + "<p style='color:#374151;font-size:15px;'>Xin chào <strong>" + escapeHtml(toName) + "</strong>,</p>"
                + "<p style='color:#374151;font-size:14px;'>Yêu cầu mượn sách <strong>#" + requestId + "</strong> của bạn đã được <span style='color:#16a34a;font-weight:700;'>chấp thuận</span>.</p>"
                + "<div style='background:#f0fdf4;border-left:4px solid #22c55e;border-radius:8px;padding:16px;margin:16px 0;'>"
                + "<p style='margin:0;color:#15803d;font-size:14px;'>&#128197; <strong>Hạn trả sách:</strong> " + escapeHtml(dueDate) + "</p>"
                + (note != null && !note.isBlank() ? "<p style='margin:8px 0 0;color:#15803d;font-size:14px;'>&#128221; <strong>Ghi chú:</strong> " + escapeHtml(note) + "</p>" : "")
                + "</div>"
                + "<p style='color:#6b7280;font-size:13px;'>Vui lòng đến thư viện để nhận sách. Nhớ trả đúng hạn để tránh bị phạt!</p>"
                + "<hr style='border:none;border-top:1px solid #e5e7eb;margin:20px 0;'>"
                + "<p style='color:#9ca3af;font-size:12px;'>Nếu bạn có thắc mắc, vui lòng liên hệ thư viện.</p>"
                + "</div></div></body></html>";
        return sendEmail(toEmail, toName, subject, html);
    }

    /**
     * Gửi email thông báo yêu cầu mượn sách bị từ chối
     */
    public static boolean sendBorrowRejectedEmail(String toEmail, String toName, int requestId, String note) {
        String subject = "[Digital Library] Yêu cầu mượn sách #" + requestId + " không được duyệt";
        String html = "<!DOCTYPE html><html><body style='font-family:Arial,sans-serif;background:#f0f2f5;margin:0;padding:20px;'>"
                + "<div style='max-width:560px;margin:0 auto;background:#fff;border-radius:16px;"
                + "box-shadow:0 4px 20px rgba(0,0,0,0.08);overflow:hidden;'>"
                + "<div style='background:linear-gradient(135deg,#ef4444,#dc2626);padding:32px;text-align:center;'>"
                + "<h1 style='color:#fff;margin:0;font-size:22px;'>&#10060; Yêu cầu mượn sách không được duyệt</h1>"
                + "<p style='color:rgba(255,255,255,0.85);margin:8px 0 0;font-size:14px;'>Digital Library</p>"
                + "</div>"
                + "<div style='padding:32px;'>"
                + "<p style='color:#374151;font-size:15px;'>Xin chào <strong>" + escapeHtml(toName) + "</strong>,</p>"
                + "<p style='color:#374151;font-size:14px;'>Rất tiếc, yêu cầu mượn sách <strong>#" + requestId + "</strong> của bạn đã bị <span style='color:#dc2626;font-weight:700;'>từ chối</span>.</p>"
                + (note != null && !note.isBlank()
                    ? "<div style='background:#fef2f2;border-left:4px solid #ef4444;border-radius:8px;padding:16px;margin:16px 0;'>"
                    + "<p style='margin:0;color:#b91c1c;font-size:14px;'>&#128221; <strong>Lý do:</strong> " + escapeHtml(note) + "</p>"
                    + "</div>" : "")
                + "<p style='color:#6b7280;font-size:13px;'>Bạn có thể liên hệ thư viện để biết thêm chi tiết hoặc gửi lại yêu cầu mới.</p>"
                + "<hr style='border:none;border-top:1px solid #e5e7eb;margin:20px 0;'>"
                + "<p style='color:#9ca3af;font-size:12px;'>Cảm ơn bạn đã sử dụng dịch vụ của Digital Library.</p>"
                + "</div></div></body></html>";
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

    /**
     * Gửi email thông báo mua sách thành công
     */
    public static boolean sendPurchaseSuccessEmail(String toEmail, String toName, int orderId, java.math.BigDecimal totalAmount) {
        String subject = "[Digital Library] Đặt hàng thành công #" + orderId;
        String html = "<!DOCTYPE html><html><body style='font-family:Arial,sans-serif;background:#f0f2f5;margin:0;padding:20px;'>"
                + "<div style='max-width:560px;margin:0 auto;background:#fff;border-radius:16px;"
                + "box-shadow:0 4px 20px rgba(0,0,0,0.08);overflow:hidden;'>"
                + "<div style='background:linear-gradient(135deg,#3b82f6,#2563eb);padding:32px;text-align:center;'>"
                + "<h1 style='color:#fff;margin:0;font-size:22px;'>&#127881; Đặt hàng thành công!</h1>"
                + "<p style='color:rgba(255,255,255,0.85);margin:8px 0 0;font-size:14px;'>Digital Library</p>"
                + "</div>"
                + "<div style='padding:32px;'>"
                + "<p style='color:#374151;font-size:15px;'>Xin chào <strong>" + escapeHtml(toName) + "</strong>,</p>"
                + "<p style='color:#374151;font-size:14px;'>Cảm ơn bạn đã ủng hộ Digital Library. Đơn hàng <strong>#" + orderId + "</strong> của bạn đã được xử lý và thanh toán thành công.</p>"
                + "<div style='background:#eff6ff;border-left:4px solid #3b82f6;border-radius:8px;padding:16px;margin:16px 0;'>"
                + "<p style='margin:0;color:#1e40af;font-size:14px;'>&#128176; <strong>Tổng tiền:</strong> " + String.format("%,d", totalAmount.longValue()) + " VNĐ</p>"
                + "</div>"
                + "<p style='color:#6b7280;font-size:13px;'>Bây giờ bạn có thể đọc sách ngay trong thư viện của mình trên website.</p>"
                + "<hr style='border:none;border-top:1px solid #e5e7eb;margin:20px 0;'>"
                + "<p style='color:#9ca3af;font-size:12px;'>Nếu bạn có thắc mắc, vui lòng liên hệ với chúng tôi.</p>"
                + "</div></div></body></html>";
        return sendEmail(toEmail, toName, subject, html);
    }

    /**
     * Gửi email thông báo tạo tài khoản độc giả
     */
    public static boolean sendNewReaderEmail(String toEmail, String toName, String rawPassword, String roleName) {
        String subject = "[Digital Library] Thông báo tạo tài khoản thành công";
        String html = "<!DOCTYPE html><html><body style='font-family:Arial,sans-serif;background:#f0f2f5;margin:0;padding:20px;'>"
                + "<div style='max-width:560px;margin:0 auto;background:#fff;border-radius:16px;"
                + "box-shadow:0 4px 20px rgba(0,0,0,0.08);overflow:hidden;'>"
                + "<div style='background:linear-gradient(135deg,#10b981,#059669);padding:32px;text-align:center;'>"
                + "<h1 style='color:#fff;margin:0;font-size:22px;'>&#127881; Tài khoản đã được tạo!</h1>"
                + "<p style='color:rgba(255,255,255,0.85);margin:8px 0 0;font-size:14px;'>Digital Library</p>"
                + "</div>"
                + "<div style='padding:32px;'>"
                + "<p style='color:#374151;font-size:15px;'>Xin chào <strong>" + escapeHtml(toName) + "</strong>,</p>"
                + "<p style='color:#374151;font-size:14px;'>Tài khoản độc giả của bạn đã được quản trị viên khởi tạo thành công trên hệ thống Digital Library.</p>"
                + "<div style='background:#ecfdf5;border-left:4px solid #10b981;border-radius:8px;padding:16px;margin:16px 0;'>"
                + "<p style='margin:0 0 8px;color:#065f46;font-size:14px;'>&#128231; <strong>Email đăng nhập:</strong> " + escapeHtml(toEmail) + "</p>"
                + "<p style='margin:0 0 8px;color:#065f46;font-size:14px;'>&#128187; <strong>Quyền hạn:</strong> " + escapeHtml(roleName) + "</p>"
                + "<p style='margin:0;color:#065f46;font-size:14px;'>&#128273; <strong>Mật khẩu tạm thời:</strong> " + escapeHtml(rawPassword) + "</p>"
                + "</div>"
                + "<p style='color:#6b7280;font-size:13px;'>Vui lòng đăng nhập vào hệ thống và đổi mật khẩu trong lần đầu tiên sử dụng để đảm bảo an toàn thao tác.</p>"
                + "<hr style='border:none;border-top:1px solid #e5e7eb;margin:20px 0;'>"
                + "<p style='color:#9ca3af;font-size:12px;'>Nếu bạn có thắc mắc, vui lòng liên hệ Thư viện.</p>"
                + "</div></div></body></html>";
        return sendEmail(toEmail, toName, subject, html);
    }

    /**
     * Gửi email thông báo cấp quyền cho nhân viên
     */
    public static boolean sendNewEmployeeEmail(String toEmail, String toName, String rawPassword, String roleName) {
        String subject = "[Digital Library] Thông báo cấp quyền hệ thống";
        String html = "<!DOCTYPE html><html><body style='font-family:Arial,sans-serif;background:#f0f2f5;margin:0;padding:20px;'>"
                + "<div style='max-width:560px;margin:0 auto;background:#fff;border-radius:16px;"
                + "box-shadow:0 4px 20px rgba(0,0,0,0.08);overflow:hidden;'>"
                + "<div style='background:linear-gradient(135deg,#f59e0b,#d97706);padding:32px;text-align:center;'>"
                + "<h1 style='color:#fff;margin:0;font-size:22px;'>&#128273; Cấp quyền thành công!</h1>"
                + "<p style='color:rgba(255,255,255,0.85);margin:8px 0 0;font-size:14px;'>Digital Library Admin</p>"
                + "</div>"
                + "<div style='padding:32px;'>"
                + "<p style='color:#374151;font-size:15px;'>Xin chào <strong>" + escapeHtml(toName) + "</strong>,</p>"
                + "<p style='color:#374151;font-size:14px;'>Email của bạn đã được <strong>nâng quyền/cấp quyền</strong> truy cập vào hệ thống quản trị của Digital Library.</p>"
                + "<div style='background:#fffbeb;border-left:4px solid #f59e0b;border-radius:8px;padding:16px;margin:16px 0;'>"
                + "<p style='margin:0 0 8px;color:#92400e;font-size:14px;'>&#128231; <strong>Email truy cập:</strong> " + escapeHtml(toEmail) + "</p>"
                + "<p style='margin:0 0 8px;color:#92400e;font-size:14px;'>&#128187; <strong>Quyền được cấp:</strong> " + escapeHtml(roleName) + "</p>"
                + "<p style='margin:0;color:#92400e;font-size:14px;'>&#128273; <strong>Mật khẩu hệ thống:</strong> " + escapeHtml(rawPassword) + "</p>"
                + "</div>"
                + "<p style='color:#6b7280;font-size:13px;'>Vui lòng đăng nhập vào hệ thống và đổi mật khẩu trong lần đầu tiên sử dụng để đảm bảo an toàn thao tác.</p>"
                + "<hr style='border:none;border-top:1px solid #e5e7eb;margin:20px 0;'>"
                + "<p style='color:#9ca3af;font-size:12px;'>Nếu bạn có thắc mắc, vui lòng liên hệ Ban quản trị.</p>"
                + "</div></div></body></html>";
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
                + "<h1 style='color:#fff;margin:0;font-size:24px;'>&#128274; Xác nhận liên kết</h1>"
                + "<p style='color:rgba(255,255,255,0.85);margin:8px 0 0;font-size:14px;'>Digital Library</p>"
                + "</div>"
                + "<div style='padding:32px;text-align:center;'>"
                + "<p style='color:#374151;font-size:15px;'>Xin chào <strong>" + escapeHtml(toName) + "</strong>,</p>"
                + "<p style='color:#374151;font-size:14px;'>Mã OTP xác nhận liên kết bằng Gmail của bạn là:</p>"
                + "<div style='display:inline-block;background:#f3f4f6;border:2px dashed #6366f1;"
                + "border-radius:12px;padding:18px 40px;margin:16px 0;'>"
                + "<span style='font-size:36px;font-weight:700;letter-spacing:12px;color:#6366f1;'>" + otp + "</span>"
                + "</div>"
                + "<p style='color:#6b7280;font-size:13px;'>Mã có hiệu lực trong <strong>5 phút</strong>. "
                + "Không chia sẻ mã này với bất kỳ ai.</p>"
                + "<hr style='border:none;border-top:1px solid #e5e7eb;margin:20px 0;'>"
                + "<p style='color:#9ca3af;font-size:12px;'>Nếu bạn không thực hiện yêu cầu liên kết này, hãy bỏ qua email này.</p>"
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
