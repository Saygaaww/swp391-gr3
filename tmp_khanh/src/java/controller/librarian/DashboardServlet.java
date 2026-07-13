package controller.librarian;

import dao.BorrowRequestDAO;
import model.Employee;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");

        if (employee == null || !"LIBRARIAN".equals(employee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        BorrowRequestDAO borrowRequestDAO = new BorrowRequestDAO();
        int pendingRequests = borrowRequestDAO.getPendingRequests().size();

        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("employee", employee);

        request.getRequestDispatcher("/librarian/dashboard.jsp").forward(request, response);
    }
}
