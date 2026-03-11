package model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BorrowRequest {
    private int requestId;
    private int readerId;
    private String status; // pending, approved, rejected, cancelled, expired
    private LocalDateTime requestedAt;
    private String note;
    private Integer processedByEmployeeId;
    private Integer processedByReaderId;
    private LocalDateTime processedAt;
    private String decisionNote;
    private String readerName;
    private String readerEmail;
    private List<BorrowRequestItem> items = new ArrayList<>();

    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }
    public int getReaderId() { return readerId; }
    public void setReaderId(int readerId) { this.readerId = readerId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getRequestedAt() { return requestedAt; }
    public void setRequestedAt(LocalDateTime requestedAt) { this.requestedAt = requestedAt; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Integer getProcessedByEmployeeId() { return processedByEmployeeId; }
    public void setProcessedByEmployeeId(Integer processedByEmployeeId) { this.processedByEmployeeId = processedByEmployeeId; }
    public Integer getProcessedByReaderId() { return processedByReaderId; }
    public void setProcessedByReaderId(Integer processedByReaderId) { this.processedByReaderId = processedByReaderId; }
    public LocalDateTime getProcessedAt() { return processedAt; }
    public void setProcessedAt(LocalDateTime processedAt) { this.processedAt = processedAt; }
    public String getDecisionNote() { return decisionNote; }
    public void setDecisionNote(String decisionNote) { this.decisionNote = decisionNote; }
    public String getReaderName() { return readerName; }
    public void setReaderName(String readerName) { this.readerName = readerName; }
    public String getReaderEmail() { return readerEmail; }
    public void setReaderEmail(String readerEmail) { this.readerEmail = readerEmail; }
    public List<BorrowRequestItem> getItems() { return items; }
    public void setItems(List<BorrowRequestItem> items) { this.items = items; }
}
