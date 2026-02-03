package dao;

import model.Employee;
import model.Role;
import utils.DBConnection;
import utils.PasswordUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class EmployeeDAO {
    
    public Employee getEmployeeByEmail(String email) throws SQLException {
        String sql = "SELECT e.employee_id, e.full_name, e.email, e.password_hash, "
                   + "e.status, e.created_at, e.role_id, "
                   + "ro.role_name, ro.description "
                   + "FROM Employee e "
                   + "LEFT JOIN Role ro ON e.role_id = ro.role_id "
                   + "WHERE e.email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Employee employee = new Employee();
                    employee.setEmployeeId(rs.getInt("employee_id"));
                    employee.setFullName(rs.getString("full_name"));
                    employee.setEmail(rs.getString("email"));
                    employee.setPasswordHash(rs.getString("password_hash"));
                    employee.setStatus(rs.getString("status"));
                    
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    if (createdAt != null) {
                        employee.setCreatedAt(createdAt.toLocalDateTime());
                    }
                    
                    employee.setRoleId(rs.getInt("role_id"));
                    
                    Role role = new Role();
                    role.setRoleId(rs.getInt("role_id"));
                    role.setRoleName(rs.getString("role_name"));
                    role.setDescription(rs.getString("description"));
                    employee.setRole(role);
                    
                    return employee;
                }
            }
        }
        return null;
    }
    
    public Employee getEmployeeById(int employeeId) throws SQLException {
        String sql = "SELECT e.employee_id, e.full_name, e.email, e.password_hash, "
                   + "e.status, e.created_at, e.role_id, "
                   + "ro.role_name, ro.description "
                   + "FROM Employee e "
                   + "LEFT JOIN Role ro ON e.role_id = ro.role_id "
                   + "WHERE e.employee_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, employeeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Employee employee = new Employee();
                    employee.setEmployeeId(rs.getInt("employee_id"));
                    employee.setFullName(rs.getString("full_name"));
                    employee.setEmail(rs.getString("email"));
                    employee.setPasswordHash(rs.getString("password_hash"));
                    employee.setStatus(rs.getString("status"));
                    
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    if (createdAt != null) {
                        employee.setCreatedAt(createdAt.toLocalDateTime());
                    }
                    
                    employee.setRoleId(rs.getInt("role_id"));
                    
                    Role role = new Role();
                    role.setRoleId(rs.getInt("role_id"));
                    role.setRoleName(rs.getString("role_name"));
                    role.setDescription(rs.getString("description"));
                    employee.setRole(role);
                    
                    return employee;
                }
            }
        }
        return null;
    }
    
    public boolean authenticate(String email, String password) throws SQLException {
        Employee employee = getEmployeeByEmail(email);
        if (employee != null && employee.getPasswordHash() != null) {
            return PasswordUtil.verifyPassword(password, employee.getPasswordHash());
        }
        return false;
    }
    
    public Employee createEmployee(String fullName, String email, String password, int roleId) throws SQLException {
        String sql = "INSERT INTO Employee (full_name, email, password_hash, role_id, status, created_at) "
                   + "VALUES (?, ?, ?, ?, 'active', SYSUTCDATETIME())";
        
        String passwordHash = PasswordUtil.hashPassword(password);
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, passwordHash);
            ps.setInt(4, roleId);
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int employeeId = rs.getInt(1);
                        return getEmployeeById(employeeId);
                    }
                }
            }
        }
        return null;
    }
}
