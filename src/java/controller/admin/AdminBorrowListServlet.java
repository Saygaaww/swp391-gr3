package controller.admin;

import dal.BorrowDAO;
import model.BorrowRequest;
import model.Employee;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/borrow-list")
public class AdminBorrowListServlet extends HttpServlet {

    private BorrowDAO borrowDAO;
    private static final int DEFAULT_PAGE_SIZE = 10;

    // Regex validate định dạng dd-MM-yyyy
    private static final java.util.regex.Pattern DATE_DD_MM_YYYY
            = java.util.regex.Pattern.compile("^(0[1-9]|[12]\\d|3[01])-(0[1-9]|1[0-2])-(\\d{4})$");

    private static final DateTimeFormatter DATE_FORMATTER
            = DateTimeFormatter.ofPattern("dd-MM-yyyy");

    @Override
    public void init() throws ServletException {
        borrowDAO = new BorrowDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        try {
            // ── Page size ──────────────────────────────────────────────────
            int pageSize = DEFAULT_PAGE_SIZE;
            boolean showAll = false;
            String pageSizeStr = request.getParameter("pageSize");
            if (pageSizeStr != null && !pageSizeStr.trim().isEmpty()) {
                if (pageSizeStr.equals("all")) {
                    showAll = true;
                    pageSize = Integer.MAX_VALUE;
                } else {
                    try {
                        pageSize = Integer.parseInt(pageSizeStr);
                        if (pageSize != 5 && pageSize != 10 && pageSize != 20) {
                            pageSize = DEFAULT_PAGE_SIZE;
                        }
                    } catch (NumberFormatException e) {
                        pageSize = DEFAULT_PAGE_SIZE;
                    }
                }
            }

            // ── Trang hiện tại ─────────────────────────────────────────────
            int currentPage = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) {
                        currentPage = 1;
                    }
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            // ── Từ khóa tìm kiếm ───────────────────────────────────────────
            String keyword = request.getParameter("keyword");
            if (keyword != null) {
                keyword = keyword.trim();
                if (keyword.isEmpty()) {
                    keyword = null;
                }
            }

            // ── Bộ lọc trạng thái ──────────────────────────────────────────
            String statusFilter = request.getParameter("status");
            if (statusFilter != null && statusFilter.trim().isEmpty()) {
                statusFilter = null;
            }

            // ── Validate ngày bắt đầu (fromDate) - định dạng dd-MM-yyyy ────
            String fromDateStr = request.getParameter("fromDate");
            LocalDate fromDate = null;
            if (fromDateStr != null && !fromDateStr.trim().isEmpty()) {
                fromDateStr = fromDateStr.trim();
                if (!DATE_DD_MM_YYYY.matcher(fromDateStr).matches()) {
                    request.setAttribute("errorFromDate",
                            "Ngày bắt đầu không hợp lệ. Định dạng phải là dd-MM-yyyy (ví dụ: 01-01-2024).");
                } else {
                    try {
                        fromDate = LocalDate.parse(fromDateStr, DATE_FORMATTER);
                    } catch (DateTimeParseException e) {
                        request.setAttribute("errorFromDate",
                                "Ngày bắt đầu không tồn tại. Vui lòng kiểm tra lại.");
                    }
                }
            }

            // ── Validate ngày kết thúc (toDate) - định dạng dd-MM-yyyy ─────
            String toDateStr = request.getParameter("toDate");
            LocalDate toDate = null;
            if (toDateStr != null && !toDateStr.trim().isEmpty()) {
                toDateStr = toDateStr.trim();
                if (!DATE_DD_MM_YYYY.matcher(toDateStr).matches()) {
                    request.setAttribute("errorToDate",
                            "Ngày kết thúc không hợp lệ. Định dạng phải là dd-MM-yyyy (ví dụ: 31-12-2024).");
                } else {
                    try {
                        toDate = LocalDate.parse(toDateStr, DATE_FORMATTER);
                    } catch (DateTimeParseException e) {
                        request.setAttribute("errorToDate",
                                "Ngày kết thúc không tồn tại. Vui lòng kiểm tra lại.");
                    }
                }
            }

            // ── Validate fromDate phải <= toDate ───────────────────────────
            if (fromDate != null && toDate != null && fromDate.isAfter(toDate)) {
                request.setAttribute("errorDateRange",
                        "Ngày bắt đầu không được lớn hơn ngày kết thúc.");
                fromDate = null;
                toDate = null;
            }

            // ── Truy vấn ───────────────────────────────────────────────────
            int totalRequests = borrowDAO.countRequestsFiltered(keyword, statusFilter);
            int totalPages = (int) Math.ceil((double) totalRequests / pageSize);
            if (totalPages < 1) {
                totalPages = 1;
            }
            if (currentPage > totalPages) {
                currentPage = totalPages;
            }

            List<BorrowRequest> requestList = borrowDAO.getRequestsFiltered(
                    keyword, statusFilter, currentPage, pageSize);

            // ── Thống kê theo trạng thái ───────────────────────────────────
            int countPending = borrowDAO.countByStatus("pending");
            int countApproved = borrowDAO.countByStatus("approved");
            int countRejected = borrowDAO.countByStatus("rejected");

            // ── Truyền dữ liệu sang JSP ────────────────────────────────────
            request.setAttribute("requestList", requestList);
            request.setAttribute("totalRequests", totalRequests);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("keyword", keyword);
            request.setAttribute("filterStatus", statusFilter);
            request.setAttribute("countPending", countPending);
            request.setAttribute("countApproved", countApproved);
            request.setAttribute("countRejected", countRejected);
            request.setAttribute("currentEmployee", session.getAttribute("user"));
            request.setAttribute("pageSize", showAll ? "all" : String.valueOf(pageSize));
            request.setAttribute("fromDate", fromDateStr);
            request.setAttribute("toDate", toDateStr);

            request.getRequestDispatcher("/jsp/admin/borrow-list.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("AdminBorrowListServlet Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
}

