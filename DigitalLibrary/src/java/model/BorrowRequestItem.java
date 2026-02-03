package model;

/**
 * Chi tiết sách trong yêu cầu mượn (Borrow_Request_Item).
 */
public class BorrowRequestItem {
    private int requestItemId;
    private int requestId;
    private int bookId;
    private int quantity;

    private BorrowRequest borrowRequest;
    private Book book;

    public BorrowRequestItem() {
    }

    public BorrowRequestItem(int requestId, int bookId, int quantity) {
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

    public BorrowRequest getBorrowRequest() {
        return borrowRequest;
    }

    public void setBorrowRequest(BorrowRequest borrowRequest) {
        this.borrowRequest = borrowRequest;
        if (borrowRequest != null) {
            this.requestId = borrowRequest.getRequestId();
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
