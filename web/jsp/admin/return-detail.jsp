<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
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

        <form id="returnForm" action="${pageContext.request.contextPath}/admin/return-process" method="POST" enctype="multipart/form-data" class="card border-0 shadow-sm">
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
                        <input class="form-check-input" type="radio" name="conditionStatus" value="late">
                        <span class="form-check-label">Sách quá hạn - Create Fine</span>
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
                                <option value="late">LATE / OVERDUE</option>
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
                        <div class="col-12 mt-3">
                            <label class="form-label fw-bold" id="evidenceLbl">
                                <i class="fas fa-camera"></i> Ảnh bằng chứng <span id="evidenceReqBadge" class="badge bg-danger ms-1">Bắt buộc</span>
                            </label>
                            <input type="file" class="form-control" id="evidenceImage" name="evidenceImage"
                                   accept="image/jpeg,image/png,image/gif,image/jpg">
                            <div class="form-text">Chấp nhận: JPG, PNG, GIF. Tối đa 5MB.</div>
                            <div id="evidenceError" class="text-danger mt-1 d-none" style="font-size:0.875rem;"></div>
                            <div id="evidencePreview" class="mt-2 d-none">
                                <img id="evidencePreviewImg" src="" alt="Preview"
                                     style="max-width:300px;max-height:200px;border-radius:8px;border:2px solid #e5e7eb;object-fit:contain;">
                                <button type="button" class="btn btn-sm btn-outline-danger ms-2" id="evidenceRemoveBtn">
                                    <i class="fas fa-times"></i> Xóa
                                </button>
                            </div>
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
        const evidenceInput = document.getElementById('evidenceImage');
        const evidenceError = document.getElementById('evidenceError');
        const evidencePreview = document.getElementById('evidencePreview');
        const evidencePreviewImg = document.getElementById('evidencePreviewImg');
        const evidenceRemoveBtn = document.getElementById('evidenceRemoveBtn');
        const evidenceReqBadge = document.getElementById('evidenceReqBadge');

        const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/gif'];
        const MAX_SIZE = 5 * 1024 * 1024; // 5MB

        function getSelectedStatus() {
            const sel = document.querySelector('input[name="conditionStatus"]:checked');
            return sel ? sel.value : 'returned';
        }

        function isEvidenceRequired() {
            const s = getSelectedStatus();
            return s === 'damaged' || s === 'lost';
        }

        function syncFineUI() {
            const selected = document.querySelector('input[name="conditionStatus"]:checked');
            const needsFine = selected && (selected.value === 'damaged' || selected.value === 'lost' || selected.value === 'late');
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

            // Update evidence required badge
            if (isEvidenceRequired()) {
                evidenceReqBadge.classList.remove('d-none');
                evidenceReqBadge.textContent = 'Bắt buộc';
            } else if (needsFine) {
                evidenceReqBadge.classList.remove('d-none');
                evidenceReqBadge.textContent = 'Không bắt buộc';
                evidenceReqBadge.className = 'badge bg-secondary ms-1';
            }
            // Clear error when switching
            evidenceError.classList.add('d-none');
        }

        function validateEvidence() {
            evidenceError.classList.add('d-none');
            const files = evidenceInput.files;

            if (isEvidenceRequired() && (!files || files.length === 0)) {
                evidenceError.textContent = 'Vui lòng chọn ảnh bằng chứng cho sách hư hỏng/mất.';
                evidenceError.classList.remove('d-none');
                return false;
            }

            if (files && files.length > 0) {
                const file = files[0];
                if (!ALLOWED_TYPES.includes(file.type)) {
                    evidenceError.textContent = 'Chỉ chấp nhận file ảnh (JPG, PNG, GIF).';
                    evidenceError.classList.remove('d-none');
                    return false;
                }
                if (file.size > MAX_SIZE) {
                    evidenceError.textContent = 'Kích thước ảnh không được vượt quá 5MB.';
                    evidenceError.classList.remove('d-none');
                    return false;
                }
            }
            return true;
        }

        // Preview image
        evidenceInput.addEventListener('change', function () {
            evidenceError.classList.add('d-none');
            const files = this.files;
            if (files && files.length > 0) {
                const file = files[0];
                if (!ALLOWED_TYPES.includes(file.type)) {
                    evidenceError.textContent = 'Chỉ chấp nhận file ảnh (JPG, PNG, GIF).';
                    evidenceError.classList.remove('d-none');
                    evidencePreview.classList.add('d-none');
                    this.value = '';
                    return;
                }
                if (file.size > MAX_SIZE) {
                    evidenceError.textContent = 'Kích thước ảnh không được vượt quá 5MB.';
                    evidenceError.classList.remove('d-none');
                    evidencePreview.classList.add('d-none');
                    this.value = '';
                    return;
                }
                const reader = new FileReader();
                reader.onload = function (e) {
                    evidencePreviewImg.src = e.target.result;
                    evidencePreview.classList.remove('d-none');
                };
                reader.readAsDataURL(file);
            } else {
                evidencePreview.classList.add('d-none');
            }
        });

        // Remove image
        evidenceRemoveBtn.addEventListener('click', function () {
            evidenceInput.value = '';
            evidencePreview.classList.add('d-none');
            evidenceError.classList.add('d-none');
        });

        function normalizeAmount() {
            if (!amountInput || !amountInput.value) return;
            const n = parseFloat(amountInput.value);
            if (isNaN(n) || n <= 0) {
                amountInput.value = '';
                return;
            }
            const normalized = Math.round(n / 1000) * 1000;
            amountInput.value = String(normalized);
        }

        radios.forEach(r => r.addEventListener('change', syncFineUI));
        amountInput.addEventListener('blur', normalizeAmount);
        document.getElementById('returnForm').addEventListener('submit', function (e) {
            normalizeAmount();
            const status = getSelectedStatus();
            if (status === 'damaged' || status === 'lost' || status === 'late') {
                if (!validateEvidence()) {
                    e.preventDefault();
                    evidenceInput.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    return false;
                }
            }
        });
        syncFineUI();
    })();
</script>

<jsp:include page="/includes/admin-shell-end.jsp" />
<jsp:include page="/includes/footer.jsp" />

