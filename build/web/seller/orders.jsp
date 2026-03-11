<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Management - Seller</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<style>
    body { background: #f0f0f0; color: #333; }
    .sidebar-panel { min-height: 100vh; background: #fff; border-right: 1px solid #e0e0e0; }
    .sidebar-panel a { color: #333; padding: 12px 20px; display: block; text-decoration: none; }
    .sidebar-panel a:hover, .sidebar-panel a.active { background: #e8e8e8; }
</style>
<body>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-2 sidebar-panel p-0">
                <div class="p-4">
                    <h4 class="text-dark">💼 Seller Panel</h4>
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

            <!-- Main -->
            <div class="col-md-10 p-4">
                <h2 class="mb-4">🛒 Order Management</h2>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${successMessage}</div>
                </c:if>

                <div class="card border border-secondary border-opacity-25">
                    <div class="card-header bg-white border-bottom border-secondary border-opacity-25">
                        <h5 class="text-dark">All Orders</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty orders}">
                                <p class="text-muted">No orders found.</p>
                            </c:when>
                            <c:otherwise>
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Order ID</th>
                                            <th>Customer</th>
                                            <th>Total Amount</th>
                                            <th>Status</th>
                                            <th>Created At</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${orders}" var="order">
                                            <tr>
                                                <td>#${order.orderId}</td>
                                                <td>${order.readerName}<br><small class="text-muted">${order.readerEmail}</small></td>
                                                <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0" minFractionDigits="0"/></td>
                                                <td>
                                                    <span class="badge 
                                                        ${order.status == 'pending' ? 'bg-warning' : ''}
                                                        ${order.status == 'paid' ? 'bg-success' : ''}
                                                        ${order.status == 'cancelled' ? 'bg-danger' : ''}
                                                        ${order.status == 'refunded' ? 'bg-info' : ''}">
                                                        ${order.status}
                                                    </span>
                                                </td>
                                                <td>${order.createdAt}</td>
                                                <td>
                                                    <a href="<%= request.getContextPath() %>/seller/order-detail?orderId=${order.orderId}" class="btn btn-sm btn-outline-dark me-1" title="View Detail">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <c:if test="${order.status == 'pending'}">
                                                        <form action="<%= request.getContextPath() %>/seller/orders" method="post" style="display:inline;">
                                                            <input type="hidden" name="orderId" value="${order.orderId}">
                                                            <input type="hidden" name="action" value="markPaid">
                                                            <button type="submit" class="btn btn-sm btn-success me-1" onclick="return confirm('Xác nhận đã thu tiền (COD)?')" title="Xác nhận đã thanh toán">
                                                                <i class="fas fa-check"></i>
                                                            </button>
                                                        </form>
                                                        <form action="<%= request.getContextPath() %>/seller/orders" method="post" style="display:inline;">
                                                            <input type="hidden" name="orderId" value="${order.orderId}">
                                                            <input type="hidden" name="action" value="cancel">
                                                            <button type="submit" class="btn btn-sm btn-danger me-1" onclick="return confirm('Cancel this order?')" title="Hủy đơn">
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${order.status == 'paid'}">
                                                        <form action="<%= request.getContextPath() %>/seller/orders" method="post" style="display:inline;">
                                                            <input type="hidden" name="orderId" value="${order.orderId}">
                                                            <input type="hidden" name="action" value="refund">
                                                            <button type="submit" class="btn btn-sm btn-warning" onclick="return confirm('Refund this order?')" title="Refund">
                                                                <i class="fas fa-undo"></i>
                                                            </button>
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
    </div>
</body>
</html>
