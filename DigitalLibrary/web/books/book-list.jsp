<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Book"%>
<%@page import="model.Author"%>
<%@page import="model.Category"%>
<%@page import="model.Reader"%>
<%@page import="model.Employee"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Sách - Digital Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .books-container {
            padding: 20px;
        }
        
        .books-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .books-header h1 {
            margin: 0;
            color: #1f2937;
        }
        
        .search-filter-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .search-form {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr auto;
            gap: 15px;
            align-items: end;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            margin-bottom: 5px;
            font-weight: 500;
            color: #374151;
            font-size: 14px;
        }
        
        .form-group input,
        .form-group select {
            padding: 10px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn i {
            font-size: 14px;
            margin-right: 6px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            color: white;
        }
        
        .btn-danger {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        
        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .book-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }
        
        .book-cover {
            width: 100%;
            height: 300px;
            object-fit: cover;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 48px;
        }
        
        .book-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .book-info {
            padding: 20px;
        }
        
        .book-title {
            font-size: 18px;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 8px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .book-author {
            color: #6b7280;
            font-size: 14px;
            margin-bottom: 8px;
        }
        
        .book-category {
            display: inline-block;
            background: #f3f4f6;
            color: #6b7280;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            margin-bottom: 12px;
        }
        
        .book-price {
            font-size: 20px;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 15px;
        }
        
        .book-actions {
            display: flex;
            gap: 10px;
        }
        
        .book-actions .btn {
            flex: 1;
            padding: 8px 12px;
            font-size: 13px;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 30px;
        }
        
        .pagination a,
        .pagination span {
            padding: 8px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            text-decoration: none;
            color: #374151;
            transition: all 0.3s;
        }
        
        .pagination a:hover {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        
        .pagination .active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
        }
        
        .empty-state > i {
            font-size: 64px;
            margin-bottom: 20px;
            color: #d1d5db;
        }
        
        .empty-state .btn i {
            font-size: 14px;
            margin: 0;
            color: inherit;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #6ee7b7;
        }
        
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }
        
        @media (max-width: 768px) {
            .search-form {
                grid-template-columns: 1fr;
            }
            
            .books-grid {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <%
        Reader reader = (Reader) session.getAttribute("reader");
        Employee employee = (Employee) session.getAttribute("employee");
        String userRole = (String) session.getAttribute("userRole");
        boolean isGuest = (reader == null && employee == null);
        
        // Lấy userName từ reader hoặc employee
        String userName = null;
        if (!isGuest) {
            if (reader != null) {
                userName = reader.getFullName() != null ? reader.getFullName() : reader.getEmail();
            } else if (employee != null) {
                userName = employee.getFullName() != null ? employee.getFullName() : employee.getEmail();
            }
        }

        boolean canManage = userRole != null && ("ADMIN".equals(userRole) || "LIBRARIAN".equals(userRole));

        List<Book> books = (List<Book>) request.getAttribute("books");
        List<Author> authors = (List<Author>) request.getAttribute("authors");
        List<Category> categories = (List<Category>) request.getAttribute("categories");

        Integer currentPage = (Integer) request.getAttribute("currentPage");
        Integer totalPages = (Integer) request.getAttribute("totalPages");
        Integer totalBooks = (Integer) request.getAttribute("totalBooks");

        String keyword = (String) request.getAttribute("keyword");
        Integer selectedAuthorId = (Integer) request.getAttribute("authorId");
        Integer selectedCategoryId = (Integer) request.getAttribute("categoryId");

        String message = request.getParameter("message");
        String error = request.getParameter("error");
        
        // Xác định dashboard path theo role
        String dashboardPath = "user"; // default
        if (userRole != null) {
            switch (userRole.toUpperCase()) {
                case "ADMIN":
                    dashboardPath = "admin";
                    break;
                case "LIBRARIAN":
                    dashboardPath = "librarian";
                    break;
                case "SELLER":
                    dashboardPath = "seller";
                    break;
                case "USER":
                default:
                    dashboardPath = "user";
                    break;
            }
        }
    %>
    
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <% if (!isGuest) { %>
                <a href="${pageContext.request.contextPath}/<%= dashboardPath %>/dashboard" style="text-decoration: none; color: inherit; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-book-reader"></i>
                    <h2>Digital Library</h2>
                </a>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/" style="text-decoration: none; color: inherit; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-book-reader"></i>
                    <h2>Digital Library</h2>
                </a>
                <% } %>
            </div>
            <nav class="sidebar-nav">
                <% if (!isGuest) { %>
                <a href="${pageContext.request.contextPath}/<%= dashboardPath %>/dashboard" class="nav-item">
                    <i class="fas fa-home"></i>
                    <span>Trang Chủ</span>
                </a>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/" class="nav-item">
                    <i class="fas fa-home"></i>
                    <span>Trang Chủ</span>
                </a>
                <% } %>
                <a href="${pageContext.request.contextPath}/books" class="nav-item active">
                    <i class="fas fa-book"></i>
                    <span><%= isGuest ? "Sách Miễn Phí" : "Danh Sách Sách" %></span>
                </a>
                <% if (canManage) { %>
                <a href="${pageContext.request.contextPath}/books/add" class="nav-item">
                    <i class="fas fa-plus-circle"></i>
                    <span>Thêm Sách</span>
                </a>
                <% } %>
                <% if (isGuest) { %>
                <div class="guest-notice" style="padding: 20px; margin: 20px 0; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 8px; text-align: center;">
                    <i class="fas fa-info-circle" style="font-size: 24px; margin-bottom: 10px;"></i>
                    <p style="margin: 0; font-size: 14px;">Đăng nhập để xem tất cả sách và mượn sách</p>
                    <a href="${pageContext.request.contextPath}/login" style="color: white; text-decoration: underline; font-weight: 500;">Đăng nhập ngay</a>
                </div>
                <% } %>
            </nav>
        </aside>
        
        <main class="main-content">
            <header class="dashboard-header">
                <div class="header-left">
                    <h1>Danh Sách Sách</h1>
                </div>
                <div class="header-right">
                    <% if (!isGuest) { %>
                    <div class="user-menu">
                        <div class="user-info">
                            <i class="fas fa-user-circle"></i>
                            <span><%= userName != null ? userName : "Người Dùng" %></span>
                        </div>
                        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                            <i class="fas fa-sign-out-alt"></i>
                            Đăng Xuất
                        </a>
                    </div>
                    <% } else { %>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                        <i class="fas fa-sign-in-alt"></i>
                        Đăng Nhập
                    </a>
                    <% } %>
                </div>
            </header>
            
            <div class="dashboard-content">
                <div class="books-container">
                    <div class="books-header">
                        <div>
                            <h1><i class="fas fa-book"></i> <%= isGuest ? "Sách Miễn Phí" : "Thư Viện Sách" %></h1>
                            <% if (isGuest) { %>
                            <p style="color: #6b7280; margin: 5px 0 0 0; font-size: 14px;">
                                Khám phá kho sách miễn phí - Đăng nhập để xem thêm sách và mượn sách
                            </p>
                            <% } %>
                        </div>
                        <% if (canManage) { %>
                        <a href="${pageContext.request.contextPath}/books/add" class="btn btn-success">
                            <i class="fas fa-plus"></i> Thêm Sách Mới
                        </a>
                        <% } %>
                        <% if (isGuest) { %>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                            <i class="fas fa-sign-in-alt"></i> Đăng Nhập Để Xem Thêm
                        </a>
                        <% } %>
                    </div>
                    
                    <% if (message != null && message.equals("delete_success")) { %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> Xóa sách thành công!
                    </div>
                    <% } %>
                    
                    <% if (error != null && error.equals("delete_failed")) { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i> Không thể xóa sách. Vui lòng thử lại.
                    </div>
                    <% } %>
                    
                    <div class="search-filter-section">
                        <form method="GET" action="${pageContext.request.contextPath}/books/search" class="search-form">
                            <div class="form-group">
                                <label for="keyword"><i class="fas fa-search"></i> Tìm kiếm</label>
                                <input type="text" id="keyword" name="keyword" 
                                       placeholder="Tìm theo tiêu đề, tác giả..." 
                                       value="<%= keyword != null ? keyword : "" %>">
                            </div>
                            
                            <div class="form-group">
                                <label for="authorId"><i class="fas fa-user"></i> Tác giả</label>
                                <select id="authorId" name="authorId">
                                    <option value="">Tất cả tác giả</option>
                                    <% if (authors != null) {
                                        for (Author author : authors) {
                                            boolean selected = selectedAuthorId != null && selectedAuthorId == author.getAuthorId();
                                    %>
                                    <option value="<%= author.getAuthorId() %>" <%= selected ? "selected" : "" %>>
                                        <%= author.getAuthorName() %>
                                    </option>
                                    <% }
                                    } %>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="categoryId"><i class="fas fa-tags"></i> Danh mục</label>
                                <select id="categoryId" name="categoryId">
                                    <option value="">Tất cả danh mục</option>
                                    <% if (categories != null) {
                                        for (Category category : categories) {
                                            boolean selected = selectedCategoryId != null && selectedCategoryId == category.getCategoryId();
                                    %>
                                    <option value="<%= category.getCategoryId() %>" <%= selected ? "selected" : "" %>>
                                        <%= category.getCategoryName() %>
                                    </option>
                                    <% }
                                    } %>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label>&nbsp;</label>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Tìm Kiếm
                                </button>
                            </div>
                        </form>
                    </div>
                    
                    <% if (books != null && !books.isEmpty()) { %>
                        <% if (totalBooks != null) { %>
                        <p style="color: #6b7280; margin-bottom: 20px;">
                            Tìm thấy <strong><%= totalBooks %></strong> cuốn sách
                        </p>
                        <% } %>
                        
                        <div class="books-grid">
                            <% for (Book book : books) { %>
                            <div class="book-card" onclick="window.location.href='${pageContext.request.contextPath}/books/view?id=<%= book.getBookId() %>'">
                                <div class="book-cover">
                                    <% if (book.getCoverUrl() != null && !book.getCoverUrl().isEmpty()) { %>
                                    <img src="<%= book.getCoverUrl() %>" alt="<%= book.getTitle() %>">
                                    <% } else { %>
                                    <i class="fas fa-book"></i>
                                    <% } %>
                                </div>
                                <div class="book-info">
                                    <div class="book-title"><%= book.getTitle() %></div>
                                    <% if (book.getAuthor() != null) { %>
                                    <div class="book-author">
                                        <i class="fas fa-user"></i> <%= book.getAuthor().getAuthorName() %>
                                    </div>
                                    <% } %>
                                    <% if (book.getCategory() != null) { %>
                                    <span class="book-category"><%= book.getCategory().getCategoryName() %></span>
                                    <% } %>
                                    <% if (book.getPrice() != null) { %>
                                    <div class="book-price">
                                        <%= String.format("%,.0f", book.getPrice()) %> 
                                        <%= book.getCurrency() != null ? book.getCurrency() : "VND" %>
                                    </div>
                                    <% } %>
                                    <div class="book-actions" onclick="event.stopPropagation();">
                                        <a href="${pageContext.request.contextPath}/books/view?id=<%= book.getBookId() %>" 
                                           class="btn btn-primary">
                                            <i class="fas fa-eye"></i> Xem
                                        </a>
                                        <% if (!isGuest && book.getPrice() != null && book.getPrice().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                                            <% if ("SELLER".equals(userRole)) { %>
                                            <form method="POST" action="${pageContext.request.contextPath}/seller/cart/add" style="display: inline;">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                                                <input type="hidden" name="quantity" value="1">
                                                <button type="submit" class="btn btn-success" style="padding: 8px 12px; font-size: 13px;">
                                                    <i class="fas fa-cart-plus"></i> Thêm (Bán)
                                                </button>
                                            </form>
                                            <% } else { %>
                                            <form method="POST" action="${pageContext.request.contextPath}/cart/add" style="display: inline;">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                                                <input type="hidden" name="quantity" value="1">
                                                <input type="hidden" name="redirect" value="/books">
                                                <button type="submit" class="btn btn-success" style="padding: 8px 12px; font-size: 13px;">
                                                    <i class="fas fa-cart-plus"></i> Thêm Vào Giỏ
                                                </button>
                                            </form>
                                            <% } %>
                                        <% } %>
                                        <% if (canManage) { %>
                                        <a href="${pageContext.request.contextPath}/books/edit?id=<%= book.getBookId() %>" 
                                           class="btn btn-secondary">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/books/delete?id=<%= book.getBookId() %>" 
                                           class="btn btn-danger"
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa sách này?');">
                                            <i class="fas fa-trash"></i>
                                        </a>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                        
                        <% if (currentPage != null && totalPages != null && totalPages > 1) { %>
                        <div class="pagination">
                            <% if (currentPage > 1) { %>
                            <a href="${pageContext.request.contextPath}/books?page=<%= currentPage - 1 %>">
                                <i class="fas fa-chevron-left"></i> Trước
                            </a>
                            <% } %>
                            
                            <% for (int i = 1; i <= totalPages; i++) {
                                if (i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)) {
                            %>
                            <a href="${pageContext.request.contextPath}/books?page=<%= i %>" 
                               class="<%= i == currentPage ? "active" : "" %>">
                                <%= i %>
                            </a>
                            <% } else if (i == currentPage - 3 || i == currentPage + 3) { %>
                            <span>...</span>
                            <% }
                            } %>
                            
                            <% if (currentPage < totalPages) { %>
                            <a href="${pageContext.request.contextPath}/books?page=<%= currentPage + 1 %>">
                                Sau <i class="fas fa-chevron-right"></i>
                            </a>
                            <% } %>
                        </div>
                        <% } %>
                    <% } else { %>
                        <div class="empty-state">
                            <i class="fas fa-book-open"></i>
                            <h3>Không tìm thấy sách nào</h3>
                            <% if (isGuest) { %>
                                <p>Hiện tại chưa có sách miễn phí nào. Vui lòng đăng nhập để xem tất cả sách.</p>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary" style="margin-top: 20px;">
                                    <i class="fas fa-sign-in-alt"></i> Đăng Nhập Để Xem Sách
                                </a>
                            <% } else { %>
                                <p>Vui lòng thử lại với từ khóa khác hoặc thêm sách mới.</p>
                                <% if (canManage) { %>
                                <a href="${pageContext.request.contextPath}/books/add" class="btn btn-success" style="margin-top: 20px;">
                                    <i class="fas fa-plus"></i> Thêm Sách Đầu Tiên
                                </a>
                                <% } %>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
