<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Book"%>
<%@page import="model.Reader"%>
<%@page import="model.Employee"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Sách - Digital Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .book-detail-container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .book-detail-content {
            display: grid;
            grid-template-columns: 400px 1fr;
            gap: 40px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 30px;
        }
        
        .book-cover-large {
            width: 100%;
            height: 500px;
            object-fit: cover;
            border-radius: 8px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 64px;
        }
        
        .book-cover-large img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .book-info-detail {
            flex: 1;
        }
        
        .book-title-detail {
            font-size: 32px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 15px;
        }
        
        .book-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 20px;
            color: #6b7280;
        }
        
        .book-meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .book-price-detail {
            font-size: 28px;
            font-weight: 700;
            color: #667eea;
            margin: 20px 0;
        }
        
        .book-description {
            margin-top: 30px;
            line-height: 1.8;
            color: #374151;
        }
        
        .book-description h3 {
            color: #1f2937;
            margin-bottom: 15px;
        }
        
        .book-actions-detail {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
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
        
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(67, 233, 123, 0.4);
        }
        
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #4b5563;
        }
        
        .category-badge {
            display: inline-block;
            background: #f3f4f6;
            color: #6b7280;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
        }
        
        @media (max-width: 968px) {
            .book-detail-content {
                grid-template-columns: 1fr;
            }
            
            .book-cover-large {
                height: 400px;
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
        
        String userName = null;
        if (reader != null) {
            userName = reader.getFullName() != null ? reader.getFullName() : reader.getEmail();
        } else if (employee != null) {
            userName = employee.getFullName() != null ? employee.getFullName() : employee.getEmail();
        }
        
        boolean canManage = userRole != null && ("ADMIN".equals(userRole) || "LIBRARIAN".equals(userRole));
        
        Book book = (Book) request.getAttribute("book");
    %>
    
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <% 
                    String dashboardPathDetail = "user";
                    if (!isGuest && userRole != null) {
                        switch (userRole.toUpperCase()) {
                            case "ADMIN": dashboardPathDetail = "admin"; break;
                            case "LIBRARIAN": dashboardPathDetail = "librarian"; break;
                            case "SELLER": dashboardPathDetail = "seller"; break;
                            default: dashboardPathDetail = "user"; break;
                        }
                    }
                %>
                <% if (!isGuest) { %>
                <a href="${pageContext.request.contextPath}/<%= dashboardPathDetail %>/dashboard" style="text-decoration: none; color: inherit; display: flex; align-items: center; gap: 10px;">
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
                <% if (!isGuest) { 
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
                <% } %>
                <a href="${pageContext.request.contextPath}/books" class="nav-item active">
                    <i class="fas fa-book"></i>
                    <span>Danh Sách Sách</span>
                </a>
                <% if (!isGuest) { %>
                <a href="${pageContext.request.contextPath}/cart" class="nav-item">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Giỏ Hàng</span>
                </a>
                <% } %>
            </nav>
        </aside>
        
        <main class="main-content">
            <header class="dashboard-header">
                <div class="header-left">
                    <h1>Chi Tiết Sách</h1>
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
                <div class="book-detail-container">
                    <%
                        String error = request.getParameter("error");
                        String message = request.getParameter("message");
                    %>
                    
                    <% if (error != null) { %>
                    <div class="alert alert-error" style="margin-bottom: 20px; padding: 15px 20px; border-radius: 8px; background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5;">
                        <i class="fas fa-exclamation-circle"></i>
                        <% if (error.equals("out_of_stock")) { %>
                            <strong>Sách này đã hết hàng!</strong> Không thể thêm vào giỏ hàng.
                        <% } else if (error.startsWith("insufficient_stock")) { 
                            String available = request.getParameter("available");
                            String inCart = request.getParameter("in_cart");
                        %>
                            <strong>Số lượng vượt quá tồn kho!</strong><br>
                            <% if (available != null) { %>
                                Tồn kho hiện có: <strong><%= available %> cuốn</strong>
                                <% if (inCart != null) { %>
                                    <br>Bạn đã có <strong><%= inCart %> cuốn</strong> trong giỏ hàng.
                                    <br>Tổng số lượng yêu cầu vượt quá tồn kho. Vui lòng giảm số lượng hoặc xóa sản phẩm khỏi giỏ hàng trước.
                                <% } else { %>
                                    <br>Vui lòng chọn số lượng nhỏ hơn hoặc bằng <%= available %>.
                                <% } %>
                            <% } else { %>
                                Vui lòng chọn số lượng phù hợp với tồn kho.
                            <% } %>
                        <% } else if (error.equals("book_not_found")) { %>
                            Không tìm thấy sách này!
                        <% } else if (error.equals("add_to_cart_failed")) { %>
                            Không thể thêm sách vào giỏ hàng. Vui lòng thử lại!
                        <% } else { %>
                            Có lỗi xảy ra: <%= error %>
                        <% } %>
                    </div>
                    <% } %>
                    
                    <% if (message != null && message.equals("added_to_cart")) { %>
                    <div class="alert alert-success" style="margin-bottom: 20px; padding: 15px 20px; border-radius: 8px; background: #d1fae5; color: #065f46; border: 1px solid #6ee7b7;">
                        <i class="fas fa-check-circle"></i>
                        Đã thêm sách vào giỏ hàng thành công!
                    </div>
                    <% } %>
                    
                    <% if (book != null) { %>
                    <div class="book-detail-content">
                        <div>
                            <div class="book-cover-large">
                                <% if (book.getCoverUrl() != null && !book.getCoverUrl().isEmpty()) { %>
                                <img src="<%= book.getCoverUrl() %>" alt="<%= book.getTitle() %>">
                                <% } else { %>
                                <i class="fas fa-book"></i>
                                <% } %>
                            </div>
                        </div>
                        
                        <div class="book-info-detail">
                            <h1 class="book-title-detail"><%= book.getTitle() %></h1>
                            
                            <div class="book-meta">
                                <% if (book.getAuthor() != null) { %>
                                <div class="book-meta-item">
                                    <i class="fas fa-user"></i>
                                    <span><%= book.getAuthor().getAuthorName() %></span>
                                </div>
                                <% } %>
                                
                                <% if (book.getCategory() != null) { %>
                                <div class="book-meta-item">
                                    <span class="category-badge"><%= book.getCategory().getCategoryName() %></span>
                                </div>
                                <% } %>
                                
                                <% if (book.getTotalPages() != null) { %>
                                <div class="book-meta-item">
                                    <i class="fas fa-file-alt"></i>
                                    <span><%= book.getTotalPages() %> trang</span>
                                </div>
                                <% } %>
                            </div>
                            
                            <% if (book.getPrice() != null && book.getPrice().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                            <div class="book-price-detail">
                                <%= String.format("%,.0f", book.getPrice()) %> 
                                <%= book.getCurrency() != null ? book.getCurrency() : "VND" %>
                            </div>
                            <% } else { %>
                            <div class="book-price-detail" style="color: #10b981;">
                                <i class="fas fa-gift"></i> Miễn Phí
                            </div>
                            <% } %>
                            
                            <div class="book-actions-detail">
                                <% if (!isGuest && book.getPrice() != null && book.getPrice().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                                    <% if ("SELLER".equals(userRole)) { %>
                                    <form method="POST" action="${pageContext.request.contextPath}/seller/cart/add" style="display: inline;">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" class="btn btn-success">
                                            <i class="fas fa-cart-plus"></i> Thêm (Bán)
                                        </button>
                                    </form>
                                    <% } else { %>
                                    <form method="POST" action="${pageContext.request.contextPath}/cart/add" style="display: inline;">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="bookId" value="<%= book.getBookId() %>">
                                        <input type="hidden" name="quantity" value="1">
                                        <input type="hidden" name="redirect" value="/books/view?id=<%= book.getBookId() %>">
                                        <button type="submit" class="btn btn-success">
                                            <i class="fas fa-cart-plus"></i> Thêm Vào Giỏ Hàng
                                        </button>
                                    </form>
                                    <% } %>
                                <% } %>
                                
                                <a href="${pageContext.request.contextPath}/books" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay Lại
                                </a>
                                
                                <% if (canManage) { %>
                                <a href="${pageContext.request.contextPath}/books/edit?id=<%= book.getBookId() %>" class="btn btn-secondary">
                                    <i class="fas fa-edit"></i> Chỉnh Sửa
                                </a>
                                <% } %>
                            </div>
                            
                            <% if (book.getSummary() != null && !book.getSummary().isEmpty()) { %>
                            <div class="book-description">
                                <h3>Tóm Tắt</h3>
                                <p><%= book.getSummary() %></p>
                            </div>
                            <% } %>
                            
                            <% if (book.getDescription() != null && !book.getDescription().isEmpty()) { %>
                            <div class="book-description">
                                <h3>Mô Tả Chi Tiết</h3>
                                <p><%= book.getDescription().replace("\n", "<br>") %></p>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% } else { %>
                    <div style="text-align: center; padding: 60px 20px; background: white; border-radius: 8px;">
                        <i class="fas fa-exclamation-circle" style="font-size: 64px; color: #d1d5db; margin-bottom: 20px;"></i>
                        <h3 style="color: #6b7280;">Không tìm thấy sách</h3>
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-primary" style="margin-top: 20px;">
                            <i class="fas fa-arrow-left"></i> Quay Lại Danh Sách
                        </a>
                    </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
