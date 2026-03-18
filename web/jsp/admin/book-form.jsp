<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
