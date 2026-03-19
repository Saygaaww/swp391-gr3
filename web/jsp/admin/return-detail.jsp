<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/includes/header.jsp" />
<jsp:include page="/includes/admin-shell-start.jsp" />

<div class="container-fluid px-0">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight:700;">
            <i class="fas fa-undo-alt" style="color:#4f46e5;"></i> Return Book
        </h2>
        <a href="${pageContext.request.contextPath}/admin/return-list" class="btn btn-outline-secondary btn-sm">
            <i class="fas fa-arrow-left"></i> Quay lại danh sách
        </a>
    </div>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">${sessionScope.successMessage}</div>
        <c:remove var="successMessage" scope="session" />
    </c:if>
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger">${sessionScope.errorMessage}</div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <c:if test="${not empty item}">
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body">
                <div class="row g-3">
                    <div class="col-md-6">
                        <div><strong>Book:</strong> ${item.bookTitle}</div>
                        <div><strong>Copy:</strong> ${item.copyCode}</div>
                    </div>
                    <div class="col-md-6">
                        <div><strong>User:</strong> ${item.readerName}</div>
                        <div><strong>Email:</strong> ${item.readerEmail}</div>
                    </div>
                    <div class="col-md-6">
                        <div><strong>Expected Return:</strong>
                            <c:if test="${not empty item.dueDate}">
                                ${item.dueDate.dayOfMonth < 10 ? '0' : ''}${item.dueDate.dayOfMonth}/${item.dueDate.monthValue < 10 ? '0' : ''}${item.dueDate.monthValue}/${item.dueDate.year}
                            </c:if>
                            <c:if test="${empty item.dueDate}">-</c:if>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div><strong>Actual Return:</strong>
                            <c:if test="${not empty item.returnedAt}">
                                ${item.returnedAt.dayOfMonth < 10 ? '0' : ''}${item.returnedAt.dayOfMonth}/${item.returnedAt.monthValue < 10 ? '0' : ''}${item.returnedAt.monthValue}/${item.returnedAt.year}
                            </c:if>
                            <c:if test="${empty item.returnedAt}">Đang chờ xác nhận</c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <form id="returnForm" action="${pageContext.request.contextPath}/admin/return-process" method="POST" class="card border-0 shadow-sm">
            <div class="card-body">
                <input type="hidden" name="borrowItemId" value="${item.borrowItemId}" />
                <input type="hidden" name="readerId" value="${item.readerId}" />
                <input type="hidden" name="returnTo" value="detail" />

                <h5 class="mb-3">Action</h5>
                <div class="d-flex flex-column gap-2 mb-3">
                    <label class="form-check">
                        <input class="form-check-input" type="radio" name="conditionStatus" value="returned" checked>
                        <span class="form-check-label">Sách OK - Confirm Return</span>
                    </label>
                    <label class="form-check">
                        <input class="form-check-input" type="radio" name="conditionStatus" value="damaged">
                        <span class="form-check-label">Sách bị hư hỏng - Create Fine</span>
                    </label>
                    <label class="form-check">
                        <input class="form-check-input" type="radio" name="conditionStatus" value="lost">
                        <span class="form-check-label">Sách bị mất - Create Fine</span>
                    </label>
                </div>

                <div id="fineBlock" class="border rounded p-3 bg-light d-none">
                    <h6 class="mb-3">Fine Details</h6>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">Violation Type</label>
                            <select class="form-select" name="violationType">
                                <option value="damaged">DAMAGE</option>
                                <option value="lost">LOST</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Severity</label>
                            <select class="form-select" name="severity">
                                <option value="Light">Light</option>
                                <option value="Medium">Medium</option>
                                <option value="Heavy">Heavy</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Amount</label>
                            <input type="number" class="form-control" name="fineAmount" min="1000" step="1000" placeholder="50000">
                        </div>
                        <div class="col-12">
                            <label class="form-label">Description</label>
                            <textarea class="form-control" name="description" rows="3" placeholder="Mô tả mức độ hư hỏng hoặc lý do phạt"></textarea>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-footer bg-white d-flex justify-content-end gap-2">
                <button id="confirmNormalBtn" type="submit" class="btn btn-success">
                    <i class="fas fa-check"></i> Confirm Return
                </button>
                <button id="confirmFineBtn" type="submit" class="btn btn-danger d-none">
                    <i class="fas fa-file-invoice-dollar"></i> Create Fine & Confirm Return
                </button>
            </div>
        </form>
    </c:if>
</div>

<script>
    (function () {
        const radios = document.querySelectorAll('input[name="conditionStatus"]');
        const fineBlock = document.getElementById('fineBlock');
        const normalBtn = document.getElementById('confirmNormalBtn');
        const fineBtn = document.getElementById('confirmFineBtn');
        const violationType = document.querySelector('select[name="violationType"]');
        const amountInput = document.querySelector('input[name="fineAmount"]');
        const descriptionInput = document.querySelector('textarea[name="description"]');

        function syncFineUI() {
            const selected = document.querySelector('input[name="conditionStatus"]:checked');
            const needsFine = selected && (selected.value === 'damaged' || selected.value === 'lost');
            fineBlock.classList.toggle('d-none', !needsFine);
            normalBtn.classList.toggle('d-none', needsFine);
            fineBtn.classList.toggle('d-none', !needsFine);

            if (needsFine) {
                violationType.value = selected.value;
                amountInput.required = true;
                descriptionInput.required = true;
            } else {
                amountInput.required = false;
                descriptionInput.required = false;
            }
        }

        function normalizeAmount() {
            if (!amountInput || !amountInput.value)
                return;
            const n = parseFloat(amountInput.value);
            if (isNaN(n) || n <= 0) {
                amountInput.value = '';
                return;
            }
            // Force whole money amount and nearest 1,000 VND.
            const normalized = Math.round(n / 1000) * 1000;
            amountInput.value = String(normalized);
        }

        radios.forEach(r => r.addEventListener('change', syncFineUI));
        amountInput.addEventListener('blur', normalizeAmount);
        document.getElementById('returnForm').addEventListener('submit', normalizeAmount);
        syncFineUI();
    })();
</script>

<jsp:include page="/includes/admin-shell-end.jsp" />
<jsp:include page="/includes/footer.jsp" />
