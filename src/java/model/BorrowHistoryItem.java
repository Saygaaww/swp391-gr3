package model;

import java.time.LocalDateTime;
import java.math.BigDecimal;

/**
 * One row for user borrow history: borrow + borrow_item + book title.
 */
public class BorrowHistoryItem {
    private int borrowId;
    private LocalDateTime borrowDate;
    private String borrowStatus;   // active, overdue, completed, cancelled
    private int borrowItemId;
    private int bookId;
    private String bookTitle;
    private String copyCode;
    private LocalDateTime dueDate;
    private LocalDateTime returnedAt;
    private String itemStatus;    // borrowed, returned, overdue, lost, damaged
    private int borrowCountForBook;

    public int getBorrowId() { return borrowId; }
    public void setBorrowId(int borrowId) { this.borrowId = borrowId; }
    public LocalDateTime getBorrowDate() { return borrowDate; }
    public void setBorrowDate(LocalDateTime borrowDate) { this.borrowDate = borrowDate; }
    public String getBorrowStatus() { return borrowStatus; }
    public void setBorrowStatus(String borrowStatus) { this.borrowStatus = borrowStatus; }
    public int getBorrowItemId() { return borrowItemId; }
    public void setBorrowItemId(int borrowItemId) { this.borrowItemId = borrowItemId; }
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
    public String getCopyCode() { return copyCode; }
    public void setCopyCode(String copyCode) { this.copyCode = copyCode; }
    public LocalDateTime getDueDate() { return dueDate; }
    public void setDueDate(LocalDateTime dueDate) { this.dueDate = dueDate; }
    public LocalDateTime getReturnedAt() { return returnedAt; }
    public void setReturnedAt(LocalDateTime returnedAt) { this.returnedAt = returnedAt; }
    public String getItemStatus() { return itemStatus; }
    public void setItemStatus(String itemStatus) { this.itemStatus = itemStatus; }
    public int getBorrowCountForBook() { return borrowCountForBook; }
    public void setBorrowCountForBook(int borrowCountForBook) { this.borrowCountForBook = borrowCountForBook; }

    /**
     * Số ngày trễ hạn (0 nếu không trễ).
     */
    public long getLateDays() {
        if (dueDate == null) return 0;
        LocalDateTime ref = (returnedAt != null) ? returnedAt : LocalDateTime.now();
        if (!ref.isAfter(dueDate)) return 0;
        long days = java.time.Duration.between(dueDate, ref).toDays();
        return Math.max(days, 0);
    }

    /**
     * Tiền phạt trả trễ = lateDays * 5000 (đơn vị tiền tệ nội bộ).
     */
    public BigDecimal getLateFee() {
        long lateDays = getLateDays();
        if (lateDays <= 0) return BigDecimal.ZERO;
        return BigDecimal.valueOf(lateDays).multiply(BigDecimal.valueOf(5000));
    }
}
