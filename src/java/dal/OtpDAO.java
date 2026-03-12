package dal;

import java.sql.*;

public class OtpDAO extends DBContext {

    // Luu OTP cho phone
    public void saveOtpForPhone(String phone, String otp) {
        String sql = "INSERT INTO OTP_Codes(phone_number, otp_code, expires_at) " +
                     "VALUES (?, ?, DATEADD(MINUTE, 5, GETDATE()))";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setString(2, otp);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xac nhan OTP phone
    public boolean verifyOtpForPhone(String phone, String otp) {
        String sql = "SELECT otp_id FROM OTP_Codes " +
                     "WHERE phone_number = ? AND otp_code = ? " +
                     "AND is_used = 0 AND expires_at > GETDATE()";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setString(2, otp);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                markUsed("OTP_Codes", rs.getInt("otp_id"), con);
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Luu OTP cho email
    public void saveOtpForEmail(String email, String otp) {
        String sql = "INSERT INTO Email_Otp(email, otp_code, expired_at) " +
                     "VALUES (?, ?, DATEADD(MINUTE, 5, GETDATE()))";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, otp);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xac nhan OTP email
    public boolean verifyOtpForEmail(String email, String otp) {
        String sql = "SELECT otp_id FROM Email_Otp " +
                     "WHERE email = ? AND otp_code = ? " +
                     "AND is_used = 0 AND expired_at > GETDATE()";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, otp);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                markUsed("Email_Otp", rs.getInt("otp_id"), con);
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private void markUsed(String table, int otpId, Connection con) throws SQLException {
        String sql = "UPDATE " + table + " SET is_used = 1 WHERE otp_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, otpId);
            ps.executeUpdate();
        }
    }
}