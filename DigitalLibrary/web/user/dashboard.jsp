<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Reader"%>
<%@page import="model.Employee"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - Digital Library</title>
    <link rel="stylesheet" href="../css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0,0,0,0.2) !important;
        }
        
        @media (max-width: 768px) {
            .quick-actions > div {
                grid-template-columns: 1fr !important;
            }
        }
    </style>
</head>
<body>
    <%
        // Kiểm tra đăng nhập (Reader hoặc Employee)
        Reader reader = (Reader) session.getAttribute("reader");
        Employee employee = (Employee) session.getAttribute("employee");
        String userRole = (String) session.getAttribute("userRole");
        
        if (reader == null && employee == null) {
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
    %>
    
    <div class="dashboard-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <a href="<%= request.getContextPath() %>/user/dashboard" style="text-decoration: none; color: inherit; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-book-reader"></i>
                    <h2>Digital Library</h2>
                </a>
            </div>
            <nav class="sidebar-nav">
                <a href="<%= request.getContextPath() %>/user/dashboard" class="nav-item active">
                    <i class="fas fa-home"></i>
                    <span>Trang Chủ</span>
                </a>
                <a href="<%= request.getContextPath() %>/books" class="nav-item">
                    <i class="fas fa-book"></i>
                    <span>Xem Sách</span>
                </a>
                <a href="<%= request.getContextPath() %>/cart" class="nav-item">
                    <i class="fas fa-shopping-cart"></i>
                    <span>Giỏ Hàng</span>
                </a>
                <a href="#" class="nav-item">
                    <i class="fas fa-hand-holding"></i>
                    <span>Mượn Sách</span>
                </a>
                <a href="#" class="nav-item">
                    <i class="fas fa-book-open"></i>
                    <span>Đang Đọc</span>
                </a>
                <a href="#" class="nav-item">
                    <i class="fas fa-bookmark"></i>
                    <span>Đánh Dấu</span>
                </a>
                <a href="#" class="nav-item">
                    <i class="fas fa-user"></i>
                    <span>Hồ Sơ</span>
                </a>
            </nav>
        </aside>
        
        <main class="main-content">
            <header class="dashboard-header">
                <div class="header-left">
                    <h1>User Dashboard</h1>
                </div>
                <div class="header-right">
                    <div class="user-menu">
                        <div class="user-info">
                            <i class="fas fa-user-circle"></i>
                            <span><%= userName != null ? userName : "Người Dùng" %></span>
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
                    <h2>Chào mừng, <%= userName != null ? userName : "Người Dùng" %>!</h2>
                    <p>Bạn đang ở trang cá nhân của bạn</p>
                    <% if (userRole != null) { %>
                        <p style="margin-top: 8px; font-size: 14px; color: #6b7280;">Role: <%= userRole %></p>
                    <% } %>
                </div>
                
                <!-- Quick Actions -->
                <div class="quick-actions" style="margin-bottom: 30px;">
                    <h3 style="margin-bottom: 20px; color: #1f2937; font-size: 20px;">Thao Tác Nhanh</h3>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px;">
                        <a href="<%= request.getContextPath() %>/books" class="action-card" style="display: block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 12px; text-decoration: none; transition: transform 0.3s ease, box-shadow 0.3s ease; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                            <div style="display: flex; align-items: center; gap: 15px;">
                                <div style="font-size: 48px; opacity: 0.9;">
                                    <i class="fas fa-book"></i>
                                </div>
                                <div>
                                    <h4 style="margin: 0 0 8px 0; font-size: 20px; font-weight: 600;">Xem Sách</h4>
                                    <p style="margin: 0; opacity: 0.9; font-size: 14px;">Khám phá và tìm kiếm sách</p>
                                </div>
                            </div>
                        </a>
                        
                        <a href="<%= request.getContextPath() %>/cart" class="action-card" style="display: block; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; padding: 30px; border-radius: 12px; text-decoration: none; transition: transform 0.3s ease, box-shadow 0.3s ease; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                            <div style="display: flex; align-items: center; gap: 15px;">
                                <div style="font-size: 48px; opacity: 0.9;">
                                    <i class="fas fa-shopping-cart"></i>
                                </div>
                                <div>
                                    <h4 style="margin: 0 0 8px 0; font-size: 20px; font-weight: 600;">Giỏ Hàng</h4>
                                    <p style="margin: 0; opacity: 0.9; font-size: 14px;">Xem và thanh toán đơn hàng</p>
                                </div>
                            </div>
                        </a>
                        
                        <a href="#" class="action-card" style="display: block; background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; padding: 30px; border-radius: 12px; text-decoration: none; transition: transform 0.3s ease, box-shadow 0.3s ease; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                            <div style="display: flex; align-items: center; gap: 15px;">
                                <div style="font-size: 48px; opacity: 0.9;">
                                    <i class="fas fa-hand-holding"></i>
                                </div>
                                <div>
                                    <h4 style="margin: 0 0 8px 0; font-size: 20px; font-weight: 600;">Mượn Sách</h4>
                                    <p style="margin: 0; opacity: 0.9; font-size: 14px;">Yêu cầu mượn sách từ thư viện</p>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
                
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                            <i class="fas fa-book"></i>
                        </div>
                        <div class="stat-info">
                            <h3>12</h3>
                            <p>Sách Đã Mua</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                            <i class="fas fa-book-open"></i>
                        </div>
                        <div class="stat-info">
                            <h3>5</h3>
                            <p>Đang Đọc</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                            <i class="fas fa-bookmark"></i>
                        </div>
                        <div class="stat-info">
                            <h3>8</h3>
                            <p>Đánh Dấu</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="stat-info">
                            <h3>15</h3>
                            <p>Đã Đánh Giá</p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
