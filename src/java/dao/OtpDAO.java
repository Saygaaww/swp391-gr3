/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import util.DBContext;
import java.sql.*;

public class OtpDAO {

    public void saveOtp(String phone, String otp) {
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

    public boolean verifyOtp(String phone, String otp) {
        String sql = """
            SELECT * FROM Phone_Otp
            WHERE phone_number = ? AND otp_code = ?
            AND is_used = 0 AND expired_at > GETDATE()
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, phone);
            ps.setString(2, otp);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                markUsed(rs.getInt("otp_id"), con);
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private void markUsed(int id, Connection con) throws SQLException {
        PreparedStatement ps = con.prepareStatement(
                "UPDATE Phone_Otp SET is_used = 1 WHERE otp_id = ?");
        ps.setInt(1, id);
        ps.executeUpdate();
    }
}
