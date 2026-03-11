<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${pageTitle}</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/additional-styles.css?v=2">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <style>
                    .form-card {
                        background: #ffffff;
                        border: 1px solid #e5e7eb;
                        border-radius: 20px;
                        padding: 2.5rem;
                        margin: 2rem auto;
                        max-width: 900px;
                        box-shadow: 0 2px 16px rgba(0, 0, 0, 0.07);
                    }

                    .form-grid {
                        display: grid;
                        grid-template-columns: 1fr 1fr;
                        gap: 1.5rem;
                    }

                    .form-group {
                        display: flex;
                        flex-direction: column;
                        gap: 0.5rem;
                    }

                    .form-group.full-width {
                        grid-column: 1 / -1;
                    }

                    .form-label {
                        font-size: 0.9rem;
                        font-weight: 600;
                        color: #374151;
                    }

                    .form-control {
                        background: #f9fafb;
                        border: 1.5px solid #d1d5db;
                        border-radius: 10px;
                        color: #111827;
                        padding: 0.75rem 1rem;
                        font-size: 0.95rem;
                        transition: border-color 0.2s;
                    }

                    .form-control:focus {
                        outline: none;
                        border-color: #7c3aed;
                        background: #ffffff;
                    }

                    .form-control option {
                        background: #ffffff;
                        color: #111827;
                    }

                    select.form-control {
                        cursor: pointer;
                    }

                    textarea.form-control {
                        resize: vertical;
                        min-height: 100px;
                    }

                    .btn-submit {
                        background: linear-gradient(135deg, #7c3aed, #a78bfa);
                        color: white;
                        border: none;
                        padding: 0.85rem 2rem;
                        border-radius: 12px;
                        font-size: 1rem;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .btn-submit:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 25px rgba(124, 58, 237, 0.4);
                    }

                    .btn-cancel {
                        background: #ffffff;
                        color: #374151;
                        border: 1px solid #d1d5db;
                        padding: 0.85rem 2rem;
                        border-radius: 12px;
                        font-size: 1rem;
                        font-weight: 600;
                        cursor: pointer;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .btn-cancel:hover {
                        background: #f3f4f6;
                        border-color: #9ca3af;
                    }

                    .form-actions {
                        display: flex;
                        gap: 1rem;
                        margin-top: 2rem;
                        justify-content: flex-end;
                    }

                    .section-title {
                        font-size: 1.1rem;
                        font-weight: 700;
                        color: #4c1d95;
                        margin: 1.5rem 0 1rem;
                        padding-bottom: 0.5rem;
                        border-bottom: 2px solid #ede9fe;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .required {
                        color: #f87171;
                        margin-left: 2px;
                    }

                    .alert-error {
                        background: #fef2f2;
                        border: 1px solid #fecaca;
                        color: #dc2626;
                        border-radius: 12px;
                        padding: 1rem 1.5rem;
                        margin-bottom: 1.5rem;
                    }

                    @media (max-width: 640px) {
                        .form-grid {
                            grid-template-columns: 1fr;
                        }
                    }
                </style>
            </head>

            <body>
                <!-- Header -->
                <header class="main-header">
                    <div class="container">
                        <nav class="navbar">
                            <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                                <i class="fas fa-book-open"></i> Thư viện Số FPT
                            </a>
                            <ul class="navbar-nav">
                                <li><a href="${pageContext.request.contextPath}/books" class="nav-link">
                                        <i class="fas fa-search"></i> Tìm sách
                                    </a></li>
                                <li><a href="${pageContext.request.contextPath}/authors" class="nav-link">
                                        <i class="fas fa-user-edit"></i> Tác giả
                                    </a></li>
                                <li><a href="${pageContext.request.contextPath}/categories" class="nav-link">
                                        <i class="fas fa-tags"></i> Thể loại
                                    </a></li>
                                <c:if test="${not empty sessionScope.user}">
                                    <li class="nav-link" style="cursor:default;opacity:0.8;font-size:0.85rem;">
                                        <i class="fas fa-user-circle"></i>
                                        <c:choose>
                                            <c:when test="${sessionScope.userRole == 'Admin'}"><span
                                                    style="color:#f59e0b;">Admin</span></c:when>
                                            <c:when test="${sessionScope.userRole == 'Librarian'}"><span
                                                    style="color:#34d399;">Librarian</span></c:when>
                                            <c:when test="${sessionScope.userRole == 'Seller'}"><span
                                                    style="color:#60a5fa;">Seller</span></c:when>
                                            <c:otherwise><span style="color:#a78bfa;">User</span></c:otherwise>
                                        </c:choose>
                                    </li>
                                    <li><a href="${pageContext.request.contextPath}/auth/logout" class="nav-link">
                                            <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                        </a></li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>
                </header>

                <main class="container">
                    <div class="page-header">
                        <h1>
                            <i class="fas ${isEdit ? 'fa-edit' : 'fa-plus-circle'}"></i>
                            ${isEdit ? 'Chỉnh sửa sách' : 'Thêm sách mới'}
                        </h1>
                        <p>${isEdit ? 'Cập nhật thông tin sách' : 'Nhập thông tin để thêm sách mới vào hệ thống'}</p>
                    </div>

                    <div class="form-card">
                        <c:if test="${not empty error}">
                            <div class="alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
                        </c:if>

                        <c:choose>
                            <c:when test="${isEdit}">
                                <c:set var="formAction"
                                    value="${pageContext.request.contextPath}/books/update/${book.bookId}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="formAction" value="${pageContext.request.contextPath}/books/create" />
                            </c:otherwise>
                        </c:choose>

                        <form method="post" action="${formAction}">

                            <!-- Thông tin cơ bản -->
                            <div class="section-title"><i class="fas fa-info-circle"></i> Thông tin cơ bản</div>
                            <div class="form-grid">
                                <div class="form-group full-width">
                                    <label class="form-label">Tựa sách <span class="required">*</span></label>
                                    <input type="text" name="title" class="form-control" value="${book.title}"
                                        placeholder="Nhập tựa sách..." required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Tác giả</label>
                                    <select name="authorId" class="form-control">
                                        <option value="">-- Chọn tác giả --</option>
                                        <c:forEach var="author" items="${authors}">
                                            <option value="${author.authorId}" ${book.authorId==author.authorId
                                                ? 'selected' : '' }>
                                                ${author.authorName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Thể loại</label>
                                    <select name="categoryId" class="form-control">
                                        <option value="">-- Chọn thể loại --</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryId}" ${book.categoryId==cat.categoryId
                                                ? 'selected' : '' }>
                                                ${cat.categoryName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group full-width">
                                    <label class="form-label">Mô tả ngắn (tóm tắt)</label>
                                    <textarea name="summary" class="form-control"
                                        placeholder="Tóm tắt nội dung sách...">${book.summary}</textarea>
                                </div>
                                <div class="form-group full-width">
                                    <label class="form-label">Mô tả chi tiết</label>
                                    <textarea name="description" class="form-control" style="min-height:140px;"
                                        placeholder="Mô tả chi tiết...">${book.description}</textarea>
                                </div>
                            </div>

                            <!-- Thông tin xuất bản -->
                            <div class="section-title"><i class="fas fa-book"></i> Thông tin xuất bản</div>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">Ngôn ngữ</label>
                                    <select name="language" class="form-control">
                                        <option value="">-- Chọn ngôn ngữ --</option>
                                        <option value="Tiếng Việt" ${book.language=='Tiếng Việt' ? 'selected' : '' }>
                                            Tiếng Việt</option>
                                        <option value="English" ${book.language=='English' ? 'selected' : '' }>English
                                        </option>
                                        <option value="Tiếng Trung" ${book.language=='Tiếng Trung' ? 'selected' : '' }>
                                            Tiếng Trung</option>
                                        <option value="Tiếng Nhật" ${book.language=='Tiếng Nhật' ? 'selected' : '' }>
                                            Tiếng Nhật</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Năm xuất bản</label>
                                    <input type="number" name="publicationYear" class="form-control"
                                        value="${book.publicationYear}" placeholder="VD: 2024" min="1900" max="2030">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Tổng số trang</label>
                                    <input type="number" name="totalPages" class="form-control"
                                        value="${book.totalPages}" placeholder="VD: 300" min="1">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Số trang xem trước</label>
                                    <input type="number" name="previewPages" class="form-control"
                                        value="${book.previewPages}" placeholder="VD: 20" min="0">
                                </div>
                            </div>

                            <!-- Thông tin giá & bìa -->
                            <div class="section-title"><i class="fas fa-tag"></i> Giá & Hình bìa</div>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">Giá (VND) — để trống nếu miễn phí</label>
                                    <input type="number" name="price" class="form-control" value="${book.price}"
                                        placeholder="VD: 50000" min="0" step="1000">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">URL hình bìa</label>
                                    <input type="url" name="coverUrl" class="form-control" value="${book.coverUrl}"
                                        placeholder="https://example.com/cover.jpg">
                                </div>
                            </div>

                            <div class="form-actions">
                                <a href="${pageContext.request.contextPath}/books" class="btn-cancel">
                                    <i class="fas fa-times"></i> Hủy
                                </a>
                                <button type="submit" class="btn-submit">
                                    <i class="fas ${isEdit ? 'fa-save' : 'fa-plus'}"></i>
                                    ${isEdit ? 'Lưu thay đổi' : 'Thêm sách'}
                                </button>
                            </div>
                        </form>
                    </div>
                </main>
            </body>

            </html>