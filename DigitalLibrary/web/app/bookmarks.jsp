<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Bookmark"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đánh dấu trang - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .bookmark-list { max-width: 720px; }
        .bookmark-item { padding: 16px; background: white; border-radius: 8px; margin-bottom: 12px; box-shadow: var(--shadow-sm); display: flex; justify-content: space-between; align-items: center; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Đánh dấu trang (Mock) - Bookmark</h2>
            <% List<Bookmark> list = (List<Bookmark>) request.getAttribute("bookmarks");
               if (list != null && !list.isEmpty()) { %>
            <div class="bookmark-list">
                <% for (Bookmark bm : list) { %>
                <div class="bookmark-item">
                    <div>
                        <strong><%= bm.getBook() != null ? bm.getBook().getTitle() : "Sách #" + bm.getBookId() %></strong> — Trang <%= bm.getPageNumber() %>
                        <% if (bm.getNote() != null && !bm.getNote().isEmpty()) { %><br><span style="color: var(--text-secondary);"><%= bm.getNote() %></span><% } %>
                    </div>
                    <button type="button" style="padding: 6px 12px; border: 1px solid var(--border); border-radius: 6px; background: white;">Xóa</button>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <p style="text-align: center; color: var(--text-secondary);">Chưa có đánh dấu nào.</p>
            <% } %>
        </div>
    </section>
</body>
</html>
