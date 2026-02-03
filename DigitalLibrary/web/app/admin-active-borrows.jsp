<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Borrow"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phiếu mượn đang hoạt động - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Phiếu mượn đang hoạt động (Mock - Librarian)</h2>
            <% List<Borrow> list = (List<Borrow>) request.getAttribute("activeBorrows");
               if (list != null && !list.isEmpty()) { %>
            <% for (Borrow b : list) { %>
            <div style="padding: 16px; background: white; border-radius: 8px; margin-bottom: 12px; box-shadow: var(--shadow-sm);">
                Phiếu #<%= b.getBorrowId() %> — Đọc giả: <%= b.getReader() != null ? b.getReader().getFullName() : b.getReaderId() %> — Trạng thái: <%= b.getStatus() %> — <a href="#">Xác nhận trả</a>
            </div>
            <% } %>
            <% } else { %>
            <p style="text-align: center; color: var(--text-secondary);">Không có phiếu mượn đang hoạt động.</p>
            <% } %>
        </div>
    </section>
</body>
</html>
