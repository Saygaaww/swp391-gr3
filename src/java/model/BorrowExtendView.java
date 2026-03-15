package model;

import java.time.LocalDateTime;

public class BorrowExtendView {
    private int extendId;
    private int borrowItemId;
    private String bookTitle;
    private String copyCode;
    private LocalDateTime oldDueDate;
    private LocalDateTime requestedDueDate;
    private LocalDateTime approvedDueDate;
    private String status;
    private LocalDateTime requestedAt;
    private LocalDateTime processedAt;
    private String decisionNote;

    public int getExtendId() {
        return extendId;
    }

    public void setExtendId(int extendId) {
        this.extendId = extendId;
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

    public LocalDateTime getOldDueDate() {
        return oldDueDate;
    }

    public void setOldDueDate(LocalDateTime oldDueDate) {
        this.oldDueDate = oldDueDate;
    }

    public LocalDateTime getRequestedDueDate() {
        return requestedDueDate;
    }

    public void setRequestedDueDate(LocalDateTime requestedDueDate) {
        this.requestedDueDate = requestedDueDate;
    }

    public LocalDateTime getApprovedDueDate() {
        return approvedDueDate;
    }

    public void setApprovedDueDate(LocalDateTime approvedDueDate) {
        this.approvedDueDate = approvedDueDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(LocalDateTime requestedAt) {
        this.requestedAt = requestedAt;
    }

    public LocalDateTime getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(LocalDateTime processedAt) {
        this.processedAt = processedAt;
    }

    public String getDecisionNote() {
        return decisionNote;
    }

    public void setDecisionNote(String decisionNote) {
        this.decisionNote = decisionNote;
    }
}

