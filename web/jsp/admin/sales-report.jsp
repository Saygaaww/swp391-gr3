<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER);%>

<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/admin-shell-start.jsp" />

<div class="container-fluid px-0">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight: 700;">
            <i class="fas fa-file-invoice-dollar" style="color:#4f46e5;"></i> Sales Report
        </h2>
    </div>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="text-center p-5 text-muted">
                            <i class="fas fa-inbox fa-3x mb-3 text-light"></i>
                            <h5>No orders found</h5>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Order ID</th>
                                    <th>Reader</th>
                                    <th>Date</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Payment Status</th>
                                    <th>Items</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td><strong>#${order.orderId}</strong></td>
                                        <td>${order.readerName}<br><small class="text-muted">${order.readerEmail}</small></td>
                                        <td>
                                            ${order.createdAt}
                                        </td>
                                        <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="$ " /></td>
                                        <td>
                                            <span class="badge bg-${order.status == 'paid' ? 'success' : order.status == 'cancelled' ? 'danger' : order.status == 'refunded' ? 'warning' : 'secondary'}">
                                                ${order.status}
                                            </span>
                                        </td>
                                        <td>
                                            <c:set var="payment" value="${paymentMap[order.orderId]}" />
                                            <c:if test="${not empty payment}">
                                                ${payment.paymentMethod} - <span class="badge bg-${payment.paymentStatus == 'success' ? 'success' : 'secondary'}">${payment.paymentStatus}</span>
                                            </c:if>
                                            <c:if test="${empty payment}">
                                                <span class="text-muted">N/A</span>
                                            </c:if>
                                        </td>
                                        <td>
                                            <ul class="mb-0 ps-3">
                                                <c:forEach var="item" items="${order.orderBooks}">
                                                    <li>${item.bookTitle} (x${item.quantity})</li>
                                                    </c:forEach>
                                            </ul>
                                        </td>
                                        <td>
                                            <c:if test="${order.status != 'cancelled' && order.status != 'refunded' && order.status != 'paid'}">
                                                <form action="${pageContext.request.contextPath}/admin/sales-report" method="POST" style="display:inline;" onsubmit="return confirm('Hủy đơn hàng này? Bạn có chắc chắn?');">
                                                    <input type="hidden" name="orderId" value="${order.orderId}">
                                                    <input type="hidden" name="action" value="cancel">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger" title="Cancel Order"><i class="fas fa-times"></i> Hủy</button>
                                                </form>
                                            </c:if>
                                            <c:if test="${order.status == 'paid' || order.status == 'delivered'}">
                                                <form action="${pageContext.request.contextPath}/admin/sales-report" method="POST" style="display:inline;" onsubmit="return confirm('Bạn có chắc chắn hoàn tiền cho đơn hàng này?');">
                                                    <input type="hidden" name="orderId" value="${order.orderId}">
                                                    <input type="hidden" name="action" value="refund">
                                                    <button type="submit" class="btn btn-sm btn-outline-warning" title="Refund Order"><i class="fas fa-undo"></i> Hoàn tiền</button>
                                                </form>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/admin-shell-end.jsp" />
<jsp:include page="/includes/footer.jsp" />
