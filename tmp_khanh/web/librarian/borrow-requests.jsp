<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Borrow Requests - Librarian</title>
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
                    <h4 class="text-dark">📖 Librarian Panel</h4>
                </div>
                <nav>
                    <a href="<%= request.getContextPath() %>/librarian/dashboard"> <i class="fas fa-dashboard"></i> Dashboard </a>
                    <a href="<%= request.getContextPath() %>/librarian/borrow-requests" class="active"> <i class="fas fa-book-reader"></i> Borrow Requests </a>
                    <a href="<%= request.getContextPath() %>/logout"> <i class="fas fa-sign-out-alt"></i> Logout </a>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="col-md-10 p-4">
                <h2 class="mb-4">📚 Borrow Requests</h2>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${successMessage}</div>
                </c:if>

                <div class="card border border-secondary border-opacity-25">
                    <div class="card-header bg-white border-bottom border-secondary border-opacity-25">
                        <h5 class="text-dark">Pending Requests</h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty requests}">
                                <p class="text-muted">No borrow requests found.</p>
                            </c:when>
                            <c:otherwise>
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Request ID</th>
                                            <th>Reader</th>
                                            <th>Status</th>
                                            <th>Requested At</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${requests}" var="req">
                                            <tr>
                                                <td>#${req.requestId}</td>
                                                <td>${req.readerName}<br><small class="text-muted">${req.readerEmail}</small></td>
                                                <td>
                                                    <span class="badge 
                                                        ${req.status == 'pending' ? 'bg-warning' : ''}
                                                        ${req.status == 'approved' ? 'bg-success' : ''}
                                                        ${req.status == 'rejected' ? 'bg-danger' : ''}">
                                                        ${req.status}
                                                    </span>
                                                </td>
                                                <td>${req.requestedAt}</td>
                                                <td>
                                                    <c:if test="${req.status == 'pending'}">
                                                        <form action="<%= request.getContextPath() %>/librarian/borrow-requests" method="post" style="display: inline;">
                                                            <input type="hidden" name="requestId" value="${req.requestId}">
                                                            <input type="hidden" name="action" value="approve">
                                                            <button type="submit" class="btn btn-sm btn-success">
                                                                <i class="fas fa-check"></i> Approve
                                                            </button>
                                                        </form>
                                                        <form action="<%= request.getContextPath() %>/librarian/borrow-requests" method="post" style="display: inline;">
                                                            <input type="hidden" name="requestId" value="${req.requestId}">
                                                            <input type="hidden" name="action" value="reject">
                                                            <button type="submit" class="btn btn-sm btn-danger">
                                                                <i class="fas fa-times"></i> Reject
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
