<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Admin</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f0f0;
            min-height: 100vh;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header h1 {
            font-size: 28px;
            font-weight: 600;
        }
        
        .user-info {
            text-align: right;
        }
        
        .user-info strong {
            display: block;
            font-size: 16px;
        }
        
        .user-info small {
            font-size: 12px;
            opacity: 0.8;
        }
        
        .btn-logout {
            margin-top: 8px;
            padding: 8px 16px;
            background: rgba(255,255,255,0.2);
            border: 2px solid white;
            color: white;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
            display: inline-block;
        }
        
        .btn-logout:hover {
            background: white;
            color: #667eea;
        }
        
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
        }
        
        .stat-card.blue::before { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .stat-card.green::before { background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); }
        .stat-card.orange::before { background: linear-gradient(135deg, #fd7e14 0%, #ffc107 100%); }
        .stat-card.red::before { background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%); }
        
        .stat-icon {
            font-size: 40px;
            margin-bottom: 10px;
        }
        
        .stat-number {
            font-size: 36px;
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 13px;
            color: #666;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .section-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #667eea;
        }
        
        .quick-actions {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 15px;
        }
        
        .action-btn {
            padding: 20px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            text-decoration: none;
            color: #333;
            font-weight: 600;
            text-align: center;
            transition: all 0.3s;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }
        
        .action-btn:hover {
            border-color: #667eea;
            background: #f8f9ff;
            transform: translateY(-3px);
        }
        
        .action-btn .icon {
            font-size: 32px;
        }
        
        .action-btn span:last-child {
            font-size: 13px;
        }
        
        .action-btn.book:hover { border-color: #667eea; background: #f0f3ff; }
        .action-btn.reader:hover { border-color: #11998e; background: #e8fff9; }
        .action-btn.employee:hover { border-color: #fd7e14; background: #fff8f0; }
        .action-btn.role:hover { border-color: #dc3545; background: #fff0f0; }
        
        .welcome-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(102, 126, 234, 0.3);
        }
        
        .welcome-card h2 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .welcome-card p {
            font-size: 16px;
            opacity: 0.9;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Dashboard</h1>
        <div class="user-info">
            <strong>👤 ${currentEmployee.fullName}</strong>
            <small>${currentEmployee.roleName}</small>
            <br>
            <a href="${pageContext.request.contextPath}/mock-logout" class="btn-logout">🚪 Đăng xuất</a>
        </div>
    </div>
    
    <div class="container">
        
        <!-- Welcome Card -->
        <div class="welcome-card">
            <h2>Chào mừng, ${currentEmployee.fullName}!</h2>
            <p>Đây là tổng quan hệ thống quản lý thư viện</p>
        </div>
        
        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card blue">
                <div class="stat-icon">📚</div>
                <div class="stat-number">${totalBooks}</div>
                <div class="stat-label">Tổng số sách</div>
            </div>
            
            <div class="stat-card green">
                <div class="stat-icon">👥</div>
                <div class="stat-number">${totalReaders}</div>
                <div class="stat-label">Độc giả</div>
            </div>
            
            <div class="stat-card orange">
                <div class="stat-icon">👨‍💼</div>
                <div class="stat-number">${totalEmployees}</div>
                <div class="stat-label">Nhân viên</div>
            </div>
            
            <div class="stat-card red">
                <div class="stat-icon">🔑</div>
                <div class="stat-number">${totalRoles}</div>
                <div class="stat-label">Vai trò</div>
            </div>
        </div>
        
        <div class="quick-actions">
            <h2 class="section-title">INTER 1 - Quản lý Sách</h2>
            <div class="actions-grid">
                <a href="${pageContext.request.contextPath}/books-list" class="action-btn book">
                    <span class="icon">📚</span>
                    <span>Danh sách sách</span>
                </a>
                <a href="${pageContext.request.contextPath}/book-form" class="action-btn book">
                    <span class="icon">➕</span>
                    <span>Thêm sách mới</span>
                </a>
            </div>
        </div>
        
        <!-- INTER 2: Quản lý User -->
        <div class="quick-actions">
            <h2 class="section-title">👥 INTER 2 - Quản lý User</h2>
            <div class="actions-grid">
                <a href="${pageContext.request.contextPath}/admin/readers" class="action-btn reader">
                    <span class="icon">👥</span>
                    <span>Quản lý Độc giả</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/reader-form" class="action-btn reader">
                    <span class="icon">➕</span>
                    <span>Thêm Độc giả</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/employees" class="action-btn employee">
                    <span class="icon">👨‍💼</span>
                    <span>Quản lý Nhân viên</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/employee-form" class="action-btn employee">
                    <span class="icon">➕</span>
                    <span>Thêm Nhân viên</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/roles" class="action-btn role">
                    <span class="icon">🔑</span>
                    <span>Quản lý Vai trò</span>
                </a>
            </div>
        </div>
        
    </div>
</body>
</html>