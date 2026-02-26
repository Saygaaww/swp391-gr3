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
    private static final int DEFAULT_PAGE_SIZE = 5;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        System.out.println("AdminBookListServlet initialized");
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
            int pageSize = DEFAULT_PAGE_SIZE;
            String pageSizeStr = request.getParameter("pageSize");
            if (pageSizeStr != null && !pageSizeStr.trim().isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeStr);

                    if (pageSize != 5 && pageSize != 10) {
                        pageSize = DEFAULT_PAGE_SIZE;
                    }
                } catch (NumberFormatException e) {
                    pageSize = DEFAULT_PAGE_SIZE;
                }
            }
            
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
            
            String keyword = request.getParameter("keyword");
            
            List<Book> bookList;
            int totalBooks;
            int totalPages;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                keyword = keyword.trim().replaceAll("\\s+", " ");
                
                bookList = bookDAO.searchBooks(keyword);
                totalBooks = bookList.size();
                
                totalPages = (int) Math.ceil((double) totalBooks / pageSize);
                if (totalPages < 1) totalPages = 1;
                if (currentPage > totalPages) currentPage = totalPages;
                
                int fromIndex = (currentPage - 1) * pageSize;
                int toIndex = Math.min(fromIndex + pageSize, totalBooks);
                
                if (fromIndex < totalBooks) {
                    bookList = bookList.subList(fromIndex, toIndex);
                } else {
                    bookList = bookList.subList(0, Math.min(pageSize, totalBooks));
                }
                
                request.setAttribute("keyword", keyword);
                
            } else {
                totalBooks = bookDAO.getTotalBooks();
                totalPages = (int) Math.ceil((double) totalBooks / pageSize);
                if (totalPages < 1) totalPages = 1;
                if (currentPage > totalPages) currentPage = totalPages;
                
                bookList = bookDAO.getBooksByPage(currentPage, pageSize);
            }
            
            request.setAttribute("bookList", bookList);
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("currentEmployee", employee);
            
            request.getRequestDispatcher("/admin/book-list.jsp").forward(request, response);
                   
        } catch (Exception e) {
            System.err.println("AdminBookListServlet Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Loi: " + e.getMessage());
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
        String pageSize = request.getParameter("pageSize");
        
        String redirectUrl = request.getContextPath() + "/books-list";
        StringBuilder params = new StringBuilder();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            keyword = keyword.trim().replaceAll("\\s+", " ");
            try {
                String encodedKeyword = URLEncoder.encode(keyword, "UTF-8");
                params.append("keyword=").append(encodedKeyword);
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }
        
        if (pageSize != null && !pageSize.trim().isEmpty()) {
            if (params.length() > 0) params.append("&");
            params.append("pageSize=").append(pageSize);
        }
        
        if (params.length() > 0) {
            redirectUrl += "?" + params.toString();
        }
        
        response.sendRedirect(redirectUrl);
    }
}