<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Book"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý sách - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Quản lý sách (Mock) - Book Management</h2>
            <p><a href="<%= request.getContextPath() %>/books/book-form.jsp" class="btn-primary">Thêm sách</a></p>
            <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md); margin-top: 16px;">
                <thead><tr style="background: var(--bg-tertiary);"><th style="padding: 14px;">ID</th><th>Tên sách</th><th>Tác giả</th><th>Danh mục</th><th>Giá</th><th>Trạng thái</th><th></th></tr></thead>
                <tbody>
                <% List<Book> bList = (List<Book>)request.getAttribute("books"); if (bList == null) bList = java.util.Collections.emptyList();
                for (Book b : bList) { %>
                <tr style="border-bottom: 1px solid var(--border);">
                    <td style="padding: 14px;"><%= b.getBookId() %></td>
                    <td><%= b.getTitle() %></td>
                    <td><%= b.getAuthor() != null ? b.getAuthor().getAuthorName() : "-" %></td>
                    <td><%= b.getCategory() != null ? b.getCategory().getCategoryName() : "-" %></td>
                    <td><%= b.getPrice() != null ? String.format("%,.0f", b.getPrice()) : "0" %> VND</td>
                    <td><%= b.getStatus() != null ? b.getStatus() : "-" %></td>
                    <td><a href="<%= request.getContextPath() %>/books/view?id=<%= b.getBookId() %>">Xem</a> | <a href="<%= request.getContextPath() %>/books/edit?id=<%= b.getBookId() %>">Sửa</a></td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </section>
</body>
</html>
