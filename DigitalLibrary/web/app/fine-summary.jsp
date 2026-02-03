<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Fine"%>
<%@page import="model.FineType"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phạt - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Tổng hợp phạt (Mock) - Fine, Fine_Type</h2>
            <% List<Fine> list = (List<Fine>) request.getAttribute("fines");
               if (list != null && !list.isEmpty()) { %>
            <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md);">
                <thead><tr style="background: var(--bg-tertiary);"><th style="padding: 14px;">Loại</th><th>Lý do</th><th>Số tiền</th><th>Trạng thái</th><th></th></tr></thead>
                <tbody>
                <% for (Fine f : list) { %>
                <tr style="border-bottom: 1px solid var(--border);">
                    <td style="padding: 14px;"><%= f.getFineType() != null ? f.getFineType().getName() : "-" %></td>
                    <td><%= f.getReason() != null ? f.getReason() : "-" %></td>
                    <td><%= f.getAmount() != null ? String.format("%,.0f VND", f.getAmount()) : "-" %></td>
                    <td><%= f.getStatus() != null ? f.getStatus() : "-" %></td>
                    <td><% if ("unpaid".equals(f.getStatus())) { %><a href="<%= request.getContextPath() %>/pages/pay-fine">Thanh toán</a><% } %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } else { %>
            <p style="text-align: center; color: var(--text-secondary);">Không có phạt nào.</p>
            <% } %>
        </div>
    </section>
</body>
</html>
