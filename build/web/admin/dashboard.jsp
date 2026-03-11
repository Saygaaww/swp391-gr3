<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Digital Library</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #f0f0f0;
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
            color: #333;
        }
        .stat-card {
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 20px;
            background: #fff;
            border: 1px solid #e0e0e0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
        .stat-card h3, .stat-card p { color: #333; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar p-0">
                <div class="p-4">
                    <h4 class="mb-4">🔧 Admin Panel</h4>
                    <p class="small mb-4">Welcome, ${employee.fullName}</p>
                </div>
                <nav>
                    <a href="<%= request.getContextPath() %>/home">
                        <i class="fas fa-home"></i> Home
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="active">
                        <i class="fas fa-dashboard"></i> Dashboard
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/users">
                        <i class="fas fa-users"></i> Users
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/books">
                        <i class="fas fa-book"></i> Books
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/payments">
                        <i class="fas fa-credit-card"></i> Payments
                    </a>
                    <a href="<%= request.getContextPath() %>/logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 p-4">
                <h2 class="mb-4">🔧 Admin Dashboard</h2>

                <!-- Statistics Cards -->
                <div class="row">
                    <div class="col-md-4">
                        <div class="stat-card">
                            <i class="fas fa-dollar-sign fa-2x mb-2 text-secondary"></i>
                            <h3><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0" minFractionDigits="0"/></h3>
                            <p class="text-muted mb-0">Total Revenue</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <i class="fas fa-shopping-cart fa-2x mb-2 text-secondary"></i>
                            <h3>${totalOrders}</h3>
                            <p class="text-muted mb-0">Total Orders</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stat-card">
                            <i class="fas fa-clock fa-2x mb-2 text-secondary"></i>
                            <h3>${pendingBorrowRequests}</h3>
                            <p class="text-muted mb-0">Pending Requests</p>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="card border border-secondary border-opacity-25">
                    <div class="card-header bg-white border-bottom border-secondary border-opacity-25">
                        <h5 class="mb-0 text-dark">System Management</h5>
                    </div>
                    <div class="card-body bg-light bg-opacity-50">
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <a href="<%= request.getContextPath() %>/admin/users" class="btn btn-outline-secondary w-100 p-3 text-dark">
                                    <i class="fas fa-users fa-2x mb-2"></i><br>
                                    User Management
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="<%= request.getContextPath() %>/admin/books" class="btn btn-outline-secondary w-100 p-3 text-dark">
                                    <i class="fas fa-book fa-2x mb-2"></i><br>
                                    Book Management
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="<%= request.getContextPath() %>/admin/payments" class="btn btn-outline-secondary w-100 p-3 text-dark">
                                    <i class="fas fa-credit-card fa-2x mb-2"></i><br>
                                    Payment Management
                                </a>
                            </div>
                            <div class="col-md-3 mb-3">
                                <a href="<%= request.getContextPath() %>/librarian/borrow-requests" class="btn btn-outline-secondary w-100 p-3 text-dark">
                                    <i class="fas fa-book-reader fa-2x mb-2"></i><br>
                                    Borrow Requests
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Overdue List (read-only) -->
                <div class="card mt-4 border border-secondary border-opacity-25">
                    <div class="card-header bg-white border-bottom border-secondary border-opacity-25">
                        <h5 class="mb-0 text-dark"><i class="fas fa-exclamation-triangle text-warning"></i> Overdue List</h5>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty overdueList}">
                                <p class="text-muted mb-0 p-3">Không có mục mượn quá hạn.</p>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light"><tr><th>Reader</th><th>Book</th><th>Due Date</th></tr></thead>
                                        <tbody>
                                            <c:forEach items="${overdueList}" var="o">
                                                <tr>
                                                    <td>${o.readerName}</td>
                                                    <td>${o.bookTitle}</td>
                                                    <td>${o.dueDate != null ? o.dueDate : '—'}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Catalog Changes (recent books, read-only) -->
                <div class="card mt-4 border border-secondary border-opacity-25">
                    <div class="card-header bg-white border-bottom border-secondary border-opacity-25">
                        <h5 class="mb-0 text-dark"><i class="fas fa-book"></i> Catalog Changes (Recently Updated)</h5>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty catalogChanges}">
                                <p class="text-muted mb-0 p-3">Chưa có sách nào.</p>
                            </c:when>
                            <c:otherwise>
                                <ul class="list-group list-group-flush">
                                    <c:forEach items="${catalogChanges}" var="b">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            <span>${b.title} <small class="text-muted">${b.authorName}</small></span>
                                            <small class="text-muted">${b.updatedAt != null ? b.updatedAt : b.createdAt}</small>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
