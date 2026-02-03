<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Cart"%>
<%@page import="model.CartItem"%>
<%@page import="model.Reader"%>
<%@page import="model.Employee"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bán Sách - Giỏ Hàng Khách - Seller Dashboard</title>
    <link rel="stylesheet" href="../css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .panel {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .cart-item {
            display: grid;
            grid-template-columns: 70px 1fr 140px 110px 80px;
            gap: 15px;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #e5e7eb;
        }
        .cart-item:last-child { border-bottom: none; }
        .cover {
            width: 70px; height: 90px;
            border-radius: 6px;
            background: #f3f4f6;
            display:flex; align-items:center; justify-content:center;
            overflow: hidden;
        }
        .cover img { width:100%; height:100%; object-fit:cover; }
        .qty input {
            width: 70px;
            padding: 8px;
            border: 1px solid #e5e7eb;
            border-radius: 6px;
        }
        .btn-mini {
            padding: 8px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
        .btn-danger { background:#ef4444; color:white; }
        .btn-secondary { background:#f3f4f6; color:#111827; }
        .btn-primary { background:#6366f1; color:white; }
        .actions-row { display:flex; gap:10px; flex-wrap:wrap; align-items:center; }
        .muted { color:#6b7280; }
        .right { text-align:right; }
    </style>
</head>
<body>
    <%
        Employee employee = (Employee) session.getAttribute("employee");
        String userRole = (String) session.getAttribute("userRole");
        String userName = (String) session.getAttribute("userName");

        if (employee == null || userRole == null || !"SELLER".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Cart cart = (Cart) request.getAttribute("cart");
        Reader customer = (Reader) request.getAttribute("customer");
        String message = request.getParameter("message");
        String error = request.getParameter("error");
    %>

    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <a href="<%= request.getContextPath() %>/seller/dashboard" style="text-decoration: none; color: inherit; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-book-reader"></i>
                    <h2>Digital Library</h2>
                </a>
            </div>
            <nav class="sidebar-nav">
                <a href="<%= request.getContextPath() %>/seller/dashboard" class="nav-item">
                    <i class="fas fa-home"></i>
                    <span>Trang Chủ</span>
                </a>
                <a href="<%= request.getContextPath() %>/books" class="nav-item">
                    <i class="fas fa-book"></i>
                    <span>Xem Sách</span>
                </a>
                <a href="<%= request.getContextPath() %>/seller/cart" class="nav-item active">
                    <i class="fas fa-shopping-bag"></i>
                    <span>Bán Sách</span>
                </a>
                <a href="<%= request.getContextPath() %>/seller/orders" class="nav-item">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Đơn Hàng</span>
                </a>
                <a href="<%= request.getContextPath() %>/seller/reports" class="nav-item">
                    <i class="fas fa-chart-line"></i>
                    <span>Báo Cáo Bán Hàng</span>
                </a>
            </nav>
        </aside>

        <main class="main-content">
            <header class="dashboard-header">
                <div class="header-left">
                    <h1>Bán Sách</h1>
                </div>
                <div class="header-right">
                    <div class="user-menu">
                        <div class="user-info">
                            <i class="fas fa-user-circle"></i>
                            <span><%= userName != null ? userName : "Người Bán" %></span>
                        </div>
                        <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
                            <i class="fas fa-sign-out-alt"></i>
                            Đăng Xuất
                        </a>
                    </div>
                </div>
            </header>

            <div class="dashboard-content">
                <% if (message != null) { %>
                <div class="panel" style="background:#d1fae5; color:#065f46;">
                    <i class="fas fa-check-circle"></i>
                    <%= message %>
                </div>
                <% } %>
                <% if (error != null) { %>
                <div class="panel" style="background:#fee2e2; color:#991b1b;">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= error %>
                </div>
                <% } %>

                <div class="panel">
                    <div class="actions-row" style="justify-content: space-between;">
                        <div>
                            <div style="font-weight:700;">Khách hàng đang chọn</div>
                            <div class="muted">
                                <%= customer != null ? (customer.getFullName() != null ? customer.getFullName() : "Reader #" + customer.getReaderId()) : "Chưa chọn" %>
                                <% if (customer != null) { %>
                                    - <%= customer.getEmail() %>
                                <% } %>
                            </div>
                        </div>
                        <div class="actions-row">
                            <a class="btn-mini btn-secondary" style="text-decoration:none;" href="<%= request.getContextPath() %>/seller/cart/select-customer">
                                <i class="fas fa-user"></i> Đổi khách hàng
                            </a>
                            <a class="btn-mini btn-secondary" style="text-decoration:none;" href="<%= request.getContextPath() %>/books">
                                <i class="fas fa-plus"></i> Thêm sách
                            </a>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <h2 style="margin-top:0;">Giỏ hàng</h2>

                    <%
                        boolean hasItems = (cart != null && cart.getItems() != null && !cart.getItems().isEmpty());
                    %>

                    <% if (!hasItems) { %>
                        <div class="muted">Giỏ hàng đang trống. Hãy vào `Xem Sách` để thêm sách vào giỏ hàng cho khách.</div>
                    <% } else { %>
                        <div style="margin-top: 10px;">
                            <% for (CartItem item : cart.getItems()) { %>
                                <div class="cart-item">
                                    <div class="cover">
                                        <% if (item.getBook() != null && item.getBook().getCoverUrl() != null && !item.getBook().getCoverUrl().isEmpty()) { %>
                                            <img src="<%= item.getBook().getCoverUrl() %>" alt="cover">
                                        <% } else { %>
                                            <i class="fas fa-book"></i>
                                        <% } %>
                                    </div>
                                    <div>
                                        <div style="font-weight:600;">
                                            <%= item.getBook() != null ? item.getBook().getTitle() : ("Book #" + item.getBookId()) %>
                                        </div>
                                        <div class="muted" style="margin-top:4px;">
                                            Giá: <strong><%= item.getBook() != null && item.getBook().getPrice() != null ? String.format("%,.0f", item.getBook().getPrice()) : "0" %></strong>
                                            <%= item.getBook() != null && item.getBook().getCurrency() != null ? item.getBook().getCurrency() : "VND" %>
                                        </div>
                                    </div>
                                    <div class="qty">
                                        <form method="POST" action="<%= request.getContextPath() %>/seller/cart/update" style="display:flex; gap:8px; align-items:center; justify-content:flex-end;">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                            <input type="number" name="quantity" min="1" value="<%= item.getQuantity() %>">
                                            <button class="btn-mini btn-primary" type="submit"><i class="fas fa-save"></i></button>
                                        </form>
                                    </div>
                                    <div class="right" style="font-weight:700;">
                                        <%
                                            java.math.BigDecimal price = (item.getBook() != null ? item.getBook().getPrice() : null);
                                            java.math.BigDecimal subtotal = (price != null ? price.multiply(java.math.BigDecimal.valueOf(item.getQuantity())) : java.math.BigDecimal.ZERO);
                                        %>
                                        <%= String.format("%,.0f", subtotal) %> <%= item.getBook() != null && item.getBook().getCurrency() != null ? item.getBook().getCurrency() : "VND" %>
                                    </div>
                                    <div class="right">
                                        <form method="POST" action="<%= request.getContextPath() %>/seller/cart/remove" style="margin:0;">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="cartItemId" value="<%= item.getCartItemId() %>">
                                            <button class="btn-mini btn-danger" type="submit"><i class="fas fa-trash"></i></button>
                                        </form>
                                    </div>
                                </div>
                            <% } %>
                        </div>

                        <div class="actions-row" style="justify-content: space-between; margin-top: 18px;">
                            <form method="POST" action="<%= request.getContextPath() %>/seller/cart/clear" style="margin:0;">
                                <input type="hidden" name="action" value="clear">
                                <button class="btn-mini btn-secondary" type="submit">
                                    <i class="fas fa-broom"></i> Xóa giỏ hàng
                                </button>
                            </form>
                            <div class="actions-row">
                                <div style="font-weight:700;">
                                    Tổng:
                                    <%= cart != null && cart.getTotalAmount() != null ? String.format("%,.0f", cart.getTotalAmount()) : "0" %> VND
                                </div>
                                <a class="btn-mini btn-primary" style="text-decoration:none;" href="<%= request.getContextPath() %>/seller/checkout">
                                    <i class="fas fa-credit-card"></i> Checkout
                                </a>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</body>
</html>

