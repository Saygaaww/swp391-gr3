package dao;

import model.Author;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AuthorDAO {

    public List<Author> getAllAuthors() {
        List<Author> authors = new ArrayList<>();
        String sql = "SELECT * FROM Author ORDER BY author_name";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                authors.add(mapAuthor(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return authors;
    }

    public Author getAuthorById(int authorId) {
        String sql = "SELECT * FROM Author WHERE author_id = ?";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, authorId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapAuthor(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int createAuthor(Author author) {
        String sql = "INSERT INTO Author(author_name, bio) VALUES (?, ?)";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, author.getAuthorName());
            ps.setString(2, author.getBio());

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateAuthor(Author author) {
        String sql = "UPDATE Author SET author_name = ?, bio = ? WHERE author_id = ?";

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, author.getAuthorName());
            ps.setString(2, author.getBio());
            ps.setInt(3, author.getAuthorId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Author mapAuthor(ResultSet rs) throws SQLException {
        Author author = new Author();
        author.setAuthorId(rs.getInt("author_id"));
        author.setAuthorName(rs.getString("author_name"));
        author.setBio(rs.getString("bio"));
        return author;
    }
}
