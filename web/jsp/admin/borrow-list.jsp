<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER);%>

<jsp:include page="/includes/header.jsp" />

<style>
    .stat-card {
        background: #fff;
        border-radius: 10px;
        padding: 20px;
        border: 1px solid #e5e7eb;
        box-shadow: 0 1px 6px rgba(0,0,0,0.04);
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
        background: #fef3c7;
        color: #d97706;
    }
    .s2 {
        background: #dcfce7;
        color: #16a34a;
    }
    .s3 {
        background: #fce4ec;
        color: #e91e63;
    }
    .s4 {
        background: #eef2ff;
        color: #4f46e5;
    }
    .stat-info h3 {
        font-size: 24px;
        font-weight: 800;
        color: #1a1a2e;
        margin: 0;
    }
    .stat-info p  {
        font-size: 13px;
        color: #6b7280;
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
    .status-pending  {
        background: #fef3c7;
        color: #92400e;
    }
    .status-approved {
        background: #dcfce7;
        color: #166534;
    }
    .status-rejected {
        background: #fef2f2;
        color: #991b1b;
    }
    .date-error {
        font-size: 11px;
        color: #dc2626;
        margin-top: 3px;
    }
</style>

<main class="container py-5 my-5" style="min-height: 70vh;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight: 700;">
            <i class="fas fa-list" style="color:#4f46e5;"></i> Lịch sử yêu cầu mượn sách
        </h2>
        <a href="${pageContext.request.contextPath}/admin/borrow-approve"
           class="btn btn-primary" style="background:#1a1a2e; border-color:#1a1a2e;">
            <i class="fas fa-check-double"></i> Duyệt yêu cầu
        </a>
    </div>

    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none">
                    <i class="fas fa-home"></i> Trang chủ
                </a>
            </li>
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/admin/borrow-approve" class="text-decoration-none">Duyệt yêu cầu</a>
            </li>
            <li class="breadcrumb-item active">Lịch sử</li>
        </ol>
    </nav>

    <!-- ── Stat cards ── -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s1"><i class="fas fa-clock"></i></div>
                <div class="stat-info"><h3>${countPending}</h3><p>Chờ duyệt</p></div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s2"><i class="fas fa-check"></i></div>
                <div class="stat-info"><h3>${countApproved}</h3><p>Đã duyệt</p></div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s3"><i class="fas fa-times"></i></div>
                <div class="stat-info"><h3>${countRejected}</h3><p>Từ chối</p></div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s4"><i class="fas fa-file-alt"></i></div>
                <div class="stat-info"><h3>${totalRequests}</h3><p>Tổng yêu cầu</p></div>
            </div>
        </div>
    </div>

    <!-- ── Filter bar ── -->
    <div class="filter-bar shadow-sm">
        <div class="row g-3 align-items-start">

            <!-- Làm mới -->
            <div class="col-auto align-self-center">
                <a href="${pageContext.request.contextPath}/admin/borrow-list"
                   class="btn btn-outline-secondary">
                    <i class="fas fa-sync-alt"></i> Làm mới
                </a>
            </div>

            <!-- Keyword -->
            <div class="col-md-3">
                <input type="text" class="form-control" id="searchKeyword"
                       placeholder="Tìm theo tên, email đọc giả..."
                       value="${keyword}">
            </div>

            <!-- Trạng thái -->
            <div class="col-auto">
                <select id="filterStatus" class="form-select form-select-sm" style="min-width:120px;">
                    <option value="">Trạng thái...</option>
                    <option value="pending"  <c:if test="${filterStatus == 'pending'}">selected</c:if>>Pending</option>
                    <option value="approved" <c:if test="${filterStatus == 'approved'}">selected</c:if>>Approved</option>
                    <option value="rejected" <c:if test="${filterStatus == 'rejected'}">selected</c:if>>Rejected</option>
                    </select>
                </div>

                <!-- Từ ngày -->
                <div class="col-auto">
                    <input type="text" class="form-control form-control-sm" id="fromDate"
                           placeholder="Từ ngày dd-MM-yyyy"
                           maxlength="10"
                           style="min-width:155px;"
                           value="${not empty fromDate ? fromDate : ''}">
                <c:if test="${not empty errorFromDate}">
                    <div class="date-error"><i class="fas fa-exclamation-circle"></i> ${errorFromDate}</div>
                </c:if>
            </div>

            <!-- Đến ngày -->
            <div class="col-auto">
                <input type="text" class="form-control form-control-sm" id="toDate"
                       placeholder="Đến ngày dd-MM-yyyy"
                       maxlength="10"
                       style="min-width:155px;"
                       value="${not empty toDate ? toDate : ''}">
                <c:if test="${not empty errorToDate}">
                    <div class="date-error"><i class="fas fa-exclamation-circle"></i> ${errorToDate}</div>
                </c:if>
            </div>

            <!-- Lỗi khoảng ngày -->
            <c:if test="${not empty errorDateRange}">
                <div class="col-12">
                    <div class="date-error"><i class="fas fa-exclamation-circle"></i> ${errorDateRange}</div>
                </div>
            </c:if>

            <!-- Page size -->
            <div class="col-auto">
                <select id="filterPageSize" class="form-select form-select-sm" style="min-width:90px;">
                    <option value="5"   <c:if test="${pageSize == '5'}">selected</c:if>>5/trang</option>
                    <option value="10"  <c:if test="${pageSize == '10'}">selected</c:if>>10/trang</option>
                    <option value="20"  <c:if test="${pageSize == '20'}">selected</c:if>>20/trang</option>
                    <option value="all" <c:if test="${pageSize == 'all'}">selected</c:if>>Tất cả</option>
                    </select>
                </div>

                <!-- Buttons -->
                <div class="col-auto align-self-center">
                    <button type="button" onclick="applyFilters()" class="btn btn-sm btn-dark">
                        <i class="fas fa-filter"></i> Lọc
                    </button>
                    <button type="button" onclick="clearFilters()" class="btn btn-sm btn-outline-secondary">
                        <i class="fas fa-times"></i> Xóa lọc
                    </button>
                </div>
            </div>
        </div>

        <!-- ── Table ── -->
        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                <c:choose>
                    <c:when test="${empty requestList}">
                        <div class="text-center p-5 text-muted">
                            <i class="fas fa-inbox fa-3x mb-3 text-light"></i>
                            <h5>Không có yêu cầu nào</h5>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Đọc giả</th>
                                    <th>Email</th>
                                    <th>Ngày yêu cầu</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="req" items="${requestList}">
                                    <tr>
                                        <td><strong>#${req.requestId}</strong></td>
                                        <td>${not empty req.readerName ? req.readerName : '—'}</td>
                                        <td>${not empty req.readerEmail ? req.readerEmail : '—'}</td>
                                        <td>
                                            <%-- Format LocalDateTime -> dd-MM-yyyy --%>
                                            <c:choose>
                                                <c:when test="${not empty req.requestedAt}">
                                                    ${req.requestedAt.dayOfMonth < 10 ? '0' : ''}${req.requestedAt.dayOfMonth}-${req.requestedAt.monthValue < 10 ? '0' : ''}${req.requestedAt.monthValue}-${req.requestedAt.year}
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="status-badge
                                                  ${req.status == 'pending'  ? 'status-pending'  :
                                                    req.status == 'approved' ? 'status-approved' :
                                                    'status-rejected'}">
                                                      ${req.status}
                                                  </span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/admin/borrow-detail?id=${req.requestId}"
                                                   class="btn btn-sm btn-outline-primary">Chi tiết</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="card-footer bg-white border-0 py-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="small text-muted">
                                Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                            </div>
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
        // Tự động thêm dấu '-' khi nhập ngày
        function autoFormatDate(input) {
            input.addEventListener('input', function () {
                let v = this.value.replace(/[^0-9]/g, '');
                if (v.length >= 3 && v.length <= 4)
                    v = v.slice(0, 2) + '-' + v.slice(2);
                if (v.length >= 5)
                    v = v.slice(0, 2) + '-' + v.slice(2, 4) + '-' + v.slice(4, 8);
                this.value = v;
            });
        }
        autoFormatDate(document.getElementById('fromDate'));
        autoFormatDate(document.getElementById('toDate'));

        // Validate regex dd-MM-yyyy trước khi submit
        const DATE_REGEX = /^(0[1-9]|[12]\d|3[01])-(0[1-9]|1[0-2])-(\d{4})$/;

        function validateDateInput(id, labelName) {
            const val = document.getElementById(id).value.trim();
            if (val === '')
                return true; // không bắt buộc
            if (!DATE_REGEX.test(val)) {
                alert(labelName + ' không hợp lệ.\nĐịnh dạng phải là dd-MM-yyyy (ví dụ: 01-06-2024).');
                document.getElementById(id).focus();
                return false;
            }
            return true;
        }

        function buildBaseUrl() {
            let u = '${pageContext.request.contextPath}/admin/borrow-list?page=1';
            const k = document.getElementById('searchKeyword').value.trim();
            if (k)
                u += '&keyword=' + encodeURIComponent(k);
            const s = document.getElementById('filterStatus').value;
            if (s)
                u += '&status=' + s;
            const p = document.getElementById('filterPageSize').value;
            if (p)
                u += '&pageSize=' + p;
            const fd = document.getElementById('fromDate').value.trim();
            if (fd)
                u += '&fromDate=' + encodeURIComponent(fd);
            const td = document.getElementById('toDate').value.trim();
            if (td)
                u += '&toDate=' + encodeURIComponent(td);
            return u;
        }

        function applyFilters() {
            if (!validateDateInput('fromDate', 'Từ ngày'))
                return;
            if (!validateDateInput('toDate', 'Đến ngày'))
                return;
            window.location.href = buildBaseUrl();
        }

        function clearFilters() {
            window.location.href = '${pageContext.request.contextPath}/admin/borrow-list';
        }

        function goToPage(pg) {
            if (!validateDateInput('fromDate', 'Từ ngày'))
                return;
            if (!validateDateInput('toDate', 'Đến ngày'))
                return;
            const u = buildBaseUrl().replace('page=1', 'page=' + pg);
            window.location.href = u;
        }
    </script>

    <jsp:include page="/includes/footer.jsp" />
