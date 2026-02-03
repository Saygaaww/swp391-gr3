<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Review"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kiểm duyệt review - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Kiểm duyệt đánh giá (Mock - Admin)</h2>
            <% List<Review> revList = (List<Review>)request.getAttribute("reviews"); if (revList == null) revList = java.util.Collections.emptyList();
            for (Review r : revList) { %>
            <div style="padding: 16px; background: white; border-radius: 8px; margin-bottom: 12px; box-shadow: var(--shadow-sm);">
                Sách: <strong><%= r.getBook() != null ? r.getBook().getTitle() : "Sách #" + r.getBookId() %></strong> — <%= r.getRating() != null ? r.getRating() : 0 %> sao — "<%= r.getComment() != null ? r.getComment() : "" %>"
                <br><small><%= r.getReader() != null ? r.getReader().getFullName() : "" %> — <%= r.getCreatedAt() != null ? r.getCreatedAt().toString() : "" %></small>
                <br><a href="#">Duyệt</a> | <a href="#">Xóa</a>
            </div>
            <% } %>
        </div>
    </section>
</body>
</html>
