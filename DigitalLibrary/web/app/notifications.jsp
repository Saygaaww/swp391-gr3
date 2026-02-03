<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Notification"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông báo - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .notif-item { padding: 16px; background: white; border-radius: 8px; margin-bottom: 12px; box-shadow: var(--shadow-sm); }
        .notif-item.unread { border-left: 4px solid var(--primary); }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Hộp thư thông báo (Mock)</h2>
            <p style="color: var(--text-secondary); margin-bottom: 24px;">Nhắc trả sách, đơn hàng, đặt chỗ...</p>
            <% List<Notification> list = (List<Notification>) request.getAttribute("notifications");
               if (list != null && !list.isEmpty()) { %>
            <% for (Notification n : list) { %>
            <div class="notif-item <%= n.isRead() ? "" : "unread" %>">
                <strong><%= n.getTitle() %></strong>
                <p style="margin: 8px 0 0;"><%= n.getMessage() != null ? n.getMessage() : "" %></p>
                <small style="color: var(--text-secondary);"><%= n.getType() %> — <%= n.getCreatedAt() != null ? n.getCreatedAt().toString() : "" %></small>
            </div>
            <% } %>
            <% } else { %>
            <p style="text-align: center; color: var(--text-secondary);">Không có thông báo.</p>
            <% } %>
        </div>
    </section>
</body>
</html>
