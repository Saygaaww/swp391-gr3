package model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BorrowRequest {
    private int requestId;
    private int readerId;
    private String status;
    private LocalDateTime requestedAt;
    private String note;
    private Integer processedByEmployeeId;
    private LocalDateTime processedAt;
    private String decisionNote;
    private java.time.LocalDate expectedStartDate;
    private java.time.LocalDate expectedReturnDate;

    private String readerName;
    private String readerEmail;
    private String readerPhone;
    private String employeeName;
    private List<BorrowRequestItem> items = new ArrayList<>();

    public BorrowRequest() {
    }

    public java.time.LocalDate getExpectedStartDate() {
        return expectedStartDate;
    }

    public void setExpectedStartDate(java.time.LocalDate expectedStartDate) {
        this.expectedStartDate = expectedStartDate;
    }

    public java.time.LocalDate getExpectedReturnDate() {
        return expectedReturnDate;
    }

    public void setExpectedReturnDate(java.time.LocalDate expectedReturnDate) {
        this.expectedReturnDate = expectedReturnDate;
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

    public String getReaderPhone() {
        return readerPhone;
    }

    public void setReaderPhone(String readerPhone) {
        this.readerPhone = readerPhone;
    }

    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }

    public List<BorrowRequestItem> getItems() {
        return items;
    }

    public void setItems(List<BorrowRequestItem> items) {
        this.items = items;
    }
}
