package controller;

import dao.EmployeeDAO;
import dao.RoleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Employee;
import model.Role;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "CreateEmployeeAccountsServlet", urlPatterns = {"/create-employee-accounts"})
public class CreateEmployeeAccountsServlet extends HttpServlet {
    
    private EmployeeDAO employeeDAO;
    private RoleDAO roleDAO;
    
    @Override
    public void init() throws ServletException {
        employeeDAO = new EmployeeDAO();
        roleDAO = new RoleDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html lang='vi'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>Tạo Tài Khoản Employee</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5; }");
        out.println(".container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        out.println("h1 { color: #6366f1; }");
        out.println(".success { color: #10b981; padding: 10px; background: #d1fae5; border-radius: 5px; margin: 10px 0; }");
        out.println(".error { color: #ef4444; padding: 10px; background: #fee2e2; border-radius: 5px; margin: 10px 0; }");
        out.println(".info { color: #6b7280; padding: 10px; background: #f3f4f6; border-radius: 5px; margin: 10px 0; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        out.println("<h1>Tạo Tài Khoản Employee</h1>");
        
        try {
            // Lấy các role
            Role adminRole = roleDAO.getRoleByName("ADMIN");
            Role librarianRole = roleDAO.getRoleByName("LIBRARIAN");
            Role sellerRole = roleDAO.getRoleByName("SELLER");
            
            if (adminRole == null || librarianRole == null || sellerRole == null) {
                out.println("<div class='error'>Lỗi: Các role chưa được tạo trong database. Vui lòng chạy database_setup.sql trước.</div>");
                out.println("</div></body></html>");
                return;
            }
            
            int createdCount = 0;
            int existingCount = 0;
            
            // Tạo ADMIN account
            Employee admin = employeeDAO.getEmployeeByEmail("admin@digitallibrary.com");
            if (admin == null) {
                admin = employeeDAO.createEmployee("Quản Trị Viên", "admin@digitallibrary.com", "admin123", adminRole.getRoleId());
                if (admin != null) {
                    out.println("<div class='success'>✓ Đã tạo tài khoản ADMIN: admin@digitallibrary.com (password: admin123)</div>");
                    createdCount++;
                } else {
                    out.println("<div class='error'>✗ Không thể tạo tài khoản ADMIN</div>");
                }
            } else {
                out.println("<div class='info'>- Tài khoản ADMIN đã tồn tại: admin@digitallibrary.com</div>");
                existingCount++;
            }
            
            // Tạo LIBRARIAN account
            Employee librarian = employeeDAO.getEmployeeByEmail("librarian@digitallibrary.com");
            if (librarian == null) {
                librarian = employeeDAO.createEmployee("Thủ Thư", "librarian@digitallibrary.com", "librarian123", librarianRole.getRoleId());
                if (librarian != null) {
                    out.println("<div class='success'>✓ Đã tạo tài khoản LIBRARIAN: librarian@digitallibrary.com (password: librarian123)</div>");
                    createdCount++;
                } else {
                    out.println("<div class='error'>✗ Không thể tạo tài khoản LIBRARIAN</div>");
                }
            } else {
                out.println("<div class='info'>- Tài khoản LIBRARIAN đã tồn tại: librarian@digitallibrary.com</div>");
                existingCount++;
            }
            
            // Tạo SELLER account
            Employee seller = employeeDAO.getEmployeeByEmail("seller@digitallibrary.com");
            if (seller == null) {
                seller = employeeDAO.createEmployee("Người Bán", "seller@digitallibrary.com", "seller123", sellerRole.getRoleId());
                if (seller != null) {
                    out.println("<div class='success'>✓ Đã tạo tài khoản SELLER: seller@digitallibrary.com (password: seller123)</div>");
                    createdCount++;
                } else {
                    out.println("<div class='error'>✗ Không thể tạo tài khoản SELLER</div>");
                }
            } else {
                out.println("<div class='info'>- Tài khoản SELLER đã tồn tại: seller@digitallibrary.com</div>");
                existingCount++;
            }
            
            out.println("<hr style='margin: 20px 0;'>");
            out.println("<div class='info'><strong>Tổng kết:</strong>");
            out.println("<br>Đã tạo mới: " + createdCount + " tài khoản");
            out.println("<br>Đã tồn tại: " + existingCount + " tài khoản");
            out.println("</div>");
            
            out.println("<hr style='margin: 20px 0;'>");
            out.println("<h3>Thông tin đăng nhập:</h3>");
            out.println("<table style='width: 100%; border-collapse: collapse;'>");
            out.println("<tr style='background: #f3f4f6;'><th style='padding: 10px; text-align: left; border: 1px solid #e5e7eb;'>Role</th><th style='padding: 10px; text-align: left; border: 1px solid #e5e7eb;'>Email</th><th style='padding: 10px; text-align: left; border: 1px solid #e5e7eb;'>Password</th></tr>");
            out.println("<tr><td style='padding: 10px; border: 1px solid #e5e7eb;'>ADMIN</td><td style='padding: 10px; border: 1px solid #e5e7eb;'>admin@digitallibrary.com</td><td style='padding: 10px; border: 1px solid #e5e7eb;'>admin123</td></tr>");
            out.println("<tr><td style='padding: 10px; border: 1px solid #e5e7eb;'>LIBRARIAN</td><td style='padding: 10px; border: 1px solid #e5e7eb;'>librarian@digitallibrary.com</td><td style='padding: 10px; border: 1px solid #e5e7eb;'>librarian123</td></tr>");
            out.println("<tr><td style='padding: 10px; border: 1px solid #e5e7eb;'>SELLER</td><td style='padding: 10px; border: 1px solid #e5e7eb;'>seller@digitallibrary.com</td><td style='padding: 10px; border: 1px solid #e5e7eb;'>seller123</td></tr>");
            out.println("</table>");
            
            out.println("<p style='margin-top: 20px; color: #6b7280;'><strong>Lưu ý:</strong> Các tài khoản này được tạo trong bảng Employee. Bạn cần tích hợp Employee vào hệ thống đăng nhập nếu muốn sử dụng.</p>");
            
        } catch (Exception e) {
            out.println("<div class='error'>Lỗi: " + e.getMessage() + "</div>");
            e.printStackTrace();
        }
        
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
}
