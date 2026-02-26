package controller.admin;

import dal.ReaderDAO;
import model.Reader;
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

@WebServlet("/admin/readers")
public class AdminReaderListServlet extends HttpServlet {
    
    private ReaderDAO readerDAO;
    private static final int PAGE_SIZE = 10;
    
    @Override
    public void init() throws ServletException {
        readerDAO = new ReaderDAO();
        System.out.println("AdminReaderListServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }
        
        Employee currentEmployee = (Employee) session.getAttribute("employee");
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        
        if (action != null && idStr != null) {
            try {
                int readerId;
                try {
                    readerId = Integer.parseInt(idStr.trim());
                } catch (NumberFormatException e) {
                    System.err.println("Invalid reader ID format: " + idStr);
                    readerId = -1;
                }
                
                if (readerId > 0 && readerId <= 999999999) {
                    Reader reader = readerDAO.getReaderById(readerId);
                    
                    if (reader != null) {
                        if ("block".equals(action)) {
                            readerDAO.updateReaderStatus(readerId, "blocked");
                            System.out.println("Blocked reader ID: " + readerId);
                        } else if ("unblock".equals(action)) {
                            readerDAO.updateReaderStatus(readerId, "active");
                            System.out.println("Unblocked reader ID: " + readerId);
                        }
                    } else {
                        System.err.println("Reader not found: " + readerId);
                    }
                } else {
                    System.err.println("Reader ID out of range: " + idStr);
                }
                
            } catch (Exception e) {
                System.err.println("Error processing action: " + e.getMessage());
            }
        }
        
        try {
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
            
            List<Reader> readerList;
            int totalReaders;
            int totalPages;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                keyword = keyword.trim().replaceAll("\\s+", " ");
                totalReaders = readerDAO.countReadersByKeyword(keyword);
                totalPages = (int) Math.ceil((double) totalReaders / PAGE_SIZE);
                if (totalPages < 1) totalPages = 1;
                if (currentPage > totalPages) currentPage = totalPages;
                
                readerList = readerDAO.searchReadersByPage(keyword, currentPage, PAGE_SIZE);
                request.setAttribute("keyword", keyword);
            } else {
                totalReaders = readerDAO.getTotalReaders();
                totalPages = (int) Math.ceil((double) totalReaders / PAGE_SIZE);
                if (totalPages < 1) totalPages = 1;
                if (currentPage > totalPages) currentPage = totalPages;
                
                readerList = readerDAO.getReadersByPage(currentPage, PAGE_SIZE);
            }
            
            int activeCount = readerDAO.countReadersByStatus("active");
            int blockedCount = readerDAO.countReadersByStatus("blocked");
            int inactiveCount = readerDAO.countReadersByStatus("inactive");
            
            request.setAttribute("readerList", readerList);
            request.setAttribute("totalReaders", totalReaders);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", PAGE_SIZE);
            request.setAttribute("currentEmployee", currentEmployee);
            request.setAttribute("activeCount", activeCount);
            request.setAttribute("blockedCount", blockedCount);
            request.setAttribute("inactiveCount", inactiveCount);
            
            request.getRequestDispatcher("/admin/reader-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Loi: " + e.getMessage());
            request.getRequestDispatcher("/admin/reader-list.jsp").forward(request, response);
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
        String redirectUrl = request.getContextPath() + "/admin/readers";
        
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