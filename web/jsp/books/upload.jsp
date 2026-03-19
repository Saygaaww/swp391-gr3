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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">
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
                        <li><a href="${pageContext.request.contextPath}/books" class="nav-link active">
                                <i class="fas fa-search"></i> Tìm sách
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/authors" class="nav-link">
                                <i class="fas fa-user-edit"></i> Tác giả
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/categories" class="nav-link">
                                <i class="fas fa-tags"></i> Thể loại
                            </a></li>
                    </ul>
                </nav>
            </div>
        </header>

        <main class="container">
            <div class="page-header">
                <h1>
                    <i class="fas fa-upload"></i>
                    Cập nhật file nội dung sách
                </h1>
                <p>Cập nhật đường dẫn file số hóa (PDF/EPUB/...) cho sách trong thư viện</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>

            <c:if test="${not empty book}">
                <section class="form-section">
                    <div class="mb-4">
                        <h2>
                            <i class="fas fa-book"></i>
                            ${book.title}
                        </h2>
                        <p class="text-muted">
                            <c:if test="${not empty book.author}">
                                <i class="fas fa-user-edit"></i>
                                Tác giả: ${book.author.authorName}
                            </c:if>
                        </p>
                        <c:if test="${not empty book.contentPath}">
                            <p>
                                <i class="fas fa-link"></i>
                                File hiện tại:
                                <code>${book.contentPath}</code>
                            </p>
                        </c:if>
                    </div>

                    <form method="post" action="${pageContext.request.contextPath}/books/upload/${book.bookId}"
                          enctype="multipart/form-data" id="uploadForm">

                        <div class="form-group">
                            <label for="contentFile" class="form-label required">
                                <i class="fas fa-file-upload"></i>
                                Chọn file nội dung
                            </label>
                            <input type="file" id="contentFile" name="contentFile" class="form-control"
                                   accept=".pdf,.epub,.txt,.doc,.docx,application/pdf,application/epub+zip">
                            <small class="form-text text-muted">
                                Khuyến nghị: PDF hoặc EPUB. Dung lượng tối đa 50MB.
                            </small>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-upload"></i>
                                Tải lên và cập nhật
                            </button>
                            <a href="${pageContext.request.contextPath}/books/detail/${book.bookId}"
                               class="btn btn-outline">
                                <i class="fas fa-arrow-left"></i>
                                Quay lại chi tiết sách
                            </a>
                        </div>
                    </form>
                </section>
            </c:if>

            <c:if test="${empty book}">
                <div class="alert alert-warning text-center">
                    <i class="fas fa-exclamation-triangle"></i>
                    Sách không tồn tại hoặc đã bị xóa.
                </div>
            </c:if>
        </main>

        <footer class="main-footer">
            <div class="container">
                <div class="footer-content">
                    <h3>Thư viện Số FPT University</h3>
                    <p>Dự án SWP391 - Hệ thống quản lý thư viện số hiện đại</p>
                </div>
            </div>
        </footer>

        <script>
            document.getElementById('uploadForm').addEventListener('submit', function (e) {
                const fileInput = document.getElementById('contentFile');
                if (!fileInput.files.length) {
                    e.preventDefault();
                    alert('Vui lòng chọn file để upload');
                    fileInput.focus();
                    return false;
                }
            });
        </script>
    </body>

</html>