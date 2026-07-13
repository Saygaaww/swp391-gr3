<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Danh sách tác giả - Thư viện Số FPT</title>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/additional-styles.css?v=2">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/author-category-styles.css?v=2">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <style>
                .search-filter-section {
                    background: #ffffff;
                    border: 1px solid #d1d5db;
                    border-radius: 14px;
                    padding: 1rem;
                    margin-bottom: 1rem;
                }

                .author-search-grid {
                    display: grid;
                    grid-template-columns: minmax(260px, 2fr) auto;
                    gap: 12px;
                    align-items: end;
                }

                .field-group {
                    display: flex;
                    flex-direction: column;
                    gap: 6px;
                }

                .search-filter-section .form-label {
                    color: #374151;
                    font-weight: 600;
                    font-size: 0.88rem;
                    letter-spacing: 0;
                    text-transform: none;
                    margin: 0;
                }

                .search-filter-section .form-control {
                    background: #ffffff;
                    border: 1px solid #cbd5e1;
                    color: #111827;
                }

                .search-filter-section .form-control::placeholder {
                    color: #9ca3af;
                }

                .search-filter-section .form-control:focus {
                    border-color: #64748b;
                    box-shadow: 0 0 0 3px rgba(100, 116, 139, 0.12);
                }

                .field-hint {
                    color: #6b7280;
                    font-size: 0.8rem;
                    line-height: 1.3;
                }

                .field-submit .btn {
                    min-width: 110px;
                    height: 44px;
                }

                .search-results-info {
                    background: #f8fafc;
                    border: 1px solid #dbeafe;
                }

                .results-text {
                    color: #334155;
                }

                .sr-only {
                    position: absolute;
                    width: 1px;
                    height: 1px;
                    padding: 0;
                    margin: -1px;
                    overflow: hidden;
                    clip: rect(0, 0, 0, 0);
                    border: 0;
                }

                @media (max-width: 992px) {
                    .author-search-grid {
                        grid-template-columns: 1fr;
                    }

                    .field-submit .btn {
                        width: 100%;
                    }
                }
            </style>
        </head>

        <body>
            <jsp:include page="/includes/navbar.jsp" />

            <main class="container">
                <div class="page-header">
                    <div
                        style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
                        <div>
                            <h1>
                                <i class="fas fa-user-edit"></i>
                                Danh sách Tác giả
                            </h1>
                            <p>Khám phá các tác giả và tác phẩm của họ trong thư viện</p>
                        </div>
                        <c:if test="${canManageCatalog}">
                            <a href="${pageContext.request.contextPath}/authors/create" class="btn btn-primary"
                                style="display: flex; align-items: center; gap: 0.5rem; text-decoration: none;">
                                <i class="fas fa-plus-circle"></i>
                                Thêm tác giả mới
                            </a>
                        </c:if>
                    </div>
                </div>

                <!-- Search Form -->
                <section class="search-filter-section">
                    <h2 class="search-title">
                        <i class="fas fa-filter"></i> Tìm kiếm tác giả
                    </h2>

                    <form method="get" action="${pageContext.request.contextPath}/authors" class="search-form">
                        <input type="hidden" name="name" value="">
                        <div class="author-search-grid">
                            <div class="field-group">
                                <label for="keyword" class="form-label">
                                    <i class="fas fa-search"></i> Bạn muốn tìm tác giả nào?
                                </label>
                                <input type="text" id="keyword" name="keyword" class="form-control"
                                    placeholder="Ví dụ: Nguyễn Nhật Ánh, Dan Brown..."
                                    value="${not empty selectedKeyword ? selectedKeyword : selectedName}">
                                <small class="field-hint">Nhập tên hoặc một phần tên tác giả để lọc nhanh danh sách.</small>
                            </div>

                            <div class="field-group field-submit">
                                <label class="sr-only" for="btnAuthorSearch">Tìm kiếm</label>
                                <button id="btnAuthorSearch" type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Tìm
                                </button>
                            </div>
                        </div>

                        <div class="search-actions mt-3">
                            <a href="${pageContext.request.contextPath}/authors" class="btn btn-outline">
                                <i class="fas fa-refresh"></i> Xóa bộ lọc
                            </a>
                        </div>
                    </form>
                </section>

                <!-- Search Results Info -->
                <c:if test="${not empty searchSummary}">
                    <div class="search-results-info">
                        <p class="results-text">
                            <i class="fas fa-info-circle"></i> ${searchSummary}
                        </p>
                    </div>
                </c:if>

                <!-- Authors Grid -->
                <section class="authors-grid">
                    <c:choose>
                        <c:when test="${not empty authors}">
                            <div class="row">
                                <c:forEach var="author" items="${authors}">
                                    <div class="col-lg-4 col-md-6 mb-4">
                                        <div class="card author-card">
                                            <div class="card-body">
                                                <h3 class="author-name">
                                                    <i class="fas fa-user"></i>
                                                    ${author.authorName}
                                                </h3>

                                                <c:if test="${not empty author.bio}">
                                                    <p class="author-bio">${author.bio}</p>
                                                </c:if>

                                                <div class="author-stats">
                                                    <span class="book-count">
                                                        <i class="fas fa-book"></i>
                                                        ${requestScope['bookCount_'.concat(author.authorId)]} Cuốn sách
                                                    </span>
                                                </div>

                                                <div class="author-actions">
                                                    <a href="${pageContext.request.contextPath}/authors/detail/${author.authorId}"
                                                        class="btn btn-primary btn-sm">
                                                        <i class="fas fa-eye"></i> Xem chi tiết
                                                    </a>
                                                    <c:if test="${canManageCatalog}">
                                                        <a href="${pageContext.request.contextPath}/authors/edit/${author.authorId}"
                                                            class="btn btn-outline btn-sm">
                                                            <i class="fas fa-pen"></i> Sửa
                                                        </a>
                                                    </c:if>
                                                    <a href="${pageContext.request.contextPath}/books?authorId=${author.authorId}"
                                                        class="btn btn-outline btn-sm">
                                                        <i class="fas fa-book-open"></i> Xem sách
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-info text-center">
                                <div class="no-results-content">
                                    <i class="fas fa-user-slash fa-3x mb-3"></i>
                                    <h4>Không tìm thấy tác giả nào</h4>
                                    <p>Không có tác giả nào khớp với tiêu chí tìm kiếm của bạn.</p>
                                    <a href="${pageContext.request.contextPath}/authors" class="btn btn-primary mt-3">
                                        <i class="fas fa-refresh"></i> Xem tất cả tác giả
                                    </a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <!-- Quick Stats -->
                <c:if test="${not empty authors}">
                    <section class="quick-stats mt-5">
                        <div class="stats-card">
                            <h4><i class="fas fa-chart-bar"></i> Thống kê tác giả</h4>
                            <div class="stats-grid">
                                <div class="stat-item">
                                    <span class="stat-number">${totalAuthors}</span>
                                    <span class="stat-label">Tổng tác giả</span>
                                </div>
                                <div class="stat-item">
                                    <span class="stat-number">${authors.size()}</span>
                                    <span class="stat-label">Đang hiển thị</span>
                                </div>
                            </div>
                        </div>
                    </section>
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

            <div class="student-badge">
                <i class="fas fa-graduation-cap"></i> SWP391 Project
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    // Auto-focus first input
                    const firstInput = document.querySelector('input[type="text"]');
                    if (firstInput && !firstInput.value) {
                        firstInput.focus();
                    }

                    // Form submission loading state
                    const form = document.querySelector('.search-form');
                    form.addEventListener('submit', function () {
                        const submitBtn = form.querySelector('button[type="submit"]');
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tìm...';
                        submitBtn.disabled = true;
                    });
                });
            </script>
        </body>

        </html>
