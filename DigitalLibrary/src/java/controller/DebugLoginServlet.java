package controller;

import dao.EmployeeDAO;
import dao.ReaderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Employee;
import model.Reader;
import utils.PasswordUtil;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "DebugLoginServlet", urlPatterns = {"/debug-login"})
public class DebugLoginServlet extends HttpServlet {
    
    private ReaderDAO readerDAO;
    private EmployeeDAO employeeDAO;
    
    @Override
    public void init() throws ServletException {
        readerDAO = new ReaderDAO();
        employeeDAO = new EmployeeDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email == null || password == null) {
            email = "admin@digitallibrary.com";
            password = "admin123";
        }
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><meta charset='UTF-8'><title>Debug Login</title>");
        out.println("<style>body{font-family:Arial;padding:20px;} .info{background:#e3f2fd;padding:10px;margin:10px 0;border-left:4px solid #2196f3;} .error{background:#ffebee;padding:10px;margin:10px 0;border-left:4px solid #f44336;} .success{background:#e8f5e9;padding:10px;margin:10px 0;border-left:4px solid #4caf50;} pre{background:#f5f5f5;padding:10px;overflow:auto;}</style>");
        out.println("</head><body>");
        out.println("<h1>Debug Login Information</h1>");
        out.println("<div class='info'><strong>Email:</strong> " + email + "<br><strong>Password:</strong> " + password + "</div>");
        
        try {
            // Kiểm tra Reader
            out.println("<h2>Checking Reader Table:</h2>");
            Reader reader = readerDAO.getReaderByEmail(email);
            if (reader != null) {
                out.println("<div class='success'>✓ Reader found in database</div>");
                out.println("<pre>");
                out.println("Reader ID: " + reader.getReaderId());
                out.println("Full Name: " + reader.getFullName());
                out.println("Email: " + reader.getEmail());
                out.println("Status: " + reader.getStatus());
                out.println("Role ID: " + reader.getRoleId());
                if (reader.getRole() != null) {
                    out.println("Role Name: " + reader.getRole().getRoleName());
                }
                out.println("Password Hash in DB: " + reader.getPasswordHash());
                out.println("</pre>");
                
                // Test password verification
                boolean readerAuth = readerDAO.authenticate(email, password);
                out.println("<div class='" + (readerAuth ? "success" : "error") + "'>");
                out.println("Password Verification: " + (readerAuth ? "✓ PASS" : "✗ FAIL"));
                out.println("</div>");
                
                // Show expected hash
                String expectedHash = PasswordUtil.hashPassword(password);
                out.println("<div class='info'>");
                out.println("<strong>Expected Hash for '" + password + "':</strong><br>");
                out.println("<pre>" + expectedHash + "</pre>");
                out.println("</div>");
            } else {
                out.println("<div class='error'>✗ Reader NOT found in database</div>");
            }
            
            // Kiểm tra Employee
            out.println("<h2>Checking Employee Table:</h2>");
            Employee employee = employeeDAO.getEmployeeByEmail(email);
            if (employee != null) {
                out.println("<div class='success'>✓ Employee found in database</div>");
                out.println("<pre>");
                out.println("Employee ID: " + employee.getEmployeeId());
                out.println("Full Name: " + employee.getFullName());
                out.println("Email: " + employee.getEmail());
                out.println("Status: " + employee.getStatus());
                out.println("Role ID: " + employee.getRoleId());
                if (employee.getRole() != null) {
                    out.println("Role Name: " + employee.getRole().getRoleName());
                }
                out.println("Password Hash in DB: " + employee.getPasswordHash());
                out.println("</pre>");
                
                // Test password verification
                boolean employeeAuth = employeeDAO.authenticate(email, password);
                out.println("<div class='" + (employeeAuth ? "success" : "error") + "'>");
                out.println("Password Verification: " + (employeeAuth ? "✓ PASS" : "✗ FAIL"));
                out.println("</div>");
                
                // Show expected hash
                String expectedHash = PasswordUtil.hashPassword(password);
                out.println("<div class='info'>");
                out.println("<strong>Expected Hash for '" + password + "':</strong><br>");
                out.println("<pre>" + expectedHash + "</pre>");
                out.println("</div>");
            } else {
                out.println("<div class='error'>✗ Employee NOT found in database</div>");
            }
            
            // Summary
            out.println("<h2>Summary:</h2>");
            if (reader == null && employee == null) {
                out.println("<div class='error'><strong>❌ Account not found!</strong><br>");
                out.println("Email '" + email + "' does not exist in Reader or Employee table.<br>");
                out.println("Please create the account first using: <a href='/DigitalLibrary/create-employee-accounts'>/create-employee-accounts</a></div>");
            } else {
                boolean readerValid = reader != null && readerDAO.authenticate(email, password);
                boolean employeeValid = employee != null && employeeDAO.authenticate(email, password);
                
                if (readerValid || employeeValid) {
                    out.println("<div class='success'><strong>✓ Authentication should work!</strong><br>");
                    if (readerValid) {
                        out.println("Reader authentication: PASS<br>");
                    }
                    if (employeeValid) {
                        out.println("Employee authentication: PASS</div>");
                    }
                } else {
                    out.println("<div class='error'><strong>❌ Password mismatch!</strong><br>");
                    out.println("Account exists but password is incorrect.<br>");
                    out.println("Please check the password hash in database matches the expected hash above.</div>");
                }
            }
            
        } catch (Exception e) {
            out.println("<div class='error'><strong>Error:</strong> " + e.getMessage() + "</div>");
            e.printStackTrace(new java.io.PrintWriter(out));
        }
        
        out.println("<hr>");
        out.println("<p><a href='/DigitalLibrary/login'>Back to Login</a> | ");
        out.println("<a href='/DigitalLibrary/create-employee-accounts'>Create Employee Accounts</a></p>");
        out.println("</body></html>");
    }
}
