<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quan ly Sach - Admin</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; }
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f4f5f7;
                min-height: 100vh;
            }

            /* ===== HEADER NAV ===== */
            .header {
                background: #1a1a2e;
                color: white;
                padding: 0 40px;
                height: 64px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 2px 12px rgba(0,0,0,0.3);
            }
            .header-left {
                display: flex;
                align-items: center;
                gap: 24px;
            }
            .header h1 { font-size: 18px; font-weight: 700; }
            .header h1 i { margin-right: 8px; }
            .header-nav { display: flex; gap: 4px; }
            .header-nav a {
                color: #ccc; text-decoration: none;
                padding: 8px 14px; border-radius: 6px;
                font-size: 13px; font-weight: 500; transition: all 0.2s;
            }
            .header-nav a:hover { color: #fff; background: rgba(255,255,255,0.1); }
            .header-nav a.active { color: #fff; background: rgba(255,255,255,0.12); }
            .header-right { display: flex; align-items: center; gap: 16px; }
            .user-badge { display: flex; align-items: center; gap: 8px; color: #ccc; font-size: 13px; }
            .user-badge strong { color: #fff; }
            .role-tag {
                background: #e74c3c; color: #fff; font-size: 10px; font-weight: 700;
                padding: 2px 8px; border-radius: 4px; text-transform: uppercase;
            }
            .btn-logout {
                padding: 7px 14px; border: 1px solid rgba(255,255,255,0.25);
                color: #fff; border-radius: 6px; text-decoration: none;
                font-size: 13px; transition: all 0.2s;
            }
            .btn-logout:hover { background: rgba(255,255,255,0.1); }

            /* ===== CONTAINER ===== */
            .container { max-width: 1300px; margin: 24px auto; padding: 0 20px; }

            /* ===== BREADCRUMB ===== */
            .breadcrumb {
                display: flex; align-items: center; gap: 8px;
                margin-bottom: 20px; font-size: 13px; color: #888;
            }
            .breadcrumb a { color: #1a1a2e; text-decoration: none; font-weight: 500; }
            .breadcrumb a:hover { text-decoration: underline; }
            .breadcrumb span { color: #bbb; }

            /* ===== STATS ===== */
            .stats-row {
                display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px;
                margin-bottom: 20px;
            }
            .stat-card {
                background: #fff; border-radius: 10px; padding: 20px;
                border: 1px solid #eee; box-shadow: 0 1px 6px rgba(0,0,0,0.04);
                display: flex; align-items: center; gap: 14px;
            }
            .stat-icon {
                width: 48px; height: 48px; border-radius: 10px;
                display: flex; align-items: center; justify-content: center;
                font-size: 20px;
            }
            .stat-icon.s1 { background: #eef2ff; color: #4f46e5; }
            .stat-icon.s2 { background: #dcfce7; color: #16a34a; }
            .stat-icon.s3 { background: #fef3c7; color: #d97706; }
            .stat-icon.s4 { background: #fce4ec; color: #e91e63; }
            .stat-info h3 { font-size: 24px; font-weight: 800; color: #1a1a2e; }
            .stat-info p { font-size: 12px; color: #888; font-weight: 500; }

            /* ===== TOOLBAR ===== */
            .toolbar {
                background: #fff; padding: 18px 22px; border-radius: 10px;
                border: 1px solid #eee; box-shadow: 0 1px 6px rgba(0,0,0,0.04);
                margin-bottom: 16px;
                display: flex; justify-content: space-between; align-items: center;
                flex-wrap: wrap; gap: 12px;
            }
            .toolbar-left { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
            .toolbar-right { display: flex; align-items: center; gap: 8px; }

            /* ===== FILTER BAR ===== */
            .filter-bar {
                background: #fff; padding: 14px 22px; border-radius: 10px;
                border: 1px solid #eee; box-shadow: 0 1px 6px rgba(0,0,0,0.04);
                margin-bottom: 16px;
                display: flex; align-items: center; gap: 14px; flex-wrap: wrap;
            }
            .filter-group {
                display: flex; align-items: center; gap: 6px;
            }
            .filter-group label {
                font-size: 12px; font-weight: 600; color: #888; text-transform: uppercase;
            }
            .filter-group select, .toolbar input[type="text"] {
                padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px;
                font-size: 13px; background: #fff; min-width: 140px;
            }
            .toolbar input[type="text"] { width: 220px; }
            .toolbar input[type="text"]:focus, .filter-group select:focus {
                outline: none; border-color: #1a1a2e;
                box-shadow: 0 0 0 3px rgba(26,26,46,0.06);
            }

            /* ===== BUTTONS ===== */
            .btn {
                padding: 8px 16px; border: none; border-radius: 6px;
                font-size: 13px; font-weight: 600; cursor: pointer;
                transition: all 0.2s; text-decoration: none; display: inline-flex;
                align-items: center; gap: 6px;
            }
            .btn:hover { transform: translateY(-1px); }
            .btn-dark { background: #1a1a2e; color: #fff; }
            .btn-dark:hover { background: #2d2d4e; }
            .btn-green { background: #16a34a; color: #fff; }
            .btn-green:hover { background: #15803d; }
            .btn-outline {
                background: #fff; color: #555; border: 1px solid #ddd;
            }
            .btn-outline:hover { background: #f8f8f8; border-color: #bbb; }
            .btn-red { background: #fff0f0; color: #e74c3c; border: 1px solid #fdd; }
            .btn-red:hover { background: #fde0e0; }
            .btn-blue { background: #eef2ff; color: #4f46e5; border: 1px solid #c7d2fe; }
            .btn-blue:hover { background: #e0e7ff; }
            .btn-amber { background: #fef3c7; color: #92400e; border: 1px solid #fde68a; }
            .btn-amber:hover { background: #fde68a; }
            .btn-sm { padding: 6px 12px; font-size: 12px; }

            .page-size-select {
                padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px;
                font-size: 13px; background: #fff; cursor: pointer;
            }

            /* ===== INFO LINE ===== */
            .info-line {
                font-size: 13px; color: #888; margin-bottom: 12px;
                display: flex; align-items: center; gap: 6px;
            }
            .info-line strong { color: #1a1a2e; }
            .info-line i { color: #bbb; }

            /* ===== TABLE ===== */
            .table-card {
                background: #fff; border-radius: 10px;
                border: 1px solid #eee; box-shadow: 0 1px 6px rgba(0,0,0,0.04);
                overflow: hidden;
            }
            table { width: 100%; border-collapse: collapse; }
            thead { background: #1a1a2e; color: #fff; }
            th {
                padding: 14px 16px; text-align: left; font-weight: 600;
                font-size: 12px; text-transform: uppercase; letter-spacing: 0.5px;
            }
            th a { color: #ccc; text-decoration: none; }
            th a:hover { color: #fff; }
            th a i { margin-left: 4px; font-size: 10px; }
            td {
                padding: 14px 16px; border-bottom: 1px solid #f0f0f0;
                vertical-align: middle; font-size: 14px;
            }
            tbody tr { transition: background 0.15s; }
            tbody tr:hover { background: #f8f9fb; }
            .book-title-cell {
                font-weight: 600; color: #1a1a2e;
                max-width: 220px; overflow: hidden;
                text-overflow: ellipsis; white-space: nowrap;
            }
            .book-title-cell a {
                color: #1a1a2e; text-decoration: none;
            }
            .book-title-cell a:hover { color: #4f46e5; }
            .book-summary {
                color: #999; display: block; margin-top: 3px;
                max-width: 220px; overflow: hidden;
                text-overflow: ellipsis; white-space: nowrap;
                font-size: 12px;
            }
            .book-cover {
                width: 48px; height: 64px; object-fit: cover;
                border-radius: 4px; box-shadow: 0 1px 4px rgba(0,0,0,0.1);
            }
            .book-cover-placeholder {
                width: 48px; height: 64px; background: #e9ecef;
                border-radius: 4px; display: flex; align-items: center;
                justify-content: center; color: #bbb; font-size: 20px;
            }
            .status-badge {
                padding: 4px 10px; border-radius: 4px;
                font-size: 11px; font-weight: 700; text-transform: uppercase;
            }
            .status-active { background: #dcfce7; color: #166534; }
            .status-inactive { background: #fef2f2; color: #991b1b; }
            .price { font-weight: 600; color: #16a34a; font-size: 13px; }
            .actions { display: flex; gap: 6px; }
            .date-cell { font-size: 12px; color: #888; white-space: nowrap; }

            /* ===== EMPTY ===== */
            .empty-state {
                text-align: center; padding: 60px 20px; color: #888;
            }
            .empty-state i { font-size: 48px; margin-bottom: 12px; display: block; color: #ccc; }
            .empty-state h3 { font-size: 18px; color: #555; margin-bottom: 8px; }

            /* ===== PAGINATION ===== */
            .pagination-bar {
                background: #fff; padding: 16px 22px; border-radius: 10px;
                border: 1px solid #eee; box-shadow: 0 1px 6px rgba(0,0,0,0.04);
                margin-top: 16px;
                display: flex; justify-content: space-between; align-items: center;
                flex-wrap: wrap; gap: 12px;
            }
            .pagination-info { color: #888; font-size: 13px; }
            .pagination-info strong { color: #1a1a2e; }
            .pagination { display: flex; gap: 4px; align-items: center; }
            .pagination a, .pagination span {
                padding: 8px 14px; border-radius: 6px; text-decoration: none;
                font-weight: 600; font-size: 13px; transition: all 0.2s;
            }
            .pagination a { background: #f0f0f0; color: #555; }
            .pagination a:hover { background: #1a1a2e; color: #fff; }
            .pagination .active { background: #1a1a2e; color: #fff; }
            .pagination .disabled { background: #f0f0f0; color: #ccc; cursor: not-allowed; }

            /* ===== RESPONSIVE ===== */
            @media (max-width: 992px) {
                .stats-row { grid-template-columns: 1fr 1fr; }
                .header-nav { display: none; }
            }
            @media (max-width: 768px) {
                .header { padding: 0 16px; }
                .toolbar { flex-direction: column; }
                .toolbar-right { width: 100%; }
                .toolbar input[type="text"] { width: 100%; }
                .filter-bar { flex-direction: column; align-items: flex-start; }
                .stats-row { grid-template-columns: 1fr; }
                table { font-size: 12px; }
                th, td { padding: 10px 8px; }
                .actions { flex-direction: column; gap: 4px; }
                .pagination-bar { flex-direction: column; text-align: center; }
            }
        </style>
    </head>
    <body>
        <%-- ===== HEADER ===== --%>
        <div class="header">
            <div class="header-left">
                <h1><i class="fas fa-book"></i> Quan ly Sach</h1>
                <nav class="header-nav">
                    <a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chu</a>
                    <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                    <a href="${pageContext.request.contextPath}/books-list" class="active"><i class="fas fa-book"></i> Sach</a>
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

            <%-- ===== BREADCRUMB ===== --%>
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chu</a>
                <span>/</span>
                <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                <span>/</span>
                <span style="color:#555; font-weight:600;">Quan ly Sach</span>
            </div>

            <%-- ===== STATS ===== --%>
            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-icon s1"><i class="fas fa-book"></i></div>
                    <div class="stat-info">
                        <h3>${totalBooks}</h3>
                        <p>Tong so sach</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon s2"><i class="fas fa-check-circle"></i></div>
                    <div class="stat-info">
                        <h3>${currentPage} / ${totalPages}</h3>
                        <p>Trang hien tai</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon s3"><i class="fas fa-layer-group"></i></div>
                    <div class="stat-info">
                        <h3>${pageSize}</h3>
                        <p>Sach moi trang</p>
                    </div>
                </div>
                <c:if test="${not empty keyword}">
                    <div class="stat-card">
                        <div class="stat-icon s4"><i class="fas fa-search"></i></div>
                        <div class="stat-info">
                            <h3>${totalBooks}</h3>
                            <p>Ket qua: "${keyword}"</p>
                        </div>
                    </div>
                </c:if>
                <c:if test="${empty keyword}">
                    <div class="stat-card">
                        <div class="stat-icon s4"><i class="fas fa-tags"></i></div>
                        <div class="stat-info">
                            <h3>${categories.size()}</h3>
                            <p>Danh muc</p>
                        </div>
                    </div>
                </c:if>
            </div>

            <%-- ===== TOOLBAR ===== --%>
            <div class="toolbar">
                <div class="toolbar-left">
                    <a href="${pageContext.request.contextPath}/books-list" class="btn btn-outline">
                        <i class="fas fa-sync-alt"></i> Lam moi
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/book-form" class="btn btn-green">
                        <i class="fas fa-plus"></i> Them sach moi
                    </a>

                    <span style="color:#888; font-size:13px; margin-left:6px;">Hien thi:</span>
                    <select id="pageSizeSelect" onchange="applyFilters()" class="page-size-select">
                        <option value="5" ${pageSize == '5' ? 'selected' : ''}>5</option>
                        <option value="10" ${pageSize == '10' ? 'selected' : ''}>10</option>
                        <option value="20" ${pageSize == '20' ? 'selected' : ''}>20</option>
                        <option value="all" ${pageSize == 'all' ? 'selected' : ''}>Tat ca</option>
                    </select>
                </div>

                <div class="toolbar-right">
                    <input type="text" id="searchKeyword" placeholder="Tim theo ten sach, tac gia..."
                           value="${keyword}">
                    <button onclick="applyFilters()" class="btn btn-dark">
                        <i class="fas fa-search"></i> Tim kiem
                    </button>
                </div>
            </div>

            <%-- ===== FILTERS ===== --%>
            <div class="filter-bar">
                <div class="filter-group">
                    <label>Danh muc:</label>
                    <select id="filterCategory">
                        <option value="">-- Tat ca --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryId}" ${filterCategoryId == cat.categoryId ? 'selected' : ''}>
                                ${cat.categoryName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="filter-group">
                    <label>Tac gia:</label>
                    <select id="filterAuthor">
                        <option value="">-- Tat ca --</option>
                        <c:forEach var="author" items="${authors}">
                            <option value="${author.authorId}" ${filterAuthorId == author.authorId ? 'selected' : ''}>
                                ${author.authorName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="filter-group">
                    <label>Trang thai:</label>
                    <select id="filterStatus">
                        <option value="">-- Tat ca --</option>
                        <option value="active" ${filterStatus == 'active' ? 'selected' : ''}>Active</option>
                        <option value="inactive" ${filterStatus == 'inactive' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>
                <button onclick="applyFilters()" class="btn btn-dark btn-sm">
                    <i class="fas fa-filter"></i> Loc
                </button>
                <button onclick="clearFilters()" class="btn btn-outline btn-sm">
                    <i class="fas fa-times"></i> Xoa loc
                </button>
            </div>

            <%-- ===== INFO LINE ===== --%>
            <div class="info-line">
                <i class="fas fa-info-circle"></i>
                <c:choose>
                    <c:when test="${showAll}">
                        Hien thi tat ca <strong>${totalBooks}</strong> sach
                    </c:when>
                    <c:otherwise>
                        Hien thi <strong>${bookList.size()}</strong> / <strong>${totalBooks}</strong> sach
                        | Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                    </c:otherwise>
                </c:choose>
                <c:if test="${not empty keyword}">
                    | Tu khoa: <strong>"${keyword}"</strong>
                </c:if>
                <c:if test="${filterCategoryId > 0}">
                    | Danh muc: <strong>
                        <c:forEach var="cat" items="${categories}">
                            <c:if test="${cat.categoryId == filterCategoryId}">${cat.categoryName}</c:if>
                        </c:forEach>
                    </strong>
                </c:if>
                <c:if test="${filterAuthorId > 0}">
                    | Tac gia: <strong>
                        <c:forEach var="author" items="${authors}">
                            <c:if test="${author.authorId == filterAuthorId}">${author.authorName}</c:if>
                        </c:forEach>
                    </strong>
                </c:if>
                <c:if test="${not empty filterStatus}">
                    | Trang thai: <strong>${filterStatus}</strong>
                </c:if>
            </div>

            <%-- ===== TABLE ===== --%>
            <div class="table-card">
                <c:choose>
                    <c:when test="${empty bookList}">
                        <div class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <h3>Khong co sach nao</h3>
                            <p>
                                <c:choose>
                                    <c:when test="${not empty keyword}">
                                        Khong tim thay sach voi tu khoa "<strong>${keyword}</strong>"
                                    </c:when>
                                    <c:otherwise>
                                        He thong chua co sach. Hay them sach moi!
                                    </c:otherwise>
                                </c:choose>
                            </p>
                            <a href="${pageContext.request.contextPath}/admin/book-form" class="btn btn-green">
                                <i class="fas fa-plus"></i> Them sach dau tien
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th style="width:50px;">ID</th>
                                    <th style="width:60px;">Bia</th>
                                    <th>Ten sach</th>
                                    <th>Tac gia</th>
                                    <th>Danh muc</th>
                                    <th>Gia</th>
                                    <th style="width:70px;">Trang</th>
                                    <th style="width:90px;">Ngay tao</th>
                                    <th style="width:80px;">Trang thai</th>
                                    <th style="width:170px;">Thao tac</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="book" items="${bookList}">
                                    <tr>
                                        <td><strong>#${book.bookId}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty book.coverUrl}">
                                                    <img src="${pageContext.request.contextPath}/${book.coverUrl}"
                                                         alt="${book.title}" class="book-cover"
                                                         onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                                                    <div class="book-cover-placeholder" style="display:none;">
                                                        <i class="fas fa-book"></i>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="book-cover-placeholder">
                                                        <i class="fas fa-book"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="book-title-cell" title="${book.title}">
                                                <a href="${pageContext.request.contextPath}/admin/book-detail?id=${book.bookId}">
                                                    ${book.title}
                                                </a>
                                            </div>
                                            <c:if test="${not empty book.summary}">
                                                <small class="book-summary">${book.summary}</small>
                                            </c:if>
                                        </td>
                                        <td>${not empty book.authorName ? book.authorName : '<span style="color:#ccc">—</span>'}</td>
                                        <td>${not empty book.categoryName ? book.categoryName : '<span style="color:#ccc">—</span>'}</td>
                                        <td class="price">
                                            <c:choose>
                                                <c:when test="${book.price != null && book.price > 0}">
                                                    <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true"/>
                                                    ${not empty book.currency ? book.currency : 'VND'}
                                                </c:when>
                                                <c:otherwise><span style="color:#ccc">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align:center;">${book.totalPages > 0 ? book.totalPages : '—'}</td>
                                        <td class="date-cell">
                                            <c:if test="${not empty book.createdAt}">
                                                <fmt:formatDate value="${book.createdAt}" pattern="dd/MM/yy"/>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${book.status == 'active'}">
                                                    <span class="status-badge status-active">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-inactive">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="actions">
                                                <a href="${pageContext.request.contextPath}/admin/book-detail?id=${book.bookId}"
                                                   class="btn btn-blue btn-sm" title="Xem chi tiet">
                                                    <i class="fas fa-eye"></i> Xem
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/book-form?id=${book.bookId}"
                                                   class="btn btn-amber btn-sm" title="Sua sach">
                                                    <i class="fas fa-pen"></i> Sua
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/book-delete?id=${book.bookId}"
                                                   class="btn btn-red btn-sm"
                                                   onclick="return confirm('Ban co chac chan muon xoa sach nay?\\n\\nTen sach: ${book.title}')"
                                                   title="Xoa sach">
                                                    <i class="fas fa-trash"></i> Xoa
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- ===== PAGINATION ===== --%>
            <c:if test="${totalPages > 1 && !showAll}">
                <div class="pagination-bar">
                    <div class="pagination-info">
                        Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                        | Tong: <strong>${totalBooks}</strong> sach
                    </div>
                    <div class="pagination">
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="javascript:goToPage(${currentPage - 1})"><i class="fas fa-chevron-left"></i> Truoc</a>
                            </c:when>
                            <c:otherwise>
                                <span class="disabled"><i class="fas fa-chevron-left"></i> Truoc</span>
                            </c:otherwise>
                        </c:choose>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="active">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="javascript:goToPage(${i})">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <a href="javascript:goToPage(${currentPage + 1})">Sau <i class="fas fa-chevron-right"></i></a>
                            </c:when>
                            <c:otherwise>
                                <span class="disabled">Sau <i class="fas fa-chevron-right"></i></span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
        </div>

        <script>
            function applyFilters() {
                var url = '${pageContext.request.contextPath}/books-list?';
                var params = [];

                var keyword = document.getElementById('searchKeyword').value.trim();
                if (keyword)
                    params.push('keyword=' + encodeURIComponent(keyword));

                var pageSize = document.getElementById('pageSizeSelect').value;
                if (pageSize)
                    params.push('pageSize=' + pageSize);

                var catId = document.getElementById('filterCategory').value;
                if (catId)
                    params.push('categoryId=' + catId);

                var authorId = document.getElementById('filterAuthor').value;
                if (authorId)
                    params.push('authorId=' + authorId);

                var status = document.getElementById('filterStatus').value;
                if (status)
                    params.push('status=' + status);

                window.location.href = url + params.join('&');
            }

            function clearFilters() {
                window.location.href = '${pageContext.request.contextPath}/books-list';
            }

            document.getElementById('searchKeyword').addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    applyFilters();
                }
            });

            function goToPage(page) {
                var url = '${pageContext.request.contextPath}/books-list?page=' + page;

                var keyword = document.getElementById('searchKeyword').value.trim();
                if (keyword) url += '&keyword=' + encodeURIComponent(keyword);

                var pageSize = document.getElementById('pageSizeSelect').value;
                if (pageSize) url += '&pageSize=' + pageSize;

                var catId = document.getElementById('filterCategory').value;
                if (catId) url += '&categoryId=' + catId;

                var authorId = document.getElementById('filterAuthor').value;
                if (authorId) url += '&authorId=' + authorId;

                var status = document.getElementById('filterStatus').value;
                if (status) url += '&status=' + status;

                window.location.href = url;
            }
        </script>
    </body>
</html>