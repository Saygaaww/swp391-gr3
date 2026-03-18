package controller.admin;

import dal.BorrowDAO;
import model.BorrowRequest;
import model.Employee;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/borrow-approve")
public class AdminBorrowApproveServlet extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 10;
    
    private BorrowDAO borrowDAO;
    
    @Override
    public void init() throws ServletException {
        borrowDAO = new BorrowDAO();
        System.out.println("AdminBorrowApproveServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String keyword = normalize(request.getParameter("keyword"));
        int page = parsePositiveInt(request.getParameter("page"), 1);
        int pageSize = parsePageSize(request.getParameter("pageSize"));
        
        try {
            int totalRequests = borrowDAO.countRequestsFiltered(keyword, "pending");
            int totalPages = Math.max(1, (int) Math.ceil((double) totalRequests / pageSize));
            if (page > totalPages) {
                page = totalPages;
            }

            List<BorrowRequest> pendingRequests;
            if (totalRequests > 0) {
                pendingRequests = borrowDAO.getRequestsFiltered(keyword, "pending", page, pageSize);
            } else {
                pendingRequests = new ArrayList<>();
            }
            
            request.setAttribute("pendingRequests", pendingRequests);
            request.setAttribute("totalRequests", totalRequests);
            request.setAttribute("keyword", keyword);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", String.valueOf(pageSize));
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentEmployee", session.getAttribute("user"));
            
            System.out.println("Co " + totalRequests + " yeu cau muon cho duyet");
            
            request.getRequestDispatcher("/jsp/admin/borrow-approve.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            System.err.println("Error in doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        
        try {
            Employee employee = (Employee) session.getAttribute("user");
            
            String requestIdStr = request.getParameter("requestId");
            String action = request.getParameter("action");
            String note = request.getParameter("note");
            
            if (requestIdStr == null || action == null) {
                response.sendRedirect(request.getContextPath() + "/admin/borrow-approve");
                return;
            }
            
            int requestId = Integer.parseInt(requestIdStr);
            boolean success = false;
            
            if ("approve".equals(action)) {
                // Duyet yeu cau
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                java.time.LocalDate startDate = java.time.LocalDate.now();
                java.time.LocalDate endDate = startDate.plusDays(7);
                try {
                    if (startDateStr != null && !startDateStr.isBlank()) {
                        startDate = java.time.LocalDate.parse(startDateStr);
                    }
                    if (endDateStr != null && !endDateStr.isBlank()) {
                        endDate = java.time.LocalDate.parse(endDateStr);
                    }
                } catch (java.time.format.DateTimeParseException e) {
                    System.err.println("Invalid date format: " + e.getMessage());
                }
                success = borrowDAO.approveRequest(requestId, employee.getEmployeeId(), note, startDate, endDate);
                if (success) {
                    System.out.println("Da duyet yeu cau ID: " + requestId);
                }
            } else if ("reject".equals(action)) {
                success = borrowDAO.rejectRequest(requestId, employee.getEmployeeId(), note);
                if (success) {
                    System.out.println("Da tu choi yeu cau ID: " + requestId);
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/borrow-approve");
            
        } catch (NumberFormatException e) {
            System.err.println("Error: Invalid request ID");
            response.sendRedirect(request.getContextPath() + "/admin/borrow-approve");
        } catch (Exception e) {
            System.err.println("Error in doPost: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/borrow-approve");
        }
    }

    private String normalize(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private int parsePositiveInt(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            int parsed = Integer.parseInt(value.trim());
            return parsed > 0 ? parsed : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private int parsePageSize(String value) {
        int parsed = parsePositiveInt(value, DEFAULT_PAGE_SIZE);
        return (parsed == 5 || parsed == 10 || parsed == 20 || parsed == 50) ? parsed : DEFAULT_PAGE_SIZE;
    }
}
