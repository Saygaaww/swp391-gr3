<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/admin-shell-start.jsp" />
<style>
    .header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 16px;
    }
    .header h1 {
        margin: 0;
        font-size: 24px;
    }
    .subtle {
        color: #666;
        font-size: 14px;
        margin-top: 4px;
    }
    .actions {
        display: flex;
        gap: 8px;
        align-items: center;
        flex-wrap: wrap;
        margin-bottom: 16px;
    }
    .actions form {
        display: flex;
        gap: 8px;
        align-items: center;
    }
    .btn {
        border: 1px solid #d6d9e0;
        background: #fff;
        border-radius: 8px;
        padding: 8px 12px;
        cursor: pointer;
    }
    .btn.primary {
        background: #1f6feb;
        color: #fff;
        border-color: #1f6feb;
    }
    .btn.warn {
        background: #f59e0b;
        color: #fff;
        border-color: #f59e0b;
    }
    .btn.good {
        background: #16a34a;
        color: #fff;
        border-color: #16a34a;
    }
    .btn.danger {
        background: #dc2626;
        color: #fff;
        border-color: #dc2626;
    }
    .btn.link {
        text-decoration: none;
        display: inline-block;
    }
    .card {
        background: #fff;
        border: 1px solid #eceff4;
        border-radius: 12px;
        padding: 12px;
        margin-bottom: 16px;
    }
    .alert {
        padding: 10px 12px;
        border-radius: 8px;
        margin-bottom: 12px;
    }
    .alert.success {
        background: #ecfdf3;
        border: 1px solid #b9f0d0;
        color: #166534;
    }
    .alert.error {
        background: #fef2f2;
        border: 1px solid #fecaca;
        color: #991b1b;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        border-radius: 12px;
        overflow: hidden;
    }
    th, td {
        padding: 10px;
        border-bottom: 1px solid #eef1f5;
        text-align: left;
        font-size: 14px;
    }
    th {
        background: #f8fafc;
        color: #475569;
    }
    tr:hover td {
        background: #fcfdff;
    }
    .badge {
        padding: 3px 8px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 600;
        display: inline-block;
    }
    .st-waiting {
        background: #e5e7eb;
        color: #374151;
    }
    .st-ready {
        background: #fef3c7;
        color: #92400e;
    }
    .st-expired {
        background: #fee2e2;
        color: #991b1b;
    }
    .st-fulfilled {
        background: #dcfce7;
        color: #166534;
    }
    .st-cancelled {
        background: #e2e8f0;
        color: #334155;
    }
    .row-actions {
        display: flex;
        gap: 6px;
        justify-content: flex-end;
    }
    .muted {
        color: #94a3b8;
    }
    .right {
        text-align: right;
    }
    select, input[type="number"] {
        border: 1px solid #d6d9e0;
        border-radius: 8px;
        padding: 7px 9px;
    }
</style>
<div class="container-fluid px-0">
    <div class="header">
        <div>
            <h1>Manage Reservations</h1>
            <div class="subtle">Queue fairness by created time. READY slot holds for 24h.</div>
        </div>
        <a class="btn link" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fas fa-arrow-left"></i> Back to dashboard
        </a>
    </div>

    <div class="card">
        <strong><i class="fas fa-bell"></i> Librarian notice:</strong>
        <span>${booksNeedAssignCount} book(s) currently have waiting queue and available stock to assign.</span>
    </div>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert success">${sessionScope.successMessage}</div>
        <% session.removeAttribute("successMessage"); %>
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert error">${sessionScope.errorMessage}</div>
        <% session.removeAttribute("errorMessage");%>
    </c:if>

    <div class="actions">
        <form method="get" action="${pageContext.request.contextPath}/admin/reservations">
            <label for="status">Filter</label>
            <select id="status" name="status">
                <option value="ALL" ${selectedStatus == 'ALL' ? 'selected' : ''}>ALL</option>
                <option value="WAITING" ${selectedStatus == 'WAITING' ? 'selected' : ''}>WAITING</option>
                <option value="READY" ${selectedStatus == 'READY' ? 'selected' : ''}>READY</option>
                <option value="EXPIRED" ${selectedStatus == 'EXPIRED' ? 'selected' : ''}>EXPIRED</option>
                <option value="FULFILLED" ${selectedStatus == 'FULFILLED' ? 'selected' : ''}>FULFILLED</option>
                <option value="CANCELLED" ${selectedStatus == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
            </select>
            <label for="bookId">Book ID</label>
            <input id="bookId" type="number" name="bookId" value="${selectedBookId}" min="1" />
            <button class="btn primary" type="submit">Apply</button>
        </form>
    </div>

    <c:choose>
        <c:when test="${empty reservations}">
            <div class="card muted">No reservations found.</div>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                    <tr>
                        <th>Book</th>
                        <th>Queue</th>
                        <th>User</th>
                        <th>Status</th>
                        <th>Created</th>
                        <th>Expire</th>
                        <th class="right">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${reservations}">
                        <tr>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/reservations?bookId=${r.bookId}" class="btn link">${r.bookTitle}</a>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty r.queuePosition}">#${r.queuePosition}</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${r.readerName}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${r.status == 'WAITING'}"><span class="badge st-waiting">WAITING</span></c:when>
                                    <c:when test="${r.status == 'READY'}"><span class="badge st-ready">READY</span></c:when>
                                    <c:when test="${r.status == 'EXPIRED'}"><span class="badge st-expired">EXPIRED</span></c:when>
                                    <c:when test="${r.status == 'FULFILLED'}"><span class="badge st-fulfilled">FULFILLED</span></c:when>
                                    <c:otherwise><span class="badge st-cancelled">${r.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>${r.queuedAt}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty r.expiresAt}">
                                        ${r.expiresAt}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="right">
                                <div class="row-actions">
                                    <c:if test="${r.status == 'WAITING'}">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/reservations">
                                            <input type="hidden" name="action" value="assign_next" />
                                            <input type="hidden" name="bookId" value="${r.bookId}" />
                                            <input type="hidden" name="status" value="${selectedStatus}" />
                                            <input type="hidden" name="filterBookId" value="${selectedBookId}" />
                                            <button type="submit" class="btn warn">Assign</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${r.status == 'READY'}">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/reservations">
                                            <input type="hidden" name="action" value="confirm_borrow" />
                                            <input type="hidden" name="reservationId" value="${r.reservationId}" />
                                            <input type="hidden" name="status" value="${selectedStatus}" />
                                            <input type="hidden" name="filterBookId" value="${selectedBookId}" />
                                            <button type="submit" class="btn good">Confirm Borrow</button>
                                        </form>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/reservations">
                                            <input type="hidden" name="action" value="skip" />
                                            <input type="hidden" name="reservationId" value="${r.reservationId}" />
                                            <input type="hidden" name="status" value="${selectedStatus}" />
                                            <input type="hidden" name="filterBookId" value="${selectedBookId}" />
                                            <button type="submit" class="btn danger">Skip</button>
                                        </form>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
<jsp:include page="/includes/admin-shell-end.jsp" />
<jsp:include page="/includes/footer.jsp" />
