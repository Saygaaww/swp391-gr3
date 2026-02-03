<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Cart"%>
<%@page import="model.CartItem"%>
<%@page import="model.Reader"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán - Digital Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .checkout-container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .checkout-header {
            margin-bottom: 30px;
        }
        
        .checkout-header h1 {
            color: #1f2937;
            margin: 0;
        }
        
        .checkout-content {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 30px;
        }
        
        .checkout-form-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 30px;
        }
        
        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e5e7eb;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #374151;
        }
        
        .form-group input,
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .payment-methods {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin-top: 15px;
        }
        
        .payment-method {
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
        }
        
        .payment-method input[type="radio"] {
            display: none;
        }
        
        .payment-method:hover {
            border-color: #667eea;
            background: #f9fafb;
        }
        
        .payment-method input[type="radio"]:checked + .payment-label {
            color: #667eea;
        }
        
        .payment-method:has(input[type="radio"]:checked) {
            border-color: #667eea;
            background: #f0f4ff;
        }
        
        .payment-label {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            cursor: pointer;
        }
        
        .payment-label i {
            font-size: 24px;
        }
        
        .order-summary {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 30px;
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        
        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid #e5e7eb;
        }
        
        .summary-item:last-child {
            border-bottom: none;
        }
        
        .summary-item-image {
            width: 60px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
        }
        
        .summary-item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 6px;
        }
        
        .summary-item-info {
            flex: 1;
            margin-left: 15px;
        }
        
        .summary-item-title {
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 5px;
        }
        
        .summary-item-details {
            font-size: 14px;
            color: #6b7280;
        }
        
        .summary-total {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #e5e7eb;
        }
        
        .summary-total-row {
            display: flex;
            justify-content: space-between;
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
        }
        
        .summary-total-row .value {
            color: #667eea;
        }
        
        .btn-submit {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 20px;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        @media (max-width: 968px) {
            .checkout-content {
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
        
        Cart cart = (Cart) request.getAttribute("cart");
        String error = (String) request.getAttribute("error");
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
                    <h1>Thanh Toán</h1>
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
                <div class="checkout-container">
                    <% if (error != null) { %>
                    <div class="alert-error">
                        <i class="fas fa-exclamation-circle"></i> <%= error %>
                    </div>
                    <% } %>
                    
                    <% if (cart != null && cart.getItems() != null && !cart.getItems().isEmpty()) { %>
                    <form method="POST" action="${pageContext.request.contextPath}/checkout/process">
                        <div class="checkout-content">
                            <div class="checkout-form-section">
                                <h2 class="section-title">Phương Thức Thanh Toán</h2>
                                
                                <div class="payment-methods">
                                    <label class="payment-method">
                                        <input type="radio" name="paymentMethod" value="cash" checked>
                                        <div class="payment-label">
                                            <i class="fas fa-money-bill-wave"></i>
                                            <span>Tiền Mặt</span>
                                        </div>
                                    </label>
                                    
                                    <label class="payment-method">
                                        <input type="radio" name="paymentMethod" value="bank_transfer">
                                        <div class="payment-label">
                                            <i class="fas fa-university"></i>
                                            <span>Chuyển Khoản</span>
                                        </div>
                                    </label>
                                    
                                    <label class="payment-method">
                                        <input type="radio" name="paymentMethod" value="credit_card">
                                        <div class="payment-label">
                                            <i class="fas fa-credit-card"></i>
                                            <span>Thẻ Tín Dụng</span>
                                        </div>
                                    </label>
                                    
                                    <label class="payment-method">
                                        <input type="radio" name="paymentMethod" value="e_wallet">
                                        <div class="payment-label">
                                            <i class="fas fa-wallet"></i>
                                            <span>Ví Điện Tử</span>
                                        </div>
                                    </label>
                                </div>
                            </div>
                            
                            <div class="order-summary">
                                <h2 class="section-title">Tóm Tắt Đơn Hàng</h2>
                                
                                <% for (CartItem item : cart.getItems()) { %>
                                <div class="summary-item">
                                    <div class="summary-item-image">
                                        <% if (item.getBook() != null && item.getBook().getCoverUrl() != null && !item.getBook().getCoverUrl().isEmpty()) { %>
                                        <img src="<%= item.getBook().getCoverUrl() %>" alt="<%= item.getBook().getTitle() %>">
                                        <% } else { %>
                                        <i class="fas fa-book"></i>
                                        <% } %>
                                    </div>
                                    <div class="summary-item-info">
                                        <div class="summary-item-title">
                                            <%= item.getBook() != null ? item.getBook().getTitle() : "Sách #" + item.getBookId() %>
                                        </div>
                                        <div class="summary-item-details">
                                            Số lượng: <%= item.getQuantity() %> x 
                                            <%= item.getBook() != null && item.getBook().getPrice() != null ? String.format("%,.0f", item.getBook().getPrice()) : "0" %> 
                                            <%= item.getCurrency() != null ? item.getCurrency() : "VND" %>
                                        </div>
                                    </div>
                                    <div style="font-weight: 600; color: #1f2937;">
                                        <%= String.format("%,.0f", item.getSubtotal()) %> 
                                        <%= item.getCurrency() != null ? item.getCurrency() : "VND" %>
                                    </div>
                                </div>
                                <% } %>
                                
                                <div class="summary-total">
                                    <div class="summary-total-row">
                                        <span>Tổng Tiền:</span>
                                        <span class="value">
                                            <%= String.format("%,.0f", cart.getTotalAmount()) %> 
                                            <%= cart.getItems().isEmpty() ? "VND" : cart.getItems().get(0).getCurrency() != null ? cart.getItems().get(0).getCurrency() : "VND" %>
                                        </span>
                                    </div>
                                </div>
                                
                                <button type="submit" class="btn-submit">
                                    <i class="fas fa-check"></i> Xác Nhận Đặt Hàng
                                </button>
                                
                                <a href="${pageContext.request.contextPath}/cart" style="display: block; text-align: center; margin-top: 15px; color: #667eea; text-decoration: none;">
                                    <i class="fas fa-arrow-left"></i> Quay lại giỏ hàng
                                </a>
                            </div>
                        </div>
                    </form>
                    <% } else { %>
                    <div style="text-align: center; padding: 60px 20px; background: white; border-radius: 8px;">
                        <i class="fas fa-shopping-cart" style="font-size: 64px; color: #d1d5db; margin-bottom: 20px;"></i>
                        <h3 style="color: #6b7280;">Giỏ hàng của bạn đang trống</h3>
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-primary" style="margin-top: 20px;">
                            <i class="fas fa-book"></i> Xem Danh Sách Sách
                        </a>
                    </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
