package controller.borrow;

import dao.BorrowDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Reader;

import java.io.IOException;

public class ReturnBookServlet extends HttpServlet {
    private final BorrowDAO borrowDAO = new BorrowDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String contextPath = request.getContextPath();
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null || !"USER".equals(user.getRoleName())) {
            response.sendRedirect(contextPath + "/auth/login.jsp");
            return;
        }
        String idParam = request.getParameter("borrow_item_id");
        if (idParam == null || idParam.isBlank()) {
            response.sendRedirect(contextPath + "/MyBorrowHistoryServlet?error=invalid");
            return;
        }
        int borrowItemId;
        try {
            borrowItemId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(contextPath + "/MyBorrowHistoryServlet?error=invalid");
            return;
        }
        boolean ok = borrowDAO.returnItem(borrowItemId, user.getReaderId());
        if (ok) {
            response.sendRedirect(contextPath + "/MyBorrowHistoryServlet?success=returned");
        } else {
            response.sendRedirect(contextPath + "/MyBorrowHistoryServlet?error=return_failed");
        }
    }
}
