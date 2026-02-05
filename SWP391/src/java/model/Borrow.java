package model;

import java.util.Date;
import java.util.List;

public class Borrow {
    private int borrowId;
    private int readerId;
    private Integer requestId;
    private Date borrowDate;
    private String status; // active, overdue, completed, cancelled
    private Date createdAt;
    private Integer approvedByEmployeeId;
    private List<BorrowItem> borrowItems; // For display

    public Borrow() {
    }

    public Borrow(int borrowId, int readerId, Integer requestId, Date borrowDate, String status, Date createdAt) {
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

    public Date getBorrowDate() {
        return borrowDate;
    }

    public void setBorrowDate(Date borrowDate) {
        this.borrowDate = borrowDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getApprovedByEmployeeId() {
        return approvedByEmployeeId;
    }

    public void setApprovedByEmployeeId(Integer approvedByEmployeeId) {
        this.approvedByEmployeeId = approvedByEmployeeId;
    }

    public List<BorrowItem> getBorrowItems() {
        return borrowItems;
    }

    public void setBorrowItems(List<BorrowItem> borrowItems) {
        this.borrowItems = borrowItems;
    }
}

