<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.BorrowExtend"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gia hạn mượn - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Yêu cầu gia hạn mượn (Mock) - Borrow_Extend</h2>
            <p style="color: var(--text-secondary); margin-bottom: 24px;">Trạng thái: pending / approved / rejected</p>
            <% List<BorrowExtend> extList = (List<BorrowExtend>)request.getAttribute("borrowExtends"); if (extList == null) extList = java.util.Collections.emptyList();
            for (BorrowExtend be : extList) { %>
            <div style="padding: 16px; background: white; border-radius: 8px; margin-bottom: 12px; box-shadow: var(--shadow-sm);">
                Yêu cầu #<%= be.getExtendId() %> — Hạn cũ: <%= be.getOldDueDate() %> → Hạn mới yêu cầu: <%= be.getRequestedDueDate() %> — <strong><%= be.getStatus() %></strong>
            </div>
            <% } %>
            <p><a href="<%= request.getContextPath() %>/pages/borrowed-items">Quay lại sách đang mượn</a></p>
        </div>
    </section>
</body>
</html>
