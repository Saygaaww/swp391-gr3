<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/admin-shell-start.jsp" />

<style>
    .return-card {
        background: #fff;
        border-radius: 10px;
        padding: 20px;
        border: 1px solid #e5e7eb;
        box-shadow: 0 1px 6px rgba(0,0,0,0.04);
        margin-bottom: 20px;
    }
</style>

<div class="container-fluid px-0">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight: 700;">
            <i class="fas fa-file-invoice-dollar" style="color:#ef4444;"></i> Quản lý Tiền phạt
        </h2>
    </div>

    <div class="return-card">
        <form method="get" action="${pageContext.request.contextPath}/admin/fines" class="row g-2 align-items-end">
            <div class="col-md-5">
                <label class="form-label mb-1">Từ khóa</label>
                <input type="text" name="keyword" class="form-control"
                       placeholder="Tên độc giả, email, tên sách..." value="${keyword}">
            </div>
            <div class="col-md-3">
                <label class="form-label mb-1">Trạng thái</label>
                <select name="status" class="form-select">
                    <option value="" ${empty status ? 'selected' : ''}>Tất cả</option>
                    <option value="unpaid" ${status == 'unpaid' ? 'selected' : ''}>unpaid</option>
                    <option value="paid" ${status == 'paid' ? 'selected' : ''}>paid</option>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label mb-1">Số dòng</label>
                <select name="pageSize" class="form-select">
                    <option value="10" ${pageSize == '10' ? 'selected' : ''}>10</option>
                    <option value="20" ${pageSize == '20' ? 'selected' : ''}>20</option>
                    <option value="50" ${pageSize == '50' ? 'selected' : ''}>50</option>
                </select>
            </div>
            <div class="col-md-2 d-flex gap-2">
                <button type="submit" class="btn btn-dark w-100"><i class="fas fa-search"></i> Lọc</button>
                <a href="${pageContext.request.contextPath}/admin/fines" class="btn btn-outline-secondary w-100">Xóa</a>
            </div>
        </form>
    </div>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i> ${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Table of Fines -->
    <div class="return-card">
        <div class="table-responsive">
            <c:choose>
                <c:when test="${empty fines}">
                    <div class="text-center p-5 text-muted">
                        <i class="fas fa-inbox fa-3x mb-3 text-light"></i>
                        <h5>Không có dữ liệu tiền phạt</h5>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Độc giả</th>
                                <th>Tên sách</th>
                                <th>Mã copy</th>
                                <th>Loại phạt</th>
                                <th>Mô tả</th>
                                <th class="text-end">Số tiền</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Ngày trả</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="f" items="${fines}">
                                <tr>
                                    <td><strong>${f.fineId}</strong></td>
                                    <td>
                                        <strong>${f.readerName}</strong><br/>
                                        <small class="text-muted">${f.readerEmail}</small>
                                    </td>
                                    <td>${f.bookTitle}</td>
                                    <td><span class="badge bg-secondary">${f.copyCode}</span></td>
                                    <td>${f.fineTypeName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty f.reason}">${f.reason}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end fw-bold text-danger">
                                        <fmt:formatNumber value="${f.amount}" type="number" maxFractionDigits="0" /> VNĐ
                                    </td>
                                    <td>
                                        <span class="badge 
                                        ${(f.status == 'unpaid' || f.status == 'UNPAID') ? 'bg-warning text-dark' : 'bg-success'}">
                                            ${(f.status == 'unpaid' || f.status == 'UNPAID') ? 'UNPAID' : 'PAID'}
                                        </span>
                                    </td>
                                    <td>
                                        <c:if test="${not empty f.createdAt}">
                                            ${f.createdAt.dayOfMonth < 10 ? '0' : ''}${f.createdAt.dayOfMonth}-${f.createdAt.monthValue < 10 ? '0' : ''}${f.createdAt.monthValue}-${f.createdAt.year}
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${not empty f.paidAt}">
                                            ${f.paidAt.dayOfMonth < 10 ? '0' : ''}${f.paidAt.dayOfMonth}-${f.paidAt.monthValue < 10 ? '0' : ''}${f.paidAt.monthValue}-${f.paidAt.year}
                                        </c:if>
                                        <c:if test="${empty f.paidAt}">
                                            —
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:if test="${f.status == 'unpaid' || f.status == 'UNPAID'}">
                                            <form method="post" action="${pageContext.request.contextPath}/admin/fines" class="d-inline">
                                                <input type="hidden" name="action" value="mark_paid">
                                                <input type="hidden" name="fineId" value="${f.fineId}">
                                                <button type="submit" class="btn btn-sm btn-outline-success"
                                                        onclick="return confirm('Xác nhận đánh dấu khoản phạt này đã thanh toán?');">
                                                    Mark Paid
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${f.status != 'unpaid' && f.status != 'UNPAID'}">
                                            <span class="text-muted">View</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${not empty fines}">
            <div class="d-flex justify-content-between align-items-center mt-3">
                <small class="text-muted">Tổng: ${totalItems} bản ghi</small>

                <c:if test="${totalPages > 1}">
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/fines?page=${currentPage - 1}&keyword=${keyword}&status=${status}&pageSize=${pageSize}">«</a>
                        </li>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/fines?page=${i}&keyword=${keyword}&status=${status}&pageSize=${pageSize}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/fines?page=${currentPage + 1}&keyword=${keyword}&status=${status}&pageSize=${pageSize}">»</a>
                        </li>
                    </ul>
                </c:if>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="/includes/admin-shell-end.jsp" />
<jsp:include page="/includes/footer.jsp" />

