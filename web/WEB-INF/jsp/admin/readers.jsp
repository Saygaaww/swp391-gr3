<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER);%>

<jsp:include page="/includes/header.jsp" />

<style>
    /* Admin nav bar */
    .admin-header { background: #1a1a2e; color: #fff; padding: 0 40px; height: 64px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 12px rgba(0,0,0,0.3); position: fixed; top: 0; left: 0; right: 0; z-index: 1050; }
    .admin-header-left { display: flex; align-items: center; gap: 24px; }
    .admin-header h1 { font-size: 18px; font-weight: 700; margin: 0; color: #fff; }
    .admin-header h1 i { margin-right: 8px; }
    .admin-header-nav { display: flex; gap: 4px; }
    .admin-header-nav a { color: #ccc; text-decoration: none; padding: 8px 14px; border-radius: 6px; font-size: 13px; font-weight: 500; transition: all 0.2s; }
    .admin-header-nav a:hover { color: #fff; background: rgba(255,255,255,0.1); }
    .admin-header-nav a.active { color: #fff; background: rgba(255,255,255,0.12); }
    .admin-header-right { display: flex; align-items: center; gap: 16px; }
    .admin-user-badge { display: flex; align-items: center; gap: 8px; color: #ccc; font-size: 13px; }
    .admin-user-badge strong { color: #fff; }
    .admin-role-tag { background: #e74c3c; color: #fff; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; text-transform: uppercase; }
    .admin-btn-logout { padding: 7px 14px; border: 1px solid rgba(255,255,255,0.25); color: #fff; border-radius: 6px; text-decoration: none; font-size: 13px; transition: all 0.2s; }
    .admin-btn-logout:hover { background: rgba(255,255,255,0.1); color: #fff; }
    @media (max-width: 992px) { .admin-header-nav { display: none; } .admin-header { padding: 0 16px; } }

    .stat-card {
        background: #fff;
        border-radius: 10px;
        padding: 20px;
        border: 1px solid #e5e7eb;
        box-shadow: 0 1px 6px rgba(0, 0, 0, 0.04);
        display: flex;
        align-items: center;
        gap: 14px;
    }

    .stat-icon {
        width: 48px;
        height: 48px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
    }

    .s1 {
        background: #eef2ff;
        color: #4f46e5;
    }

    .s2 {
        background: #dcfce7;
        color: #16a34a;
    }

    .s4 {
        background: #fce4ec;
        color: #e91e63;
    }

    .s3 {
        background: #fef3c7;
        color: #d97706;
    }

    .stat-info h3 {
        font-size: 24px;
        font-weight: 800;
        color: #1a1a2e;
        margin: 0;
    }

    .stat-info p {
        font-size: 13px;
        color: #6b7280;
        font-weight: 500;
        margin: 0;
    }

    .filter-bar {
        background: #fff;
        padding: 14px 22px;
        border-radius: 10px;
        border: 1px solid #e5e7eb;
        margin-bottom: 20px;
    }

    .status-badge {
        padding: 4px 10px;
        border-radius: 4px;
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
    }

    .status-active {
        background: #dcfce7;
        color: #166534;
    }

    .status-blocked {
        background: #fef2f2;
        color: #991b1b;
    }

    .status-inactive {
        background: #fef3c7;
        color: #92400e;
    }

    .role-badge {
        padding: 4px 10px;
        border-radius: 4px;
        font-size: 11px;
        font-weight: 700;
        background: #eef2ff;
        color: #4f46e5;
    }
</style>

<main class="container py-5" style="min-height: 70vh; margin-top: 80px;">
    <!-- Admin Nav Bar -->
    <div class="admin-header">
        <div class="admin-header-left">
            <h1><i class="fas fa-users"></i> Quan ly Doc gia</h1>
            <nav class="admin-header-nav">
                <a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chu</a>
                <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="${pageContext.request.contextPath}/books-list"><i class="fas fa-book"></i> Sach</a>
                <a href="${pageContext.request.contextPath}/admin/readers" class="active"><i class="fas fa-users"></i> Doc gia</a>
                <a href="${pageContext.request.contextPath}/admin/employees"><i class="fas fa-user-tie"></i> Nhan vien</a>
                <a href="${pageContext.request.contextPath}/admin/borrow-list"><i class="fas fa-clipboard-list"></i> Muon tra</a>
                <a href="${pageContext.request.contextPath}/admin/roles"><i class="fas fa-key"></i> Vai tro</a>
            </nav>
        </div>
        <div class="admin-header-right">
            <div class="admin-user-badge">
                <i class="fas fa-user-circle" style="font-size:20px;"></i>
                <strong>${currentEmployee.fullName}</strong>
                <span class="admin-role-tag">${currentEmployee.roleName}</span>
            </div>
            <a href="${pageContext.request.contextPath}/auth/logout" class="admin-btn-logout">
                <i class="fas fa-sign-out-alt"></i> Dang xuat
            </a>
        </div>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight: 700;"><i class="fas fa-users"
                                                      style="color:#4f46e5;"></i> Quản lí độc giả </h2>
    </div>

    <!-- Breadcrumbs -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard"
                                           class="text-decoration-none"><i class="fas fa-home"></i> Trang chủ</a></li>
            <li class="breadcrumb-item active" aria-current="page">Quản lí độc giả</li>
        </ol>
    </nav>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${sessionScope.successMessage}</div>
        <% session.removeAttribute("successMessage"); %>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${sessionScope.errorMessage}</div>
        <% session.removeAttribute("errorMessage"); %>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${errorMessage}</div>
    </c:if>

    <!-- Stats row -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s1"><i class="fas fa-users"></i></div>
                <div class="stat-info">
                    <h3>${totalReaders}</h3>
                    <p>Tổng độc giả</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s2"><i class="fas fa-check-circle"></i></div>
                <div class="stat-info">
                    <h3>${activeCount}</h3>
                    <p>Đang hoạt động</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s4"><i class="fas fa-lock"></i></div>
                <div class="stat-info">
                    <h3>${blockedCount}</h3>
                    <p>Tài khoản bị khóa</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s3"><i class="fas fa-file-alt"></i></div>
                <div class="stat-info">
                    <h3>${currentPage}/${totalPages}</h3>
                    <p>Trang hiện tại</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Toolbar & Filters -->
    <div class="filter-bar shadow-sm">
        <div class="row g-3 align-items-center">
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/admin/readers"
                   class="btn btn-outline-secondary"><i class="fas fa-sync-alt"></i>Làm mới</a>
            </div>
            <div class="col-md-4">
                <div class="input-group">
                    <input type="text" class="form-control" id="searchKeyword"
                           placeholder="Tìm theo họ tên hoặc email..." value="${keyword}">
                    <button class="btn btn-primary"
                            style="background:#1a1a2e; border-color:#1a1a2e;"
                            onclick="applyFilters()"><i class="fas fa-search"></i> Tìm</button>
                </div>
            </div>
            <div class="col-auto">
                <select id="filterStatus" class="form-select form-select-sm"
                        style="min-width: 120px;">
                    <option value="">Trạng thái</option>
                    <option value="active" ${filterStatus=='active' ? 'selected' : '' }>Active
                    </option>
                    <option value="blocked" ${filterStatus=='blocked' ? 'selected' : '' }>Blocked
                    </option>
                    <option value="inactive" ${filterStatus=='inactive' ? 'selected' : '' }>Inactive
                    </option>
                </select>
            </div>
            <div class="col-auto">
                <select id="filterRoleId" class="form-select form-select-sm"
                        style="min-width: 120px;">
                    <option value="">Vai trò...</option>
                    <c:forEach var="role" items="${roles}">
                        <option value="${role.roleId}" ${filterRoleId==role.roleId ? 'selected' : ''
                                         }>${role.roleName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-auto">
                <select id="filterPageSize" class="form-select form-select-sm"
                        style="min-width: 90px;">
                    <option value="5" ${pageSize=='5' ? 'selected' : '' }>5/trang</option>
                    <option value="10" ${pageSize=='10' ? 'selected' : '' }>10/trang</option>
                    <option value="20" ${pageSize=='20' ? 'selected' : '' }>20/trang</option>
                    <option value="all" ${pageSize=='all' ? 'selected' : '' }>Tất cả</option>
                </select>
            </div>
            <div class="col-auto">
                <button onclick="applyFilters()" class="btn btn-sm btn-dark"><i
                        class="fas fa-filter"></i> Lọc</button>
                <button onclick="clearFilters()" class="btn btn-sm btn-outline-secondary"><i
                        class="fas fa-times"></i> Xóa lọc</button>
            </div>
        </div>
    </div>

    <!-- Data Table -->
    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <c:choose>
                    <c:when test="${empty readerList}">
                        <div class="text-center p-5 text-muted">
                            <i class="fas fa-inbox fa-3x mb-3 text-light"></i>
                            <h5>Không có dữ liệu độc giả</h5>
                            <p>${not empty keyword ? 'không tìm thấy kết quả phù hợp' : 'Hệ thống
                                 chưa có độc giả'}</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>SDT</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${readerList}">
                                    <tr>
                                        <td><strong>#${r.readerId}</strong></td>
                                        <td>${r.fullName}</td>
                                        <td>${r.email}</td>
                                        <td>${r.phone}</td>
                                        <td>
                                            <form
                                                action="${pageContext.request.contextPath}/admin/readers"
                                                method="post" style="display:inline;">
                                                <input type="hidden" name="action"
                                                       value="change_role">
                                                <input type="hidden" name="id"
                                                       value="${r.readerId}">
                                                <select name="roleId"
                                                        class="form-select form-select-sm shadow-none"
                                                        style="width:110px; display:inline-block;"
                                                        onchange="if (confirm('Thay đổi vai trò người dùng này sang ' + this.options[this.selectedIndex].text + '?'))
                                                                                    this.form.submit();
                                                                                else
                                                                                    this.value = '${r.roleId}';">
                                                    <c:forEach var="role" items="${roles}">
                                                        <option value="${role.roleId}"
                                                                ${r.roleId==role.roleId ? 'selected'
                                                                  : '' }>${role.roleName}</option>
                                                    </c:forEach>
                                                </select>
                                            </form>
                                        </td>
                                        <td>

                                            <c:choose>
                                                <c:when test="${r.status == 'active'}"><span
                                                        class="status-badge status-active">Active</span>
                                                </c:when>
                                                <c:when test="${r.status == 'blocked'}"><span
                                                        class="status-badge status-blocked">Blocked</span>
                                                </c:when>
                                                <c:otherwise><span
                                                        class="status-badge status-inactive">${r.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-muted small">
                                            <c:if test="${not empty r.createdAt}">
                                                ${r.createdAt.toLocalDate().toString()}
                                            </c:if>
                                        </td>
                                        <td>

                                            <c:choose>
                                                <c:when test="${r.status == 'blocked'}">
                                                    <form
                                                        action="${pageContext.request.contextPath}/admin/readers"
                                                        method="post" style="display:inline;">
                                                        <input type="hidden" name="action"
                                                               value="unblock">
                                                        <input type="hidden" name="id"
                                                               value="${r.readerId}">
                                                        <button type="submit"
                                                                class="btn btn-sm btn-outline-primary"
                                                                onclick="return confirm('Mở khóa độc giả này?')"><i
                                                                class="fas fa-unlock"></i> Mở khóa
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <form
                                                        action="${pageContext.request.contextPath}/admin/readers"
                                                        method="post" style="display:inline;">
                                                        <input type="hidden" name="action"
                                                               value="block">
                                                        <input type="hidden" name="id"
                                                               value="${r.readerId}">
                                                        <button type="submit"
                                                                class="btn btn-sm btn-outline-danger"
                                                                onclick="return confirm('Khóa độc giả này?')"><i
                                                                class="fas fa-lock"></i> Khóa
                                                        </button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="card-footer bg-white border-0 py-3">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="small text-muted">Trang <strong>${currentPage}</strong> /
                        <strong>${totalPages}</strong> | Tổng: <strong>${totalReaders}</strong>
                    </div>
                    <nav>
                        <ul class="pagination pagination-sm mb-0">
                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="javascript:goToPage(${currentPage - 1})">Trước</a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="javascript:goToPage(${i})">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <a class="page-link"
                                   href="javascript:goToPage(${currentPage + 1})">Sau</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </c:if>
    </div>
</main>

<script>
                        function applyFilters() {
                            var k = document.getElementById('searchKeyword').value.trim();
                            var s = document.getElementById('filterStatus').value;
                            var r = document.getElementById('filterRoleId').value;
                            var p = document.getElementById('filterPageSize').value;
                            var u = '${pageContext.request.contextPath}/admin/readers?page=1';
                            if (k)
                                u += '&keyword=' + encodeURIComponent(k);
                            if (s)
                                u += '&status=' + s;
                            if (r)
                                u += '&roleId=' + r;
                            if (p)
                                u += '&pageSize=' + p;
                            window.location.href = u;
                        }
                        function clearFilters() {
                            window.location.href = '${pageContext.request.contextPath}/admin/readers';
                        }
                        function goToPage(pg) {
                            var k = document.getElementById('searchKeyword').value.trim();
                            var s = document.getElementById('filterStatus').value;
                            var r = document.getElementById('filterRoleId').value;
                            var p = document.getElementById('filterPageSize').value;
                            var u = '${pageContext.request.contextPath}/admin/readers?page=' + pg;
                            if (k)
                                u += '&keyword=' + encodeURIComponent(k);
                            if (s)
                                u += '&status=' + s;
                            if (r)
                                u += '&roleId=' + r;
                            if (p)
                                u += '&pageSize=' + p;
                            window.location.href = u;
                        }
                        document.getElementById('searchKeyword').addEventListener('keypress', function (e) {
                            if (e.key === 'Enter') {
                                e.preventDefault();
                                applyFilters();
                            }
                        });
</script>

<jsp:include page="/includes/footer.jsp" />