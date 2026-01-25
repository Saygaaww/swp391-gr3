package model;

import java.sql.Timestamp;

public class BookCopy {
    private int copyId;
    private int bookId;
    private String copyCode;
    private String status; // available, borrowed, reserved, lost, damaged
    private Timestamp createdAt;

    public BookCopy() {
    }

    public BookCopy(int copyId, int bookId, String copyCode, String status, Timestamp createdAt) {
        this.copyId = copyId;
        this.bookId = bookId;
        this.copyCode = copyCode;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getCopyId() {
        return copyId;
    }

    public void setCopyId(int copyId) {
        this.copyId = copyId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getCopyCode() {
        return copyCode;
    }

    public void setCopyCode(String copyCode) {
        this.copyCode = copyCode;
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
}

