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
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Employee currentEmployee = (Employee) session.getAttribute("employee");
        if (!"ADMIN".equalsIgnoreCase(currentEmployee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        try {
            List<Role> roleList = roleDAO.getAllRoles();
            for (Role role : roleList) {
                role.setEmployeeCount(employeeDAO.countEmployeesByRole(role.getRoleId()));
            }

            request.setAttribute("roleList", roleList);
            request.setAttribute("currentEmployee", currentEmployee);
            request.getRequestDispatcher("/admin/role-list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Loi: " + e.getMessage());
            request.getRequestDispatcher("/admin/role-list.jsp").forward(request, response);
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

        Employee currentEmployee = (Employee) session.getAttribute("employee");
        if (!"ADMIN".equalsIgnoreCase(currentEmployee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String roleName = request.getParameter("roleName");
                String description = request.getParameter("description");

                if (roleName != null && !roleName.trim().isEmpty() && roleName.trim().length() <= 50) {
                    roleDAO.addRole(new Role(roleName.trim().toUpperCase(), description));
                }

            } else if ("edit".equals(action)) {
                int roleId = parseId(request.getParameter("roleId"));
                String roleName = request.getParameter("roleName");
                String description = request.getParameter("description");

                if (roleId > 0 && roleName != null && roleDAO.getRoleById(roleId) != null) {
                    Role role = new Role();
                    role.setRoleId(roleId);
                    role.setRoleName(roleName.trim().toUpperCase());
                    role.setDescription(description);
                    roleDAO.updateRole(role);
                }

            } else if ("delete".equals(action)) {
                int roleId = parseId(request.getParameter("roleId"));

                if (roleId > 0 && roleDAO.getRoleById(roleId) != null) {
                    int count = employeeDAO.countEmployeesByRole(roleId);
                    if (count > 0) {
                        request.setAttribute("errorMessage",
                            "Khong the xoa vai tro dang co " + count + " nhan vien!");
                    } else {
                        roleDAO.deleteRole(roleId);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/roles");
    }

    // Parse ID an toan, tra ve 0 neu loi
    private int parseId(String str) {
        if (str == null || str.trim().isEmpty()) return 0;
        try {
            int id = Integer.parseInt(str.trim());
            return (id > 0 && id <= 999999999) ? id : 0;
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}