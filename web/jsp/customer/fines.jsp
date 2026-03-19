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
            <div class="d-flex gap-2">
                <a class="btn btn-outline-secondary" href="<%=ctx%>/customer/fines-history">Lịch sử thanh toán</a>
                <a class="btn btn-outline-primary" href="<%=ctx%>/customer/borrowed-items">Sách đang mượn</a>
            </div>
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
                <c:set var="unpaidTotal" value="0" />
                <c:set var="unpaidCount" value="0" />
                <c:forEach var="f0" items="${fines}">
                    <c:if test="${f0.status != 'paid'}">
                        <c:set var="unpaidTotal" value="${unpaidTotal + f0.amount}" />
                        <c:set var="unpaidCount" value="${unpaidCount + 1}" />
                    </c:if>
                </c:forEach>

                <c:if test="${unpaidCount > 0}">
                    <div class="alert alert-warning d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-2">
                        <div>
                            <strong>Bạn có ${unpaidCount} khoản phạt cần thanh toán.</strong>
                            <div class="small text-muted">
                                Tổng tiền phạt:
                                <strong>
                                    <fmt:formatNumber value="${unpaidTotal}" type="number" maxFractionDigits="0" /> VNĐ
                                </strong>
                            </div>
                        </div>
                        <form method="post" action="<%=ctx%>/customer/fines/pay-all"
                              onsubmit="return confirm('Xác nhận thanh toán tất cả các khoản phạt chưa trả?');">
                            <button class="btn btn-danger" type="submit">Thanh toán tất cả</button>
                        </form>
                    </div>
                </c:if>

                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Sách</th>
                                <th>Lý do</th>
                                <th class="text-end">Tiền (Amount)</th>
                                <th>Trạng thái</th>
                                <th class="text-end">Hành vi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="f" items="${fines}">
                                <tr>
                                    <td><strong>${f.fineId}</strong></td>
                                    <td>${f.bookTitle}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty f.reason}">
                                                ${f.reason}
                                            </c:when>
                                            <c:otherwise>${f.fineTypeName}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${f.amount}" type="number" maxFractionDigits="0" /> VNĐ
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${f.status == 'paid'}">
                                                <span class="badge bg-success">PAID</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">UNPAID</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-end">
                                        <c:if test="${f.status != 'paid'}">
                                            <form method="post" action="<%=ctx%>/customer/fines/pay" class="d-inline"
                                                  onsubmit="return confirm('Xác nhận đã thanh toán tiền phạt này?');">
                                                <input type="hidden" name="fineId" value="${f.fineId}">
                                                <input type="hidden" name="paymentMethod" value="cash">
                                                <button class="btn btn-outline-secondary btn-sm" type="submit">Tiền mặt</button>
                                            </form>
                                            <form method="post" action="<%=ctx%>/customer/fines/pay" class="d-inline ms-1"
                                                  onsubmit="return confirm('Xác nhận đã thanh toán tiền phạt này?');">
                                                <input type="hidden" name="fineId" value="${f.fineId}">
                                                <input type="hidden" name="paymentMethod" value="bank_transfer">
                                                <button class="btn btn-primary btn-sm" type="submit">Chuyển khoản</button>
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
