<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Order"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Quản lý đơn hàng (Mock - Seller/Admin)</h2>
            <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md);">
                <thead><tr style="background: var(--bg-tertiary);"><th style="padding: 14px;">ID</th><th>Đọc giả</th><th>Tổng tiền</th><th>Trạng thái</th><th>Ngày</th></tr></thead>
                <tbody>
                <% List<Order> oList = (List<Order>)request.getAttribute("orders"); if (oList == null) oList = java.util.Collections.emptyList();
                for (Order o : oList) { %>
                <tr style="border-bottom: 1px solid var(--border);">
                    <td style="padding: 14px;">#<%= o.getOrderId() %></td>
                    <td><%= o.getReader() != null ? o.getReader().getFullName() : o.getReaderId() %></td>
                    <td><%= o.getTotalAmount() != null ? String.format("%,.0f", o.getTotalAmount()) : "-" %> <%= o.getCurrency() != null ? o.getCurrency() : "VND" %></td>
                    <td><%= o.getStatus() %></td>
                    <td><%= o.getCreatedAt() != null ? o.getCreatedAt().toString() : "-" %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</body>
</html>
