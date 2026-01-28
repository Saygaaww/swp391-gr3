package controller.admin;

import dal.BookDAO;
import dal.AuthorDAO;
import dal.CategoryDAO;
import dal.BorrowDAO;
import model.Employee;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet Dashboard Admin - Tổng quan hệ thống
 * @author Member E - Dũng
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    private AuthorDAO authorDAO;
    private CategoryDAO categoryDAO;
    private BorrowDAO borrowDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        authorDAO = new AuthorDAO();
        categoryDAO = new CategoryDAO();
        borrowDAO = new BorrowDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }
        
        Employee employee = (Employee) session.getAttribute("employee");
        
        try {
            // Lấy thống kê
            int totalBooks = bookDAO.getTotalBooks();
            int totalAuthors = authorDAO.getTotalAuthors();
            int totalCategories = categoryDAO.getTotalCategories();
            int pendingBorrowRequests = borrowDAO.getPendingRequestsCount();
            int activeBorrows = borrowDAO.getActiveBorrowsCount();
            
            // Gửi dữ liệu sang JSP
            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("totalAuthors", totalAuthors);
            request.setAttribute("totalCategories", totalCategories);
            request.setAttribute("pendingBorrowRequests", pendingBorrowRequests);
            request.setAttribute("activeBorrows", activeBorrows);
            request.setAttribute("currentEmployee", employee);
            
            System.out.println("📊 Dashboard - Books: " + totalBooks + 
                             ", Authors: " + totalAuthors + 
                             ", Categories: " + totalCategories);
            
            request.getRequestDispatcher("/admin/dashboard.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải dashboard: " + e.getMessage());
            request.getRequestDispatcher("/admin/dashboard.jsp")
                   .forward(request, response);
        }
    }
}