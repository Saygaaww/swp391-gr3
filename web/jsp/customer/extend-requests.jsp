<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@include file="/includes/header.jsp" %>
<% String ctx = request.getContextPath(); %>
<%@include file="/includes/navbar.jsp" %>
<style>
    .user-home {
        background: #fff;
        min-height: 100vh;
        color: #333;
    }
</style>
<div class="user-home">
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h2 class="fw-bold mb-1">Yêu cầu gia hạn</h2>
                <p class="text-muted mb-0">Theo dõi kết quả duyệt và hạn trả mới (nếu được duyệt).</p>
            </div>
            <a class="btn btn-outline-primary" href="<%=ctx%>/customer/borrowed-items">Sách đang mượn</a>
        </div>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">${sessionScope.successMessage}</div>
            <% session.removeAttribute("successMessage"); %>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">${sessionScope.errorMessage}</div>
            <% session.removeAttribute("errorMessage"); %>
        </c:if>

        <c:choose>
            <c:when test="${empty extendRequests}">
                <div class="alert alert-info">Bạn chưa có yêu cầu gia hạn nào.</div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                        <tr>
                            <th>Sách</th>
                            <th>Copy</th>
                            <th>Hạn cũ</th>
                            <th>Xin gia hạn tới</th>
                            <th>Hạn mới (nếu duyệt)</th>
                            <th>Trạng thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="e" items="${extendRequests}">
                            <tr>
                                <td>${e.bookTitle}</td>
                                <td><span class="badge bg-light text-dark">${e.copyCode}</span></td>
                                <td>${e.oldDueDate}</td>
                                <td>${e.requestedDueDate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty e.approvedDueDate}">${e.approvedDueDate}</c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="badge bg-${e.status=='approved'?'success':(e.status=='rejected'?'danger':(e.status=='pending'?'warning':'secondary'))}">
                                        ${e.status}
                                    </span>
                                    <c:if test="${not empty e.decisionNote}">
                                        <div class="text-muted small mt-1">${e.decisionNote}</div>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>
