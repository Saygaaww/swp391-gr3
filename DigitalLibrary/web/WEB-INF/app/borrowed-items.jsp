<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Borrow"%>
<%@page import="model.BorrowItem"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sách đang mượn - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .borrow-table { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md); }
        .borrow-table th, .borrow-table td { padding: 14px 18px; border-bottom: 1px solid var(--border); }
        .borrow-table th { background: var(--bg-tertiary); }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Sách đang mượn (Mock) - Borrow, Borrow_Item</h2>
            <% List<BorrowItem> items = (List<BorrowItem>) request.getAttribute("borrowItems");
               if (items != null && !items.isEmpty()) { %>
            <table class="borrow-table">
                <thead><tr><th>Bản copy</th><th>Hạn trả</th><th>Trạng thái</th><th></th></tr></thead>
                <tbody>
                <% for (BorrowItem bi : items) { %>
                <tr>
                    <td><%= bi.getBookCopy() != null ? bi.getBookCopy().getCopyCode() : "Copy #" + bi.getCopyId() %></td>
                    <td><%= bi.getDueDate() != null ? bi.getDueDate().toString() : "-" %></td>
                    <td><%= bi.getStatus() != null ? bi.getStatus() : "-" %></td>
                    <td><a href="<%= request.getContextPath() %>/pages/extend-request">Gia hạn</a> | <a href="#">Trả sách</a></td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } else { %>
            <p style="text-align: center; color: var(--text-secondary);">Không có sách đang mượn.</p>
            <p style="text-align: center;"><a href="<%= request.getContextPath() %>/pages/borrow-request" class="btn-primary">Tạo yêu cầu mượn</a></p>
            <% } %>
        </div>
    </section>
</body>
</html>
