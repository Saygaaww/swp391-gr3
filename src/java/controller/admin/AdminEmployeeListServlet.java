package controller.admin;

import dal.EmployeeDAO;
import dal.RoleDAO;
import model.Employee;
import model.Role;
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
    private RoleDAO roleDAO;
    private static final int DEFAULT_PAGE_SIZE = 5;

    @Override
    public void init() throws ServletException {
        employeeDAO = new EmployeeDAO();
        roleDAO = new RoleDAO();
        System.out.println("AdminEmployeeListServlet initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Employee currentEmployee = (Employee) session.getAttribute("user");
        request.setCharacterEncoding("UTF-8");

        // Xu ly block/unblock qua POST (redirect tu doPost)
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (action != null && idStr != null) {
            try {
                int empId = Integer.parseInt(idStr);

                if (empId == currentEmployee.getEmployeeId()) {
                    session.setAttribute("errorMessage", "Khong the khoa chinh minh!");
                } else {
                    Employee target = employeeDAO.getEmployeeById(empId);
                    if (target != null && "ADMIN".equalsIgnoreCase(target.getRoleName())) {
                        session.setAttribute("errorMessage", "Khong the khoa tai khoan ADMIN!");
                    } else if ("block".equals(action)) {
                        boolean success = employeeDAO.updateEmployeeStatus(empId, "blocked");
                        if (success) {
                            session.setAttribute("successMessage",
                                    "Da khoa nhan vien: " + (target != null ? target.getFullName() : "ID " + empId));
                        } else {
                            session.setAttribute("errorMessage", "Khoa nhan vien that bai!");
                        }
                    } else if ("unblock".equals(action)) {
                        boolean success = employeeDAO.updateEmployeeStatus(empId, "active");
                        if (success) {
                            session.setAttribute("successMessage",
                                    "Da mo khoa nhan vien: " + (target != null ? target.getFullName() : "ID " + empId));
                        } else {
                            session.setAttribute("errorMessage", "Mo khoa nhan vien that bai!");
                        }
                    }
                }
            } catch (NumberFormatException e) {
                // ID khong hop le, bo qua
            }
        }

        // Lay danh sach voi loc
        try {
            // Page size
            int pageSize = DEFAULT_PAGE_SIZE;
            boolean showAll = false;
            String pageSizeStr = request.getParameter("pageSize");
            if (pageSizeStr != null && !pageSizeStr.trim().isEmpty()) {
                if (pageSizeStr.equals("all")) {
                    showAll = true;
                    pageSize = Integer.MAX_VALUE;
                } else {
                    try {
                        pageSize = Integer.parseInt(pageSizeStr);
                        if (pageSize != 5 && pageSize != 10 && pageSize != 20) {
                            pageSize = DEFAULT_PAGE_SIZE;
                        }
                    } catch (NumberFormatException e) {
                        pageSize = DEFAULT_PAGE_SIZE;
                    }
                }
            }

            // Current page
            int currentPage = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Math.max(1, Integer.parseInt(pageStr));
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            // Keyword
            String keyword = request.getParameter("keyword");
            if (keyword != null) {
                keyword = keyword.trim().replaceAll("\\s+", " ");
                if (keyword.isEmpty()) {
                    keyword = null;
                }
            }

            // Role filter
            int filterRoleId = 0;
            String roleIdStr = request.getParameter("roleId");
            if (roleIdStr != null && !roleIdStr.trim().isEmpty()) {
                try {
                    filterRoleId = Integer.parseInt(roleIdStr);
                } catch (NumberFormatException e) {
                    filterRoleId = 0;
                }
            }

            // Status filter
            String filterStatus = request.getParameter("status");
            if (filterStatus != null && filterStatus.trim().isEmpty()) {
                filterStatus = null;
            }

            // Query voi filter
            int totalEmployees = employeeDAO.countEmployeesFiltered(keyword, filterRoleId, filterStatus);
            int totalPages = Math.max(1, (int) Math.ceil((double) totalEmployees / pageSize));
            if (currentPage > totalPages) {
                currentPage = totalPages;
            }

            List<Employee> employeeList = employeeDAO.getEmployeesFiltered(
                    keyword, filterRoleId, filterStatus, currentPage, pageSize);

            // Thong ke theo trang thai
            int activeCount = employeeDAO.countEmployeesByStatus("active");
            int blockedCount = employeeDAO.countEmployeesByStatus("blocked");

            // Lay danh sach role de hien thi filter
            List<Role> roles = roleDAO.getAllRoles();

            // Truyen du lieu sang JSP
            request.setAttribute("employeeList", employeeList);
            request.setAttribute("totalEmployees", totalEmployees);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", showAll ? "all" : String.valueOf(pageSize));
            request.setAttribute("currentEmployee", currentEmployee);
            request.setAttribute("activeCount", activeCount);
            request.setAttribute("blockedCount", blockedCount);

            // Filter data
            request.setAttribute("roles", roles);
            request.setAttribute("keyword", keyword);
            request.setAttribute("filterRoleId", filterRoleId);
            request.setAttribute("filterStatus", filterStatus);

            // Session messages
            if (session.getAttribute("successMessage") != null) {
                request.setAttribute("successMessage", session.getAttribute("successMessage"));
                session.removeAttribute("successMessage");
            }
            if (session.getAttribute("errorMessage") != null) {
                request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
                session.removeAttribute("errorMessage");
            }

            request.getRequestDispatcher("/jsp/admin/employees.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Loi: " + e.getMessage());
            request.getRequestDispatcher("/jsp/admin/employees.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        // Xu ly block/unblock qua POST
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (action != null && idStr != null) {
            Employee currentEmployee = (Employee) session.getAttribute("user");
            try {
                int empId = Integer.parseInt(idStr.trim());

                if (empId <= 0 || empId > 999999999) {
                    session.setAttribute("errorMessage", "ID nhan vien khong hop le!");
                } else if (empId == currentEmployee.getEmployeeId()) {
                    session.setAttribute("errorMessage", "Khong the khoa chinh minh!");
                } else {
                    Employee target = employeeDAO.getEmployeeById(empId);
                    if (target == null) {
                        session.setAttribute("errorMessage", "Khong tim thay nhan vien ID: " + empId);
                    } else if ("ADMIN".equalsIgnoreCase(target.getRoleName())) {
                        session.setAttribute("errorMessage", "Khong the khoa tai khoan ADMIN!");
                    } else if ("block".equals(action)) {
                        if ("blocked".equals(target.getStatus())) {
                            session.setAttribute("errorMessage", "Nhan vien nay da bi khoa roi!");
                        } else {
                            boolean success = employeeDAO.updateEmployeeStatus(empId, "blocked");
                            if (success) {
                                session.setAttribute("successMessage", "Da khoa nhan vien: " + target.getFullName());
                            } else {
                                session.setAttribute("errorMessage", "Khoa nhan vien that bai!");
                            }
                        }
                    } else if ("unblock".equals(action)) {
                        if ("active".equals(target.getStatus())) {
                            session.setAttribute("errorMessage", "Nhan vien nay dang active roi!");
                        } else {
                            boolean success = employeeDAO.updateEmployeeStatus(empId, "active");
                            if (success) {
                                session.setAttribute("successMessage", "Da mo khoa nhan vien: " + target.getFullName());
                            } else {
                                session.setAttribute("errorMessage", "Mo khoa nhan vien that bai!");
                            }
                        }
                    }
                }
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "ID nhan vien khong hop le!");
            }

            response.sendRedirect(request.getContextPath() + "/admin/employees");
            return;
        }

        // Search redirect
        String keyword = request.getParameter("keyword");
        String redirectUrl = request.getContextPath() + "/admin/employees";

        if (keyword != null && !keyword.trim().isEmpty()) {
            try {
                redirectUrl += "?keyword=" + URLEncoder.encode(keyword.trim(), "UTF-8");
            } catch (UnsupportedEncodingException e) {
            }
        }

        response.sendRedirect(redirectUrl);
    }
}
