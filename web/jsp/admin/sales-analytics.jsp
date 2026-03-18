<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER);%>

<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/admin-shell-start.jsp" />

<style>
    .stat-card {
        background: #fff;
        border-radius: 10px;
        padding: 20px;
        border: 1px solid #e5e7eb;
        box-shadow: 0 1px 6px rgba(0,0,0,0.04);
        display: flex;
        align-items: center;
        gap: 14px;
    }
    .stat-icon {
        width: 48px;
        height: 48px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
    }
    .s1 { background: #eef2ff; color: #4f46e5; }
    .s2 { background: #dcfce7; color: #16a34a; }
    .stat-info h3 { font-size: 24px; font-weight: 800; color: #1a1a2e; margin: 0; }
    .stat-info p  { font-size: 13px; color: #6b7280; margin: 0; }
</style>

<div class="container-fluid px-0">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight: 700;">
            <i class="fas fa-chart-line" style="color:#4f46e5;"></i> Sales Analytics
        </h2>
    </div>

    <!-- Summary stats -->
    <div class="row mb-4">
        <div class="col-md-6">
            <div class="stat-card border-0 shadow-sm">
                <div class="stat-icon s1"><i class="fas fa-shopping-cart"></i></div>
                <div class="stat-info">
                    <h3>${totalVolume}</h3>
                    <p>Total Paid Orders Volume</p>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="stat-card border-0 shadow-sm">
                <div class="stat-icon s2"><i class="fas fa-hand-holding-usd"></i></div>
                <div class="stat-info">
                    <h3><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$ " /></h3>
                    <p>Total Revenue (Paid/Delivered)</p>
                </div>
            </div>
        </div>
    </div>

    <h4 class="mb-3 text-secondary">Top Selling Books</h4>
    <div class="card shadow-sm border-0">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-3">ID</th>
                            <th>Book Title</th>
                            <th>Author</th>
                            <th class="text-center">Copies Sold</th>
                            <th class="text-end pe-3">Revenue Gen.</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="book" items="${topBooks}">
                            <tr>
                                <td class="ps-3"><strong>#${book.bookId}</strong></td>
                                <td>${book.title}</td>
                                <td>${book.authorName}</td>
                                <td class="text-center"><span class="badge bg-primary rounded-pill px-3">${book.totalQuantity}</span></td>
                                <td class="text-end pe-3"><fmt:formatNumber value="${book.totalRevenue}" type="currency" currencySymbol="$" /></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty topBooks}">
                            <tr>
                                <td colspan="5" class="text-center p-4 text-muted">No sales data available.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/admin-shell-end.jsp" />
<jsp:include page="/includes/footer.jsp" />
