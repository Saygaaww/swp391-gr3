<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Order"%>
<%@page import="model.OrderBook"%>
<%@page import="model.Payment"%>
<%@page import="model.Reader"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Hàng Thành Công - Digital Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .success-container {
            padding: 20px;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .success-header {
            text-align: center;
            padding: 40px 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .success-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            color: white;
            font-size: 40px;
        }
        
        .success-header h1 {
            color: #1f2937;
            margin-bottom: 10px;
        }
        
        .success-header p {
            color: #6b7280;
            font-size: 16px;
        }
        
        .order-details {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 20px;
        }
        
        .order-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .info-item {
            padding: 15px;
            background: #f9fafb;
            border-radius: 6px;
        }
        
        .info-label {
            font-size: 12px;
            color: #6b7280;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        
        .info-value {
            font-size: 16px;
            font-weight: 600;
            color: #1f2937;
        }
        
        .order-items {
            margin-top: 30px;
        }
        
        .order-item {
            display: flex;
            gap: 15px;
            padding: 20px;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .item-image {
            width: 80px;
            height: 100px;
            object-fit: cover;
            border-radius: 6px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
        }
        
        .item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 6px;
        }
        
        .item-info {
            flex: 1;
        }
        
        .item-title {
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 5px;
        }
        
        .item-details {
            font-size: 14px;
            color: #6b7280;
        }
        
        .item-subtotal {
            font-weight: 600;
            color: #1f2937;
            text-align: right;
        }
        
        .order-total {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            font-size: 20px;
            font-weight: 700;
        }
        
        .order-total .value {
            color: #667eea;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
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
        
        .btn-secondary {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
        }
        
        .btn-secondary:hover {
            background: #f0f4ff;
        }
        
        @media (max-width: 768px) {
            .order-info {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%
        Reader reader = (Reader) session.getAttribute("reader");
        String userRole = (String) session.getAttribute("userRole");
        boolean isGuest = (reader == null);
        
        String userName = null;
        if (reader != null) {
            userName = reader.getFullName() != null ? reader.getFullName() : reader.getEmail();
        }
        
        Order order = (Order) request.getAttribute("order");
    %>
    
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <% if (!isGuest) { 
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
                <a href="${pageContext.request.contextPath}/books" class="nav-item">
                    <i class="fas fa-book"></i>
                    <span>Danh Sách Sách</span>
                </a>
                <a href="${pageContext.request.contextPath}/cart" class="nav-item">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Giỏ Hàng</span>
                </a>
            </nav>
        </aside>
        
        <main class="main-content">
            <header class="dashboard-header">
                <div class="header-left">
                    <h1>Đặt Hàng Thành Công</h1>
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
                    <% } %>
                </div>
            </header>
            
            <div class="dashboard-content">
                <div class="success-container">
                    <% if (order != null) { %>
                    <div class="success-header">
                        <div class="success-icon">
                            <i class="fas fa-check"></i>
                        </div>
                        <h1>Cảm Ơn Bạn Đã Đặt Hàng!</h1>
                        <p>Đơn hàng của bạn đã được tiếp nhận và đang được xử lý</p>
                    </div>
                    
                    <div class="order-details">
                        <h2 style="margin-bottom: 20px; color: #1f2937;">Chi Tiết Đơn Hàng</h2>
                        
                        <div class="order-info">
                            <div class="info-item">
                                <div class="info-label">Mã Đơn Hàng</div>
                                <div class="info-value">#<%= order.getOrderId() %></div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">Trạng Thái</div>
                                <div class="info-value"><%= order.getStatusDisplay() %></div>
                            </div>
                            
                            <% if (order.getPayment() != null) { %>
                            <div class="info-item">
                                <div class="info-label">Phương Thức Thanh Toán</div>
                                <div class="info-value"><%= order.getPayment().getPaymentMethodDisplay() %></div>
                            </div>
                            
                            <div class="info-item">
                                <div class="info-label">Trạng Thái Thanh Toán</div>
                                <div class="info-value"><%= order.getPayment().getPaymentStatusDisplay() %></div>
                            </div>
                            <% } %>
                            
                            <div class="info-item">
                                <div class="info-label">Ngày Đặt Hàng</div>
                                <div class="info-value">
                                    <%= order.getCreatedAt() != null ? order.getCreatedAt().toString() : "N/A" %>
                                </div>
                            </div>
                        </div>
                        
                        <% if (order.getItems() != null && !order.getItems().isEmpty()) { %>
                        <div class="order-items">
                            <h3 style="margin-bottom: 15px; color: #1f2937;">Sản Phẩm Đã Đặt</h3>
                            
                            <% for (OrderBook item : order.getItems()) { %>
                            <div class="order-item">
                                <div class="item-image">
                                    <% if (item.getBook() != null && item.getBook().getCoverUrl() != null && !item.getBook().getCoverUrl().isEmpty()) { %>
                                    <img src="<%= item.getBook().getCoverUrl() %>" alt="<%= item.getBook().getTitle() %>">
                                    <% } else { %>
                                    <i class="fas fa-book"></i>
                                    <% } %>
                                </div>
                                <div class="item-info">
                                    <div class="item-title">
                                        <%= item.getBook() != null ? item.getBook().getTitle() : "Sách #" + item.getBookId() %>
                                    </div>
                                    <div class="item-details">
                                        Số lượng: <%= item.getQuantity() %> x 
                                        <%= String.format("%,.0f", item.getPrice()) %> 
                                        <%= item.getCurrency() != null ? item.getCurrency() : "VND" %>
                                    </div>
                                </div>
                                <div class="item-subtotal">
                                    <%= String.format("%,.0f", item.getSubtotal()) %> 
                                    <%= item.getCurrency() != null ? item.getCurrency() : "VND" %>
                                </div>
                            </div>
                            <% } %>
                            
                            <div class="order-total">
                                <span>Tổng Tiền:</span>
                                <span class="value">
                                    <%= String.format("%,.0f", order.getTotalAmount()) %> 
                                    <%= order.getCurrency() != null ? order.getCurrency() : "VND" %>
                                </span>
                            </div>
                        </div>
                        <% } %>
                    </div>
                    
                    <div class="action-buttons">
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-primary">
                            <i class="fas fa-book"></i> Tiếp Tục Mua Sắm
                        </a>
                        <a href="${pageContext.request.contextPath}/user/dashboard" class="btn btn-secondary">
                            <i class="fas fa-user"></i> Xem Lịch Sử Đơn Hàng
                        </a>
                    </div>
                    <% } else { %>
                    <div style="text-align: center; padding: 60px 20px; background: white; border-radius: 8px;">
                        <i class="fas fa-exclamation-circle" style="font-size: 64px; color: #d1d5db; margin-bottom: 20px;"></i>
                        <h3 style="color: #6b7280;">Không tìm thấy thông tin đơn hàng</h3>
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-primary" style="margin-top: 20px;">
                            <i class="fas fa-book"></i> Về Trang Chủ
                        </a>
                    </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
