<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Order"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử đơn hàng - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .order-table { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md); }
        .order-table th, .order-table td { padding: 14px 18px; text-align: left; border-bottom: 1px solid var(--border); }
        .order-table th { background: var(--bg-tertiary); }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Lịch sử đơn hàng (Mock) - Order, Order_Book, Payment</h2>
            <% List<Order> list = (List<Order>) request.getAttribute("orders");
               if (list != null && !list.isEmpty()) { %>
            <table class="order-table">
                <thead><tr><th>Mã đơn</th><th>Ngày</th><th>Tổng tiền</th><th>Trạng thái</th><th></th></tr></thead>
                <tbody>
                <% for (Order o : list) { %>
                <tr>
                    <td>#<%= o.getOrderId() %></td>
                    <td><%= o.getCreatedAt() != null ? o.getCreatedAt().toString() : "-" %></td>
                    <td><%= o.getTotalAmount() != null ? String.format("%,.0f %s", o.getTotalAmount(), o.getCurrency() != null ? o.getCurrency() : "VND") : "-" %></td>
                    <td><%= o.getStatus() != null ? o.getStatus() : "-" %></td>
                    <td><a href="<%= request.getContextPath() %>/seller/order-detail.jsp?id=<%= o.getOrderId() %>">Chi tiết</a></td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } else { %>
            <p style="text-align: center; color: var(--text-secondary);">Chưa có đơn hàng nào.</p>
            <% } %>
        </div>
    </section>
</body>
</html>
