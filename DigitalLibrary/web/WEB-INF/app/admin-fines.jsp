<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Fine"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xử lý phạt - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Xử lý phạt (Mock - Librarian)</h2>
            <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md);">
                <thead><tr style="background: var(--bg-tertiary);"><th style="padding: 14px;">ID</th><th>Đọc giả</th><th>Lý do</th><th>Số tiền</th><th>Trạng thái</th><th></th></tr></thead>
                <tbody>
                <% List<Fine> fList = (List<Fine>)request.getAttribute("fines"); if (fList == null) fList = java.util.Collections.emptyList();
                for (Fine f : fList) { %>
                <tr style="border-bottom: 1px solid var(--border);">
                    <td style="padding: 14px;"><%= f.getFineId() %></td>
                    <td><%= f.getReader() != null ? f.getReader().getFullName() : f.getReaderId() %></td>
                    <td><%= f.getReason() != null ? f.getReason() : "-" %></td>
                    <td><%= f.getAmount() != null ? String.format("%,.0f", f.getAmount()) : "-" %> VND</td>
                    <td><%= f.getStatus() %></td>
                    <td><a href="#">Xác nhận / Miễn</a></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</body>
</html>
