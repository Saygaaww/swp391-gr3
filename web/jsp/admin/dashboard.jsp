<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER);
    /* Nếu chưa đăng nhập hoặc
    không phải admin, báo lỗi hoặc tự động được controller xử lý */%>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>
            <%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle")
                            : "Admin Control Panel"%>
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
                background: #f4f7fe;
                color: #111827;
                min-height: 100vh;
                padding: 24px;
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .dashboard-container {
                width: 100%;
                max-width: 1200px;
            }

            /* Header Banner */
            .header-banner {
                background: linear-gradient(135deg, #111827, #1e3a8a);
                border-radius: 16px;
                padding: 32px 40px;
                color: white;
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 24px;
                box-shadow: 0 10px 25px rgba(17, 24, 39, 0.15);
                position: relative;
                overflow: hidden;
            }

            .header-banner::after {
                content: '';
                position: absolute;
                right: 0;
                top: 0;
                width: 40%;
                height: 100%;
                background: radial-gradient(circle at top right, rgba(255, 255, 255, 0.1) 0%, transparent 60%);
            }

            .header-content h1 {
                font-size: 1.75rem;
                font-weight: 700;
                margin-bottom: 8px;
            }

            .header-content p {
                font-size: 0.9rem;
                color: #9ca3af;
            }

            .header-date {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 0.85rem;
                color: #d1d5db;
                background: rgba(255, 255, 255, 0.1);
                padding: 6px 14px;
                border-radius: 20px;
                backdrop-filter: blur(4px);
            }

            /* Stats Grid */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
                margin-bottom: 40px;
            }

            .stat-card {
                background: #fff;
                border-radius: 12px;
                padding: 20px 24px;
                display: flex;
                align-items: center;
                gap: 16px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                transition: transform 0.2s, box-shadow 0.2s;
                border-top: 4px solid transparent;
            }

            .stat-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            }

            .stat-card.books {
                border-top-color: #6366f1;
            }

            .stat-card.readers {
                border-top-color: #10b981;
            }

            .stat-card.staff {
                border-top-color: #f59e0b;
            }

            .stat-card.roles {
                border-top-color: #ef4444;
            }

            .stat-icon {
                width: 48px;
                height: 48px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.25rem;
                flex-shrink: 0;
            }

            .stat-card.books .stat-icon {
                background: #e0e7ff;
                color: #4f46e5;
            }

            .stat-card.readers .stat-icon {
                background: #d1fae5;
                color: #059669;
            }

            .stat-card.staff .stat-icon {
                background: #fef3c7;
                color: #d97706;
            }

            .stat-card.roles .stat-icon {
                background: #fee2e2;
                color: #dc2626;
            }

            .stat-info .stat-value {
                font-size: 1.5rem;
                font-weight: 700;
                color: #111827;
                line-height: 1.2;
            }

            .stat-info .stat-label {
                font-size: 0.75rem;
                font-weight: 600;
                color: #6b7280;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                margin-top: 4px;
            }

            /* Quick Actions Section */
            .section-title {
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 1.1rem;
                font-weight: 600;
                color: #374151;
                margin-bottom: 20px;
            }

            .section-title i {
                color: #6b7280;
            }

            .actions-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 20px;
            }

            .action-card {
                background: #fff;
                border-radius: 12px;
                padding: 24px 20px;
                text-align: center;
                text-decoration: none;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                transition: all 0.2s ease;
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 12px;
                border: 1px solid transparent;
            }

            .action-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 12px 20px -5px rgba(0, 0, 0, 0.08);
                border-color: #e5e7eb;
            }

            .action-icon {
                width: 56px;
                height: 56px;
                border-radius: 14px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                transition: transform 0.2s;
            }

            .action-card:hover .action-icon {
                transform: scale(1.05);
            }

            /* Colored Icons for Actions */
            .icon-blue {
                background: #eff6ff;
                color: #3b82f6;
            }

            .icon-green {
                background: #f0fdf4;
                color: #22c55e;
            }

            .icon-cyan {
                background: #ecfeff;
                color: #06b6d4;
            }

            .icon-emerald {
                background: #ecfdf5;
                color: #10b981;
            }

            .icon-yellow {
                background: #fefce8;
                color: #eab308;
            }

            .icon-orange {
                background: #fff7ed;
                color: #f97316;
            }

            .icon-purple {
                background: #faf5ff;
                color: #a855f7;
            }

            .icon-rose {
                background: #fff1f2;
                color: #f43f5e;
            }

            .action-info h3 {
                font-size: 0.95rem;
                font-weight: 600;
                color: #111827;
                margin-bottom: 4px;
            }

            .action-info p {
                font-size: 0.75rem;
                color: #9ca3af;
                line-height: 1.4;
            }

            /* Responsive */
            @media (max-width: 1024px) {

                .stats-grid,
                .actions-grid {
                    grid-template-columns: repeat(2, 1fr);
                }
            }

            @media (max-width: 640px) {

                .stats-grid,
                .actions-grid {
                    grid-template-columns: 1fr;
                }

                .header-banner {
                    flex-direction: column;
                    gap: 16px;
                    padding: 24px;
                }
            }
        </style>
    </head>

    <body>
        <div class="dashboard-container">

            <!-- Header Banner -->
            <div class="header-banner">
                <div class="header-content">
                    <h1>Chào mừng, <%= currentAdmin != null ? currentAdmin.getFullName() : "System Admin"%>!
                    </h1>
                    <p>Tổng quan quản lý thư viện số - Digital Library Management System</p>
                </div>

                <div class="header-date">
                    <i class="far fa-calendar-alt"></i>
                    <% java.time.LocalDate today = java.time.LocalDate.now();
                                java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("'Thứ' e, dd 'tháng' MM, yyyy",
                                        new java.util.Locale("vi", "VN"));
                                out.print(today.format(formatter));%>
                </div>
                <a href="<%= request.getContextPath()%>/auth/logout"
                   style="position: absolute; right: 24px; bottom: 24px; color: #9ca3af; text-decoration: none; font-size: 1.2rem; transition: color 0.2s; z-index:1000;"
                   title="Đăng xuất"
                   onmouseover="this.style.color = '#fff'"
                   onmouseout="this.style.color = '#9ca3af'">

                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                </a>
            </div>

            <!-- Statistics Grid -->
            <div class="stats-grid">
                <div class="stat-card books">
                    <div class="stat-icon"><i class="fas fa-book"></i></div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <%= request.getAttribute("totalBooks") != null ? request.getAttribute("totalBooks")
                                            : "13"%>
                        </div>
                        <div class="stat-label">TỔNG SỐ SÁCH</div>
                    </div>
                </div>

                <div class="stat-card readers">
                    <div class="stat-icon"><i class="fas fa-users"></i></div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <%= request.getAttribute("totalReaders") != null
                                            ? request.getAttribute("totalReaders") : "6"%>
                        </div>
                        <div class="stat-label">ĐỘC GIẢ</div>
                    </div>
                </div>

                <div class="stat-card staff">
                    <div class="stat-icon"><i class="fas fa-user-tie"></i></div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <%= request.getAttribute("totalEmployees") != null
                                            ? request.getAttribute("totalEmployees") : "7"%>
                        </div>
                        <div class="stat-label">NHÂN VIÊN</div>
                    </div>
                </div>

                <div class="stat-card roles">
                    <div class="stat-icon"><i class="fas fa-key"></i></div>
                    <div class="stat-info">
                        <div class="stat-value">
                            <%= request.getAttribute("totalRoles") != null ? request.getAttribute("totalRoles")
                                            : "4"%>
                        </div>
                        <div class="stat-label">VAI TRÒ</div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <h2 class="section-title"><i class="fas fa-bolt"></i> Thao tac nhanh</h2>

            <div class="actions-grid">
                <!-- Sách -->
                <a href="<%= request.getContextPath()%>/admin/book-list" class="action-card">
                    <div class="action-icon icon-blue"><i class="fas fa-list-ul"></i></div>
                    <div class="action-info">
                        <h3>Danh sách sách</h3>
                        <p>Xem va quan ly sach</p>
                    </div>
                </a>

                <a href="<%= request.getContextPath()%>/admin/book-form" class="action-card">
                    <div class="action-icon icon-green"><i class="fas fa-plus"></i></div>
                    <div class="action-info">
                        <h3>Thêm sách mới</h3>
                        <p>Thêm sách vào hệ thống</p>
                    </div>
                </a>

                <a href="<%= request.getContextPath()%>/admin/book-list" class="action-card">
                    <div class="action-icon icon-blue"><i class="fas fa-upload"></i></div>
                    <div class="action-info">
                        <h3>Upload nội dung sách</h3>
                        <p>PDF, EPUB - chọn sách trong danh sách để upload</p>
                    </div>
                </a>

                <!-- Độc giả -->
                <a href="<%= request.getContextPath()%>/admin/readers" class="action-card">
                    <div class="action-icon icon-cyan"><i class="fas fa-user-friends"></i></div>
                    <div class="action-info">
                        <h3>Quản lý Độc giả</h3>
                        <p>Xem danh sách độc giả</p>
                    </div>
                </a>

                <a href="<%= request.getContextPath()%>/admin/reader-form" class="action-card">
                    <div class="action-icon icon-emerald"><i class="fas fa-user-plus"></i></div>
                    <div class="action-info">
                        <h3>Thêm Độc giả</h3>
                        <p>Đăng ký độc giả mới</p>
                    </div>
                </a>

                <!-- Nhân viên -->
                <a href="<%= request.getContextPath()%>/admin/employees" class="action-card">
                    <div class="action-icon icon-yellow"><i class="fas fa-user-tie"></i></div>
                    <div class="action-info">
                        <h3>Quản lý Nhân viên</h3>
                        <p>Xem danh sách nhân viên</p>
                    </div>
                </a>

                <a href="<%= request.getContextPath()%>/admin/employee-form" class="action-card">
                    <div class="action-icon icon-orange"><i class="fas fa-user-plus"></i></div>
                    <div class="action-info">
                        <h3>Thêm Nhân Viên</h3>
                        <p>Thêm Nhân Viên Mới</p>
                    </div>
                </a>

                <!-- Mượn trả & Vai trò -->
                <a href="<%= request.getContextPath()%>/admin/borrow-list" class="action-card">
                    <div class="action-icon icon-purple"><i class="fas fa-check-circle"></i></div>
                    <div class="action-info">
                        <h3>Duyệt yêu cầu mượn</h3>
                        <p>Xử lý yêu cầu mượn</p>
                    </div>
                </a>

                <a href="<%= request.getContextPath()%>/admin/reservations" class="action-card">
                    <div class="action-icon icon-yellow"><i class="fas fa-bookmark"></i></div>
                    <div class="action-info">
                        <h3>Manage Reservations</h3>
                        <p>Queue, assign, skip, confirm borrow</p>
                    </div>
                </a>

                <a href="<%= request.getContextPath()%>/admin/roles" class="action-card">
                    <div class="action-icon icon-rose"><i class="fas fa-key"></i></div>
                    <div class="action-info">
                        <h3>Quản lý vai trò</h3>
                        <p>Phân Quyền Hệ Thống</p>
                    </div>
                </a>

                <!-- Sales Report -->
                <a href="<%= request.getContextPath()%>/admin/sales-report" class="action-card">
                    <div class="action-icon icon-blue"><i class="fas fa-file-invoice-dollar"></i></div>
                    <div class="action-info">
                        <h3>Báo cáo bán hàng</h3>
                        <p>Xem báo cáo đơn hàng và thanh toán</p>
                    </div>
                </a>

                <!-- Sales Analytics -->
                <a href="<%= request.getContextPath()%>/admin/sales-analytics" class="action-card">
                    <div class="action-icon icon-green"><i class="fas fa-chart-line"></i></div>
                    <div class="action-info">
                        <h3>Phân tích dữ liệu bán hàng</h3>
                        <p>Thống kê doanh số, doanh thu, top sách</p>
                    </div>
                </a>
            </div>

        </div>
    </body>

</html>
