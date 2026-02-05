package model;

import java.sql.Timestamp;

/**
 * Model class đại diện cho độc giả (Reader/User)
 * Mapping với bảng Reader trong database
 * 
 * @author Member E - Dũng
 * @version Inter 2
 */
public class Reader {
    private int readerId;
    private String fullName;
    private String email;
    private String passwordHash;
    private String phone;
    private String address;
    private String status;          // active, inactive, blocked
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Constructor rỗng
    public Reader() {
    }
    
    // Constructor đầy đủ
    public Reader(int readerId, String fullName, String email, String passwordHash,
                  String phone, String address, String status, 
                  Timestamp createdAt, Timestamp updatedAt) {
        this.readerId = readerId;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
        this.address = address;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Constructor không có ID (dùng khi thêm mới)
    public Reader(String fullName, String email, String passwordHash,
                  String phone, String address, String status) {
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
        this.address = address;
        this.status = status;
    }

    // Getters và Setters
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

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "Reader{" +
                "readerId=" + readerId +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}