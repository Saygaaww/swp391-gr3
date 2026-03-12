<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Duyet yeu cau Muon - Admin</title>
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
        .container { max-width: 1300px; margin: 24px auto; padding: 0 20px; }
        .breadcrumb { display: flex; align-items: center; gap: 8px; margin-bottom: 20px; font-size: 13px; color: #888; }
        .breadcrumb a { color: #1a1a2e; text-decoration: none; font-weight: 500; }
        .breadcrumb a:hover { text-decoration: underline; }
        .stats-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 20px; }
        .stat-card { background: #fff; border-radius: 10px; padding: 20px; border: 1px solid #eee; box-shadow: 0 1px 6px rgba(0,0,0,0.04); display: flex; align-items: center; gap: 14px; }
        .stat-icon { width: 48px; height: 48px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .s1 { background: #fef3c7; color: #d97706; } .s2 { background: #eef2ff; color: #4f46e5; } .s3 { background: #dcfce7; color: #16a34a; }
        .stat-info h3 { font-size: 24px; font-weight: 800; color: #1a1a2e; }
        .stat-info p { font-size: 12px; color: #888; font-weight: 500; }
        .toolbar { background: #fff; padding: 18px 22px; border-radius: 10px; border: 1px solid #eee; box-shadow: 0 1px 6px rgba(0,0,0,0.04); margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; }
        .toolbar-left { display: flex; align-items: center; gap: 10px; }
        .btn { padding: 8px 16px; border: none; border-radius: 6px; font-size: 13px; font-weight: 600; cursor: pointer; transition: all 0.2s; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; }
        .btn:hover { transform: translateY(-1px); }
        .btn-dark { background: #1a1a2e; color: #fff; } .btn-dark:hover { background: #2d2d4e; }
        .btn-green { background: #16a34a; color: #fff; } .btn-green:hover { background: #15803d; }
        .btn-outline { background: #fff; color: #555; border: 1px solid #ddd; } .btn-outline:hover { background: #f8f8f8; }
        .btn-amber { background: #fef3c7; color: #92400e; border: 1px solid #fde68a; } .btn-amber:hover { background: #fde68a; }
        .btn-red { background: #e74c3c; color: #fff; } .btn-red:hover { background: #c0392b; }
        .btn-blue { background: #eef2ff; color: #4f46e5; border: 1px solid #c7d2fe; } .btn-blue:hover { background: #e0e7ff; }
        .btn-sm { padding: 6px 12px; font-size: 12px; }
        .request-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(420px, 1fr)); gap: 20px; }
        .request-card { background: #fff; border-radius: 12px; border: 1px solid #eee; box-shadow: 0 2px 8px rgba(0,0,0,0.04); overflow: hidden; transition: box-shadow 0.2s; }
        .request-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
        .request-header { background: #1a1a2e; color: #fff; padding: 14px 20px; display: flex; justify-content: space-between; align-items: center; }
        .request-header .req-id { font-weight: 700; font-size: 15px; }
        .request-header .req-date { font-size: 12px; color: #ccc; }
        .request-body { padding: 20px; }
        .request-info { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 16px; }
        .info-item { }
        .info-label { font-size: 11px; font-weight: 600; color: #888; text-transform: uppercase; margin-bottom: 2px; }
        .info-value { font-size: 14px; color: #333; font-weight: 500; }
        .request-note { background: #f8f9fb; padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-size: 13px; color: #555; border-left: 3px solid #d97706; }
        .request-note .note-label { font-size: 11px; font-weight: 600; color: #888; text-transform: uppercase; margin-bottom: 4px; }
        .request-actions { display: flex; gap: 10px; padding-top: 16px; border-top: 1px solid #f0f0f0; }
        .request-actions form { flex: 1; }
        .request-actions .btn { width: 100%; justify-content: center; padding: 10px 16px; }
        .empty-state { text-align: center; padding: 80px 20px; color: #888; }
        .empty-state i { font-size: 56px; margin-bottom: 16px; display: block; color: #16a34a; }
        .empty-state h3 { font-size: 20px; color: #333; margin-bottom: 8px; }
        .empty-state p { font-size: 14px; color: #888; }
        @media (max-width: 992px) { .stats-row { grid-template-columns: 1fr 1fr; } .header-nav { display: none; } .request-grid { grid-template-columns: 1fr; } }
        @media (max-width: 768px) { .header { padding: 0 16px; } .toolbar { flex-direction: column; } .stats-row { grid-template-columns: 1fr; } .request-info { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-left">
            <h1><i class="fas fa-check-double"></i> Duyet yeu cau Muon</h1>
            <nav class="header-nav">
                <a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chu</a>
                <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="${pageContext.request.contextPath}/books-list"><i class="fas fa-book"></i> Sach</a>
                <a href="${pageContext.request.contextPath}/admin/readers"><i class="fas fa-users"></i> Doc gia</a>
                <a href="${pageContext.request.contextPath}/admin/employees"><i class="fas fa-user-tie"></i> Nhan vien</a>
                <a href="${pageContext.request.contextPath}/admin/borrow-list" class="active"><i class="fas fa-clipboard-list"></i> Muon tra</a>
                <a href="${pageContext.request.contextPath}/admin/roles"><i class="fas fa-key"></i> Vai tro</a>
            </nav>
        </div>
        <div class="header-right">
            <div class="user-badge"><i class="fas fa-user-circle" style="font-size:20px;"></i> <strong>${currentEmployee.fullName}</strong> <span class="role-tag">${currentEmployee.roleName}</span></div>
            <a href="${pageContext.request.contextPath}/auth/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Dang xuat</a>
        </div>
    </div>
    <div class="container">
        <div class="breadcrumb"><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chu</a><span>/</span><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a><span>/</span><a href="${pageContext.request.contextPath}/admin/borrow-list">Muon tra</a><span>/</span><span style="color:#555;font-weight:600;">Duyet yeu cau</span></div>
        <div class="stats-row">
            <div class="stat-card"><div class="stat-icon s1"><i class="fas fa-clock"></i></div><div class="stat-info"><h3>${pendingRequests.size()}</h3><p>Yeu cau cho duyet</p></div></div>
            <div class="stat-card"><div class="stat-icon s2"><i class="fas fa-clipboard-list"></i></div><div class="stat-info"><h3>-</h3><p>Trang duyet yeu cau</p></div></div>
            <div class="stat-card"><div class="stat-icon s3"><i class="fas fa-check-circle"></i></div><div class="stat-info"><h3><i class="fas fa-arrow-right" style="font-size:14px;"></i></h3><p><a href="${pageContext.request.contextPath}/admin/borrow-list" style="color:#16a34a;text-decoration:none;font-weight:600;">Xem lich su</a></p></div></div>
        </div>
        <div class="toolbar">
            <div class="toolbar-left">
                <a href="${pageContext.request.contextPath}/admin/borrow-approve" class="btn btn-outline"><i class="fas fa-sync-alt"></i> Lam moi</a>
                <a href="${pageContext.request.contextPath}/admin/borrow-list" class="btn btn-blue"><i class="fas fa-history"></i> Lich su muon tra</a>
            </div>
        </div>
        <c:choose>
            <c:when test="${empty pendingRequests}">
                <div class="empty-state"><i class="fas fa-check-circle"></i><h3>Khong co yeu cau nao can duyet</h3><p>Tat ca yeu cau muon tra da duoc xu ly.</p><a href="${pageContext.request.contextPath}/admin/borrow-list" class="btn btn-dark" style="margin-top:16px;"><i class="fas fa-history"></i> Xem lich su</a></div>
            </c:when>
            <c:otherwise>
                <div class="request-grid">
                    <c:forEach var="b" items="${pendingRequests}">
                        <div class="request-card">
                            <div class="request-header"><span class="req-id"><i class="fas fa-file-alt"></i> Yeu cau #${b.requestId}</span><span class="req-date"><i class="fas fa-calendar-alt"></i> <fmt:formatDate value="${b.requestedAt}" pattern="dd/MM/yyyy HH:mm"/></span></div>
                            <div class="request-body">
                                <div class="request-info">
                                    <div class="info-item"><div class="info-label">Doc gia</div><div class="info-value"><i class="fas fa-user" style="color:#4f46e5;margin-right:4px;"></i> ${b.readerName}</div></div>
                                    <div class="info-item"><div class="info-label">Email</div><div class="info-value"><i class="fas fa-envelope" style="color:#d97706;margin-right:4px;"></i> ${b.readerEmail}</div></div>
                                </div>
                                <c:if test="${not empty b.note}"><div class="request-note"><div class="note-label"><i class="fas fa-sticky-note"></i> Ghi chu</div>${b.note}</div></c:if>
                                <div class="request-actions">
                                    <form action="${pageContext.request.contextPath}/admin/borrow-approve" method="post"><input type="hidden" name="requestId" value="${b.requestId}"><input type="hidden" name="action" value="approve"><button type="submit" class="btn btn-green" onclick="return confirm('Duyet yeu cau nay?')"><i class="fas fa-check"></i> Duyet</button></form>
                                    <form action="${pageContext.request.contextPath}/admin/borrow-approve" method="post"><input type="hidden" name="requestId" value="${b.requestId}"><input type="hidden" name="action" value="reject"><button type="submit" class="btn btn-red" onclick="return confirm('Tu choi yeu cau nay?')"><i class="fas fa-times"></i> Tu choi</button></form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>