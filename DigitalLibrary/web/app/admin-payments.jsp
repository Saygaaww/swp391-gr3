<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Payment"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Danh sách thanh toán (Mock - Admin)</h2>
            <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md);">
                <thead><tr style="background: var(--bg-tertiary);"><th style="padding: 14px;">ID</th><th>Đơn hàng</th><th>Số tiền</th><th>Phương thức</th><th>Trạng thái</th><th>Mã GD</th></tr></thead>
                <tbody>
                <% List<Payment> pList = (List<Payment>)request.getAttribute("payments"); if (pList == null) pList = java.util.Collections.emptyList();
                for (Payment p : pList) { %>
                <tr style="border-bottom: 1px solid var(--border);">
                    <td style="padding: 14px;"><%= p.getPaymentId() %></td>
                    <td>#<%= p.getOrderId() %></td>
                    <td><%= p.getAmount() != null ? String.format("%,.0f", p.getAmount()) : "-" %> VND</td>
                    <td><%= p.getPaymentMethod() != null ? p.getPaymentMethod() : "-" %></td>
                    <td><%= p.getPaymentStatus() != null ? p.getPaymentStatus() : "-" %></td>
                    <td><%= p.getTransactionCode() != null ? p.getTransactionCode() : "-" %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</body>
</html>
