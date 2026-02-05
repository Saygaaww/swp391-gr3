package controller.admin;

import dal.RoleDAO;
import dal.EmployeeDAO;
import model.Role;
import model.Employee;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/roles")
public class AdminRoleListServlet extends HttpServlet {
    
    private RoleDAO roleDAO;
    private EmployeeDAO employeeDAO;
    
    @Override
    public void init() throws ServletException {
        roleDAO = new RoleDAO();
        employeeDAO = new EmployeeDAO();
        System.out.println("AdminRoleListServlet initialized");
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
        
        if (!"ADMIN".equalsIgnoreCase(currentEmployee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=unauthorized");
            return;
        }
        
        try {
            List<Role> roleList = roleDAO.getAllRoles();
            
            for (Role role : roleList) {
                int count = employeeDAO.countEmployeesByRole(role.getRoleId());
                role.setEmployeeCount(count);
            }
            
            request.setAttribute("roleList", roleList);
            request.setAttribute("currentEmployee", currentEmployee);
            
            request.getRequestDispatcher("/admin/role-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("AdminRoleListServlet.doGet Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            request.getRequestDispatcher("/admin/role-list.jsp").forward(request, response);
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
        
        Employee currentEmployee = (Employee) session.getAttribute("employee");
        
        if (!"ADMIN".equalsIgnoreCase(currentEmployee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=unauthorized");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        try {
            if ("add".equals(action)) {
                String roleName = request.getParameter("roleName");
                String description = request.getParameter("description");
                
                if (roleName != null && !roleName.trim().isEmpty()) {
                    Role role = new Role(roleName.trim().toUpperCase(), description);
                    boolean success = roleDAO.addRole(role);
                    
                    if (success) {
                        System.out.println("Role added: " + roleName);
                    } else {
                        System.err.println("Failed to add role: " + roleName);
                    }
                }
                
            } else if ("edit".equals(action)) {
                String roleIdStr = request.getParameter("roleId");
                String roleName = request.getParameter("roleName");
                String description = request.getParameter("description");
                
                if (roleIdStr != null && roleName != null) {
                    int roleId = Integer.parseInt(roleIdStr);
                    Role role = new Role();
                    role.setRoleId(roleId);
                    role.setRoleName(roleName.trim().toUpperCase());
                    role.setDescription(description);
                    
                    boolean success = roleDAO.updateRole(role);
                    
                    if (success) {
                        System.out.println("Role updated: " + roleName);
                    }
                }
                
            } else if ("delete".equals(action)) {
                String roleIdStr = request.getParameter("roleId");
                
                if (roleIdStr != null) {
                    int roleId = Integer.parseInt(roleIdStr);
                    
                    int count = employeeDAO.countEmployeesByRole(roleId);
                    
                    if (count > 0) {
                        System.err.println("Cannot delete role with " + count + " employees");
                        request.setAttribute("errorMessage", 
                            "Không thể xóa vai trò đang có " + count + " nhân viên!");
                    } else {
                        boolean success = roleDAO.deleteRole(roleId);
                        
                        if (success) {
                            System.out.println("Role deleted: " + roleId);
                        }
                    }
                }
            }
            
        } catch (Exception e) {
            System.err.println("AdminRoleListServlet.doPost Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/roles");
    }
}