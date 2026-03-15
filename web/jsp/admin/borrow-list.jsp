<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER); %>

<jsp:include page="/includes/header.jsp" />

<style>
    .stat-card { background: #fff; border-radius: 10px; padding: 20px; border: 1px solid #e5e7eb; box-shadow: 0 1px 6px rgba(0,0,0,0.04); display: flex; align-items: center; gap: 14px; }
    .stat-icon { width: 48px; height: 48px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 20px; }
    .s1 { background: #fef3c7; color: #d97706; }
    .s2 { background: #dcfce7; color: #16a34a; }
    .s3 { background: #fce4ec; color: #e91e63; }
    .s4 { background: #eef2ff; color: #4f46e5; }
    .stat-info h3 { font-size: 24px; font-weight: 800; color: #1a1a2e; margin: 0; }
    .stat-info p { font-size: 13px; color: #6b7280; margin: 0; }
    .filter-bar { background: #fff; padding: 14px 22px; border-radius: 10px; border: 1px solid #e5e7eb; margin-bottom: 20px; }
    .status-badge { padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
    .status-pending { background: #fef3c7; color: #92400e; }
    .status-approved { background: #dcfce7; color: #166534; }
    .status-rejected { background: #fef2f2; color: #991b1b; }
</style>

<main class="container py-5 my-5" style="min-height: 70vh;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight: 700;">
            <i class="fas fa-list" style="color:#4f46e5;"></i> Lịch sử yêu cầu mượn sách
        </h2>
        <a href="${pageContext.request.contextPath}/admin/borrow-approve" class="btn btn-primary" style="background:#1a1a2e; border-color:#1a1a2e;"><i class="fas fa-check-double"></i> Duyệt yêu cầu</a>
    </div>
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none"><i class="fas fa-home"></i> Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/borrow-approve" class="text-decoration-none">Duyệt yêu cầu</a></li>
            <li class="breadcrumb-item active">Lịch sử</li>
        </ol>
    </nav>

    <div class="row mb-4">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s1"><i class="fas fa-clock"></i></div>
                <div class="stat-info">
                    <h3>${countPending}</h3>
                    <p>Chờ duyệt</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s2"><i class="fas fa-check"></i></div>
                <div class="stat-info">
                    <h3>${countApproved}</h3>
                    <p>Đã duyệt</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s3"><i class="fas fa-times"></i></div>
                <div class="stat-info">
                    <h3>${countRejected}</h3>
                    <p>Từ chối</p>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon s4"><i class="fas fa-file-alt"></i></div>
                <div class="stat-info">
                    <h3>${totalRequests}</h3>
                    <p>Tổng yêu cầu</p>
                </div>
            </div>
        </div>
    </div>

    <div class="filter-bar shadow-sm">
        <div class="row g-3 align-items-center">
            <div class="col-auto">
                <a href="${pageContext.request.contextPath}/admin/borrow-list" class="btn btn-outline-secondary"><i class="fas fa-sync-alt"></i> Làm mới</a>
            </div>
            <div class="col-md-4">
                <input type="text" class="form-control" id="searchKeyword" placeholder="Tìm theo tên, email đọc giả..." value="${keyword}">
            </div>
            <div class="col-auto">
                <select id="filterStatus" class="form-select form-select-sm" style="min-width: 120px;">
                    <option value="">Trạng thái...</option>
                    <option value="pending" <c:if test="${filterStatus == 'pending'}">selected</c:if>>Pending</option>
                    <option value="approved" <c:if test="${filterStatus == 'approved'}">selected</c:if>>Approved</option>
                    <option value="rejected" <c:if test="${filterStatus == 'rejected'}">selected</c:if>>Rejected</option>
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
                                        <td>${req.readerName != null ? req.readerName : '—'}</td>
                                        <td>${req.readerEmail != null ? req.readerEmail : '—'}</td>
                                        <td>${req.requestedAt}</td>
                                        <td>
                                            <span class="status-badge ${req.status == 'pending' ? 'status-pending' : (req.status == 'approved' ? 'status-approved' : 'status-rejected')}">${req.status}</span>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/admin/borrow-detail?id=${req.requestId}" class="btn btn-sm btn-outline-primary">Chi tiết</a>
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
                        <div class="small text-muted">Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong></div>
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
        var u = '${pageContext.request.contextPath}/admin/borrow-list?page=1';
        var k = document.getElementById('searchKeyword').value.trim();
        if (k) u += '&keyword=' + encodeURIComponent(k);
        var s = document.getElementById('filterStatus').value;
        if (s) u += '&status=' + s;
        var p = document.getElementById('filterPageSize').value;
        if (p) u += '&pageSize=' + p;
        window.location.href = u;
    }
    function clearFilters() {
        window.location.href = '${pageContext.request.contextPath}/admin/borrow-list';
    }
    function goToPage(pg) {
        var u = '${pageContext.request.contextPath}/admin/borrow-list?page=' + pg;
        var k = document.getElementById('searchKeyword').value.trim();
        if (k) u += '&keyword=' + encodeURIComponent(k);
        var s = document.getElementById('filterStatus').value;
        if (s) u += '&status=' + s;
        var p = document.getElementById('filterPageSize').value;
        if (p) u += '&pageSize=' + p;
        window.location.href = u;
    }
</script>

<jsp:include page="/includes/footer.jsp" />
