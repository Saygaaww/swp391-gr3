<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <%@ page import="model.Employee, util.AuthUtil" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
                <% Employee currentAdmin=(Employee) session.getAttribute(AuthUtil.SESSION_USER); %>

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
                            background: #eef2ff;
                            color: #4f46e5;
                        }
                    </style>

                    <main class="container py-5 my-5" style="min-height: 70vh;">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h2 class="mb-0" style="font-weight: 700;"><i class="fas fa-users"
                                    style="color:#4f46e5;"></i> Qu?n lï¿½ ï¿½?c gi?</h2>
                        </div>

                        <!-- Breadcrumbs -->
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard"
                                        class="text-decoration-none"><i class="fas fa-home"></i> Trang ch?</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Qu?n lï¿½ ï¿½?c gi?</li>
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
                                    <div class="stat-icon s1"><i class="fas fa-users"></i></div>
                                    <div class="stat-info">
                                        <h3>${totalReaders}</h3>
                                        <p>T?ng d?c gi?</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card">
                                    <div class="stat-icon s2"><i class="fas fa-check-circle"></i></div>
                                    <div class="stat-info">
                                        <h3>${activeCount}</h3>
                                        <p>ï¿½ang ho?t d?ng</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card">
                                    <div class="stat-icon s4"><i class="fas fa-lock"></i></div>
                                    <div class="stat-info">
                                        <h3>${blockedCount}</h3>
                                        <p>ï¿½ï¿½ khï¿½a</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stat-card">
                                    <div class="stat-icon s3"><i class="fas fa-file-alt"></i></div>
                                    <div class="stat-info">
                                        <h3>${currentPage}/${totalPages}</h3>
                                        <p>Trang hi?n t?i</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Toolbar & Filters -->
                        <div class="filter-bar shadow-sm">
                            <div class="row g-3 align-items-center">
                                <div class="col-auto">
                                    <a href="${pageContext.request.contextPath}/admin/readers"
                                        class="btn btn-outline-secondary"><i class="fas fa-sync-alt"></i> Lï¿½m m?i</a>
                                </div>
                                <div class="col-md-4">
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="searchKeyword"
                                            placeholder="Tï¿½m theo tï¿½n ho?c email..." value="${keyword}">
                                        <button class="btn btn-primary"
                                            style="background:#1a1a2e; border-color:#1a1a2e;"
                                            onclick="applyFilters()"><i class="fas fa-search"></i> Tï¿½m</button>
                                    </div>
                                </div>
                                <div class="col-auto">
                                    <select id="filterStatus" class="form-select form-select-sm"
                                        style="min-width: 120px;">
                                        <option value="">Tr?ng thï¿½i...</option>
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
                                        <option value="">Vai trï¿½...</option>
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
                                        <option value="all" ${pageSize=='all' ? 'selected' : '' }>T?t c?</option>
                                    </select>
                                </div>
                                <div class="col-auto">
                                    <button onclick="applyFilters()" class="btn btn-sm btn-dark"><i
                                            class="fas fa-filter"></i> L?c</button>
                                    <button onclick="clearFilters()" class="btn btn-sm btn-outline-secondary"><i
                                            class="fas fa-times"></i> Xï¿½a l?c</button>
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
                                                <h5>Khï¿½ng cï¿½ d? li?u d?c gi?</h5>
                                                <p>${not empty keyword ? 'Khï¿½ng tï¿½m th?y k?t qu? phï¿½ h?p.' : 'H?
                                                    th?ng
                                                    chua cï¿½ d?c gi?.'}</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <table class="table table-hover align-middle mb-0">
                                                <thead class="table-light">
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>H? tï¿½n</th>
                                                        <th>Email</th>
                                                        <th>Sï¿½T</th>
                                                        <th>Vai trï¿½</th>
                                                        <th>Tr?ng thï¿½i</th>
                                                        <th>Ngï¿½y t?o</th>
                                                        <th>Thao tï¿½c</th>
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
                                                                        onchange="if(confirm('Thay đổi vai trò người dùng này sang ' + this.options[this.selectedIndex].text + '?')) this.form.submit(); else this.value='${r.roleId}';">
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
                                                                ${r.createdAt.toString().substring(0, 16).replace('T', '
                                                                ')}
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
                                                                                onclick="return confirm('M? khï¿½a d?c gi? nï¿½y?')"><i
                                                                                    class="fas fa-unlock"></i> M?
                                                                                khï¿½a</button>
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
                                                                                onclick="return confirm('Khï¿½a d?c gi? nï¿½y?')"><i
                                                                                    class="fas fa-lock"></i>
                                                                                Khï¿½a</button>
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
                                            <strong>${totalPages}</strong> | T?ng: <strong>${totalReaders}</strong>
                                        </div>
                                        <nav>
                                            <ul class="pagination pagination-sm mb-0">
                                                <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                                    <a class="page-link"
                                                        href="javascript:goToPage(${currentPage - 1})">Tru?c</a>
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
                        function applyFilters() { var k = document.getElementById('searchKeyword').value.trim(); var s = document.getElementById('filterStatus').value; var r = document.getElementById('filterRoleId').value; var p = document.getElementById('filterPageSize').value; var u = '${pageContext.request.contextPath}/admin/readers?page=1'; if (k) u += '&keyword=' + encodeURIComponent(k); if (s) u += '&status=' + s; if (r) u += '&roleId=' + r; if (p) u += '&pageSize=' + p; window.location.href = u; }
                        function clearFilters() { window.location.href = '${pageContext.request.contextPath}/admin/readers'; }
                        function goToPage(pg) { var k = document.getElementById('searchKeyword').value.trim(); var s = document.getElementById('filterStatus').value; var r = document.getElementById('filterRoleId').value; var p = document.getElementById('filterPageSize').value; var u = '${pageContext.request.contextPath}/admin/readers?page=' + pg; if (k) u += '&keyword=' + encodeURIComponent(k); if (s) u += '&status=' + s; if (r) u += '&roleId=' + r; if (p) u += '&pageSize=' + p; window.location.href = u; }
                        document.getElementById('searchKeyword').addEventListener('keypress', function (e) { if (e.key === 'Enter') { e.preventDefault(); applyFilters(); } });
                    </script>

                    <jsp:include page="/includes/footer.jsp" />
