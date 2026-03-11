package model;

import java.time.LocalDateTime;

/**
 * Bookmark: đánh dấu trang + ghi chú theo sách.
 */
public class Bookmark {
    private int bookmarkId;
    private int readerId;
    private int bookId;
    private int pageNumber;
    private String note;
    private LocalDateTime createdAt;
    // Join
    private String bookTitle;
    private String bookCoverUrl;
    private Integer bookTotalPages;

    public int getBookmarkId() { return bookmarkId; }
    public void setBookmarkId(int bookmarkId) { this.bookmarkId = bookmarkId; }
    public int getReaderId() { return readerId; }
    public void setReaderId(int readerId) { this.readerId = readerId; }
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    public int getPageNumber() { return pageNumber; }
    public void setPageNumber(int pageNumber) { this.pageNumber = pageNumber; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
    public String getBookCoverUrl() { return bookCoverUrl; }
    public void setBookCoverUrl(String bookCoverUrl) { this.bookCoverUrl = bookCoverUrl; }
    public Integer getBookTotalPages() { return bookTotalPages; }
    public void setBookTotalPages(Integer bookTotalPages) { this.bookTotalPages = bookTotalPages; }
}
