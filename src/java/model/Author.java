package model;

import java.util.ArrayList;
import java.util.List;

/**
 * Author Model - Simplified version without JPA
 * @author FPT Student Team
 */
public class Author {
    
    private Integer authorId;
    private String authorName;
    private String bio;
    
    // Related books (will be set by DAO if needed)
    private List<Book> books = new ArrayList<>();
    
    // Constructors
    public Author() {
    }
    
    public Author(String authorName) {
        this.authorName = authorName;
    }
    
    public Author(String authorName, String bio) {
        this.authorName = authorName;
        this.bio = bio;
    }
    
    // Getters and Setters
    public Integer getAuthorId() {
        return authorId;
    }
    
    public void setAuthorId(Integer authorId) {
        this.authorId = authorId;
    }
    
    public String getAuthorName() {
        return authorName;
    }
    
    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }
    
    public String getBio() {
        return bio;
    }
    
    public void setBio(String bio) {
        this.bio = bio;
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
        book.setAuthor(this);
    }
    
    public void removeBook(Book book) {
        books.remove(book);
        book.setAuthor(null);
    }
    
    public int getBookCount() {
        return books != null ? books.size() : 0;
    }
    
    @Override
    public String toString() {
        return "Author{" +
                "authorId=" + authorId +
                ", authorName='" + authorName + '\'' +
                ", bookCount=" + getBookCount() +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Author)) return false;
        Author author = (Author) o;
        return authorId != null && authorId.equals(author.authorId);
    }
    
    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}