package controller;

import dao.AuthorDAO;
import dao.BookDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Author;
import model.Book;
import util.StringUtil;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


/**
 * AuthorController - Servlet for handling author-related requests
 * @author FPT Student Team
 */
@WebServlet(name = "AuthorController", urlPatterns = {"/authors", "/authors/*"})
public class AuthorController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(AuthorController.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                handleAuthorListing(request, response);
            } else if (pathInfo.startsWith("/detail/")) {
                handleAuthorDetail(request, response, pathInfo);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in AuthorController", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu. Vui lòng thử lại.");
            response.getWriter().println("<h1>Error: " + e.getMessage() + "</h1>");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void handleAuthorListing(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String searchName = StringUtil.cleanInput(request.getParameter("name"));
        String keyword = StringUtil.cleanInput(request.getParameter("keyword"));
        
        LOGGER.info("Author listing - name: " + searchName + ", keyword: " + keyword);
        
        AuthorDAO authorDAO = new AuthorDAO();
        BookDAO bookDAO = new BookDAO();
        
        try {
            List<Author> authors;
            String searchSummary = "";
            
            if (!StringUtil.isBlank(searchName)) {
                authors = authorDAO.searchAuthorsByName(searchName);
                searchSummary = "Tìm thấy " + authors.size() + " tác giả với tên chứa \"" + searchName + "\"";
            } else if (!StringUtil.isBlank(keyword)) {
                authors = authorDAO.searchAuthorsByName(keyword);
                searchSummary = "Tìm thấy " + authors.size() + " tác giả với từ khóa \"" + keyword + "\"";
            } else {
                authors = authorDAO.getAllAuthors();
                searchSummary = "Hiển thị tất cả " + authors.size() + " tác giả";
            }
            
            // Get book count for each author
            for (Author author : authors) {
                List<Book> authorBooks = bookDAO.getBooksByAuthor(author.getAuthorId());
                request.setAttribute("bookCount_" + author.getAuthorId(), authorBooks.size());
            }
            
            request.setAttribute("authors", authors);
            request.setAttribute("searchSummary", searchSummary);
            request.setAttribute("selectedName", searchName);
            request.setAttribute("selectedKeyword", keyword);
            request.setAttribute("pageTitle", "Danh sách tác giả - Thư viện Số FPT");
            request.setAttribute("totalAuthors", authorDAO.getAllAuthors().size());
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/authors/list.jsp");
            dispatcher.forward(request, response);
            
        } finally {
            authorDAO.close();
            bookDAO.close();
        }
    }
    
    private void handleAuthorDetail(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        
        try {
            String authorIdStr = pathInfo.substring("/detail/".length());
            int authorId = Integer.parseInt(authorIdStr);
            
            LOGGER.info("Author detail request for ID: " + authorId);
            
            AuthorDAO authorDAO = new AuthorDAO();
            BookDAO bookDAO = new BookDAO();
            
            try {
                Author author = authorDAO.getAuthorById(authorId);
                
                if (author != null) {
                    List<Book> authorBooks = bookDAO.getBooksByAuthor(authorId);
                    
                    request.setAttribute("author", author);
                    request.setAttribute("authorBooks", authorBooks);
                    request.setAttribute("bookCount", authorBooks.size());
                    request.setAttribute("pageTitle", author.getAuthorName() + " - Thư viện Số FPT");
                    
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/authors/detail.jsp");
                    dispatcher.forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
                
            } finally {
                authorDAO.close();
                bookDAO.close();
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tác giả không hợp lệ");
        }
    }
}