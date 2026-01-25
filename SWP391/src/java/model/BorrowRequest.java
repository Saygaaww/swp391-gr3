package model;

import java.sql.Timestamp;

public class BorrowRequest {
    private int requestId;
    private int readerId;
    private String status; // pending, approved, rejected, cancelled, expired
    private Timestamp requestedAt;
    private String note;
    private Integer processedByEmployeeId;
    private Timestamp processedAt;
    private String decisionNote;

    public BorrowRequest() {
    }

    public BorrowRequest(int requestId, int readerId, String status, Timestamp requestedAt, String note) {
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

    public Timestamp getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(Timestamp requestedAt) {
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

    public Timestamp getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(Timestamp processedAt) {
        this.processedAt = processedAt;
    }

    public String getDecisionNote() {
        return decisionNote;
    }

    public void setDecisionNote(String decisionNote) {
        this.decisionNote = decisionNote;
    }
}

