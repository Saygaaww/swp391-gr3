package dao;

import model.Employee;
import util.DBUtil;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * EmployeeDAO - Data access cho tài khoản Employee (Admin/Librarian/Seller)
 * JOIN với bảng Role để lấy role_name
 */
public class EmployeeDAO {

    private static final Logger LOGGER = Logger.getLogger(EmployeeDAO.class.getName());
    private Connection connection;

    public EmployeeDAO() throws SQLException {
        this.connection = DBUtil.getConnection();
    }

    public void close() {
        DBUtil.releaseConnection(connection);
    }

    // ==================== READ ====================

    /**
     * Tìm Employee theo email (JOIN với Role để lấy role_name)
     */
    public Employee findByEmail(String email) throws SQLException {
        String sql = "SELECT e.employee_id, e.full_name, e.email, e.password_hash, "
                + "       e.status, e.created_at, e.role_id, r.role_name "
                + "FROM Employee e "
                + "JOIN Role r ON e.role_id = r.role_id "
                + "WHERE e.email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "findByEmail employee error: " + email, e);
            throw e;
        }
        return null;
    }

    /**
     * Tìm Employee theo ID
     */
    public Employee findById(int employeeId) throws SQLException {
        String sql = "SELECT e.employee_id, e.full_name, e.email, e.password_hash, "
                + "       e.status, e.created_at, e.role_id, r.role_name "
                + "FROM Employee e "
                + "JOIN Role r ON e.role_id = r.role_id "
                + "WHERE e.employee_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "findById employee error: " + employeeId, e);
            throw e;
        }
        return null;
    }

    // ==================== UPDATE ====================

    /**
     * Cập nhật password_hash của Employee (dùng để tự động upgrade plain text →
     * hash)
     */
    public boolean updatePasswordHash(int employeeId, String newHash) throws SQLException {
        String sql = "UPDATE Employee SET password_hash = ? WHERE employee_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, employeeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "updatePasswordHash error for employee: " + employeeId, e);
            throw e;
        }
    }

    // ==================== MAPPING ====================

    private Employee mapRow(ResultSet rs) throws SQLException {
        Employee e = new Employee();
        e.setEmployeeId(rs.getInt("employee_id"));
        e.setFullName(rs.getNString("full_name"));
        e.setEmail(rs.getString("email"));
        e.setPasswordHash(rs.getString("password_hash"));
        e.setStatus(rs.getString("status"));
        e.setRoleId(rs.getInt("role_id"));
        e.setRoleName(rs.getString("role_name"));

        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            e.setCreatedAt(ts.toLocalDateTime());
        }
        return e;
    }
}
