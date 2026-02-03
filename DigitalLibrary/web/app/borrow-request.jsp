<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Book"%>
<%@page import="model.BorrowRequest"%>
<%@page import="model.Book"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yêu cầu mượn sách - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Tạo yêu cầu mượn sách (Mock) - Borrow_Request, Borrow_Request_Item</h2>
            <p style="color: var(--text-secondary); margin-bottom: 24px;">Chọn sách cần mượn và gửi yêu cầu.</p>
            <form action="#" method="post" style="margin-bottom: 24px;">
                <p><label><input type="checkbox" name="bookId" value="6"> Clean Code</label></p>
                <p><label><input type="checkbox" name="bookId" value="3"> Atomic Habits</label></p>
                <p><label>Ghi chú: <input type="text" name="note" placeholder="Mượn tham khảo" style="padding: 8px; width: 300px;"></label></p>
                <button type="submit" class="btn-primary">Gửi yêu cầu mượn</button>
            </form>
            <h3>Yêu cầu gần đây</h3>
            <% List<BorrowRequest> brList = (List<BorrowRequest>)request.getAttribute("borrowRequests"); if (brList == null) brList = java.util.Collections.emptyList();
            for (BorrowRequest br : brList) { %>
            <p>#<%= br.getRequestId() %> — <%= br.getStatus() %> — <%= br.getRequestedAt() != null ? br.getRequestedAt().toString() : "" %></p>
            <% } %>
        </div>
    </section>
</body>
</html>
