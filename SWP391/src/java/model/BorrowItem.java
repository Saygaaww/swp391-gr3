package model;

import java.util.Date;

public class BorrowItem {
    private int borrowItemId;
    private int borrowId;
    private int copyId;
    private Date dueDate;
    private Date returnedAt;
    private String status; // borrowed, returned, overdue, lost, damaged

    public BorrowItem() {
    }

    public BorrowItem(int borrowItemId, int borrowId, int copyId, Date dueDate, String status) {
        this.borrowItemId = borrowItemId;
        this.borrowId = borrowId;
        this.copyId = copyId;
        this.dueDate = dueDate;
        this.status = status;
    }

    public int getBorrowItemId() {
        return borrowItemId;
    }

    public void setBorrowItemId(int borrowItemId) {
        this.borrowItemId = borrowItemId;
    }

    public int getBorrowId() {
        return borrowId;
    }

    public void setBorrowId(int borrowId) {
        this.borrowId = borrowId;
    }

    public int getCopyId() {
        return copyId;
    }

    public void setCopyId(int copyId) {
        this.copyId = copyId;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public Date getReturnedAt() {
        return returnedAt;
    }

    public void setReturnedAt(Date returnedAt) {
        this.returnedAt = returnedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}

