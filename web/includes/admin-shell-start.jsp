<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .admin-shell {
        min-height: 100vh;
        background: #f3f4f6;
    }

    .admin-topbar {
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

    .admin-brand {
        display: flex;
        align-items: center;
        gap: 10px;
        font-size: 1.15rem;
        font-weight: 700;
        color: #111827;
        text-decoration: none;
    }

    .admin-brand i {
        color: #7c3aed;
    }

    .admin-topbar-right {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .admin-role-badge {
        background: linear-gradient(135deg, #6366f1, #8b5cf6);
        color: #fff;
        padding: 4px 12px;
        border-radius: 99px;
        font-size: 0.78rem;
        font-weight: 600;
    }

    .admin-top-link {
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

    .admin-top-link:hover {
        background: #f3f4f6;
        color: #7c3aed;
    }

    .admin-top-link.danger {
        color: #dc2626;
    }

    .admin-top-link.danger:hover {
        background: #fef2f2;
    }

    .admin-layout {
        display: flex;
    }

    .admin-sidebar {
        width: 240px;
        background: #ffffff;
        border-right: 1px solid #e5e7eb;
        min-height: calc(100vh - 64px);
        padding: 1.5rem 1rem;
        position: sticky;
        top: 64px;
        flex-shrink: 0;
    }

    .admin-sidebar-section {
        font-size: 0.7rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: #9ca3af;
        padding: 0 0.75rem;
        margin-bottom: 6px;
        margin-top: 16px;
    }

    .admin-sidebar-section:first-child {
        margin-top: 0;
    }

    .admin-sidebar-link {
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

    .admin-sidebar-link:hover {
        background: #f3f4f6;
        color: #7c3aed;
    }

    .admin-sidebar-link i {
        width: 18px;
        text-align: center;
    }

    .admin-main {
        flex: 1;
        padding: 2rem;
        min-height: calc(100vh - 64px);
    }

    .admin-page-card {
        background: #fff;
        border-radius: 12px;
        padding: 20px;
        border: 1px solid #e5e7eb;
        box-shadow: 0 1px 6px rgba(0, 0, 0, 0.04);
    }

    @media (max-width: 992px) {
        .admin-sidebar {
            display: none;
        }

        .admin-main {
            padding: 1rem;
        }
    }
</style>

<div class="admin-shell">
    <header class="admin-topbar">
        <a href="${pageContext.request.contextPath}/books/dashboard" class="admin-brand">
            <i class="fas fa-book-open"></i> Thư viện Số FPT
        </a>
        <div class="admin-topbar-right">
            <span class="admin-role-badge">
                <i class="fas fa-user-tie" style="margin-right:4px;"></i>
                ${sessionScope.userRole}
            </span>
            <a href="${pageContext.request.contextPath}/books/list" class="admin-top-link">
                <i class="fas fa-eye"></i> Xem trang người dùng
            </a>
            <a href="${pageContext.request.contextPath}/auth/logout" class="admin-top-link danger">
                <i class="fas fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </header>

    <div class="admin-layout">
        <aside class="admin-sidebar">
            <div class="admin-sidebar-section">Tong quan</div>
            <a href="${pageContext.request.contextPath}/books/dashboard" class="admin-sidebar-link">
                <i class="fas fa-chart-bar"></i> Dashboard
            </a>

            <div class="admin-sidebar-section">Quan ly danh muc</div>
            <a href="${pageContext.request.contextPath}/books/create" class="admin-sidebar-link">
                <i class="fas fa-plus-circle"></i> Them sach moi
            </a>
            <a href="${pageContext.request.contextPath}/books/list" class="admin-sidebar-link">
                <i class="fas fa-book"></i> Danh sach sach
            </a>
            <a href="${pageContext.request.contextPath}/authors" class="admin-sidebar-link">
                <i class="fas fa-user-edit"></i> Tac gia
            </a>
            <a href="${pageContext.request.contextPath}/categories" class="admin-sidebar-link">
                <i class="fas fa-tags"></i> The loai
            </a>
            <a href="${pageContext.request.contextPath}/admin/borrow-list" class="admin-sidebar-link">
                <i class="fas fa-check-circle"></i> Duyet yeu cau muon
            </a>
            <a href="${pageContext.request.contextPath}/admin/return-list" class="admin-sidebar-link">
                <i class="fas fa-undo"></i> Duyet tra sach
            </a>
            <a href="${pageContext.request.contextPath}/admin/borrowed-items" class="admin-sidebar-link">
                <i class="fas fa-history"></i> Lich su Muon / Tra
            </a>
            <a href="${pageContext.request.contextPath}/admin/fines" class="admin-sidebar-link">
                <i class="fas fa-file-invoice-dollar"></i> Quan ly tien phat
            </a>
            <a href="${pageContext.request.contextPath}/admin/reservations" class="admin-sidebar-link">
                <i class="fas fa-bookmark"></i> Quan ly dat sach
            </a>
        </aside>

        <main class="admin-main">
