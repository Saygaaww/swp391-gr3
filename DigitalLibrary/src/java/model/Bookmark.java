package model;

import java.time.LocalDateTime;

/**
 * Đánh dấu trang sách của reader.
 */
public class Bookmark {
    private int bookmarkId;
    private int readerId;
    private int bookId;
    private int pageNumber;
    private String note;
    private LocalDateTime createdAt;

    private Reader reader;
    private Book book;

    public Bookmark() {
    }

    public Bookmark(int readerId, int bookId, int pageNumber) {
        this.readerId = readerId;
        this.bookId = bookId;
        this.pageNumber = pageNumber;
    }

    public int getBookmarkId() {
        return bookmarkId;
    }

    public void setBookmarkId(int bookmarkId) {
        this.bookmarkId = bookmarkId;
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

    public int getPageNumber() {
        return pageNumber;
    }

    public void setPageNumber(int pageNumber) {
        this.pageNumber = pageNumber;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
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
