<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.FineType"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loại phạt - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Quản lý loại phạt (Mock - Admin/Librarian)</h2>
            <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md);">
                <thead><tr style="background: var(--bg-tertiary);"><th style="padding: 14px;">ID</th><th>Tên</th><th>Mô tả</th><th>Số tiền mặc định</th><th>Phí/ngày</th></tr></thead>
                <tbody>
                <% List<FineType> ftList = (List<FineType>)request.getAttribute("fineTypes"); if (ftList == null) ftList = java.util.Collections.emptyList();
                for (FineType ft : ftList) { %>
                <tr style="border-bottom: 1px solid var(--border);">
                    <td style="padding: 14px;"><%= ft.getFineTypeId() %></td>
                    <td><%= ft.getName() %></td>
                    <td><%= ft.getDescription() != null ? ft.getDescription() : "-" %></td>
                    <td><%= ft.getDefaultAmount() != null ? String.format("%,.0f", ft.getDefaultAmount()) : "-" %></td>
                    <td><%= ft.getPerDayRate() != null ? String.format("%,.0f", ft.getPerDayRate()) : "-" %></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</body>
</html>
