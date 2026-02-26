package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Book {
    private int bookId;
    private String title;
    private String summary;
    private String description;
    private String coverUrl;
    private String contentPath;
    private BigDecimal price;
    private String currency;
    private int totalPages;
    private int previewPages;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    private int authorId;
    private int categoryId;
    private Integer createdByEmployeeId; 
    private Integer updatedByEmployeeId; 
    
    private String categoryName;
    private String authorName;
    
    public Book() {
    }
    
    public Book(int bookId, String title, String summary, String description,
                String coverUrl, String contentPath, BigDecimal price, String currency,
                int totalPages, int previewPages, String status, Timestamp createdAt,
                Timestamp updatedAt, int authorId, int categoryId,
                Integer createdByEmployeeId, Integer updatedByEmployeeId) {
        this.bookId = bookId;
        this.title = title;
        this.summary = summary;
        this.description = description;
        this.coverUrl = coverUrl;
        this.contentPath = contentPath;
        this.price = price;
        this.currency = currency;
        this.totalPages = totalPages;
        this.previewPages = previewPages;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.authorId = authorId;
        this.categoryId = categoryId;
        this.createdByEmployeeId = createdByEmployeeId;
        this.updatedByEmployeeId = updatedByEmployeeId;
    }
    
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
    
    public int getTotalPages() {
        return totalPages;
    }
    
    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
    }
    
    public int getPreviewPages() {
        return previewPages;
    }
    
    public void setPreviewPages(int previewPages) {
        this.previewPages = previewPages;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public int getAuthorId() {
        return authorId;
    }
    
    public void setAuthorId(int authorId) {
        this.authorId = authorId;
    }
    
    public int getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(int categoryId) {
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
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public String getAuthorName() {
        return authorName;
    }
    
    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }
    
    @Override
    public String toString() {
        return "Book{" +
                "bookId=" + bookId +
                ", title='" + title + '\'' +
                ", price=" + price +
                ", totalPages=" + totalPages +
                ", status='" + status + '\'' +
                ", categoryName='" + categoryName + '\'' +
                ", authorName='" + authorName + '\'' +
                '}';
    }
}