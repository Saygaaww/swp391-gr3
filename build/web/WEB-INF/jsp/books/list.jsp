<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Tìm kiếm sách - Thư viện Số FPT</title>

                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/additional-styles.css?v=2">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">

                <style>
                    /* Enhanced Filter Styles */
                    .filter-section {
                        background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                        border-radius: 16px;
                        padding: 2rem;
                        margin-bottom: 2rem;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                    }

                    .filter-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 1.5rem;
                    }

                    .filter-toggle {
                        background: #667eea;
                        color: white;
                        border: none;
                        padding: 0.5rem 1rem;
                        border-radius: 8px;
                        font-size: 0.9rem;
                        cursor: pointer;
                        transition: all 0.2s ease;
                    }

                    .filter-toggle:hover {
                        background: #5a67d8;
                    }

                    .advanced-filters {
                        background: white;
                        border-radius: 12px;
                        padding: 1.5rem;
                        margin-top: 1rem;
                        border: 2px dashed #e2e8f0;
                        transition: all 0.3s ease;
                    }

                    .advanced-filters.show {
                        border: 2px solid #667eea;
                        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.1);
                    }

                    .filter-group {
                        margin-bottom: 1rem;
                    }

                    .filter-label {
                        font-weight: 600;
                        color: #2d3748;
                        margin-bottom: 0.5rem;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .form-control,
                    .form-select {
                        border: 2px solid #e2e8f0;
                        border-radius: 8px;
                        padding: 0.75rem;
                        font-size: 0.95rem;
                        transition: border-color 0.2s ease;
                    }

                    .form-control:focus,
                    .form-select:focus {
                        border-color: #667eea;
                        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                    }

                    .filter-actions {
                        display: flex;
                        gap: 1rem;
                        margin-top: 1.5rem;
                    }

                    .btn-filter-primary {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border: none;
                        color: white;
                        padding: 0.75rem 1.5rem;
                        border-radius: 8px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        text-decoration: none;
                    }

                    .btn-filter-primary:hover {
                        transform: translateY(-1px);
                        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
                        color: white;
                    }

                    .btn-filter-clear {
                        background: transparent;
                        border: 2px solid #e2e8f0;
                        color: #718096;
                        padding: 0.75rem 1.5rem;
                        border-radius: 8px;
                        font-weight: 600;
                        cursor: pointer;
                        transition: all 0.2s ease;
                        text-decoration: none;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .btn-filter-clear:hover {
                        border-color: #cbd5e0;
                        background: #f7fafc;
                        color: #718096;
                        text-decoration: none;
                    }

                    /* Pagination Styles */
                    .pagination-info-bar {
                        background: #f8f9fa;
                        border-radius: 8px;
                        padding: 1rem;
                        margin-bottom: 2rem;
                        border: 1px solid #e9ecef;
                    }

                    .pagination-info {
                        margin: 0;
                        color: #6c757d;
                        font-size: 0.95rem;
                    }

                    .page-size-selector {
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        font-size: 0.9rem;
                    }

                    .page-size-selector select {
                        width: auto;
                        min-width: 100px;
                    }

                    .pagination-wrapper {
                        margin-top: 3rem;
                        padding: 2rem 0;
                        border-top: 1px solid #e9ecef;
                    }

                    .pagination-nav {
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        gap: 1rem;
                    }

                    .pagination {
                        margin: 0;
                        flex-wrap: wrap;
                        gap: 0.25rem;
                    }

                    .pagination .page-link {
                        border: 1px solid #dee2e6;
                        border-radius: 8px;
                        padding: 0.5rem 0.75rem;
                        margin: 0 2px;
                        color: #667eea;
                        text-decoration: none;
                        transition: all 0.2s ease;
                        font-weight: 500;
                    }

                    .pagination .page-link:hover {
                        background: #667eea;
                        color: white;
                        border-color: #667eea;
                        transform: translateY(-1px);
                        text-decoration: none;
                    }

                    .pagination .page-item.active .page-link {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border-color: #667eea;
                        color: white;
                        font-weight: 600;
                        box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
                    }

                    .pagination .page-item.disabled .page-link {
                        color: #6c757d;
                        background: #f8f9fa;
                        border-color: #dee2e6;
                        cursor: not-allowed;
                    }

                    .pagination-jump .input-group {
                        width: auto;
                    }

                    .pagination-summary {
                        margin-top: 1rem;
                        padding-top: 1rem;
                        border-top: 1px solid #e9ecef;
                    }

                    /* Responsive adjustments */
                    @media (max-width: 768px) {
                        .pagination {
                            font-size: 0.9rem;
                        }

                        .pagination .page-link {
                            padding: 0.4rem 0.6rem;
                            margin: 0 1px;
                        }

                        .pagination-info-bar .row {
                            flex-direction: column;
                            gap: 1rem;
                        }

                        .page-size-selector {
                            justify-content: center;
                        }

                        .filter-actions {
                            flex-direction: column;
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
                                <%-- Quản lý sách: Admin & Librarian --%>
                                    <c:if
                                        test="${sessionScope.userRole == 'Admin' or sessionScope.userRole == 'Librarian'}">
                                        <li><a href="${pageContext.request.contextPath}/books/create" class="nav-link">
                                                <i class="fas fa-plus-circle"></i> Thêm sách
                                            </a></li>
                                    </c:if>
                                    <%-- Bán sách: Admin & Seller --%>
                                        <c:if
                                            test="${sessionScope.userRole == 'Admin' or sessionScope.userRole == 'Seller'}">
                                            <li><a href="${pageContext.request.contextPath}/books/create"
                                                    class="nav-link">
                                                    <i class="fas fa-store"></i> Đăng sách bán
                                                </a></li>
                                        </c:if>
                                        <%-- Role badge + Đăng xuất / Đăng nhập --%>
                                            <c:choose>
                                                <c:when test="${not empty sessionScope.user}">
                                                    <%-- Profile link cho User thường --%>
                                                        <c:if
                                                            test="${sessionScope.userRole == 'User' or sessionScope.userRole == 'Reader'}">
                                                            <li><a href="${pageContext.request.contextPath}/profile/view"
                                                                    class="nav-link">
                                                                    <i class="fas fa-user-circle"></i>
                                                                    <span style="color:#7c3aed;">Hồ sơ</span>
                                                                </a></li>
                                                        </c:if>
                                                        <%-- Role badge cho Admin/Librarian/Seller --%>
                                                            <c:if
                                                                test="${sessionScope.userRole != 'User' and sessionScope.userRole != 'Reader'}">
                                                                <li class="nav-link"
                                                                    style="cursor:default;opacity:0.8;font-size:0.85rem;">
                                                                    <i class="fas fa-user-circle"></i>
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${sessionScope.userRole == 'Admin'}">
                                                                            <span style="color:#f59e0b;">Admin</span>
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${sessionScope.userRole == 'Librarian'}">
                                                                            <span
                                                                                style="color:#34d399;">Librarian</span>
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${sessionScope.userRole == 'Seller'}">
                                                                            <span style="color:#60a5fa;">Seller</span>
                                                                        </c:when>
                                                                    </c:choose>
                                                                </li>
                                                            </c:if>
                                                            <li><a href="${pageContext.request.contextPath}/auth/logout"
                                                                    class="nav-link">
                                                                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                                                </a></li>
                                                </c:when>
                                                <c:otherwise>
                                                    <li><a href="${pageContext.request.contextPath}/auth/login"
                                                            class="nav-link">
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
                        <h1>
                            <i class="fas fa-filter"></i>
                            Tìm kiếm và Lọc Sách
                        </h1>
                        <p>Sử dụng bộ lọc nâng cao để tìm kiếm sách theo nhiều tiêu chí khác nhau</p>
                    </div>

                    <!-- Enhanced Filter Section -->
                    <section class="filter-section">
                        <div class="filter-header">
                            <h2 class="search-title">
                                <i class="fas fa-sliders-h"></i>
                                Bộ lọc tìm kiếm
                            </h2>
                            <button type="button" class="filter-toggle" onclick="toggleAdvancedFilters()">
                                <i class="fas fa-cog"></i> Bộ lọc nâng cao
                            </button>
                        </div>

                        <form method="get" action="${pageContext.request.contextPath}/books" class="search-form">
                            <!-- Basic Filters Row -->
                            <div class="row g-3">
                                <!-- Quick Search -->
                                <div class="col-md-6">
                                    <label for="keyword" class="filter-label">
                                        <i class="fas fa-search"></i> Tìm kiếm tổng hợp
                                    </label>
                                    <input type="text" id="keyword" name="keyword" class="form-control"
                                        placeholder="Nhập tên sách, tác giả, mô tả..." value="${selectedKeyword}">
                                </div>

                                <!-- Category Filter -->
                                <div class="col-md-3">
                                    <label for="categoryId" class="filter-label">
                                        <i class="fas fa-tags"></i> Thể loại
                                    </label>
                                    <select id="categoryId" name="categoryId" class="form-select">
                                        <option value="">Tất cả thể loại</option>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.categoryId}"
                                                ${selectedCategoryId==category.categoryId ? 'selected' : '' }>
                                                ${category.categoryName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Author Filter -->
                                <div class="col-md-3">
                                    <label for="authorId" class="filter-label">
                                        <i class="fas fa-user-edit"></i> Tác giả
                                    </label>
                                    <select id="authorId" name="authorId" class="form-select">
                                        <option value="">Tất cả tác giả</option>
                                        <c:forEach var="author" items="${authors}">
                                            <option value="${author.authorId}" ${selectedAuthorId==author.authorId
                                                ? 'selected' : '' }>
                                                ${author.authorName}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <!-- Advanced Filters Section -->
                            <div class="advanced-filters" id="advancedFilters" style="display: none;">
                                <h4 style="margin-bottom: 1rem; color: #667eea;">
                                    <i class="fas fa-filter"></i> Bộ lọc nâng cao
                                </h4>

                                <div class="row g-3">
                                    <!-- Title Search -->
                                    <div class="col-md-4">
                                        <div class="filter-group">
                                            <label for="title" class="filter-label">
                                                <i class="fas fa-book"></i> Tên sách
                                            </label>
                                            <input type="text" id="title" name="title" class="form-control"
                                                placeholder="Nhập tên sách cụ thể..." value="${selectedTitle}">
                                        </div>
                                    </div>

                                    <!-- Language Filter -->
                                    <div class="col-md-4">
                                        <div class="filter-group">
                                            <label for="language" class="filter-label">
                                                <i class="fas fa-globe"></i> Ngôn ngữ
                                            </label>
                                            <select id="language" name="language" class="form-select">
                                                <option value="">Tất cả ngôn ngữ</option>
                                                <option value="Tiếng Việt" ${selectedLanguage=='Tiếng Việt' ? 'selected'
                                                    : '' }>Tiếng Việt</option>
                                                <option value="Tiếng Anh" ${selectedLanguage=='Tiếng Anh' ? 'selected'
                                                    : '' }>Tiếng Anh</option>
                                                <option value="Tiếng Nhật" ${selectedLanguage=='Tiếng Nhật' ? 'selected'
                                                    : '' }>Tiếng Nhật</option>
                                                <option value="Tiếng Pháp" ${selectedLanguage=='Tiếng Pháp' ? 'selected'
                                                    : '' }>Tiếng Pháp</option>
                                                <option value="Tiếng Trung" ${selectedLanguage=='Tiếng Trung'
                                                    ? 'selected' : '' }>Tiếng Trung</option>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Publication Year -->
                                    <div class="col-md-4">
                                        <div class="filter-group">
                                            <label for="publicationYear" class="filter-label">
                                                <i class="fas fa-calendar"></i> Năm xuất bản
                                            </label>
                                            <select id="publicationYear" name="publicationYear" class="form-select">
                                                <option value="">Tất cả năm</option>
                                                <option value="2020-2024" ${selectedYearRange=='2020-2024' ? 'selected'
                                                    : '' }>2020 - 2024 (Mới nhất)</option>
                                                <option value="2010-2019" ${selectedYearRange=='2010-2019' ? 'selected'
                                                    : '' }>2010 - 2019</option>
                                                <option value="2000-2009" ${selectedYearRange=='2000-2009' ? 'selected'
                                                    : '' }>2000 - 2009</option>
                                                <option value="1990-1999" ${selectedYearRange=='1990-1999' ? 'selected'
                                                    : '' }>1990 - 1999</option>
                                                <option value="before-1980" ${selectedYearRange=='before-1980'
                                                    ? 'selected' : '' }>Trước 1980 (Kinh điển)</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- Price Range Row -->
                                <div class="row g-3 mt-2">
                                    <div class="col-md-3">
                                        <div class="filter-group">
                                            <label for="minPrice" class="filter-label">
                                                <i class="fas fa-money-bill-wave"></i> Giá từ
                                            </label>
                                            <input type="number" id="minPrice" name="minPrice" class="form-control"
                                                placeholder="0 VNĐ" value="${selectedMinPrice}" step="1000" min="0">
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="filter-group">
                                            <label for="maxPrice" class="filter-label">
                                                <i class="fas fa-money-bill-wave"></i> Giá đến
                                            </label>
                                            <input type="number" id="maxPrice" name="maxPrice" class="form-control"
                                                placeholder="1,000,000 VNĐ" value="${selectedMaxPrice}" step="1000"
                                                min="0">
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="filter-group">
                                            <label for="priceType" class="filter-label">
                                                <i class="fas fa-tag"></i> Loại giá
                                            </label>
                                            <select id="priceType" name="priceType" class="form-select">
                                                <option value="">Tất cả</option>
                                                <option value="free" ${selectedPriceType=='free' ? 'selected' : '' }>Chỉ
                                                    sách miễn phí</option>
                                                <option value="paid" ${selectedPriceType=='paid' ? 'selected' : '' }>Chỉ
                                                    sách có phí</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-md-3">
                                        <div class="filter-group">
                                            <label for="sortBy" class="filter-label">
                                                <i class="fas fa-sort"></i> Sắp xếp theo
                                            </label>
                                            <select id="sortBy" name="sortBy" class="form-select">
                                                <option value="newest" ${selectedSortBy=='newest' ? 'selected' : '' }>
                                                    Mới nhất</option>
                                                <option value="title" ${selectedSortBy=='title' ? 'selected' : '' }>Tên
                                                    A-Z</option>
                                                <option value="price-low" ${selectedSortBy=='price-low' ? 'selected'
                                                    : '' }>Giá thấp đến cao</option>
                                                <option value="price-high" ${selectedSortBy=='price-high' ? 'selected'
                                                    : '' }>Giá cao đến thấp</option>
                                                <option value="year" ${selectedSortBy=='year' ? 'selected' : '' }>Năm
                                                    xuất bản</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Filter Actions -->
                            <div class="filter-actions">
                                <button type="submit" class="btn-filter-primary">
                                    <i class="fas fa-search"></i>
                                    Tìm kiếm
                                </button>
                                <button type="button" class="btn-filter-clear" onclick="clearAllFilters()">
                                    <i class="fas fa-times"></i>
                                    Xóa bộ lọc
                                </button>
                                <a href="${pageContext.request.contextPath}/books/free" class="btn-filter-clear">
                                    <i class="fas fa-gift"></i>
                                    Sách miễn phí
                                </a>
                                <a href="${pageContext.request.contextPath}/books/latest" class="btn-filter-clear">
                                    <i class="fas fa-clock"></i>
                                    Sách mới nhất
                                </a>
                            </div>
                        </form>
                    </section>

                    <!-- Pagination Info Bar (Top) -->
                    <c:if test="${not empty paginatedResult && totalPages > 1}">
                        <div class="pagination-info-bar">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <p class="pagination-info">
                                        <i class="fas fa-info-circle"></i>
                                        ${paginationInfo}
                                    </p>
                                </div>
                                <div class="col-md-6 text-end">
                                    <div class="page-size-selector">
                                        <label for="pageSizeSelect">Hiển thị:</label>
                                        <select id="pageSizeSelect" class="form-select form-select-sm"
                                            onchange="changePageSize(this.value)">
                                            <option value="6" ${pageSize==6 ? 'selected' : '' }>6 sách</option>
                                            <option value="12" ${pageSize==12 ? 'selected' : '' }>12 sách</option>
                                            <option value="24" ${pageSize==24 ? 'selected' : '' }>24 sách</option>
                                            <option value="48" ${pageSize==48 ? 'selected' : '' }>48 sách</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Search Results Info -->
                    <c:if test="${not empty searchSummary}">
                        <div class="search-results-info">
                            <p class="results-text">
                                <i class="fas fa-info-circle"></i>
                                ${searchSummary}
                            </p>
                        </div>
                    </c:if>

                    <!-- Books Display -->
                    <section class="books-grid">
                        <c:choose>
                            <c:when test="${not empty books}">
                                <div class="row">
                                    <c:forEach var="book" items="${books}" varStatus="status">
                                        <div class="col-lg-3 col-md-4 col-sm-6">
                                            <article class="card book-card" data-book-id="${book.bookId}">
                                                <div class="card-image-container">
                                                    <img src="${not empty book.coverUrl ? book.coverUrl : pageContext.request.contextPath.concat('/images/no-image.jpg')}"
                                                        class="card-img-top" alt="${book.title}"
                                                        onerror="this.src='https://via.placeholder.com/300x400/667eea/ffffff?text=📚'">
                                                    <div class="card-overlay">
                                                        <a href="${pageContext.request.contextPath}/books/detail/${book.bookId}"
                                                            class="btn btn-primary btn-sm">
                                                            <i class="fas fa-eye"></i>
                                                            Xem chi tiết
                                                        </a>
                                                    </div>
                                                </div>

                                                <div class="card-body">
                                                    <h3 class="card-title" title="${book.title}">
                                                        ${book.title}
                                                    </h3>

                                                    <div class="book-meta">
                                                        <p class="card-text text-muted">
                                                            <i class="fas fa-user"></i>
                                                            <span>Tác giả: ${not empty book.author ?
                                                                book.author.authorName : 'Chưa xác định'}</span>
                                                        </p>
                                                        <p class="card-text text-muted">
                                                            <i class="fas fa-bookmark"></i>
                                                            <span>Thể loại: ${not empty book.category ?
                                                                book.category.categoryName : 'Chưa phân loại'}</span>
                                                        </p>
                                                        <c:if test="${not empty book.totalPages}">
                                                            <p class="card-text text-muted">
                                                                <i class="fas fa-file-alt"></i>
                                                                <span>${book.totalPages} trang</span>
                                                            </p>
                                                        </c:if>
                                                    </div>

                                                    <c:if test="${not empty book.summary}">
                                                        <p class="card-text book-summary" title="${book.summary}">
                                                            ${book.summary}
                                                        </p>
                                                    </c:if>

                                                    <div class="card-footer-content">
                                                        <div class="book-price">
                                                            <c:choose>
                                                                <c:when
                                                                    test="${not empty book.price && book.price > 0}">
                                                                    <span class="price text-success">
                                                                        <i class="fas fa-money-bill-wave"></i>
                                                                        <fmt:formatNumber value="${book.price}"
                                                                            type="number" maxFractionDigits="0" />
                                                                        ${not empty book.currency ? book.currency :
                                                                        'VNĐ'}
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="price-free text-success">
                                                                        <i class="fas fa-gift"></i>
                                                                        Miễn phí
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>

                                                        <div class="book-actions">
                                                            <a href="${pageContext.request.contextPath}/books/detail/${book.bookId}"
                                                                class="btn btn-primary btn-sm">
                                                                <i class="fas fa-book-open"></i>
                                                                Đọc ngay
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </article>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info text-center">
                                    <div class="no-results-content">
                                        <i class="fas fa-search fa-3x mb-3"></i>
                                        <h4>Không tìm thấy sách nào phù hợp</h4>
                                        <p>Không có sách nào khớp với tiêu chí tìm kiếm của bạn.</p>
                                        <div class="suggestions">
                                            <strong>Gợi ý:</strong>
                                            <ul>
                                                <li>Thử sử dụng từ khóa khác</li>
                                                <li>Giảm bớt các bộ lọc</li>
                                                <li>Kiểm tra chính tả</li>
                                                <li>Duyệt qua các thể loại khác nhau</li>
                                            </ul>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/books" class="btn btn-primary mt-3">
                                            <i class="fas fa-refresh"></i>
                                            Xem tất cả sách
                                        </a>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </section>

                    <!-- Enhanced Pagination Component -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-wrapper">
                            <nav aria-label="Phân trang danh sách sách" class="pagination-nav">
                                <ul class="pagination justify-content-center">

                                    <!-- Previous Page Button -->
                                    <li class="page-item ${!hasPreviousPage ? 'disabled' : ''}">
                                        <c:choose>
                                            <c:when test="${hasPreviousPage}">
                                                <a class="page-link" href="${currentUrl}page=${currentPage - 1}"
                                                    aria-label="Trang trước">
                                                    <i class="fas fa-chevron-left"></i>
                                                    <span class="d-none d-sm-inline">Trước</span>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="page-link disabled">
                                                    <i class="fas fa-chevron-left"></i>
                                                    <span class="d-none d-sm-inline">Trước</span>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>

                                    <!-- Page Numbers Logic -->
                                    <c:set var="startPage" value="${currentPage - 2 < 1 ? 1 : currentPage - 2}" />
                                    <c:set var="endPage"
                                        value="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}" />

                                    <!-- First page if not in range -->
                                    <c:if test="${startPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="${currentUrl}page=1">1</a>
                                        </li>
                                        <c:if test="${startPage > 2}">
                                            <li class="page-item disabled">
                                                <span class="page-link">...</span>
                                            </li>
                                        </c:if>
                                    </c:if>

                                    <!-- Page range -->
                                    <c:forEach var="pageNum" begin="${startPage}" end="${endPage}">
                                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                            <c:choose>
                                                <c:when test="${pageNum == currentPage}">
                                                    <span class="page-link current-page">
                                                        ${pageNum}
                                                        <span class="sr-only">(trang hiện tại)</span>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a class="page-link"
                                                        href="${currentUrl}page=${pageNum}">${pageNum}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </li>
                                    </c:forEach>

                                    <!-- Last page if not in range -->
                                    <c:if test="${endPage < totalPages}">
                                        <c:if test="${endPage < totalPages - 1}">
                                            <li class="page-item disabled">
                                                <span class="page-link">...</span>
                                            </li>
                                        </c:if>
                                        <li class="page-item">
                                            <a class="page-link"
                                                href="${currentUrl}page=${totalPages}">${totalPages}</a>
                                        </li>
                                    </c:if>

                                    <!-- Next Page Button -->
                                    <li class="page-item ${!hasNextPage ? 'disabled' : ''}">
                                        <c:choose>
                                            <c:when test="${hasNextPage}">
                                                <a class="page-link" href="${currentUrl}page=${currentPage + 1}"
                                                    aria-label="Trang sau">
                                                    <span class="d-none d-sm-inline">Sau</span>
                                                    <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="page-link disabled">
                                                    <span class="d-none d-sm-inline">Sau</span>
                                                    <i class="fas fa-chevron-right"></i>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>

                                </ul>

                                <!-- Quick Jump -->
                                <div class="pagination-jump d-none d-md-block">
                                    <div class="input-group input-group-sm">
                                        <span class="input-group-text">Trang:</span>
                                        <input type="number" id="jumpToPage" class="form-control" min="1"
                                            max="${totalPages}" value="${currentPage}" style="width: 80px;">
                                        <button class="btn btn-outline-primary" onclick="jumpToPage()">
                                            <i class="fas fa-arrow-right"></i>
                                        </button>
                                    </div>
                                </div>
                            </nav>

                            <!-- Mobile Pagination Summary -->
                            <div class="pagination-summary d-md-none text-center">
                                <small class="text-muted">
                                    Trang ${currentPage} / ${totalPages}
                                </small>
                            </div>
                        </div>
                    </c:if>
                </main>

                <!-- Footer -->
                <footer class="main-footer">
                    <div class="container">
                        <div class="footer-content">
                            <h3 class="footer-title">Thư viện Số FPT University</h3>
                            <p class="footer-text">
                                Dự án SWP391 - Hệ thống quản lý thư viện số hiện đại và thân thiện
                            </p>
                        </div>
                    </div>
                </footer>

                <div class="student-badge">
                    <i class="fas fa-graduation-cap"></i>
                    SWP391 Project
                </div>

                <!-- JavaScript -->
                <script>
                    function toggleAdvancedFilters() {
                        const advancedFilters = document.getElementById('advancedFilters');
                        const isVisible = advancedFilters.style.display !== 'none';

                        if (isVisible) {
                            advancedFilters.style.display = 'none';
                            advancedFilters.classList.remove('show');
                        } else {
                            advancedFilters.style.display = 'block';
                            advancedFilters.classList.add('show');
                        }
                    }

                    function clearAllFilters() {
                        document.getElementById('keyword').value = '';
                        document.getElementById('title').value = '';
                        document.getElementById('categoryId').value = '';
                        document.getElementById('authorId').value = '';
                        document.getElementById('language').value = '';
                        document.getElementById('publicationYear').value = '';
                        document.getElementById('minPrice').value = '';
                        document.getElementById('maxPrice').value = '';
                        document.getElementById('priceType').value = '';
                        document.getElementById('sortBy').value = 'newest';
                        window.location.href = '${pageContext.request.contextPath}/books';
                    }

                    function changePageSize(newSize) {
                        const url = new URL(window.location.href);
                        url.searchParams.set('pageSize', newSize);
                        url.searchParams.set('page', '1');
                        window.location.href = url.toString();
                    }

                    function jumpToPage() {
                        const pageInput = document.getElementById('jumpToPage');
                        const page = parseInt(pageInput.value);
                        const maxPage = ${ totalPages > 0 ? totalPages : 1
                    };

                    if (page >= 1 && page <= maxPage) {
                        window.location.href = '${currentUrl}page=' + page;
                    }
        }

                    document.addEventListener('DOMContentLoaded', function () {
                        const jumpInput = document.getElementById('jumpToPage');
                        if (jumpInput) {
                            jumpInput.addEventListener('keypress', function (e) {
                                if (e.key === 'Enter') {
                                    jumpToPage();
                                }
                            });
                        }

                        const keywordInput = document.getElementById('keyword');
                        if (keywordInput && !keywordInput.value) {
                            keywordInput.focus();
                        }

                        const searchForm = document.querySelector('.search-form');
                        if (searchForm) {
                            searchForm.addEventListener('submit', function () {
                                const submitBtn = searchForm.querySelector('.btn-filter-primary');
                                if (submitBtn) {
                                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tìm...';
                                    submitBtn.disabled = true;
                                }
                            });
                        }
                    });
                </script>
            </body>

            </html>