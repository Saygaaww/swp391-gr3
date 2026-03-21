<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/navbar.jsp" />

<div class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h2 class="mb-1">Sales Report</h2>
            <div class="text-muted">Báo cáo doanh thu theo ngày/tháng cho Seller</div>
        </div>
        <a href="${pageContext.request.contextPath}/books/dashboard" class="btn btn-outline-secondary">Về dashboard</a>
    </div>

    <div class="card mb-3">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/seller/sales-report" class="row g-2 align-items-end">
                <div class="col-md-2">
                    <label class="form-label">Nhóm theo</label>
                    <select name="groupBy" class="form-select">
                        <option value="day" ${groupBy == 'day' ? 'selected' : ''}>Ngày</option>
                        <option value="month" ${groupBy == 'month' ? 'selected' : ''}>Tháng</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label">Status</label>
                    <select name="status" class="form-select">
                        <option value="all" ${empty status ? 'selected' : ''}>Tất cả</option>
                        <option value="pending" ${status == 'pending' ? 'selected' : ''}>Pending</option>
                        <option value="paid" ${status == 'paid' ? 'selected' : ''}>Paid</option>
                        <option value="cancelled" ${status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
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
                    <button type="submit" class="btn btn-dark">Xem báo cáo</button>
                </div>
            </form>
        </div>
    </div>

    <div class="row g-3 mb-3">
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-body">
                    <div class="text-muted">Tổng số đơn</div>
                    <div class="fs-3 fw-bold">${totalOrders}</div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card h-100">
                <div class="card-body">
                    <div class="text-muted">Tổng doanh thu</div>
                    <div class="fs-3 fw-bold"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" /></div>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover mb-0 align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Kỳ báo cáo</th>
                        <th class="text-center">Số đơn</th>
                        <th class="text-end">Doanh thu</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${rows}">
                        <tr>
                            <td>${row.period}</td>
                            <td class="text-center">${row.orderCount}</td>
                            <td class="text-end"><fmt:formatNumber value="${row.revenue}" type="currency" currencySymbol="₫" /></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty rows}">
                        <tr>
                            <td colspan="3" class="text-center text-muted py-4">Không có dữ liệu báo cáo.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
