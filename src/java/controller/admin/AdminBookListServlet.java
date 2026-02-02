package controller.admin;

import dal.BookDAO;
import model.Book;
import model.Employee;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/books-list")
public class AdminBookListServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    private static final int PAGE_SIZE = 5;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }
        
        Employee employee = (Employee) session.getAttribute("employee");
        request.setCharacterEncoding("UTF-8");
        
        try {
            // Lấy page
            int currentPage = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // Lấy keyword
            String keyword = request.getParameter("keyword");
            
            List<Book> bookList;
            int totalBooks;
            int totalPages;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                // CÓ TÌM KIẾM
                keyword = keyword.trim();
                totalBooks = bookDAO.countBooksByKeyword(keyword);
                totalPages = (int) Math.ceil((double) totalBooks / PAGE_SIZE);
                if (totalPages < 1) totalPages = 1;
                if (currentPage > totalPages) currentPage = totalPages;
                
                bookList = bookDAO.searchBooksByPage(keyword, currentPage, PAGE_SIZE);
                request.setAttribute("keyword", keyword);
            } else {
                // KHÔNG TÌM KIẾM
                totalBooks = bookDAO.getTotalBooks();
                totalPages = (int) Math.ceil((double) totalBooks / PAGE_SIZE);
                if (totalPages < 1) totalPages = 1;
                if (currentPage > totalPages) currentPage = totalPages;
                
                bookList = bookDAO.getBooksByPage(currentPage, PAGE_SIZE);
            }
            
            request.setAttribute("bookList", bookList);
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", PAGE_SIZE);
            request.setAttribute("currentEmployee", employee);
            
            request.getRequestDispatcher("/admin/book-list.jsp").forward(request, response);
                   
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/admin/book-list.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        String keyword = request.getParameter("keyword");
        
        String redirectUrl = request.getContextPath() + "/books-list";
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            try {
                String encodedKeyword = URLEncoder.encode(keyword.trim(), "UTF-8");
                redirectUrl += "?keyword=" + encodedKeyword;
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect(redirectUrl);
    }
}