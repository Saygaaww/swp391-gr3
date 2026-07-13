package controller.admin;

import dal.BookDAO;
import dal.ReaderDAO;
import dal.EmployeeDAO;
import dal.RoleDAO;
import model.Employee;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({ "/admin/dashboard", "/admin", "/admin/" })
public class AdminDashboardServlet extends HttpServlet {

    private BookDAO bookDAO;
    private ReaderDAO readerDAO;
    private EmployeeDAO employeeDAO;
    private RoleDAO roleDAO;

    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        readerDAO = new ReaderDAO();
        employeeDAO = new EmployeeDAO();
        roleDAO = new RoleDAO();
        System.out.println("AdminDashboardServlet initialized");
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

        try {
            int totalBooks = bookDAO.getTotalBooks();

            int totalReaders = readerDAO.getTotalReaders();
            int totalEmployees = employeeDAO.getTotalEmployees();
            int totalRoles = roleDAO.getAllRoles().size();

            request.setAttribute("currentEmployee", currentEmployee);

            request.setAttribute("totalBooks", totalBooks);

            request.setAttribute("totalReaders", totalReaders);
            request.setAttribute("totalEmployees", totalEmployees);
            request.setAttribute("totalRoles", totalRoles);

            request.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("AdminDashboardServlet Error: " + e.getMessage());
            e.printStackTrace();

            request.setAttribute("currentEmployee", currentEmployee);
            request.setAttribute("totalBooks", 0);
            request.setAttribute("totalReaders", 0);
            request.setAttribute("totalEmployees", 0);
            request.setAttribute("totalRoles", 0);

            request.getRequestDispatcher("/jsp/admin/dashboard.jsp").forward(request, response);
        }
    }
}

