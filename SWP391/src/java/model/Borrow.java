package model;

import java.sql.Timestamp;

public class Borrow {
    private int borrowId;
    private int readerId;
    private Integer requestId;
    private Timestamp borrowDate;
    private String status; // active, overdue, completed, cancelled
    private Timestamp createdAt;
    private Integer approvedByEmployeeId;

    public Borrow() {
    }

    public Borrow(int borrowId, int readerId, Integer requestId, Timestamp borrowDate, String status, Timestamp createdAt) {
        this.borrowId = borrowId;
        this.readerId = readerId;
        this.requestId = requestId;
        this.borrowDate = borrowDate;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getBorrowId() {
        return borrowId;
    }

    public void setBorrowId(int borrowId) {
        this.borrowId = borrowId;
    }

    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
    }

    public Integer getRequestId() {
        return requestId;
    }

    public void setRequestId(Integer requestId) {
        this.requestId = requestId;
    }

    public Timestamp getBorrowDate() {
        return borrowDate;
    }

    public void setBorrowDate(Timestamp borrowDate) {
        this.borrowDate = borrowDate;
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

    public Integer getApprovedByEmployeeId() {
        return approvedByEmployeeId;
    }

    public void setApprovedByEmployeeId(Integer approvedByEmployeeId) {
        this.approvedByEmployeeId = approvedByEmployeeId;
    }
}

