package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Phạt (trả muộn, mất sách, hư sách).
 * status: unpaid, paid, waived
 */
public class Fine {
    private int fineId;
    private int readerId;
    private int borrowItemId;
    private int fineTypeId;

    private BigDecimal amount;
    private String reason;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime paidAt;

    private Integer handledByEmployeeId;

    private Reader reader;
    private BorrowItem borrowItem;
    private FineType fineType;
    private Employee handledByEmployee;

    public Fine() {
    }

    public Fine(int readerId, int borrowItemId, int fineTypeId, BigDecimal amount, String status) {
        this.readerId = readerId;
        this.borrowItemId = borrowItemId;
        this.fineTypeId = fineTypeId;
        this.amount = amount;
        this.status = status;
    }

    public int getFineId() {
        return fineId;
    }

    public void setFineId(int fineId) {
        this.fineId = fineId;
    }

    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
    }

    public int getBorrowItemId() {
        return borrowItemId;
    }

    public void setBorrowItemId(int borrowItemId) {
        this.borrowItemId = borrowItemId;
    }

    public int getFineTypeId() {
        return fineTypeId;
    }

    public void setFineTypeId(int fineTypeId) {
        this.fineTypeId = fineTypeId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
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

    public LocalDateTime getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(LocalDateTime paidAt) {
        this.paidAt = paidAt;
    }

    public Integer getHandledByEmployeeId() {
        return handledByEmployeeId;
    }

    public void setHandledByEmployeeId(Integer handledByEmployeeId) {
        this.handledByEmployeeId = handledByEmployeeId;
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

    public BorrowItem getBorrowItem() {
        return borrowItem;
    }

    public void setBorrowItem(BorrowItem borrowItem) {
        this.borrowItem = borrowItem;
        if (borrowItem != null) {
            this.borrowItemId = borrowItem.getBorrowItemId();
        }
    }

    public FineType getFineType() {
        return fineType;
    }

    public void setFineType(FineType fineType) {
        this.fineType = fineType;
        if (fineType != null) {
            this.fineTypeId = fineType.getFineTypeId();
        }
    }

    public Employee getHandledByEmployee() {
        return handledByEmployee;
    }

    public void setHandledByEmployee(Employee handledByEmployee) {
        this.handledByEmployee = handledByEmployee;
        if (handledByEmployee != null) {
            this.handledByEmployeeId = handledByEmployee.getEmployeeId();
        }
    }
}
