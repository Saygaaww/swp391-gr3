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
                    <a href="<%= request.getContextPath() %>/home"><i class="fas fa-home"></i> Home</a>
                    <a href="<%= request.getContextPath() %>/seller/dashboard"><i class="fas fa-dashboard"></i> Dashboard</a>
                    <a href="<%= request.getContextPath() %>/seller/books"><i class="fas fa-book"></i> Books</a>
                    <a href="<%= request.getContextPath() %>/seller/orders"><i class="fas fa-shopping-cart"></i> Orders</a>
                    <a href="<%= request.getContextPath() %>/seller/sales-report" class="active"><i class="fas fa-chart-line"></i> Sales Report</a>
                    <a href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </nav>
            </div>

            <!-- Main -->
            <div class="col-md-10 p-4">
                <h2 class="mb-4"><i class="fas fa-chart-bar"></i> Sales Report</h2>

                <!-- Date Filter -->
                <div class="card border border-secondary border-opacity-25 mb-4">
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/seller/sales-report" method="get" class="row g-2 align-items-end">
                            <div class="col-auto">
                                <label class="form-label small">From</label>
                                <input type="date" name="fromDate" class="form-control" value="${fromDate}">
                            </div>
                            <div class="col-auto">
                                <label class="form-label small">To</label>
                                <input type="date" name="toDate" class="form-control" value="${toDate}">
                            </div>
                            <div class="col-auto">
                                <button type="submit" class="btn btn-dark"><i class="fas fa-filter"></i> Filter</button>
                            </div>
                            <div class="col-auto">
                                <a href="<%= request.getContextPath() %>/seller/sales-report" class="btn btn-outline-secondary">Reset</a>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="row mb-4">
                    <div class="col-md-2">
                        <div class="card border border-secondary border-opacity-25">
                            <div class="card-body text-center">
                                <h4 class="text-dark"><fmt:formatNumber value="${totalSales}" type="currency" currencySymbol="₫" maxFractionDigits="0" minFractionDigits="0"/></h4>
                                <p class="text-muted mb-0 small">Revenue</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card border border-secondary border-opacity-25">
                            <div class="card-body text-center">
                                <h4 class="text-dark">${totalOrders}</h4>
                                <p class="text-muted mb-0 small">Total Orders</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card border border-secondary border-opacity-25">
                            <div class="card-body text-center">
                                <h4 class="text-success">${paidOrders}</h4>
                                <p class="text-muted mb-0 small">Paid</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card border border-secondary border-opacity-25">
                            <div class="card-body text-center">
                                <h4 class="text-warning">${pendingOrders}</h4>
                                <p class="text-muted mb-0 small">Pending</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card border border-secondary border-opacity-25">
                            <div class="card-body text-center">
                                <h4 class="text-danger">${cancelledOrders}</h4>
                                <p class="text-muted mb-0 small">Cancelled</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-2">
                        <div class="card border border-secondary border-opacity-25">
                            <div class="card-body text-center">
                                <h4 class="text-info">${refundedOrders}</h4>
                                <p class="text-muted mb-0 small">Refunded</p>
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
                                                <td><fmt:formatNumber value="${b.totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0" minFractionDigits="0"/></td>
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
                                    <thead><tr><th>Order ID</th><th>Customer</th><th>Amount</th><th>Status</th><th>Created</th><th></th></tr></thead>
                                    <tbody>
                                        <c:forEach items="${orders}" var="o">
                                            <tr>
                                                <td>#${o.orderId}</td>
                                                <td>${o.readerName}</td>
                                                <td><fmt:formatNumber value="${o.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0" minFractionDigits="0"/></td>
                                                <td><span class="badge ${o.status == 'paid' ? 'bg-success' : o.status == 'pending' ? 'bg-warning' : o.status == 'cancelled' ? 'bg-danger' : o.status == 'refunded' ? 'bg-info' : 'bg-secondary'}">${o.status}</span></td>
                                                <td>${o.createdAt != null ? o.createdAt : '-'}</td>
                                                <td><a href="<%= request.getContextPath() %>/seller/order-detail?orderId=${o.orderId}" class="btn btn-sm btn-outline-dark"><i class="fas fa-eye"></i></a></td>
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
