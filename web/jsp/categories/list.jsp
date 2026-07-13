<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Danh sách thể loại - Thư viện Số FPT</title>

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

                .category-search-grid {
                    display: grid;
                    grid-template-columns: minmax(260px, 2fr) minmax(180px, 1fr) auto;
                    gap: 12px;
                    align-items: start;
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

                .search-filter-section .form-control,
                .search-filter-section .form-select {
                    background: #ffffff;
                    border: 1px solid #cbd5e1;
                    color: #111827;
                }

                .search-filter-section .form-control::placeholder {
                    color: #9ca3af;
                }

                .search-filter-section .form-control:focus,
                .search-filter-section .form-select:focus {
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

                .field-submit {
                    align-self: end;
                }

                .category-search-grid .form-control,
                .category-search-grid .form-select {
                    min-height: 44px;
                }

                .field-hint-row {
                    margin-top: 8px;
                    color: #6b7280;
                    font-size: 0.8rem;
                    line-height: 1.3;
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
                    .category-search-grid {
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
                                <i class="fas fa-tags"></i>
                                Danh sách Thể loại
                            </h1>
                            <p>Khám phá sách theo các thể loại yêu thích của bạn</p>
                        </div>
                        <c:if test="${canManageCatalog}">
                            <a href="${pageContext.request.contextPath}/categories/create" class="btn btn-primary"
                                style="display: flex; align-items: center; gap: 0.5rem; text-decoration: none;">
                                <i class="fas fa-plus-circle"></i>
                                Thêm thể loại mới
                            </a>
                        </c:if>
                    </div>
                </div>

                <!-- Search & Sort Form -->
                <section class="search-filter-section">
                    <h2 class="search-title">
                        <i class="fas fa-filter"></i> Tìm kiếm và sắp xếp thể loại
                    </h2>

                    <form method="get" action="${pageContext.request.contextPath}/categories" class="search-form">
                        <div class="category-search-grid">
                            <div class="field-group">
                                <label for="keyword" class="form-label">
                                    <i class="fas fa-search"></i> Bạn muốn tìm thể loại gì?
                                </label>
                                <input type="text" id="keyword" name="keyword" class="form-control"
                                    placeholder="Ví dụ: khoa học, thiếu nhi, kinh doanh..."
                                    value="${selectedKeyword}">
                            </div>

                            <div class="field-group">
                                <label for="sort" class="form-label">
                                    <i class="fas fa-sort"></i> Sắp xếp
                                </label>
                                <select id="sort" name="sort" class="form-select">
                                    <option value="" ${selectedSort==null || selectedSort=='' ? 'selected' : '' }>
                                        Theo tên A-Z
                                    </option>
                                    <option value="popular" ${selectedSort=='popular' ? 'selected' : '' }>
                                        Phổ biến nhất (nhiều sách)
                                    </option>
                                </select>
                            </div>

                            <div class="field-group field-submit">
                                <label class="sr-only" for="btnCategorySearch">Tìm kiếm</label>
                                <button id="btnCategorySearch" type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Tìm
                                </button>
                            </div>
                        </div>

                        <div class="field-hint-row">Nhập từ khóa gần đúng, hệ thống sẽ tìm các thể loại có tên chứa từ đó.</div>

                        <div class="search-actions mt-3">
                            <a href="${pageContext.request.contextPath}/categories" class="btn btn-outline">
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

                <!-- Categories Grid -->
                <section class="categories-grid">
                    <c:choose>
                        <c:when test="${not empty categories}">
                            <div class="row">
                                <c:forEach var="category" items="${categories}">
                                    <div class="col-lg-4 col-md-6 mb-4">
                                        <div class="card category-card">
<!--                                            <div class="category-card-cover">
                                                <i class="fas fa-book-open"></i>
                                            </div>-->
                                            <div class="card-body">
                                                <h3 class="category-name">
                                                    ${category.categoryName}
                                                </h3>

                                                <c:if test="${not empty category.description}">
                                                    <p class="category-description">${category.description}</p>
                                                </c:if>

                                                <div class="category-stats">
                                                    <span class="book-count">
                                                        <i class="fas fa-book"></i>
                                                        ${requestScope['bookCount_'.concat(category.categoryId)]} cuốn
                                                        sách
                                                    </span>
                                                </div>

                                                <div class="category-actions">
                                                    <a href="${pageContext.request.contextPath}/categories/detail/${category.categoryId}"
                                                        class="btn btn-primary btn-sm">
                                                        <i class="fas fa-eye"></i> Xem chi tiết
                                                    </a>
                                                    <c:if test="${canManageCatalog}">
                                                        <a href="${pageContext.request.contextPath}/categories/edit/${category.categoryId}"
                                                            class="btn btn-outline btn-sm">
                                                            <i class="fas fa-pen"></i> Sửa
                                                        </a>
                                                    </c:if>
                                                    <a href="${pageContext.request.contextPath}/books?categoryId=${category.categoryId}"
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
                                    <i class="fas fa-tags fa-3x mb-3"></i>
                                    <h4>Không tìm thấy thể loại nào</h4>
                                    <p>Không có thể loại nào khớp với tiêu chí tìm kiếm của bạn.</p>
                                    <a href="${pageContext.request.contextPath}/categories"
                                        class="btn btn-primary mt-3">
                                        <i class="fas fa-refresh"></i> Xem tất cả thể loại
                                    </a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </section>

                <!-- Quick Links & Stats -->
                <section class="quick-links mt-5">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="quick-link-card">
                                <h4><i class="fas fa-fire"></i> Thể loại phổ biến</h4>
                                <p>Xem các thể loại có nhiều sách nhất trong thư viện</p>
                                <a href="${pageContext.request.contextPath}/categories?sort=popular"
                                    class="btn btn-outline">
                                    <i class="fas fa-chart-line"></i> Xem thể loại phổ biến
                                </a>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="quick-link-card">
                                <h4><i class="fas fa-chart-bar"></i> Thống kê thể loại</h4>
                                <div class="stats-grid">
                                    <div class="stat-item">
                                        <span class="stat-number">${totalCategories}</span>
                                        <span class="stat-label">Tổng thể loại</span>
                                    </div>
                                    <div class="stat-item">
                                        <span class="stat-number">${categories.size()}</span>
                                        <span class="stat-label">Đang hiển thị</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
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

            <div class="student-badge">
                <i class="fas fa-graduation-cap"></i> SWP391 Project
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', function () {
                    // Auto-focus first input if empty
                    const firstInput = document.querySelector('input[type="text"]');
                    if (firstInput && !firstInput.value) {
                        firstInput.focus();
                    }

                    // Category card hover effects
                    const categoryCards = document.querySelectorAll('.category-card');
                    categoryCards.forEach(card => {
                        card.addEventListener('mouseenter', function () {
                            this.style.transform = 'translateY(-4px)';
                        });

                        card.addEventListener('mouseleave', function () {
                            this.style.transform = 'translateY(0)';
                        });
                    });

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
