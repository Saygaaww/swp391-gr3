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
            <i class="fas fa-list" style="color:#4f46e5;"></i> Lịch sử Mượn / Trả Sách
        </h2>
    </div>

    <!-- Table of Borrowed Items -->
    <div class="return-card">
        <div class="table-responsive">
            <c:choose>
                <c:when test="${empty items}">
                    <div class="text-center p-5 text-muted">
                        <i class="fas fa-inbox fa-3x mb-3 text-light"></i>
                        <h5>Không có dữ liệu mượn/trả sách</h5>
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
                                <th>Hạn trả</th>
                                <th>Ngày trả (Thực tế)</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="req" items="${items}">
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
                                        <c:choose>
                                            <c:when test="${not empty req.returnedAt}">
                                                <span class="text-success fw-bold">
                                                    ${req.returnedAt.dayOfMonth < 10 ? '0' : ''}${req.returnedAt.dayOfMonth}-${req.returnedAt.monthValue < 10 ? '0' : ''}${req.returnedAt.monthValue}-${req.returnedAt.year}
                                                </span>
                                            </c:when>
                                            <c:otherwise>—</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge 
                                        ${req.status == 'borrowed' ? 'bg-primary' : (req.status == 'return_requested' ? 'bg-warning text-dark' : (req.status == 'returned' ? 'bg-success' : 'bg-secondary'))}">
                                            ${req.status}
                                        </span>
                                    </td>
                                    <td>
                                        <c:if test="${req.status == 'return_requested'}">
                                            <form action="${pageContext.request.contextPath}/admin/return-process" method="POST" class="d-inline">
                                                <input type="hidden" name="borrowItemId" value="${req.borrowItemId}" />
                                                <input type="hidden" name="readerId" value="${req.readerId}" />
                                                
                                                <div class="mb-2">
                                                    <select name="conditionStatus" class="form-select form-select-sm" style="width: 150px;">
                                                        <option value="returned">Bình thường</option>
                                                        <option value="damaged">Hư hỏng sách</option>
                                                        <option value="lost">Làm mất sách</option>
                                                    </select>
                                                </div>
                                                
                                                <div class="mb-2">
                                                    <select name="fineTypeId" class="form-select form-select-sm" style="width: 150px;">
                                                        <option value="0">Không phạt</option>
                                                        <option value="1">Quá hạn (5.000đ/ngày)</option>
                                                        <option value="2">Mất sách (150% giá sách)</option>
                                                        <option value="3">Hư hỏng (50% giá sách)</option>
                                                    </select>
                                                </div>
                                                
                                                <div class="mb-2">
                                                    <input type="number" name="fineAmount" class="form-control form-control-sm" placeholder="Số tiền phạt" style="width: 150px;">
                                                </div>

                                                <button type="submit" class="btn btn-sm btn-success" 
                                                        onclick="return confirm('Xác nhận cập nhật trạng thái sách này?');">
                                                    <i class="fas fa-check"></i> Xác nhận
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
</main>

<jsp:include page="/includes/footer.jsp" />
