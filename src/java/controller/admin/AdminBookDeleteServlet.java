package controller.admin;

import dal.BookDAO;
import model.Book;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/book-delete")
public class AdminBookDeleteServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        System.out.println("AdminBookDeleteServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }
        
        try {
            String idStr = request.getParameter("id");
            
            if (idStr == null || idStr.trim().isEmpty()) {
                System.err.println("Book ID is empty");
                response.sendRedirect(request.getContextPath() + "/books-list");
                return;
            }
            
            int bookId;
            try {
                bookId = Integer.parseInt(idStr.trim());
            } catch (NumberFormatException e) {
                System.err.println("Invalid book ID format: " + idStr);
                response.sendRedirect(request.getContextPath() + "/books-list");
                return;
            }
            
            if (bookId <= 0 || bookId > 999999999) {
                System.err.println("Book ID out of range: " + bookId);
                response.sendRedirect(request.getContextPath() + "/books-list");
                return;
            }
            
            Book book = bookDAO.getBookById(bookId);
            if (book == null) {
                System.err.println("Book not found: " + bookId);
                response.sendRedirect(request.getContextPath() + "/books-list");
                return;
            }
            
            boolean success = bookDAO.deleteBook(bookId);
            
            if (success) {
                System.out.println("Deleted book ID: " + bookId + " - Title: " + book.getTitle());
            } else {
                System.err.println("Failed to delete book ID: " + bookId);
            }
            
            response.sendRedirect(request.getContextPath() + "/books-list");
            
        } catch (Exception e) {
            System.err.println("Error in doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/books-list");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}