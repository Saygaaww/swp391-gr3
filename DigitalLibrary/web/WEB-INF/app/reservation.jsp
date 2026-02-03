<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Reservation"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt chỗ mượn sách - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Đặt chỗ / Hold (Mock) - Reservation</h2>
            <p style="color: var(--text-secondary); margin-bottom: 24px;">Khi không còn bản copy, đặt chỗ để được ưu tiên khi có sách trả.</p>
            <% List<Reservation> resList = (List<Reservation>)request.getAttribute("reservations"); if (resList == null) resList = java.util.Collections.emptyList();
            for (Reservation res : resList) { %>
            <div style="padding: 16px; background: white; border-radius: 8px; margin-bottom: 12px; box-shadow: var(--shadow-sm);">
                Sách: <strong><%= res.getBook() != null ? res.getBook().getTitle() : "Sách #" + res.getBookId() %></strong> — Trạng thái: <%= res.getStatus() %> — Hết hạn: <%= res.getExpiresAt() != null ? res.getExpiresAt().toString() : "-" %>
            </div>
            <% } %>
        </div>
    </section>
</body>
</html>
