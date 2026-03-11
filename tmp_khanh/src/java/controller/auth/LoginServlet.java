package controller.auth;

import dao.ReaderDAO;
import dao.EmployeeDAO;
import model.Reader;
import model.Employee;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import util.PasswordUtil;

/**
 * Unified login for both Reader (user) and Employee.
 * Tries Reader first, then Employee. Redirects by role.
 */
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.isBlank() || password.isBlank()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }

        String hashedPassword = PasswordUtil.hash(password);
        HttpSession session = request.getSession(true);
        session.setMaxInactiveInterval(60 * 30); // 30 phút

        // 1) Try Reader (user) first
        ReaderDAO readerDAO = new ReaderDAO();
        Reader user = readerDAO.loginByEmailPassword(email, hashedPassword);

        if (user != null) {
            if (!"ACTIVE".equalsIgnoreCase(user.getStatus())) {
                request.setAttribute("error", "Tài khoản đã bị khóa");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }
            session.setAttribute("user", user);
            session.removeAttribute("employee");
            response.sendRedirect(request.getContextPath() + "/customer/home_1.jsp");
            return;
        }

        // 2) Try Employee
        EmployeeDAO employeeDAO = new EmployeeDAO();
        Employee employee = employeeDAO.loginByEmailPassword(email, hashedPassword);

        if (employee != null) {
            if (!"active".equalsIgnoreCase(employee.getStatus())) {
                request.setAttribute("error", "Tài khoản đã bị khóa");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }
            session.setAttribute("employee", employee);
            session.setAttribute("userType", "employee");
            session.removeAttribute("user");

            String role = employee.getRoleName();
            switch (role) {
                case "ADMIN":
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    break;
                case "LIBRARIAN":
                    response.sendRedirect(request.getContextPath() + "/librarian/dashboard");
                    break;
                case "SELLER":
                    response.sendRedirect(request.getContextPath() + "/seller/dashboard");
                    break;
                default:
                    request.setAttribute("error", "Quyền truy cập không hợp lệ");
                    request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                    break;
            }
            return;
        }

        // Not found as either
        request.setAttribute("error", "Email hoặc mật khẩu không đúng");
        request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
    }
}
