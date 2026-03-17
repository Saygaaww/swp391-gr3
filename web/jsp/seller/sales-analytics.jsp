<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Analytics - Seller</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background:#f3f4f6; }
        .topbar {
            background:#fff; border-bottom:1px solid #e5e7eb; height:64px; display:flex;
            align-items:center; justify-content:space-between; padding:0 1.5rem;
        }
        .brand { text-decoration:none; color:#111827; font-weight:800; display:flex; gap:10px; align-items:center; }
        .brand i { color:#7c3aed; }
        .role-badge {
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            color:#fff; padding:4px 12px; border-radius:99px; font-size:.78rem; font-weight:700;
        }
        .kpi-card { border:0; border-radius:16px; box-shadow: 0 1px 8px rgba(0,0,0,0.06); }
        .kpi-icon { width:48px; height:48px; border-radius:14px; display:flex; align-items:center; justify-content:center; }
        .kpi-icon.purple { background:#ede9fe; color:#7c3aed; }
        .kpi-icon.green { background:#dcfce7; color:#16a34a; }
        .kpi-icon.orange { background:#ffedd5; color:#ea580c; }
        .kpi-icon.blue { background:#dbeafe; color:#2563eb; }
    </style>
</head>
<body>
<header class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/books/dashboard">
        <i class="fas fa-book-open"></i> Seller Dashboard
    </a>
    <div class="d-flex align-items-center gap-2">
        <span class="role-badge"><i class="fas fa-user-tie me-1"></i>${sessionScope.userRole}</span>
        <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/seller/sales-report">
            <i class="fas fa-receipt me-1"></i> Report
        </a>
        <a class="btn btn-outline-danger btn-sm" href="${pageContext.request.contextPath}/auth/logout">
            <i class="fas fa-sign-out-alt me-1"></i> Logout
        </a>
    </div>
</header>

<main class="container py-4">
    <div class="d-flex justify-content-between align-items-end mb-3">
        <div>
            <h3 class="mb-1 fw-bold">Sales Analytics</h3>
            <div class="text-muted">Tổng quan volume, doanh thu và top-selling books (paid orders).</div>
        </div>
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/books/dashboard">
            <i class="fas fa-arrow-left me-1"></i> Về dashboard
        </a>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card kpi-card">
                <div class="card-body d-flex gap-3 align-items-center">
                    <div class="kpi-icon purple"><i class="fas fa-file-invoice"></i></div>
                    <div>
                        <div class="text-muted small">Total orders</div>
                        <div class="fs-4 fw-bold">${totalOrders}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card kpi-card">
                <div class="card-body d-flex gap-3 align-items-center">
                    <div class="kpi-icon green"><i class="fas fa-check"></i></div>
                    <div>
                        <div class="text-muted small">Paid orders</div>
                        <div class="fs-4 fw-bold">${paidOrders}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card kpi-card">
                <div class="card-body d-flex gap-3 align-items-center">
                    <div class="kpi-icon orange"><i class="fas fa-hourglass-half"></i></div>
                    <div>
                        <div class="text-muted small">Pending orders</div>
                        <div class="fs-4 fw-bold">${pendingOrders}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card kpi-card">
                <div class="card-body d-flex gap-3 align-items-center">
                    <div class="kpi-icon blue"><i class="fas fa-money-bill-wave"></i></div>
                    <div>
                        <div class="text-muted small">Revenue (paid)</div>
                        <div class="fs-5 fw-bold">
                            <fmt:formatNumber value="${paidRevenue}" type="number" maxFractionDigits="0" /> VND
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <div class="fw-bold"><i class="fas fa-crown me-2 text-warning"></i>Top-selling books</div>
            <div class="text-muted small">Theo số lượng bán (order status = paid)</div>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th style="width:90px;">BookID</th>
                        <th>Title</th>
                        <th style="width:220px;">Author</th>
                        <th style="width:140px;">Qty</th>
                        <th style="width:180px;">Revenue</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty topBooks}">
                            <tr><td colspan="5" class="text-center text-muted py-4">Chưa có dữ liệu.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="b" items="${topBooks}">
                                <tr>
                                    <td class="fw-bold">#${b.bookId}</td>
                                    <td>${b.title}</td>
                                    <td class="text-muted">${b.authorName}</td>
                                    <td class="fw-semibold">${b.totalQuantity}</td>
                                    <td class="fw-semibold">
                                        <fmt:formatNumber value="${b.totalRevenue}" type="number" maxFractionDigits="0" /> VND
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
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

