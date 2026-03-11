package controller.borrow;

import dao.BorrowRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.BorrowRequest;
import model.Reader;

import java.io.IOException;
import java.util.List;

public class PendingBorrowRequestsServlet extends HttpServlet {
    private final BorrowRequestDAO borrowRequestDAO = new BorrowRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null || !"LIBRARIAN".equals(user.getRoleName())) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        List<BorrowRequest> pending = borrowRequestDAO.listPending();
        request.setAttribute("pendingRequests", pending);
        request.getRequestDispatcher("/librarian/pending-requests.jsp").forward(request, response);
    }
}
