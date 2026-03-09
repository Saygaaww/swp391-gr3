package model;

import java.sql.Timestamp;

public class BorrowRequest {
    private int requestId;
    private int readerId;
    private String status;
    private Timestamp requestedAt;
    private String note;
    private Integer processedByEmployeeId;
    private Timestamp processedAt;
    private String decisionNote;

    // Thong tin tu JOIN
    private String readerName;
    private String readerEmail;
    private String readerPhone;
    private String employeeName;

    public BorrowRequest() {}

    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getReaderId() { return readerId; }
    public void setReaderId(int readerId) { this.readerId = readerId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getRequestedAt() { return requestedAt; }
    public void setRequestedAt(Timestamp requestedAt) { this.requestedAt = requestedAt; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Integer getProcessedByEmployeeId() { return processedByEmployeeId; }
    public void setProcessedByEmployeeId(Integer processedByEmployeeId) { this.processedByEmployeeId = processedByEmployeeId; }

    public Timestamp getProcessedAt() { return processedAt; }
    public void setProcessedAt(Timestamp processedAt) { this.processedAt = processedAt; }

    public String getDecisionNote() { return decisionNote; }
    public void setDecisionNote(String decisionNote) { this.decisionNote = decisionNote; }

    public String getReaderName() { return readerName; }
    public void setReaderName(String readerName) { this.readerName = readerName; }

    public String getReaderEmail() { return readerEmail; }
    public void setReaderEmail(String readerEmail) { this.readerEmail = readerEmail; }

    public String getReaderPhone() { return readerPhone; }
    public void setReaderPhone(String readerPhone) { this.readerPhone = readerPhone; }

    public String getEmployeeName() { return employeeName; }
    public void setEmployeeName(String employeeName) { this.employeeName = employeeName; }

    @Override
    public String toString() {
        return "BorrowRequest{requestId=" + requestId +
               ", readerId=" + readerId +
               ", status='" + status + "'" +
               ", readerName='" + readerName + "'}";
    }
}