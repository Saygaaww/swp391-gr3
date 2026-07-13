<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
        <h2 class="fw-bold mb-3">Yêu cầu mượn sách</h2>
        <p class="text-muted mb-4">Xác nhận thông tin và gửi yêu cầu mượn tới thủ thư.</p>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">${sessionScope.successMessage}</div>
            <% session.removeAttribute("successMessage"); %>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">${sessionScope.errorMessage}</div>
            <% session.removeAttribute("errorMessage");%>
        </c:if>

        <c:choose>
            <c:when test="${empty book}">
                <div class="alert alert-warning">
                    Không tìm thấy sách để mượn. Vui lòng chọn sách từ danh sách.
                </div>
                <a class="btn btn-outline-dark" href="<%=ctx%>/books">Quay lại danh sách sách</a>
            </c:when>
            <c:otherwise>
                <div class="card mb-4">
                    <div class="card-body d-flex gap-3">
                        <img src="${not empty book.coverUrl ? book.coverUrl : pageContext.request.contextPath.concat('/images/no-image.jpg')}"
                             alt="${book.title}"
                             style="width:92px;height:130px;object-fit:cover;border-radius:8px;"
                             onerror="this.src='https://via.placeholder.com/92x130/667eea/ffffff?text=📚'">
                        <div class="flex-grow-1">
                            <h5 class="mb-1">${book.title}</h5>
                            <div class="text-muted small">
                                <c:if test="${not empty book.author}">
                                    Tác giả: ${book.author.authorName}
                                </c:if>
                            </div>
                            <div class="mt-2">
                                <a class="btn btn-sm btn-outline-secondary" href="<%=ctx%>/books/detail/${book.bookId}">
                                    Xem chi tiết
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <form method="post" action="<%=ctx%>/customer/borrow-request" class="card">
                    <div class="card-body">
                        <input type="hidden" name="bookId" value="${book.bookId}">

                        <div class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label">Số lượng</label>
                                <input type="number" name="quantity" class="form-control" value="1" min="1" max="5"
                                       oninvalid="this.setCustomValidity('Vui lòng nhập số lượng từ 1 đến 5.')"
                                       oninput="this.setCustomValidity('')">
                                <div class="form-text">Tối đa 5/cuốn trong 1 yêu cầu.</div>
                            </div>
                            <div class="col-md-9">
                                <label class="form-label">Ghi chú (tuỳ chọn)</label>
                                <input type="text" name="note" class="form-control" maxlength="500"
                                       placeholder="Ví dụ: Em cần mượn để học môn...">
                            </div>
                        </div>

                        <div class="row g-3 mt-2">
                            <div class="col-md-6">
                                <label class="form-label">Ngày bắt đầu mượn (Dự kiến) <span class="text-danger">*</span></label>
                                <input type="date" name="expectedStartDate" id="expectedStartDate" class="form-control" required
                                       oninvalid="this.setCustomValidity('Vui lòng chọn ngày bắt đầu mượn.')"
                                       oninput="this.setCustomValidity('')">
                                <div class="form-text">Chọn ngày bạn muốn bắt đầu mượn sách.</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Ngày trả (Dự kiến) <span class="text-danger">*</span></label>
                                <input type="date" name="expectedReturnDate" id="expectedReturnDate" class="form-control" required
                                       oninvalid="this.setCustomValidity('Vui lòng chọn ngày trả hợp lệ (tối đa 5 ngày).')"
                                       oninput="this.setCustomValidity('')">
                                <div class="form-text">Chọn ngày bạn dự định trả sách.</div>
                            </div>
                        </div>

                        <div class="d-flex gap-2 mt-4">
                            <button type="submit" class="btn btn-primary">
                                Gửi yêu cầu mượn
                            </button>
                            <a class="btn btn-outline-dark" href="<%=ctx%>/books">Chọn sách khác</a>
                            <a class="btn btn-outline-secondary" href="<%=ctx%>/customer/borrow-request-status">Xem trạng thái yêu cầu</a>
                        </div>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    (function () {
        const startDateInput = document.getElementById("expectedStartDate");
        const returnDateInput = document.getElementById("expectedReturnDate");

        // Set min date to today
        const today = new Date();
        // Cần convert sang timezone phù hợp nếu máy chủ khác múi giờ, ở đây dùng local date của trình duyệt
        const yyyy = today.getFullYear();
        const mm = String(today.getMonth() + 1).padStart(2, '0');
        const dd = String(today.getDate()).padStart(2, '0');
        const formattedToday = yyyy + "-" + mm + "-" + dd;

        if (startDateInput) {
            startDateInput.min = formattedToday;
        }
        
        function updateReturnDateConstraints() {
            if (startDateInput && startDateInput.value && returnDateInput) {
                const startDate = new Date(startDateInput.value);
                returnDateInput.min = startDateInput.value;
                
                const maxDate = new Date(startDate);
                maxDate.setDate(maxDate.getDate() + 5);
                const max_yyyy = maxDate.getFullYear();
                const max_mm = String(maxDate.getMonth() + 1).padStart(2, '0');
                const max_dd = String(maxDate.getDate()).padStart(2, '0');
                returnDateInput.max = max_yyyy + "-" + max_mm + "-" + max_dd;
                
                // Cho phép trình duyệt tự hiển thị lỗi Validation thay vì tự sửa giá trị
            } else if (returnDateInput) {
                returnDateInput.min = formattedToday;
            }
        }

        // Initialize when page loads
        updateReturnDateConstraints();

        if (startDateInput) {
            startDateInput.addEventListener("change", updateReturnDateConstraints);
        }
        if (returnDateInput) {
            returnDateInput.addEventListener("change", function() {
                this.setCustomValidity('');
            });
        }

        const form = document.querySelector("form.card");
        if (form) {
            form.addEventListener("submit", function(e) {
                if (startDateInput && returnDateInput && startDateInput.value && returnDateInput.value) {
                    const s = new Date(startDateInput.value);
                    const r = new Date(returnDateInput.value);
                    // Reset giờ phút để so sánh ngày chuẩn xác
                    s.setHours(0,0,0,0);
                    r.setHours(0,0,0,0);
                    
                    const diffTime = r.getTime() - s.getTime();
                    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
                    
                    if (diffDays < 0) {
                        e.preventDefault();
                        returnDateInput.setCustomValidity('Ngày trả không được trước ngày mượn.');
                        returnDateInput.reportValidity();
                    } else if (diffDays > 5) {
                        e.preventDefault();
                        returnDateInput.setCustomValidity('Vui lòng chọn ngày trả hợp lệ (tối đa 5 ngày).');
                        returnDateInput.reportValidity();
                    } else {
                        returnDateInput.setCustomValidity('');
                    }
                }
            });
        }
    })();
</script>
<%@include file="/includes/footer.jsp" %>

