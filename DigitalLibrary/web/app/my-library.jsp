<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.ReaderBookOwnership"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tủ sách của tôi - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .books-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 24px; }
        .book-card { background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md); padding: 20px; }
        .book-title { font-weight: 600; margin-bottom: 8px; }
        .book-meta { font-size: 14px; color: var(--text-secondary); }
        .btn-read { margin-top: 12px; padding: 8px 16px; background: var(--primary); color: white; border: none; border-radius: 8px; cursor: pointer; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Tủ sách của tôi (Mock)</h2>
            <p style="color: var(--text-secondary); margin-bottom: 24px;">Sách bạn sở hữu vĩnh viễn (Reader_Book_Ownership)</p>
            <% List<ReaderBookOwnership> list = (List<ReaderBookOwnership>) request.getAttribute("ownedBooks");
               if (list != null && !list.isEmpty()) { %>
            <div class="books-grid">
                <% for (ReaderBookOwnership o : list) { %>
                <div class="book-card">
                    <div class="book-title"><%= o.getBook() != null ? o.getBook().getTitle() : "Sách #" + o.getBookId() %></div>
                    <div class="book-meta">Mua qua: <%= o.getAcquiredVia() != null ? o.getAcquiredVia() : "-" %></div>
                    <button type="button" class="btn-read" onclick="alert('Mở đọc (mock)')"><i class="fas fa-book-open"></i> Đọc</button>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <p style="text-align: center; color: var(--text-secondary);">Chưa có sách nào trong tủ.</p>
            <p style="text-align: center;"><a href="<%= request.getContextPath() %>/pages/browse" class="btn-primary">Duyệt sách</a></p>
            <% } %>
        </div>
    </section>
</body>
</html>
