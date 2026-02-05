package controller.admin;

import dal.EmployeeDAO;
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

@WebServlet("/admin/employees")
public class AdminEmployeeListServlet extends HttpServlet {
    
    private EmployeeDAO employeeDAO;
    private static final int PAGE_SIZE = 5;
    
    @Override
    public void init() throws ServletException {
        employeeDAO = new EmployeeDAO();
        System.out.println("AdminEmployeeListServlet initialized");
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
                int empId = Integer.parseInt(idStr);
                
                if (empId == currentEmployee.getEmployeeId()) {
                    System.err.println("Khong the tu khoa chinh minh!");
                    request.setAttribute("errorMessage", "Bạn không thể khóa chính mình!");
                } 
                else {
                    Employee targetEmployee = employeeDAO.getEmployeeById(empId);
                    
                    if (targetEmployee != null && "ADMIN".equalsIgnoreCase(targetEmployee.getRoleName())) {
                        System.err.println("Khong the khoa tai khoan ADMIN!");
                        request.setAttribute("errorMessage", "Không thể khóa tài khoản ADMIN!");
                    } else {
                        if ("block".equals(action)) {
                            employeeDAO.updateEmployeeStatus(empId, "blocked");
                            System.out.println("Blocked employee ID: " + empId);
                        } else if ("unblock".equals(action)) {
                            employeeDAO.updateEmployeeStatus(empId, "active");
                            System.out.println("Unblocked employee ID: " + empId);
                        }
                    }
                }
                
            } catch (NumberFormatException e) {
                System.err.println("Invalid employee ID: " + idStr);
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
            
            List<Employee> employeeList;
            int totalEmployees;
            int totalPages;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                keyword = keyword.trim();
                totalEmployees = employeeDAO.countEmployeesByKeyword(keyword);
                totalPages = (int) Math.ceil((double) totalEmployees / PAGE_SIZE);
                if (totalPages < 1) totalPages = 1;
                if (currentPage > totalPages) currentPage = totalPages;
                
                employeeList = employeeDAO.searchEmployeesByPage(keyword, currentPage, PAGE_SIZE);
                request.setAttribute("keyword", keyword);
            } else {
                totalEmployees = employeeDAO.getTotalEmployees();
                totalPages = (int) Math.ceil((double) totalEmployees / PAGE_SIZE);
                if (totalPages < 1) totalPages = 1;
                if (currentPage > totalPages) currentPage = totalPages;
                
                employeeList = employeeDAO.getEmployeesByPage(currentPage, PAGE_SIZE);
            }
            
            request.setAttribute("employeeList", employeeList);
            request.setAttribute("totalEmployees", totalEmployees);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", PAGE_SIZE);
            request.setAttribute("currentEmployee", currentEmployee);
            
            request.getRequestDispatcher("/admin/employee-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/admin/employee-list.jsp").forward(request, response);
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
        
        String redirectUrl = request.getContextPath() + "/admin/employees";
        
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