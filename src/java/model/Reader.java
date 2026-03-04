package model;

import java.sql.Timestamp;

public class Reader {
    private int readerId;
    private String fullName;
    private String email;
    private String passwordHash;
    private String phone;
    private String avatar;
    private String status;        
    private Timestamp createdAt;
    private int roleId;             
    
   
    private String roleName;   
    
    public Reader() {
    }
    
    public Reader(int readerId, String fullName, String email, String passwordHash,
                  String phone, String avatar, String status, 
                  Timestamp createdAt, int roleId) {
        this.readerId = readerId;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
        this.avatar = avatar;
        this.status = status;
        this.createdAt = createdAt;
        this.roleId = roleId;
    }
    
    // Constructor khong co ID (dung khi them moi)
    public Reader(String fullName, String email, String passwordHash,
                  String phone, String avatar, String status, int roleId) {
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
        this.avatar = avatar;
        this.status = status;
        this.roleId = roleId;
    }

    // Getters va Setters
    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
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

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
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
        return "Reader{" +
                "readerId=" + readerId +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", status='" + status + '\'' +
                ", roleId=" + roleId +
                ", roleName='" + roleName + '\'' +
                '}';
    }
}