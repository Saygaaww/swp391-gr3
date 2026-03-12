<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lich su Muon tra - Admin</title>
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
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 20px; }
        .stat-card { background: #fff; border-radius: 10px; padding: 20px; border: 1px solid #eee; box-shadow: 0 1px 6px rgba(0,0,0,0.04); display: flex; align-items: center; gap: 14px; }
        .stat-icon { width: 48px; height: 48px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .s1 { background: #eef2ff; color: #4f46e5; } .s2 { background: #fef3c7; color: #d97706; } .s3 { background: #dcfce7; color: #16a34a; } .s4 { background: #fce4ec; color: #e91e63; }
        .stat-info h3 { font-size: 24px; font-weight: 800; color: #1a1a2e; }
        .stat-info p { font-size: 12px; color: #888; font-weight: 500; }
        .toolbar { background: #fff; padding: 18px 22px; border-radius: 10px; border: 1px solid #eee; box-shadow: 0 1px 6px rgba(0,0,0,0.04); margin-bottom: 16px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; }
        .toolbar-left { display: flex; align-items: center; gap: 10px; }
        .toolbar-right { display: flex; align-items: center; gap: 8px; }
        .toolbar input[type="text"] { padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 13px; width: 220px; }
        .toolbar input[type="text"]:focus { outline: none; border-color: #1a1a2e; box-shadow: 0 0 0 3px rgba(26,26,46,0.06); }
        .filter-bar { background: #fff; padding: 14px 22px; border-radius: 10px; border: 1px solid #eee; box-shadow: 0 1px 6px rgba(0,0,0,0.04); margin-bottom: 16px; display: flex; align-items: center; gap: 14px; flex-wrap: wrap; }
        .filter-group { display: flex; align-items: center; gap: 6px; }
        .filter-group label { font-size: 12px; font-weight: 600; color: #888; text-transform: uppercase; }
        .filter-group select { padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 13px; background: #fff; min-width: 140px; }
        .btn { padding: 8px 16px; border: none; border-radius: 6px; font-size: 13px; font-weight: 600; cursor: pointer; transition: all 0.2s; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; }
        .btn:hover { transform: translateY(-1px); }
        .btn-dark { background: #1a1a2e; color: #fff; } .btn-dark:hover { background: #2d2d4e; }
        .btn-green { background: #16a34a; color: #fff; } .btn-green:hover { background: #15803d; }
        .btn-outline { background: #fff; color: #555; border: 1px solid #ddd; } .btn-outline:hover { background: #f8f8f8; }
        .btn-amber { background: #fef3c7; color: #92400e; border: 1px solid #fde68a; } .btn-amber:hover { background: #fde68a; }
        .btn-blue { background: #eef2ff; color: #4f46e5; border: 1px solid #c7d2fe; } .btn-blue:hover { background: #e0e7ff; }
        .btn-sm { padding: 6px 12px; font-size: 12px; }
        .table-card { background: #fff; border-radius: 10px; border: 1px solid #eee; box-shadow: 0 1px 6px rgba(0,0,0,0.04); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        thead { background: #1a1a2e; color: #fff; }
        th { padding: 14px 16px; text-align: left; font-weight: 600; font-size: 12px; text-transform: uppercase; letter-spacing: 0.5px; }
        td { padding: 14px 16px; border-bottom: 1px solid #f0f0f0; vertical-align: middle; font-size: 14px; }
        tbody tr { transition: background 0.15s; } tbody tr:hover { background: #f8f9fb; }
        .status-badge { padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
        .status-pending { background: #fef3c7; color: #92400e; }
        .status-approved { background: #dcfce7; color: #166534; }
        .status-rejected { background: #fef2f2; color: #991b1b; }
        .status-returned { background: #e0f2fe; color: #0369a1; }
        .empty-state { text-align: center; padding: 60px 20px; color: #888; }
        .empty-state i { font-size: 48px; margin-bottom: 12px; display: block; color: #ccc; }
        .empty-state h3 { font-size: 18px; color: #555; margin-bottom: 8px; }
        .pagination-bar { background: #fff; padding: 16px 22px; border-radius: 10px; border: 1px solid #eee; box-shadow: 0 1px 6px rgba(0,0,0,0.04); margin-top: 16px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; }
        .pagination-info { color: #888; font-size: 13px; } .pagination-info strong { color: #1a1a2e; }
        .pagination { display: flex; gap: 4px; align-items: center; }
        .pagination a, .pagination span { padding: 8px 14px; border-radius: 6px; text-decoration: none; font-weight: 600; font-size: 13px; transition: all 0.2s; }
        .pagination a { background: #f0f0f0; color: #555; } .pagination a:hover { background: #1a1a2e; color: #fff; }
        .pagination .active { background: #1a1a2e; color: #fff; }
        .pagination .disabled { background: #f0f0f0; color: #ccc; cursor: not-allowed; }
        @media (max-width: 992px) { .stats-row { grid-template-columns: 1fr 1fr; } .header-nav { display: none; } }
        @media (max-width: 768px) { .header { padding: 0 16px; } .toolbar { flex-direction: column; } .stats-row { grid-template-columns: 1fr; } .filter-bar { flex-direction: column; align-items: flex-start; } .pagination-bar { flex-direction: column; text-align: center; } }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-left">
            <h1><i class="fas fa-clipboard-list"></i> Lich su Muon tra</h1>
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
        <div class="breadcrumb"><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chu</a><span>/</span><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a><span>/</span><span style="color:#555;font-weight:600;">Lich su Muon tra</span></div>
        <div class="stats-row">
            <div class="stat-card"><div class="stat-icon s1"><i class="fas fa-clipboard-list"></i></div><div class="stat-info"><h3>${totalRequests}</h3><p>Tong yeu cau</p></div></div>
            <div class="stat-card"><div class="stat-icon s2"><i class="fas fa-clock"></i></div><div class="stat-info"><h3>${countPending}</h3><p>Dang cho duyet</p></div></div>
            <div class="stat-card"><div class="stat-icon s3"><i class="fas fa-check-circle"></i></div><div class="stat-info"><h3>${countApproved}</h3><p>Da duyet</p></div></div>
            <div class="stat-card"><div class="stat-icon s4"><i class="fas fa-times-circle"></i></div><div class="stat-info"><h3>${countRejected}</h3><p>Tu choi</p></div></div>
        </div>
        <div class="toolbar">
            <div class="toolbar-left">
                <a href="${pageContext.request.contextPath}/admin/borrow-list" class="btn btn-outline"><i class="fas fa-sync-alt"></i> Lam moi</a>
                <a href="${pageContext.request.contextPath}/admin/borrow-approve" class="btn btn-amber"><i class="fas fa-check-double"></i> Duyet yeu cau</a>
            </div>
            <div class="toolbar-right">
                <input type="text" id="searchKeyword" placeholder="Tim theo ten hoac email..." value="${keyword}">
                <button onclick="applyFilters()" class="btn btn-dark"><i class="fas fa-search"></i> Tim kiem</button>
            </div>
        </div>
        <div class="filter-bar">
            <div class="filter-group"><label>Hien thi:</label><select id="filterPageSize"><option value="5" ${pageSize == '5' ? 'selected' : ''}>5</option><option value="10" ${pageSize == '10' ? 'selected' : ''}>10</option><option value="20" ${pageSize == '20' ? 'selected' : ''}>20</option><option value="all" ${pageSize == 'all' ? 'selected' : ''}>Tat ca</option></select></div>
            <div class="filter-group"><label>Trang thai:</label><select id="filterStatus"><option value="">-- Tat ca --</option><option value="pending" ${filterStatus == 'pending' ? 'selected' : ''}>Pending</option><option value="approved" ${filterStatus == 'approved' ? 'selected' : ''}>Approved</option><option value="rejected" ${filterStatus == 'rejected' ? 'selected' : ''}>Rejected</option><option value="returned" ${filterStatus == 'returned' ? 'selected' : ''}>Returned</option></select></div>
            <button onclick="applyFilters()" class="btn btn-dark btn-sm"><i class="fas fa-filter"></i> Loc</button>
            <button onclick="clearFilters()" class="btn btn-outline btn-sm"><i class="fas fa-times"></i> Xoa loc</button>
        </div>
        <div class="table-card">
            <c:choose>
                <c:when test="${empty requestList}"><div class="empty-state"><i class="fas fa-inbox"></i><h3>Khong co yeu cau nao</h3><p><c:choose><c:when test="${not empty keyword}">Khong tim thay voi tu khoa "${keyword}"</c:when><c:otherwise>He thong chua co yeu cau muon tra.</c:otherwise></c:choose></p></div></c:when>
                <c:otherwise>
                    <table><thead><tr><th>ID</th><th>Doc gia</th><th>Email</th><th>Ngay muon</th><th>Trang thai</th><th>Nguoi duyet</th><th>Ngay xu ly</th><th>Ghi chu</th><th>Thao tac</th></tr></thead>
                    <tbody>
                        <c:forEach var="b" items="${requestList}">
                            <tr>
                                <td><strong>#${b.requestId}</strong></td>
                                <td>${b.readerName}</td>
                                <td style="font-size:13px;">${b.readerEmail}</td>
                                <td style="font-size:12px;color:#888;"><fmt:formatDate value="${b.requestedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><c:choose><c:when test="${b.status == 'pending'}"><span class="status-badge status-pending">Pending</span></c:when><c:when test="${b.status == 'approved'}"><span class="status-badge status-approved">Approved</span></c:when><c:when test="${b.status == 'rejected'}"><span class="status-badge status-rejected">Rejected</span></c:when><c:when test="${b.status == 'returned'}"><span class="status-badge status-returned">Returned</span></c:when><c:otherwise><span class="status-badge" style="background:#f0f0f0;color:#555;">${b.status}</span></c:otherwise></c:choose></td>
                                <td>${b.employeeName}</td>
                                <td style="font-size:12px;color:#888;"><c:if test="${b.processedAt != null}"><fmt:formatDate value="${b.processedAt}" pattern="dd/MM/yyyy HH:mm"/></c:if></td>
                                <td style="font-size:13px;max-width:150px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;" title="${b.note}">${b.note}</td>
                                <td><a href="${pageContext.request.contextPath}/admin/borrow-detail?id=${b.requestId}" class="btn btn-blue btn-sm"><i class="fas fa-eye"></i> Chi tiet</a></td>
                            </tr>
                        </c:forEach>
                    </tbody></table>
                </c:otherwise>
            </c:choose>
        </div>
        <c:if test="${totalPages > 1}">
            <div class="pagination-bar">
                <div class="pagination-info">Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong> | Tong: <strong>${totalRequests}</strong> yeu cau</div>
                <div class="pagination">
                    <c:choose><c:when test="${currentPage > 1}"><a href="javascript:goToPage(${currentPage - 1})"><i class="fas fa-chevron-left"></i> Truoc</a></c:when><c:otherwise><span class="disabled"><i class="fas fa-chevron-left"></i> Truoc</span></c:otherwise></c:choose>
                    <c:forEach begin="1" end="${totalPages}" var="i"><c:choose><c:when test="${i == currentPage}"><span class="active">${i}</span></c:when><c:otherwise><a href="javascript:goToPage(${i})">${i}</a></c:otherwise></c:choose></c:forEach>
                    <c:choose><c:when test="${currentPage < totalPages}"><a href="javascript:goToPage(${currentPage + 1})">Sau <i class="fas fa-chevron-right"></i></a></c:when><c:otherwise><span class="disabled">Sau <i class="fas fa-chevron-right"></i></span></c:otherwise></c:choose>
                </div>
            </div>
        </c:if>
    </div>
    <script>
        function applyFilters(){var k=document.getElementById('searchKeyword').value.trim();var s=document.getElementById('filterStatus').value;var p=document.getElementById('filterPageSize').value;var u='${pageContext.request.contextPath}/admin/borrow-list?page=1';if(k)u+='&keyword='+encodeURIComponent(k);if(s)u+='&status='+s;if(p)u+='&pageSize='+p;window.location.href=u;}
        function clearFilters(){window.location.href='${pageContext.request.contextPath}/admin/borrow-list';}
        function goToPage(pg){var k=document.getElementById('searchKeyword').value.trim();var s=document.getElementById('filterStatus').value;var p=document.getElementById('filterPageSize').value;var u='${pageContext.request.contextPath}/admin/borrow-list?page='+pg;if(k)u+='&keyword='+encodeURIComponent(k);if(s)u+='&status='+s;if(p)u+='&pageSize='+p;window.location.href=u;}
        document.getElementById('searchKeyword').addEventListener('keypress',function(e){if(e.key==='Enter'){e.preventDefault();applyFilters();}});
    </script>
</body>
</html>