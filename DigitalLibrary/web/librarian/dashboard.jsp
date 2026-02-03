<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Reader"%>
<%@page import="model.Employee"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Librarian Dashboard - Digital Library</title>
    <link rel="stylesheet" href="../css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <%
        // Kiểm tra đăng nhập và quyền LIBRARIAN (từ Reader hoặc Employee)
        Reader reader = (Reader) session.getAttribute("reader");
        Employee employee = (Employee) session.getAttribute("employee");
        String userRole = (String) session.getAttribute("userRole");
        
        if ((reader == null && employee == null) || userRole == null || !"LIBRARIAN".equals(userRole)) {
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
                <a href="<%= request.getContextPath() %>/librarian/dashboard" style="text-decoration: none; color: inherit; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-book-reader"></i>
                    <h2>Digital Library</h2>
                </a>
            </div>
            <nav class="sidebar-nav">
                <a href="<%= request.getContextPath() %>/librarian/dashboard" class="nav-item active">
                    <i class="fas fa-home"></i>
                    <span>Trang Chủ</span>
                </a>
                <a href="<%= request.getContextPath() %>/books" class="nav-item">
                    <i class="fas fa-book"></i>
                    <span>Quản Lý Sách</span>
                </a>
                <a href="#" class="nav-item">
                    <i class="fas fa-hand-holding"></i>
                    <span>Yêu Cầu Mượn</span>
                </a>
                <a href="#" class="nav-item">
                    <i class="fas fa-clock"></i>
                    <span>Gia Hạn</span>
                </a>
                <a href="#" class="nav-item">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>Vi Phạm</span>
                </a>
            </nav>
        </aside>
        
        <main class="main-content">
            <header class="dashboard-header">
                <div class="header-left">
                    <h1>Librarian Dashboard</h1>
                </div>
                <div class="header-right">
                    <div class="user-menu">
                        <div class="user-info">
                            <i class="fas fa-user-circle"></i>
                            <span><%= userName != null ? userName : "Thủ Thư" %></span>
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
                    <h2>Chào mừng, <%= userName != null ? userName : "Thủ Thư" %>!</h2>
                    <p>Bạn đang ở trang quản lý thư viện</p>
                    <% if (userRole != null) { %>
                        <p style="margin-top: 8px; font-size: 14px; color: #6b7280;">Role: <%= userRole %> | Type: <%= reader != null ? "Reader" : "Employee" %></p>
                    <% } %>
                </div>
                
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                            <i class="fas fa-book"></i>
                        </div>
                        <div class="stat-info">
                            <h3>456</h3>
                            <p>Sách Đang Mượn</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-info">
                            <h3>23</h3>
                            <p>Yêu Cầu Chờ</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <div class="stat-info">
                            <h3>12</h3>
                            <p>Quá Hạn</p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
