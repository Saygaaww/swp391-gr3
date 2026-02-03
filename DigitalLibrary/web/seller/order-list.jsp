<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Order"%>
<%@page import="model.Reader"%>
<%@page import="model.Employee"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Đơn Hàng - Seller Dashboard</title>
    <link rel="stylesheet" href="../css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-box {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .stat-box h3 {
            margin: 0 0 10px 0;
            color: #1f2937;
            font-size: 24px;
        }
        
        .stat-box p {
            margin: 0;
            color: #6b7280;
            font-size: 14px;
        }
        
        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .filter-form {
            display: flex;
            gap: 15px;
            align-items: end;
            flex-wrap: wrap;
        }
        
        .orders-table {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        thead {
            background: #f3f4f6;
        }
        
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }
        
        th {
            font-weight: 600;
            color: #1f2937;
        }
        
        tr:hover {
            background: #f9fafb;
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
        
        .btn-view {
            padding: 6px 12px;
            background: #6366f1;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 13px;
        }
        
        .btn-view:hover {
            background: #4f46e5;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
        }
        
        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.3;
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
        
        List<Order> orders = (List<Order>) request.getAttribute("orders");
        Integer currentPage = (Integer) request.getAttribute("currentPage");
        Integer totalPages = (Integer) request.getAttribute("totalPages");
        Integer totalOrders = (Integer) request.getAttribute("totalOrders");
        String statusFilter = (String) request.getAttribute("statusFilter");
        java.math.BigDecimal totalRevenue = (java.math.BigDecimal) request.getAttribute("totalRevenue");
        Integer totalPaidOrders = (Integer) request.getAttribute("totalPaidOrders");
        Integer pendingOrders = (Integer) request.getAttribute("pendingOrders");
        
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
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
                <a href="<%= request.getContextPath() %>/seller/orders" class="nav-item active">
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
                    <h1>Quản Lý Đơn Hàng</h1>
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
                <!-- Stats Overview -->
                <div class="stats-overview">
                    <div class="stat-box">
                        <h3><%= totalOrders != null ? totalOrders : 0 %></h3>
                        <p><i class="fas fa-shopping-cart"></i> Tổng Đơn Hàng</p>
                    </div>
                    <div class="stat-box">
                        <h3><%= totalPaidOrders != null ? totalPaidOrders : 0 %></h3>
                        <p><i class="fas fa-check-circle"></i> Đã Thanh Toán</p>
                    </div>
                    <div class="stat-box">
                        <h3><%= pendingOrders != null ? pendingOrders : 0 %></h3>
                        <p><i class="fas fa-clock"></i> Chờ Xử Lý</p>
                    </div>
                    <div class="stat-box">
                        <h3><%= totalRevenue != null ? String.format("%,.0f", totalRevenue) : "0" %> VND</h3>
                        <p><i class="fas fa-dollar-sign"></i> Tổng Doanh Thu</p>
                    </div>
                </div>
                
                <!-- Filter Section -->
                <div class="filter-section">
                    <form method="GET" action="<%= request.getContextPath() %>/seller/orders" class="filter-form">
                        <div style="flex: 1; min-width: 200px;">
                            <label for="status" style="display: block; margin-bottom: 5px; color: #6b7280; font-size: 14px;">Lọc theo trạng thái:</label>
                            <select id="status" name="status" style="width: 100%; padding: 8px; border: 1px solid #e5e7eb; border-radius: 4px;">
                                <option value="all" <%= statusFilter == null || "all".equals(statusFilter) ? "selected" : "" %>>Tất cả</option>
                                <option value="pending" <%= "pending".equals(statusFilter) ? "selected" : "" %>>Chờ thanh toán</option>
                                <option value="paid" <%= "paid".equals(statusFilter) ? "selected" : "" %>>Đã thanh toán</option>
                                <option value="cancelled" <%= "cancelled".equals(statusFilter) ? "selected" : "" %>>Đã hủy</option>
                                <option value="refunded" <%= "refunded".equals(statusFilter) ? "selected" : "" %>>Đã hoàn tiền</option>
                            </select>
                        </div>
                        <div>
                            <label style="display: block; margin-bottom: 5px; color: transparent;">.</label>
                            <button type="submit" class="btn btn-primary" style="padding: 8px 20px;">
                                <i class="fas fa-filter"></i> Lọc
                            </button>
                        </div>
                    </form>
                </div>
                
                <!-- Orders Table -->
                <div class="orders-table">
                    <% if (orders != null && !orders.isEmpty()) { %>
                    <table>
                        <thead>
                            <tr>
                                <th>Mã Đơn</th>
                                <th>Khách Hàng</th>
                                <th>Tổng Tiền</th>
                                <th>Trạng Thái</th>
                                <th>Ngày Đặt</th>
                                <th>Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Order order : orders) { %>
                            <tr>
                                <td><strong>#<%= order.getOrderId() %></strong></td>
                                <td>
                                    <% if (order.getReader() != null) { %>
                                        <%= order.getReader().getFullName() != null ? order.getReader().getFullName() : order.getReader().getEmail() %>
                                    <% } else { %>
                                        Reader #<%= order.getReaderId() %>
                                    <% } %>
                                </td>
                                <td>
                                    <strong><%= String.format("%,.0f", order.getTotalAmount()) %> <%= order.getCurrency() != null ? order.getCurrency() : "VND" %></strong>
                                </td>
                                <td>
                                    <% 
                                        String status = order.getStatus() != null ? order.getStatus().toLowerCase() : "";
                                        String statusClass = "status-" + status;
                                        String statusDisplay = order.getStatusDisplay();
                                    %>
                                    <span class="status-badge <%= statusClass %>"><%= statusDisplay %></span>
                                </td>
                                <td>
                                    <%= order.getCreatedAt() != null ? order.getCreatedAt().format(dateFormatter) : "N/A" %>
                                </td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/seller/orders/view?id=<%= order.getOrderId() %>" class="btn-view">
                                        <i class="fas fa-eye"></i> Xem
                                    </a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                    
                    <!-- Pagination -->
                    <% if (totalPages != null && totalPages > 1) { %>
                    <div style="padding: 20px; text-align: center; border-top: 1px solid #e5e7eb;">
                        <% if (currentPage > 1) { %>
                        <a href="<%= request.getContextPath() %>/seller/orders?page=<%= currentPage - 1 %><%= statusFilter != null && !statusFilter.isEmpty() ? "&status=" + statusFilter : "" %>" 
                           style="padding: 8px 16px; margin: 0 5px; background: #6366f1; color: white; text-decoration: none; border-radius: 4px;">
                            <i class="fas fa-chevron-left"></i> Trước
                        </a>
                        <% } %>
                        
                        <% for (int i = 1; i <= totalPages; i++) {
                            if (i == 1 || i == totalPages || (i >= currentPage - 2 && i <= currentPage + 2)) {
                        %>
                        <a href="<%= request.getContextPath() %>/seller/orders?page=<%= i %><%= statusFilter != null && !statusFilter.isEmpty() ? "&status=" + statusFilter : "" %>" 
                           style="padding: 8px 12px; margin: 0 2px; <%= i == currentPage ? "background: #6366f1; color: white;" : "background: #f3f4f6; color: #1f2937;" %> text-decoration: none; border-radius: 4px;">
                            <%= i %>
                        </a>
                        <% } else if (i == currentPage - 3 || i == currentPage + 3) { %>
                        <span style="padding: 8px;">...</span>
                        <% }
                        } %>
                        
                        <% if (currentPage < totalPages) { %>
                        <a href="<%= request.getContextPath() %>/seller/orders?page=<%= currentPage + 1 %><%= statusFilter != null && !statusFilter.isEmpty() ? "&status=" + statusFilter : "" %>" 
                           style="padding: 8px 16px; margin: 0 5px; background: #6366f1; color: white; text-decoration: none; border-radius: 4px;">
                            Sau <i class="fas fa-chevron-right"></i>
                        </a>
                        <% } %>
                    </div>
                    <% } %>
                    
                    <% } else { %>
                    <div class="empty-state">
                        <i class="fas fa-shopping-cart"></i>
                        <h3>Chưa có đơn hàng nào</h3>
                        <p>Hiện tại chưa có đơn hàng nào trong hệ thống.</p>
                    </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
