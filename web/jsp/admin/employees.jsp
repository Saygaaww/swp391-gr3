<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER);%>

<jsp:include page="/includes/header.jsp" />

<style>
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
    }

    .role-admin {
        background: #fce4ec;
        color: #c62828;
    }

    .role-librarian {
        background: #e0f2fe;
        color: #0369a1;
    }

    .role-seller {
        background: #dcfce7;
        color: #166534;
    }

    .you-tag {
        color: #4f46e5;
        font-size: 11px;
        font-weight: 600;
        margin-left: 4px;
    }
</style>

<main class="container py-5 my-5" style="min-height: 70vh;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight: 700;">
            <i class="fas fa-user-tie" style="color:#4f46e5;"></i> Quản lý Nhân viên
        </h2>
        <a href="${pageContext.request.contextPath}/admin/employee-form" class="btn btn-primary" style="background:#1a1a2e; border-color:#1a1a2e;"><i class="fas fa-user-plus"></i> Thêm nhân viên</a>
    </div>

    <!-- Breadcrumbs -->
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/"
                                           class="text-decoration-none"><i class="fas fa-home"></i> Trang chủ</a></li>
            <li class="breadcrumb-item active" aria-current="page">Quản Lý Nhân Viên</li>
        </ol>
    </nav>

    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${errorMessage}
        </div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${successMessage}</div>
    </c:if>

    <!-- Stats row -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s1"><i class="fas fa-user-tie"></i></div>
                <div class="stat-info">
                    <h3>${totalEmployees}</h3>
                    <p>Tổng Nhân Viên</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s2"><i class="fas fa-check-circle"></i></div>
                <div class="stat-info">
                    <h3>${activeCount}</h3>
                    <p>Đang Hoạt Động</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s4"><i class="fas fa-lock"></i></div>
                <div class="stat-info">
                    <h3>${blockedCount}</h3>
                    <p>Đã Khóa</p>
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
                <a href="${pageContext.request.contextPath}/admin/employees"
                   class="btn btn-outline-secondary"><i class="fas fa-sync-alt"></i> Làm mới
                </a>
            </div>
            <div class="col-md-4">
                <div class="input-group">
                    <input type="text" class="form-control" id="searchKeyword"
                           placeholder="Tìm theo tên hoặc email..." value="${keyword}">
                    <button class="btn btn-primary"
                            style="background:#1a1a2e; border-color:#1a1a2e;"
                            onclick="applyFilters()"><i class="fas fa-search"></i> Tìm</button>
                </div>
            </div>
            <div class="col-auto">
                <select id="filterStatus" class="form-select form-select-sm"
                        style="min-width: 120px;">
                    <option value="">Trạng thái...</option>
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
                        class="fas fa-times"></i> Xóa Lọc</button>
            </div>
        </div>
    </div>

    <!-- Data Table -->
    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <c:choose>
                    <c:when test="${empty employeeList}">
                        <div class="text-center p-5 text-muted">
                            <i class="fas fa-inbox fa-3x mb-3 text-light"></i>
                            <h5>Không có dữ liệu nhân viên</h5>
                            <p>${not empty keyword ? 'Không tìm thấy kết quả phù hợp.' : 'Hệ thống chưa có nhân viên.'}</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${employeeList}">
                                    <tr>
                                        <td><strong>#${r.employeeId}</strong></td>
                                        <td>
                                            ${r.fullName}
                                            <c:if
                                                test="${r.employeeId == sessionScope.user.employeeId}">
                                                <span class="you-tag text-success">(Bạn)</span>
                                            </c:if>
                                        </td>
                                        <td>${r.email}</td>
                                        <td>
                                            <span class="role-badge 
                                                  ${r.roleName == 'Admin' ? 'role-admin' : 
                                                    (r.roleName == 'Librarian' ? 'role-librarian' : 'role-seller')}">
                                                      ${r.roleName}
                                                  </span>
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
                                                ${r.createdAt.toString().substring(0, 16).replace('T', '
                                                  ')}
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/employee-form?id=${r.employeeId}"
                                                   class="btn btn-sm btn-outline-primary"><i class="fas fa-pen"></i> Sửa</a>
                                                <c:choose>
                                                    <c:when
                                                        test="${r.employeeId == sessionScope.user.employeeId}">
                                                        <span class="badge bg-secondary">Không thể khóa chính mình</span>
                                                    </c:when>
                                                    <c:when test="${r.roleName == 'Admin'}">
                                                        <span class="badge bg-secondary">Được bảo vệ</span>
                                                    </c:when>
                                                    <c:when test="${r.status == 'inactive'}">
                                                        <form
                                                            action="${pageContext.request.contextPath}/admin/employees"
                                                            method="post" style="display:inline;">
                                                            <input type="hidden" name="action"
                                                                   value="delete">
                                                            <input type="hidden" name="id"
                                                                   value="${r.employeeId}">
                                                            <button type="submit"
                                                                    class="btn btn-sm btn-outline-danger"
                                                                    onclick="return confirm('Xóa vĩnh viễn nhân viên này? Hành động không thể hoàn tác.')"><i
                                                                    class="fas fa-trash"></i> Xóa vĩnh viễn</button>
                                                        </form>
                                                    </c:when>
                                                    <c:when test="${r.status == 'blocked'}">
                                                        <form
                                                            action="${pageContext.request.contextPath}/admin/employees"
                                                            method="post" style="display:inline;">
                                                            <input type="hidden" name="action"
                                                                   value="unblock">
                                                            <input type="hidden" name="id"
                                                                   value="${r.employeeId}">
                                                            <button type="submit"
                                                                    class="btn btn-sm btn-outline-primary"
                                                                    onclick="return confirm('Mở khóa nhân viên này?')"><i
                                                                    class="fas fa-unlock"></i> Mở khóa</button>
                                                        </form>
                                                        <form
                                                            action="${pageContext.request.contextPath}/admin/employees"
                                                            method="post" style="display:inline;">
                                                            <input type="hidden" name="action"
                                                                   value="deactivate">
                                                            <input type="hidden" name="id"
                                                                   value="${r.employeeId}">
                                                            <button type="submit"
                                                                    class="btn btn-sm btn-outline-warning"
                                                                    onclick="return confirm('Vô hiệu hóa nhân viên này?')"><i
                                                                    class="fas fa-ban"></i> Vô hiệu hóa</button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form
                                                            action="${pageContext.request.contextPath}/admin/employees"
                                                            method="post" style="display:inline;">
                                                            <input type="hidden" name="action"
                                                                   value="block">
                                                            <input type="hidden" name="id"
                                                                   value="${r.employeeId}">
                                                            <button type="submit"
                                                                    class="btn btn-sm btn-outline-danger"
                                                                    onclick="return confirm('Khóa nhân viên này?')"><i
                                                                    class="fas fa-lock"></i>
                                                                Khóa</button>
                                                        </form>
                                                        <form
                                                            action="${pageContext.request.contextPath}/admin/employees"
                                                            method="post" style="display:inline;">
                                                            <input type="hidden" name="action"
                                                                   value="deactivate">
                                                            <input type="hidden" name="id"
                                                                   value="${r.employeeId}">
                                                            <button type="submit"
                                                                    class="btn btn-sm btn-outline-warning"
                                                                    onclick="return confirm('Vô hiệu hóa nhân viên này?')"><i
                                                                    class="fas fa-ban"></i> Vô hiệu hóa</button>
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
                            <strong>${totalPages}</strong> | Tổng: <strong>${totalEmployees}</strong>
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
            var u = '${pageContext.request.contextPath}/admin/employees?page=1';
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
            window.location.href = '${pageContext.request.contextPath}/admin/employees';
        }
        function goToPage(pg) {
            var k = document.getElementById('searchKeyword').value.trim();
            var s = document.getElementById('filterStatus').value;
            var r = document.getElementById('filterRoleId').value;
            var p = document.getElementById('filterPageSize').value;
            var u = '${pageContext.request.contextPath}/admin/employees?page=' + pg;
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

