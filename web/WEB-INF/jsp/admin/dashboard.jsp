<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="model.Employee, util.AuthUtil" %>
        <% Employee currentAdmin=(Employee) session.getAttribute(AuthUtil.SESSION_USER); // Nếu chưa đăng nhập hoặc
            không phải admin, báo lỗi hoặc tự động được controller xử lý %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>
                    <%= request.getAttribute("pageTitle") !=null ? request.getAttribute("pageTitle")
                        : "Admin Control Panel" %>
                </title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                <style>
                    *,
                    *::before,
                    *::after {
                        box-sizing: border-box;
                        margin: 0;
                        padding: 0;
                    }

                    body {
                        font-family: 'Inter', sans-serif;
                        background: #f3f4f6;
                        color: #111827;
                        display: flex;
                        min-height: 100vh;
                    }

                    /* Sidebar */
                    .sidebar {
                        width: 260px;
                        background: #ffffff;
                        border-right: 1px solid #e5e7eb;
                        display: flex;
                        flex-direction: column;
                        position: fixed;
                        top: 0;
                        bottom: 0;
                        left: 0;
                        z-index: 50;
                    }

                    .sidebar-header {
                        padding: 24px 20px;
                        border-bottom: 1px solid #f3f4f6;
                        display: flex;
                        align-items: center;
                        gap: 12px;
                    }

                    .sidebar-header .icon-cube {
                        width: 40px;
                        height: 40px;
                        background: linear-gradient(135deg, #6366f1, #8b5cf6);
                        border-radius: 10px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #fff;
                        font-size: 1.2rem;
                    }

                    .sidebar-header .title {
                        font-weight: 700;
                        font-size: 1.1rem;
                        color: #111827;
                        line-height: 1.2;
                    }

                    .sidebar-header .subtitle {
                        font-size: 0.75rem;
                        color: #6b7280;
                        font-weight: 500;
                    }

                    .nav-menu {
                        flex: 1;
                        padding: 20px 14px;
                        overflow-y: auto;
                    }

                    .nav-group {
                        margin-bottom: 24px;
                    }

                    .nav-group-title {
                        font-size: 0.7rem;
                        font-weight: 700;
                        color: #9ca3af;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                        margin-bottom: 8px;
                        padding-left: 12px;
                    }

                    .nav-link {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        padding: 10px 12px;
                        border-radius: 8px;
                        color: #4b5563;
                        font-size: 0.9rem;
                        font-weight: 500;
                        text-decoration: none;
                        transition: all 0.2s;
                        margin-bottom: 4px;
                    }

                    .nav-link i {
                        width: 20px;
                        text-align: center;
                        font-size: 1.1rem;
                        color: #9ca3af;
                        transition: color 0.2s;
                    }

                    .nav-link:hover {
                        background: #f3f4f6;
                        color: #111827;
                    }

                    .nav-link.active {
                        background: #ede9fe;
                        color: #7c3aed;
                        font-weight: 600;
                    }

                    .nav-link.active i {
                        color: #7c3aed;
                    }

                    .sidebar-footer {
                        padding: 20px;
                        border-top: 1px solid #f3f4f6;
                    }

                    .user-profile {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                    }

                    .user-avatar {
                        width: 40px;
                        height: 40px;
                        border-radius: 50%;
                        background: #e5e7eb;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        color: #6b7280;
                        font-weight: 600;
                        font-size: 1.1rem;
                    }

                    .user-info {
                        flex: 1;
                        overflow: hidden;
                    }

                    .user-name {
                        font-weight: 600;
                        font-size: 0.85rem;
                        color: #111827;
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                    }

                    .user-role {
                        font-size: 0.75rem;
                        color: #6b7280;
                    }

                    .logout-btn {
                        color: #9ca3af;
                        cursor: pointer;
                        transition: color 0.2s;
                        text-decoration: none;
                    }

                    .logout-btn:hover {
                        color: #dc2626;
                    }

                    /* Main Content */
                    .main-content {
                        flex: 1;
                        margin-left: 260px;
                        padding: 30px 40px;
                        display: flex;
                        flex-direction: column;
                    }

                    .page-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 30px;
                    }

                    .page-title {
                        font-size: 1.5rem;
                        font-weight: 700;
                        color: #111827;
                    }

                    /* Stats Grid */
                    .stats-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
                        gap: 20px;
                        margin-bottom: 30px;
                    }

                    .stat-card {
                        background: #fff;
                        border-radius: 16px;
                        padding: 24px;
                        border: 1px solid #e5e7eb;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);
                        display: flex;
                        align-items: flex-start;
                        gap: 16px;
                        transition: transform 0.2s;
                    }

                    .stat-card:hover {
                        transform: translateY(-3px);
                        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.06);
                    }

                    .stat-icon {
                        width: 56px;
                        height: 56px;
                        border-radius: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.5rem;
                        flex-shrink: 0;
                    }

                    .stat-icon.users {
                        background: #dbeafe;
                        color: #3b82f6;
                    }

                    .stat-icon.employees {
                        background: #ede9fe;
                        color: #8b5cf6;
                    }

                    .stat-icon.books {
                        background: #fef3c7;
                        color: #d97706;
                    }

                    .stat-icon.revenue {
                        background: #dcfce3;
                        color: #16a34a;
                    }

                    .stat-info {
                        flex: 1;
                    }

                    .stat-label {
                        font-size: 0.85rem;
                        color: #6b7280;
                        font-weight: 600;
                        margin-bottom: 6px;
                    }

                    .stat-value {
                        font-size: 1.8rem;
                        font-weight: 700;
                        color: #111827;
                        line-height: 1.1;
                    }

                    /* Content Area */
                    .content-card {
                        background: #fff;
                        border-radius: 16px;
                        border: 1px solid #e5e7eb;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.03);
                        padding: 30px;
                        text-align: center;
                        color: #6b7280;
                        flex: 1;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                    }

                    .alert {
                        border-radius: 10px;
                        padding: 12px 16px;
                        margin-bottom: 20px;
                        font-size: 0.9rem;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        background: #eff6ff;
                        border: 1px solid #bfdbfe;
                        color: #1d4ed8;
                    }
                </style>
            </head>

            <body>

                <!-- SIDEBAR -->
                <aside class="sidebar">
                    <div class="sidebar-header">
                        <div class="icon-cube"><i class="fas fa-shield-alt"></i></div>
                        <div>
                            <div class="title">Digital Library</div>
                            <div class="subtitle">Admin Control Panel</div>
                        </div>
                    </div>

                    <nav class="nav-menu">
                        <div class="nav-group">
                            <div class="nav-group-title">Tổng quan</div>
                            <a href="<%= request.getContextPath() %>/admin/dashboard"
                                class="nav-link <%= request.getRequestURI().endsWith(" /admin/dashboard") ||
                                request.getRequestURI().endsWith("/admin") ? "active" : "" %>">
                                <i class="fas fa-chart-pie"></i> Dashboard
                            </a>
                        </div>

                        <div class="nav-group">
                            <div class="nav-group-title">Quản lý Tài khoản</div>
                            <a href="<%= request.getContextPath() %>/admin/users"
                                class="nav-link <%= request.getRequestURI().endsWith(" /admin/users") ? "active" : ""
                                %>">
                                <i class="fas fa-users"></i> Người dùng (Readers)
                            </a>
                            <a href="<%= request.getContextPath() %>/admin/employees"
                                class="nav-link <%= request.getRequestURI().endsWith(" /admin/employees") ? "active"
                                : "" %>">
                                <i class="fas fa-user-tie"></i> Nhân viên (Staff)
                            </a>
                        </div>

                        <div class="nav-group">
                            <div class="nav-group-title">Khác</div>
                            <a href="<%= request.getContextPath() %>/books" class="nav-link">
                                <i class="fas fa-book"></i> Về Thư viện sách
                            </a>
                        </div>
                    </nav>

                    <div class="sidebar-footer">
                        <div class="user-profile">
                            <div class="user-avatar">
                                <%= currentAdmin !=null ? currentAdmin.getFullName().substring(0, 1).toUpperCase() : "A"
                                    %>
                            </div>
                            <div class="user-info">
                                <div class="user-name">
                                    <%= currentAdmin !=null ? currentAdmin.getFullName() : "Admin" %>
                                </div>
                                <div class="user-role">Administrator</div>
                            </div>
                            <a href="<%= request.getContextPath() %>/auth/logout" class="logout-btn" title="Đăng xuất">
                                <i class="fas fa-sign-out-alt"></i>
                            </a>
                        </div>
                    </div>
                </aside>

                <!-- MAIN CONTENT -->
                <main class="main-content">
                    <div class="page-header">
                        <h1 class="page-title">
                            <%= request.getAttribute("pageTitle") !=null ? request.getAttribute("pageTitle")
                                : "Dashboard" %>
                        </h1>
                    </div>

                    <% if (request.getAttribute("message") !=null) { %>
                        <div class="alert"><i class="fas fa-info-circle"></i>
                            <%= request.getAttribute("message") %>
                        </div>
                        <% } %>

                            <!-- Stats (Chỉ hiện ở Dashboard chính) -->
                            <% if (request.getRequestURI().endsWith("/admin") ||
                                request.getRequestURI().endsWith("/admin/dashboard")) { %>
                                <div class="stats-grid">
                                    <div class="stat-card">
                                        <div class="stat-icon users"><i class="fas fa-users"></i></div>
                                        <div class="stat-info">
                                            <div class="stat-label">Tổng Người Dùng</div>
                                            <div class="stat-value">1,204</div>
                                        </div>
                                    </div>
                                    <div class="stat-card">
                                        <div class="stat-icon employees"><i class="fas fa-user-tie"></i></div>
                                        <div class="stat-info">
                                            <div class="stat-label">Nhân Viên</div>
                                            <div class="stat-value">12</div>
                                        </div>
                                    </div>
                                    <div class="stat-card">
                                        <div class="stat-icon books"><i class="fas fa-book"></i></div>
                                        <div class="stat-info">
                                            <div class="stat-label">Tổng Sách</div>
                                            <div class="stat-value">845</div>
                                        </div>
                                    </div>
                                    <div class="stat-card">
                                        <div class="stat-icon revenue"><i class="fas fa-chart-line"></i></div>
                                        <div class="stat-info">
                                            <div class="stat-label">Hoạt Động Tháng</div>
                                            <div class="stat-value">+24%</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="content-card">
                                    <i class="fas fa-cogs"
                                        style="font-size: 3rem; color: #d1d5db; margin-bottom: 16px;"></i>
                                    <h3 style="color:#374151; margin-bottom: 8px;">Hệ thống đang hoạt động ổn định</h3>
                                    <p>Các tính năng quản trị chi tiết đang được phát triển trong giai đoạn sau.</p>
                                </div>
                                <% } else { %>
                                    <div class="content-card">
                                        <i class="fas fa-tools"
                                            style="font-size: 3rem; color: #d1d5db; margin-bottom: 16px;"></i>
                                        <h3 style="color:#374151; margin-bottom: 8px;">Khu vực đang thi công</h3>
                                        <p>Mô-đun quản lý này đang được FPT Student Team tiến hành xây dựng.</p>
                                    </div>
                                    <% } %>
                </main>

            </body>

            </html>