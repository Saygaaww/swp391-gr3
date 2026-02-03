<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Category"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý danh mục - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Quản lý danh mục (Mock - Librarian/Seller)</h2>
            <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md);">
                <thead><tr style="background: var(--bg-tertiary);"><th style="padding: 14px;">ID</th><th>Tên</th><th>Mô tả</th><th></th></tr></thead>
                <tbody>
                <% List<Category> cList = (List<Category>)request.getAttribute("categories"); if (cList == null) cList = java.util.Collections.emptyList();
                for (Category c : cList) { %>
                <tr style="border-bottom: 1px solid var(--border);">
                    <td style="padding: 14px;"><%= c.getCategoryId() %></td>
                    <td><%= c.getCategoryName() %></td>
                    <td><%= c.getDescription() != null ? c.getDescription() : "-" %></td>
                    <td><a href="#">Sửa</a></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</body>
</html>
