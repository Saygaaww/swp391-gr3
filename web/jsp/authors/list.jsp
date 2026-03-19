<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                        <li><a href="${pageContext.request.contextPath}/authors" class="nav-link active">
                                <i class="fas fa-user-edit"></i> Tác giả
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/categories" class="nav-link">
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
                    <div class="row g-3">
                        <div class="col-md-5">
                            <label for="name" class="form-label">
                                <i class="fas fa-search"></i> Tìm theo tên tác giả
                            </label>
                            <input type="text" id="name" name="name" class="form-control"
                                   placeholder="Nhập tên tác giả..." value="${selectedName}">
                        </div>

                        <div class="col-md-5">
                            <label for="keyword" class="form-label">
                                <i class="fas fa-key"></i> Từ khóa tổng hợp
                            </label>
                            <input type="text" id="keyword" name="keyword" class="form-control"
                                   placeholder="Tìm kiếm tổng hợp..." value="${selectedKeyword}">
                        </div>

                        <div class="col-md-2">
                            <label class="form-label">&nbsp;</label>
                            <button type="submit" class="btn btn-primary form-control">
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
                                                    ${requestScope['bookCount_'.concat(author.authorId)]} cuốn sách
                                                </span>
                                            </div>

                                            <div class="author-actions">
                                                <a href="${pageContext.request.contextPath}/authors/detail/${author.authorId}"
                                                   class="btn btn-primary btn-sm">
                                                    <i class="fas fa-eye"></i> Xem chi tiết
                                                </a>
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