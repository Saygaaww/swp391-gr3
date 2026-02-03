package model;

import java.time.LocalDateTime;

/**
 * Sở hữu sách của reader (mua/được tặng).
 * acquired_via: order, promo, admin_grant
 * status: active, revoked
 */
public class ReaderBookOwnership {
    private int ownershipId;
    private int readerId;
    private int bookId;
    private LocalDateTime acquiredAt;
    private String acquiredVia;
    private String status;

    private Reader reader;
    private Book book;

    public ReaderBookOwnership() {
    }

    public ReaderBookOwnership(int readerId, int bookId, String acquiredVia, String status) {
        this.readerId = readerId;
        this.bookId = bookId;
        this.acquiredVia = acquiredVia;
        this.status = status;
    }

    public int getOwnershipId() {
        return ownershipId;
    }

    public void setOwnershipId(int ownershipId) {
        this.ownershipId = ownershipId;
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

    public LocalDateTime getAcquiredAt() {
        return acquiredAt;
    }

    public void setAcquiredAt(LocalDateTime acquiredAt) {
        this.acquiredAt = acquiredAt;
    }

    public String getAcquiredVia() {
        return acquiredVia;
    }

    public void setAcquiredVia(String acquiredVia) {
        this.acquiredVia = acquiredVia;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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
