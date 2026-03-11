package dao;

import model.Employee;
import util.DBContext;

import java.sql.*;

public class EmployeeDAO {

    /* ================= LOGIN EMAIL + PASSWORD ================= */
    public Employee loginByEmailPassword(String email, String passwordHash) {

        String sql = """
            SELECT e.*, ro.role_name
            FROM Employee e
            JOIN Role ro ON e.role_id = ro.role_id
            WHERE e.email = ? AND e.password_hash = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, passwordHash);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapEmployee(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /* ================= FIND BY EMAIL ================= */
    public Employee findByEmail(String email) {

        String sql = """
            SELECT e.*, ro.role_name
            FROM Employee e
            JOIN Role ro ON e.role_id = ro.role_id
            WHERE e.email = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapEmployee(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /* ================= FIND BY ID ================= */
    public Employee findById(int employeeId) {

        String sql = """
            SELECT e.*, ro.role_name
            FROM Employee e
            JOIN Role ro ON e.role_id = ro.role_id
            WHERE e.employee_id = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapEmployee(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /* ================= CREATE EMPLOYEE (Admin only) ================= */
    public boolean createEmployee(String fullName, String email, String passwordHash, int roleId) {

        String sql = """
            INSERT INTO Employee(full_name, email, password_hash, status, role_id)
            VALUES (?, ?, ?, 'active', ?)
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, passwordHash);
            ps.setInt(4, roleId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ================= UPDATE EMPLOYEE STATUS ================= */
    public boolean updateStatus(int employeeId, String status) {

        String sql = """
            UPDATE Employee
            SET status = ?
            WHERE employee_id = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, employeeId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ================= UPDATE PASSWORD ================= */
    public boolean updatePassword(int employeeId, String hashedPassword) {

        String sql = """
            UPDATE Employee
            SET password_hash = ?
            WHERE employee_id = ?
        """;

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, hashedPassword);
            ps.setInt(2, employeeId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* ================= CHECK EMAIL EXISTS ================= */
    public boolean isEmailExists(String email) {

        String sql = "SELECT 1 FROM Employee WHERE email = ?";

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

    /* ================= MAP RESULTSET ================= */
    private Employee mapEmployee(ResultSet rs) throws SQLException {

        Employee e = new Employee();

        e.setEmployeeId(rs.getInt("employee_id"));
        e.setFullName(rs.getString("full_name"));
        e.setEmail(rs.getString("email"));
        e.setStatus(rs.getString("status"));
        e.setRoleId(rs.getInt("role_id"));
        e.setRoleName(rs.getString("role_name"));

        return e;
    }
}
