package model;

public class BorrowRequestItem {
    private int requestItemId;
    private int requestId;
    private int bookId;
    private int quantity;
    private Book book; // For display
    private int availableCopies; // For display

    public BorrowRequestItem() {
    }

    public BorrowRequestItem(int requestItemId, int requestId, int bookId, int quantity) {
        this.requestItemId = requestItemId;
        this.requestId = requestId;
        this.bookId = bookId;
        this.quantity = quantity;
    }

    public int getRequestItemId() {
        return requestItemId;
    }

    public void setRequestItemId(int requestItemId) {
        this.requestItemId = requestItemId;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public int getAvailableCopies() {
        return availableCopies;
    }

    public void setAvailableCopies(int availableCopies) {
        this.availableCopies = availableCopies;
    }
}

