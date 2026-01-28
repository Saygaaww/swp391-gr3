package controller;

import dao.BookDAO;
import dao.AuthorDAO;
import dao.CategoryDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Book;
import model.Author;
import model.Category;
import util.StringUtil;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * BookController - Enhanced Servlet with Advanced Filtering Support
 * @author FPT Student Team
 */
@WebServlet(name = "BookController", urlPatterns = {"/books", "/books/*"})
public class BookController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(BookController.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Handle book listing: /books or /books/
                handleBookListing(request, response);
                
            } else if (pathInfo.startsWith("/detail/")) {
                // Handle book detail: /books/detail/{id}
                handleBookDetail(request, response, pathInfo);
                
            } else if (pathInfo.startsWith("/category/")) {
                // Handle books by category: /books/category/{id}
                handleBooksByCategory(request, response, pathInfo);
                
            } else if (pathInfo.equals("/latest")) {
                // Handle latest books: /books/latest
                handleLatestBooks(request, response);
                
            } else if (pathInfo.equals("/free")) {
                // Handle free books: /books/free
                handleFreeBooks(request, response);
                
            } else {
                // Path not found
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in BookController", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu. Vui lòng thử lại.");
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/books/list.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Handle book detail requests
     * URL pattern: /books/detail/{bookId}
     */
    private void handleBookDetail(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        
        try {
            // Extract book ID from URL path
            String bookIdStr = pathInfo.substring("/detail/".length());
            int bookId = Integer.parseInt(bookIdStr);
            
            LOGGER.info("Book detail request for ID: " + bookId);
            
            BookDAO bookDAO = new BookDAO();
            
            try {
                // Get book by ID with author and category info
                Book book = bookDAO.getBookById(bookId);
                
                if (book != null) {
                    // Set book data for JSP
                    request.setAttribute("book", book);
                    request.setAttribute("pageTitle", book.getTitle() + " - Thư viện Số FPT");
                    
                    // Forward to detail JSP
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/books/detail.jsp");
                    dispatcher.forward(request, response);
                    
                } else {
                    // Book not found
                    LOGGER.warning("Book not found for ID: " + bookId);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sách không tồn tại");
                }
                
            } finally {
                bookDAO.close();
            }
            
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid book ID format: " + pathInfo);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sách không hợp lệ");
        }
    }
    
    /**
     * Handle book listing with enhanced search and filters
     */
    private void handleBookListing(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get all filter parameters
        String searchTitle = StringUtil.cleanInput(request.getParameter("title"));
        String authorIdStr = StringUtil.cleanInput(request.getParameter("authorId"));
        String categoryIdStr = StringUtil.cleanInput(request.getParameter("categoryId"));
        String minPriceStr = StringUtil.cleanInput(request.getParameter("minPrice"));
        String maxPriceStr = StringUtil.cleanInput(request.getParameter("maxPrice"));
        String keyword = StringUtil.cleanInput(request.getParameter("keyword"));
        
        // NEW: Enhanced filter parameters
        String language = StringUtil.cleanInput(request.getParameter("language"));
        String yearRange = StringUtil.cleanInput(request.getParameter("publicationYear"));
        String priceType = StringUtil.cleanInput(request.getParameter("priceType"));
        String sortBy = StringUtil.cleanInput(request.getParameter("sortBy"));
        
        LOGGER.info("Enhanced book search - keyword: " + keyword + ", language: " + language + ", yearRange: " + yearRange);
        
        BookDAO bookDAO = new BookDAO();
        AuthorDAO authorDAO = new AuthorDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        
        try {
            List<Book> books;
            String searchSummary = "";
            
            // Parse parameters
            Integer selectedAuthorId = parseInteger(authorIdStr);
            Integer selectedCategoryId = parseInteger(categoryIdStr);
            BigDecimal selectedMinPrice = parseBigDecimal(minPriceStr);
            BigDecimal selectedMaxPrice = parseBigDecimal(maxPriceStr);
            
            // Perform search
            if (!StringUtil.isBlank(keyword)) {
                // Keyword search takes precedence
                books = bookDAO.searchByKeyword(keyword);
                searchSummary = buildKeywordSearchSummary(books.size(), keyword);
            } else {
                // Use enhanced filter search
                books = bookDAO.searchBooksAdvanced(searchTitle, selectedAuthorId, selectedCategoryId, 
                                                  selectedMinPrice, selectedMaxPrice, 
                                                  language, yearRange, priceType, sortBy);
                searchSummary = buildAdvancedSearchSummary(books.size(), searchTitle, selectedAuthorId, 
                                                         selectedCategoryId, language, yearRange, priceType);
            }
            
            // Get dropdown options
            List<Author> authors = authorDAO.getAuthorsWithBooks();
            List<Category> categories = categoryDAO.getCategoriesWithBooks();
            
            // Set attributes for JSP
            request.setAttribute("books", books);
            request.setAttribute("authors", authors);
            request.setAttribute("categories", categories);
            request.setAttribute("searchSummary", searchSummary);
            
            // Keep selected values for form
            request.setAttribute("selectedTitle", searchTitle);
            request.setAttribute("selectedAuthorId", selectedAuthorId);
            request.setAttribute("selectedCategoryId", selectedCategoryId);
            request.setAttribute("selectedMinPrice", selectedMinPrice);
            request.setAttribute("selectedMaxPrice", selectedMaxPrice);
            request.setAttribute("selectedKeyword", keyword);
            request.setAttribute("selectedLanguage", language);
            request.setAttribute("selectedYearRange", yearRange);
            request.setAttribute("selectedPriceType", priceType);
            request.setAttribute("selectedSortBy", sortBy != null ? sortBy : "newest");
            
            request.setAttribute("pageTitle", "Tìm kiếm sách - Thư viện Số FPT");
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/books/list.jsp");
            dispatcher.forward(request, response);
            
        } finally {
            bookDAO.close();
            authorDAO.close();
            categoryDAO.close();
        }
    }
    
    /**
     * Handle books by category
     */
    private void handleBooksByCategory(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        
        try {
            String categoryIdStr = pathInfo.substring("/category/".length());
            int categoryId = Integer.parseInt(categoryIdStr);
            
            BookDAO bookDAO = new BookDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            
            try {
                List<Book> books = bookDAO.getBooksByCategory(categoryId);
                Category category = categoryDAO.getCategoryById(categoryId);
                
                String searchSummary = category != null ? 
                    "Hiển thị " + books.size() + " cuốn sách trong thể loại \"" + category.getCategoryName() + "\"" :
                    "Hiển thị " + books.size() + " cuốn sách";
                
                request.setAttribute("books", books);
                request.setAttribute("searchSummary", searchSummary);
                request.setAttribute("pageTitle", 
                    (category != null ? category.getCategoryName() : "Thể loại") + " - Thư viện Số FPT");
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/books/list.jsp");
                dispatcher.forward(request, response);
                
            } finally {
                bookDAO.close();
                categoryDAO.close();
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID thể loại không hợp lệ");
        }
    }
    
    /**
     * Handle latest books
     */
    private void handleLatestBooks(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        BookDAO bookDAO = new BookDAO();
        
        try {
            List<Book> books = bookDAO.getLatestBooks(20);
            request.setAttribute("books", books);
            request.setAttribute("searchSummary", "Hiển thị " + books.size() + " cuốn sách mới nhất");
            request.setAttribute("pageTitle", "Sách mới nhất - Thư viện Số FPT");
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/books/list.jsp");
            dispatcher.forward(request, response);
            
        } finally {
            bookDAO.close();
        }
    }
    
    /**
     * Handle free books
     */
    private void handleFreeBooks(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        BookDAO bookDAO = new BookDAO();
        
        try {
            List<Book> books = bookDAO.getFreeBooks();
            request.setAttribute("books", books);
            request.setAttribute("searchSummary", "Hiển thị " + books.size() + " cuốn sách miễn phí");
            request.setAttribute("pageTitle", "Sách miễn phí - Thư viện Số FPT");
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/books/list.jsp");
            dispatcher.forward(request, response);
            
        } finally {
            bookDAO.close();
        }
    }
    
    // ========== ENHANCED UTILITY METHODS ==========
    
    private Integer parseInteger(String value) {
        if (StringUtil.isBlank(value)) return null;
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
    
    private BigDecimal parseBigDecimal(String value) {
        if (StringUtil.isBlank(value)) return null;
        try {
            return new BigDecimal(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
    
    private String buildKeywordSearchSummary(int count, String keyword) {
        return "Tìm thấy " + count + " cuốn sách với từ khóa \"" + keyword + "\"";
    }
    
    private String buildAdvancedSearchSummary(int count, String title, Integer authorId, 
                                            Integer categoryId, String language, 
                                            String yearRange, String priceType) {
        
        if (StringUtil.isBlank(title) && authorId == null && categoryId == null 
            && StringUtil.isBlank(language) && StringUtil.isBlank(yearRange) 
            && StringUtil.isBlank(priceType)) {
            return "Hiển thị tất cả " + count + " cuốn sách";
        }
        
        StringBuilder summary = new StringBuilder("Tìm thấy " + count + " cuốn sách");
        List<String> criteria = new ArrayList<>();
        
        if (!StringUtil.isBlank(title)) {
            criteria.add("tên chứa \"" + title + "\"");
        }
        
        if (!StringUtil.isBlank(language)) {
            criteria.add("ngôn ngữ " + language);
        }
        
        if (!StringUtil.isBlank(yearRange)) {
            String yearText = getYearRangeText(yearRange);
            criteria.add("xuất bản " + yearText);
        }
        
        if (!StringUtil.isBlank(priceType)) {
            if ("free".equals(priceType)) {
                criteria.add("miễn phí");
            } else if ("paid".equals(priceType)) {
                criteria.add("có phí");
            }
        }
        
        if (!criteria.isEmpty()) {
            summary.append(" với ").append(String.join(", ", criteria));
        }
        
        return summary.toString();
    }
    
    private String getYearRangeText(String yearRange) {
        switch (yearRange) {
            case "2020-2024": return "2020-2024";
            case "2010-2019": return "2010-2019";
            case "2000-2009": return "2000-2009";
            case "1990-1999": return "1990-1999";
            case "1980-1989": return "1980-1989";
            case "before-1980": return "trước 1980";
            default: return yearRange;
        }
    }
    
    // Legacy method for backward compatibility
    private String buildSearchSummary(int count, String title, Integer authorId, 
                                    Integer categoryId, BigDecimal minPrice, BigDecimal maxPrice) {
        if (StringUtil.isBlank(title) && authorId == null && categoryId == null 
            && minPrice == null && maxPrice == null) {
            return "Hiển thị tất cả " + count + " cuốn sách";
        }
        
        return "Tìm thấy " + count + " cuốn sách phù hợp với tiêu chí tìm kiếm";
    }
}