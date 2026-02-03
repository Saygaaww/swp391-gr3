<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Employee"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout Thành Công - Seller</title>
    <link rel="stylesheet" href="../css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .panel { background:#fff; padding:24px; border-radius:10px; box-shadow:0 2px 4px rgba(0,0,0,0.1); max-width:720px; }
        .btn { padding:12px 16px; border:none; border-radius:8px; cursor:pointer; text-decoration:none; display:inline-block; }
        .btn-primary { background:#6366f1; color:white; }
        .btn-secondary { background:#f3f4f6; color:#111827; }
    </style>
</head>
<body>
    <%
        Employee employee = (Employee) session.getAttribute("employee");
        String userRole = (String) session.getAttribute("userRole");
        if (employee == null || userRole == null || !"SELLER".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String orderId = request.getParameter("orderId");
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
                    <h1>Checkout Thành Công</h1>
                </div>
            </header>

            <div class="dashboard-content">
                <div class="panel">
                    <div style="display:flex; gap:12px; align-items:center;">
                        <div style="width:48px; height:48px; border-radius:999px; background:#d1fae5; color:#065f46; display:flex; align-items:center; justify-content:center;">
                            <i class="fas fa-check"></i>
                        </div>
                        <div>
                            <div style="font-weight:800; font-size:18px;">Đã tạo đơn hàng thành công</div>
                            <% if (orderId != null) { %>
                                <div style="color:#6b7280; margin-top:4px;">Mã đơn: <strong>#<%= orderId %></strong></div>
                            <% } %>
                        </div>
                    </div>

                    <div style="display:flex; gap:10px; margin-top:18px; flex-wrap:wrap;">
                        <a class="btn btn-primary" href="<%= request.getContextPath() %>/seller/orders">
                            <i class="fas fa-receipt"></i> Xem đơn hàng
                        </a>
                        <a class="btn btn-secondary" href="<%= request.getContextPath() %>/seller/cart">
                            <i class="fas fa-shopping-bag"></i> Bán tiếp
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>

