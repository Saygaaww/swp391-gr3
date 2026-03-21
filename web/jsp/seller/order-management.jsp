<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h2 class="mb-1">Quản lý Order COD</h2>
            <div class="text-muted">Seller chỉ xem đơn có sách do mình tạo và thanh toán COD</div>
        </div>
        <a href="${pageContext.request.contextPath}/books/dashboard" class="btn btn-outline-secondary">Về dashboard</a>
    </div>

    <c:if test="${not empty sellerOrderMessage}">
        <div class="alert alert-success">${sellerOrderMessage}</div>
    </c:if>
    <c:if test="${not empty sellerOrderError}">
        <div class="alert alert-danger">${sellerOrderError}</div>
    </c:if>

    <div class="card mb-3">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/seller/order-management" class="row g-2 align-items-end">
                <div class="col-md-3">
                    <label class="form-label">Trạng thái đơn</label>
                    <select name="status" class="form-select">
                        <option value="all" ${empty selectedStatus ? 'selected' : ''}>Tất cả</option>
                        <option value="pending" ${selectedStatus == 'pending' ? 'selected' : ''}>Pending</option>
                        <option value="paid" ${selectedStatus == 'paid' ? 'selected' : ''}>Paid</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Từ ngày</label>
                    <input type="date" name="fromDate" value="${fromDate}" class="form-control" />
                </div>
                <div class="col-md-3">
                    <label class="form-label">Đến ngày</label>
                    <input type="date" name="toDate" value="${toDate}" class="form-control" />
                </div>
                <div class="col-md-3 d-grid">
                    <button type="submit" class="btn btn-dark">Lọc dữ liệu</button>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>Mã đơn</th>
                        <th>Độc giả</th>
                        <th>Ngày tạo</th>
                        <th>Tổng tiền đơn</th>
                        <th>Order Status</th>
                        <th>Payment Status</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty orders}">
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">Không có đơn COD phù hợp.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="order" items="${orders}">
                                <c:set var="payment" value="${paymentMap[order.orderId]}" />
                                <tr>
                                    <td><strong>#${order.orderId}</strong></td>
                                    <td>
                                        <div>${order.readerName}</div>
                                        <small class="text-muted">${order.readerEmail}</small>
                                    </td>
                                    <td>${order.createdAt}</td>
                                    <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" /></td>
                                    <td>
                                        <span class="badge bg-${order.status == 'paid' ? 'success' : order.status == 'pending' ? 'warning text-dark' : 'secondary'}">
                                            ${order.status}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge bg-${payment.paymentStatus == 'success' ? 'success' : payment.paymentStatus == 'pending' ? 'warning text-dark' : 'secondary'}">
                                            ${payment.paymentStatus}
                                        </span>
                                    </td>
                                    <td>
                                        <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/seller/order-management?view=details&orderId=${order.orderId}">
                                            Chi tiết
                                        </a>
                                        <c:if test="${payment.paymentStatus == 'pending'}">
                                            <form action="${pageContext.request.contextPath}/seller/order-management" method="post" class="d-inline"
                                                  onsubmit="return confirm('Xác nhận đã nhận tiền COD cho đơn này?');">
                                                <input type="hidden" name="action" value="confirm-cod" />
                                                <input type="hidden" name="orderId" value="${order.orderId}" />
                                                <button type="submit" class="btn btn-sm btn-success">Xác nhận COD</button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
