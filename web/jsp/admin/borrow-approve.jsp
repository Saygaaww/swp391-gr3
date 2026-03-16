<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER); %>

<jsp:include page="/includes/header.jsp" />

<main class="container py-5 my-5" style="min-height: 70vh;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight: 700;">
            <i class="fas fa-check-circle" style="color:#4f46e5;"></i> Duyệt yêu cầu mượn sách
        </h2>
        <a href="${pageContext.request.contextPath}/admin/borrow-list" class="btn btn-outline-secondary"><i class="fas fa-list"></i> Lịch sử yêu cầu</a>
    </div>
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none"><i class="fas fa-home"></i> Trang chủ</a></li>
            <li class="breadcrumb-item active">Duyệt yêu cầu mượn</li>
        </ol>
    </nav>

    <p class="mb-4">Có <strong>${totalRequests}</strong> yêu cầu đang chờ duyệt.</p>

    <c:choose>
        <c:when test="${empty pendingRequests}">
            <div class="card shadow-sm border-0">
                <div class="card-body text-center py-5 text-muted">
                    <i class="fas fa-inbox fa-3x mb-3"></i>
                    <h5>Không có yêu cầu nào đang chờ duyệt</h5>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="req" items="${pendingRequests}">
                <div class="card shadow-sm border-0 mb-3">
                    <div class="card-body">
                        <h5 class="card-title">Yêu cầu #${req.requestId}</h5>
                        <p class="card-text mb-1"><strong>Đọc giả:</strong> ${req.readerName != null ? req.readerName : '—'} | <strong>Email:</strong> ${req.readerEmail != null ? req.readerEmail : '—'}</p>
                        <p class="card-text text-muted small mb-3"><strong>Ngày yêu cầu:</strong> ${req.requestedAt}</p>
                        <a href="${pageContext.request.contextPath}/admin/borrow-detail?id=${req.requestId}" class="btn btn-primary btn-sm" style="background:#1a1a2e; border-color:#1a1a2e;"><i class="fas fa-eye"></i> Chi tiết / Duyệt</a>
                        <form action="${pageContext.request.contextPath}/admin/borrow-approve" method="post" style="display:inline;">
                            <input type="hidden" name="requestId" value="${req.requestId}">
                            <input type="hidden" name="action" value="approve">
                            <input type="hidden" name="startDate" value="${req.expectedStartDate}">
                            <input type="hidden" name="endDate" value="${req.expectedReturnDate}">
                            <button type="submit" class="btn btn-success btn-sm" onclick="return confirm('Duyệt yêu cầu #${req.requestId}?');"><i class="fas fa-check"></i> Duyệt</button>
                        </form>
                        <form action="${pageContext.request.contextPath}/admin/borrow-approve" method="post" style="display:inline;">
                            <input type="hidden" name="requestId" value="${req.requestId}">
                            <input type="hidden" name="action" value="reject">
                            <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Từ chối yêu cầu #${req.requestId}?');"><i class="fas fa-times"></i> Từ chối</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/includes/footer.jsp" />
