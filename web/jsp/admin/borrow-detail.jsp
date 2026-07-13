<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER); %>

<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/admin-shell-start.jsp" />

<style>
    .status-badge { padding: 4px 10px; border-radius: 4px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
</style>

<div class="container-fluid px-0">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none"><i class="fas fa-home"></i> Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/borrow-list" class="text-decoration-none">Yêu cầu mượn</a></li>
            <li class="breadcrumb-item active">#${borrowRequest.requestId}</li>
        </ol>
    </nav>
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${errorMessage}</div>
    </c:if>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight: 700;">
            <i class="fas fa-file-alt" style="color:#4f46e5;"></i> Chi tiết yêu cầu mượn #${borrowRequest.requestId}
        </h2>
        <span class="badge ${borrowRequest.status == 'pending' ? 'bg-warning' : (borrowRequest.status == 'approved' ? 'bg-success' : 'bg-danger')}">${borrowRequest.status}</span>
    </div>

    <div class="card shadow-sm border-0 mb-3">
        <div class="card-header bg-white"><strong>Thông tin đọc giả</strong></div>
        <div class="card-body">
            <p class="mb-1"><strong>Họ tên:</strong> ${borrowRequest.readerName != null ? borrowRequest.readerName : '—'}</p>
            <p class="mb-1"><strong>Email:</strong> ${borrowRequest.readerEmail != null ? borrowRequest.readerEmail : '—'}</p>
            <p class="mb-1"><strong>Số điện thoại:</strong> ${borrowRequest.readerPhone != null ? borrowRequest.readerPhone : '—'}</p>
            <p class="mb-1"><strong>Ngày yêu cầu:</strong> ${borrowRequest.requestedAt}</p>
            <p class="mb-1"><strong>Ngày bắt đầu (Dự kiến):</strong> <span class="badge bg-secondary">${borrowRequest.expectedStartDate != null ? borrowRequest.expectedStartDate : '—'}</span></p>
            <p class="mb-1"><strong>Ngày trả (Dự kiến):</strong> <span class="badge bg-secondary">${borrowRequest.expectedReturnDate != null ? borrowRequest.expectedReturnDate : '—'}</span></p>
            <p class="mb-1"><strong>Ghi chú:</strong> ${borrowRequest.note != null ? borrowRequest.note : '—'}</p>
            <c:if test="${borrowRequest.processedAt != null}">
                <p class="mb-1"><strong>Xử lý lúc:</strong> ${borrowRequest.processedAt}</p>
                <p class="mb-1"><strong>Người xử lý:</strong> ${borrowRequest.employeeName != null ? borrowRequest.employeeName : '—'}</p>
                <p class="mb-0"><strong>Ghi chú quyết định:</strong> ${borrowRequest.decisionNote != null ? borrowRequest.decisionNote : '—'}</p>
            </c:if>
        </div>
    </div>

    <div class="card shadow-sm border-0 mb-3">
        <div class="card-header bg-white"><strong>Sách yêu cầu mượn</strong></div>
        <div class="card-body p-0">
            <ul class="list-group list-group-flush">
                <c:choose>
                    <c:when test="${empty borrowRequest.items}">
                        <li class="list-group-item">Không có đầu mục nào.</li>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${borrowRequest.items}">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <strong>${item.bookTitle != null ? item.bookTitle : 'Book #'.concat(item.bookId)}</strong>
                                <span class="badge bg-primary">x ${item.quantity}</span>
                            </li>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>

    <c:if test="${borrowRequest.status == 'pending'}">
        <div class="card shadow-sm border-0 mb-3">
            <div class="card-header bg-white"><strong>Duyệt / Từ chối</strong></div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/borrow-detail" method="post" class="mb-3">
                    <input type="hidden" name="requestId" value="${borrowRequest.requestId}">
                    <input type="hidden" name="action" value="approve">
                    <div class="row g-2 mb-2">
                        <div class="col-md-6">
                            <label class="form-label">Ngày mượn (Xác nhận) <span class="text-danger">*</span></label>
                            <input type="date" name="startDate" id="startDate" class="form-control" value="${borrowRequest.expectedStartDate}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Ngày trả (Xác nhận) <span class="text-danger">*</span></label>
                            <input type="date" name="endDate" id="endDate" class="form-control" value="${borrowRequest.expectedReturnDate}" required>
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label">Ghi chú (tối đa 500 ký tự)</label>
                        <textarea name="note" class="form-control" maxlength="500" rows="2" placeholder="Ghi chú khi duyệt..."></textarea>
                    </div>
                    <button type="submit" class="btn btn-success" onclick="return confirm('Duyệt yêu cầu này?');"><i class="fas fa-check"></i> Duyệt</button>
                </form>
                <form action="${pageContext.request.contextPath}/admin/borrow-detail" method="post">
                    <input type="hidden" name="requestId" value="${borrowRequest.requestId}">
                    <input type="hidden" name="action" value="reject">
                    <div class="mb-2">
                        <label class="form-label">Lý do từ chối (tối đa 500 ký tự)</label>
                        <textarea name="note" class="form-control" maxlength="500" rows="2" placeholder="Lý do từ chối..."></textarea>
                    </div>
                    <button type="submit" class="btn btn-danger" onclick="return confirm('Từ chối yêu cầu này?');"><i class="fas fa-times"></i> Từ chối</button>
                </form>
            </div>
        </div>
    </c:if>

    <a href="${pageContext.request.contextPath}/admin/borrow-list" class="btn btn-outline-secondary"><i class="fas fa-arrow-left"></i> Về danh sách</a>
</div>

<jsp:include page="/includes/admin-shell-end.jsp" />
<jsp:include page="/includes/footer.jsp" />

