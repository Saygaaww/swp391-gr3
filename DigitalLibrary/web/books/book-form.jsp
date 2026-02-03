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
    <title><%= request.getAttribute("action") != null && request.getAttribute("action").equals("update") ? "Sửa Sách" : "Thêm Sách" %> - Digital Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .form-container {
            padding: 20px;
            max-width: 900px;
            margin: 0 auto;
        }
        
        .form-header {
            margin-bottom: 30px;
        }
        
        .form-header h1 {
            color: #1f2937;
            margin-bottom: 10px;
        }
        
        .form-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #374151;
            font-size: 14px;
        }
        
        .form-group label .required {
            color: #ef4444;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }
        
        .form-group small {
            display: block;
            margin-top: 5px;
            color: #6b7280;
            font-size: 12px;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e5e7eb;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #4b5563;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .form-actions .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <%
        Reader reader = (Reader) session.getAttribute("reader");
        Employee employee = (Employee) session.getAttribute("employee");
        String userRole = (String) session.getAttribute("userRole");
        
        if (reader == null && employee == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        boolean canManage = userRole != null && ("ADMIN".equals(userRole) || "LIBRARIAN".equals(userRole));
        if (!canManage) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }
        
        String userName = null;
        if (reader != null) {
            userName = reader.getFullName() != null ? reader.getFullName() : reader.getEmail();
        } else if (employee != null) {
            userName = employee.getFullName() != null ? employee.getFullName() : employee.getEmail();
        }
        
        Book book = (Book) request.getAttribute("book");
        List<Author> authors = (List<Author>) request.getAttribute("authors");
        List<Category> categories = (List<Category>) request.getAttribute("categories");
        String action = (String) request.getAttribute("action");
        boolean isUpdate = "update".equals(action);
        String error = (String) request.getAttribute("error");
    %>
    
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <% 
                    String dashboardPathHeader = "user";
                    if (userRole != null) {
                        switch (userRole.toUpperCase()) {
                            case "ADMIN": dashboardPathHeader = "admin"; break;
                            case "LIBRARIAN": dashboardPathHeader = "librarian"; break;
                            case "SELLER": dashboardPathHeader = "seller"; break;
                            default: dashboardPathHeader = "user"; break;
                        }
                    }
                %>
                <a href="${pageContext.request.contextPath}/<%= dashboardPathHeader %>/dashboard" style="text-decoration: none; color: inherit; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-book-reader"></i>
                    <h2>Digital Library</h2>
                </a>
            </div>
            <nav class="sidebar-nav">
                <% 
                    String dashboardPath = "user";
                    if (userRole != null) {
                        switch (userRole.toUpperCase()) {
                            case "ADMIN": dashboardPath = "admin"; break;
                            case "LIBRARIAN": dashboardPath = "librarian"; break;
                            case "SELLER": dashboardPath = "seller"; break;
                            default: dashboardPath = "user"; break;
                        }
                    }
                %>
                <a href="${pageContext.request.contextPath}/<%= dashboardPath %>/dashboard" class="nav-item">
                    <i class="fas fa-home"></i>
                    <span>Trang Chủ</span>
                </a>
                <a href="${pageContext.request.contextPath}/books" class="nav-item">
                    <i class="fas fa-book"></i>
                    <span>Danh Sách Sách</span>
                </a>
                <a href="${pageContext.request.contextPath}/books/add" class="nav-item active">
                    <i class="fas fa-plus-circle"></i>
                    <span>Thêm Sách</span>
                </a>
            </nav>
        </aside>
        
        <main class="main-content">
            <header class="dashboard-header">
                <div class="header-left">
                    <h1><%= isUpdate ? "Sửa Sách" : "Thêm Sách Mới" %></h1>
                </div>
                <div class="header-right">
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
                </div>
            </header>
            
            <div class="dashboard-content">
                <div class="form-container">
                    <div class="form-header">
                        <h1><i class="fas fa-<%= isUpdate ? "edit" : "plus-circle" %>"></i> <%= isUpdate ? "Sửa Thông Tin Sách" : "Thêm Sách Mới" %></h1>
                        <p style="color: #6b7280;">Vui lòng điền đầy đủ thông tin bên dưới</p>
                    </div>
                    
                    <% if (error != null) { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i> <%= error %>
                    </div>
                    <% } %>
                    
                    <div class="form-card">
                        <form method="POST" action="${pageContext.request.contextPath}/books/<%= isUpdate ? "edit" : "add" %>">
                            <input type="hidden" name="action" value="<%= isUpdate ? "update" : "create" %>">
                            <% if (isUpdate && book != null) { %>
                            <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                            <% } %>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="title">
                                        Tiêu đề <span class="required">*</span>
                                    </label>
                                    <input type="text" id="title" name="title" 
                                           value="<%= book != null && book.getTitle() != null ? book.getTitle() : "" %>" 
                                           required>
                                </div>
                                
                                <div class="form-group">
                                    <label for="status">Trạng thái</label>
                                    <select id="status" name="status">
                                        <option value="active" <%= book != null && "active".equals(book.getStatus()) ? "selected" : "" %>>
                                            Hoạt động
                                        </option>
                                        <option value="inactive" <%= book != null && "inactive".equals(book.getStatus()) ? "selected" : "" %>>
                                            Không hoạt động
                                        </option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="summary">Tóm tắt</label>
                                <textarea id="summary" name="summary" 
                                          placeholder="Nhập tóm tắt ngắn gọn về cuốn sách..."><%= book != null && book.getSummary() != null ? book.getSummary() : "" %></textarea>
                                <small>Tóm tắt ngắn gọn về nội dung sách (tối đa 500 ký tự)</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="description">Mô tả chi tiết</label>
                                <textarea id="description" name="description" 
                                          placeholder="Nhập mô tả chi tiết về cuốn sách..."><%= book != null && book.getDescription() != null ? book.getDescription() : "" %></textarea>
                                <small>Mô tả đầy đủ về nội dung, đặc điểm của sách</small>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="authorId">Tác giả</label>
                                    <select id="authorId" name="authorId">
                                        <option value="">-- Chọn tác giả --</option>
                                        <% if (authors != null) {
                                            for (Author author : authors) {
                                                boolean selected = book != null && book.getAuthorId() != null && book.getAuthorId() == author.getAuthorId();
                                        %>
                                        <option value="<%= author.getAuthorId() %>" <%= selected ? "selected" : "" %>>
                                            <%= author.getAuthorName() %>
                                        </option>
                                        <% }
                                        } %>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="categoryId">Danh mục</label>
                                    <select id="categoryId" name="categoryId">
                                        <option value="">-- Chọn danh mục --</option>
                                        <% if (categories != null) {
                                            for (Category category : categories) {
                                                boolean selected = book != null && book.getCategoryId() != null && book.getCategoryId() == category.getCategoryId();
                                        %>
                                        <option value="<%= category.getCategoryId() %>" <%= selected ? "selected" : "" %>>
                                            <%= category.getCategoryName() %>
                                        </option>
                                        <% }
                                        } %>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="price">Giá (VND)</label>
                                    <input type="number" id="price" name="price" 
                                           step="0.01" min="0"
                                           value="<%= book != null && book.getPrice() != null ? book.getPrice() : "" %>" 
                                           placeholder="0">
                                </div>
                                
                                <div class="form-group">
                                    <label for="currency">Đơn vị tiền tệ</label>
                                    <select id="currency" name="currency">
                                        <option value="VND" <%= book != null && "VND".equals(book.getCurrency()) ? "selected" : "selected" %>>
                                            VND
                                        </option>
                                        <option value="USD" <%= book != null && "USD".equals(book.getCurrency()) ? "selected" : "" %>>
                                            USD
                                        </option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="totalPages">Tổng số trang</label>
                                    <input type="number" id="totalPages" name="totalPages" 
                                           min="1"
                                           value="<%= book != null && book.getTotalPages() != null ? book.getTotalPages() : "" %>" 
                                           placeholder="0">
                                </div>
                                
                                <div class="form-group">
                                    <label for="previewPages">Số trang xem trước</label>
                                    <input type="number" id="previewPages" name="previewPages" 
                                           min="0"
                                           value="<%= book != null && book.getPreviewPages() != null ? book.getPreviewPages() : "" %>" 
                                           placeholder="0">
                                    <small>Số trang đầu tiên cho phép người dùng xem miễn phí</small>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="coverUrl">URL ảnh bìa</label>
                                <input type="url" id="coverUrl" name="coverUrl" 
                                       value="<%= book != null && book.getCoverUrl() != null ? book.getCoverUrl() : "" %>" 
                                       placeholder="https://example.com/book-cover.jpg">
                                <small>Link đến ảnh bìa sách (hỗ trợ URL)</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="contentPath">Đường dẫn nội dung</label>
                                <input type="text" id="contentPath" name="contentPath" 
                                       value="<%= book != null && book.getContentPath() != null ? book.getContentPath() : "" %>" 
                                       placeholder="/books/content/book-name.pdf">
                                <small>Đường dẫn đến file nội dung sách (PDF, EPUB, etc.)</small>
                            </div>
                            
                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary">
                                    <i class="fas fa-times"></i> Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-<%= isUpdate ? "save" : "plus" %>"></i> 
                                    <%= isUpdate ? "Cập Nhật" : "Thêm Sách" %>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
