<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Reader"%>
<%@page import="model.Employee"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chọn Khách Hàng - Seller Dashboard</title>
    <link rel="stylesheet" href="../css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .search-section {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .search-form {
            display: flex;
            gap: 10px;
        }
        
        .search-form input {
            flex: 1;
            padding: 10px;
            border: 1px solid #e5e7eb;
            border-radius: 4px;
        }
        
        .customers-list {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .customer-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            border-bottom: 1px solid #e5e7eb;
            cursor: pointer;
            transition: background 0.2s;
        }
        
        .customer-item:hover {
            background: #f9fafb;
        }
        
        .customer-item:last-child {
            border-bottom: none;
        }
        
        .customer-info {
            flex: 1;
        }
        
        .customer-name {
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 5px;
        }
        
        .customer-email {
            color: #6b7280;
            font-size: 14px;
        }
        
        .btn-select {
            padding: 8px 20px;
            background: #6366f1;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-select:hover {
            background: #4f46e5;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
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
        
        List<Reader> customers = (List<Reader>) request.getAttribute("customers");
        String search = (String) request.getAttribute("search");
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
                    <h1>Chọn Khách Hàng</h1>
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
                <div style="background: #fee2e2; color: #991b1b; padding: 12px; border-radius: 6px; margin-bottom: 20px;">
                    <i class="fas fa-exclamation-circle"></i> 
                    <% if ("customer_not_found".equals(error)) { %>
                        Không tìm thấy khách hàng
                    <% } else { %>
                        <%= error %>
                    <% } %>
                </div>
                <% } %>
                
                <div class="search-section">
                    <form method="GET" action="<%= request.getContextPath() %>/seller/cart/select-customer" class="search-form">
                        <input type="text" name="search" placeholder="Tìm kiếm theo tên hoặc email..." 
                               value="<%= search != null ? search : "" %>">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                    </form>
                </div>
                
                <div class="customers-list">
                    <% if (customers != null && !customers.isEmpty()) { %>
                        <% for (Reader customer : customers) { %>
                        <div class="customer-item">
                            <div class="customer-info">
                                <div class="customer-name">
                                    <%= customer.getFullName() != null ? customer.getFullName() : "Không có tên" %>
                                </div>
                                <div class="customer-email">
                                    <i class="fas fa-envelope"></i> <%= customer.getEmail() %>
                                </div>
                            </div>
                            <form method="POST" action="<%= request.getContextPath() %>/seller/cart/select-customer" style="margin: 0;">
                                <input type="hidden" name="action" value="select-customer">
                                <input type="hidden" name="readerId" value="<%= customer.getReaderId() %>">
                                <button type="submit" class="btn-select">
                                    <i class="fas fa-check"></i> Chọn
                                </button>
                            </form>
                        </div>
                        <% } %>
                    <% } else { %>
                        <div class="empty-state">
                            <i class="fas fa-users" style="font-size: 64px; opacity: 0.3; margin-bottom: 20px;"></i>
                            <h3>Không tìm thấy khách hàng</h3>
                            <p><%= search != null ? "Thử tìm kiếm với từ khóa khác" : "Chưa có khách hàng nào trong hệ thống" %></p>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
