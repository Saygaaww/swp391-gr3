package model;

import java.sql.Timestamp;

public class Book {
    private int bookId;
    private String title;
    private String summary;
    private String description;
    private String coverUrl;
    private String contentPath;
    private Double price;
    private String currency;
    private Integer totalPages;
    private Integer previewPages;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Integer authorId;
    private Integer categoryId;
    private Integer createdByEmployeeId;
    private Integer updatedByEmployeeId;
    
    // Additional fields for display
    private String authorName;
    private String categoryName;
    private int availableCopies;

    public Book() {
    }

    public Book(int bookId, String title, String summary, String description, String coverUrl, 
                String contentPath, Double price, String currency, Integer totalPages, 
                Integer previewPages, String status, Timestamp createdAt, Timestamp updatedAt,
                Integer authorId, Integer categoryId) {
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

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
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

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public int getAvailableCopies() {
        return availableCopies;
    }

    public void setAvailableCopies(int availableCopies) {
        this.availableCopies = availableCopies;
    }
}

