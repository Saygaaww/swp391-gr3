<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/includes/header.jsp" %>
<% String ctx = request.getContextPath();%>
<%@include file="/includes/navbar.jsp" %>

<div class="user-home" style="min-height: calc(100vh - 130px);">
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h2 class="fw-bold mb-1">Tiền phạt</h2>
                <p class="text-muted mb-0">Danh sách tiền phạt gắn với các lượt mượn.</p>
            </div>
            <a class="btn btn-outline-primary" href="<%=ctx%>/customer/borrowed-items">Sách đang mượn</a>
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
            <c:when test="${empty fines}">
                <div class="alert alert-info">Bạn chưa có tiền phạt.</div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Sách</th>
                                <th>Copy</th>
                                <th>Loại phạt</th>
                                <th class="text-end">Số tiền</th>
                                <th>Trạng thái</th>
                                <th class="text-end">Thanh toán</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="f" items="${fines}">
                                <tr>
                                    <td><strong>${f.fineId}</strong></td>
                                    <td>${f.bookTitle}</td>
                                    <td><span class="badge bg-light text-dark">${f.copyCode}</span></td>
                                    <td>${f.fineTypeName}</td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${f.amount}" type="number" maxFractionDigits="0" /> VNĐ
                                    </td>
                                    <td>
                                        <span class="badge bg-${f.status=='paid'?'success':'warning'}">
                                            ${f.status}
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <c:if test="${f.status != 'paid'}">
                                            <form method="post" action="<%=ctx%>/customer/fines/pay" class="d-inline"
                                                  onsubmit="return confirm('Xác nhận đã thanh toán tiền phạt này?');">
                                                <input type="hidden" name="fineId" value="${f.fineId}">
                                                <button class="btn btn-primary btn-sm" type="submit">Đã thanh toán</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${f.status == 'paid'}">
                                            <span class="text-muted small">Đã trả</span>
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
