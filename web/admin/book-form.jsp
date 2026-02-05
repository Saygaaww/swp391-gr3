<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${mode == 'edit' ? 'Sửa' : 'Thêm'} sách - Admin</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f0f0f0;
                min-height: 100vh;
            }

            .header {
                color: white;
                padding: 20px 40px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            }
            .header-add {
                background: #5a5a5a;
            }
            .header-edit {
                background: #d39e00;
            }
            .header h1 {
                font-size: 28px;
                font-weight: 600;
            }

            .container {
                max-width: 900px;
                margin: 30px auto;
                padding: 0 20px;
            }

            .card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.08);
                padding: 40px;
            }

            .card-header {
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 3px solid #888;
            }
            .card-header-edit {
                border-bottom-color: #ffc107;
            }
            .card-header h2 {
                font-size: 24px;
                color: #333;
                margin-bottom: 10px;
            }
            .card-header p {
                color: #666;
                font-size: 14px;
            }

            .mode-badge {
                display: inline-block;
                padding: 8px 20px;
                border-radius: 20px;
                font-size: 14px;
                font-weight: 600;
                margin-bottom: 15px;
            }
            .mode-badge-add {
                background: #5a5a5a;
                color: #fff;
            }
            .mode-badge-edit {
                background: #ffc107;
                color: #000;
            }

            .book-id-badge {
                display: inline-block;
                background: #888;
                color: white;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                margin-left: 10px;
            }

            .form-group {
                margin-bottom: 25px;
            }
            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #333;
                font-size: 14px;
            }
            .form-group label span {
                color: #dc3545;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e0e0e0;
                border-radius: 8px;
                font-size: 14px;
                font-family: inherit;
                transition: all 0.3s;
            }

            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {
                outline: none;
                border-color: #888;
                box-shadow: 0 0 0 3px rgba(136,136,136,0.1);
            }

            .form-group textarea {
                resize: vertical;
                min-height: 100px;
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            .alert {
                padding: 15px 20px;
                border-radius: 8px;
                margin-bottom: 20px;
            }
            .alert-error {
                background: #f8d7da;
                border: 1px solid #f5c6cb;
                color: #721c24;
            }

            .form-actions {
                display: flex;
                gap: 15px;
                margin-top: 30px;
                padding-top: 30px;
                border-top: 2px solid #f0f0f0;
            }

            .btn {
                padding: 14px 30px;
                border: none;
                border-radius: 8px;
                font-size: 15px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                text-decoration: none;
                display: inline-block;
            }
            .btn-primary {
                background: #888;
                color: white;
                box-shadow: 0 4px 15px rgba(136,136,136,0.3);
            }
            .btn-primary-edit {
                background: #ffc107;
                color: #000;
                box-shadow: 0 4px 15px rgba(255,193,7,0.3);
            }
            .btn-primary:hover, .btn-primary-edit:hover {
                transform: translateY(-2px);
            }
            .btn-secondary {
                background: #6c757d;
                color: white;
            }
            .btn-secondary:hover {
                background: #5a6268;
            }

            .form-help {
                font-size: 12px;
                color: #666;
                margin-top: 5px;
            }

            @media (max-width: 768px) {
                .form-row {
                    grid-template-columns: 1fr;
                }
                .form-actions {
                    flex-direction: column;
                }
            }
        </style>
    </head>
    <body>
        <div class="header ${mode == 'edit' ? 'header-edit' : 'header-add'}">
            <h1>${mode == 'edit' ? 'Sửa thông tin sách' : 'Thêm sách mới'}</h1>
        </div>

        <div class="container">
            <div class="card">
                <div class="card-header ${mode == 'edit' ? 'card-header-edit' : ''}">
                    <div class="mode-badge ${mode == 'edit' ? 'mode-badge-edit' : 'mode-badge-add'}">
                        ${mode == 'edit' ? 'CHẾ ĐỘ SỬA' : 'CHẾ ĐỘ THÊM MỚI'}
                    </div>
                    <h2>
                        <c:choose>
                            <c:when test="${mode == 'edit'}">
                                Chỉnh sửa: ${book.title}
                                <span class="book-id-badge">ID: ${book.bookId}</span>
                            </c:when>
                            <c:otherwise>
                                Thêm sách mới vào hệ thống
                            </c:otherwise>
                        </c:choose>
                    </h2>
                    <p>${mode == 'edit' ? 'Cập nhật thông tin sách' : 'Điền đầy đủ thông tin để thêm sách mới'}</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-error"> ${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/book-form" method="post" 
                      enctype="multipart/form-data">

                    <c:if test="${mode == 'edit'}">
                        <input type="hidden" name="bookId" value="${book.bookId}">
                    </c:if>

                    <div class="form-group">
                        <label>Tên sách <span>*</span></label>
                        <input type="text" name="title" value="${book.title}" required placeholder="Nhập tên sách...">
                    </div>

                    <div class="form-group">
                        <label>Tóm tắt</label>
                        <textarea name="summary" placeholder="Tóm tắt ngắn gọn...">${book.summary}</textarea>
                        <div class="form-help">Mô tả ngắn gọn (1-2 câu)</div>
                    </div>

                    <div class="form-group">
                        <label>Mô tả chi tiết</label>
                        <textarea name="description" rows="5" placeholder="Mô tả chi tiết...">${book.description}</textarea>
                    </div>

                    <!-- Upload ảnh bìa -->
                    <div class="form-group">
                        <label>Ảnh bìa</label>

                        <c:if test="${mode == 'edit' && not empty book.coverUrl}">
                            <div style="margin-bottom: 10px;">
                                <img src="${pageContext.request.contextPath}/${book.coverUrl}" 
                                     alt="Ảnh bìa hiện tại" 
                                     style="max-width: 150px; max-height: 200px; border: 1px solid #ddd; border-radius: 8px;">
                                <p style="font-size: 12px; color: #666; margin-top: 5px;">Ảnh hiện tại</p>
                            </div>
                        </c:if>

                        <input type="file" name="coverFile" accept="image/*" class="form-control"
                               style="padding: 10px;">

                        <input type="hidden" name="oldCoverUrl" value="${book.coverUrl}">

                        <div class="form-help">Chọn file ảnh (JPG, PNG, GIF). Tối đa 5MB</div>
                    </div>

                    <div class="form-group">
                        <label>Đường dẫn file PDF</label>
                        <input type="text" name="contentPath" value="${book.contentPath}" placeholder="/books/filename.pdf">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Giá</label>
                            <input type="number" name="price" step="0.01" min="0" value="${book.price}" placeholder="0.00">
                        </div>
                        <div class="form-group">
                            <label>Đơn vị tiền tệ</label>
                            <select name="currency">
                                <option value="VND" ${book.currency == 'VND' || empty book.currency ? 'selected' : ''}>VND</option>
                                <option value="USD" ${book.currency == 'USD' ? 'selected' : ''}>USD</option>
                                <option value="EUR" ${book.currency == 'EUR' ? 'selected' : ''}>EUR</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Tổng số trang</label>
                            <input type="number" name="totalPages" min="1" value="${book.totalPages > 0 ? book.totalPages : ''}" placeholder="250">
                        </div>
                        <div class="form-group">
                            <label>Số trang xem trước</label>
                            <input type="number" name="previewPages" min="0" value="${book.previewPages > 0 ? book.previewPages : ''}" placeholder="20">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Tác giả</label>
                            <select name="authorId">
                                <option value="">-- Chọn tác giả --</option>
                                <c:forEach var="author" items="${authors}">
                                    <option value="${author.authorId}" ${book.authorId == author.authorId ? 'selected' : ''}>
                                        ${author.authorName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Danh mục</label>
                            <select name="categoryId">
                                <option value="">-- Chọn danh mục --</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.categoryId}" ${book.categoryId == category.categoryId ? 'selected' : ''}>
                                        ${category.categoryName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Trạng thái</label>
                        <select name="status">
                            <option value="active" ${book.status == 'active' || empty book.status ? 'selected' : ''}>Active</option>
                            <option value="inactive" ${book.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn ${mode == 'edit' ? 'btn-primary-edit' : 'btn-primary'}">
                            ${mode == 'edit' ? 'Lưu thay đổi' : 'Thêm sách'}
                        </button>
                        <a href="${pageContext.request.contextPath}/books-list" class="btn btn-secondary">Quay lại</a>
                    </div>
                </form>
            </div>
        </div>
    </body>
</html>