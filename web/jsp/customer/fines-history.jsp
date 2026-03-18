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
                <h2 class="fw-bold mb-1">Lịch sử trả tiền mượn sách</h2>
                <p class="text-muted mb-0">Các khoản phạt đã thanh toán liên quan đến mượn/trả sách.</p>
            </div>
            <div class="d-flex gap-2">
                <a class="btn btn-outline-primary" href="<%=ctx%>/customer/fines">Quay lại tiền phạt</a>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty paidFines}">
                <div class="alert alert-info">Bạn chưa có lịch sử thanh toán khoản phạt nào.</div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Sách</th>
                                <th>Loại vi phạm</th>
                                <th>Lý do</th>
                                <th class="text-end">Số tiền</th>
                                <th>Thời gian thanh toán</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="f" items="${paidFines}">
                                <tr>
                                    <td><strong>${f.fineId}</strong></td>
                                    <td>${f.bookTitle}</td>
                                    <td>${f.fineTypeName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty f.reason}">${f.reason}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${f.amount}" type="number" maxFractionDigits="0" /> VNĐ
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty f.paidAt}">
                                                ${f.paidAt.dayOfMonth < 10 ? '0' : ''}${f.paidAt.dayOfMonth}-${f.paidAt.monthValue < 10 ? '0' : ''}${f.paidAt.monthValue}-${f.paidAt.year}
                                                ${f.paidAt.hour < 10 ? '0' : ''}${f.paidAt.hour}:${f.paidAt.minute < 10 ? '0' : ''}${f.paidAt.minute}
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><span class="badge bg-success">PAID</span></td>
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
