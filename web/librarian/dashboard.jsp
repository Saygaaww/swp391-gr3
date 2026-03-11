<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Librarian Dashboard - Digital Library</title>
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
        }
        .stat-card {
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 20px;
            background: #fff;
            border: 1px solid #e0e0e0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.06);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar p-0">
                <div class="p-4">
                    <h4 class="mb-4">📖 Librarian Panel</h4>
                    <p class="small mb-4">Welcome, ${employee.fullName}</p>
                </div>
                <nav>
                    <a href="<%= request.getContextPath() %>/home">
                        <i class="fas fa-home"></i> Home
                    </a>
                    <a href="<%= request.getContextPath() %>/librarian/dashboard" class="active">
                        <i class="fas fa-dashboard"></i> Dashboard
                    </a>
                    <a href="<%= request.getContextPath() %>/librarian/borrow-requests">
                        <i class="fas fa-book-reader"></i> Borrow Requests
                    </a>
                    <a href="<%= request.getContextPath() %>/logout">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 p-4">
                <h2 class="mb-4">📖 Librarian Dashboard</h2>

                <!-- Statistics -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="stat-card">
                            <i class="fas fa-clock fa-2x mb-2 text-secondary"></i>
                            <h3>${pendingRequests}</h3>
                            <p class="text-muted mb-0">Pending Borrow Requests</p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="stat-card">
                            <i class="fas fa-book fa-2x mb-2 text-secondary"></i>
                            <h3>${fn:length(overdueList)}</h3>
                            <p class="text-muted mb-0">Overdue</p>
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

                <div class="card mt-4 border border-secondary border-opacity-25">
                    <div class="card-header bg-white border-bottom border-secondary border-opacity-25">
                        <h5 class="mb-0 text-dark">Quick Actions</h5>
                    </div>
                    <div class="card-body bg-light bg-opacity-50">
                        <a href="<%= request.getContextPath() %>/librarian/borrow-requests" class="btn btn-outline-secondary me-2 text-dark">
                            <i class="fas fa-check"></i> Process Borrow Requests
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/books" class="btn btn-outline-secondary text-dark">
                            <i class="fas fa-book"></i> View Book Catalog
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
