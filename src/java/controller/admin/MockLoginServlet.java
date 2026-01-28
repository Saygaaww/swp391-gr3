package controller.admin;

import model.Employee;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * MOCK LOGIN - CHỈ DÙNG CHO INTER 1
 * XÓA KHI GHÉP VỚI LOGIN THẬT (Member A)
 * @author Member E - Dũng
 */
@WebServlet("/mock-login")
public class MockLoginServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("employee") != null) {
            // ✅ FIX: Chuyển đến SERVLET, không phải JSP
            response.sendRedirect(request.getContextPath() + "/books-list");
            return;
        }
        
        request.getRequestDispatcher("/mock-login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String role = request.getParameter("role");
        HttpSession session = request.getSession();
        
        Employee mockEmployee = new Employee();
        mockEmployee.setStatus("active");
        
        switch (role) {
            case "admin":
                mockEmployee.setEmployeeId(1);
                mockEmployee.setFullName("Admin Test");
                mockEmployee.setEmail("admin@test.com");
                mockEmployee.setRoleId(1);
                mockEmployee.setRoleName("ADMIN");
                break;
                
            case "librarian":
                mockEmployee.setEmployeeId(2);
                mockEmployee.setFullName("Librarian Test");
                mockEmployee.setEmail("librarian@test.com");
                mockEmployee.setRoleId(2);
                mockEmployee.setRoleName("LIBRARIAN");
                break;
                
            case "seller":
                mockEmployee.setEmployeeId(3);
                mockEmployee.setFullName("Seller Test");
                mockEmployee.setEmail("seller@test.com");
                mockEmployee.setRoleId(3);
                mockEmployee.setRoleName("SELLER");
                break;
                
            default:
                mockEmployee.setEmployeeId(1);
                mockEmployee.setFullName("Admin Test");
                mockEmployee.setEmail("admin@test.com");
                mockEmployee.setRoleId(1);
                mockEmployee.setRoleName("ADMIN");
        }
        
        session.setAttribute("employee", mockEmployee);
        session.setAttribute("employeeRole", role);
        session.setAttribute("employeeName", mockEmployee.getFullName());
        
        System.out.println("=================================");
        System.out.println("✅ MOCK LOGIN THÀNH CÔNG");
        System.out.println("Role: " + mockEmployee.getRoleName());
        System.out.println("Name: " + mockEmployee.getFullName());
        System.out.println("=================================");
        
        // ✅ FIX: Chuyển đến SERVLET /books-list
        response.sendRedirect(request.getContextPath() + "/books-list");
    }
}