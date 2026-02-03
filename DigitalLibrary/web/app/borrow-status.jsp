<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.BorrowRequest"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trạng thái yêu cầu mượn - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Trạng thái yêu cầu mượn (Mock)</h2>
            <p style="color: var(--text-secondary); margin-bottom: 24px;">pending / approved / rejected / cancelled / expired</p>
            <% List<BorrowRequest> brList = (List<BorrowRequest>)request.getAttribute("borrowRequests"); if (brList == null) brList = java.util.Collections.emptyList();
            for (BorrowRequest br : brList) { %>
            <div style="padding: 16px; background: white; border-radius: 8px; margin-bottom: 12px; box-shadow: var(--shadow-sm);">
                <strong>Yêu cầu #<%= br.getRequestId() %></strong> — Trạng thái: <span style="color: var(--primary);"><%= br.getStatus() %></span><br>
                Ngày yêu cầu: <%= br.getRequestedAt() != null ? br.getRequestedAt().toString() : "-" %><br>
                <% if (br.getDecisionNote() != null && !br.getDecisionNote().isEmpty()) { %>Ghi chú thủ thư: <%= br.getDecisionNote() %><% } %>
            </div>
            <% } %>
        </div>
    </section>
</body>
</html>
