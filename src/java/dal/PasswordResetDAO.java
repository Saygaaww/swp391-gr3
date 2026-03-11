package dal;

import java.sql.*;
import java.util.Random;

public class PasswordResetDAO extends DBContext {

    public void saveOtpForEmail(String email, String otp) {
        String sql = "INSERT INTO Email_Otp(email, otp_code, expired_at, is_used) " +
                     "VALUES (?, ?, DATEADD(MINUTE, 5, GETDATE()), 0)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, otp);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean verifyOtpForEmail(String email, String otp) {
        String selectSql = "SELECT otp_id FROM Email_Otp " +
                           "WHERE email = ? AND otp_code = ? " +
                           "AND is_used = 0 AND expired_at > GETDATE()";
        String updateSql = "UPDATE Email_Otp SET is_used = 1 WHERE otp_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(selectSql)) {
            ps.setString(1, email);
            ps.setString(2, otp);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int otpId = rs.getInt("otp_id");
                try (PreparedStatement ups = con.prepareStatement(updateSql)) {
                    ups.setInt(1, otpId);
                    ups.executeUpdate();
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public String generateOTP() {
        return String.valueOf(100000 + new Random().nextInt(900000));
    }
}