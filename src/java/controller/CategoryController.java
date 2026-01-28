package controller;

import dao.CategoryDAO;
import dao.BookDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Book;
import util.StringUtil;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;


/**
 * CategoryController - Servlet for handling category-related requests
 * @author FPT Student Team
 */
@WebServlet(name = "CategoryController", urlPatterns = {"/categories", "/categories/*"})
public class CategoryController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(CategoryController.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                handleCategoryListing(request, response);
            } else if (pathInfo.startsWith("/detail/")) {
                handleCategoryDetail(request, response, pathInfo);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in CategoryController", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu. Vui lòng thử lại.");
            response.getWriter().println("<h1>Error: " + e.getMessage() + "</h1>");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void handleCategoryListing(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String searchName = StringUtil.cleanInput(request.getParameter("name"));
        String keyword = StringUtil.cleanInput(request.getParameter("keyword"));
        String sortBy = StringUtil.cleanInput(request.getParameter("sort"));
        
        CategoryDAO categoryDAO = new CategoryDAO();
        
        try {
            List<Category> categories;
            String searchSummary = "";
            
            if (!StringUtil.isBlank(searchName)) {
                categories = categoryDAO.searchCategoriesByName(searchName);
                searchSummary = "Tìm thấy " + categories.size() + " thể loại với tên chứa \"" + searchName + "\"";
            } else if (!StringUtil.isBlank(keyword)) {
                categories = categoryDAO.searchCategoriesByName(keyword);
                searchSummary = "Tìm thấy " + categories.size() + " thể loại với từ khóa \"" + keyword + "\"";
            } else if ("popular".equals(sortBy)) {
                categories = categoryDAO.getTopCategoriesByBookCount(50);
                searchSummary = "Hiển thị các thể loại phổ biến nhất";
            } else {
                categories = categoryDAO.getAllCategories();
                searchSummary = "Hiển thị tất cả " + categories.size() + " thể loại";
            }
            
            // Get book count for each category
            for (Category category : categories) {
                int bookCount = categoryDAO.countBooksByCategory(category.getCategoryId());
                request.setAttribute("bookCount_" + category.getCategoryId(), bookCount);
            }
            
            request.setAttribute("categories", categories);
            request.setAttribute("searchSummary", searchSummary);
            request.setAttribute("selectedName", searchName);
            request.setAttribute("selectedKeyword", keyword);
            request.setAttribute("selectedSort", sortBy);
            request.setAttribute("pageTitle", "Danh sách thể loại - Thư viện Số FPT");
            request.setAttribute("totalCategories", categoryDAO.getAllCategories().size());
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/categories/list.jsp");
            dispatcher.forward(request, response);
            
        } finally {
            categoryDAO.close();
        }
    }
    
    private void handleCategoryDetail(HttpServletRequest request, HttpServletResponse response, String pathInfo) 
            throws ServletException, IOException {
        
        try {
            String categoryIdStr = pathInfo.substring("/detail/".length());
            int categoryId = Integer.parseInt(categoryIdStr);
            
            CategoryDAO categoryDAO = new CategoryDAO();
            BookDAO bookDAO = new BookDAO();
            
            try {
                Category category = categoryDAO.getCategoryById(categoryId);
                
                if (category != null) {
                    List<Book> categoryBooks = bookDAO.getBooksByCategory(categoryId);
                    
                    request.setAttribute("category", category);
                    request.setAttribute("categoryBooks", categoryBooks);
                    request.setAttribute("totalBooks", categoryBooks.size());
                    request.setAttribute("pageTitle", category.getCategoryName() + " - Thư viện Số FPT");
                    
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/categories/detail.jsp");
                    dispatcher.forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
                
            } finally {
                categoryDAO.close();
                bookDAO.close();
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID thể loại không hợp lệ");
        }
    }
}