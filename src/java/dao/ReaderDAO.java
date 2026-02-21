package dao;

import model.Reader;
import model.GoogleUser;
import util.DBContext;

import java.sql.*;

public class ReaderDAO {

    /* ================= LOGIN EMAIL + PASSWORD ================= */
    public Reader loginByEmailPassword(String email, String passwordHash) {

        String sql = """
            SELECT r.*, ro.role_name
            FROM Reader r
            JOIN Role ro ON r.role_id = ro.role_id
            WHERE r.email = ? AND r.password_hash = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, passwordHash);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapReader(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /* ================= LOGIN GOOGLE ================= */
    public Reader loginByGoogle(GoogleUser gUser) {

        String checkSql = """
            SELECT r.*, ro.role_name
            FROM Reader r
            JOIN Role ro ON r.role_id = ro.role_id
            JOIN Reader_Account ra ON r.reader_id = ra.reader_id
            WHERE ra.provider = 'GOOGLE'
              AND ra.provider_user_id = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(checkSql)) {

            ps.setString(1, gUser.getId());
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapReader(rs);
            }

            /* 👉 chưa có → tạo reader mới */
            String insertReader = """
                INSERT INTO Reader(full_name, email, password_hash, avatar, status, role_id)
                VALUES (?, ?, '', ?, 'ACTIVE', 4)
            """;

            PreparedStatement ps1 = con.prepareStatement(insertReader, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, gUser.getName());
            ps1.setString(2, gUser.getEmail());
            ps1.setString(3, gUser.getPicture());
            ps1.executeUpdate();

            ResultSet key = ps1.getGeneratedKeys();
            if (key.next()) {
                int readerId = key.getInt(1);

                String insertAccount = """
                    INSERT INTO Reader_Account(reader_id, provider, provider_user_id)
                    VALUES (?, 'GOOGLE', ?)
                """;

                PreparedStatement ps2 = con.prepareStatement(insertAccount);
                ps2.setInt(1, readerId);
                ps2.setString(2, gUser.getId());
                ps2.executeUpdate();
            }

            return loginByGoogle(gUser);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /* ================= REGISTER EMAIL ================= */
    public boolean registerByEmail(String fullName, String email, String passwordHash) {

        String insertReader = """
            INSERT INTO Reader(full_name, email, password_hash, status, role_id)
            VALUES (?, ?, ?, 'ACTIVE', 4)
        """;

        String insertAccount = """
            INSERT INTO Reader_Account(reader_id, provider)
            VALUES (?, 'LOCAL')
        """;

        try (Connection con = DBContext.getConnection()) {

            con.setAutoCommit(false);

            PreparedStatement ps1 = con.prepareStatement(insertReader, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, fullName);
            ps1.setString(2, email);
            ps1.setString(3, passwordHash);
            ps1.executeUpdate();

            ResultSet rs = ps1.getGeneratedKeys();
            if (!rs.next()) {
                con.rollback();
                return false;
            }

            int readerId = rs.getInt(1);

            PreparedStatement ps2 = con.prepareStatement(insertAccount);
            ps2.setInt(1, readerId);
            ps2.executeUpdate();

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ================= CHECK EMAIL ================= */
    public boolean isEmailExists(String email) {

        String sql = "SELECT 1 FROM Reader WHERE email = ?";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ================= FIND BY EMAIL ================= */
    public Reader findByEmail(String email) {

        String sql = """
            SELECT r.*, ro.role_name
            FROM Reader r
            JOIN Role ro ON r.role_id = ro.role_id
            WHERE r.email = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapReader(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /* ================= UPDATE PASSWORD ================= */
    public boolean updatePasswordByEmail(String email, String hashedPassword) {

        String sql = """
            UPDATE Reader
            SET password_hash = ?
            WHERE email = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, hashedPassword);
            ps.setString(2, email);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ================= MAP RESULTSET ================= */
    private Reader mapReader(ResultSet rs) throws SQLException {

        Reader r = new Reader();

        r.setReaderId(rs.getInt("reader_id"));
        r.setFullName(rs.getString("full_name"));
        r.setEmail(rs.getString("email"));
        r.setPhone(rs.getString("phone"));
        r.setAvatar(rs.getString("avatar"));
        r.setStatus(rs.getString("status"));
        r.setRoleId(rs.getInt("role_id"));
        r.setRoleName(rs.getString("role_name"));

        return r;
    }
}
