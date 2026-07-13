<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@include file="/includes/header.jsp" %>
<% String ctx = request.getContextPath();%>
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
                <h2 class="fw-bold mb-1">Đặt Sách (Reservation)</h2>
                <p class="text-muted mb-0">Theo dõi trạng thái hàng đợi và thời hạn hết hiệu lực.</p>
            </div>
            <a class="btn btn-outline-primary" href="<%=ctx%>/books">Tìm sách</a>
        </div>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">${sessionScope.successMessage}</div>
            <% session.removeAttribute("successMessage"); %>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">${sessionScope.errorMessage}</div>
            <% session.removeAttribute("errorMessage");%>
        </c:if>

        <c:choose>
            <c:when test="${empty reservations}">
                <div class="alert alert-info">Bạn chưa có đặt chỗ nào.</div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>Sách</th>
                                <th>Trạng thái</th>
                                <th>Thời điểm xếp hàng</th>
                                <th>Hết hạn</th>
                                <th class="text-end">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="r" items="${reservations}">
                                <c:set var="st" value="${fn:toUpperCase(r.status)}" />
                                <tr>
                                    <td>
                                        <a href="<%=ctx%>/books/detail/${r.bookId}" class="text-decoration-none">
                                            <strong>${r.bookTitle}</strong>
                                        </a>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${st == 'ACTIVE' && empty r.expiresAt}">
                                                <span class="badge bg-warning text-dark">Waiting</span>
                                            </c:when>
                                            <c:when test="${st == 'ACTIVE' && not empty r.expiresAt}">
                                                <span class="badge bg-success">Ready</span>
                                            </c:when>
                                            <c:when test="${st == 'FULFILLED'}">
                                                <span class="badge bg-primary">Fulfilled</span>
                                            </c:when>
                                            <c:when test="${st == 'CANCELLED'}">
                                                <span class="badge bg-secondary">Cancelled</span>
                                            </c:when>
                                            <c:when test="${st == 'EXPIRED'}">
                                                <span class="badge bg-dark">Expired</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${r.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${r.queuedAt}</td>
                                    <td>${r.expiresAt}</td>
                                    <td class="text-end">
                                        <c:if test="${st == 'ACTIVE' && not empty r.expiresAt}">
                                            <a href="<%=ctx%>/customer/borrow-request?bookId=${r.bookId}" class="btn btn-outline-success btn-sm">
                                                Mượn ngay
                                            </a>
                                        </c:if>
                                        <c:if test="${st == 'ACTIVE'}">
                                            <form method="post" action="<%=ctx%>/customer/reservations" class="d-inline"
                                                  onsubmit="return confirm('Hủy đặt chỗ này?');">
                                                <input type="hidden" name="action" value="cancel">
                                                <input type="hidden" name="reservationId" value="${r.reservationId}">
                                                <button class="btn btn-outline-danger btn-sm" type="submit">Hủy</button>
                                            </form>
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
