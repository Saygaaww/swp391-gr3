<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="dal.FineDAO" %>
<%@ page import="model.FineView" %>
<%@ page import="dao.NotificationDAO" %>
<%@ page import="model.Notification" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.math.BigDecimal" %>
<style>
    /* ===== COMPACT NAVBAR ===== */
    .site-header {
        position: sticky;
        top: 0;
        z-index: 1000;
        box-shadow: 0 2px 10px rgba(17, 24, 39, 0.08);
    }

    /* --- TOP BAR --- */
    .navbar-top {
        background: #fff;
        padding: 10px 24px;
        display: flex;
        align-items: center;
        gap: 16px;
        border-bottom: 1px solid #e5e7eb;
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
        background: #f3f4f6;
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
        background: #f3f4f6;
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
        background: #4b5563;
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

    /* Notification Dropdown */
    .notif-dropdown {
        position: relative;
    }

    .notif-badge {
        position: absolute;
        top: 3px;
        right: 3px;
        min-width: 16px;
        height: 16px;
        background: #ef4444;
        color: #fff;
        border-radius: 50px;
        font-size: 0.65rem;
        font-weight: 700;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 0 3px;
        border: 2px solid #fff;
        line-height: 1;
    }

    .notif-panel {
        display: none;
        position: absolute;
        right: 0;
        top: calc(100% + 8px);
        background: #fff;
        border-radius: 12px;
        box-shadow: 0 8px 30px rgba(0,0,0,0.14);
        width: 320px;
        overflow: hidden;
        border: 1px solid #f0f0f0;
        z-index: 9999;
    }

    .notif-dropdown:hover .notif-panel,
    .notif-dropdown:focus-within .notif-panel {
        display: block;
    }

    .notif-panel-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 12px 16px 8px;
        border-bottom: 1px solid #f0f0f0;
        font-size: 0.85rem;
        font-weight: 600;
        color: #1e293b;
    }

    .notif-panel-header a {
        font-size: 0.78rem;
        color: #6366f1;
        text-decoration: none;
        font-weight: 500;
    }

    .notif-item {
        display: flex;
        align-items: flex-start;
        gap: 10px;
        padding: 10px 16px;
        border-bottom: 1px solid #f8fafc;
        text-decoration: none;
        color: #334155;
        font-size: 0.82rem;
        transition: background 0.15s;
        cursor: default;
    }

    .notif-item.unread {
        background: #f0f4ff;
    }

    .notif-item:hover {
        background: #f8fafc;
    }

    .notif-item-icon {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 0.8rem;
        flex-shrink: 0;
        margin-top: 1px;
    }

    .notif-icon-return  { background: #d1fae5; color: #059669; }
    .notif-icon-fine    { background: #fee2e2; color: #dc2626; }
    .notif-icon-reservation { background: #fef3c7; color: #d97706; }
    .notif-icon-general { background: #e0e7ff; color: #6366f1; }

    .notif-item-body { flex: 1; min-width: 0; }

    .notif-item-title {
        font-weight: 600;
        color: #1e293b;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .notif-item-msg {
        color: #64748b;
        font-size: 0.78rem;
        margin-top: 1px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }

    .notif-item-time {
        font-size: 0.72rem;
        color: #94a3b8;
        margin-top: 3px;
    }

    .notif-panel-footer {
        padding: 10px 16px;
        text-align: center;
    }

    .notif-panel-footer a {
        font-size: 0.82rem;
        color: #6366f1;
        text-decoration: none;
        font-weight: 500;
    }

    .notif-empty {
        padding: 24px 16px;
        text-align: center;
        color: #94a3b8;
        font-size: 0.83rem;
    }

    /* --- BOTTOM MENU BAR --- */
    .navbar-menu {
        background: #e5e7eb;
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
        color: #374151;
        text-decoration: none;
        font-size: 0.85rem;
        font-weight: 500;
        white-space: nowrap;
        border-bottom: 3px solid transparent;
        transition: color 0.2s, border-color 0.2s;
    }

    .menu-item:hover,
    .menu-item.active {
        color: #111827;
        border-bottom-color: #6b7280;
        background: #f9fafb;
    }

    .menu-item i {
        font-size: 0.8rem;
    }
    .user-home {
        flex: 1; /* Đẩy footer xuống đáy */
    }
</style>

<%
    // Fine notification (Reader only) - computed here to show in navbar everywhere
    int __unpaidFineCount = 0;
    BigDecimal __unpaidFineTotal = BigDecimal.ZERO;
    try {
        Object __role = session != null ? session.getAttribute("userRole") : null;
        Object __readerIdObj = session != null ? session.getAttribute("readerId") : null;
        boolean __isReader = __role != null && ("Reader".equals(__role.toString()) || "User".equals(__role.toString()));
        if (__isReader && __readerIdObj instanceof Integer) {
            int __readerId = (Integer) __readerIdObj;
            FineDAO __fineDao = new FineDAO();
            List<FineView> __fines = __fineDao.getFinesByReader(__readerId);
            for (FineView __f : __fines) {
                if (__f != null && __f.getStatus() != null && !"paid".equalsIgnoreCase(__f.getStatus())) {
                    __unpaidFineCount++;
                    if (__f.getAmount() != null) {
                        __unpaidFineTotal = __unpaidFineTotal.add(__f.getAmount());
                    }
                }
            }
        }
    } catch (Exception ignore) {
        // avoid breaking navbar rendering
    }
    request.setAttribute("unpaidFineCount", __unpaidFineCount);
    request.setAttribute("unpaidFineTotal", __unpaidFineTotal);

    // Load recent notifications for bell dropdown (Reader only)
    List<Notification> __recentNotifs = new ArrayList<>();
    int __notifUnreadCount = 0;
    try {
        Object __roleN = session != null ? session.getAttribute("userRole") : null;
        Object __readerIdN = session != null ? session.getAttribute("readerId") : null;
        boolean __isReaderN = __roleN != null && ("Reader".equals(__roleN.toString()) || "User".equals(__roleN.toString()));
        if (__isReaderN && __readerIdN instanceof Integer) {
            int __rid = (Integer) __readerIdN;
            NotificationDAO __nDao = new NotificationDAO();
            __recentNotifs = __nDao.getNotifications(__rid, 8);
            __notifUnreadCount = __nDao.getUnreadCount(__rid);
            __nDao.close();
        }
    } catch (Exception ignore) {}
    request.setAttribute("recentNotifs", __recentNotifs);
    request.setAttribute("notifUnreadCount", __notifUnreadCount);
%>

<header class="site-header">
    <!-- TOP BAR -->
    <div class="navbar-top">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand-compact">
            <i class="fas fa-book-open"></i>
            <span>DigitalLibrary</span>
        </a>

        <!-- Search Box -->
        <form class="navbar-search" action="${pageContext.request.contextPath}/books" method="get"
              title="Tìm kiếm sách nhanh">
            <i class="fas fa-search" style="color:#94a3b8; font-size:0.85rem;"></i>
            <input type="text" name="keyword" placeholder="Tìm kiếm sách, tác giả..."
                   value="${param.keyword}">
            <button type="submit" class="search-btn" aria-label="Tìm kiếm">
                <i class="fas fa-search"></i>
            </button>
        </form>

        <!-- Icons -->
        <div class="navbar-icons">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <!-- Notification Dropdown -->
                    <div class="notif-dropdown">
                        <button class="icon-btn" title="Thông báo" style="position:relative;">
                            <i class="fas fa-bell"></i>
                            <c:if test="${notifUnreadCount gt 0 or unpaidFineCount gt 0}">
                                <span class="notif-badge">${notifUnreadCount + unpaidFineCount}</span>
                            </c:if>
                        </button>
                        <div class="notif-panel">
                            <div class="notif-panel-header">
                                <span>Thông báo</span>
                                <c:if test="${notifUnreadCount gt 0}">
                                    <form method="post" action="${pageContext.request.contextPath}/notifications/mark-read" style="display:inline;">
                                        <input type="hidden" name="notificationId" value="all">
                                        <button type="submit" style="background:none;border:none;padding:0;color:#6366f1;font-size:0.78rem;font-weight:500;cursor:pointer;">
                                            Đánh dấu đã đọc
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${notifUnreadCount == 0}">
                                    <a href="${pageContext.request.contextPath}/notifications">Xem tất cả</a>
                                </c:if>
                            </div>

                            <%-- Fine alert item nếu có phạt chưa thanh toán --%>
                            <c:if test="${(sessionScope.userRole == 'Reader' or sessionScope.userRole == 'User') and unpaidFineCount gt 0}">
                                <a href="${pageContext.request.contextPath}/customer/fines" class="notif-item unread">
                                    <div class="notif-item-icon notif-icon-fine"><i class="fas fa-exclamation"></i></div>
                                    <div class="notif-item-body">
                                        <div class="notif-item-title">Bạn có ${unpaidFineCount} khoản phạt chưa thanh toán</div>
                                        <div class="notif-item-msg">Tổng: <fmt:formatNumber value="${unpaidFineTotal}" type="number" maxFractionDigits="0"/>đ — Nhấn để xem chi tiết</div>
                                    </div>
                                </a>
                            </c:if>

                            <%-- Recent notifications --%>
                            <c:choose>
                                <c:when test="${empty recentNotifs and unpaidFineCount == 0}">
                                    <div class="notif-empty">
                                        <i class="fas fa-bell-slash" style="font-size:1.5rem;display:block;margin-bottom:6px;"></i>
                                        Chưa có thông báo nào
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="n" items="${recentNotifs}">
                                        <div class="notif-item ${n.read ? '' : 'unread'}">
                                            <div class="notif-item-icon
                                                ${n.notifType == 'return' ? 'notif-icon-return' :
                                                  n.notifType == 'fine' ? 'notif-icon-fine' :
                                                  n.notifType == 'reservation' ? 'notif-icon-reservation' :
                                                  'notif-icon-general'}">
                                                <i class="fas
                                                    ${n.notifType == 'return' ? 'fa-check-circle' :
                                                      n.notifType == 'fine' ? 'fa-exclamation-triangle' :
                                                      n.notifType == 'reservation' ? 'fa-bookmark' :
                                                      'fa-bell'}"></i>
                                            </div>
                                            <div class="notif-item-body">
                                                <div class="notif-item-title">${n.title}</div>
                                                <div class="notif-item-msg">${n.message}</div>
                                                <div class="notif-item-time">${n.timeAgo}</div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>

                            <div class="notif-panel-footer">
                                <a href="${pageContext.request.contextPath}/notifications">Xem tất cả thông báo →</a>
                            </div>
                        </div>
                    </div>

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
                            <c:if test="${(sessionScope.userRole == 'Reader' or sessionScope.userRole == 'User') and unpaidFineCount gt 0}">
                                <a href="${pageContext.request.contextPath}/customer/fines">
                                    <i class="fas fa-bell"></i>
                                    🔔 Bạn có ${unpaidFineCount} khoản phạt cần thanh toán
                                </a>
                                <a href="${pageContext.request.contextPath}/customer/fines">
                                    <i class="fas fa-coins"></i>
                                    Tổng tiền phạt:
                                    <strong>
                                        <fmt:formatNumber value="${unpaidFineTotal}" type="number" maxFractionDigits="0" />đ
                                    </strong>
                                </a>
                                <div class="dropdown-divider"></div>
                            </c:if>
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
                                <a href="${pageContext.request.contextPath}/customer/fines-history">
                                    <i class="fas fa-receipt"></i> Lịch sử trả tiền mượn
                                </a>
                            </c:if>
                            <c:if test="${sessionScope.userRole == 'Admin'}">
                                <a href="${pageContext.request.contextPath}/admin/dashboard">
                                    <i class="fas fa-star"></i> Trang đặc biệt Admin
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/book-list">
                                    <i class="fas fa-toolbox"></i> Quản lý Admin
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
        <a href="${pageContext.request.contextPath}/" class="menu-item">
            <i class="fas fa-home"></i> Trang chủ
        </a>
        <a href="${pageContext.request.contextPath}/books" class="menu-item">
            <i class="fas fa-book"></i> Kho sách
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

        <c:if test="${sessionScope.userRole == 'Admin'}">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="menu-item">
                <i class="fas fa-star"></i> Trang đặc biệt
            </a>
            <a href="${pageContext.request.contextPath}/admin/book-list" class="menu-item">
                <i class="fas fa-layer-group"></i> Sách Admin
            </a>
            <a href="${pageContext.request.contextPath}/admin/readers" class="menu-item">
                <i class="fas fa-users"></i> Độc giả
            </a>
            <a href="${pageContext.request.contextPath}/admin/employees" class="menu-item">
                <i class="fas fa-user-tie"></i> Nhân viên
            </a>
            <a href="${pageContext.request.contextPath}/admin/roles" class="menu-item">
                <i class="fas fa-key"></i> Vai trò
            </a>
            <a href="${pageContext.request.contextPath}/admin/borrow-approve" class="menu-item">
                <i class="fas fa-check-circle"></i> Duyệt mượn
            </a>
            <a href="${pageContext.request.contextPath}/admin/return-list" class="menu-item">
                <i class="fas fa-undo"></i> Duyệt trả
            </a>
            <a href="${pageContext.request.contextPath}/admin/fines" class="menu-item">
                <i class="fas fa-money-bill-wave"></i> Tiền phạt
            </a>
        </c:if>

        <c:if test="${sessionScope.userRole == 'Librarian' or sessionScope.userRole == 'Seller'}">
            <a href="${pageContext.request.contextPath}/books/dashboard" class="menu-item">
                <i class="fas fa-chart-line"></i> Bảng quản lý
            </a>
        </c:if>
    </nav>
</header>
