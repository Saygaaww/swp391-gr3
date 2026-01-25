package model;

public class Author {
    private int authorId;
    private String authorName;
    private String bio;

    public Author() {
    }

    public Author(int authorId, String authorName, String bio) {
        this.authorId = authorId;
        this.authorName = authorName;
        this.bio = bio;
    }

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
}

