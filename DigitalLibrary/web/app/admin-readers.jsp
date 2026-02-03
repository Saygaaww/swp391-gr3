<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Reader"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đọc giả - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Quản lý đọc giả (Mock - Admin)</h2>
            <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md);">
                <thead><tr style="background: var(--bg-tertiary);"><th style="padding: 14px;">ID</th><th>Họ tên</th><th>Email</th><th>Trạng thái</th><th></th></tr></thead>
                <tbody>
                <% List<Reader> rList = (List<Reader>)request.getAttribute("readers"); if (rList == null) rList = java.util.Collections.emptyList();
                for (Reader r : rList) { %>
                <tr style="border-bottom: 1px solid var(--border);">
                    <td style="padding: 14px;"><%= r.getReaderId() %></td>
                    <td><%= r.getFullName() %></td>
                    <td><%= r.getEmail() %></td>
                    <td><%= r.getStatus() != null ? r.getStatus() : "-" %></td>
                    <td><a href="#">Chi tiết</a> | <a href="#">Khóa</a></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</body>
</html>
