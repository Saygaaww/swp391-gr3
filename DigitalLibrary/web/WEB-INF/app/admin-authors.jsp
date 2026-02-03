<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Author"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tác giả - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Quản lý tác giả (Mock - Librarian/Seller)</h2>
            <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md);">
                <thead><tr style="background: var(--bg-tertiary);"><th style="padding: 14px;">ID</th><th>Tên</th><th>Tiểu sử</th><th></th></tr></thead>
                <tbody>
                <% List<Author> aList = (List<Author>)request.getAttribute("authors"); if (aList == null) aList = java.util.Collections.emptyList();
                for (Author a : aList) { %>
                <tr style="border-bottom: 1px solid var(--border);">
                    <td style="padding: 14px;"><%= a.getAuthorId() %></td>
                    <td><%= a.getAuthorName() %></td>
                    <td><%= a.getBio() != null ? (a.getBio().length() > 50 ? a.getBio().substring(0, 50) + "..." : a.getBio()) : "-" %></td>
                    <td><a href="#">Sửa</a></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</body>
</html>
