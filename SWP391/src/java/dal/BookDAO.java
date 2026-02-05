package dal;

import model.Book;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class BookDAO extends DBContext {
    
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, a.author_name, c.category_name, " +
                     "COUNT(CASE WHEN bc.status = 'available' THEN 1 END) as available_copies " +
                     "FROM Book b " +
                     "LEFT JOIN Author a ON b.author_id = a.author_id " +
                     "LEFT JOIN Category c ON b.category_id = c.category_id " +
                     "LEFT JOIN BookCopy bc ON b.book_id = bc.book_id " +
                     "WHERE b.status = 'active' " +
                     "GROUP BY b.book_id, b.title, b.summary, b.description, b.cover_url, " +
                     "b.content_path, b.price, b.currency, b.total_pages, b.preview_pages, " +
                     "b.status, b.created_at, b.updated_at, b.author_id, b.category_id, " +
                     "b.created_by_employee_id, b.updated_by_employee_id, a.author_name, c.category_name " +
                     "ORDER BY b.created_at DESC";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setSummary(rs.getString("summary"));
                book.setDescription(rs.getString("description"));
                book.setCoverUrl(rs.getString("cover_url"));
                book.setContentPath(rs.getString("content_path"));
                book.setPrice(rs.getDouble("price"));
                book.setCurrency(rs.getString("currency"));
                book.setTotalPages(rs.getInt("total_pages"));
                book.setPreviewPages(rs.getInt("preview_pages"));
                book.setStatus(rs.getString("status"));
                Timestamp createdAt = rs.getTimestamp("created_at");
                Timestamp updatedAt = rs.getTimestamp("updated_at");
                book.setCreatedAt(createdAt != null ? new Date(createdAt.getTime()) : null);
                book.setUpdatedAt(updatedAt != null ? new Date(updatedAt.getTime()) : null);
                book.setAuthorId(rs.getInt("author_id"));
                book.setCategoryId(rs.getInt("category_id"));
                book.setAuthorName(rs.getString("author_name"));
                book.setCategoryName(rs.getString("category_name"));
                book.setAvailableCopies(rs.getInt("available_copies"));
                
                books.add(book);
            }
        } catch (SQLException e) {
            System.out.println("Error getting all books: " + e.getMessage());
        }
        
        return books;
    }
    
    public Book getBookById(int bookId) {
        String sql = "SELECT b.*, a.author_name, c.category_name, " +
                     "COUNT(CASE WHEN bc.status = 'available' THEN 1 END) as available_copies " +
                     "FROM Book b " +
                     "LEFT JOIN Author a ON b.author_id = a.author_id " +
                     "LEFT JOIN Category c ON b.category_id = c.category_id " +
                     "LEFT JOIN BookCopy bc ON b.book_id = bc.book_id " +
                     "WHERE b.book_id = ? " +
                     "GROUP BY b.book_id, b.title, b.summary, b.description, b.cover_url, " +
                     "b.content_path, b.price, b.currency, b.total_pages, b.preview_pages, " +
                     "b.status, b.created_at, b.updated_at, b.author_id, b.category_id, " +
                     "b.created_by_employee_id, b.updated_by_employee_id, a.author_name, c.category_name";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setSummary(rs.getString("summary"));
                book.setDescription(rs.getString("description"));
                book.setCoverUrl(rs.getString("cover_url"));
                book.setContentPath(rs.getString("content_path"));
                book.setPrice(rs.getDouble("price"));
                book.setCurrency(rs.getString("currency"));
                book.setTotalPages(rs.getInt("total_pages"));
                book.setPreviewPages(rs.getInt("preview_pages"));
                book.setStatus(rs.getString("status"));
                Timestamp createdAt = rs.getTimestamp("created_at");
                Timestamp updatedAt = rs.getTimestamp("updated_at");
                book.setCreatedAt(createdAt != null ? new Date(createdAt.getTime()) : null);
                book.setUpdatedAt(updatedAt != null ? new Date(updatedAt.getTime()) : null);
                book.setAuthorId(rs.getInt("author_id"));
                book.setCategoryId(rs.getInt("category_id"));
                book.setAuthorName(rs.getString("author_name"));
                book.setCategoryName(rs.getString("category_name"));
                book.setAvailableCopies(rs.getInt("available_copies"));
                
                return book;
            }
        } catch (SQLException e) {
            System.out.println("Error getting book by id: " + e.getMessage());
        }
        
        return null;
    }
    
    public List<Book> searchBooks(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.*, a.author_name, c.category_name, " +
                     "COUNT(CASE WHEN bc.status = 'available' THEN 1 END) as available_copies " +
                     "FROM Book b " +
                     "LEFT JOIN Author a ON b.author_id = a.author_id " +
                     "LEFT JOIN Category c ON b.category_id = c.category_id " +
                     "LEFT JOIN BookCopy bc ON b.book_id = bc.book_id " +
                     "WHERE b.status = 'active' " +
                     "AND (b.title LIKE ? OR a.author_name LIKE ? OR c.category_name LIKE ?) " +
                     "GROUP BY b.book_id, b.title, b.summary, b.description, b.cover_url, " +
                     "b.content_path, b.price, b.currency, b.total_pages, b.preview_pages, " +
                     "b.status, b.created_at, b.updated_at, b.author_id, b.category_id, " +
                     "b.created_by_employee_id, b.updated_by_employee_id, a.author_name, c.category_name " +
                     "ORDER BY b.created_at DESC";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Book book = new Book();
                book.setBookId(rs.getInt("book_id"));
                book.setTitle(rs.getString("title"));
                book.setSummary(rs.getString("summary"));
                book.setDescription(rs.getString("description"));
                book.setCoverUrl(rs.getString("cover_url"));
                book.setContentPath(rs.getString("content_path"));
                book.setPrice(rs.getDouble("price"));
                book.setCurrency(rs.getString("currency"));
                book.setTotalPages(rs.getInt("total_pages"));
                book.setPreviewPages(rs.getInt("preview_pages"));
                book.setStatus(rs.getString("status"));
                Timestamp createdAt = rs.getTimestamp("created_at");
                Timestamp updatedAt = rs.getTimestamp("updated_at");
                book.setCreatedAt(createdAt != null ? new Date(createdAt.getTime()) : null);
                book.setUpdatedAt(updatedAt != null ? new Date(updatedAt.getTime()) : null);
                book.setAuthorId(rs.getInt("author_id"));
                book.setCategoryId(rs.getInt("category_id"));
                book.setAuthorName(rs.getString("author_name"));
                book.setCategoryName(rs.getString("category_name"));
                book.setAvailableCopies(rs.getInt("available_copies"));
                
                books.add(book);
            }
        } catch (SQLException e) {
            System.out.println("Error searching books: " + e.getMessage());
        }
        
        return books;
    }
}

