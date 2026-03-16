<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
    /* ===== COMPACT NAVBAR ===== */
    .site-header {
        position: sticky;
        top: 0;
        z-index: 1000;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.10);
    }

    /* --- TOP BAR --- */
    .navbar-top {
        background: #fff;
        padding: 10px 24px;
        display: flex;
        align-items: center;
        gap: 16px;
        border-bottom: 1px solid #f0f0f0;
    }

    .navbar-brand-compact {
        font-size: 1.1rem;
        font-weight: 700;
        color: #1e293b;
        text-decoration: none;
        white-space: nowrap;
        display: flex;
        align-items: center;
        gap: 8px;
        flex-shrink: 0;
    }

    .navbar-brand-compact i {
        color: #475569;
    }

    .navbar-search {
        flex: 1;
        display: flex;
        align-items: center;
        background: #f1f5f9;
        border-radius: 50px;
        padding: 6px 16px;
        gap: 8px;
        max-width: 500px;
    }

    .navbar-search input {
        border: none;
        background: transparent;
        outline: none;
        width: 100%;
        font-size: 0.9rem;
        color: #334155;
    }

    .navbar-search input::placeholder {
        color: #94a3b8;
    }

    .navbar-search .search-btn {
        background: none;
        border: none;
        cursor: pointer;
        color: #475569;
        padding: 0;
        font-size: 0.95rem;
    }

    .navbar-icons {
        display: flex;
        align-items: center;
        gap: 4px;
        flex-shrink: 0;
        margin-left: auto;
    }

    .icon-btn {
        position: relative;
        background: none;
        border: none;
        cursor: pointer;
        width: 38px;
        height: 38px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #475569;
        font-size: 1rem;
        text-decoration: none;
        transition: background 0.2s;
    }

    .icon-btn:hover {
        background: #f1f5f9;
        color: #1e293b;
    }

    .icon-btn .badge-dot {
        position: absolute;
        top: 5px;
        right: 5px;
        width: 8px;
        height: 8px;
        background: #ef4444;
        border-radius: 50%;
        border: 2px solid #fff;
    }

    /* User Avatar Dropdown */
    .user-dropdown {
        position: relative;
    }

    .user-avatar-btn {
        width: 34px;
        height: 34px;
        border-radius: 50%;
        background: #475569;
        color: #fff;
        border: none;
        cursor: pointer;
        font-size: 0.85rem;
        font-weight: 600;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: opacity 0.2s;
    }

    .user-avatar-btn:hover {
        opacity: 0.85;
    }

    .user-dropdown-menu {
        display: none;
        position: absolute;
        right: 0;
        top: calc(100% + 8px);
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
        min-width: 200px;
        overflow: hidden;
        border: 1px solid #f0f0f0;
    }

    .user-dropdown:hover .user-dropdown-menu,
    .user-dropdown:focus-within .user-dropdown-menu {
        display: block;
    }

    .user-dropdown-menu a {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 16px;
        color: #334155;
        text-decoration: none;
        font-size: 0.88rem;
        transition: background 0.15s;
    }

    .user-dropdown-menu a:hover {
        background: #f8fafc;
    }

    .user-dropdown-menu a i {
        width: 16px;
        color: #64748b;
    }

    .user-dropdown-menu .dropdown-divider {
        height: 1px;
        background: #f0f0f0;
        margin: 4px 0;
    }

    .user-dropdown-menu .logout-link {
        color: #ef4444;
    }

    .user-dropdown-menu .logout-link i {
        color: #ef4444;
    }

    /* --- BOTTOM MENU BAR --- */
    .navbar-menu {
        background: #1e293b;
        padding: 0 24px;
        display: flex;
        align-items: center;
        gap: 0;
        overflow-x: auto;
        scrollbar-width: none;
    }

    .navbar-menu::-webkit-scrollbar {
        display: none;
    }

    .menu-item {
        display: flex;
        align-items: center;
        gap: 6px;
        padding: 10px 16px;
        color: #cbd5e1;
        text-decoration: none;
        font-size: 0.85rem;
        font-weight: 500;
        white-space: nowrap;
        border-bottom: 3px solid transparent;
        transition: color 0.2s, border-color 0.2s;
    }

    .menu-item:hover,
    .menu-item.active {
        color: #fff;
        border-bottom-color: #60a5fa;
    }

    .menu-item i {
        font-size: 0.8rem;
    }
    .user-home {
        flex: 1; /* Đẩy footer xuống đáy */
    }
</style>

<header class="site-header">
    <!-- TOP BAR -->
    <div class="navbar-top">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand-compact">
            <i class="fas fa-book-open"></i>
            <span>DigitalLibrary</span>
        </a>

        <!-- Search Box -->
        <form class="navbar-search" action="${pageContext.request.contextPath}/books" method="get">
            <i class="fas fa-search" style="color:#94a3b8; font-size:0.85rem;"></i>
            <input type="text" name="keyword" placeholder="Tìm kiếm sách, tác giả..."
                   value="${param.keyword}">
        </form>

        <!-- Icons -->
        <div class="navbar-icons">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <!-- Notification -->
                    <a href="${pageContext.request.contextPath}/notifications" class="icon-btn"
                       title="Thông báo">
                        <i class="fas fa-bell"></i>
                    </a>

                    <c:if test="${sessionScope.userRole == 'Reader' or sessionScope.userRole == 'User'}">
                        <!-- Cart -->
                        <a href="${pageContext.request.contextPath}/customer/cart" class="icon-btn"
                           title="Giỏ hàng">
                            <i class="fas fa-shopping-cart"></i>
                        </a>
                    </c:if>

                    <!-- User Avatar Dropdown -->
                    <div class="user-dropdown">
                        <button class="user-avatar-btn" title="${sessionScope.user.fullName}">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user.fullName}">
                                    ${fn:substring(sessionScope.user.fullName, 0, 1)}
                                </c:when>
                                <c:otherwise>U</c:otherwise>
                            </c:choose>
                        </button>
                        <div class="user-dropdown-menu">
                            <a href="${pageContext.request.contextPath}/profile">
                                <i class="fas fa-user"></i> Hồ sơ cá nhân
                            </a>
                            <c:if
                                test="${sessionScope.userRole == 'Reader' or sessionScope.userRole == 'User'}">
                                <a href="${pageContext.request.contextPath}/customer/orders">
                                    <i class="fas fa-box"></i> Đơn hàng của tôi
                                </a>
                                <a href="${pageContext.request.contextPath}/customer/reading-history">
                                    <i class="fas fa-history"></i> Lịch sử đọc
                                </a>
                                <a href="${pageContext.request.contextPath}/customer/my-library">
                                    <i class="fas fa-book-open"></i> Thư viện của tôi 
                                </a>
                                <a href="${pageContext.request.contextPath}/customer/bookmarks">
                                    <i class="fas fa-bookmark"></i> Dấu trang
                                </a>
                                <a href="${pageContext.request.contextPath}/customer/fines">
                                    <i class="fas fa-check-circle"></i> Phạt
                                </a>
                            </c:if>
                            <c:if test="${sessionScope.userRole == 'Admin'}">
                                <a href="${pageContext.request.contextPath}/admin">
                                    <i class="fas fa-tachometer-alt"></i> Quản trị
                                </a>
                            </c:if>
                            <c:if test="${sessionScope.userRole == 'Seller'}">
                                <a href="${pageContext.request.contextPath}/books/dashboard">
                                    <i class="fas fa-tachometer-alt"></i> Bảng Thống Kê
                                </a>
                            </c:if>
                            <div class="dropdown-divider"></div>
                            <a href="${pageContext.request.contextPath}/auth/logout" class="logout-link">
                                <i class="fas fa-sign-out-alt"></i> Đăng xuất
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/auth/login" class="icon-btn"
                       title="Đăng nhập">
                        <i class="fas fa-user"></i>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- BOTTOM MENU BAR -->
    <nav class="navbar-menu">
        <a href="${pageContext.request.contextPath}/books" class="menu-item">
            <i class="fas fa-home"></i> Trang chủ
        </a>
        <a href="${pageContext.request.contextPath}/books/latest" class="menu-item">
            <i class="fas fa-fire"></i> Mới nhất
        </a>
        <a href="${pageContext.request.contextPath}/categories" class="menu-item">
            <i class="fas fa-th-large"></i> Thể loại
        </a>
        <a href="${pageContext.request.contextPath}/authors" class="menu-item">
            <i class="fas fa-pen-nib"></i> Tác giả
        </a>
        <c:if test="${not empty sessionScope.user}">
            <a href="${pageContext.request.contextPath}/customer/reading-history" class="menu-item">
                <i class="fas fa-history"></i> Lịch sử
            </a>
<!--            <a href="${pageContext.request.contextPath}/customer/borrow-request" class="menu-item">
                <i class="fas fa-book-reader"></i> Yêu cầu mượn sách
            </a>-->
            <a href="${pageContext.request.contextPath}/customer/borrow-request-status" class="menu-item">
                <i class="fas fa-clipboard-check"></i> Trạng thái yêu cầu mượn
            </a>
            <a href="${pageContext.request.contextPath}/customer/borrowed-items" class="menu-item">
                <i class="fas fa-book-open"></i> Sách đang mượn
            </a>
            <a href="${pageContext.request.contextPath}/customer/extend-requests" class="menu-item">
                <i class="fas fa-clock"></i> Yêu cầu gia hạn
            </a>
            <a href="${pageContext.request.contextPath}/customer/reservations" class="menu-item">
                <i class="fas fa-bookmark"></i> Đặt sách
            </a>
        </c:if>
        <c:if test="${sessionScope.userRole == 'Admin' or sessionScope.userRole == 'Librarian'}">
            <a href="${pageContext.request.contextPath}/books/create" class="menu-item">
                <i class="fas fa-plus"></i> Thêm sách
            </a>
        </c:if>
    </nav>
</header>