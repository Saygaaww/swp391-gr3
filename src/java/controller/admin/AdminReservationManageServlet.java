package controller.admin;

import dal.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.AdminReservationView;
import model.Employee;
import util.AuthUtil;

@WebServlet(name = "AdminReservationManageServlet", urlPatterns = {"/admin/reservations"})
public class AdminReservationManageServlet extends HttpServlet {

    private boolean canManage(HttpServletRequest request) {
        return AuthUtil.hasAnyRole(request, AuthUtil.ROLE_ADMIN, AuthUtil.ROLE_LIBRARIAN);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AuthUtil.SESSION_USER) == null || !canManage(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String status = request.getParameter("status");
        if (status == null || status.isBlank()) {
            status = "ALL";
        }

        Integer bookId = null;
        String bookIdStr = request.getParameter("bookId");
        if (bookIdStr != null && !bookIdStr.isBlank()) {
            try {
                bookId = Integer.parseInt(bookIdStr);
            } catch (NumberFormatException ignore) {
            }
        }

        ReservationDAO dao = new ReservationDAO();
        dao.expireAllDueReservations();
        List<AdminReservationView> rows = dao.getReservationsForAdmin(status, bookId);

        request.setAttribute("reservations", rows);
        request.setAttribute("selectedStatus", status.toUpperCase());
        request.setAttribute("selectedBookId", bookId);
        request.setAttribute("booksNeedAssignCount", dao.countBooksNeedingAssignment());
        request.getRequestDispatcher("/jsp/admin/reservations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute(AuthUtil.SESSION_USER) == null || !canManage(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        ReservationDAO dao = new ReservationDAO();
        boolean ok = false;

        try {
            if ("assign_next".equals(action)) {
                int bookId = Integer.parseInt(request.getParameter("bookId"));
                ok = dao.activateNextPendingReservation(bookId);
            } else if ("skip".equals(action)) {
                int reservationId = Integer.parseInt(request.getParameter("reservationId"));
                ok = dao.skipReservation(reservationId);
            } else if ("confirm_borrow".equals(action)) {
                int reservationId = Integer.parseInt(request.getParameter("reservationId"));
                Employee employee = (Employee) session.getAttribute(AuthUtil.SESSION_USER);
                int employeeId = employee != null && employee.getEmployeeId() != null ? employee.getEmployeeId() : 0;
                ok = employeeId > 0 && dao.confirmBorrowFromReady(reservationId, employeeId);
            }
        } catch (Exception e) {
            ok = false;
        }

        session.setAttribute(ok ? "successMessage" : "errorMessage",
                ok ? "Reservation action completed." : "Reservation action failed.");

        String status = request.getParameter("status");
        String bookId = request.getParameter("filterBookId");
        StringBuilder redirect = new StringBuilder(request.getContextPath()).append("/admin/reservations");
        boolean hasQuery = false;
        if (status != null && !status.isBlank()) {
            redirect.append("?status=").append(status);
            hasQuery = true;
        }
        if (bookId != null && !bookId.isBlank()) {
            redirect.append(hasQuery ? "&" : "?").append("bookId=").append(bookId);
        }
        response.sendRedirect(redirect.toString());
    }
}

