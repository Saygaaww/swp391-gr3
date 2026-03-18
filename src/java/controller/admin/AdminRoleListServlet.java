package controller.admin;

import dal.RoleDAO;
import dal.EmployeeDAO;
import model.Role;
import model.Employee;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/roles")
public class AdminRoleListServlet extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 10;

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
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Employee currentEmployee = (Employee) session.getAttribute("user");
        if (!"ADMIN".equalsIgnoreCase(currentEmployee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }

        try {
            String keyword = request.getParameter("keyword");
            if (keyword != null) {
                keyword = keyword.trim();
                if (keyword.isEmpty()) {
                    keyword = null;
                }
            }

            int page = parsePositiveInt(request.getParameter("page"), 1);
            int pageSize = parsePageSize(request.getParameter("pageSize"));

            List<Role> roleList = roleDAO.getAllRoles();
            for (Role role : roleList) {
                role.setEmployeeCount(employeeDAO.countEmployeesByRole(role.getRoleId()));
            }

            List<Role> filtered = new ArrayList<>();
            for (Role role : roleList) {
                if (keyword == null) {
                    filtered.add(role);
                } else {
                    String kw = keyword.toLowerCase();
                    String roleName = role.getRoleName() != null ? role.getRoleName().toLowerCase() : "";
                    String description = role.getDescription() != null ? role.getDescription().toLowerCase() : "";
                    if (roleName.contains(kw) || description.contains(kw)
                            || String.valueOf(role.getRoleId()).contains(kw)) {
                        filtered.add(role);
                    }
                }
            }

            int totalItems = filtered.size();
            int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
            if (page > totalPages) {
                page = totalPages;
            }

            int fromIndex = (page - 1) * pageSize;
            int toIndex = Math.min(fromIndex + pageSize, totalItems);
            List<Role> pageItems = fromIndex < toIndex ? filtered.subList(fromIndex, toIndex) : new ArrayList<>();

            request.setAttribute("roleList", pageItems);
            request.setAttribute("currentEmployee", currentEmployee);
            request.setAttribute("keyword", keyword);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", String.valueOf(pageSize));
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.getRequestDispatcher("/jsp/admin/role-list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Loi: " + e.getMessage());
            request.getRequestDispatcher("/jsp/admin/role-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Employee currentEmployee = (Employee) session.getAttribute("user");
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

    private int parsePositiveInt(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            int parsed = Integer.parseInt(value.trim());
            return parsed > 0 ? parsed : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private int parsePageSize(String value) {
        int parsed = parsePositiveInt(value, DEFAULT_PAGE_SIZE);
        return (parsed == 5 || parsed == 10 || parsed == 20) ? parsed : DEFAULT_PAGE_SIZE;
    }
}
