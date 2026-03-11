package controller.librarian;

import dao.BorrowItemDAO;
import dao.BorrowRequestDAO;
import model.Employee;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Dashboard librarian: số yêu cầu mượn đang chờ (pendingRequests), danh sách mượn quá hạn (overdueList). Chỉ hiển thị, không CRUD.
 */
public class DashboardServlet extends HttpServlet {

    /**
     * Kiểm tra employee role LIBRARIAN. Lấy pendingRequests (getPendingRequests.size), overdueList (getOverdueItems); set attributes, forward librarian/dashboard.jsp.
     */
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
        BorrowItemDAO borrowItemDAO = new BorrowItemDAO();
        int pendingRequests = borrowRequestDAO.getPendingRequests().size();

        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("overdueList", borrowItemDAO.getOverdueItems());
        request.setAttribute("employee", employee);

        request.getRequestDispatcher("/librarian/dashboard.jsp").forward(request, response);
    }
}
