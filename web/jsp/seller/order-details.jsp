<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="mb-0">Chi tiết đơn #${order.orderId}</h2>
        <a href="${pageContext.request.contextPath}/seller/order-management" class="btn btn-outline-secondary">Quay lại</a>
    </div>

    <c:if test="${not empty sellerOrderError}">
        <div class="alert alert-danger">${sellerOrderError}</div>
    </c:if>

    <div class="row g-3 mb-3">
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-header">Thông tin đơn</div>
                <div class="card-body">
                    <div><strong>Độc giả:</strong> ${order.readerName} (${order.readerEmail})</div>
                    <div><strong>Ngày tạo:</strong> ${order.createdAt}</div>
                    <div><strong>Order status:</strong> ${order.status}</div>
                    <div><strong>Tổng tiền:</strong> <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" /></div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-header">Thông tin thanh toán</div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty payment}">
                            <div class="text-muted">Không có bản ghi thanh toán.</div>
                        </c:when>
                        <c:otherwise>
                            <div><strong>Phương thức:</strong> ${payment.paymentMethod}</div>
                            <div><strong>Trạng thái:</strong> ${payment.paymentStatus}</div>
                            <div><strong>Mã giao dịch:</strong> ${empty payment.transactionCode ? 'N/A' : payment.transactionCode}</div>
                            <c:if test="${payment.paymentMethod == 'COD' and payment.paymentStatus == 'pending'}">
                                <form action="${pageContext.request.contextPath}/seller/order-management" method="post" class="mt-3"
                                      onsubmit="return confirm('Xác nhận đã nhận tiền COD cho đơn này?');">
                                    <input type="hidden" name="action" value="confirm-cod" />
                                    <input type="hidden" name="orderId" value="${order.orderId}" />
                                    <button type="submit" class="btn btn-success">Xác nhận COD</button>
                                </form>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header">Sách của bạn trong đơn hàng này</div>
        <div class="table-responsive">
            <table class="table table-striped mb-0">
                <thead>
                    <tr>
                        <th>Tên sách</th>
                        <th>Tác giả</th>
                        <th class="text-end">Đơn giá</th>
                        <th class="text-center">SL</th>
                        <th class="text-end">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${order.orderBooks}">
                        <tr>
                            <td>${item.bookTitle}</td>
                            <td>${item.authorName}</td>
                            <td class="text-end"><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" /></td>
                            <td class="text-center">${item.quantity}</td>
                            <td class="text-end"><fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="₫" /></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty order.orderBooks}">
                        <tr>
                            <td colspan="5" class="text-center text-muted">Không có sản phẩm thuộc seller trong đơn này.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
