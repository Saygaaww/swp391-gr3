package model;

import java.time.LocalDateTime;

/**
 * Sách reader sở hữu vĩnh viễn (mua hoặc admin cấp).
 */
public class ReaderBookOwnership {
    private int ownershipId;
    private int readerId;
    private int bookId;
    private LocalDateTime acquiredAt;
    private String acquiredVia;
    private String status;
    // Join
    private String bookTitle;
    private String bookCoverUrl;
    private String authorName;
    private String contentPath;
    private Integer bookTotalPages;

    public int getOwnershipId() { return ownershipId; }
    public void setOwnershipId(int ownershipId) { this.ownershipId = ownershipId; }
    public int getReaderId() { return readerId; }
    public void setReaderId(int readerId) { this.readerId = readerId; }
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    public LocalDateTime getAcquiredAt() { return acquiredAt; }
    public void setAcquiredAt(LocalDateTime acquiredAt) { this.acquiredAt = acquiredAt; }
    public String getAcquiredVia() { return acquiredVia; }
    public void setAcquiredVia(String acquiredVia) { this.acquiredVia = acquiredVia; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
    public String getBookCoverUrl() { return bookCoverUrl; }
    public void setBookCoverUrl(String bookCoverUrl) { this.bookCoverUrl = bookCoverUrl; }
    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }
    public String getContentPath() { return contentPath; }
    public void setContentPath(String contentPath) { this.contentPath = contentPath; }
    public Integer getBookTotalPages() { return bookTotalPages; }
    public void setBookTotalPages(Integer bookTotalPages) { this.bookTotalPages = bookTotalPages; }
}
