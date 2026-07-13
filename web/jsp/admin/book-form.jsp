<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER); %>

<jsp:include page="/includes/header.jsp" />

<main class="container py-5 my-5" style="min-height: 70vh;">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0" style="font-weight: 700;">
            <i class="fas fa-book" style="color:#4f46e5;"></i> ${mode == 'edit' ? 'Sửa sách' : 'Thêm sách mới'}
        </h2>
    </div>
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none"><i class="fas fa-home"></i> Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/book-list" class="text-decoration-none">Danh sách sách</a></li>
            <li class="breadcrumb-item active">${mode == 'edit' ? 'Sửa' : 'Thêm'}</li>
        </ol>
    </nav>
    <c:if test="${not empty error}">
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div>
    </c:if>

    <div class="card shadow-sm border-0">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/book-form" method="post" enctype="multipart/form-data">
                <c:if test="${mode == 'edit'}">
                    <input type="hidden" name="bookId" value="${book.bookId}">
                </c:if>
                <input type="hidden" name="oldCoverUrl" value="${book.coverUrl}">
                <input type="hidden" name="oldContentPath" value="${book.contentPath}">

                <div class="row g-3">
                    <div class="col-12">
                        <label class="form-label">Tiêu đề sách <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" value="${book.title}" required maxlength="500">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Tóm tắt</label>
                        <textarea name="summary" class="form-control" rows="3">${book.summary}</textarea>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Mô tả</label>
                        <textarea name="description" class="form-control" rows="4">${book.description}</textarea>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Ảnh bìa (JPG, PNG, GIF)</label>
                        <input type="file" name="coverFile" class="form-control" accept=".jpg,.jpeg,.png,.gif">
                        <c:if test="${not empty book.coverUrl}">
                            <small class="text-muted">Hiện tại: ${book.coverUrl}</small>
                        </c:if>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">File nội dung (PDF)</label>
                        <input type="file" name="contentFile" class="form-control" accept=".pdf">
                        <c:if test="${not empty book.contentPath}">
                            <small class="text-muted">Hiện tại: ${book.contentPath}</small>
                        </c:if>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Giá</label>
                        <input type="number" name="price" class="form-control" value="${book.price != null ? book.price : ''}" min="0" step="1000">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Tiền tệ</label>
                        <select name="currency" class="form-select">
                            <option value="VND" <c:if test="${book.currency == 'VND'}">selected</c:if>>VND</option>
                            <option value="USD" <c:if test="${book.currency == 'USD'}">selected</c:if>>USD</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Tổng trang</label>
                        <input type="number" name="totalPages" class="form-control" value="${book.totalPages != null ? book.totalPages : ''}" min="0">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Trang xem trước</label>
                        <input type="number" name="previewPages" class="form-control" value="${book.previewPages != null ? book.previewPages : ''}" min="0">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="active" <c:if test="${book.status == 'active'}">selected</c:if>>Active</option>
                            <option value="inactive" <c:if test="${book.status == 'inactive'}">selected</c:if>>Inactive</option>
                            <option value="draft" <c:if test="${book.status == 'draft'}">selected</c:if>>Draft</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Tác giả</label>
                        <select name="authorId" class="form-select">
                            <option value="">-- Chọn tác giả --</option>
                            <c:forEach var="a" items="${authors}">
                                <option value="${a.authorId}" <c:if test="${book.authorId != null && book.authorId == a.authorId}">selected</c:if>>${a.authorName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Danh mục</label>
                        <select name="categoryId" class="form-select">
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}" <c:if test="${book.categoryId != null && book.categoryId == c.categoryId}">selected</c:if>>${c.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary" style="background:#1a1a2e; border-color:#1a1a2e;"><i class="fas fa-save"></i> Lưu</button>
                        <a href="${pageContext.request.contextPath}/admin/book-list" class="btn btn-outline-secondary">Hủy</a>
                    </div>
                </div>
            </form>

<script>
    document.querySelector('form').addEventListener('submit', function(e) {
        var errors = [];
        
        var title = document.querySelector('input[name="title"]');
        if (!title.value.trim()) {
            errors.push('Tên sách không được để trống');
            title.style.borderColor = '#dc3545';
        } else if (title.value.trim().length > 500) {
            errors.push('Tên sách không được quá 500 ký tự');
            title.style.borderColor = '#dc3545';
        } else {
            title.style.borderColor = '#28a745';
        }
        
        var price = document.querySelector('input[name="price"]');
        if (!price.value || price.value.trim() === '' || price.value === '0.00' || price.value === '0') {
            errors.push('Vui lòng nhập giá sách');
            price.style.borderColor = '#dc3545';
        } else if (parseFloat(price.value) < 0) {
            errors.push('Gi\n\
á tiền không được âm');
            price.style.borderColor = '#dc3545';
        } else {
            price.style.borderColor = '#28a745';
        }
        
        var totalPages = document.querySelector('input[name="totalPages"]');
        if (!totalPages.value || totalPages.value.trim() === '') {
            errors.push('Vui lòng nhập tổng số trang');
            totalPages.style.borderColor = '#dc3545';
        } else if (parseInt(totalPages.value) < 1) {
            errors.push('Số trang phải lớn hơn 0');
            totalPages.style.borderColor = '#dc3545';
        } else {
            totalPages.style.borderColor = '#28a745';
        }
        
        var previewPages = document.querySelector('input[name="previewPages"]');
        if (previewPages.value && totalPages.value) {
            if (parseInt(previewPages.value) < 0) {
                errors.push('Số trang xem trước không được âm');
                previewPages.style.borderColor = '#dc3545';
            } else if (parseInt(previewPages.value) > parseInt(totalPages.value)) {
                errors.push('Số trang xem trước không được lớn hơn tổng số trang');
                previewPages.style.borderColor = '#dc3545';
            } else {
                previewPages.style.borderColor = '#28a745';
            }
        }
        
        var authorId = document.querySelector('select[name="authorId"]');
        if (!authorId.value) {
            errors.push('Vui lòng chọn tác giả');
            authorId.style.borderColor = '#dc3545';
        } else {
            authorId.style.borderColor = '#28a745';
        }
        
        var categoryId = document.querySelector('select[name="categoryId"]');
        if (!categoryId.value) {
            errors.push('Vui lòng chọn danh mục');
            categoryId.style.borderColor = '#dc3545';
        } else {
            categoryId.style.borderColor = '#28a745';
        }
        
        var coverFile = document.querySelector('input[name="coverFile"]');
        if (coverFile && coverFile.files.length > 0) {
            var coverExt = coverFile.files[0].name.split('.').pop().toLowerCase();
            if (!['jpg','jpeg','png','gif'].includes(coverExt)) {
                errors.push('Ảnh bìa chỉ chấp nhận JPG, PNG, GIF');
                coverFile.style.borderColor = '#dc3545';
            } else if (coverFile.files[0].size > 5 * 1024 * 1024) {
                errors.push('Ảnh bìa không được quá 5MB');
                coverFile.style.borderColor = '#dc3545';
            } else {
                coverFile.style.borderColor = '#28a745';
            }
        }
        
        // Kiem tra file PDF (neu co chon)
        var contentFile = document.querySelector('input[name="contentFile"]');
        if (contentFile && contentFile.files.length > 0) {
            var pdfExt = contentFile.files[0].name.split('.').pop().toLowerCase();
            if (pdfExt !== 'pdf') {
                errors.push('File nội dung chỉ chấp nhận PDF');
                contentFile.style.borderColor = '#dc3545';
            } else if (contentFile.files[0].size > 50 * 1024 * 1024) {
                errors.push('File PDF không được quá 50MB');
                contentFile.style.borderColor = '#dc3545';
            } else {
                contentFile.style.borderColor = '#28a745';
            }
        }
        
        if (errors.length > 0) {
            e.preventDefault();
            
            var alertDiv = document.querySelector('.alert-danger.validation-errors');
            if (!alertDiv) {
                alertDiv = document.createElement('div');
                alertDiv.className = 'alert alert-danger validation-errors';
                document.querySelector('.card-body').prepend(alertDiv);
            }
            alertDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i> <strong>Vui lòng sửa các lỗi sau:</strong><br>' + errors.join('<br>');
            alertDiv.scrollIntoView({behavior: 'smooth', block: 'center'});
        }
    });
    
    // Xoa vien do khi nguoi dung bat dau nhap lai
    document.querySelectorAll('input, select, textarea').forEach(function(el) {
        el.addEventListener('input', function() {
            this.style.borderColor = '#e0e0e0';
        });
        el.addEventListener('change', function() {
            this.style.borderColor = '#e0e0e0';
        });
    });
</script>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />

