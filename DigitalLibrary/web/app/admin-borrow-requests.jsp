<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.BorrowRequest"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yêu cầu mượn - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Danh sách yêu cầu mượn (Mock - Librarian)</h2>
            <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md);">
                <thead><tr style="background: var(--bg-tertiary);"><th style="padding: 14px;">ID</th><th>Đọc giả</th><th>Ngày yêu cầu</th><th>Trạng thái</th><th></th></tr></thead>
                <tbody>
                <% List<BorrowRequest> brList = (List<BorrowRequest>)request.getAttribute("borrowRequests"); if (brList == null) brList = java.util.Collections.emptyList();
                for (BorrowRequest br : brList) { %>
                <tr style="border-bottom: 1px solid var(--border);">
                    <td style="padding: 14px;"><%= br.getRequestId() %></td>
                    <td><%= br.getReader() != null ? br.getReader().getFullName() : "Reader #" + br.getReaderId() %></td>
                    <td><%= br.getRequestedAt() != null ? br.getRequestedAt().toString() : "-" %></td>
                    <td><%= br.getStatus() %></td>
                    <td><a href="#">Duyệt</a> | <a href="#">Từ chối</a></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</body>
</html>
