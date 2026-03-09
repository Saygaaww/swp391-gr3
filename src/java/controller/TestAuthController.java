package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.AuthUtil;

import java.io.IOException;
import java.util.logging.Logger;

/**
 * TestAuthController - Temporary servlet for testing authorization
 * REMOVE THIS FILE AFTER INTEGRATING WITH REAL LOGIN SYSTEM
 * 
 * @author FPT Student Team
 */
@WebServlet(name = "TestAuthController", urlPatterns = {"/test-auth"})
public class TestAuthController extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(TestAuthController.class.getName());
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String role = request.getParameter("role");
        String employeeIdStr = request.getParameter("employeeId");
        
        if ("login".equals(action)) {
            // Set test session
            jakarta.servlet.http.HttpSession session = request.getSession();
            
            // Set role (default: Librarian)
            String testRole = role != null ? role : "Librarian";
            session.setAttribute(AuthUtil.SESSION_USER_ROLE, testRole);
            session.setAttribute(AuthUtil.SESSION_USER_ID, 1);
            
            // Set employee ID
            int employeeId = 1;
            if (employeeIdStr != null) {
                try {
                    employeeId = Integer.parseInt(employeeIdStr);
                } catch (NumberFormatException e) {
                    employeeId = 1;
                }
            }
            session.setAttribute(AuthUtil.SESSION_EMPLOYEE_ID, employeeId);
            session.setAttribute(AuthUtil.SESSION_USER, "Test User");
            
            LOGGER.info("Test login: Role = " + testRole + ", EmployeeID = " + employeeId);
            
            // Redirect to requested URL or authors page
            String redirectURL = request.getParameter("redirect");
            if (redirectURL != null && !redirectURL.isEmpty()) {
                response.sendRedirect(redirectURL);
            } else {
                response.sendRedirect(request.getContextPath() + "/authors");
            }
            
        } else if ("logout".equals(action)) {
            // Clear session
            jakarta.servlet.http.HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            
            LOGGER.info("Test logout");
            response.sendRedirect(request.getContextPath() + "/authors");
            
        } else {
            // Show test page
            showTestPage(request, response);
        }
    }
    
    private void showTestPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        String currentRole = session != null ? 
            (String) session.getAttribute(AuthUtil.SESSION_USER_ROLE) : null;
        Integer currentEmployeeId = session != null ? 
            AuthUtil.getEmployeeId(request) : null;
        
        response.setContentType("text/html;charset=UTF-8");
        java.io.PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html lang='vi'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>Test Authorization - Thư viện Số FPT</title>");
        out.println("<link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css'>");
        out.println("<style>");
        out.println("body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 2rem; background: #f5f5f5; }");
        out.println(".container { max-width: 800px; margin: 0 auto; background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        out.println("h1 { color: #667eea; margin-bottom: 1rem; }");
        out.println(".info-box { background: #e2e8f0; padding: 1rem; border-radius: 8px; margin-bottom: 2rem; }");
        out.println(".info-box strong { color: #2d3748; }");
        out.println(".role-buttons { display: flex; gap: 1rem; flex-wrap: wrap; margin-bottom: 2rem; }");
        out.println(".btn { padding: 0.75rem 1.5rem; border: none; border-radius: 8px; cursor: pointer; text-decoration: none; display: inline-block; font-weight: 600; transition: all 0.2s; }");
        out.println(".btn-librarian { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }");
        out.println(".btn-seller { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; }");
        out.println(".btn-customer { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; }");
        out.println(".btn-logout { background: #e53e3e; color: white; }");
        out.println(".btn-test { background: #48bb78; color: white; }");
        out.println(".btn:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(0,0,0,0.15); }");
        out.println(".test-links { margin-top: 2rem; padding-top: 2rem; border-top: 2px solid #e2e8f0; }");
        out.println(".test-links a { display: block; padding: 0.75rem; margin: 0.5rem 0; background: #f7fafc; border-left: 4px solid #667eea; text-decoration: none; color: #2d3748; border-radius: 4px; }");
        out.println(".test-links a:hover { background: #edf2f7; }");
        out.println(".warning { background: #fff5f5; border-left: 4px solid #e53e3e; padding: 1rem; margin-top: 2rem; border-radius: 4px; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<h1><i class='fas fa-shield-alt'></i> Test Authorization System</h1>");
        
        if (currentRole != null) {
            out.println("<div class='info-box'>");
            out.println("<strong>Current Session:</strong><br>");
            out.println("Role: <strong>" + currentRole + "</strong><br>");
            out.println("Employee ID: <strong>" + (currentEmployeeId != null ? currentEmployeeId : "N/A") + "</strong>");
            out.println("</div>");
        } else {
            out.println("<div class='info-box'>");
            out.println("<strong>Status:</strong> Not logged in");
            out.println("</div>");
        }
        
        out.println("<h2>Set Test Role:</h2>");
        out.println("<div class='role-buttons'>");
        out.println("<a href='?action=login&role=Librarian' class='btn btn-librarian'>");
        out.println("<i class='fas fa-user-shield'></i> Login as Librarian");
        out.println("</a>");
        out.println("<a href='?action=login&role=Seller' class='btn btn-seller'>");
        out.println("<i class='fas fa-user-tag'></i> Login as Seller");
        out.println("</a>");
        out.println("<a href='?action=login&role=Customer' class='btn btn-customer'>");
        out.println("<i class='fas fa-user'></i> Login as Customer");
        out.println("</a>");
        if (currentRole != null) {
            out.println("<a href='?action=logout' class='btn btn-logout'>");
            out.println("<i class='fas fa-sign-out-alt'></i> Logout");
            out.println("</a>");
        }
        out.println("</div>");
        
        out.println("<div class='test-links'>");
        out.println("<h2>Test Protected Pages:</h2>");
        out.println("<a href='" + request.getContextPath() + "/authors'><i class='fas fa-list'></i> Authors List (Public)</a>");
        out.println("<a href='" + request.getContextPath() + "/authors/create'><i class='fas fa-plus'></i> Create Author (Protected - Need Librarian/Seller)</a>");
        out.println("<a href='" + request.getContextPath() + "/authors/edit/1'><i class='fas fa-edit'></i> Edit Author (Protected - Need Librarian/Seller)</a>");
        out.println("</div>");
        
        out.println("<div class='warning'>");
        out.println("<strong><i class='fas fa-exclamation-triangle'></i> Warning:</strong> ");
        out.println("This is a test servlet. Remove this file after integrating with real login system!");
        out.println("</div>");
        
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
}
