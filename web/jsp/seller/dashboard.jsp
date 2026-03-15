<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Dashboard Quản lý - Thư viện Số FPT</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
                        min-height: 100vh;
                        color: #111827;
                    }

                    /* ── TOP NAV ── */
                    .topbar {
                        background: #ffffff;
                        border-bottom: 1px solid #e5e7eb;
                        box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
                        padding: 0 2rem;
                        height: 64px;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                        position: sticky;
                        top: 0;
                        z-index: 100;
                    }

                    .brand {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        font-size: 1.15rem;
                        font-weight: 700;
                        color: #111827;
                        text-decoration: none;
                    }

                    .brand i {
                        color: #7c3aed;
                    }

                    .topbar-right {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                    }

                    .role-badge {
                        background: linear-gradient(135deg, #6366f1, #8b5cf6);
                        color: #fff;
                        padding: 4px 12px;
                        border-radius: 99px;
                        font-size: 0.78rem;
                        font-weight: 600;
                    }

                    .topbar-link {
                        color: #4b5563;
                        text-decoration: none;
                        font-size: 0.875rem;
                        font-weight: 500;
                        padding: 6px 12px;
                        border-radius: 8px;
                        transition: all 0.2s;
                        display: flex;
                        align-items: center;
                        gap: 6px;
                    }

                    .topbar-link:hover {
                        background: #f3f4f6;
                        color: #7c3aed;
                    }

                    .topbar-link.danger {
                        color: #dc2626;
                    }

                    .topbar-link.danger:hover {
                        background: #fef2f2;
                    }

                    /* ── LAYOUT ── */
                    .layout {
                        display: flex;
                    }

                    .sidebar {
                        width: 240px;
                        background: #ffffff;
                        border-right: 1px solid #e5e7eb;
                        min-height: calc(100vh - 64px);
                        padding: 1.5rem 1rem;
                        position: sticky;
                        top: 64px;
                        flex-shrink: 0;
                    }

                    .sidebar-section {
                        font-size: 0.7rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.08em;
                        color: #9ca3af;
                        padding: 0 0.75rem;
                        margin-bottom: 6px;
                        margin-top: 16px;
                    }

                    .sidebar-section:first-child {
                        margin-top: 0;
                    }

                    .sidebar-link {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                        padding: 8px 12px;
                        border-radius: 8px;
                        color: #4b5563;
                        text-decoration: none;
                        font-size: 0.875rem;
                        font-weight: 500;
                        transition: all 0.15s;
                        margin-bottom: 2px;
                    }

                    .sidebar-link:hover {
                        background: #f3f4f6;
                        color: #7c3aed;
                    }

                    .sidebar-link.active {
                        background: #ede9fe;
                        color: #7c3aed;
                        font-weight: 600;
                    }

                    .sidebar-link i {
                        width: 18px;
                        text-align: center;
                    }

                    /* ── MAIN ── */
                    .main {
                        flex: 1;
                        padding: 2rem;
                        overflow-y: auto;
                    }

                    .page-title {
                        font-size: 1.6rem;
                        font-weight: 700;
                        color: #111827;
                        margin-bottom: 0.25rem;
                    }

                    .page-subtitle {
                        color: #6b7280;
                        font-size: 0.9rem;
                        margin-bottom: 2rem;
                    }

                    /* ── STATS CARDS ── */
                    .stats-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                        gap: 1.25rem;
                        margin-bottom: 2rem;
                    }

                    .stat-card {
                        background: #ffffff;
                        border: 1px solid #e5e7eb;
                        border-radius: 16px;
                        padding: 1.5rem;
                        display: flex;
                        align-items: center;
                        gap: 1rem;
                        box-shadow: 0 1px 6px rgba(0, 0, 0, 0.05);
                        transition: transform 0.2s, box-shadow 0.2s;
                    }

                    .stat-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
                    }

                    .stat-icon {
                        width: 52px;
                        height: 52px;
                        border-radius: 12px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 1.3rem;
                        flex-shrink: 0;
                    }

                    .stat-icon.purple {
                        background: #ede9fe;
                        color: #7c3aed;
                    }

                    .stat-icon.blue {
                        background: #dbeafe;
                        color: #2563eb;
                    }

                    .stat-icon.green {
                        background: #dcfce7;
                        color: #16a34a;
                    }

                    .stat-icon.orange {
                        background: #ffedd5;
                        color: #ea580c;
                    }

                    .stat-number {
                        font-size: 1.8rem;
                        font-weight: 700;
                        color: #111827;
                        line-height: 1;
                    }

                    .stat-label {
                        font-size: 0.82rem;
                        color: #6b7280;
                        margin-top: 4px;
                        font-weight: 500;
                    }

                    /* ── QUICK ACTIONS ── */
                    .section-title {
                        font-size: 1rem;
                        font-weight: 600;
                        color: #111827;
                        margin-bottom: 1rem;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .quick-actions {
                        display: flex;
                        gap: 12px;
                        flex-wrap: wrap;
                        margin-bottom: 2rem;
                    }

                    .action-btn {
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        padding: 10px 20px;
                        border-radius: 10px;
                        font-size: 0.875rem;
                        font-weight: 600;
                        text-decoration: none;
                        transition: all 0.2s;
                        border: none;
                        cursor: pointer;
                    }

                    .action-btn.primary {
                        background: linear-gradient(135deg, #6366f1, #8b5cf6);
                        color: #fff;
                        box-shadow: 0 3px 10px rgba(99, 102, 241, 0.3);
                    }

                    .action-btn.primary:hover {
                        transform: translateY(-1px);
                        box-shadow: 0 6px 18px rgba(99, 102, 241, 0.35);
                        color: #fff;
                    }

                    .action-btn.outline {
                        background: #ffffff;
                        color: #374151;
                        border: 1px solid #d1d5db;
                    }

                    .action-btn.outline:hover {
                        border-color: #7c3aed;
                        color: #7c3aed;
                        background: #faf5ff;
                    }

                    /* ── RECENT BOOKS TABLE ── */
                    .card {
                        background: #ffffff;
                        border: 1px solid #e5e7eb;
                        border-radius: 16px;
                        overflow: hidden;
                        box-shadow: 0 1px 6px rgba(0, 0, 0, 0.05);
                    }

                    .card-header {
                        padding: 1.25rem 1.5rem;
                        border-bottom: 1px solid #f3f4f6;
                        display: flex;
                        align-items: center;
                        justify-content: space-between;
                    }

                    .card-header-title {
                        font-size: 0.95rem;
                        font-weight: 600;
                        color: #111827;
                    }

                    .view-all {
                        font-size: 0.8rem;
                        color: #7c3aed;
                        text-decoration: none;
                        font-weight: 500;
                    }

                    .view-all:hover {
                        text-decoration: underline;
                    }

                    table {
                        width: 100%;
                        border-collapse: collapse;
                    }

                    thead th {
                        background: #f9fafb;
                        padding: 10px 16px;
                        font-size: 0.78rem;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 0.04em;
                        color: #6b7280;
                        text-align: left;
                        border-bottom: 1px solid #e5e7eb;
                    }

                    tbody tr {
                        transition: background 0.15s;
                    }

                    tbody tr:hover {
                        background: #fafafa;
                    }

                    tbody td {
                        padding: 12px 16px;
                        font-size: 0.875rem;
                        color: #374151;
                        border-bottom: 1px solid #f3f4f6;
                    }

                    tbody tr:last-child td {
                        border-bottom: none;
                    }

                    .book-title-cell {
                        font-weight: 500;
                        color: #111827;
                        max-width: 260px;
                    }

                    .book-title-cell a {
                        color: inherit;
                        text-decoration: none;
                    }

                    .book-title-cell a:hover {
                        color: #7c3aed;
                    }

                    .badge {
                        display: inline-flex;
                        align-items: center;
                        padding: 2px 8px;
                        border-radius: 99px;
                        font-size: 0.72rem;
                        font-weight: 600;
                    }

                    .badge-active {
                        background: #dcfce7;
                        color: #16a34a;
                    }

                    .badge-free {
                        background: #dbeafe;
                        color: #2563eb;
                    }

                    .badge-price {
                        background: #ede9fe;
                        color: #7c3aed;
                    }

                    .action-icons {
                        display: flex;
                        gap: 8px;
                    }

                    .icon-btn {
                        width: 30px;
                        height: 30px;
                        border-radius: 7px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 0.8rem;
                        text-decoration: none;
                        transition: all 0.15s;
                        border: 1px solid transparent;
                    }

                    .icon-btn.edit {
                        color: #2563eb;
                        background: #eff6ff;
                    }

                    .icon-btn.edit:hover {
                        background: #dbeafe;
                    }

                    .icon-btn.upload {
                        color: #7c3aed;
                        background: #f5f3ff;
                    }

                    .icon-btn.upload:hover {
                        background: #ede9fe;
                    }

                    .icon-btn.detail {
                        color: #374151;
                        background: #f9fafb;
                        border-color: #e5e7eb;
                    }

                    .icon-btn.detail:hover {
                        background: #f3f4f6;
                    }

                    @media (max-width: 768px) {
                        .sidebar {
                            display: none;
                        }

                        .main {
                            padding: 1rem;
                        }

                        .stats-grid {
                            grid-template-columns: 1fr 1fr;
                        }
                    }
                </style>
            </head>

            <body>

                <!-- TOP BAR -->
                <header class="topbar">
                    <a href="${pageContext.request.contextPath}/books/dashboard" class="brand">
                        <i class="fas fa-book-open"></i> Thư viện Số FPT
                    </a>
                    <div class="topbar-right">
                        <span class="role-badge">
                            <i class="fas fa-user-tie" style="margin-right:4px;"></i>
                            ${sessionScope.userRole}
                        </span>
                        <a href="${pageContext.request.contextPath}/books/list" class="topbar-link">
                            <i class="fas fa-eye"></i> Xem trang người dùng
                        </a>
                        <a href="${pageContext.request.contextPath}/auth/logout" class="topbar-link danger">
                            <i class="fas fa-sign-out-alt"></i> Đăng xuất
                        </a>
                    </div>
                </header>

                <div class="layout">
                    <!-- SIDEBAR -->
                    <aside class="sidebar">
                        <div class="sidebar-section">Tổng quan</div>
                        <a href="${pageContext.request.contextPath}/books/dashboard" class="sidebar-link active">
                            <i class="fas fa-chart-bar"></i> Dashboard
                        </a>

                        <div class="sidebar-section">Quản lý danh mục</div>
                        <a href="${pageContext.request.contextPath}/books/create" class="sidebar-link">
                            <i class="fas fa-plus-circle"></i> Thêm sách mới
                        </a>
                        <a href="${pageContext.request.contextPath}/books/list" class="sidebar-link">
                            <i class="fas fa-book"></i> Danh sách sách
                        </a>
                        <a href="${pageContext.request.contextPath}/authors" class="sidebar-link">
                            <i class="fas fa-user-edit"></i> Tác giả
                        </a>
                        <a href="${pageContext.request.contextPath}/categories" class="sidebar-link">
                            <i class="fas fa-tags"></i> Thể loại
                        </a>

                        <div class="sidebar-section">Tài khoản</div>
                        <a href="${pageContext.request.contextPath}/notifications" class="sidebar-link">
                            <i class="fas fa-bell"></i> Thông báo
                        </a>
                    </aside>

                    <!-- MAIN CONTENT -->
                    <main class="main">
                        <div class="page-title">Xin chào, ${sessionScope.user.fullName} 👋</div>
                        <div class="page-subtitle">Dashboard quản lý thư viện — ${sessionScope.userRole}</div>

                        <!-- STATS -->
                        <div class="stats-grid">
                            <div class="stat-card">
                                <div class="stat-icon purple"><i class="fas fa-book"></i></div>
                                <div>
                                    <div class="stat-number">${totalBooks}</div>
                                    <div class="stat-label">Tổng số sách</div>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon blue"><i class="fas fa-user-edit"></i></div>
                                <div>
                                    <div class="stat-number">${totalAuthors}</div>
                                    <div class="stat-label">Tác giả</div>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon green"><i class="fas fa-tags"></i></div>
                                <div>
                                    <div class="stat-number">${totalCategories}</div>
                                    <div class="stat-label">Thể loại</div>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon orange"><i class="fas fa-gift"></i></div>
                                <div>
                                    <div class="stat-number">—</div>
                                    <div class="stat-label">Sách miễn phí</div>
                                </div>
                            </div>
                        </div>

                        <!-- QUICK ACTIONS -->
                        <div class="section-title"><i class="fas fa-bolt"></i> Thao tác nhanh</div>
                        <div class="quick-actions">
                            <a href="${pageContext.request.contextPath}/books/create" class="action-btn primary">
                                <i class="fas fa-plus"></i> Thêm sách mới
                            </a>
                            <a href="${pageContext.request.contextPath}/authors/create" class="action-btn outline">
                                <i class="fas fa-user-plus"></i> Thêm tác giả
                            </a>
                            <a href="${pageContext.request.contextPath}/categories/create" class="action-btn outline">
                                <i class="fas fa-folder-plus"></i> Thêm thể loại
                            </a>
                            <a href="${pageContext.request.contextPath}/books/list" class="action-btn outline">
                                <i class="fas fa-list"></i> Xem toàn bộ sách
                            </a>
                        </div>

                        <!-- RECENT BOOKS TABLE -->
                        <div class="section-title"><i class="fas fa-clock"></i> Sách mới nhất</div>
                        <div class="card">
                            <div class="card-header">
                                <span class="card-header-title">8 sách được thêm gần đây</span>
                                <a href="${pageContext.request.contextPath}/books/list" class="view-all">Xem tất cả
                                    →</a>
                            </div>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Tên sách</th>
                                        <th>Tác giả</th>
                                        <th>Thể loại</th>
                                        <th>Giá</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty recentBooks}">
                                            <c:forEach var="book" items="${recentBooks}">
                                                <tr>
                                                    <td class="book-title-cell">
                                                        <a
                                                            href="${pageContext.request.contextPath}/books/detail/${book.bookId}">
                                                            ${book.title}
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty book.author}">
                                                                ${book.author.authorName}</c:when>
                                                            <c:otherwise><span style="color:#9ca3af;">—</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty book.category}">
                                                                ${book.category.categoryName}</c:when>
                                                            <c:otherwise><span style="color:#9ca3af;">—</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty book.price and book.price > 0}">
                                                                <span class="badge badge-price">
                                                                    <fmt:formatNumber value="${book.price}"
                                                                        type="number" maxFractionDigits="0" /> VNĐ
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge badge-free">Miễn phí</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <div class="action-icons">
                                                            <a href="${pageContext.request.contextPath}/books/detail/${book.bookId}"
                                                                class="icon-btn detail" title="Chi tiết">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/books/edit/${book.bookId}"
                                                                class="icon-btn edit" title="Chỉnh sửa">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/books/upload/${book.bookId}"
                                                                class="icon-btn upload" title="Cập nhật file">
                                                                <i class="fas fa-upload"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="5"
                                                    style="text-align:center; padding: 2rem; color:#9ca3af;">
                                                    <i class="fas fa-book-open"
                                                        style="font-size:1.5rem;display:block;margin-bottom:8px;"></i>
                                                    Chưa có sách nào. <a
                                                        href="${pageContext.request.contextPath}/books/create"
                                                        style="color:#7c3aed;">Thêm sách đầu tiên</a>
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </main>
                </div>

            </body>

            </html>