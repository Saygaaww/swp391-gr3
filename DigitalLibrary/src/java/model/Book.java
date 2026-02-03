package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Book {
    private int bookId;
    private String title;
    private String summary;
    private String description;
    private String coverUrl;
    private String contentPath;
    private BigDecimal price;
    private String currency;
    private Integer totalPages;
    private Integer previewPages;
    private Integer stock; // Số lượng tồn kho (inventory)
    private String status; // active, inactive
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Approval workflow (SELLER tạo sách -> ADMIN duyệt)
    private String approvalStatus; // pending_approval, approved, rejected
    private Integer approvedByEmployeeId;
    private String approvalNotes;
    private LocalDateTime approvedAt;
    
    // Foreign keys
    private Integer authorId;
    private Integer categoryId;
    private Integer createdByEmployeeId;
    private Integer updatedByEmployeeId;
    
    // Related objects
    private Author author;
    private Category category;
    private Employee createdByEmployee;
    private Employee updatedByEmployee;
    private Employee approvedByEmployee;
    
    public Book() {
    }
    
    public Book(String title, String summary, String description, BigDecimal price, String status) {
        this.title = title;
        this.summary = summary;
        this.description = description;
        this.price = price;
        this.status = status;
    }
    
    // Getters and Setters
    public int getBookId() {
        return bookId;
    }
    
    public void setBookId(int bookId) {
        this.bookId = bookId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getSummary() {
        return summary;
    }
    
    public void setSummary(String summary) {
        this.summary = summary;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getCoverUrl() {
        return coverUrl;
    }
    
    public void setCoverUrl(String coverUrl) {
        this.coverUrl = coverUrl;
    }
    
    public String getContentPath() {
        return contentPath;
    }
    
    public void setContentPath(String contentPath) {
        this.contentPath = contentPath;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public String getCurrency() {
        return currency;
    }
    
    public void setCurrency(String currency) {
        this.currency = currency;
    }
    
    public Integer getTotalPages() {
        return totalPages;
    }
    
    public void setTotalPages(Integer totalPages) {
        this.totalPages = totalPages;
    }
    
    public Integer getPreviewPages() {
        return previewPages;
    }
    
    public void setPreviewPages(Integer previewPages) {
        this.previewPages = previewPages;
    }
    
    public Integer getStock() {
        return stock;
    }
    
    public void setStock(Integer stock) {
        this.stock = stock;
    }
    
    /**
     * Kiểm tra sách còn hàng không
     */
    public boolean isInStock() {
        return stock != null && stock > 0;
    }
    
    /**
     * Kiểm tra số lượng có đủ không
     */
    public boolean hasEnoughStock(int requestedQuantity) {
        return stock != null && stock >= requestedQuantity;
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
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public Integer getAuthorId() {
        return authorId;
    }
    
    public void setAuthorId(Integer authorId) {
        this.authorId = authorId;
    }
    
    public Integer getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }
    
    public Integer getCreatedByEmployeeId() {
        return createdByEmployeeId;
    }
    
    public void setCreatedByEmployeeId(Integer createdByEmployeeId) {
        this.createdByEmployeeId = createdByEmployeeId;
    }
    
    public Integer getUpdatedByEmployeeId() {
        return updatedByEmployeeId;
    }
    
    public void setUpdatedByEmployeeId(Integer updatedByEmployeeId) {
        this.updatedByEmployeeId = updatedByEmployeeId;
    }
    
    public Author getAuthor() {
        return author;
    }
    
    public void setAuthor(Author author) {
        this.author = author;
        if (author != null) {
            this.authorId = author.getAuthorId();
        }
    }
    
    public Category getCategory() {
        return category;
    }
    
    public void setCategory(Category category) {
        this.category = category;
        if (category != null) {
            this.categoryId = category.getCategoryId();
        }
    }
    
    public Employee getCreatedByEmployee() {
        return createdByEmployee;
    }
    
    public void setCreatedByEmployee(Employee createdByEmployee) {
        this.createdByEmployee = createdByEmployee;
        if (createdByEmployee != null) {
            this.createdByEmployeeId = createdByEmployee.getEmployeeId();
        }
    }
    
    public Employee getUpdatedByEmployee() {
        return updatedByEmployee;
    }
    
    public void setUpdatedByEmployee(Employee updatedByEmployee) {
        this.updatedByEmployee = updatedByEmployee;
        if (updatedByEmployee != null) {
            this.updatedByEmployeeId = updatedByEmployee.getEmployeeId();
        }
    }

    public String getApprovalStatus() {
        return approvalStatus;
    }

    public void setApprovalStatus(String approvalStatus) {
        this.approvalStatus = approvalStatus;
    }

    public Integer getApprovedByEmployeeId() {
        return approvedByEmployeeId;
    }

    public void setApprovedByEmployeeId(Integer approvedByEmployeeId) {
        this.approvedByEmployeeId = approvedByEmployeeId;
    }

    public String getApprovalNotes() {
        return approvalNotes;
    }

    public void setApprovalNotes(String approvalNotes) {
        this.approvalNotes = approvalNotes;
    }

    public LocalDateTime getApprovedAt() {
        return approvedAt;
    }

    public void setApprovedAt(LocalDateTime approvedAt) {
        this.approvedAt = approvedAt;
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

    public String getApprovalStatusDisplay() {
        if (approvalStatus == null) return "Chưa xác định";
        switch (approvalStatus.toLowerCase()) {
            case "pending_approval":
                return "Chờ duyệt";
            case "approved":
                return "Đã duyệt";
            case "rejected":
                return "Đã từ chối";
            default:
                return approvalStatus;
        }
    }
}
