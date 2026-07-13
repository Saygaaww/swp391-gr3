package model;

import java.time.LocalDateTime;

/**
 * Employee - Nhân viên thư viện (Admin / Librarian / Seller)
 * Đăng nhập qua bảng Employee + Role
 */
public class Employee {

    private Integer employeeId;
    private String fullName;
    private String email;
    private String passwordHash;
    private String status; // active, inactive
    private LocalDateTime createdAt;

    // Role info (join từ bảng Role)
    private Integer roleId;
    private String roleName; // ADMIN, LIBRARIAN, SELLER

    public Employee() {
    }

    // ========================= Getters & Setters =========================

    public Integer getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(Integer employeeId) {
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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    // ========================= Helpers =========================

    public boolean isActive() {
        return "active".equalsIgnoreCase(status);
    }

    public boolean hasPassword() {
        return passwordHash != null && !passwordHash.isBlank();
    }

    /**
     * Map roleName DB → AuthUtil role constant
     * DB: ADMIN → AuthUtil.ROLE_ADMIN ("Admin")
     * DB: LIBRARIAN → AuthUtil.ROLE_LIBRARIAN ("Librarian")
     * DB: SELLER → AuthUtil.ROLE_SELLER ("Seller")
     */
    public String getAuthRole() {
        if (roleName == null)
            return util.AuthUtil.ROLE_ADMIN;
        switch (roleName.toUpperCase()) {
            case "ADMIN":
                return util.AuthUtil.ROLE_ADMIN;
            case "LIBRARIAN":
                return util.AuthUtil.ROLE_LIBRARIAN;
            case "SELLER":
                return util.AuthUtil.ROLE_SELLER;
            default:
                return util.AuthUtil.ROLE_ADMIN;
        }
    }

    /** Trả về avatar initials */
    public String getInitials() {
        if (fullName == null || fullName.isBlank())
            return "?";
        String[] parts = fullName.trim().split("\\s+");
        if (parts.length == 1)
            return parts[0].substring(0, 1).toUpperCase();
        return (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
    }

    /** Avatar URL từ ui-avatars.com */
    public String getDisplayAvatar() {
        return "https://ui-avatars.com/api/?name="
                + java.net.URLEncoder.encode(fullName != null ? fullName : "Employee",
                        java.nio.charset.StandardCharsets.UTF_8)
                + "&background=6366f1&color=fff&size=128";
    }

    @Override
    public String toString() {
        return "Employee{id=" + employeeId + ", email='" + email + "', role='" + roleName + "'}";
    }
}
