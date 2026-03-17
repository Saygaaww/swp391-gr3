<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                <h2 class="fw-bold mb-1">Sách đang mượn</h2>
                <p class="text-muted mb-0">Xem hạn trả, trạng thái và gửi yêu cầu trả/gia hạn.</p>
            </div>
            <div class="d-flex gap-2">
                <a class="btn btn-outline-secondary" href="<%=ctx%>/customer/extend-requests">Yêu cầu gia hạn</a>
                <a class="btn btn-outline-primary" href="<%=ctx%>/customer/fines">Tiền phạt</a>
            </div>
        </div>

        <c:if test="${hasUnpaidFines}">
            <div class="alert alert-danger d-flex align-items-center" role="alert">
                <i class="fas fa-exclamation-triangle me-2 fa-lg"></i>
                <div>
                    <strong>Cảnh báo:</strong> Bạn đang có khoản phạt chưa thanh toán (Tổng cộng: <fmt:formatNumber value="${totalUnpaidFines}" type="number" maxFractionDigits="0" /> VNĐ). Vui lòng <a href="<%=ctx%>/customer/fines" class="alert-link">Thanh toán ngay</a> để không bị khóa quyền mượn sách.
                </div>
            </div>
        </c:if>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">${sessionScope.successMessage}</div>
            <% session.removeAttribute("successMessage"); %>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">${sessionScope.errorMessage}</div>
            <% session.removeAttribute("errorMessage"); %>
        </c:if>

        <c:choose>
            <c:when test="${empty items}">
                <div class="alert alert-info">Bạn chưa có sách đang mượn.</div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead>
                        <tr>
                            <th>Sách</th>
                            <th>Copy</th>
                            <th>Hạn trả</th>
                            <th>Trạng thái</th>
                            <th class="text-end">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="it" items="${items}">
                            <tr>
                                <td>
                                    <a href="<%=ctx%>/books/detail/${it.bookId}" class="text-decoration-none">
                                        <strong>${it.bookTitle}</strong>
                                    </a>
                                </td>
                                <td><span class="badge bg-light text-dark">${it.copyCode}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty it.dueDate}">${it.dueDate}</c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="badge bg-${it.status=='borrowed'?'primary':(it.status=='return_requested'?'warning':'secondary')}">
                                        ${it.status}
                                    </span>
                                </td>
                                <td class="text-end">
                                    <form action="<%=ctx%>/customer/auto-return" method="post" class="d-inline"
                                          onsubmit="return confirm('Bạn có chắc muốn trả sách này ngay bây giờ?');">
                                        <input type="hidden" name="borrowItemId" value="${it.borrowItemId}">
                                        <button class="btn btn-outline-primary btn-sm" type="submit">
                                            Trả sách
                                        </button>
                                    </form>

                                    <button class="btn btn-outline-success btn-sm" type="button"
                                            data-bs-toggle="modal" data-bs-target="#extendModal${it.borrowItemId}">
                                        Gia hạn
                                    </button>

                                    <!-- Extend modal -->
                                    <div class="modal fade" id="extendModal${it.borrowItemId}" tabindex="-1"
                                         aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <form action="<%=ctx%>/customer/extend-borrow" method="post">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title">Yêu cầu gia hạn</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                                aria-label="Close"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <input type="hidden" name="borrowItemId" value="${it.borrowItemId}">
                                                        <div class="mb-2"><strong>${it.bookTitle}</strong></div>
                                                        <div class="mb-3">
                                                            <label class="form-label">Gia hạn (ngày)</label>
                                                            <input type="number" name="extendDays" class="form-control" value="7" min="1" max="30">
                                                        </div>
                                                        <div class="mb-3">
                                                            <label class="form-label">Ghi chú (tuỳ chọn)</label>
                                                            <input type="text" name="note" class="form-control" maxlength="500"
                                                                   placeholder="Lý do xin gia hạn...">
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-outline-secondary"
                                                                data-bs-dismiss="modal">Đóng</button>
                                                        <button type="submit" class="btn btn-success">Gửi yêu cầu</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
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
