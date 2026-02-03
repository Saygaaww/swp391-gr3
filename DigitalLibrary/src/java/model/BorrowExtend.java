package model;

import java.time.LocalDateTime;

/**
 * Yêu cầu gia hạn mượn sách (Borrow_Extend).
 * status: pending, approved, rejected, cancelled
 */
public class BorrowExtend {
    private int extendId;
    private int borrowItemId;

    private LocalDateTime oldDueDate;
    private LocalDateTime requestedDueDate;
    private LocalDateTime approvedDueDate;

    private String status;
    private LocalDateTime requestedAt;
    private LocalDateTime processedAt;
    private String decisionNote;

    private Integer approvedByEmployeeId;

    private BorrowItem borrowItem;
    private Employee approvedByEmployee;

    public BorrowExtend() {
    }

    public BorrowExtend(int borrowItemId, LocalDateTime oldDueDate, LocalDateTime requestedDueDate, String status) {
        this.borrowItemId = borrowItemId;
        this.oldDueDate = oldDueDate;
        this.requestedDueDate = requestedDueDate;
        this.status = status;
    }

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

    public Integer getApprovedByEmployeeId() {
        return approvedByEmployeeId;
    }

    public void setApprovedByEmployeeId(Integer approvedByEmployeeId) {
        this.approvedByEmployeeId = approvedByEmployeeId;
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

    public Employee getApprovedByEmployee() {
        return approvedByEmployee;
    }

    public void setApprovedByEmployee(Employee approvedByEmployee) {
        this.approvedByEmployee = approvedByEmployee;
        if (approvedByEmployee != null) {
            this.approvedByEmployeeId = approvedByEmployee.getEmployeeId();
        }
    }
}
