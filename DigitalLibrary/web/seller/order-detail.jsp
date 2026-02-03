<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Order"%>
<%@page import="model.OrderBook"%>
<%@page import="model.Reader"%>
<%@page import="model.Payment"%>
<%@page import="model.Employee"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Đơn Hàng - Seller Dashboard</title>
    <link rel="stylesheet" href="../css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .order-detail-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
        }
        
        .order-info-card, .status-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .order-items-table {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }
        
        th {
            background: #f3f4f6;
            font-weight: 600;
        }
        
        .status-form {
            margin-top: 20px;
        }
        
        .status-form select {
            width: 100%;
            padding: 10px;
            border: 1px solid #e5e7eb;
            border-radius: 4px;
            margin-bottom: 15px;
        }
        
        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 13px;
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
        
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .info-label {
            color: #6b7280;
            font-weight: 500;
        }
        
        .info-value {
            color: #1f2937;
            font-weight: 600;
        }
        
        @media (max-width: 768px) {
            .order-detail-container {
                grid-template-columns: 1fr;
            }
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
        
        Order order = (Order) request.getAttribute("order");
        String message = request.getParameter("message");
        String error = request.getParameter("error");
        
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/seller/orders");
            return;
        }
        
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
                    <a href="<%= request.getContextPath() %>/seller/orders" style="color: #6366f1; text-decoration: none; margin-right: 15px;">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                    <h1>Chi Tiết Đơn Hàng #<%= order.getOrderId() %></h1>
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
                <div style="background: #d1fae5; color: #065f46; padding: 12px; border-radius: 6px; margin-bottom: 20px;">
                    <i class="fas fa-check-circle"></i> <%= message %>
                </div>
                <% } %>
                
                <% if (error != null) { %>
                <div style="background: #fee2e2; color: #991b1b; padding: 12px; border-radius: 6px; margin-bottom: 20px;">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                </div>
                <% } %>
                
                <div class="order-detail-container">
                    <!-- Left Column: Order Info & Items -->
                    <div>
                        <!-- Order Info -->
                        <div class="order-info-card">
                            <h2 style="margin-top: 0; margin-bottom: 20px;">Thông Tin Đơn Hàng</h2>
                            <div class="info-row">
                                <span class="info-label">Mã Đơn Hàng:</span>
                                <span class="info-value">#<%= order.getOrderId() %></span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Khách Hàng:</span>
                                <span class="info-value">
                                    <% if (order.getReader() != null) { %>
                                        <%= order.getReader().getFullName() != null ? order.getReader().getFullName() : order.getReader().getEmail() %>
                                        <br><small style="color: #6b7280; font-weight: normal;"><%= order.getReader().getEmail() %></small>
                                    <% } else { %>
                                        Reader #<%= order.getReaderId() %>
                                    <% } %>
                                </span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Ngày Đặt:</span>
                                <span class="info-value"><%= order.getCreatedAt() != null ? order.getCreatedAt().format(dateFormatter) : "N/A" %></span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Tổng Tiền:</span>
                                <span class="info-value" style="color: #10b981; font-size: 18px;">
                                    <%= String.format("%,.0f", order.getTotalAmount()) %> <%= order.getCurrency() != null ? order.getCurrency() : "VND" %>
                                </span>
                            </div>
                        </div>
                        
                        <!-- Order Items -->
                        <div class="order-items-table">
                            <h2 style="margin-top: 0; margin-bottom: 20px;">Danh Sách Sách</h2>
                            <% if (order.getItems() != null && !order.getItems().isEmpty()) { %>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Sách</th>
                                        <th>Số Lượng</th>
                                        <th>Đơn Giá</th>
                                        <th>Thành Tiền</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (OrderBook item : order.getItems()) { %>
                                    <tr>
                                        <td>
                                            <div style="display: flex; align-items: center; gap: 10px;">
                                                <% if (item.getBook() != null && item.getBook().getCoverUrl() != null && !item.getBook().getCoverUrl().isEmpty()) { %>
                                                <img src="<%= item.getBook().getCoverUrl() %>" alt="<%= item.getBook().getTitle() %>" 
                                                     style="width: 50px; height: 70px; object-fit: cover; border-radius: 4px;">
                                                <% } else { %>
                                                <div style="width: 50px; height: 70px; background: #f3f4f6; display: flex; align-items: center; justify-content: center; border-radius: 4px;">
                                                    <i class="fas fa-book" style="color: #9ca3af;"></i>
                                                </div>
                                                <% } %>
                                                <div>
                                                    <strong><%= item.getBook() != null ? item.getBook().getTitle() : "Book #" + item.getBookId() %></strong>
                                                </div>
                                            </div>
                                        </td>
                                        <td><%= item.getQuantity() %></td>
                                        <td><%= String.format("%,.0f", item.getPrice()) %> <%= item.getCurrency() %></td>
                                        <td><strong><%= String.format("%,.0f", item.getSubtotal()) %> <%= item.getCurrency() %></strong></td>
                                    </tr>
                                    <% } %>
                                </tbody>
                                <tfoot>
                                    <tr style="background: #f9fafb;">
                                        <td colspan="3" style="text-align: right; font-weight: 600;">Tổng Cộng:</td>
                                        <td style="font-weight: 700; font-size: 16px; color: #10b981;">
                                            <%= String.format("%,.0f", order.getTotalAmount()) %> <%= order.getCurrency() != null ? order.getCurrency() : "VND" %>
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                            <% } else { %>
                            <p style="color: #6b7280;">Không có sách nào trong đơn hàng này.</p>
                            <% } %>
                        </div>
                    </div>
                    
                    <!-- Right Column: Status & Payment -->
                    <div>
                        <!-- Status Card -->
                        <div class="status-card">
                            <h2 style="margin-top: 0; margin-bottom: 20px;">Trạng Thái Đơn Hàng</h2>
                            <div style="margin-bottom: 20px;">
                                <% 
                                    String status = order.getStatus() != null ? order.getStatus().toLowerCase() : "";
                                    String statusClass = "status-" + status;
                                    String statusDisplay = order.getStatusDisplay();
                                %>
                                <span class="status-badge <%= statusClass %>" style="font-size: 16px; padding: 10px 20px;">
                                    <%= statusDisplay %>
                                </span>
                            </div>
                            
                            <form method="POST" action="<%= request.getContextPath() %>/seller/orders/update-status" class="status-form">
                                <input type="hidden" name="action" value="update-status">
                                <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                
                                <label for="status" style="display: block; margin-bottom: 8px; color: #6b7280; font-weight: 500;">Cập nhật trạng thái:</label>
                                <select id="status" name="status" required>
                                    <option value="pending" <%= "pending".equals(status) ? "selected" : "" %>>Chờ thanh toán</option>
                                    <option value="paid" <%= "paid".equals(status) ? "selected" : "" %>>Đã thanh toán</option>
                                    <option value="cancelled" <%= "cancelled".equals(status) ? "selected" : "" %>>Đã hủy</option>
                                    <option value="refunded" <%= "refunded".equals(status) ? "selected" : "" %>>Đã hoàn tiền</option>
                                </select>
                                
                                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 12px;">
                                    <i class="fas fa-save"></i> Cập Nhật Trạng Thái
                                </button>
                            </form>
                        </div>
                        
                        <!-- Payment Info -->
                        <% if (order.getPayment() != null) { %>
                        <div class="order-info-card">
                            <h2 style="margin-top: 0; margin-bottom: 20px;">Thông Tin Thanh Toán</h2>
                            <div class="info-row">
                                <span class="info-label">Phương thức:</span>
                                <span class="info-value"><%= order.getPayment().getPaymentMethodDisplay() %></span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Trạng thái:</span>
                                <span class="info-value">
                                    <% 
                                        String paymentStatus = order.getPayment().getPaymentStatus() != null ? order.getPayment().getPaymentStatus().toLowerCase() : "";
                                        String paymentStatusDisplay = order.getPayment().getPaymentStatusDisplay();
                                    %>
                                    <span class="status-badge status-<%= paymentStatus %>"><%= paymentStatusDisplay %></span>
                                </span>
                            </div>
                            <% if (order.getPayment().getTransactionCode() != null) { %>
                            <div class="info-row">
                                <span class="info-label">Mã giao dịch:</span>
                                <span class="info-value"><%= order.getPayment().getTransactionCode() %></span>
                            </div>
                            <% } %>
                            <% if (order.getPayment().getPaidAt() != null) { %>
                            <div class="info-row">
                                <span class="info-label">Ngày thanh toán:</span>
                                <span class="info-value"><%= order.getPayment().getPaidAt().format(dateFormatter) %></span>
                            </div>
                            <% } %>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
