<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        </head>

        <body>
            <!-- Header -->
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
                            <c:if test="${sessionScope.userRole == 'Admin' or sessionScope.userRole == 'Librarian'}">
                                <li><a href="${pageContext.request.contextPath}/books/create" class="nav-link">
                                        <i class="fas fa-plus-circle"></i> Thêm sách
                                    </a></li>
                            </c:if>
                            <c:if test="${sessionScope.userRole == 'Admin' or sessionScope.userRole == 'Seller'}">
                                <li><a href="${pageContext.request.contextPath}/books/create" class="nav-link">
                                        <i class="fas fa-store"></i> Đăng sách bán
                                    </a></li>
                            </c:if>
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <c:if
                                        test="${sessionScope.userRole == 'User' or sessionScope.userRole == 'Reader'}">
                                        <li><a href="${pageContext.request.contextPath}/profile/edit" class="nav-link">
                                                <i class="fas fa-user-circle"></i>
                                                <span style="color:#a78bfa;">Hồ sơ</span>
                                            </a></li>
                                    </c:if>
                                    <c:if
                                        test="${sessionScope.userRole != 'User' and sessionScope.userRole != 'Reader'}">
                                        <li class="nav-link" style="cursor:default;opacity:0.8;font-size:0.85rem;">
                                            <i class="fas fa-user-circle"></i>
                                            <c:choose>
                                                <c:when test="${sessionScope.userRole == 'Admin'}"><span
                                                        style="color:#f59e0b;">Admin</span></c:when>
                                                <c:when test="${sessionScope.userRole == 'Librarian'}"><span
                                                        style="color:#34d399;">Librarian</span></c:when>
                                                <c:when test="${sessionScope.userRole == 'Seller'}"><span
                                                        style="color:#60a5fa;">Seller</span></c:when>
                                            </c:choose>
                                        </li>
                                    </c:if>
                                    <li><a href="${pageContext.request.contextPath}/auth/logout" class="nav-link">
                                            <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                        </a></li>
                                </c:when>
                                <c:otherwise>
                                    <li><a href="${pageContext.request.contextPath}/auth/login" class="nav-link">
                                            <i class="fas fa-sign-in-alt"></i> Đăng nhập
                                        </a></li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </nav>
                </div>
            </header>

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
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label for="name" class="form-label">
                                    <i class="fas fa-search"></i> Tìm theo tên thể loại
                                </label>
                                <input type="text" id="name" name="name" class="form-control"
                                    placeholder="Nhập tên thể loại..." value="${selectedName}">
                            </div>

                            <div class="col-md-3">
                                <label for="keyword" class="form-label">
                                    <i class="fas fa-key"></i> Từ khóa
                                </label>
                                <input type="text" id="keyword" name="keyword" class="form-control"
                                    placeholder="Tìm kiếm tổng hợp..." value="${selectedKeyword}">
                            </div>

                            <div class="col-md-3">
                                <label for="sort" class="form-label">
                                    <i class="fas fa-sort"></i> Sắp xếp theo
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

                            <div class="col-md-2">
                                <label class="form-label">&nbsp;</label>
                                <button type="submit" class="btn btn-primary form-control">
                                    <i class="fas fa-search"></i> Tìm
                                </button>
                            </div>
                        </div>

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