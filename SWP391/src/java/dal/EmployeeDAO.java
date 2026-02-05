package dal;

import model.Employee;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class EmployeeDAO extends DBContext {
    
    public Employee login(String email, String password) {
        String sql = "SELECT e.*, r.role_name FROM Employee e " +
                     "INNER JOIN Role r ON e.role_id = r.role_id " +
                     "WHERE e.email = ? AND e.password_hash = ? AND e.status = 'active'";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, hashPassword(password));
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Employee employee = new Employee();
                employee.setEmployeeId(rs.getInt("employee_id"));
                employee.setFullName(rs.getString("full_name"));
                employee.setEmail(rs.getString("email"));
                employee.setPasswordHash(rs.getString("password_hash"));
                employee.setStatus(rs.getString("status"));
                Timestamp createdAt = rs.getTimestamp("created_at");
                employee.setCreatedAt(createdAt != null ? new java.util.Date(createdAt.getTime()) : null);
                employee.setRoleId(rs.getInt("role_id"));
                employee.setRoleName(rs.getString("role_name"));
                
                return employee;
            }
        } catch (SQLException e) {
            System.out.println("Error logging in employee: " + e.getMessage());
        }
        
        return null;
    }
    
    public Employee getEmployeeById(int employeeId) {
        String sql = "SELECT e.*, r.role_name FROM Employee e " +
                     "INNER JOIN Role r ON e.role_id = r.role_id " +
                     "WHERE e.employee_id = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Employee employee = new Employee();
                employee.setEmployeeId(rs.getInt("employee_id"));
                employee.setFullName(rs.getString("full_name"));
                employee.setEmail(rs.getString("email"));
                employee.setPasswordHash(rs.getString("password_hash"));
                employee.setStatus(rs.getString("status"));
                Timestamp createdAt = rs.getTimestamp("created_at");
                employee.setCreatedAt(createdAt != null ? new java.util.Date(createdAt.getTime()) : null);
                employee.setRoleId(rs.getInt("role_id"));
                employee.setRoleName(rs.getString("role_name"));
                
                return employee;
            }
        } catch (SQLException e) {
            System.out.println("Error getting employee by id: " + e.getMessage());
        }
        
        return null;
    }
    
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            System.out.println("Error hashing password: " + e.getMessage());
            return password; // Fallback to plain password (not recommended for production)
        }
    }
}
