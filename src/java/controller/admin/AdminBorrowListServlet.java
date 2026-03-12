package controller.admin;

import dal.BorrowDAO;
import model.BorrowRequest;
import model.Employee;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/borrow-list")
public class AdminBorrowListServlet extends HttpServlet {
    
    private BorrowDAO borrowDAO;
    private static final int DEFAULT_PAGE_SIZE = 10;
    
    @Override
    public void init() throws ServletException {
        borrowDAO = new BorrowDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        
        try {
            // Page size
            int pageSize = DEFAULT_PAGE_SIZE;
            boolean showAll = false;
            String pageSizeStr = request.getParameter("pageSize");
            if (pageSizeStr != null && !pageSizeStr.trim().isEmpty()) {
                if (pageSizeStr.equals("all")) {
                    showAll = true;
                    pageSize = Integer.MAX_VALUE;
                } else {
                    try {
                        pageSize = Integer.parseInt(pageSizeStr);
                        if (pageSize != 5 && pageSize != 10 && pageSize != 20) {
                            pageSize = DEFAULT_PAGE_SIZE;
                        }
                    } catch (NumberFormatException e) {
                        pageSize = DEFAULT_PAGE_SIZE;
                    }
                }
            }

            // Lay trang hien tai
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
            
            // Lay tu khoa tim kiem
            String keyword = request.getParameter("keyword");
            if (keyword != null) {
                keyword = keyword.trim();
                if (keyword.isEmpty()) keyword = null;
            }
            
            // Lay bo loc trang thai
            String statusFilter = request.getParameter("status");
            if (statusFilter != null && statusFilter.trim().isEmpty()) {
                statusFilter = null;
            }
            
            // Truy van
            int totalRequests = borrowDAO.countRequestsFiltered(keyword, statusFilter);
            int totalPages = (int) Math.ceil((double) totalRequests / pageSize);
            if (totalPages < 1) totalPages = 1;
            if (currentPage > totalPages) currentPage = totalPages;
            
            List<BorrowRequest> requestList = borrowDAO.getRequestsFiltered(
                keyword, statusFilter, currentPage, pageSize);
            
            // Thong ke theo trang thai
            int countPending = borrowDAO.countByStatus("pending");
            int countApproved = borrowDAO.countByStatus("approved");
            int countRejected = borrowDAO.countByStatus("rejected");
            
            // Truyen du lieu sang JSP
            request.setAttribute("requestList", requestList);
            request.setAttribute("totalRequests", totalRequests);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("keyword", keyword);
            request.setAttribute("filterStatus", statusFilter);
            request.setAttribute("countPending", countPending);
            request.setAttribute("countApproved", countApproved);
            request.setAttribute("countRejected", countRejected);
            request.setAttribute("currentEmployee", session.getAttribute("user"));
            request.setAttribute("pageSize", showAll ? "all" : String.valueOf(pageSize));
            
            request.getRequestDispatcher("/WEB-INF/jsp/admin/borrow-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("AdminBorrowListServlet Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
}
