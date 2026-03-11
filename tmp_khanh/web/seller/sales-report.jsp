<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sales Report - Seller</title>
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
                    <a href="<%= request.getContextPath() %>/seller/dashboard">Dashboard</a>
                    <a href="<%= request.getContextPath() %>/seller/orders">Orders</a>
                    <a href="<%= request.getContextPath() %>/seller/sales-report" class="active">Sales Report</a>
                    <a href="<%= request.getContextPath() %>/logout">Logout</a>
                </nav>
            </div>

            <!-- Main -->
            <div class="col-md-10 p-4">
                <h2 class="mb-4">📊 Sales Report</h2>

                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card border border-secondary border-opacity-25">
                            <div class="card-body text-center">
                                <h4 class="text-dark"><fmt:formatNumber value="${totalSales}" type="currency" currencySymbol="$"/></h4>
                                <p class="text-muted mb-0">Total Sales</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border border-secondary border-opacity-25">
                            <div class="card-body text-center">
                                <h4 class="text-dark">${totalOrders}</h4>
                                <p class="text-muted mb-0">Total Orders</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border border-secondary border-opacity-25">
                            <div class="card-body text-center">
                                <h4 class="text-dark">${paidOrders}</h4>
                                <p class="text-muted mb-0">Paid Orders</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card border border-secondary border-opacity-25">
                            <div class="card-body text-center">
                                <h4 class="text-dark">${pendingOrders}</h4>
                                <p class="text-muted mb-0">Pending Orders</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card border border-secondary border-opacity-25 mb-4">
                    <div class="card-header bg-white border-bottom border-secondary border-opacity-25">
                        <h5 class="text-dark mb-0">Sales Analytics - Top Selling Books</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty topSellingBooks}">
                                <p class="text-muted mb-0">Chưa có dữ liệu bán hàng.</p>
                            </c:when>
                            <c:otherwise>
                                <table class="table table-sm table-hover">
                                    <thead><tr><th>#</th><th>Book</th><th>Author</th><th>Qty Sold</th><th>Revenue</th></tr></thead>
                                    <tbody>
                                        <c:forEach items="${topSellingBooks}" var="b" varStatus="st">
                                            <tr>
                                                <td>${st.index + 1}</td>
                                                <td>${b.title}</td>
                                                <td>${b.authorName}</td>
                                                <td>${b.totalQuantity}</td>
                                                <td><fmt:formatNumber value="${b.totalRevenue}" type="currency" currencySymbol="$"/></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="card border border-secondary border-opacity-25">
                    <div class="card-header bg-white border-bottom border-secondary border-opacity-25">
                        <h5 class="text-dark mb-0">Recent Orders</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty orders}">
                                <p class="text-muted mb-0">No orders found.</p>
                            </c:when>
                            <c:otherwise>
                                <table class="table table-sm table-hover">
                                    <thead><tr><th>Order ID</th><th>Customer</th><th>Amount</th><th>Status</th><th>Created</th></tr></thead>
                                    <tbody>
                                        <c:forEach items="${orders}" var="o">
                                            <tr>
                                                <td>#${o.orderId}</td>
                                                <td>${o.readerName}</td>
                                                <td><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="$"/></td>
                                                <td><span class="badge ${o.status == 'paid' ? 'bg-success' : o.status == 'pending' ? 'bg-warning' : 'bg-secondary'}">${o.status}</span></td>
                                                <td>${o.createdAt != null ? o.createdAt : '-'}</td>
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
