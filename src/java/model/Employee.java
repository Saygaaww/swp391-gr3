package model;

import java.sql.Timestamp;

/**
 * Model class đại diện cho nhân viên (Admin, Librarian, Seller)
 * Mapping với bảng Employee trong database
 * @author Member E - Dũng
 */
public class Employee {
    private int employeeId;
    private String fullName;
    private String email;
    private String passwordHash;
    private String status;
    private Timestamp createdAt;
    private int roleId;
    
    // Thông tin từ JOIN (không lưu trong DB)
    private String roleName; // ADMIN, LIBRARIAN, SELLER
    
    // Constructor rỗng
    public Employee() {
    }
    
    // Constructor đầy đủ
    public Employee(int employeeId, String fullName, String email, 
                   String passwordHash, String status, Timestamp createdAt, 
                   int roleId) {
        this.employeeId = employeeId;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.status = status;
        this.createdAt = createdAt;
        this.roleId = roleId;
    }
    
    // Constructor không có ID (dùng khi thêm mới)
    public Employee(String fullName, String email, String passwordHash, 
                   String status, int roleId) {
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.status = status;
        this.roleId = roleId;
    }
    
    // Getters và Setters
    public int getEmployeeId() {
        return employeeId;
    }
    
    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPasswordHash() {
        return passwordHash;
    }
    
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public int getRoleId() {
        return roleId;
    }
    
    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }
    
    public String getRoleName() {
        return roleName;
    }
    
    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }
    
    @Override
    public String toString() {
        return "Employee{" +
                "employeeId=" + employeeId +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", status='" + status + '\'' +
                ", roleId=" + roleId +
                ", roleName='" + roleName + '\'' +
                '}';
    }
}
