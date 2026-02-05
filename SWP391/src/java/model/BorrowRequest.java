package model;

import java.util.Date;
import java.util.List;

public class BorrowRequest {
    private int requestId;
    private int readerId;
    private String status; // pending, approved, rejected, cancelled, expired
    private Date requestedAt;
    private String note;
    private Integer processedByEmployeeId;
    private Date processedAt;
    private String decisionNote;
    private List<BorrowRequestItem> requestItems; // For display

    public BorrowRequest() {
    }

    public BorrowRequest(int requestId, int readerId, String status, Date requestedAt, String note) {
        this.requestId = requestId;
        this.readerId = readerId;
        this.status = status;
        this.requestedAt = requestedAt;
        this.note = note;
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

    public Date getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(Date requestedAt) {
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

    public Date getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(Date processedAt) {
        this.processedAt = processedAt;
    }

    public String getDecisionNote() {
        return decisionNote;
    }

    public void setDecisionNote(String decisionNote) {
        this.decisionNote = decisionNote;
    }

    public List<BorrowRequestItem> getRequestItems() {
        return requestItems;
    }

    public void setRequestItems(List<BorrowRequestItem> requestItems) {
        this.requestItems = requestItems;
    }
}

