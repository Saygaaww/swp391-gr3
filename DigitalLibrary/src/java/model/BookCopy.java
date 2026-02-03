package model;

import java.time.LocalDateTime;

/**
 * Bản sao sách vật lý (copy) - dùng cho mượn thư viện.
 * status: available, borrowed, reserved, lost, damaged
 */
public class BookCopy {
    private int copyId;
    private int bookId;
    private String copyCode;
    private String status;
    private LocalDateTime createdAt;

    private Book book;

    public BookCopy() {
    }

    public BookCopy(int bookId, String copyCode, String status) {
        this.bookId = bookId;
        this.copyCode = copyCode;
        this.status = status;
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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
        if (book != null) {
            this.bookId = book.getBookId();
        }
    }
}
