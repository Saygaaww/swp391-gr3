<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Review"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh giá & Review - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .review-item { padding: 16px; background: white; border-radius: 8px; margin-bottom: 12px; box-shadow: var(--shadow-sm); }
        .review-stars { color: #f59e0b; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Đánh giá & Review (Mock) - Review</h2>
            <% List<Review> list = (List<Review>) request.getAttribute("reviews");
               if (list != null && !list.isEmpty()) { %>
            <% for (Review r : list) { %>
            <div class="review-item">
                <strong><%= r.getBook() != null ? r.getBook().getTitle() : "Sách #" + r.getBookId() %></strong>
                <div class="review-stars">
                    <% for (int i = 0; i < (r.getRating() != null ? r.getRating() : 0); i++) { %><i class="fas fa-star"></i><% } %>
                </div>
                <p><%= r.getComment() != null ? r.getComment() : "" %></p>
                <small style="color: var(--text-secondary);"><%= r.getCreatedAt() != null ? r.getCreatedAt().toString() : "" %></small>
            </div>
            <% } %>
            <% } else { %>
            <p style="text-align: center; color: var(--text-secondary);">Chưa có đánh giá nào.</p>
            <% } %>
        </div>
    </section>
</body>
</html>
