<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="/includes/header.jsp" />

<style>
    .return-card {
        background: #fff;
        border-radius: 10px;
        padding: 20px;
        border: 1px solid #e5e7eb;
        box-shadow: 0 1px 6px rgba(0,0,0,0.04);
        margin-bottom: 20px;
    }
</style>

<main class="container py-5 my-5" style="min-height: 70vh;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight: 700;">
            <i class="fas fa-undo" style="color:#4f46e5;"></i> Duyệt trả sách
        </h2>
    </div>

    <!-- Feedback messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i> ${sessionScope.successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i> ${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Table of Return Requests -->
    <div class="return-card">
        <div class="table-responsive">
            <c:choose>
                <c:when test="${empty returnRequests}">
                    <div class="text-center p-5 text-muted">
                        <i class="fas fa-inbox fa-3x mb-3 text-light"></i>
                        <h5>Không có yêu cầu trả sách nào</h5>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Đọc giả</th>
                                <th>Sách</th>
                                <th>Mã bản sao</th>
                                <th>Ngày trả dự kiến</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="req" items="${returnRequests}">
                                <tr>
                                    <td><strong>${req.borrowItemId}</strong></td>
                                    <td>
                                        <strong>${req.readerName}</strong><br/>
                                        <small class="text-muted">${req.readerEmail}</small>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <c:if test="${not empty req.bookCoverUrl}">
                                                <img src="${req.bookCoverUrl}" alt="cover"
                                                     style="width:40px;height:55px;object-fit:cover;border-radius:4px;border:1px solid #ddd;">
                                            </c:if>
                                            <div class="text-truncate" style="max-width:200px;" title="${req.bookTitle}">
                                                ${req.bookTitle}
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge bg-secondary">${req.copyCode}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty req.dueDate}">
                                                <span class="text-danger fw-bold">
                                                    ${req.dueDate.dayOfMonth < 10 ? '0' : ''}${req.dueDate.dayOfMonth}-${req.dueDate.monthValue < 10 ? '0' : ''}${req.dueDate.monthValue}-${req.dueDate.year}
                                                </span>
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/return-process" method="POST" class="d-inline">
                                            <input type="hidden" name="borrowItemId" value="${req.borrowItemId}" />
                                            <button type="submit" class="btn btn-sm btn-success" 
                                                    onclick="return confirm('Xác nhận đọc giả ${req.readerName} đã trả sách này?');">
                                                <i class="fas fa-check"></i> Xác nhận đã trả
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
