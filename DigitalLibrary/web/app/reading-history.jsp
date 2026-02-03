<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.ReadingHistory"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử đọc - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .history-table { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md); }
        .history-table th, .history-table td { padding: 14px 18px; text-align: left; border-bottom: 1px solid var(--border); }
        .history-table th { background: var(--bg-tertiary); font-weight: 600; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Lịch sử đọc (Mock) - Reading_History</h2>
            <% List<ReadingHistory> list = (List<ReadingHistory>) request.getAttribute("readingHistories");
               if (list != null && !list.isEmpty()) { %>
            <table class="history-table">
                <thead><tr><th>Sách</th><th>Vị trí đọc</th><th>Lần đọc cuối</th><th></th></tr></thead>
                <tbody>
                <% for (ReadingHistory rh : list) { %>
                <tr>
                    <td><%= rh.getBook() != null ? rh.getBook().getTitle() : "Sách #" + rh.getBookId() %></td>
                    <td><%= rh.getLastReadPosition() != null ? "Trang " + rh.getLastReadPosition() : "-" %></td>
                    <td><%= rh.getLastReadAt() != null ? rh.getLastReadAt().toString() : "-" %></td>
                    <td><button type="button" class="btn-primary" style="padding: 6px 12px;">Đọc tiếp</button></td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } else { %>
            <p style="text-align: center; color: var(--text-secondary);">Chưa có lịch sử đọc.</p>
            <% } %>
        </div>
    </section>
</body>
</html>
