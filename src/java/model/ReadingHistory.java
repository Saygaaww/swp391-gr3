package model;

import java.time.LocalDateTime;

/**
 * L?ch sử ???c: v? trí và th??i ?i?m ???c cu?i m?i sách.
 */
public class ReadingHistory {
    private int historyId;
    private int readerId;
    private int bookId;
    private Integer lastReadPosition;
    private LocalDateTime lastReadAt;
    // Join
    private String bookTitle;
    private String bookCoverUrl;
    private Integer bookTotalPages;

    public int getHistoryId() { return historyId; }
    public void setHistoryId(int historyId) { this.historyId = historyId; }
    public int getReaderId() { return readerId; }
    public void setReaderId(int readerId) { this.readerId = readerId; }
    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }
    public Integer getLastReadPosition() { return lastReadPosition; }
    public void setLastReadPosition(Integer lastReadPosition) { this.lastReadPosition = lastReadPosition; }
    public LocalDateTime getLastReadAt() { return lastReadAt; }
    public void setLastReadAt(LocalDateTime lastReadAt) { this.lastReadAt = lastReadAt; }
    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }
    public String getBookCoverUrl() { return bookCoverUrl; }
    public void setBookCoverUrl(String bookCoverUrl) { this.bookCoverUrl = bookCoverUrl; }
    public Integer getBookTotalPages() { return bookTotalPages; }
    public void setBookTotalPages(Integer bookTotalPages) { this.bookTotalPages = bookTotalPages; }

    /** Tiến ?? % (0-100), null nếu không có total_pages. */
    public Integer getProgressPercent() {
        if (bookTotalPages == null || bookTotalPages <= 0 || lastReadPosition == null || lastReadPosition <= 0)
            return null;
        return Math.min(100, (lastReadPosition * 100) / bookTotalPages);
    }
}
