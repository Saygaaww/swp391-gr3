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

/**
 * Servlet duyệt yêu cầu mượn sách
 * @author Member E - Dũng
 */
@WebServlet("/admin/borrow-approve")
public class AdminBorrowApproveServlet extends HttpServlet {
    
    private BorrowDAO borrowDAO;
    
    @Override
    public void init() throws ServletException {
        borrowDAO = new BorrowDAO();
    }
    
    /**
     * GET - Hiển thị danh sách yêu cầu chờ duyệt
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }
        
        try {
            // Lấy danh sách yêu cầu chờ duyệt
            List<BorrowRequest> pendingRequests = borrowDAO.getPendingRequests();
            
            request.setAttribute("pendingRequests", pendingRequests);
            request.setAttribute("totalRequests", pendingRequests.size());
            request.setAttribute("currentEmployee", session.getAttribute("employee"));
            
            System.out.println("📋 Có " + pendingRequests.size() + " yêu cầu mượn chờ duyệt");
            
            request.getRequestDispatcher("/admin/borrow-approve.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
    
    /**
     * POST - Xử lý duyệt/từ chối yêu cầu
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
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
                success = borrowDAO.approveRequest(requestId, employee.getEmployeeId(), note);
                if (success) {
                    System.out.println("✅ Đã duyệt yêu cầu ID: " + requestId);
                }
            } else if ("reject".equals(action)) {
                success = borrowDAO.rejectRequest(requestId, employee.getEmployeeId(), note);
                if (success) {
                    System.out.println("❌ Đã từ chối yêu cầu ID: " + requestId);
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/borrow-approve");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/borrow-approve");
        }
    }
}