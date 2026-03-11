package controller.borrow;

import dao.BorrowRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Reader;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class ApproveBorrowServlet extends HttpServlet {
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

        // Hai ô ngày giờ: borrow_from, due_date. Không nhập thì mặc định 1 tuần.
        LocalDateTime borrowFrom = null;
        LocalDateTime dueDate = null;
        DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
        String borrowFromStr = request.getParameter("borrow_from");
        String dueDateStr = request.getParameter("due_date");
        if (borrowFromStr != null && !borrowFromStr.isBlank()) {
            try {
                borrowFrom = LocalDateTime.parse(borrowFromStr.replace(" ", "T"), formatter);
            } catch (DateTimeParseException ignored) { }
        }
        if (dueDateStr != null && !dueDateStr.isBlank()) {
            try {
                dueDate = LocalDateTime.parse(dueDateStr.replace(" ", "T"), formatter);
            } catch (DateTimeParseException ignored) { }
        }
        if (borrowFrom == null) borrowFrom = LocalDateTime.now();
        if (dueDate == null) dueDate = borrowFrom.plusDays(7);

        // borrowFrom không được ở quá khứ quá 1 ngày
        if (borrowFrom.isBefore(LocalDateTime.now().minusDays(1))) {
            response.sendRedirect(contextPath + "/PendingBorrowRequestsServlet?error=invalid_borrow_date");
            return;
        }

        // Giới hạn thời hạn mượn tối đa 30 ngày
        if (dueDate.isAfter(borrowFrom.plusDays(30))) {
            dueDate = borrowFrom.plusDays(30);
        }

        boolean ok = borrowRequestDAO.approve(requestId, user.getReaderId(), decisionNote, borrowFrom, dueDate);
        if (ok) {
            response.sendRedirect(contextPath + "/PendingBorrowRequestsServlet?success=approved");
        } else {
            response.sendRedirect(contextPath + "/PendingBorrowRequestsServlet?error=approve_failed");
        }
    }
}
