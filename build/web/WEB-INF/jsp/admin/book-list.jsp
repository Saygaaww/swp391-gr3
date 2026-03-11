<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="model.Book, model.Category, model.Author, model.Employee, util.AuthUtil" %>
        <%@ page import="java.util.List" %>
            <% Employee currentAdmin=(Employee) session.getAttribute(AuthUtil.SESSION_USER); if(currentAdmin==null) {
                response.sendRedirect(request.getContextPath() + "/auth/login" ); return; } %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Quản lý Sách - Admin Control Panel</title>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                    <style>
                        *,
                        *::before,
                        *::after {
                            box-sizing: border-box;
                            margin: 0;
                            padding: 0;
                        }

                        body {
                            font-family: 'Inter', sans-serif;
                            background: #f4f7fe;
                            color: #111827;
                            min-height: 100vh;
                            padding: 24px;
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                        }

                        .container {
                            width: 100%;
                            max-width: 1200px;
                        }

                        /* Top Bar */
                        .top-bar {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 24px;
                        }

                        .back-btn {
                            display: inline-flex;
                            align-items: center;
                            gap: 8px;
                            color: #4b5563;
                            text-decoration: none;
                            font-weight: 500;
                            background: #fff;
                            padding: 8px 16px;
                            border-radius: 8px;
                            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                            transition: all 0.2s;
                        }

                        .back-btn:hover {
                            color: #111827;
                            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                        }

                        .page-title {
                            font-size: 1.5rem;
                            font-weight: 700;
                        }

                        /* Content Panel */
                        .content-panel {
                            background: #fff;
                            border-radius: 16px;
                            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                            padding: 24px;
                        }

                        .toolbar {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 24px;
                            flex-wrap: wrap;
                            gap: 16px;
                        }

                        .toolbar-actions {
                            display: flex;
                            gap: 12px;
                        }

                        .btn-primary {
                            background: #4f46e5;
                            color: white;
                            border: none;
                            padding: 10px 20px;
                            border-radius: 8px;
                            font-weight: 500;
                            cursor: pointer;
                            text-decoration: none;
                            display: inline-flex;
                            align-items: center;
                            gap: 8px;
                            transition: background 0.2s;
                        }

                        .btn-primary:hover {
                            background: #4338ca;
                        }

                        /* Filter Form */
                        .filter-form {
                            display: flex;
                            gap: 12px;
                            flex-wrap: wrap;
                        }

                        .filter-form input,
                        .filter-form select {
                            padding: 8px 12px;
                            border: 1px solid #d1d5db;
                            border-radius: 6px;
                            outline: none;
                            font-family: inherit;
                        }

                        .filter-form button {
                            background: #f3f4f6;
                            border: 1px solid #d1d5db;
                            padding: 8px 16px;
                            border-radius: 6px;
                            cursor: pointer;
                            font-weight: 500;
                        }

                        .filter-form button:hover {
                            background: #e5e7eb;
                        }

                        /* Table */
                        .table-container {
                            overflow-x: auto;
                        }

                        table {
                            width: 100%;
                            border-collapse: collapse;
                        }

                        th,
                        td {
                            padding: 12px 16px;
                            text-align: left;
                            border-bottom: 1px solid #e5e7eb;
                        }

                        th {
                            background: #f9fafb;
                            font-weight: 600;
                            color: #4b5563;
                            font-size: 0.85rem;
                            text-transform: uppercase;
                        }

                        td {
                            color: #111827;
                            font-size: 0.95rem;
                        }

                        .actions-cell {
                            display: flex;
                            gap: 10px;
                        }

                        .btn-action {
                            width: 32px;
                            height: 32px;
                            border-radius: 6px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            text-decoration: none;
                            color: white;
                            transition: opacity 0.2s;
                        }

                        .btn-action:hover {
                            opacity: 0.8;
                        }

                        .edit-btn {
                            background: #3b82f6;
                        }

                        .delete-btn {
                            background: #ef4444;
                        }

                        /* Pagination */
                        .pagination {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-top: 24px;
                            padding-top: 16px;
                            border-top: 1px solid #e5e7eb;
                        }

                        .page-info {
                            color: #6b7280;
                            font-size: 0.9rem;
                        }

                        .page-buttons {
                            display: flex;
                            gap: 8px;
                        }

                        .page-btn {
                            padding: 6px 12px;
                            border: 1px solid #d1d5db;
                            background: #fff;
                            border-radius: 6px;
                            color: #374151;
                            text-decoration: none;
                            transition: all 0.2s;
                        }

                        .page-btn.active {
                            background: #4f46e5;
                            color: white;
                            border-color: #4f46e5;
                        }

                        .page-btn:hover:not(.active) {
                            background: #f3f4f6;
                        }

                        .alert {
                            padding: 12px 16px;
                            border-radius: 8px;
                            margin-bottom: 20px;
                        }

                        .alert-success {
                            background: #dcfce3;
                            color: #16a34a;
                        }

                        .alert-error {
                            background: #fee2e2;
                            color: #dc2626;
                        }
                    </style>
                </head>

                <body>
                    <div class="container">
                        <!-- Top Bar -->
                        <div class="top-bar">
                            <a href="<%= request.getContextPath() %>/admin/dashboard" class="back-btn">
                                <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                            </a>
                            <h1 class="page-title">Quản lý Sách</h1>
                            <div style="width: 140px;"></div> <!-- Spacer -->
                        </div>

                        <% if (request.getAttribute("message") !=null) { %>
                            <div class="alert alert-success">
                                <i class="fas fa-check-circle"></i>
                                <%= request.getAttribute("message") %>
                            </div>
                            <% } %>

                                <% if (request.getAttribute("errorMessage") !=null) { %>
                                    <div class="alert alert-error">
                                        <i class="fas fa-exclamation-circle"></i>
                                        <%= request.getAttribute("errorMessage") %>
                                    </div>
                                    <% } %>

                                        <div class="content-panel">
                                            <div class="toolbar">
                                                <form action="<%= request.getContextPath() %>/admin/book-list" method="GET"
                                                    class="filter-form">
                                                    <input type="text" name="keyword" placeholder="Tìm kiếm sách..."
                                                        value="<%= request.getAttribute(" keyword") !=null ?
                                                        request.getAttribute("keyword") : "" %>">

                                                    <select name="categoryId">
                                                        <option value="">Tất cả danh mục</option>
                                                        <% List<Category> cats = (List<Category>)
                                                                request.getAttribute("categories");
                                                                Integer filterCat = (Integer)
                                                                request.getAttribute("filterCategoryId");
                                                                if(cats != null) {
                                                                for(Category c : cats) {
                                                                %>
                                                                <option value="<%= c.getId() %>" <%=filterCat !=null &&
                                                                    filterCat==c.getId() ? "selected" : "" %>><%=
                                                                        c.getName() %>
                                                                </option>
                                                                <% } } %>
                                                    </select>

                                                    <button type="submit"><i class="fas fa-search"></i> Lọc</button>
                                                    <a href="<%= request.getContextPath() %>/admin/book-list"
                                                        class="btn-primary"
                                                        style="background:#6b7280; padding: 8px 16px;"><i
                                                            class="fas fa-redo"></i> Đặt lại</a>
                                                </form>

                                                <div class="toolbar-actions">
                                                    <a href="<%= request.getContextPath() %>/admin/book-form"
                                                        class="btn-primary">
                                                        <i class="fas fa-plus"></i> Thêm Sách Mới
                                                    </a>
                                                </div>
                                            </div>

                                            <div class="table-container">
                                                <table>
                                                    <thead>
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Ảnh</th>
                                                            <th>Tên sách</th>
                                                            <th>Tác giả</th>
                                                            <th>Danh mục</th>
                                                            <th>Số lượng</th>
                                                            <th>Hành động</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <% List<Book> books = (List<Book>)
                                                                request.getAttribute("bookList");
                                                                if(books != null && !books.isEmpty()) {
                                                                for(Book b : books) {
                                                                %>
                                                                <tr>
                                                                    <td>
                                                                        <%= b.getId() %>
                                                                    </td>
                                                                    <td>
                                                                        <% if(b.getImageUrl() !=null &&
                                                                            !b.getImageUrl().isEmpty()) { %>
                                                                            <img src="<%= request.getContextPath() %>/<%= b.getImageUrl() %>"
                                                                                alt="Book cover"
                                                                                style="width: 40px; height: 60px; object-fit: cover; border-radius: 4px;">
                                                                            <% } else { %>
                                                                                <div
                                                                                    style="width: 40px; height: 60px; background: #e5e7eb; border-radius: 4px; display: flex; align-items: center; justify-content: center; font-size: 10px; color: #9ca3af;">
                                                                                    No img</div>
                                                                                <% } %>
                                                                    </td>
                                                                    <td style="font-weight: 500;">
                                                                        <%= b.getTitle() %>
                                                                    </td>
                                                                    <td>
                                                                        <%= b.getAuthor() !=null ?
                                                                            b.getAuthor().getName() : "Không rõ" %>
                                                                    </td>
                                                                    <td>
                                                                        <%= b.getCategory() !=null ?
                                                                            b.getCategory().getName() : "Không rõ" %>
                                                                    </td>
                                                                    <td>
                                                                        <span
                                                                            style="background: #e0e7ff; color: #4338ca; padding: 4px 8px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">
                                                                            <%= b.getQuantity() %> cuốn
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <div class="actions-cell">
                                                                            <a href="<%= request.getContextPath() %>/admin/book-form?id=<%= b.getId() %>"
                                                                                class="btn-action edit-btn"
                                                                                title="Chỉnh sửa"><i
                                                                                    class="fas fa-pen"></i></a>
                                                                            <a href="<%= request.getContextPath() %>/admin/book-delete?id=<%= b.getId() %>"
                                                                                class="btn-action delete-btn"
                                                                                title="Xóa"
                                                                                onclick="return confirm('Bạn có chắc chắn muốn xóa sách này không?');"><i
                                                                                    class="fas fa-trash"></i></a>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                                <% } } else { %>
                                                                    <tr>
                                                                        <td colspan="7"
                                                                            style="text-align: center; padding: 40px 0; color: #6b7280;">
                                                                            Không tìm thấy sách nào trong hệ thống.</td>
                                                                    </tr>
                                                                    <% } %>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <!-- Pagination -->
                                            <% Integer totalPages=(Integer) request.getAttribute("totalPages"); Integer
                                                currentPageId=(Integer) request.getAttribute("currentPage");
                                                if(totalPages !=null && totalPages> 1) {
                                                %>
                                                <div class="pagination">
                                                    <div class="page-info">
                                                        Đang hiển thị trang <%= currentPageId %> trên tổng <%=
                                                                totalPages %> trang
                                                    </div>
                                                    <div class="page-buttons">
                                                        <% if(currentPageId> 1) { %>
                                                            <a href="?page=<%= currentPageId - 1 %>&keyword=<%= request.getParameter("
                                                                keyword")!=null?request.getParameter("keyword"):""
                                                                %>&categoryId=<%=
                                                                    request.getParameter("categoryId")!=null?request.getParameter("categoryId"):""
                                                                    %>" class="page-btn"><i
                                                                        class="fas fa-chevron-left"></i></a>
                                                            <% } %>

                                                                <% for(int i=1; i<=totalPages; i++) { %>
                                                                    <a href="?page=<%= i %>&keyword=<%= request.getParameter("
                                                                        keyword")!=null?request.getParameter("keyword"):""
                                                                        %>&categoryId=<%=
                                                                            request.getParameter("categoryId")!=null?request.getParameter("categoryId"):""
                                                                            %>" class="page-btn <%= i==currentPageId
                                                                                ? "active" : "" %>"><%= i %></a>
                                                                    <% } %>

                                                                        <% if(currentPageId < totalPages) { %>
                                                                            <a href="?page=<%= currentPageId + 1 %>&keyword=<%= request.getParameter("
                                                                                keyword")!=null?request.getParameter("keyword"):""
                                                                                %>&categoryId=<%=
                                                                                    request.getParameter("categoryId")!=null?request.getParameter("categoryId"):""
                                                                                    %>" class="page-btn"><i
                                                                                        class="fas fa-chevron-right"></i></a>
                                                                            <% } %>
                                                    </div>
                                                </div>
                                                <% } %>
                                        </div>
                    </div>
                </body>

                </html>
