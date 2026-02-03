package model;

import java.time.LocalDateTime;

/**
 * Đặt chỗ mượn sách khi không còn bản copy (hold).
 * status: pending, active, fulfilled, cancelled, expired
 */
public class Reservation {
    private int reservationId;
    private int readerId;
    private int bookId;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime expiresAt;
    private Integer fulfilledBorrowItemId;

    private Reader reader;
    private Book book;

    public Reservation() {
    }

    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
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

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public Integer getFulfilledBorrowItemId() {
        return fulfilledBorrowItemId;
    }

    public void setFulfilledBorrowItemId(Integer fulfilledBorrowItemId) {
        this.fulfilledBorrowItemId = fulfilledBorrowItemId;
    }

    public Reader getReader() {
        return reader;
    }

    public void setReader(Reader reader) {
        this.reader = reader;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }
}
