package model;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Yêu cầu mượn sách của reader.
 * status: pending, approved, rejected, cancelled, expired
 */
public class BorrowRequest {
    private int requestId;
    private int readerId;
    private String status;
    private LocalDateTime requestedAt;
    private String note;

    private Integer processedByEmployeeId;
    private LocalDateTime processedAt;
    private String decisionNote;

    private Reader reader;
    private Employee processedByEmployee;
    private List<BorrowRequestItem> items;

    public BorrowRequest() {
    }

    public BorrowRequest(int readerId, String status) {
        this.readerId = readerId;
        this.status = status;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getReaderId() {
        return readerId;
    }

    public void setReaderId(int readerId) {
        this.readerId = readerId;
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

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Integer getProcessedByEmployeeId() {
        return processedByEmployeeId;
    }

    public void setProcessedByEmployeeId(Integer processedByEmployeeId) {
        this.processedByEmployeeId = processedByEmployeeId;
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

    public Reader getReader() {
        return reader;
    }

    public void setReader(Reader reader) {
        this.reader = reader;
        if (reader != null) {
            this.readerId = reader.getReaderId();
        }
    }

    public Employee getProcessedByEmployee() {
        return processedByEmployee;
    }

    public void setProcessedByEmployee(Employee processedByEmployee) {
        this.processedByEmployee = processedByEmployee;
        if (processedByEmployee != null) {
            this.processedByEmployeeId = processedByEmployee.getEmployeeId();
        }
    }

    public List<BorrowRequestItem> getItems() {
        return items;
    }

    public void setItems(List<BorrowRequestItem> items) {
        this.items = items;
    }
}
