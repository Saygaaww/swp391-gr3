<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Digital Library - Thu vien So</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f5f7;
            min-height: 100vh;
            color: #333;
        }

        /* ===== NAVBAR ===== */
        .navbar {
            background: #1a1a2e;
            padding: 0 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 64px;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 12px rgba(0,0,0,0.3);
        }
        .navbar-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #fff;
            text-decoration: none;
            font-size: 20px;
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        .navbar-brand i { font-size: 24px; color: #e0e0e0; }
        .navbar-links {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .navbar-links a {
            color: #ccc;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
        }
        .navbar-links a:hover {
            color: #fff;
            background: rgba(255,255,255,0.1);
        }
        .navbar-links a.active {
            color: #fff;
            background: rgba(255,255,255,0.12);
        }
        .navbar-links .nav-divider {
            width: 1px;
            height: 24px;
            background: rgba(255,255,255,0.15);
            margin: 0 4px;
        }
        .btn-admin {
            background: #e74c3c !important;
            color: #fff !important;
            font-weight: 600 !important;
            padding: 8px 18px !important;
        }
        .btn-admin:hover { background: #c0392b !important; }
        .btn-login-nav {
            background: #fff !important;
            color: #1a1a2e !important;
            font-weight: 700 !important;
            padding: 8px 20px !important;
        }
        .btn-login-nav:hover { background: #e0e0e0 !important; }
        .btn-logout-nav {
            border: 1px solid rgba(255,255,255,0.3) !important;
            color: #fff !important;
        }
        .btn-logout-nav:hover {
            background: rgba(255,255,255,0.15) !important;
        }
        .user-greeting {
            color: #aaa;
            font-size: 13px;
            margin-right: 4px;
        }
        .user-greeting strong { color: #fff; }
        .role-tag {
            background: #e74c3c;
            color: #fff;
            font-size: 10px;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 4px;
            text-transform: uppercase;
            margin-left: 4px;
        }

        /* ===== ADMIN ACTIONS ON CARDS ===== */
        .book-admin-actions {
            display: flex;
            gap: 6px;
            padding: 0 16px 14px;
        }
        .book-admin-actions a {
            flex: 1;
            text-align: center;
            padding: 6px 0;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-edit-sm {
            background: #f0f0f0;
            color: #555;
            border: 1px solid #ddd;
        }
        .btn-edit-sm:hover { background: #e0e0e0; color: #333; }
        .btn-delete-sm {
            background: #fff0f0;
            color: #e74c3c;
            border: 1px solid #fdd;
        }
        .btn-delete-sm:hover { background: #fde0e0; }

        /* ===== HERO ===== */
        .hero {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            color: #fff;
            padding: 70px 40px 80px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .hero::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.03'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
            opacity: 0.5;
        }
        .hero-content {
            position: relative;
            z-index: 1;
            max-width: 750px;
            margin: 0 auto;
        }
        .hero h1 {
            font-size: 42px;
            margin-bottom: 14px;
            font-weight: 800;
            letter-spacing: -0.5px;
        }
        .hero p {
            font-size: 17px;
            opacity: 0.8;
            margin-bottom: 30px;
            line-height: 1.7;
        }
        .hero-search {
            max-width: 520px;
            margin: 0 auto 35px;
            position: relative;
        }
        .hero-search input {
            width: 100%;
            padding: 14px 50px 14px 20px;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            background: rgba(255,255,255,0.12);
            color: #fff;
            outline: none;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.15);
        }
        .hero-search input::placeholder { color: rgba(255,255,255,0.5); }
        .hero-search input:focus {
            background: rgba(255,255,255,0.18);
            border-color: rgba(255,255,255,0.3);
        }
        .hero-search button {
            position: absolute;
            right: 6px;
            top: 50%;
            transform: translateY(-50%);
            background: #e74c3c;
            border: none;
            color: #fff;
            width: 40px;
            height: 40px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.2s;
        }
        .hero-search button:hover { background: #c0392b; }
        .hero-stats {
            display: flex;
            justify-content: center;
            gap: 50px;
        }
        .hero-stat { text-align: center; }
        .hero-stat .number {
            font-size: 32px;
            font-weight: 800;
            display: block;
        }
        .hero-stat .label {
            font-size: 13px;
            opacity: 0.6;
            text-transform: uppercase;
            letter-spacing: 1.5px;
        }

        /* ===== SECTIONS ===== */
        .section {
            max-width: 1200px;
            margin: 45px auto;
            padding: 0 20px;
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        .section-header h2 {
            font-size: 24px;
            color: #1a1a2e;
            font-weight: 700;
        }
        .section-header h2 i {
            color: #888;
            margin-right: 10px;
            font-size: 20px;
        }
        .view-all {
            color: #555;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.2s;
        }
        .view-all:hover { color: #1a1a2e; }

        /* ===== BOOK CARDS ===== */
        .books-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 22px;
        }
        .book-card {
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 1px 8px rgba(0,0,0,0.06);
            transition: all 0.25s ease;
            border: 1px solid #eee;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        .book-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            border-color: #ddd;
        }
        .book-cover {
            width: 100%;
            height: 220px;
            background: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        .book-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .book-cover .no-cover {
            font-size: 50px;
            color: #bbb;
        }
        .book-cover .badge-new {
            position: absolute;
            top: 10px;
            left: 10px;
            background: #e74c3c;
            color: #fff;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 4px;
            text-transform: uppercase;
        }
        .book-info {
            padding: 16px;
        }
        .book-info h3 {
            font-size: 15px;
            color: #1a1a2e;
            margin-bottom: 8px;
            line-height: 1.45;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            font-weight: 600;
        }
        .book-meta {
            display: flex;
            flex-direction: column;
            gap: 5px;
            font-size: 13px;
            color: #888;
        }
        .book-meta .author { color: #666; font-weight: 500; }
        .book-meta .author i { margin-right: 4px; color: #aaa; }
        .book-meta .category-badge {
            background: #f0f0f0;
            color: #666;
            padding: 3px 10px;
            border-radius: 4px;
            display: inline-block;
            font-size: 11px;
            font-weight: 600;
            width: fit-content;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        .book-price {
            margin-top: 10px;
            font-size: 16px;
            font-weight: 700;
            color: #e74c3c;
        }
        .book-price.free { color: #27ae60; }

        /* ===== CATEGORIES ===== */
        .categories-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        .category-tag {
            background: #fff;
            border: 1px solid #e0e0e0;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            color: #555;
            font-weight: 500;
            transition: all 0.2s;
            text-decoration: none;
            cursor: default;
        }
        .category-tag:hover {
            border-color: #1a1a2e;
            color: #1a1a2e;
            background: #f8f8f8;
        }
        .category-tag i { margin-right: 6px; color: #999; }

        /* ===== FEATURES ===== */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }
        .feature-card {
            background: #fff;
            border-radius: 10px;
            padding: 28px 22px;
            text-align: center;
            box-shadow: 0 1px 8px rgba(0,0,0,0.06);
            border: 1px solid #eee;
            transition: all 0.25s;
        }
        .feature-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.08);
        }
        .feature-icon {
            width: 56px;
            height: 56px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            font-size: 24px;
        }
        .feature-icon.f1 { background: #eef2ff; color: #4f46e5; }
        .feature-icon.f2 { background: #fef3c7; color: #d97706; }
        .feature-icon.f3 { background: #dcfce7; color: #16a34a; }
        .feature-icon.f4 { background: #fce4ec; color: #e91e63; }
        .feature-card h3 {
            font-size: 15px;
            color: #1a1a2e;
            margin-bottom: 8px;
            font-weight: 600;
        }
        .feature-card p {
            font-size: 13px;
            color: #888;
            line-height: 1.6;
        }

        /* ===== FOOTER ===== */
        .footer {
            background: #1a1a2e;
            color: #fff;
            padding: 40px;
            margin-top: 60px;
        }
        .footer-inner {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .footer-brand { font-size: 18px; font-weight: 700; }
        .footer-brand i { margin-right: 8px; }
        .footer-copy { font-size: 13px; color: #888; margin-top: 6px; }
        .footer-links { display: flex; gap: 20px; }
        .footer-links a {
            color: #aaa;
            text-decoration: none;
            font-size: 13px;
            transition: color 0.2s;
        }
        .footer-links a:hover { color: #fff; }

        /* ===== EMPTY ===== */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-state i { font-size: 50px; margin-bottom: 15px; display: block; color: #ccc; }

        /* ===== RESPONSIVE ===== */
        @media (max-width: 992px) {
            .books-grid { grid-template-columns: repeat(3, 1fr); }
            .features-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 768px) {
            .navbar { padding: 0 16px; }
            .navbar-links { gap: 4px; }
            .hero { padding: 50px 20px 60px; }
            .hero h1 { font-size: 28px; }
            .hero-stats { gap: 30px; }
            .books-grid { grid-template-columns: repeat(2, 1fr); gap: 14px; }
            .features-grid { grid-template-columns: 1fr 1fr; }
            .footer-inner { flex-direction: column; text-align: center; gap: 15px; }
        }
        @media (max-width: 480px) {
            .books-grid { grid-template-columns: 1fr; }
            .features-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <%-- ===== NAVBAR ===== --%>
    <nav class="navbar">
        <a href="${pageContext.request.contextPath}/home" class="navbar-brand">
            <i class="fas fa-book-open"></i> Digital Library
        </a>

        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/home" class="active">
                <i class="fas fa-home"></i> Trang chu
            </a>

            <c:choose>
                <%-- === EMPLOYEE (ADMIN / LIBRARIAN / SELLER) === --%>
                <c:when test="${not empty currentEmployee}">
                    <c:if test="${currentEmployee.roleName eq 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                        <a href="${pageContext.request.contextPath}/books-list">
                            <i class="fas fa-book"></i> Sach
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/readers">
                            <i class="fas fa-users"></i> Doc gia
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/employees">
                            <i class="fas fa-user-tie"></i> Nhan vien
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/borrow-list">
                            <i class="fas fa-clipboard-list"></i> Muon tra
                        </a>
                    </c:if>
                    <c:if test="${currentEmployee.roleName eq 'LIBRARIAN'}">
                        <a href="${pageContext.request.contextPath}/admin/borrow-list">
                            <i class="fas fa-clipboard-list"></i> Muon tra
                        </a>
                    </c:if>
                    <c:if test="${currentEmployee.roleName eq 'SELLER'}">
                        <a href="${pageContext.request.contextPath}/seller/home.jsp">
                            <i class="fas fa-store"></i> Ban hang
                        </a>
                    </c:if>

                    <div class="nav-divider"></div>
                    <span class="user-greeting">
                        <strong>${currentEmployee.fullName}</strong>
                        <span class="role-tag">${currentEmployee.roleName}</span>
                    </span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout-nav">
                        <i class="fas fa-sign-out-alt"></i> Dang xuat
                    </a>
                </c:when>

                <%-- === READER (USER) === --%>
                <c:when test="${not empty currentReader}">
                    <div class="nav-divider"></div>
                    <span class="user-greeting">Xin chao, <strong>${currentReader.fullName}</strong></span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout-nav">
                        <i class="fas fa-sign-out-alt"></i> Dang xuat
                    </a>
                </c:when>

                <%-- === GUEST === --%>
                <c:otherwise>
                    <div class="nav-divider"></div>
                    <a href="${pageContext.request.contextPath}/register">
                        <i class="fas fa-user-plus"></i> Dang ky
                    </a>
                    <a href="${pageContext.request.contextPath}/login" class="btn-login-nav">
                        <i class="fas fa-sign-in-alt"></i> Dang nhap
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <%-- ===== HERO ===== --%>
    <section class="hero">
        <div class="hero-content">
            <h1><i class="fas fa-book-reader"></i> Thu vien So Digital Library</h1>
            <p>He thong quan ly thu vien hien dai — Kham pha kho sach phong phu voi hang tram dau sach da dang the loai</p>

            <form class="hero-search" action="${pageContext.request.contextPath}/home" method="get">
                <input type="text" name="search" placeholder="Tim kiem sach, tac gia, the loai..."
                       value="${param.search}">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>

            <div class="hero-stats">
                <div class="hero-stat">
                    <span class="number">${totalBooks}</span>
                    <span class="label">Dau sach</span>
                </div>
                <div class="hero-stat">
                    <span class="number">${totalCategories}</span>
                    <span class="label">The loai</span>
                </div>
                <div class="hero-stat">
                    <span class="number">${totalAuthors}</span>
                    <span class="label">Tac gia</span>
                </div>
            </div>
        </div>
    </section>

    <%-- ===== LATEST BOOKS ===== --%>
    <section class="section">
        <div class="section-header">
            <h2><i class="fas fa-fire"></i> Sach moi nhat</h2>
            <c:if test="${not empty currentEmployee && currentEmployee.roleName eq 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/admin/book-form"
                   style="background:#1a1a2e;color:#fff;padding:8px 18px;border-radius:6px;text-decoration:none;font-size:13px;font-weight:600;">
                    <i class="fas fa-plus"></i> Them sach
                </a>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${not empty latestBooks}">
                <div class="books-grid">
                    <c:forEach var="book" items="${latestBooks}" varStatus="st">
                        <div class="book-card">
                            <a href="${pageContext.request.contextPath}/admin/book-detail?id=${book.bookId}"
                               style="text-decoration:none;color:inherit;">
                            <div class="book-cover">
                                <c:if test="${st.index < 3}">
                                    <span class="badge-new">Moi</span>
                                </c:if>
                                <c:choose>
                                    <c:when test="${not empty book.coverUrl}">
                                        <img src="${pageContext.request.contextPath}/${book.coverUrl}"
                                             alt="${book.title}"
                                             onerror="this.style.display='none';this.nextElementSibling.style.display='flex';">
                                        <div class="no-cover" style="display:none;">
                                            <i class="fas fa-book"></i>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="no-cover"><i class="fas fa-book"></i></div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="book-info">
                                <h3>${book.title}</h3>
                                <div class="book-meta">
                                    <span class="author">
                                        <i class="fas fa-pen-nib"></i>
                                        ${not empty book.authorName ? book.authorName : 'Chua ro tac gia'}
                                    </span>
                                    <c:if test="${not empty book.categoryName}">
                                        <span class="category-badge">${book.categoryName}</span>
                                    </c:if>
                                </div>
                                <c:choose>
                                    <c:when test="${book.price != null && book.price.doubleValue() > 0}">
                                        <div class="book-price">
                                            <fmt:formatNumber value="${book.price}" pattern="#,###"/> ${book.currency}
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="book-price free"><i class="fas fa-gift"></i> Mien phi</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            </a>

                            <%-- Admin: Edit / Delete --%>
                            <c:if test="${not empty currentEmployee && currentEmployee.roleName eq 'ADMIN'}">
                                <div class="book-admin-actions">
                                    <a href="${pageContext.request.contextPath}/admin/book-form?id=${book.bookId}"
                                       class="btn-edit-sm"><i class="fas fa-pen"></i> Sua</a>
                                    <a href="${pageContext.request.contextPath}/admin/book-delete?id=${book.bookId}"
                                       class="btn-delete-sm"
                                       onclick="return confirm('Ban co chac muon xoa sach nay?');">
                                       <i class="fas fa-trash"></i> Xoa</a>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <p>Chua co sach nao trong thu vien</p>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

    <%-- ===== CATEGORIES ===== --%>
    <c:if test="${not empty categories}">
        <section class="section">
            <div class="section-header">
                <h2><i class="fas fa-tags"></i> The loai sach</h2>
            </div>
            <div class="categories-grid">
                <c:forEach var="cat" items="${categories}">
                    <span class="category-tag">
                        <i class="fas fa-bookmark"></i> ${cat.categoryName}
                    </span>
                </c:forEach>
            </div>
        </section>
    </c:if>

    <%-- ===== FEATURES ===== --%>
    <section class="section">
        <div class="section-header">
            <h2><i class="fas fa-star"></i> Tinh nang noi bat</h2>
        </div>
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon f1"><i class="fas fa-book-open"></i></div>
                <h3>Kho sach phong phu</h3>
                <p>Hang tram dau sach da dang the loai, tu van hoc den khoa hoc ky thuat</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon f2"><i class="fas fa-search"></i></div>
                <h3>Tim kiem thong minh</h3>
                <p>Tim kiem theo ten sach, tac gia, the loai mot cach nhanh chong</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon f3"><i class="fas fa-hand-holding-heart"></i></div>
                <h3>Muon sach online</h3>
                <p>Gui yeu cau muon sach truc tuyen, tien loi va nhanh chong</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon f4"><i class="fas fa-user-shield"></i></div>
                <h3>Quan ly hieu qua</h3>
                <p>He thong quan ly danh cho nhan vien thu vien voi day du chuc nang</p>
            </div>
        </div>
    </section>

    <%-- ===== FOOTER ===== --%>
    <footer class="footer">
        <div class="footer-inner">
            <div>
                <div class="footer-brand"><i class="fas fa-book-open"></i> Digital Library</div>
                <div class="footer-copy">&copy; 2025 PRJ301 - Library Management System</div>
            </div>
            <div class="footer-links">
                <a href="${pageContext.request.contextPath}/home">Trang chu</a>
                <a href="${pageContext.request.contextPath}/login">Dang nhap</a>
                <a href="${pageContext.request.contextPath}/register">Dang ky</a>
            </div>
        </div>
    </footer>
</body>
</html>
