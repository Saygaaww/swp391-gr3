<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/additional-styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/author-category-styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <header class="main-header">
        <div class="container">
            <nav class="navbar">
                <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                    <i class="fas fa-book-open"></i>
                    Thư viện Số FPT
                </a>
                <ul class="navbar-nav">
                    <li><a href="${pageContext.request.contextPath}/books" class="nav-link">
                        <i class="fas fa-search"></i> Tìm sách
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/authors" class="nav-link">
                        <i class="fas fa-user-edit"></i> Tác giả
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/categories" class="nav-link active">
                        <i class="fas fa-tags"></i> Thể loại
                    </a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main class="container">
        <div class="page-header">
            <h1>
                <i class="fas fa-${isEdit ? 'edit' : 'plus-circle'}"></i>
                ${isEdit ? 'Chỉnh sửa' : 'Thêm mới'} Thể loại
            </h1>
            <p>${isEdit ? 'Cập nhật thông tin thể loại sách' : 'Tạo mới thể loại sách trong thư viện'}</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                ${error}
            </div>
        </c:if>

        <section class="form-section">
            <form method="post"
                  action="${pageContext.request.contextPath}/categories${isEdit ? '/update/' : '/create'}${isEdit ? category.categoryId : ''}"
                  id="categoryForm" novalidate>

                <c:if test="${isEdit && not empty category.categoryId}">
                    <input type="hidden" name="categoryId" value="${category.categoryId}">
                    <input type="hidden" name="action" value="update">
                </c:if>
                <c:if test="${not isEdit}">
                    <input type="hidden" name="action" value="create">
                </c:if>

                <div class="form-group">
                    <label for="categoryName" class="form-label required">
                        <i class="fas fa-tag"></i>
                        Tên thể loại
                    </label>
                    <input type="text"
                           id="categoryName"
                           name="categoryName"
                           class="form-control"
                           placeholder="Nhập tên thể loại..."
                           value="${not empty category.categoryName ? category.categoryName : ''}"
                           required
                           maxlength="255">
                    <small class="form-text text-muted">
                        Tên thể loại là bắt buộc và không được trùng với thể loại khác.
                    </small>
                </div>

                <div class="form-group">
                    <label for="description" class="form-label">
                        <i class="fas fa-align-left"></i>
                        Mô tả
                    </label>
                    <textarea id="description"
                              name="description"
                              class="form-control"
                              rows="4"
                              maxlength="1000"
                              placeholder="Mô tả ngắn gọn về thể loại...">${not empty category.description ? category.description : ''}</textarea>
                    <small class="form-text text-muted">
                        Mô tả giúp người dùng hiểu rõ hơn về thể loại (tối đa 1000 ký tự).
                    </small>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-${isEdit ? 'save' : 'plus'}"></i>
                        ${isEdit ? 'Cập nhật' : 'Thêm mới'}
                    </button>
                    <a href="${pageContext.request.contextPath}/categories" class="btn btn-outline">
                        <i class="fas fa-times"></i>
                        Hủy
                    </a>
                    <c:if test="${isEdit && not empty category.categoryId}">
                        <a href="${pageContext.request.contextPath}/categories/detail/${category.categoryId}" class="btn btn-outline">
                            <i class="fas fa-eye"></i>
                            Xem chi tiết
                        </a>
                    </c:if>
                </div>
            </form>
        </section>
    </main>

    <footer class="main-footer">
        <div class="container">
            <div class="footer-content">
                <h3>Thư viện Số FPT University</h3>
                <p>Dự án SWP391 - Hệ thống quản lý thư viện số hiện đại và thân thiện</p>
            </div>
        </div>
    </footer>

    <script>
        document.getElementById('categoryForm').addEventListener('submit', function (e) {
            const nameInput = document.getElementById('categoryName');
            const name = nameInput.value.trim();
            if (!name) {
                e.preventDefault();
                alert('Vui lòng nhập tên thể loại');
                nameInput.focus();
                return false;
            }
        });

        // Auto-focus
        const nameInput = document.getElementById('categoryName');
        if (nameInput && !nameInput.value) {
            nameInput.focus();
        }
    </script>
</body>
</html>

