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

@WebServlet("/admin/borrow-approve")
public class AdminBorrowApproveServlet extends HttpServlet {
    
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
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            List<BorrowRequest> pendingRequests = borrowDAO.getPendingRequests();
            
            request.setAttribute("pendingRequests", pendingRequests);
            request.setAttribute("totalRequests", pendingRequests.size());
            request.setAttribute("currentEmployee", session.getAttribute("employee"));
            
            System.out.println("Co " + pendingRequests.size() + " yeu cau muon cho duyet");
            
            request.getRequestDispatcher("/admin/borrow-approve.jsp")
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
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        
        try {
            Employee employee = (Employee) session.getAttribute("employee");
            
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
                success = borrowDAO.approveRequest(requestId, employee.getEmployeeId(), note);
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
}