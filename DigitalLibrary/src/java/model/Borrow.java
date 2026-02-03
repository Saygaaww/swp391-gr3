package model;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Phiếu mượn sách (1 request -> 0..1 borrow).
 * status: active, overdue, completed, cancelled
 */
public class Borrow {
    private int borrowId;
    private int readerId;
    private Integer requestId;
    private LocalDateTime borrowDate;
    private String status;
    private LocalDateTime createdAt;
    private Integer approvedByEmployeeId;

    private Reader reader;
    private BorrowRequest borrowRequest;
    private Employee approvedByEmployee;
    private List<BorrowItem> items;

    public Borrow() {
    }

    public Borrow(int readerId, String status) {
        this.readerId = readerId;
        this.status = status;
    }

    public int getBorrowId() {
        return borrowId;
    }

    public void setBorrowId(int borrowId) {
        this.borrowId = borrowId;
    }

    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
    }

    public Integer getRequestId() {
        return requestId;
    }

    public void setRequestId(Integer requestId) {
        this.requestId = requestId;
    }

    public LocalDateTime getBorrowDate() {
        return borrowDate;
    }

    public void setBorrowDate(LocalDateTime borrowDate) {
        this.borrowDate = borrowDate;
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

    public Integer getApprovedByEmployeeId() {
        return approvedByEmployeeId;
    }

    public void setApprovedByEmployeeId(Integer approvedByEmployeeId) {
        this.approvedByEmployeeId = approvedByEmployeeId;
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

    public BorrowRequest getBorrowRequest() {
        return borrowRequest;
    }

    public void setBorrowRequest(BorrowRequest borrowRequest) {
        this.borrowRequest = borrowRequest;
        if (borrowRequest != null) {
            this.requestId = borrowRequest.getRequestId();
        }
    }

    public Employee getApprovedByEmployee() {
        return approvedByEmployee;
    }

    public void setApprovedByEmployee(Employee approvedByEmployee) {
        this.approvedByEmployee = approvedByEmployee;
        if (approvedByEmployee != null) {
            this.approvedByEmployeeId = approvedByEmployee.getEmployeeId();
        }
    }

    public List<BorrowItem> getItems() {
        return items;
    }

    public void setItems(List<BorrowItem> items) {
        this.items = items;
    }
}
