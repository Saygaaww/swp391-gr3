<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER); %>

<jsp:include page="/includes/header.jsp" />

<style>
    .stat-card { background: #fff; border-radius: 10px; padding: 20px; border: 1px solid #e5e7eb; box-shadow: 0 1px 6px rgba(0,0,0,0.04); display: flex; align-items: center; gap: 14px; }
    .stat-icon { width: 48px; height: 48px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 20px; }
    .s1 { background: #eef2ff; color: #4f46e5; }
    .s2 { background: #dcfce7; color: #16a34a; }
    .s4 { background: #fce4ec; color: #e91e63; }
    .s3 { background: #fef3c7; color: #d97706; }
    .stat-info h3 { font-size: 24px; font-weight: 800; color: #1a1a2e; margin: 0; }
    .stat-info p { font-size: 13px; color: #6b7280; font-weight: 500; margin: 0; }
    .filter-bar { background: #fff; padding: 14px 22px; border-radius: 10px; border: 1px solid #e5e7eb; margin-bottom: 20px; }
    .status-badge { padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
    .status-active { background: #dcfce7; color: #166534; }
    .status-blocked { background: #fef2f2; color: #991b1b; }
    .status-inactive { background: #fef3c7; color: #92400e; }
</style>

<main class="container py-5 my-5" style="min-height: 70vh;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight: 700;">
            <i class="fas fa-user-friends" style="color:#4f46e5;"></i> Quản lý Độc giả
        </h2>
        <a href="${pageContext.request.contextPath}/admin/reader-form" class="btn btn-primary" style="background:#1a1a2e; border-color:#1a1a2e;"><i class="fas fa-user-plus"></i> Thêm đọc giả</a>
    </div>
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none"><i class="fas fa-home"></i> Trang chủ</a></li>
            <li class="breadcrumb-item active">Quản lý Độc giả</li>
        </ol>
    </nav>
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${errorMessage}</div>
    </c:if>

    <div class="row mb-4">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s1"><i class="fas fa-user-friends"></i></div>
                <div class="stat-info">
                    <h3>${totalReaders}</h3>
                    <p>Tổng đọc giả</p>
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
                    <p>Đã khóa</p>
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

    <div class="filter-bar shadow-sm">
        <div class="row g-3 align-items-center">
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/admin/readers" class="btn btn-outline-secondary"><i class="fas fa-sync-alt"></i> Làm mới</a>
            </div>
            <div class="col-md-4">
                <div class="input-group">
                    <input type="text" class="form-control" id="searchKeyword" placeholder="Tìm theo tên, email, SĐT..." value="${keyword}">
                    <button type="button" class="btn btn-primary" style="background:#1a1a2e; border-color:#1a1a2e;" onclick="applyFilters()"><i class="fas fa-search"></i> Tìm</button>
                </div>
            </div>
            <div class="col-auto">
                <select id="filterStatus" class="form-select form-select-sm" style="min-width: 120px;">
                    <option value="">Trạng thái...</option>
                    <option value="active" <c:if test="${filterStatus == 'active'}">selected</c:if>>Active</option>
                    <option value="blocked" <c:if test="${filterStatus == 'blocked'}">selected</c:if>>Blocked</option>
                    <option value="inactive" <c:if test="${filterStatus == 'inactive'}">selected</c:if>>Inactive</option>
                </select>
            </div>
            <div class="col-auto">
                <select id="filterRoleId" class="form-select form-select-sm" style="min-width: 120px;">
                    <option value="">Vai trò...</option>
                    <c:forEach var="r" items="${roles}">
                        <option value="${r.roleId}" <c:if test="${filterRoleId == r.roleId}">selected</c:if>>${r.roleName}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-auto">
                <select id="filterPageSize" class="form-select form-select-sm" style="min-width: 90px;">
                    <option value="5" <c:if test="${pageSize == '5'}">selected</c:if>>5/trang</option>
                    <option value="10" <c:if test="${pageSize == '10'}">selected</c:if>>10/trang</option>
                    <option value="20" <c:if test="${pageSize == '20'}">selected</c:if>>20/trang</option>
                    <option value="all" <c:if test="${pageSize == 'all'}">selected</c:if>>Tất cả</option>
                </select>
            </div>
            <div class="col-auto">
                <button type="button" onclick="applyFilters()" class="btn btn-sm btn-dark"><i class="fas fa-filter"></i> Lọc</button>
                <button type="button" onclick="clearFilters()" class="btn btn-sm btn-outline-secondary"><i class="fas fa-times"></i> Xóa lọc</button>
            </div>
        </div>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <c:choose>
                    <c:when test="${empty readerList}">
                        <div class="text-center p-5 text-muted">
                            <i class="fas fa-inbox fa-3x mb-3 text-light"></i>
                            <h5>Không có dữ liệu đọc giả</h5>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Họ và tên</th>
                                    <th>Email</th>
                                    <th>Số điện thoại</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${readerList}">
                                    <tr>
                                        <td><strong>#${r.readerId}</strong></td>
                                        <td>${r.fullName}</td>
                                        <td>${r.email}</td>
                                        <td>${r.phone != null ? r.phone : '—'}</td>
                                        <td>${r.roleName != null ? r.roleName : '—'}</td>
                                        <td>
                                            <span class="status-badge ${r.status == 'active' ? 'status-active' : (r.status == 'blocked' ? 'status-blocked' : 'status-inactive')}">${r.status}</span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/reader-form?id=${r.readerId}" class="btn btn-sm btn-outline-primary">Sửa</a>
                                            <c:choose>
                                                <c:when test="${r.status == 'inactive'}">
                                                    <form action="${pageContext.request.contextPath}/admin/readers" method="post" style="display:inline;" onsubmit="return confirm('Xóa vĩnh viễn đọc giả này? Hành động không thể hoàn tác.');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${r.readerId}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger"><i class="fas fa-trash"></i> Xóa vĩnh viễn</button>
                                                    </form>
                                                </c:when>
                                                <c:when test="${r.status == 'blocked'}">
                                                    <form action="${pageContext.request.contextPath}/admin/readers" method="post" style="display:inline;" onsubmit="return confirm('Mở khóa đọc giả này?');">
                                                        <input type="hidden" name="action" value="unblock">
                                                        <input type="hidden" name="id" value="${r.readerId}">
                                                        <button type="submit" class="btn btn-sm btn-outline-primary"><i class="fas fa-unlock"></i> Mở khóa</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/admin/readers" method="post" style="display:inline;" onsubmit="return confirm('Vô hiệu hóa đọc giả này?');">
                                                        <input type="hidden" name="action" value="deactivate">
                                                        <input type="hidden" name="id" value="${r.readerId}">
                                                        <button type="submit" class="btn btn-sm btn-outline-warning"><i class="fas fa-ban"></i> Vô hiệu hóa</button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="${pageContext.request.contextPath}/admin/readers" method="post" style="display:inline;" onsubmit="return confirm('Khóa đọc giả này?');">
                                                        <input type="hidden" name="action" value="block">
                                                        <input type="hidden" name="id" value="${r.readerId}">
                                                        <button type="submit" class="btn btn-sm btn-outline-danger"><i class="fas fa-lock"></i> Khóa</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/admin/readers" method="post" style="display:inline;" onsubmit="return confirm('Vô hiệu hóa đọc giả này?');">
                                                        <input type="hidden" name="action" value="deactivate">
                                                        <input type="hidden" name="id" value="${r.readerId}">
                                                        <button type="submit" class="btn btn-sm btn-outline-warning"><i class="fas fa-ban"></i> Vô hiệu hóa</button>
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
            <c:if test="${totalPages > 1}">
                <div class="card-footer bg-white border-0 py-3">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="small text-muted">Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong> | Tổng: <strong>${totalReaders}</strong></div>
                        <nav>
                            <ul class="pagination pagination-sm mb-0">
                                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="javascript:goToPage(${currentPage - 1})">Trước</a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="javascript:goToPage(${i})">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="javascript:goToPage(${currentPage + 1})">Sau</a>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
</main>

<script>
    function applyFilters() {
        var u = '${pageContext.request.contextPath}/admin/readers?page=1';
        var k = document.getElementById('searchKeyword').value.trim();
        if (k) u += '&keyword=' + encodeURIComponent(k);
        var s = document.getElementById('filterStatus').value;
        if (s) u += '&status=' + s;
        var r = document.getElementById('filterRoleId').value;
        if (r) u += '&roleId=' + r;
        var p = document.getElementById('filterPageSize').value;
        if (p) u += '&pageSize=' + p;
        window.location.href = u;
    }
    function clearFilters() {
        window.location.href = '${pageContext.request.contextPath}/admin/readers';
    }
    function goToPage(pg) {
        var u = '${pageContext.request.contextPath}/admin/readers?page=' + pg;
        var k = document.getElementById('searchKeyword').value.trim();
        if (k) u += '&keyword=' + encodeURIComponent(k);
        var s = document.getElementById('filterStatus').value;
        if (s) u += '&status=' + s;
        var r = document.getElementById('filterRoleId').value;
        if (r) u += '&roleId=' + r;
        var p = document.getElementById('filterPageSize').value;
        if (p) u += '&pageSize=' + p;
        window.location.href = u;
    }
    document.getElementById('searchKeyword').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') { e.preventDefault(); applyFilters(); }
    });
</script>

<jsp:include page="/includes/footer.jsp" />

