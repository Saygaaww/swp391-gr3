package model;

import java.util.ArrayList;
import java.util.List;

/**
 * Category Model - Simplified version without JPA
 * @author FPT Student Team
 */
public class Category {
    
    private Integer categoryId;
    private String categoryName;
    private String description;
    
    // Related books (will be set by DAO if needed)
    private List<Book> books = new ArrayList<>();
    
    // Constructors
    public Category() {
    }
    
    public Category(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public Category(String categoryName, String description) {
        this.categoryName = categoryName;
        this.description = description;
    }
    
    // Getters and Setters
    public Integer getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public List<Book> getBooks() {
        return books;
    }
    
    public void setBooks(List<Book> books) {
        this.books = books;
    }
    
    // Business Methods
    public void addBook(Book book) {
        books.add(book);
        book.setCategory(this);
    }
    
    public void removeBook(Book book) {
        books.remove(book);
        book.setCategory(null);
    }
    
    public int getBookCount() {
        return books != null ? books.size() : 0;
    }
    
    @Override
    public String toString() {
        return "Category{" +
                "categoryId=" + categoryId +
                ", categoryName='" + categoryName + '\'' +
                ", bookCount=" + getBookCount() +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Category)) return false;
        Category category = (Category) o;
        return categoryId != null && categoryId.equals(category.categoryId);
    }
    
    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}