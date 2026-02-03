package model;

import java.time.LocalDateTime;

/**
 * Chi tiết từng bản copy trong phiếu mượn (Borrow_Item).
 * status: borrowed, returned, overdue, lost, damaged
 */
public class BorrowItem {
    private int borrowItemId;
    private int borrowId;
    private int copyId;
    private LocalDateTime dueDate;
    private LocalDateTime returnedAt;
    private String status;

    private Borrow borrow;
    private BookCopy bookCopy;

    public BorrowItem() {
    }

    public BorrowItem(int borrowId, int copyId, LocalDateTime dueDate, String status) {
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

    public LocalDateTime getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDateTime dueDate) {
        this.dueDate = dueDate;
    }

    public LocalDateTime getReturnedAt() {
        return returnedAt;
    }

    public void setReturnedAt(LocalDateTime returnedAt) {
        this.returnedAt = returnedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Borrow getBorrow() {
        return borrow;
    }

    public void setBorrow(Borrow borrow) {
        this.borrow = borrow;
        if (borrow != null) {
            this.borrowId = borrow.getBorrowId();
        }
    }

    public BookCopy getBookCopy() {
        return bookCopy;
    }

    public void setBookCopy(BookCopy bookCopy) {
        this.bookCopy = bookCopy;
        if (bookCopy != null) {
            this.copyId = bookCopy.getCopyId();
        }
    }
}
