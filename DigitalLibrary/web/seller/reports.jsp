<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Employee"%>
<%@page import="java.math.BigDecimal"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Bán Hàng - Seller Dashboard</title>
    <link rel="stylesheet" href="../css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .report-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .report-card {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .report-card h3 {
            margin: 0 0 10px 0;
            color: #1f2937;
            font-size: 28px;
        }
        
        .report-card p {
            margin: 0;
            color: #6b7280;
            font-size: 14px;
        }
        
        .report-card .icon {
            font-size: 32px;
            margin-bottom: 15px;
            opacity: 0.8;
        }
        
        .revenue-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .revenue-card h3,
        .revenue-card p {
            color: white;
        }
        
        .status-breakdown {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .status-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .status-item:last-child {
            border-bottom: none;
        }
        
        .status-label {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }
        
        .status-paid {
            background: #d1fae5;
            color: #065f46;
        }
        
        .status-cancelled {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .status-refunded {
            background: #e0e7ff;
            color: #3730a3;
        }
        
        .info-section {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .info-section h3 {
            margin-top: 0;
            color: #1f2937;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            color: #6b7280;
        }
        
        .info-value {
            color: #1f2937;
            font-weight: 600;
        }
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
        
        BigDecimal totalRevenue = (BigDecimal) request.getAttribute("totalRevenue");
        Integer totalOrders = (Integer) request.getAttribute("totalOrders");
        Integer paidOrders = (Integer) request.getAttribute("paidOrders");
        Integer pendingOrders = (Integer) request.getAttribute("pendingOrders");
        Integer cancelledOrders = (Integer) request.getAttribute("cancelledOrders");
        Integer refundedOrders = (Integer) request.getAttribute("refundedOrders");
        
        if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;
        if (totalOrders == null) totalOrders = 0;
        if (paidOrders == null) paidOrders = 0;
        if (pendingOrders == null) pendingOrders = 0;
        if (cancelledOrders == null) cancelledOrders = 0;
        if (refundedOrders == null) refundedOrders = 0;
        
        // Tính tỷ lệ
        double paidRate = totalOrders > 0 ? (paidOrders * 100.0 / totalOrders) : 0;
        double pendingRate = totalOrders > 0 ? (pendingOrders * 100.0 / totalOrders) : 0;
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
                <a href="<%= request.getContextPath() %>/seller/orders" class="nav-item">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Đơn Hàng</span>
                </a>
                <a href="<%= request.getContextPath() %>/seller/reports" class="nav-item active">
                    <i class="fas fa-chart-line"></i>
                    <span>Báo Cáo Bán Hàng</span>
                </a>
            </nav>
        </aside>
        
        <main class="main-content">
            <header class="dashboard-header">
                <div class="header-left">
                    <h1>Báo Cáo Bán Hàng</h1>
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
                <!-- Revenue Overview -->
                <div class="report-grid">
                    <div class="report-card revenue-card">
                        <div class="icon">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <h3><%= String.format("%,.0f", totalRevenue) %> VND</h3>
                        <p>Tổng Doanh Thu</p>
                    </div>
                    <div class="report-card">
                        <div class="icon" style="color: #667eea;">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <h3><%= totalOrders %></h3>
                        <p>Tổng Đơn Hàng</p>
                    </div>
                    <div class="report-card">
                        <div class="icon" style="color: #10b981;">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <h3><%= paidOrders %></h3>
                        <p>Đã Thanh Toán</p>
                    </div>
                    <div class="report-card">
                        <div class="icon" style="color: #f59e0b;">
                            <i class="fas fa-clock"></i>
                        </div>
                        <h3><%= pendingOrders %></h3>
                        <p>Chờ Xử Lý</p>
                    </div>
                </div>
                
                <!-- Status Breakdown -->
                <div class="status-breakdown">
                    <h2 style="margin-top: 0; margin-bottom: 20px;">Phân Tích Trạng Thái Đơn Hàng</h2>
                    <div class="status-item">
                        <div class="status-label">
                            <span class="status-badge status-paid">Đã thanh toán</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 15px;">
                            <span style="color: #6b7280; font-size: 14px;"><%= String.format("%.1f", paidRate) %>%</span>
                            <strong style="color: #1f2937;"><%= paidOrders %> đơn</strong>
                        </div>
                    </div>
                    <div class="status-item">
                        <div class="status-label">
                            <span class="status-badge status-pending">Chờ thanh toán</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 15px;">
                            <span style="color: #6b7280; font-size: 14px;"><%= String.format("%.1f", pendingRate) %>%</span>
                            <strong style="color: #1f2937;"><%= pendingOrders %> đơn</strong>
                        </div>
                    </div>
                    <div class="status-item">
                        <div class="status-label">
                            <span class="status-badge status-cancelled">Đã hủy</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 15px;">
                            <span style="color: #6b7280; font-size: 14px;">
                                <%= totalOrders > 0 ? String.format("%.1f", cancelledOrders * 100.0 / totalOrders) : "0" %>%
                            </span>
                            <strong style="color: #1f2937;"><%= cancelledOrders %> đơn</strong>
                        </div>
                    </div>
                    <div class="status-item">
                        <div class="status-label">
                            <span class="status-badge status-refunded">Đã hoàn tiền</span>
                        </div>
                        <div style="display: flex; align-items: center; gap: 15px;">
                            <span style="color: #6b7280; font-size: 14px;">
                                <%= totalOrders > 0 ? String.format("%.1f", refundedOrders * 100.0 / totalOrders) : "0" %>%
                            </span>
                            <strong style="color: #1f2937;"><%= refundedOrders %> đơn</strong>
                        </div>
                    </div>
                </div>
                
                <!-- Additional Info -->
                <div class="info-section">
                    <h3>Thông Tin Bổ Sung</h3>
                    <div class="info-row">
                        <span class="info-label">Tỷ lệ đơn hàng thành công:</span>
                        <span class="info-value" style="color: #10b981;">
                            <%= String.format("%.1f", paidRate) %>% (<%= paidOrders %>/<%= totalOrders %>)
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Tỷ lệ đơn hàng chờ xử lý:</span>
                        <span class="info-value" style="color: #f59e0b;">
                            <%= String.format("%.1f", pendingRate) %>% (<%= pendingOrders %>/<%= totalOrders %>)
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Doanh thu trung bình mỗi đơn:</span>
                        <span class="info-value">
                            <%= paidOrders > 0 ? String.format("%,.0f", totalRevenue.divide(BigDecimal.valueOf(paidOrders), 2, BigDecimal.ROUND_HALF_UP)) : "0" %> VND
                        </span>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
