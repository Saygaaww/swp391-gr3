package model;

import java.time.LocalDateTime;

public class BookCopy {
    private int copyId;
    private int bookId;
    private String copyCode;
    private String status; // available, borrowed, reserved, lost, damaged
    private LocalDateTime createdAt;

    public int getCopyId() { return copyId; }
    public void setCopyId(int copyId) { this.copyId = copyId; }
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    public String getCopyCode() { return copyCode; }
    public void setCopyCode(String copyCode) { this.copyCode = copyCode; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
