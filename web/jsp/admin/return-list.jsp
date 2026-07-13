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
            <i class="fas fa-undo" style="color:#4f46e5;"></i> Duyệt trả sách
        </h2>
    </div>

    <!-- Feedback messages -->
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

    <div class="return-card">
        <form method="get" action="${pageContext.request.contextPath}/admin/return-list" class="row g-2 align-items-end">
            <div class="col-md-7">
                <label class="form-label mb-1">Từ khóa</label>
                <input type="text" name="keyword" class="form-control"
                       placeholder="Độc giả, email, tên sách, mã bản sao..." value="${keyword}">
            </div>
            <div class="col-md-2">
                <label class="form-label mb-1">Số dòng</label>
                <select name="pageSize" class="form-select">
                    <option value="10" ${pageSize == '10' ? 'selected' : ''}>10</option>
                    <option value="20" ${pageSize == '20' ? 'selected' : ''}>20</option>
                    <option value="50" ${pageSize == '50' ? 'selected' : ''}>50</option>
                </select>
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-dark w-100"><i class="fas fa-filter"></i> Lọc</button>
                <a href="${pageContext.request.contextPath}/admin/return-list" class="btn btn-outline-secondary w-100">Xóa lọc</a>
            </div>
        </form>
    </div>

    <!-- Table of Return Requests -->
    <div class="return-card">
        <div class="table-responsive">
            <c:choose>
                <c:when test="${empty returnRequests}">
                    <div class="text-center p-5 text-muted">
                        <i class="fas fa-inbox fa-3x mb-3 text-light"></i>
                        <h5>Không có yêu cầu trả sách nào</h5>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Độc giả</th>
                                <th>Sách</th>
                                <th>Mã bản sao</th>
                                <th>Ngày trả dự kiến</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="req" items="${returnRequests}">
                                <tr>
                                    <td><strong>${req.borrowItemId}</strong></td>
                                    <td>
                                        <strong>${req.readerName}</strong><br/>
                                        <small class="text-muted">${req.readerEmail}</small>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <c:if test="${not empty req.bookCoverUrl}">
                                                <img src="${req.bookCoverUrl}" alt="cover"
                                                     style="width:40px;height:55px;object-fit:cover;border-radius:4px;border:1px solid #ddd;">
                                            </c:if>
                                            <div class="text-truncate" style="max-width:200px;" title="${req.bookTitle}">
                                                ${req.bookTitle}
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge bg-secondary">${req.copyCode}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty req.dueDate}">
                                                <span class="text-danger fw-bold">
                                                    ${req.dueDate.dayOfMonth < 10 ? '0' : ''}${req.dueDate.dayOfMonth}-${req.dueDate.monthValue < 10 ? '0' : ''}${req.dueDate.monthValue}-${req.dueDate.year}
                                                </span>
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a class="btn btn-sm btn-primary"
                                           href="${pageContext.request.contextPath}/admin/borrow/return/${req.borrowItemId}">
                                            <i class="fas fa-clipboard-check"></i> Xử lý trả sách
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>

        <c:if test="${not empty returnRequests}">
            <div class="d-flex justify-content-between align-items-center mt-3">
                <small class="text-muted">Tổng: ${totalItems} bản ghi</small>

                <c:if test="${totalPages > 1}">
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/return-list?page=${currentPage - 1}&keyword=${keyword}&pageSize=${pageSize}">«</a>
                        </li>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/return-list?page=${i}&keyword=${keyword}&pageSize=${pageSize}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/admin/return-list?page=${currentPage + 1}&keyword=${keyword}&pageSize=${pageSize}">»</a>
                        </li>
                    </ul>
                </c:if>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="/includes/admin-shell-end.jsp" />
<jsp:include page="/includes/footer.jsp" />

