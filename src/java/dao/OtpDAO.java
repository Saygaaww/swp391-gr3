/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import util.DBContext;
import java.sql.*;

public class OtpDAO {

    /* ================= PHONE OTP ================= */

    public void saveOtpForPhone(String phone, String otp) {
        String sql = """
            INSERT INTO Phone_Otp(phone_number, otp_code, expired_at)
            VALUES (?, ?, DATEADD(MINUTE, 5, GETDATE()))
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, phone);
            ps.setString(2, otp);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean verifyOtpForPhone(String phone, String otp) {
        String sql = """
            SELECT otp_id FROM Phone_Otp
            WHERE phone_number = ? AND otp_code = ?
              AND is_used = 0 AND expired_at > GETDATE()
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, phone);
            ps.setString(2, otp);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                markUsed("Phone_Otp", rs.getInt("otp_id"), con);
                return true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ================= EMAIL OTP ================= */

    public void saveOtpForEmail(String email, String otp) {
        String sql = """
            INSERT INTO Email_Otp(email, otp_code, expired_at)
            VALUES (?, ?, DATEADD(MINUTE, 5, GETDATE()))
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, otp);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean verifyOtpForEmail(String email, String otp) {
        String sql = """
            SELECT otp_id FROM Email_Otp
            WHERE email = ? AND otp_code = ?
              AND is_used = 0 AND expired_at > GETDATE()
        """;

        try (Connection con = DBContext.getConnection();
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

    /* ================= COMMON ================= */

    private void markUsed(String table, int otpId, Connection con) throws SQLException {
        String sql = "UPDATE " + table + " SET is_used = 1 WHERE otp_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, otpId);
            ps.executeUpdate();
        }
    }
}
