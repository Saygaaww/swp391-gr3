<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
                                <th>Đọc giả</th>
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
    </div>
</div>

<jsp:include page="/includes/admin-shell-end.jsp" />
<jsp:include page="/includes/footer.jsp" />
