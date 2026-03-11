package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Book model - Enhanced with Language and PublicationYear
 * 
 * @author FPT Student Team
 */
public class Book {

    private Integer bookId;
    private String title;
    private String summary;
    private String description;
    private String coverUrl;
    private String contentPath;
    private BigDecimal price;
    private String currency;
    private Integer totalPages;
    private Integer previewPages;
    private String status;

    // NEW: Enhanced fields
    private String language;
    private Integer publicationYear;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Foreign key references
    private Integer authorId;
    private Integer categoryId;
    private Integer createdByEmployeeId;
    private Integer updatedByEmployeeId;

    // Related objects (populated by DAO)
    private Author author;
    private Category category;

    // Denormalized display fields (populated by DAO JOINs)
    private String categoryName;
    private String authorName;

    // Constructors
    public Book() {
    }

    public Book(String title, String summary, String description) {
        this.title = title;
        this.summary = summary;
        this.description = description;
    }

    // Getters and Setters
    public Integer getBookId() {
        return bookId;
    }

    public void setBookId(Integer bookId) {
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // NEW: Language getter/setter
    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    // NEW: PublicationYear getter/setter
    public Integer getPublicationYear() {
        return publicationYear;
    }

    public void setPublicationYear(Integer publicationYear) {
        this.publicationYear = publicationYear;
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

    // Business methods
    public boolean isAvailable() {
        return "active".equals(this.status);
    }

    public boolean isFree() {
        return this.price == null || this.price.compareTo(BigDecimal.ZERO) == 0;
    }

    public String getFormattedPrice() {
        if (isFree()) {
            return "Miễn phí";
        }
        if (price != null) {
            return String.format("%,.0f %s", price, currency != null ? currency : "VNĐ");
        }
        return "Chưa có giá";
    }

    // NEW: Helper methods for enhanced fields
    public String getDisplayLanguage() {
        return language != null ? language : "Chưa rõ";
    }

    public String getDisplayPublicationYear() {
        return publicationYear != null ? publicationYear.toString() : "Chưa rõ";
    }

    public boolean isClassic() {
        return publicationYear != null && publicationYear < 1980;
    }

    public boolean isRecent() {
        return publicationYear != null && publicationYear >= 2020;
    }

    // equals and hashCode
    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null || getClass() != obj.getClass())
            return false;
        Book book = (Book) obj;
        return Objects.equals(bookId, book.bookId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(bookId);
    }

    // toString
    @Override
    public String toString() {
        return "Book{" +
                "bookId=" + bookId +
                ", title='" + title + '\'' +
                ", author=" + (author != null ? author.getAuthorName() : "Unknown") +
                ", category=" + (category != null ? category.getCategoryName() : "Unknown") +
                ", language='" + language + '\'' +
                ", publicationYear=" + publicationYear +
                ", price=" + price +
                ", status='" + status + '\'' +
                '}';
    }
}