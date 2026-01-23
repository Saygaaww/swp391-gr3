package model;

/**
 * Model class đại diện cho tác giả
 * Mapping với bảng Author trong database
 */
public class Author {
    private int authorId;
    private String authorName;
    private String bio; // Đổi từ biography → bio
    
    // Constructor rỗng
    public Author() {
    }
    
    // Constructor đầy đủ
    public Author(int authorId, String authorName, String bio) {
        this.authorId = authorId;
        this.authorName = authorName;
        this.bio = bio;
    }
    
    // Constructor không có ID (dùng khi thêm mới)
    public Author(String authorName, String bio) {
        this.authorName = authorName;
        this.bio = bio;
    }
    
    // Getters và Setters
    public int getAuthorId() {
        return authorId;
    }
    
    public void setAuthorId(int authorId) {
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
    
    @Override
    public String toString() {
        return "Author{" +
                "authorId=" + authorId +
                ", authorName='" + authorName + '\'' +
                ", bio='" + bio + '\'' +
                '}';
    }
}