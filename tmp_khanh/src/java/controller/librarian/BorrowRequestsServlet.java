package controller.librarian;

import dao.BorrowRequestDAO;
import model.BorrowRequest;
import model.Employee;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class BorrowRequestsServlet extends HttpServlet {

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
        
        String filter = request.getParameter("filter");
        List<BorrowRequest> requests;
        
        if ("pending".equals(filter)) {
            requests = borrowRequestDAO.getPendingRequests();
        } else {
            requests = borrowRequestDAO.getAllBorrowRequests();
        }

        request.setAttribute("requests", requests);
        request.setAttribute("filter", filter);

        request.getRequestDispatcher("/librarian/borrow-requests.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Employee employee = (Employee) session.getAttribute("employee");

        if (employee == null || !"LIBRARIAN".equals(employee.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String decisionNote = request.getParameter("decisionNote");

        BorrowRequestDAO borrowRequestDAO = new BorrowRequestDAO();

        if ("approve".equals(action)) {
            borrowRequestDAO.updateRequestStatus(requestId, "approved", employee.getEmployeeId(), decisionNote);
            session.setAttribute("successMessage", "Borrow request approved successfully!");
        } else if ("reject".equals(action)) {
            borrowRequestDAO.updateRequestStatus(requestId, "rejected", employee.getEmployeeId(), decisionNote);
            session.setAttribute("successMessage", "Borrow request rejected!");
        }

        response.sendRedirect(request.getContextPath() + "/librarian/borrow-requests");
    }
}
