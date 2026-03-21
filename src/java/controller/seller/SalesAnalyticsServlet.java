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
import model.TopSellingBook;
import util.AuthUtil;

public class SalesAnalyticsServlet extends HttpServlet {

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

        Date fromDate = parseDate(request.getParameter("fromDate"));
        Date toDate = parseDate(request.getParameter("toDate"));
        String trendBy = "month".equalsIgnoreCase(request.getParameter("trendBy")) ? "month" : "day";

        Map<String, Object> summary = orderDAO.getSellerAnalyticsSummary(employeeId, fromDate, toDate);
        List<Map<String, Object>> trend = orderDAO.getSellerRevenueTrend(employeeId, trendBy, "month".equals(trendBy) ? 12 : 14);
        List<TopSellingBook> topBooks = orderDAO.getTopSellingBooksBySeller(employeeId, 10);

        StringBuilder labels = new StringBuilder("[");
        StringBuilder values = new StringBuilder("[");
        for (int i = 0; i < trend.size(); i++) {
            Map<String, Object> row = trend.get(i);
            if (i > 0) {
                labels.append(',');
                values.append(',');
            }
            labels.append('"').append(escapeJs(String.valueOf(row.get("period")))).append('"');
            BigDecimal revenue = (BigDecimal) row.get("revenue");
            values.append(revenue == null ? "0" : revenue.toPlainString());
        }
        labels.append(']');
        values.append(']');

        request.setAttribute("summary", summary);
        request.setAttribute("trendLabels", labels.toString());
        request.setAttribute("trendValues", values.toString());
        request.setAttribute("trendBy", trendBy);
        request.setAttribute("fromDate", request.getParameter("fromDate"));
        request.setAttribute("toDate", request.getParameter("toDate"));
        request.setAttribute("topBooks", topBooks);
        request.getRequestDispatcher("/jsp/seller/sales-analytics.jsp").forward(request, response);
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

    private String escapeJs(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
