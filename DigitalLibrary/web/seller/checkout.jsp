<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Cart"%>
<%@page import="model.CartItem"%>
<%@page import="model.Reader"%>
<%@page import="model.Employee"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Seller</title>
    <link rel="stylesheet" href="../css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .panel { background:#fff; padding:20px; border-radius:8px; box-shadow:0 2px 4px rgba(0,0,0,0.1); margin-bottom:20px; }
        .row { display:flex; justify-content:space-between; padding:10px 0; border-bottom:1px solid #e5e7eb; }
        .row:last-child { border-bottom:none; }
        .btn { padding:12px 16px; border:none; border-radius:8px; cursor:pointer; }
        .btn-primary { background:#6366f1; color:white; }
        .btn-secondary { background:#f3f4f6; color:#111827; }
        select { width:100%; padding:10px; border:1px solid #e5e7eb; border-radius:8px; }
        .muted { color:#6b7280; }
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
                <a href="<%= request.getContextPath() %>/seller/cart" class="nav-item active">
                    <i class="fas fa-shopping-bag"></i>
                    <span>Bán Sách</span>
                </a>
                <a href="<%= request.getContextPath() %>/seller/orders" class="nav-item">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Đơn Hàng</span>
                </a>
            </nav>
        </aside>

        <main class="main-content">
            <header class="dashboard-header">
                <div class="header-left">
                    <a href="<%= request.getContextPath() %>/seller/cart" style="color:#6366f1; text-decoration:none; margin-right:12px;">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                    <h1>Checkout</h1>
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
                <% if (error != null) { %>
                <div class="panel" style="background:#fee2e2; color:#991b1b;">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                </div>
                <% } %>

                <div class="panel">
                    <div style="font-weight:700;">Khách hàng</div>
                    <div class="muted">
                        <%= customer != null ? (customer.getFullName() != null ? customer.getFullName() : ("Reader #" + customer.getReaderId())) : "N/A" %>
                        <% if (customer != null) { %> - <%= customer.getEmail() %><% } %>
                    </div>
                </div>

                <div class="panel">
                    <h2 style="margin-top:0;">Tóm tắt đơn hàng</h2>
                    <% if (cart != null && cart.getItems() != null) { %>
                        <% for (CartItem item : cart.getItems()) { %>
                            <div class="row">
                                <div>
                                    <div style="font-weight:600;">
                                        <%= item.getBook() != null ? item.getBook().getTitle() : ("Book #" + item.getBookId()) %>
                                    </div>
                                    <div class="muted">SL: <%= item.getQuantity() %></div>
                                </div>
                                <div style="font-weight:700;">
                                    <%
                                        java.math.BigDecimal price = (item.getBook() != null ? item.getBook().getPrice() : null);
                                        java.math.BigDecimal subtotal = (price != null ? price.multiply(java.math.BigDecimal.valueOf(item.getQuantity())) : java.math.BigDecimal.ZERO);
                                    %>
                                    <%= String.format("%,.0f", subtotal) %> VND
                                </div>
                            </div>
                        <% } %>
                        <div class="row" style="border-bottom:none; margin-top:10px;">
                            <div style="font-weight:700;">Tổng cộng</div>
                            <div style="font-weight:800;"><%= cart.getTotalAmount() != null ? String.format("%,.0f", cart.getTotalAmount()) : "0" %> VND</div>
                        </div>
                    <% } %>
                </div>

                <div class="panel">
                    <form method="POST" action="<%= request.getContextPath() %>/seller/checkout/process">
                        <input type="hidden" name="action" value="process">
                        <label style="display:block; margin-bottom:8px; font-weight:600;">Phương thức thanh toán</label>
                        <select name="paymentMethod" required>
                            <option value="">-- Chọn --</option>
                            <option value="cash">Tiền mặt</option>
                            <option value="bank_transfer">Chuyển khoản</option>
                            <option value="momo">MoMo (mock)</option>
                        </select>

                        <div style="display:flex; gap:10px; margin-top:15px; justify-content:flex-end;">
                            <a class="btn btn-secondary" style="text-decoration:none;" href="<%= request.getContextPath() %>/seller/cart">Hủy</a>
                            <button class="btn btn-primary" type="submit">
                                <i class="fas fa-check"></i> Tạo đơn & thanh toán (mock)
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</body>
</html>

