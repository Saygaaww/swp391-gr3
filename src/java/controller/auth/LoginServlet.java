package controller.auth;

import dal.ReaderDAO;
import dal.EmployeeDAO;
import model.Reader;
import model.Employee;
import util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
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
            request.setAttribute("error", "Vui long nhap day du thong tin");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
            return;
        }

        String hashedPassword = PasswordUtil.hash(password);

        // Kiem tra trong bang Employee truoc (ADMIN, LIBRARIAN, SELLER)
        EmployeeDAO empDAO = new EmployeeDAO();
        Employee emp = empDAO.getEmployeeByEmail(email);

        if (emp != null && emp.getPasswordHash().equals(hashedPassword)) {
            if (!"active".equalsIgnoreCase(emp.getStatus())) {
                request.setAttribute("error", "Tai khoan da bi khoa");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("employee", emp);

            // Dieu huong theo role
            String role = emp.getRoleName();
            if ("ADMIN".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if ("LIBRARIAN".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/librarian/home.jsp");
            } else if ("SELLER".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/seller/home.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
            return;
        }

        // Kiem tra trong bang Reader (USER)
        ReaderDAO readerDAO = new ReaderDAO();
        Reader reader = readerDAO.getReaderByEmail(email);

        if (reader != null && reader.getPasswordHash().equals(hashedPassword)) {
            if (!"active".equalsIgnoreCase(reader.getStatus())) {
                request.setAttribute("error", "Tai khoan da bi khoa");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("user", reader);
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // Sai email hoac mat khau
        request.setAttribute("error", "Email hoac mat khau khong dung");
        request.setAttribute("inputEmail", email);
        request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
    }
}