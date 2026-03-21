package controller.seller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.List;
import java.util.Map;
import util.AuthUtil;

public class SalesReportServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AuthUtil.isLoggedIn(request) || !AuthUtil.isSeller(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Integer employeeId = AuthUtil.getEmployeeId(request);
        if (employeeId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String groupBy = "month".equalsIgnoreCase(request.getParameter("groupBy")) ? "month" : "day";
        String status = normalizeStatus(request.getParameter("status"));
        Date fromDate = parseDate(request.getParameter("fromDate"));
        Date toDate = parseDate(request.getParameter("toDate"));

        List<Map<String, Object>> rows = orderDAO.getSellerSalesReport(employeeId, fromDate, toDate, status, groupBy);

        int totalOrders = 0;
        BigDecimal totalRevenue = BigDecimal.ZERO;
        for (Map<String, Object> row : rows) {
            Number count = (Number) row.get("orderCount");
            if (count != null) {
                totalOrders += count.intValue();
            }
            BigDecimal revenue = (BigDecimal) row.get("revenue");
            if (revenue != null) {
                totalRevenue = totalRevenue.add(revenue);
            }
        }

        request.setAttribute("rows", rows);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("groupBy", groupBy);
        request.setAttribute("status", status == null ? "" : status);
        request.setAttribute("fromDate", request.getParameter("fromDate"));
        request.setAttribute("toDate", request.getParameter("toDate"));
        request.getRequestDispatcher("/jsp/seller/sales-report.jsp").forward(request, response);
    }

    private String normalizeStatus(String rawStatus) {
        if (rawStatus == null || rawStatus.isBlank() || "all".equalsIgnoreCase(rawStatus)) {
            return null;
        }
        String value = rawStatus.trim().toLowerCase();
        if ("pending".equals(value) || "paid".equals(value) || "cancelled".equals(value)) {
            return value;
        }
        return null;
    }

    private Date parseDate(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return Date.valueOf(value);
        } catch (Exception e) {
            return null;
        }
    }
}
