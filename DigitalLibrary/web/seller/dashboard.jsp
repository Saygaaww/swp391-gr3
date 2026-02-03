<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Reader"%>
<%@page import="model.Employee"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Dashboard - Digital Library</title>
    <link rel="stylesheet" href="../css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <%
        // Kiểm tra đăng nhập và quyền SELLER (từ Reader hoặc Employee)
        Reader reader = (Reader) session.getAttribute("reader");
        Employee employee = (Employee) session.getAttribute("employee");
        String userRole = (String) session.getAttribute("userRole");
        
        if ((reader == null && employee == null) || userRole == null || !"SELLER".equals(userRole)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Lấy thông tin user để hiển thị (ưu tiên từ session)
        String userName = (String) session.getAttribute("userName");
        if (userName == null || userName.isEmpty()) {
            if (reader != null) {
                userName = reader.getFullName() != null ? reader.getFullName() : reader.getEmail();
            } else if (employee != null) {
                userName = employee.getFullName() != null ? employee.getFullName() : employee.getEmail();
            }
        }
        
        // Lấy stats từ request (được set bởi SellerDashboardServlet)
        Integer totalOrders = (Integer) request.getAttribute("totalOrders");
        Integer paidOrders = (Integer) request.getAttribute("paidOrders");
        Integer pendingOrders = (Integer) request.getAttribute("pendingOrders");
        java.math.BigDecimal totalRevenue = (java.math.BigDecimal) request.getAttribute("totalRevenue");
        String seedMessage = (String) request.getAttribute("seedMessage");
        Boolean seedSuccess = (Boolean) request.getAttribute("seedSuccess");
        
        // Nếu không có (truy cập trực tiếp JSP), set giá trị mặc định
        if (totalOrders == null) totalOrders = 0;
        if (paidOrders == null) paidOrders = 0;
        if (pendingOrders == null) pendingOrders = 0;
        if (totalRevenue == null) totalRevenue = java.math.BigDecimal.ZERO;
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
                <a href="<%= request.getContextPath() %>/seller/dashboard" class="nav-item active">
                    <i class="fas fa-home"></i>
                    <span>Trang Chủ</span>
                </a>
                <a href="<%= request.getContextPath() %>/books" class="nav-item">
                    <i class="fas fa-book"></i>
                    <span>Xem Sách</span>
                </a>
                <a href="<%= request.getContextPath() %>/seller/cart" class="nav-item">
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
                    <h1>Seller Dashboard</h1>
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
                <div class="welcome-card">
                    <h2>Chào mừng, <%= userName != null ? userName : "Người Bán" %>!</h2>
                    <p>Bạn đang ở trang quản lý bán hàng</p>
                    <% if (userRole != null) { %>
                        <p style="margin-top: 8px; font-size: 14px; color: #6b7280;">Role: <%= userRole %> | Type: <%= reader != null ? "Reader" : "Employee" %></p>
                    <% } %>
                    <% if (seedMessage != null && !seedMessage.isEmpty()) { %>
                        <p style="margin-top: 10px; font-size: 14px; color: <%= (seedSuccess != null && seedSuccess) ? "#065f46" : "#991b1b" %>;">
                            <i class="fas <%= (seedSuccess != null && seedSuccess) ? "fa-check-circle" : "fa-exclamation-circle" %>"></i>
                            <%= seedMessage %>
                        </p>
                    <% } %>
                </div>
                
                <div class="stats-grid">
                    <a href="<%= request.getContextPath() %>/seller/cart" style="text-decoration: none; color: inherit;">
                        <div class="stat-card" style="cursor: pointer;">
                            <div class="stat-icon" style="background: linear-gradient(135deg, #8b5cf6 0%, #6366f1 100%);">
                                <i class="fas fa-shopping-bag"></i>
                            </div>
                            <div class="stat-info">
                                <h3>Bán Sách</h3>
                                <p>Tạo đơn hàng mới</p>
                            </div>
                        </div>
                    </a>
                    <a href="<%= request.getContextPath() %>/seller/orders" style="text-decoration: none; color: inherit;">
                        <div class="stat-card" style="cursor: pointer;">
                            <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <div class="stat-info">
                                <h3><%= totalOrders %></h3>
                                <p>Tổng Đơn Hàng</p>
                            </div>
                        </div>
                    </a>
                    <a href="<%= request.getContextPath() %>/seller/orders?status=paid" style="text-decoration: none; color: inherit;">
                        <div class="stat-card" style="cursor: pointer;">
                            <div class="stat-icon" style="background: linear-gradient(135deg, #10b981 0%, #059669 100%);">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <div class="stat-info">
                                <h3><%= paidOrders %></h3>
                                <p>Đã Thanh Toán</p>
                            </div>
                        </div>
                    </a>
                    <a href="<%= request.getContextPath() %>/seller/orders?status=pending" style="text-decoration: none; color: inherit;">
                        <div class="stat-card" style="cursor: pointer;">
                            <div class="stat-icon" style="background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-info">
                                <h3><%= pendingOrders %></h3>
                                <p>Chờ Xử Lý</p>
                            </div>
                        </div>
                    </a>
                    <a href="<%= request.getContextPath() %>/seller/reports" style="text-decoration: none; color: inherit;">
                        <div class="stat-card" style="cursor: pointer;">
                            <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                            <div class="stat-info">
                                <h3><%= String.format("%,.0f", totalRevenue) %></h3>
                                <p>Doanh Thu (VND)</p>
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
