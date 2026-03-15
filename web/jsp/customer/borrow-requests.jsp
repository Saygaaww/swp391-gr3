<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/includes/header.jsp" %>
<% String ctx = request.getContextPath(); %>
<%@include file="/includes/navbar.jsp" %>
<style>
    .user-home {
        background: #fff;
        min-height: 100vh;
        color: #333;
    }
</style>
<div class="user-home">
    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h2 class="fw-bold mb-1">Trạng thái yêu cầu mượn</h2>
                <p class="text-muted mb-0">Theo dõi pending/approved/rejected và ghi chú của thủ thư.</p>
            </div>
            <a class="btn btn-outline-primary" href="<%=ctx%>/books">Mượn thêm sách</a>
        </div>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">${sessionScope.successMessage}</div>
            <% session.removeAttribute("successMessage"); %>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">${sessionScope.errorMessage}</div>
            <% session.removeAttribute("errorMessage"); %>
        </c:if>

        <c:choose>
            <c:when test="${empty requests}">
                <div class="alert alert-info">Bạn chưa có yêu cầu mượn nào.</div>
            </c:when>
            <c:otherwise>
                <div class="accordion" id="reqAcc">
                    <c:forEach var="r" items="${requests}" varStatus="st">
                        <div class="accordion-item mb-2">
                            <h2 class="accordion-header" id="h${st.index}">
                                <button class="accordion-button ${st.index==0 ? '' : 'collapsed'}" type="button"
                                        data-bs-toggle="collapse" data-bs-target="#c${st.index}">
                                    <div class="w-100 d-flex justify-content-between align-items-center">
                                        <div>
                                            <strong>#${r.requestId}</strong>
                                            <span class="text-muted ms-2">
                                                <c:if test="${not empty r.requestedAt}">
                                                    (${r.requestedAt})
                                                </c:if>
                                            </span>
                                        </div>
                                        <span class="badge bg-${r.status=='approved'?'success':(r.status=='rejected'?'danger':(r.status=='pending'?'warning':'secondary'))}">
                                            ${r.status}
                                        </span>
                                    </div>
                                </button>
                            </h2>
                            <div id="c${st.index}" class="accordion-collapse collapse ${st.index==0 ? 'show' : ''}"
                                 data-bs-parent="#reqAcc">
                                <div class="accordion-body">
                                    <c:if test="${not empty r.decisionNote}">
                                        <div class="alert alert-${r.status=='rejected'?'danger':'secondary'}">
                                            <strong>Ghi chú thủ thư:</strong> ${r.decisionNote}
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty r.note}">
                                        <p class="mb-2"><strong>Ghi chú của bạn:</strong> ${r.note}</p>
                                    </c:if>

                                    <c:if test="${not empty r.items}">
                                        <div class="table-responsive">
                                            <table class="table table-sm align-middle">
                                                <thead>
                                                <tr>
                                                    <th>Sách</th>
                                                    <th class="text-end">Số lượng</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:forEach var="it" items="${r.items}">
                                                    <tr>
                                                        <td>
                                                            <a href="<%=ctx%>/books/detail/${it.bookId}" class="text-decoration-none">
                                                                ${it.bookTitle}
                                                            </a>
                                                        </td>
                                                        <td class="text-end">${it.quantity}</td>
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@include file="/includes/footer.jsp" %>
