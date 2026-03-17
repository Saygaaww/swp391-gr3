<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="/includes/header.jsp" />

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

<main class="container py-5 my-5" style="min-height: 70vh;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight: 700;">
            <i class="fas fa-file-invoice-dollar" style="color:#ef4444;"></i> Quản lý Tiền phạt
        </h2>
    </div>

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
                                <th class="text-end">Số tiền</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Ngày trả</th>
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
                                    <td class="text-end fw-bold text-danger">
                                        <fmt:formatNumber value="${f.amount}" type="number" maxFractionDigits="0" /> VNĐ
                                    </td>
                                    <td>
                                        <span class="badge 
                                        ${f.status == 'unpaid' ? 'bg-warning text-dark' : 'bg-success'}">
                                            ${f.status}
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
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
