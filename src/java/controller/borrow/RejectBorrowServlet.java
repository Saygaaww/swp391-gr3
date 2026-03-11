package controller.borrow;

import dao.BorrowRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Reader;

import java.io.IOException;

public class RejectBorrowServlet extends HttpServlet {
    private final BorrowRequestDAO borrowRequestDAO = new BorrowRequestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String contextPath = request.getContextPath();
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null || !"LIBRARIAN".equals(user.getRoleName())) {
            response.sendRedirect(contextPath + "/auth/login.jsp");
            return;
        }
        String idParam = request.getParameter("request_id");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(contextPath + "/PendingBorrowRequestsServlet");
            return;
        }
        int requestId;
        try {
            requestId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(contextPath + "/PendingBorrowRequestsServlet");
            return;
        }
        String decisionNote = request.getParameter("decision_note");
        if (decisionNote == null) decisionNote = "";

        boolean ok = borrowRequestDAO.reject(requestId, user.getReaderId(), decisionNote);
        if (ok) {
            response.sendRedirect(contextPath + "/PendingBorrowRequestsServlet?success=rejected");
        } else {
            response.sendRedirect(contextPath + "/PendingBorrowRequestsServlet?error=reject_failed");
        }
    }
}
