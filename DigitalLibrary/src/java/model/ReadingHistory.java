package model;

import java.time.LocalDateTime;

/**
 * Lịch sử đọc sách (vị trí đọc cuối, thời gian).
 */
public class ReadingHistory {
    private int historyId;
    private int readerId;
    private int bookId;
    private Integer lastReadPosition;
    private LocalDateTime lastReadAt;

    private Reader reader;
    private Book book;

    public ReadingHistory() {
    }

    public ReadingHistory(int readerId, int bookId) {
        this.readerId = readerId;
        this.bookId = bookId;
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public Integer getLastReadPosition() {
        return lastReadPosition;
    }

    public void setLastReadPosition(Integer lastReadPosition) {
        this.lastReadPosition = lastReadPosition;
    }

    public LocalDateTime getLastReadAt() {
        return lastReadAt;
    }

    public void setLastReadAt(LocalDateTime lastReadAt) {
        this.lastReadAt = lastReadAt;
    }

    public Reader getReader() {
        return reader;
    }

    public void setReader(Reader reader) {
        this.reader = reader;
        if (reader != null) {
            this.readerId = reader.getReaderId();
        }
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
