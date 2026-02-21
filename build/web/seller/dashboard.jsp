<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Dashboard - Digital Library</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f0f0f0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
        }
        .sidebar {
            min-height: 100vh;
            background: #fff;
            color: #333;
            border-right: 1px solid #e0e0e0;
        }
        .sidebar a {
            color: #333;
            text-decoration: none;
            padding: 12px 20px;
            display: block;
            transition: background 0.2s;
        }
        .sidebar a:hover, .sidebar a.active {
            background: #e8e8e8;
        }
        .stat-card {
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 20px;
            background: #fff;
            border: 1px solid #e0e0e0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        .stat-card h3 { font-size: 2.5rem; font-weight: bold; margin: 0; color: #333; }
        .stat-card p { color: #666; margin: 0; font-size: 0.9rem; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar p-0">
                <div class="p-4">
                    <h4 class="mb-4">📚 Seller Panel</h4>
                    <p class="small mb-4">Welcome, ${employee.fullName}</p>
                </div>
                <nav>
                    <a href="<%= request.getContextPath() %>/home">
                        <i class="fas fa-home"></i> Home
                    </a>
                    <a href="<%= request.getContextPath() %>/seller/dashboard" class="active">
                        <i class="fas fa-dashboard"></i> Dashboard
                    </a>
                    <a href="<%= request.getContextPath() %>/seller/orders">
                        <i class="fas fa-shopping-cart"></i> Orders
                    </a>
                    <a href="<%= request.getContextPath() %>/seller/sales-report">
                        <i class="fas fa-chart-line"></i> Sales Report
                    </a>
                    <a href="<%= request.getContextPath() %>/logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>💼 Seller Dashboard</h2>
                    <div class="text-muted">
                        <i class="fas fa-user"></i> ${employee.fullName} (${employee.roleName})
                    </div>
                </div>

                <!-- Success Message -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show">
                        ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Statistics Cards -->
                <div class="row">
                    <div class="col-md-4">
                        <div class="stat-card">
                            <i class="fas fa-dollar-sign text-secondary mb-3" style="font-size: 2rem;"></i>
                            <h3>
                                <fmt:formatNumber value="${totalSales}" type="currency" currencySymbol="$"/>
                            </h3>
                            <p>Total Sales</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <i class="fas fa-shopping-bag text-secondary mb-3" style="font-size: 2rem;"></i>
                            <h3>${totalOrders}</h3>
                            <p>Total Orders</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <i class="fas fa-clock text-secondary mb-3" style="font-size: 2rem;"></i>
                            <h3>${pendingOrders}</h3>
                            <p>Pending Orders</p>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="card mt-4 border border-secondary border-opacity-25">
                    <div class="card-header bg-white border-bottom border-secondary border-opacity-25">
                        <h5 class="mb-0 text-dark">Quick Actions</h5>
                    </div>
                    <div class="card-body bg-light bg-opacity-50">
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <a href="<%= request.getContextPath() %>/seller/orders" class="btn btn-outline-secondary w-100 p-3 text-dark">
                                    <i class="fas fa-list"></i><br>
                                    Manage Orders
                                </a>
                            </div>
                            <div class="col-md-4 mb-3">
                                <a href="<%= request.getContextPath() %>/seller/sales-report" class="btn btn-outline-secondary w-100 p-3 text-dark">
                                    <i class="fas fa-chart-bar"></i><br>
                                    View Sales Report
                                </a>
                            </div>
                            <div class="col-md-4 mb-3">
                                <a href="<%= request.getContextPath() %>/admin/books" class="btn btn-outline-secondary w-100 p-3 text-dark">
                                    <i class="fas fa-book"></i><br>
                                    Browse Catalog
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card mt-4 border border-secondary border-opacity-25">
                    <div class="card-header bg-white border-bottom border-secondary border-opacity-25">
                        <h5 class="mb-0 text-dark">Recent Activity</h5>
                    </div>
                    <div class="card-body bg-light bg-opacity-50">
                        <p class="text-muted mb-0">System is ready. Start managing orders and viewing reports.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
