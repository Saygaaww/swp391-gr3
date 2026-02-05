package model;

/**
 * Model class đại diện cho vai trò (Role)
 * Mapping với bảng Role trong database
 * 
 * @author Member E - Dũng
 * @version Inter 2
 */
public class Role {
    private int roleId;
    private String roleName;        // ADMIN, LIBRARIAN, SELLER
    private String description;
    
    // Transient field (không lưu trong DB, dùng để hiển thị)
    private int employeeCount;
    
    // Constructor rỗng
    public Role() {
    }
    
    // Constructor đầy đủ
    public Role(int roleId, String roleName, String description) {
        this.roleId = roleId;
        this.roleName = roleName;
        this.description = description;
    }
    
    // Constructor không có ID (dùng khi thêm mới)
    public Role(String roleName, String description) {
        this.roleName = roleName;
        this.description = description;
    }

    // Getters và Setters
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
    
    public int getEmployeeCount() {
        return employeeCount;
    }
    
    public void setEmployeeCount(int employeeCount) {
        this.employeeCount = employeeCount;
    }

    @Override
    public String toString() {
        return "Role{" +
                "roleId=" + roleId +
                ", roleName='" + roleName + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}