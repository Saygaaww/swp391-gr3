<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h2 class="mb-1">Sales Analytics</h2>
            <div class="text-muted">KPI và xu hướng doanh thu của Seller</div>
        </div>
        <a href="${pageContext.request.contextPath}/books/dashboard" class="btn btn-outline-secondary">Về dashboard</a>
    </div>

    <div class="card mb-3">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/seller/sales-analytics" class="row g-2 align-items-end">
                <div class="col-md-2">
                    <label class="form-label">Xu hướng theo</label>
                    <select name="trendBy" class="form-select">
                        <option value="day" ${trendBy == 'day' ? 'selected' : ''}>Ngày</option>
                        <option value="month" ${trendBy == 'month' ? 'selected' : ''}>Tháng</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Từ ngày</label>
                    <input type="date" name="fromDate" value="${fromDate}" class="form-control" />
                </div>
                <div class="col-md-3">
                    <label class="form-label">Đến ngày</label>
                    <input type="date" name="toDate" value="${toDate}" class="form-control" />
                </div>
                <div class="col-md-2 d-grid">
                    <button type="submit" class="btn btn-dark">Cập nhật</button>
                </div>
            </form>
        </div>
    </div>

    <div class="row g-3 mb-3">
        <div class="col-md-4">
            <div class="card h-100"><div class="card-body"><div class="text-muted">Tổng doanh thu</div><div class="fs-4 fw-bold"><fmt:formatNumber value="${summary.totalRevenue}" type="currency" currencySymbol="₫" /></div></div></div>
        </div>
        <div class="col-md-4">
            <div class="card h-100"><div class="card-body"><div class="text-muted">Đơn thành công</div><div class="fs-4 fw-bold">${summary.successfulOrders}</div></div></div>
        </div>
        <div class="col-md-4">
            <div class="card h-100"><div class="card-body"><div class="text-muted">Giá trị đơn TB</div><div class="fs-4 fw-bold"><fmt:formatNumber value="${summary.avgOrderValue}" type="currency" currencySymbol="₫" /></div></div></div>
        </div>
    </div>

    <div class="card mb-3">
        <div class="card-header">Biểu đồ xu hướng doanh thu</div>
        <div class="card-body">
            <div id="trendData" data-labels='${trendLabels}' data-values='${trendValues}'></div>
            <canvas id="revenueChart" height="110"></canvas>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header">Top sách bán chạy</div>
        <div class="table-responsive">
            <table class="table table-hover mb-0 align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Sách</th>
                        <th>Tác giả</th>
                        <th class="text-center">SL bán</th>
                        <th class="text-end">Doanh thu</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="book" items="${topBooks}">
                        <tr>
                            <td>${book.title}</td>
                            <td>${book.authorName}</td>
                            <td class="text-center">${book.totalQuantity}</td>
                            <td class="text-end"><fmt:formatNumber value="${book.totalRevenue}" type="currency" currencySymbol="₫" /></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty topBooks}">
                        <tr>
                            <td colspan="4" class="text-center text-muted py-4">Chưa có dữ liệu.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = document.getElementById('revenueChart');
    const trendDataNode = document.getElementById('trendData');
    const trendLabels = trendDataNode ? JSON.parse(trendDataNode.getAttribute('data-labels') || '[]') : [];
    const trendValues = trendDataNode ? JSON.parse(trendDataNode.getAttribute('data-values') || '[]') : [];

    if (ctx) {
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: trendLabels,
                datasets: [{
                    label: 'Doanh thu',
                    data: trendValues,
                    borderColor: '#0d6efd',
                    backgroundColor: 'rgba(13,110,253,0.12)',
                    fill: true,
                    tension: 0.25
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: true } },
                scales: { y: { beginAtZero: true } }
            }
        });
    }
</script>

<jsp:include page="/includes/footer.jsp" />
