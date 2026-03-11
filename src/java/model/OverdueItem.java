package model;

import java.time.LocalDateTime;

/**
 * DTO cho một mục mượn quá hạn – chỉ dùng để hiển thị trên dashboard (không CRUD).
 */
public class OverdueItem {
    private int borrowItemId;
    private String readerName;
    private String bookTitle;
    private LocalDateTime dueDate;

    public int getBorrowItemId() { return borrowItemId; }
    public void setBorrowItemId(int borrowItemId) { this.borrowItemId = borrowItemId; }
    public String getReaderName() { return readerName; }
    public void setReaderName(String readerName) { this.readerName = readerName; }
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
    public LocalDateTime getDueDate() { return dueDate; }
    public void setDueDate(LocalDateTime dueDate) { this.dueDate = dueDate; }
}
