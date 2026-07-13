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
                background: #eef1f4;
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
                background: linear-gradient(135deg, #374151, #4b5563);
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
                color: #e5e7eb;
            }

            .header-date {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 0.85rem;
                color: #f3f4f6;
                background: rgba(255, 255, 255, 0.1);
                padding: 6px 14px;
                border-radius: 20px;
                backdrop-filter: blur(4px);
            }

            .header-tools {
                display: flex;
                flex-direction: column;
                align-items: flex-end;
                gap: 12px;
                z-index: 1;
            }

            .header-actions {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
                justify-content: flex-end;
            }

            .header-btn {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                text-decoration: none;
                font-size: 0.85rem;
                font-weight: 600;
                border-radius: 999px;
                padding: 8px 14px;
                transition: all 0.2s ease;
            }

            .header-btn-home {
                color: #111827;
                background: #f3f4f6;
            }

            .header-btn-home:hover {
                background: #ffffff;
            }

            .header-btn-logout {
                color: #f9fafb;
                background: rgba(17, 24, 39, 0.45);
            }

            .header-btn-logout:hover {
                background: rgba(17, 24, 39, 0.65);
            }

            .special-note {
                margin: 0 0 22px;
                padding: 14px 16px;
                border-radius: 10px;
                border: 1px solid #d1d5db;
                background: #ffffff;
                color: #4b5563;
                font-size: 0.92rem;
            }

            .admin-profile-card {
                background: #ffffff;
                border: 1px solid #d1d5db;
                border-radius: 12px;
                padding: 16px;
                margin: 0 0 24px;
            }

            .admin-profile-title {
                font-size: 0.95rem;
                font-weight: 600;
                color: #1f2937;
                margin-bottom: 12px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .admin-profile-title i {
                color: #475569;
            }

            .admin-profile-grid {
                display: grid;
                grid-template-columns: repeat(4, minmax(140px, 1fr));
                gap: 12px;
            }

            .admin-profile-item {
                background: #f8fafc;
                border: 1px solid #e5e7eb;
                border-radius: 10px;
                padding: 10px 12px;
            }

            .admin-profile-label {
                display: block;
                font-size: 0.74rem;
                color: #6b7280;
                text-transform: uppercase;
                letter-spacing: 0.04em;
                margin-bottom: 4px;
            }

            .admin-profile-value {
                font-size: 0.92rem;
                color: #111827;
                font-weight: 600;
                word-break: break-word;
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

            /* Special Admin Section */
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

            .special-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
            }

            .special-card {
                background: #fff;
                border-radius: 12px;
                padding: 24px 20px;
                text-decoration: none;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                transition: all 0.2s ease;
                display: flex;
                gap: 12px;
                border: 1px solid transparent;
            }

            .special-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 12px 20px -5px rgba(0, 0, 0, 0.08);
                border-color: #e5e7eb;
            }

            .special-icon {
                width: 48px;
                height: 48px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.2rem;
                flex-shrink: 0;
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

            .special-info h3 {
                font-size: 0.95rem;
                font-weight: 600;
                color: #111827;
                margin-bottom: 4px;
            }

            .special-info p {
                font-size: 0.82rem;
                color: #6b7280;
                line-height: 1.4;
            }

            /* Responsive */
            @media (max-width: 1024px) {

                .stats-grid,
                .special-grid {
                    grid-template-columns: repeat(2, 1fr);
                }

                .admin-profile-grid {
                    grid-template-columns: repeat(2, minmax(140px, 1fr));
                }
            }

            @media (max-width: 640px) {

                .stats-grid,
                .special-grid {
                    grid-template-columns: 1fr;
                }

                .admin-profile-grid {
                    grid-template-columns: 1fr;
                }

                .header-banner {
                    flex-direction: column;
                    gap: 16px;
                    padding: 24px;
                }

                .header-tools {
                    width: 100%;
                    align-items: flex-start;
                }

                .header-actions {
                    width: 100%;
                    justify-content: flex-start;
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

                <div class="header-tools">
                    <div class="header-date">
                        <i class="far fa-calendar-alt"></i>
                        <span id="dashboardDate"></span>
                    </div>
                    <div class="header-actions">
                        <a href="<%= request.getContextPath()%>/" class="header-btn header-btn-home" title="Quay về trang chủ">
                            <i class="fas fa-arrow-left"></i> Quay về trang chủ
                        </a>
                        <a href="<%= request.getContextPath()%>/auth/logout" class="header-btn header-btn-logout" title="Đăng xuất">
                            <i class="fas fa-sign-out-alt"></i> Đăng xuất
                        </a>
                    </div>
                </div>
            </div>

            <script>
                (function () {
                    const now = new Date();
                    const weekdays = ["Chủ nhật", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"];
                    const dd = String(now.getDate()).padStart(2, '0');
                    const mm = String(now.getMonth() + 1).padStart(2, '0');
                    const yyyy = now.getFullYear();
                    const label = weekdays[now.getDay()] + ', ' + dd + ' tháng ' + mm + ', ' + yyyy;
                    const dateEl = document.getElementById('dashboardDate');
                    if (dateEl) {
                        dateEl.textContent = label;
                    }
                })();
            </script>

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

            <div class="special-note">
                Trang này chỉ giữ vai trò tổng quan đặc biệt cho Admin. Các thao tác hằng ngày hãy dùng thanh tab chung để quản lý trực tiếp theo phân quyền.
            </div>

            <div class="admin-profile-card">
                <div class="admin-profile-title">
                    <i class="fas fa-id-badge"></i> Thông tin Admin đang đăng nhập
                </div>
                <div class="admin-profile-grid">
                    <div class="admin-profile-item">
                        <span class="admin-profile-label">Mã nhân viên</span>
                        <span class="admin-profile-value"><%= currentAdmin != null && currentAdmin.getEmployeeId() != null ? currentAdmin.getEmployeeId() : "-" %></span>
                    </div>
                    <div class="admin-profile-item">
                        <span class="admin-profile-label">Họ tên</span>
                        <span class="admin-profile-value"><%= currentAdmin != null && currentAdmin.getFullName() != null ? currentAdmin.getFullName() : "-" %></span>
                    </div>
                    <div class="admin-profile-item">
                        <span class="admin-profile-label">Email</span>
                        <span class="admin-profile-value"><%= currentAdmin != null && currentAdmin.getEmail() != null ? currentAdmin.getEmail() : "-" %></span>
                    </div>
                    <div class="admin-profile-item">
                        <span class="admin-profile-label">Vai trò / Trạng thái</span>
                        <span class="admin-profile-value"><%= currentAdmin != null ? (currentAdmin.getRoleName() + " / " + currentAdmin.getStatus()) : "-" %></span>
                    </div>
                </div>
            </div>

            <h2 class="section-title"><i class="fas fa-shield-alt"></i> Khu vực đặc biệt của Admin</h2>

            <div class="special-grid">
                <a href="<%= request.getContextPath()%>/admin/roles" class="special-card">
                    <div class="special-icon icon-rose"><i class="fas fa-key"></i></div>
                    <div class="special-info">
                        <h3>Điều phối phân quyền</h3>
                        <p>Quản lý vai trò hệ thống và kiểm soát phạm vi truy cập nâng cao.</p>
                    </div>
                </a>

                <a href="<%= request.getContextPath()%>/admin/borrowed-items" class="special-card">
                    <div class="special-icon icon-purple"><i class="fas fa-book-reader"></i></div>
                    <div class="special-info">
                        <h3>Giáám sát vận hành mượn trả</h3>
                        <p>Theo dõi trạng thái mượn trả toàn cục, xử lý các điểm nghẽn nghiệp vụ.</p>
                    </div>
                </a>

                <a href="<%= request.getContextPath()%>/admin/fines" class="special-card">
                    <div class="special-icon icon-orange"><i class="fas fa-money-bill-wave"></i></div>
                    <div class="special-info">
                        <h3>Kiểm soát tiền phạt</h3>
                        <p>Giáám sát phát sinh khoản phạt và điều phối xử lý theo chính sách.</p>
                    </div>
                </a>
            </div>

        </div>
    </body>

</html>
