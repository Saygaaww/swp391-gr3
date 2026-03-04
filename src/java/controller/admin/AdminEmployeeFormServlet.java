package controller.admin;

import dal.EmployeeDAO;
import dal.RoleDAO;
import model.Employee;
import model.Role;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/employee-form")
public class AdminEmployeeFormServlet extends HttpServlet {
    
    private EmployeeDAO employeeDAO;
    private RoleDAO roleDAO;
    
    @Override
    public void init() throws ServletException {
        employeeDAO = new EmployeeDAO();
        roleDAO = new RoleDAO();
        System.out.println("AdminEmployeeFormServlet initialized");
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
        
        try {
            List<Role> roles = roleDAO.getAllRoles();
            request.setAttribute("roles", roles);
            
            String idStr = request.getParameter("id");
            
             if (idStr != null && !idStr.trim().isEmpty()) {
                int empId = Integer.parseInt(idStr);
                
                if (empId <= 0 || empId > 999999999) {
                    System.err.println("Employee ID out of range: " + empId);
                    response.sendRedirect(request.getContextPath() + "/admin/employees");
                    return;
                }
                
                Employee employee = employeeDAO.getEmployeeById(empId);
                
                if (employee != null) {
                    request.setAttribute("mode", "edit");
                    request.setAttribute("employee", employee);
                    System.out.println("Edit mode: Employee ID " + empId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/employees");
                    return;
                }
                
            } else {
                request.setAttribute("mode", "add");
                request.setAttribute("employee", new Employee());
                System.out.println("Add mode: New Employee");
            }
            
            request.setAttribute("currentEmployee", currentEmployee);
            request.getRequestDispatcher("/admin/employee-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid employee ID");
            response.sendRedirect(request.getContextPath() + "/admin/employees");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/admin/employee-form.jsp").forward(request, response);
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
        
        try {
            String employeeIdStr = request.getParameter("employeeId");
            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String status = request.getParameter("status");
            String roleIdStr = request.getParameter("roleId");
            
            boolean isEdit = (employeeIdStr != null && !employeeIdStr.trim().isEmpty());
            
            if (fullName == null || fullName.trim().isEmpty()) {
                reloadFormWithError(request, response, "Họ tên không được để trống!", isEdit, employeeIdStr);
                return;
            }
            
            if (email == null || email.trim().isEmpty()) {
                reloadFormWithError(request, response, "Email không được để trống!", isEdit, employeeIdStr);
                return;
            }
            
            if (isEdit) {
                int empId = Integer.parseInt(employeeIdStr);
                if (employeeDAO.isEmailExistsExcept(email, empId)) {
                    reloadFormWithError(request, response, "Email đã tồn tại!", isEdit, employeeIdStr);
                    return;
                }
            } else {
                if (employeeDAO.isEmailExists(email)) {
                    reloadFormWithError(request, response, "Email đã tồn tại!", isEdit, employeeIdStr);
                    return;
                }
                
                if (password == null || password.trim().isEmpty()) {
                    reloadFormWithError(request, response, "Mật khẩu không được để trống!", isEdit, employeeIdStr);
                    return;
                }
            }
            
            Employee employee = new Employee();
            employee.setFullName(fullName.trim());
            employee.setEmail(email.trim());
            employee.setStatus(status != null ? status : "active");
            
            if (roleIdStr != null && !roleIdStr.trim().isEmpty()) {
                employee.setRoleId(Integer.parseInt(roleIdStr));
            }
            
            boolean success;
            
            if (isEdit) {
                employee.setEmployeeId(Integer.parseInt(employeeIdStr));
                success = employeeDAO.updateEmployee(employee);
                
                if (password != null && !password.trim().isEmpty()) {
                    employeeDAO.updateEmployeePassword(employee.getEmployeeId(), password);
                }
                
                System.out.println(success ? "Cập nhật nhân viên thành công" : "Cập nhật thất bại");
                
            } else {
                employee.setPasswordHash(password);
                success = employeeDAO.addEmployee(employee);
                
                System.out.println(success ? "Thêm nhân viên thành công" : "Thêm thất bại");
            }
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/employees");
            } else {
                reloadFormWithError(request, response, "Thao tác thất bại. Vui lòng thử lại!", isEdit, employeeIdStr);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/admin/employee-form.jsp").forward(request, response);
        }
    }
    
    private void reloadFormWithError(HttpServletRequest request, HttpServletResponse response,
                                     String errorMessage, boolean isEdit, String employeeIdStr)
            throws ServletException, IOException {
        
        request.setAttribute("errorMessage", errorMessage);
        request.setAttribute("roles", roleDAO.getAllRoles());
        
        if (isEdit && employeeIdStr != null) {
            request.setAttribute("mode", "edit");
            Employee existingEmployee = employeeDAO.getEmployeeById(Integer.parseInt(employeeIdStr));
            request.setAttribute("employee", existingEmployee);
        } else {
            request.setAttribute("mode", "add");
            
            Employee emp = new Employee();
            emp.setFullName(request.getParameter("fullName"));
            emp.setEmail(request.getParameter("email"));
            emp.setStatus(request.getParameter("status"));
            String roleIdStr = request.getParameter("roleId");
            if (roleIdStr != null && !roleIdStr.isEmpty()) {
                emp.setRoleId(Integer.parseInt(roleIdStr));
            }
            request.setAttribute("employee", emp);
        }
        
        request.getRequestDispatcher("/admin/employee-form.jsp").forward(request, response);
    }
}