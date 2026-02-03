<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Cart"%>
<%@page import="model.CartItem"%>
<%@page import="model.Reader"%>
<%@page import="java.util.List"%>
<%@page import="java.math.BigDecimal"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ Hàng - Digital Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .cart-container {
            padding: 20px;
        }
        
        .cart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .cart-header h1 {
            margin: 0;
            color: #1f2937;
        }
        
        .cart-content {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 30px;
        }
        
        .cart-items {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
        }
        
        .cart-item {
            display: grid;
            grid-template-columns: 120px 1fr 140px 130px 50px;
            gap: 20px;
            padding: 20px;
            border-bottom: 1px solid #e5e7eb;
            align-items: center;
        }
        
        .cart-item:last-child {
            border-bottom: none;
        }
        
        .cart-item-image {
            width: 120px;
            height: 160px;
            object-fit: cover;
            border-radius: 8px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 32px;
        }
        
        .cart-item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .cart-item-info {
            flex: 1;
        }
        
        .cart-item-title {
            font-size: 18px;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 8px;
        }
        
        .cart-item-price {
            font-size: 16px;
            color: #667eea;
            font-weight: 600;
        }
        
        .cart-item-quantity {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 0;
        }
        
        .quantity-update-form {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: nowrap;
        }
        
        .quantity-input {
            width: 70px;
            min-width: 70px;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            text-align: center;
            font-size: 16px;
            font-weight: 500;
        }
        
        .quantity-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.2);
        }
        
        .btn-update-quantity {
            padding: 10px 18px;
            border: 1px solid #667eea;
            border-radius: 8px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            white-space: nowrap;
            transition: all 0.3s;
        }
        
        .btn-update-quantity:hover:not(:disabled) {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.35);
        }
        
        .btn-update-quantity:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .cart-item-subtotal {
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
            min-width: 120px;
            text-align: right;
        }
        
        .cart-item-remove {
            color: #ef4444;
            cursor: pointer;
            font-size: 20px;
            transition: all 0.3s;
        }
        
        .cart-item-remove:hover {
            color: #dc2626;
            transform: scale(1.1);
        }
        
        .cart-summary {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        
        .summary-title {
            font-size: 20px;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e5e7eb;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            color: #6b7280;
        }
        
        .summary-row.total {
            font-size: 20px;
            font-weight: 700;
            color: #1f2937;
            padding-top: 15px;
            border-top: 2px solid #e5e7eb;
            margin-top: 15px;
        }
        
        .summary-row.total .value {
            color: #667eea;
        }
        
        .btn-checkout {
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
        
        .btn-checkout:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        .btn-checkout:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .empty-cart i {
            font-size: 64px;
            color: #d1d5db;
            margin-bottom: 20px;
        }
        
        .empty-cart h3 {
            color: #6b7280;
            margin-bottom: 10px;
        }
        
        .empty-cart p {
            color: #9ca3af;
            margin-bottom: 30px;
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
        
        @media (max-width: 968px) {
            .cart-content {
                grid-template-columns: 1fr;
            }
            
            .cart-item {
                grid-template-columns: 100px 1fr;
                gap: 15px;
            }
            
            .cart-item-quantity,
            .cart-item-subtotal,
            .cart-item-remove {
                grid-column: 1 / -1;
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
        String message = request.getParameter("message");
        String error = request.getParameter("error");
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
                <a href="${pageContext.request.contextPath}/cart" class="nav-item active">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Giỏ Hàng</span>
                </a>
            </nav>
        </aside>
        
        <main class="main-content">
            <header class="dashboard-header">
                <div class="header-left">
                    <h1>Giỏ Hàng</h1>
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
                <div class="cart-container">
                    <% if (message != null) { %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <% if (message.equals("added_to_cart")) { %>
                            Đã thêm sách vào giỏ hàng!
                        <% } else if (message.equals("cart_updated")) { %>
                            Đã cập nhật giỏ hàng!
                        <% } else if (message.equals("item_removed")) { %>
                            Đã xóa sách khỏi giỏ hàng!
                        <% } else if (message.equals("cart_cleared")) { %>
                            Đã xóa tất cả sách trong giỏ hàng!
                        <% } %>
                    </div>
                    <% } %>
                    
                    <% if (error != null) { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <% if (error.equals("cart_empty")) { %>
                            Giỏ hàng của bạn đang trống!
                        <% } else if (error.equals("missing_params") || error.equals("missing_cart_item_id")) { %>
                            Thiếu thông tin cần thiết. Vui lòng thử lại!
                        <% } else if (error.equals("invalid_cart_item_id") || error.equals("invalid_quantity")) { %>
                            Thông tin không hợp lệ. Vui lòng thử lại!
                        <% } else if (error.equals("quantity_too_small")) { %>
                            Số lượng phải lớn hơn 0!
                        <% } else if (error.equals("quantity_too_large")) { %>
                            Số lượng tối đa là 999!
                        <% } else if (error.equals("quantity_invalid")) { %>
                            Số lượng không hợp lệ!
                        <% } else if (error.equals("cart_item_not_found")) { %>
                            Sản phẩm không tồn tại trong giỏ hàng!
                        <% } else if (error.equals("book_deleted")) { %>
                            Sách này đã bị xóa khỏi hệ thống!
                        <% } else if (error.equals("out_of_stock")) { %>
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
                                    <br>Vui lòng giảm số lượng hoặc xóa sản phẩm khỏi giỏ hàng.
                                <% } else { %>
                                    <br>Vui lòng chọn số lượng nhỏ hơn hoặc bằng <%= available %>.
                                <% } %>
                            <% } else { %>
                                Vui lòng chọn số lượng phù hợp với tồn kho.
                            <% } %>
                        <% } else if (error.equals("unauthorized")) { %>
                            Bạn không có quyền thực hiện thao tác này!
                        <% } else if (error.equals("update_failed") || error.equals("remove_failed") || error.equals("add_to_cart_failed")) { %>
                            Không thể thực hiện thao tác. Vui lòng thử lại!
                        <% } else { %>
                            Có lỗi xảy ra: <%= error %>
                        <% } %>
                    </div>
                    <% } %>
                    
                    <% if (cart != null && cart.getItems() != null && !cart.getItems().isEmpty()) { %>
                    <div class="cart-content">
                        <div class="cart-items">
                            <% for (CartItem item : cart.getItems()) { %>
                            <div class="cart-item">
                                <div class="cart-item-image">
                                    <% if (item.getBook() != null && item.getBook().getCoverUrl() != null && !item.getBook().getCoverUrl().isEmpty()) { %>
                                    <img src="<%= item.getBook().getCoverUrl() %>" alt="<%= item.getBook().getTitle() %>">
                                    <% } else { %>
                                    <i class="fas fa-book"></i>
                                    <% } %>
                                </div>
                                
                                <div class="cart-item-info">
                                    <div class="cart-item-title">
                                        <%= item.getBook() != null ? item.getBook().getTitle() : "Sách #" + item.getBookId() %>
                                    </div>
                                    <div class="cart-item-price">
                                        <%= item.getBook() != null && item.getBook().getPrice() != null ? String.format("%,.0f", item.getBook().getPrice()) : "0" %> 
                                        <%= item.getCurrency() != null ? item.getCurrency() : "VND" %>
                                    </div>
                                    <% if (item.getBook() != null && item.getBook().getStock() != null) { %>
                                    <div style="margin-top: 8px; font-size: 14px; color: <%= item.getBook().getStock() > 0 ? "#10b981" : "#ef4444" %>;">
                                        <i class="fas fa-<%= item.getBook().getStock() > 0 ? "check-circle" : "times-circle" %>"></i>
                                        <% if (item.getBook().getStock() > 0) { %>
                                            Còn lại: <strong><%= item.getBook().getStock() %> cuốn</strong>
                                            <% if (item.getQuantity() > item.getBook().getStock()) { %>
                                                <span style="color: #ef4444; font-weight: 600;"> (Vượt quá tồn kho!)</span>
                                            <% } %>
                                        <% } else { %>
                                            <strong>Hết hàng</strong>
                                        <% } %>
                                    </div>
                                    <% } %>
                                </div>
                                
                                <div class="cart-item-quantity">
                                    <%
                                        int maxQuantity = 999;
                                        if (item.getBook() != null && item.getBook().getStock() != null) {
                                            maxQuantity = Math.min(999, item.getBook().getStock());
                                        }
                                        boolean isOutOfStock = item.getBook() != null && item.getBook().getStock() != null && item.getBook().getStock() <= 0;
                                    %>
                                    <form method="POST" action="${pageContext.request.contextPath}/cart/update" class="quantity-update-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                        <input type="number" 
                                               name="quantity" 
                                               value="<%= item.getQuantity() %>" 
                                               min="1" 
                                               max="<%= maxQuantity %>" 
                                               class="quantity-input"
                                               title="Tối đa <%= maxQuantity %> cuốn (theo tồn kho). Thay đổi số lượng sẽ tự động cập nhật."
                                               onchange="this.form.submit()"
                                               <%= isOutOfStock ? "disabled" : "" %>>
                                    </form>
                                    <% if (item.getBook() != null && item.getBook().getStock() != null && item.getQuantity() > item.getBook().getStock()) { %>
                                    <div style="margin-top: 5px; font-size: 12px; color: #ef4444;">
                                        <i class="fas fa-exclamation-triangle"></i> Vượt quá tồn kho!
                                    </div>
                                    <% } %>
                                </div>
                                
                                <div class="cart-item-subtotal">
                                    <%= String.format("%,.0f", item.getSubtotal()) %> <%= item.getCurrency() != null ? item.getCurrency() : "VND" %>
                                </div>
                                
                                <form method="POST" action="${pageContext.request.contextPath}/cart/remove" style="display: inline;">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                    <button type="submit" class="cart-item-remove" style="background:none; border:none; cursor:pointer; padding:0;" title="Xóa khỏi giỏ hàng">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </form>
                            </div>
                            <% } %>
                        </div>
                        
                        <div class="cart-summary">
                            <div class="summary-title">Tóm Tắt Đơn Hàng</div>
                            
                            <div class="summary-row">
                                <span>Tổng số lượng:</span>
                                <span><strong><%= cart.getTotalItems() %> sách</strong></span>
                            </div>
                            
                            <div class="summary-row total">
                                <span>Tổng tiền:</span>
                                <span class="value">
                                    <%= String.format("%,.0f", cart.getTotalAmount()) %> 
                                    <%= cart.getItems().isEmpty() ? "VND" : cart.getItems().get(0).getCurrency() != null ? cart.getItems().get(0).getCurrency() : "VND" %>
                                </span>
                            </div>
                            
                            <a href="${pageContext.request.contextPath}/checkout" class="btn-checkout">
                                <i class="fas fa-credit-card"></i> Thanh Toán
                            </a>
                            
                            <a href="${pageContext.request.contextPath}/books" style="display: block; text-align: center; margin-top: 15px; color: #667eea; text-decoration: none;">
                                <i class="fas fa-arrow-left"></i> Tiếp tục mua sắm
                            </a>
                        </div>
                    </div>
                    <% } else { %>
                    <div class="empty-cart">
                        <i class="fas fa-shopping-cart"></i>
                        <h3>Giỏ hàng của bạn đang trống</h3>
                        <p>Hãy thêm sách vào giỏ hàng để tiếp tục mua sắm</p>
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-primary">
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
