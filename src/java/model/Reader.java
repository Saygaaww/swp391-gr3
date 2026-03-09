package model;

import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Reader model - Tài khoản người đọc (Customer/Reader)
 */
public class Reader {

    private Integer readerId;
    private String fullName;
    private String email;
    private String phone;
    private String passwordHash;
    private String avatarUrl;
    private String status;           // active, banned, unverified
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Reader() {}

    public Reader(String fullName, String email, String passwordHash) {
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.status = "active";
    }

    // ===================== Getters & Setters =====================

    public Integer getReaderId() { return readerId; }
    public void setReaderId(Integer readerId) { this.readerId = readerId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getAvatarUrl() { return avatarUrl; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    // ===================== Helper methods =====================

    public boolean isActive() {
        return "active".equals(this.status);
    }

    public boolean isBanned() {
        return "banned".equals(this.status);
    }

    /** Trả về avatar URL hoặc URL ảnh mặc định */
    public String getDisplayAvatar() {
        return (avatarUrl != null && !avatarUrl.isBlank())
                ? avatarUrl
                : "https://ui-avatars.com/api/?name=" + java.net.URLEncoder.encode(fullName != null ? fullName : "User", java.nio.charset.StandardCharsets.UTF_8) + "&background=6366f1&color=fff&size=128";
    }

    /** Lấy tên viết tắt (initials) để hiển thị avatar */
    public String getInitials() {
        if (fullName == null || fullName.isBlank()) return "?";
        String[] parts = fullName.trim().split("\\s+");
        if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
        return (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
    }

    public boolean hasPassword() {
        return passwordHash != null && !passwordHash.isBlank();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Reader reader = (Reader) o;
        return Objects.equals(readerId, reader.readerId);
    }

    @Override
    public int hashCode() { return Objects.hash(readerId); }

    @Override
    public String toString() {
        return "Reader{readerId=" + readerId + ", fullName='" + fullName + "', email='" + email + "', status='" + status + "'}";
    }
}
