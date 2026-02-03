<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Book"%>
<%@page import="model.Category"%>
<%@page import="model.Author"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Duyệt sách - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .books-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 24px; }
        .book-card { background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md); transition: all 0.3s; cursor: pointer; }
        .book-card:hover { transform: translateY(-6px); box-shadow: var(--shadow-xl); }
        .book-cover { width: 100%; height: 260px; background: var(--gradient-primary); display: flex; align-items: center; justify-content: center; color: white; font-size: 48px; }
        .book-info { padding: 16px; }
        .book-title { font-weight: 600; color: var(--text-primary); margin-bottom: 8px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .book-author { color: var(--text-secondary); font-size: 14px; margin-bottom: 6px; }
        .book-price { font-weight: 700; color: var(--primary); }
        .book-price.free { color: #10b981; }
        .filters { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 24px; align-items: center; }
        .filters select, .filters input { padding: 10px 14px; border: 1px solid var(--border); border-radius: 8px; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Duyệt sách (Mock)</h2>
            <div class="filters">
                <input type="text" placeholder="Tìm theo tên, tác giả, từ khóa..." style="min-width: 260px;">
                <select><option value="">Tất cả danh mục</option>
                    <% List<Category> catList = (List<Category>)request.getAttribute("categories"); if (catList != null) for (Category c : catList) { %>
                    <option value="<%= c.getCategoryId() %>"><%= c.getCategoryName() %></option>
                    <% } %>
                </select>
                <select><option value="">Tất cả tác giả</option>
                    <% List<Author> authList = (List<Author>)request.getAttribute("authors"); if (authList != null) for (Author a : authList) { %>
                    <option value="<%= a.getAuthorId() %>"><%= a.getAuthorName() %></option>
                    <% } %>
                </select>
                <select><option value="">Khoảng giá</option><option>Miễn phí</option><option>Dưới 50k</option><option>50k-100k</option><option>Trên 100k</option></select>
            </div>
            <div class="books-grid">
                <% List<Book> bookList = (List<Book>)request.getAttribute("books"); if (bookList == null) bookList = java.util.Collections.emptyList();
                for (Book b : bookList) { %>
                <div class="book-card" onclick="location.href='<%= request.getContextPath() %>/books/view?id=<%= b.getBookId() %>'">
                    <div class="book-cover"><i class="fas fa-book"></i></div>
                    <div class="book-info">
                        <div class="book-title"><%= b.getTitle() %></div>
                        <% if (b.getAuthor() != null) { %><div class="book-author"><%= b.getAuthor().getAuthorName() %></div><% } %>
                        <% if (b.getPrice() != null && b.getPrice().signum() > 0) { %>
                        <div class="book-price"><%= String.format("%,.0f", b.getPrice()) %> VND</div>
                        <% } else { %><div class="book-price free">Miễn phí</div><% } %>
                    </div>
                </div>
                <% } %>
            </div>
        </div>
    </section>
</body>
</html>
