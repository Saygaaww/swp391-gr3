package controller.admin;

import dao.ReaderDAO;
import dao.EmployeeDAO;
import model.Employee;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class UserManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");

        if (employee == null || !"ADMIN".equals(employee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get users list
        // TODO: Implement getAllReaders() and getAllEmployees() in respective DAOs

        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");

        if (employee == null || !"ADMIN".equals(employee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String userType = request.getParameter("userType");

        if ("block".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            
            if ("reader".equals(userType)) {
                // TODO: Block reader
            } else if ("employee".equals(userType)) {
                EmployeeDAO employeeDAO = new EmployeeDAO();
                employeeDAO.updateStatus(userId, "blocked");
            }
            
            session.setAttribute("successMessage", "User blocked successfully!");
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
