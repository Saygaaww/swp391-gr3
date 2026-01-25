package controller;

import dal.BookDAO;
import model.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class BookServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listBooks(request, response);
                break;
            case "detail":
                showBookDetail(request, response);
                break;
            case "search":
                searchBooks(request, response);
                break;
            default:
                listBooks(request, response);
                break;
        }
    }
    
    private void listBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Book> books = bookDAO.getAllBooks();
        request.setAttribute("books", books);
        request.getRequestDispatcher("/view/reader/book.jsp").forward(request, response);
    }
    
    private void showBookDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bookIdStr = request.getParameter("id");
        if (bookIdStr == null || bookIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Book ID is required");
            return;
        }
        
        try {
            int bookId = Integer.parseInt(bookIdStr);
            Book book = bookDAO.getBookById(bookId);
            
            if (book == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Book not found");
                return;
            }
            
            request.setAttribute("book", book);
            request.getRequestDispatcher("/view/reader/book-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Book ID");
        }
    }
    
    private void searchBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            listBooks(request, response);
            return;
        }
        
        List<Book> books = bookDAO.searchBooks(keyword.trim());
        request.setAttribute("books", books);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/view/reader/book.jsp").forward(request, response);
    }
}

