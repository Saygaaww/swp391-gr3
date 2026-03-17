package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class FineView {
    private int fineId;
    private int borrowItemId;
    private String bookTitle;
    private String copyCode;
    private int fineTypeId;
    private String fineTypeName;
    private BigDecimal amount;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime paidAt;

    public int getFineId() {
        return fineId;
    }

    public void setFineId(int fineId) {
        this.fineId = fineId;
    }

    public int getBorrowItemId() {
        return borrowItemId;
    }

    public void setBorrowItemId(int borrowItemId) {
        this.borrowItemId = borrowItemId;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getCopyCode() {
        return copyCode;
    }

    public void setCopyCode(String copyCode) {
        this.copyCode = copyCode;
    }

    public int getFineTypeId() {
        return fineTypeId;
    }

    public void setFineTypeId(int fineTypeId) {
        this.fineTypeId = fineTypeId;
    }

    public String getFineTypeName() {
        return fineTypeName;
    }

    public void setFineTypeName(String fineTypeName) {
        this.fineTypeName = fineTypeName;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
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

    private String readerName;
    private String readerEmail;

    public String getReaderName() {
        return readerName;
    }

    public void setReaderName(String readerName) {
        this.readerName = readerName;
    }

    public String getReaderEmail() {
        return readerEmail;
    }

    public void setReaderEmail(String readerEmail) {
        this.readerEmail = readerEmail;
    }
}

