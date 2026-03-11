<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Detail - Seller</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f0f0f0; color: #333; }
        .sidebar-panel { min-height: 100vh; background: #fff; border-right: 1px solid #e0e0e0; }
        .sidebar-panel a { color: #333; padding: 12px 20px; display: block; text-decoration: none; }
        .sidebar-panel a:hover, .sidebar-panel a.active { background: #e8e8e8; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-2 sidebar-panel p-0">
                <div class="p-4">
                    <h4 class="text-dark mb-4"><i class="fas fa-store"></i> Seller Panel</h4>
                </div>
                <nav>
                    <a href="<%= request.getContextPath() %>/home"><i class="fas fa-home"></i> Home</a>
                    <a href="<%= request.getContextPath() %>/seller/dashboard"><i class="fas fa-dashboard"></i> Dashboard</a>
                    <a href="<%= request.getContextPath() %>/seller/books"><i class="fas fa-book"></i> Books</a>
                    <a href="<%= request.getContextPath() %>/seller/orders" class="active"><i class="fas fa-shopping-cart"></i> Orders</a>
                    <a href="<%= request.getContextPath() %>/seller/sales-report"><i class="fas fa-chart-line"></i> Sales Report</a>
                    <a href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </nav>
            </div>

            <div class="col-md-10 p-4">
                <c:if test="${empty order}">
                    <p class="text-muted">Order not found.</p>
                    <a href="<%= request.getContextPath() %>/seller/orders" class="btn btn-dark">&larr; Back to Orders</a>
                </c:if>

                <c:if test="${not empty order}">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2><i class="fas fa-receipt"></i> Order #${order.orderId}</h2>
                        <a href="<%= request.getContextPath() %>/seller/orders" class="btn btn-outline-dark">&larr; Back to Orders</a>
                    </div>

                    <!-- Order Info -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="card border border-secondary border-opacity-25 h-100">
                                <div class="card-header bg-white"><strong>Order Information</strong></div>
                                <div class="card-body">
                                    <p class="mb-1"><strong>Order ID:</strong> #${order.orderId}</p>
                                    <p class="mb-1"><strong>Date:</strong> ${order.createdAt}</p>
                                    <p class="mb-1"><strong>Status:</strong>
                                        <span class="badge
                                            ${order.status == 'pending' ? 'bg-warning' : ''}
                                            ${order.status == 'paid' ? 'bg-success' : ''}
                                            ${order.status == 'cancelled' ? 'bg-danger' : ''}
                                            ${order.status == 'refunded' ? 'bg-info' : ''}">
                                            ${order.status}
                                        </span>
                                    </p>
                                    <p class="mb-0"><strong>Total:</strong> <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0" minFractionDigits="0"/> (${order.currency})</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card border border-secondary border-opacity-25 h-100">
                                <div class="card-header bg-white"><strong>Customer</strong></div>
                                <div class="card-body">
                                    <p class="mb-1"><strong>Name:</strong> ${order.readerName}</p>
                                    <p class="mb-0"><strong>Email:</strong> ${order.readerEmail}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Items -->
                    <div class="card border border-secondary border-opacity-25 mb-4">
                        <div class="card-header bg-white"><strong>Items</strong></div>
                        <div class="card-body p-0">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Book</th>
                                        <th class="text-center">Qty</th>
                                        <th class="text-end">Unit Price</th>
                                        <th class="text-end">Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${order.orderBooks}" var="ob">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <c:if test="${not empty ob.bookCoverUrl}">
                                                        <img src="${ob.bookCoverUrl}" class="rounded me-2" style="width:40px;height:55px;object-fit:cover;">
                                                    </c:if>
                                                    <div>
                                                        <strong>${ob.bookTitle}</strong>
                                                        <c:if test="${not empty ob.authorName}"><br><small class="text-muted">${ob.authorName}</small></c:if>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-center">${ob.quantity}</td>
                                            <td class="text-end"><fmt:formatNumber value="${ob.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" minFractionDigits="0"/></td>
                                            <td class="text-end"><fmt:formatNumber value="${ob.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0" minFractionDigits="0"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr class="table-light">
                                        <td colspan="3" class="text-end fw-bold">Total</td>
                                        <td class="text-end fw-bold"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0" minFractionDigits="0"/></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>

                    <!-- Payment -->
                    <div class="card border border-secondary border-opacity-25 mb-4">
                        <div class="card-header bg-white"><strong>Payment</strong></div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty payment}">
                                    <div class="row">
                                        <div class="col-md-3"><strong>Method:</strong> ${payment.paymentMethod}</div>
                                        <div class="col-md-3"><strong>Status:</strong>
                                            <span class="badge ${payment.paymentStatus == 'success' ? 'bg-success' : payment.paymentStatus == 'pending' ? 'bg-warning' : 'bg-danger'}">
                                                ${payment.paymentStatus}
                                            </span>
                                        </div>
                                        <c:if test="${not empty payment.transactionCode}">
                                            <div class="col-md-3"><strong>Txn Code:</strong> ${payment.transactionCode}</div>
                                        </c:if>
                                        <c:if test="${not empty payment.paidAt}">
                                            <div class="col-md-3"><strong>Paid At:</strong> ${payment.paidAt}</div>
                                        </c:if>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted mb-0">No payment record.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="d-flex gap-2">
                        <c:if test="${order.status == 'pending'}">
                            <form action="<%= request.getContextPath() %>/seller/orders" method="post" class="d-inline">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <input type="hidden" name="action" value="markPaid">
                                <button type="submit" class="btn btn-success" onclick="return confirm('Xác nhận đã thu tiền (COD) cho đơn này?')">
                                    <i class="fas fa-check"></i> Xác nhận đã thanh toán
                                </button>
                            </form>
                            <form action="<%= request.getContextPath() %>/seller/orders" method="post" class="d-inline">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <input type="hidden" name="action" value="cancel">
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Cancel this order?')">
                                    <i class="fas fa-times"></i> Hủy đơn
                                </button>
                            </form>
                        </c:if>
                        <c:if test="${order.status == 'paid'}">
                            <form action="<%= request.getContextPath() %>/seller/orders" method="post">
                                <input type="hidden" name="orderId" value="${order.orderId}">
                                <input type="hidden" name="action" value="refund">
                                <button type="submit" class="btn btn-warning" onclick="return confirm('Refund this order?')">
                                    <i class="fas fa-undo"></i> Refund
                                </button>
                            </form>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
