<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Report - Seller</title>
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
        .chip { padding:4px 10px; border-radius:999px; font-weight:700; font-size:.75rem; }
        .chip-paid { background:#dcfce7; color:#16a34a; }
        .chip-pending { background:#ffedd5; color:#ea580c; }
        .chip-cancelled { background:#fee2e2; color:#dc2626; }
        .chip-other { background:#e5e7eb; color:#374151; }
        .chip-success { background:#dcfce7; color:#16a34a; }
        .chip-pay-pending { background:#dbeafe; color:#2563eb; }
        .chip-pay-fail { background:#fee2e2; color:#dc2626; }
    </style>
</head>
<body>
<header class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/books/dashboard">
        <i class="fas fa-book-open"></i> Seller Dashboard
    </a>
    <div class="d-flex align-items-center gap-2">
        <span class="role-badge"><i class="fas fa-user-tie me-1"></i>${sessionScope.userRole}</span>
        <a class="btn btn-outline-secondary btn-sm" href="${pageContext.request.contextPath}/seller/sales-analytics">
            <i class="fas fa-chart-line me-1"></i> Analytics
        </a>
        <a class="btn btn-outline-danger btn-sm" href="${pageContext.request.contextPath}/auth/logout">
            <i class="fas fa-sign-out-alt me-1"></i> Logout
        </a>
    </div>
</header>

<main class="container py-4">
    <div class="d-flex justify-content-between align-items-end mb-3">
        <div>
            <h3 class="mb-1 fw-bold">Sales Report</h3>
            <div class="text-muted">Xem orders, order items và trạng thái thanh toán.</div>
        </div>
        <a class="btn btn-secondary" href="${pageContext.request.contextPath}/books/dashboard">
            <i class="fas fa-arrow-left me-1"></i> Về dashboard
        </a>
    </div>

    <c:if test="${param.msg == 'ok'}">
        <div class="alert alert-success">Thao tác thành công.</div>
    </c:if>
    <c:if test="${param.msg == 'denied'}">
        <div class="alert alert-warning">Không thể thực hiện theo policy hoặc trạng thái không phù hợp.</div>
    </c:if>
    <c:if test="${param.msg == 'notfound'}">
        <div class="alert alert-danger">Không tìm thấy đơn hàng.</div>
    </c:if>

    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th style="width:90px;">Order</th>
                        <th>Người mua</th>
                        <th style="width:170px;">Ngày tạo</th>
                        <th style="width:140px;">Tổng</th>
                        <th style="width:150px;">Order status</th>
                        <th style="width:150px;">Payment</th>
                        <th style="width:220px;">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty orders}">
                            <tr><td colspan="7" class="text-center text-muted py-4">Chưa có đơn hàng.</td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="o" items="${orders}">
                                <c:set var="p" value="${requestScope['payment_'.concat(o.orderId)]}" />
                                <tr>
                                    <td class="fw-bold">#${o.orderId}</td>
                                    <td>
                                        <div class="fw-semibold">${o.readerName}</div>
                                        <div class="text-muted small">${o.readerEmail}</div>
                                    </td>
                                    <td class="text-muted">
                                        <c:choose>
                                            <c:when test="${not empty o.createdAt}">${o.createdAt}</c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="fw-semibold">
                                        <fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0" />
                                        ${not empty o.currency ? o.currency : 'VND'}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${o.status == 'paid'}"><span class="chip chip-paid">paid</span></c:when>
                                            <c:when test="${o.status == 'pending'}"><span class="chip chip-pending">pending</span></c:when>
                                            <c:when test="${o.status == 'cancelled'}"><span class="chip chip-cancelled">cancelled</span></c:when>
                                            <c:otherwise><span class="chip chip-other">${o.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty p}">
                                                <span class="chip chip-other">—</span>
                                            </c:when>
                                            <c:when test="${p.paymentStatus == 'success'}">
                                                <span class="chip chip-success">success</span>
                                            </c:when>
                                            <c:when test="${p.paymentStatus == 'pending'}">
                                                <span class="chip chip-pay-pending">pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="chip chip-pay-fail">${p.paymentStatus}</span>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${not empty p && not empty p.transactionCode}">
                                            <div class="text-muted small">Txn: ${p.transactionCode}</div>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="d-flex flex-wrap gap-2">
                                            <button class="btn btn-outline-secondary btn-sm"
                                                    type="button"
                                                    data-bs-toggle="collapse"
                                                    data-bs-target="#items_${o.orderId}">
                                                <i class="fas fa-list me-1"></i> Items
                                            </button>

                                            <form method="post" action="${pageContext.request.contextPath}/seller/sales-report" class="d-inline">
                                                <input type="hidden" name="orderId" value="${o.orderId}">
                                                <input type="hidden" name="action" value="cancel">
                                                <button class="btn btn-outline-danger btn-sm"
                                                        type="submit"
                                                        onclick="return confirm('Hủy đơn #${o.orderId}?');">
                                                    <i class="fas fa-ban me-1"></i> Cancel
                                                </button>
                                            </form>

                                            <form method="post" action="${pageContext.request.contextPath}/seller/sales-report" class="d-inline">
                                                <input type="hidden" name="orderId" value="${o.orderId}">
                                                <input type="hidden" name="action" value="refund">
                                                <button class="btn btn-outline-primary btn-sm"
                                                        type="submit"
                                                        onclick="return confirm('Yêu cầu hoàn tiền đơn #${o.orderId}?');">
                                                    <i class="fas fa-rotate-left me-1"></i> Refund
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>

                                <tr class="collapse bg-light" id="items_${o.orderId}">
                                    <td colspan="7">
                                        <div class="p-3">
                                            <div class="fw-bold mb-2">Order items</div>
                                            <c:choose>
                                                <c:when test="${empty o.orderBooks}">
                                                    <div class="text-muted">Không có items.</div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="table-responsive">
                                                        <table class="table table-sm align-middle mb-0">
                                                            <thead>
                                                            <tr>
                                                                <th>Book</th>
                                                                <th style="width:120px;">Price</th>
                                                                <th style="width:100px;">Qty</th>
                                                                <th style="width:140px;">Subtotal</th>
                                                            </tr>
                                                            </thead>
                                                            <tbody>
                                                            <c:forEach var="it" items="${o.orderBooks}">
                                                                <tr>
                                                                    <td>
                                                                        <div class="fw-semibold">${it.bookTitle}</div>
                                                                        <div class="text-muted small">${it.authorName}</div>
                                                                    </td>
                                                                    <td>
                                                                        <fmt:formatNumber value="${it.price}" type="number" maxFractionDigits="0" />
                                                                    </td>
                                                                    <td>${it.quantity}</td>
                                                                    <td class="fw-semibold">
                                                                        <fmt:formatNumber value="${it.price * it.quantity}" type="number" maxFractionDigits="0" />
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
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

