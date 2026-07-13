<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f4f5f7; min-height: 100vh; }

        .header { background: #1a1a2e; color: #fff; padding: 0 40px; height: 64px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 12px rgba(0,0,0,0.3); }
        .header-left { display: flex; align-items: center; gap: 24px; }
        .header h1 { font-size: 18px; font-weight: 700; }
        .header h1 i { margin-right: 8px; }
        .header-nav { display: flex; gap: 4px; }
        .header-nav a { color: #ccc; text-decoration: none; padding: 8px 14px; border-radius: 6px; font-size: 13px; font-weight: 500; transition: all 0.2s; }
        .header-nav a:hover { color: #fff; background: rgba(255,255,255,0.1); }
        .header-nav a.active { color: #fff; background: rgba(255,255,255,0.12); }
        .header-right { display: flex; align-items: center; gap: 16px; }
        .user-badge { display: flex; align-items: center; gap: 8px; color: #ccc; font-size: 13px; }
        .user-badge strong { color: #fff; }
        .role-tag { background: #e74c3c; color: #fff; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; text-transform: uppercase; }
        .btn-logout { padding: 7px 14px; border: 1px solid rgba(255,255,255,0.25); color: #fff; border-radius: 6px; text-decoration: none; font-size: 13px; transition: all 0.2s; }
        .btn-logout:hover { background: rgba(255,255,255,0.1); }

        .container { max-width: 1200px; margin: 24px auto; padding: 0 20px; }

        .welcome-card {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            color: #fff; border-radius: 12px; padding: 35px 40px; margin-bottom: 24px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
            display: flex; justify-content: space-between; align-items: center;
        }
        .welcome-card h2 { font-size: 24px; margin-bottom: 6px; font-weight: 700; }
        .welcome-card p { font-size: 14px; opacity: 0.7; }
        .welcome-date { text-align: right; opacity: 0.7; font-size: 13px; }

        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px; }
        .stat-card {
            background: #fff; border-radius: 10px; padding: 22px;
            box-shadow: 0 1px 6px rgba(0,0,0,0.04); border: 1px solid #eee;
            position: relative; overflow: hidden; transition: all 0.25s;
            display: flex; align-items: center; gap: 16px;
        }
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 6px 20px rgba(0,0,0,0.08); }
        .stat-card::before { content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 3px; }
        .stat-card.c1::before { background: #4f46e5; }
        .stat-card.c2::before { background: #16a34a; }
        .stat-card.c3::before { background: #d97706; }
        .stat-card.c4::before { background: #e74c3c; }
        .stat-icon-box {
            width: 52px; height: 52px; border-radius: 12px; display: flex;
            align-items: center; justify-content: center; font-size: 22px;
        }
        .s1 { background: #eef2ff; color: #4f46e5; }
        .s2 { background: #dcfce7; color: #16a34a; }
        .s3 { background: #fef3c7; color: #d97706; }
        .s4 { background: #fce4ec; color: #e74c3c; }
        .stat-number { font-size: 28px; font-weight: 800; color: #1a1a2e; }
        .stat-label { font-size: 12px; color: #888; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin-top: 2px; }

        .quick-actions-title {
            font-size: 16px; font-weight: 700; color: #1a1a2e; margin-bottom: 16px;
            display: flex; align-items: center; gap: 8px;
        }
        .quick-actions-title i { color: #888; }

        .actions-grid {
            display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 16px;
            margin-bottom: 24px;
        }
        .action-card {
            background: #fff; border: 1px solid #eee; border-radius: 10px; padding: 24px 20px;
            text-decoration: none; color: #555; text-align: center; transition: all 0.2s;
            box-shadow: 0 1px 6px rgba(0,0,0,0.04);
        }
        .action-card:hover { border-color: #1a1a2e; background: #f8f8fb; transform: translateY(-3px); box-shadow: 0 6px 20px rgba(0,0,0,0.08); }
        .action-icon {
            width: 56px; height: 56px; border-radius: 14px; margin: 0 auto 12px;
            display: flex; align-items: center; justify-content: center; font-size: 24px;
        }
        .action-card h3 { font-size: 14px; color: #1a1a2e; margin-bottom: 4px; }
        .action-card p { font-size: 12px; color: #999; }
        .ic-book { background: #eef2ff; color: #4f46e5; }
        .ic-add { background: #dcfce7; color: #16a34a; }
        .ic-reader { background: #e0f2fe; color: #0284c7; }
        .ic-emp { background: #fef3c7; color: #d97706; }
        .ic-role { background: #fce4ec; color: #e91e63; }
        .ic-borrow { background: #f3e8ff; color: #9333ea; }
        .ic-history { background: #e8f5e9; color: #2e7d32; }

        @media (max-width: 992px) { .header-nav { display: none; } .stats-grid { grid-template-columns: 1fr 1fr; } }
        @media (max-width: 768px) { .header { padding: 0 16px; } .stats-grid { grid-template-columns: 1fr; } .actions-grid { grid-template-columns: 1fr 1fr; } .welcome-card { flex-direction: column; gap: 10px; } }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-left">
            <h1><i class="fas fa-tachometer-alt"></i> Dashboard</h1>
            <nav class="header-nav">
                <a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chu</a>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="${pageContext.request.contextPath}/books-list"><i class="fas fa-book"></i> Sach</a>
                <a href="${pageContext.request.contextPath}/admin/readers"><i class="fas fa-users"></i> Doc gia</a>
                <a href="${pageContext.request.contextPath}/admin/employees"><i class="fas fa-user-tie"></i> Nhan vien</a>
                <a href="${pageContext.request.contextPath}/admin/borrow-list"><i class="fas fa-clipboard-list"></i> Muon tra</a>
                <a href="${pageContext.request.contextPath}/admin/roles"><i class="fas fa-key"></i> Vai tro</a>
            </nav>
        </div>
        <div class="header-right">
            <div class="user-badge">
                <i class="fas fa-user-circle" style="font-size:20px;"></i>
                <strong>${currentEmployee.fullName}</strong>
                <span class="role-tag">${currentEmployee.roleName}</span>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
                <i class="fas fa-sign-out-alt"></i> Dang xuat
            </a>
        </div>
    </div>

    <div class="container">
        <div class="welcome-card">
            <div>
                <h2><i class="fas fa-hand-wave" style="margin-right:8px;"></i> Chao mung, ${currentEmployee.fullName}!</h2>
                <p>Tong quan he thong quan ly thu vien so - Digital Library Management System</p>
            </div>
            <div class="welcome-date">
                <i class="fas fa-calendar-alt"></i><br>
                <script>document.write(new Date().toLocaleDateString('vi-VN',{weekday:'long',year:'numeric',month:'long',day:'numeric'}));</script>
            </div>
        </div>

        <div class="stats-grid">
            <div class="stat-card c1">
                <div class="stat-icon-box s1"><i class="fas fa-book"></i></div>
                <div>
                    <div class="stat-number">${totalBooks}</div>
                    <div class="stat-label">Tong so sach</div>
                </div>
            </div>
            <div class="stat-card c2">
                <div class="stat-icon-box s2"><i class="fas fa-users"></i></div>
                <div>
                    <div class="stat-number">${totalReaders}</div>
                    <div class="stat-label">Doc gia</div>
                </div>
            </div>
            <div class="stat-card c3">
                <div class="stat-icon-box s3"><i class="fas fa-user-tie"></i></div>
                <div>
                    <div class="stat-number">${totalEmployees}</div>
                    <div class="stat-label">Nhan vien</div>
                </div>
            </div>
            <div class="stat-card c4">
                <div class="stat-icon-box s4"><i class="fas fa-key"></i></div>
                <div>
                    <div class="stat-number">${totalRoles}</div>
                    <div class="stat-label">Vai tro</div>
                </div>
            </div>
        </div>

        <h2 class="quick-actions-title"><i class="fas fa-bolt"></i> Thao tac nhanh</h2>
        <div class="actions-grid">
            <a href="${pageContext.request.contextPath}/books-list" class="action-card">
                <div class="action-icon ic-book"><i class="fas fa-list"></i></div>
                <h3>Danh sach sach</h3>
                <p>Xem va quan ly sach</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/book-form" class="action-card">
                <div class="action-icon ic-add"><i class="fas fa-plus"></i></div>
                <h3>Them sach moi</h3>
                <p>Them sach vao he thong</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/readers" class="action-card">
                <div class="action-icon ic-reader"><i class="fas fa-users"></i></div>
                <h3>Quan ly Doc gia</h3>
                <p>Xem danh sach doc gia</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/reader-form" class="action-card">
                <div class="action-icon ic-add"><i class="fas fa-user-plus"></i></div>
                <h3>Them Doc gia</h3>
                <p>Dang ky doc gia moi</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/employees" class="action-card">
                <div class="action-icon ic-emp"><i class="fas fa-user-tie"></i></div>
                <h3>Quan ly Nhan vien</h3>
                <p>Xem danh sach nhan vien</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/employee-form" class="action-card">
                <div class="action-icon ic-emp"><i class="fas fa-user-plus"></i></div>
                <h3>Them Nhan vien</h3>
                <p>Them nhan vien moi</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/borrow-approve" class="action-card">
                <div class="action-icon ic-borrow"><i class="fas fa-check-circle"></i></div>
                <h3>Duyet yeu cau muon</h3>
                <p>Xu ly yeu cau muon sach</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/borrow-list" class="action-card">
                <div class="action-icon ic-history"><i class="fas fa-history"></i></div>
                <h3>Lich su muon tra</h3>
                <p>Xem lich su yeu cau</p>
            </a>
            <a href="${pageContext.request.contextPath}/admin/roles" class="action-card">
                <div class="action-icon ic-role"><i class="fas fa-key"></i></div>
                <h3>Quan ly Vai tro</h3>
                <p>Phan quyen he thong</p>
            </a>
        </div>
    </div>
</body>
</html>