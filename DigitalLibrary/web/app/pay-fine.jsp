<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Fine"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán phạt - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container" style="max-width: 520px;">
            <h2 class="section-title">Thanh toán phạt (Mock)</h2>
            <p style="color: var(--text-secondary); margin-bottom: 24px;">Chọn phạt chưa thanh toán và thanh toán.</p>
            <% List<Fine> fineList = (List<Fine>)request.getAttribute("fines"); if (fineList == null) fineList = java.util.Collections.emptyList();
            for (Fine f : fineList) {
                   if ("unpaid".equals(f.getStatus())) { %>
            <div style="padding: 16px; background: white; border-radius: 8px; margin-bottom: 12px; box-shadow: var(--shadow-sm);">
                Phạt #<%= f.getFineId() %> — <%= f.getReason() %> — <strong><%= f.getAmount() != null ? String.format("%,.0f VND", f.getAmount()) : "" %></strong>
                <button type="button" class="btn-primary" style="margin-left: 12px;">Thanh toán</button>
            </div>
            <% } } %>
            <p><a href="<%= request.getContextPath() %>/pages/fine-summary">Quay lại tổng hợp phạt</a></p>
        </div>
    </section>
</body>
</html>
