package model;

/**
 * Model class đại diện cho tác giả
 * Mapping với bảng authors trong database
 * @author Member E - Dũng
 */
public class Author {
    private int authorId;
    private String authorName;
    private String biography;
    
    // Constructor rỗng
    public Author() {
    }
    
    // Constructor đầy đủ
    public Author(int authorId, String authorName, String biography) {
        this.authorId = authorId;
        this.authorName = authorName;
        this.biography = biography;
    }
    
    // Constructor không có ID (dùng khi thêm mới)
    public Author(String authorName, String biography) {
        this.authorName = authorName;
        this.biography = biography;
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
    
    public String getBiography() {
        return biography;
    }
    
    public void setBiography(String biography) {
        this.biography = biography;
    }
    
    // toString() - Dùng để debug, in ra thông tin
    @Override
    public String toString() {
        return "Author{" +
                "authorId=" + authorId +
                ", authorName='" + authorName + '\'' +
                ", biography='" + biography + '\'' +
                '}';
    }
}
