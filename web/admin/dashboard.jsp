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
            background: #5a5a5a;
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
        
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
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
        
        .stat-card.blue::before {
            background: #888888;
        }
        
        .stat-card.green::before {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
        }
        
        .stat-card.orange::before {
            background: linear-gradient(135deg, #fd7e14 0%, #ffc107 100%);
        }
        
        .stat-card.red::before {
            background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%);
        }
        
        .stat-card.purple::before {
            background: linear-gradient(135deg, #6f42c1 0%, #e83e8c 100%);
        }
        
        .stat-icon {
            font-size: 48px;
            margin-bottom: 15px;
        }
        
        .stat-number {
            font-size: 42px;
            font-weight: 700;
            color: #333;
            margin-bottom: 8px;
        }
        
        .stat-label {
            font-size: 14px;
            color: #666;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .quick-actions {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .quick-actions h2 {
            font-size: 20px;
            color: #333;
            margin-bottom: 20px;
        }
        
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .action-btn {
            padding: 20px;
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
            border-color: #888888;
            background: #f5f5f5;
            transform: translateY(-3px);
        }
        
        .action-btn .icon {
            font-size: 36px;
        }
        
        .welcome-card {
            background: #888888;
            color: white;
            border-radius: 12px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 4px 20px rgba(136, 136, 136, 0.3);
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
        <h1>📊 Dashboard</h1>
        <div class="user-info">
            <strong>👤 ${currentEmployee.fullName}</strong>
            <small>${currentEmployee.roleName}</small>
        </div>
    </div>
    
    <div class="container">
        
        <!-- Welcome Card -->
        <div class="welcome-card">
            <h2>Chào mừng, ${currentEmployee.fullName}! 👋</h2>
            <p>Đây là tổng quan hệ thống thư viện số của bạn</p>
        </div>
        
        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card blue">
                <div class="stat-icon">📚</div>
                <div class="stat-number">${totalBooks}</div>
                <div class="stat-label">Tổng số sách</div>
            </div>
            
            <div class="stat-card green">
                <div class="stat-icon">✍️</div>
                <div class="stat-number">${totalAuthors}</div>
                <div class="stat-label">Tác giả</div>
            </div>
            
            <div class="stat-card orange">
                <div class="stat-icon">📂</div>
                <div class="stat-number">${totalCategories}</div>
                <div class="stat-label">Danh mục</div>
            </div>
            
            <div class="stat-card red">
                <div class="stat-icon">⏳</div>
                <div class="stat-number">${pendingBorrowRequests}</div>
                <div class="stat-label">Chờ duyệt</div>
            </div>
            
            <div class="stat-card purple">
                <div class="stat-icon">📖</div>
                <div class="stat-number">${activeBorrows}</div>
                <div class="stat-label">Đang mượn</div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="quick-actions">
            <h2>⚡ Thao tác nhanh</h2>
            <div class="actions-grid">
                <a href="${pageContext.request.contextPath}/books-list" class="action-btn">
                    <span class="icon">📚</span>
                    Quản lý sách
                </a>
                <a href="${pageContext.request.contextPath}/admin/book-add" class="action-btn">
                    <span class="icon">➕</span>
                    Thêm sách mới
                </a>
                <a href="${pageContext.request.contextPath}/admin/borrow-approve" class="action-btn">
                    <span class="icon">✅</span>
                    Duyệt mượn sách
                </a>
                <a href="${pageContext.request.contextPath}/mock-logout" class="action-btn">
                    <span class="icon">🚪</span>
                    Đăng xuất
                </a>
            </div>
        </div>
    </div>
</body>
</html>