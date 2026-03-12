package model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

/**
 * Notification - Thông báo cho Reader
 */
public class Notification {

    private Integer notificationId;
    private Integer readerId;
    private String title;
    private String message;
    private String notifType; // general, overdue, reservation, order
    private boolean isRead;
    private LocalDateTime createdAt;

    public Notification() {
    }

    public Notification(Integer readerId, String title, String message, String notifType) {
        this.readerId = readerId;
        this.title = title;
        this.message = message;
        this.notifType = notifType;
        this.isRead = false;
    }

    public Integer getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(Integer notificationId) {
        this.notificationId = notificationId;
    }

    public Integer getReaderId() {
        return readerId;
    }

    public void setReaderId(Integer readerId) {
        this.readerId = readerId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getNotifType() {
        return notifType;
    }

    public void setNotifType(String notifType) {
        this.notifType = notifType;
    }

    public boolean isRead() {
        return isRead;
    }

    public void setRead(boolean read) {
        isRead = read;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    /** Icon CSS class tương ứng với loại thông báo */
    public String getTypeIcon() {
        if (notifType == null)
            return "fa-bell";
        switch (notifType.toLowerCase()) {
            case "overdue":
                return "fa-clock";
            case "reservation":
                return "fa-bookmark";
            case "order":
                return "fa-shopping-cart";
            default:
                return "fa-bell";
        }
    }

    /** Badge color class */
    public String getTypeBadgeClass() {
        if (notifType == null)
            return "badge-info";
        switch (notifType.toLowerCase()) {
            case "overdue":
                return "badge-danger";
            case "reservation":
                return "badge-warning";
            case "order":
                return "badge-success";
            default:
                return "badge-info";
        }
    }

    /** Thời gian hiển thị dạng "x phút trước" */
    public String getTimeAgo() {
        if (createdAt == null)
            return "";
        LocalDateTime now = LocalDateTime.now();
        long minutes = ChronoUnit.MINUTES.between(createdAt, now);
        if (minutes < 1)
            return "Vừa xong";
        if (minutes < 60)
            return minutes + " phút trước";
        long hours = ChronoUnit.HOURS.between(createdAt, now);
        if (hours < 24)
            return hours + " giờ trước";
        long days = ChronoUnit.DAYS.between(createdAt, now);
        if (days < 30)
            return days + " ngày trước";
        return createdAt.format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
    }
}
