/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.User;
import util.DBContext;
import util.PasswordUtil;

import java.sql.*;
import model.GoogleUser;

public class UserDAO {

    public User loginByEmailPassword(String email, String password) {
        String sql = """
            SELECT u.*, r.role_name
            FROM Users u
            JOIN Roles r ON u.role_id = r.role_id
            JOIN User_Accounts ua ON u.user_id = ua.user_id
            WHERE ua.email = ? AND ua.password_hash = ?
        """;

        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, PasswordUtil.hash(password));

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void createUserByPhone(String phone) {
        String insertUser = """
            INSERT INTO Users(phone_number, status, role_id)
            VALUES (?, 'ACTIVE', 3)
        """;

        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(insertUser, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, phone);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int userId = rs.getInt(1);

                String insertAccount = """
                    INSERT INTO User_Accounts(user_id, provider)
                    VALUES (?, 'PHONE')
                """;
                PreparedStatement ps2 = con.prepareStatement(insertAccount);
                ps2.setInt(1, userId);
                ps2.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public User loginByGoogle(GoogleUser gUser) {

        String checkSql = """
        SELECT u.*, r.role_name
        FROM Users u
        JOIN Roles r ON u.role_id = r.role_id
        JOIN User_Accounts ua ON u.user_id = ua.user_id
        WHERE ua.provider = 'GOOGLE' AND ua.provider_user_id = ?
    """;

        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(checkSql)) {

            ps.setString(1, gUser.getId());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapUser(rs);
            }

            // 👉 Nếu chưa tồn tại → tạo mới
            String insertUser = """
            INSERT INTO Users(full_name, email, avatar_url, status, role_id)
            VALUES (?, ?, ?, 'ACTIVE', 3)
        """;

            PreparedStatement ps1 = con.prepareStatement(insertUser, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, gUser.getName());
            ps1.setString(2, gUser.getEmail());
            ps1.setString(3, gUser.getPicture());
            ps1.executeUpdate();

            ResultSet key = ps1.getGeneratedKeys();
            if (key.next()) {
                int userId = key.getInt(1);

                String insertAccount = """
                INSERT INTO User_Accounts(user_id, provider, provider_user_id, email)
                VALUES (?, 'GOOGLE', ?, ?)
            """;

                PreparedStatement ps2 = con.prepareStatement(insertAccount);
                ps2.setInt(1, userId);
                ps2.setString(2, gUser.getId());
                ps2.setString(3, gUser.getEmail());
                ps2.executeUpdate();
            }

            return loginByGoogle(gUser);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isEmailExists(String email) {
        String sql = "SELECT 1 FROM User_Accounts WHERE email = ?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void registerByEmail(String fullName, String email, String password) {

        String insertUser = """
        INSERT INTO Users(full_name, email, status, role_id)
        VALUES (?, ?, 'ACTIVE', 3)
    """;

        String insertAccount = """
        INSERT INTO User_Accounts(user_id, provider, email, password_hash)
        VALUES (?, 'EMAIL', ?, ?)
    """;

        try (Connection con = DBContext.getConnection()) {

            con.setAutoCommit(false);

            PreparedStatement ps1
                    = con.prepareStatement(insertUser, Statement.RETURN_GENERATED_KEYS);

            ps1.setString(1, fullName);
            ps1.setString(2, email);
            ps1.executeUpdate();

            ResultSet rs = ps1.getGeneratedKeys();
            if (!rs.next()) {
                con.rollback();
                return;
            }

            int userId = rs.getInt(1);

            PreparedStatement ps2 = con.prepareStatement(insertAccount);
            ps2.setInt(1, userId);
            ps2.setString(2, email);
            ps2.setString(3, PasswordUtil.hash(password));
            ps2.executeUpdate();

            con.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setEmail(rs.getString("email"));
        u.setPhoneNumber(rs.getString("phone_number"));
        u.setStatus(rs.getString("status"));
        u.setRoleId(rs.getInt("role_id"));
        u.setRoleName(rs.getString("role_name"));
        return u;
    }
}
