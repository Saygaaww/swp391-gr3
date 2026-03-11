<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${book.title} - Thư viện Số FPT</title>
                <meta name="description" content="${book.summary}">

                <!-- Fonts -->
                <link
                    href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap"
                    rel="stylesheet">

                <!-- CSS -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/additional-styles.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

                <style>
                    /* Book Detail Specific Styles */
                    .book-detail-container {
                        background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                        min-height: 100vh;
                        padding: 2rem 0;
                    }

                    .book-hero {
                        background: white;
                        border-radius: 24px;
                        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                        margin-bottom: 3rem;
                    }

                    .book-cover-section {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        padding: 4rem 2rem;
                        position: relative;
                    }

                    .book-cover-section::before {
                        content: '';
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="0.5" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="0.3" fill="rgba(255,255,255,0.05)"/><circle cx="50" cy="50" r="0.2" fill="rgba(255,255,255,0.08)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
                        opacity: 0.5;
                    }

                    .book-cover-image {
                        max-width: 300px;
                        width: 100%;
                        height: auto;
                        border-radius: 16px;
                        box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
                        transition: transform 0.5s ease;
                        position: relative;
                        z-index: 2;
                    }

                    .book-cover-image:hover {
                        transform: translateY(-8px) rotateY(5deg);
                    }

                    .book-info-section {
                        padding: 3rem;
                        background: white;
                    }

                    .book-title {
                        font-family: 'Playfair Display', serif;
                        font-size: 2.5rem;
                        font-weight: 700;
                        color: #1a202c;
                        margin-bottom: 1rem;
                        line-height: 1.2;
                    }

                    .book-author {
                        font-family: 'Inter', sans-serif;
                        font-size: 1.2rem;
                        color: #667eea;
                        font-weight: 500;
                        margin-bottom: 0.5rem;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .book-category {
                        font-family: 'Inter', sans-serif;
                        font-size: 1rem;
                        color: #718096;
                        margin-bottom: 2rem;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .book-summary {
                        font-family: 'Inter', sans-serif;
                        font-size: 1.1rem;
                        color: #4a5568;
                        line-height: 1.8;
                        margin-bottom: 2rem;
                        font-style: italic;
                        padding-left: 1rem;
                        border-left: 4px solid #667eea;
                    }

                    .book-price-section {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        padding: 1.5rem 2rem;
                        border-radius: 16px;
                        margin-bottom: 2rem;
                        text-align: center;
                    }

                    .book-price {
                        font-family: 'Playfair Display', serif;
                        font-size: 2rem;
                        font-weight: 600;
                        margin-bottom: 0.5rem;
                    }

                    .price-free {
                        color: #48bb78;
                        background: rgba(72, 187, 120, 0.1);
                        padding: 0.5rem 1rem;
                        border-radius: 8px;
                        display: inline-block;
                    }

                    .book-actions {
                        display: flex;
                        gap: 1rem;
                        margin-bottom: 3rem;
                        flex-wrap: wrap;
                    }

                    .btn-primary-modern {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border: none;
                        padding: 1rem 2rem;
                        border-radius: 12px;
                        color: white;
                        font-family: 'Inter', sans-serif;
                        font-weight: 600;
                        font-size: 1.1rem;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .btn-primary-modern:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
                        color: white;
                        text-decoration: none;
                    }

                    .btn-outline-modern {
                        background: transparent;
                        border: 2px solid #667eea;
                        padding: 1rem 2rem;
                        border-radius: 12px;
                        color: #667eea;
                        font-family: 'Inter', sans-serif;
                        font-weight: 600;
                        font-size: 1.1rem;
                        cursor: pointer;
                        transition: all 0.3s ease;
                        text-decoration: none;
                        display: inline-flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .btn-outline-modern:hover {
                        background: #667eea;
                        color: white;
                        transform: translateY(-2px);
                        text-decoration: none;
                    }

                    .book-details-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                        gap: 2rem;
                        margin-bottom: 3rem;
                    }

                    .detail-card {
                        background: white;
                        border-radius: 16px;
                        padding: 2rem;
                        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                        border: 1px solid #e2e8f0;
                    }

                    .detail-card h3 {
                        font-family: 'Playfair Display', serif;
                        font-size: 1.4rem;
                        color: #1a202c;
                        margin-bottom: 1rem;
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                    }

                    .detail-card p {
                        font-family: 'Inter', sans-serif;
                        color: #4a5568;
                        line-height: 1.7;
                        margin: 0;
                    }

                    .stats-item {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 0.75rem 0;
                        border-bottom: 1px solid #e2e8f0;
                    }

                    .stats-item:last-child {
                        border-bottom: none;
                    }

                    .stats-label {
                        font-family: 'Inter', sans-serif;
                        color: #718096;
                        font-weight: 500;
                    }

                    .stats-value {
                        font-family: 'Inter', sans-serif;
                        color: #1a202c;
                        font-weight: 600;
                    }

                    .breadcrumb {
                        background: transparent;
                        padding: 1rem 0;
                        margin-bottom: 2rem;
                    }

                    .breadcrumb a {
                        color: #667eea;
                        text-decoration: none;
                        font-family: 'Inter', sans-serif;
                        transition: color 0.2s ease;
                    }

                    .breadcrumb a:hover {
                        color: #764ba2;
                    }

                    .breadcrumb-separator {
                        margin: 0 0.5rem;
                        color: #a0aec0;
                    }

                    /* Responsive Design */
                    @media (max-width: 768px) {
                        .book-hero {
                            border-radius: 16px;
                        }

                        .book-cover-section {
                            padding: 2rem 1rem;
                            text-align: center;
                        }

                        .book-info-section {
                            padding: 2rem 1.5rem;
                        }

                        .book-title {
                            font-size: 2rem;
                        }

                        .book-actions {
                            flex-direction: column;
                        }

                        .btn-primary-modern,
                        .btn-outline-modern {
                            width: 100%;
                            justify-content: center;
                        }
                    }

                    /* Animation for page load */
                    .book-hero {
                        animation: slideUp 0.6s ease-out;
                    }

                    .detail-card {
                        animation: fadeIn 0.8s ease-out;
                        animation-delay: 0.2s;
                        animation-fill-mode: both;
                    }

                    @keyframes slideUp {
                        from {
                            transform: translateY(30px);
                            opacity: 0;
                        }

                        to {
                            transform: translateY(0);
                            opacity: 1;
                        }
                    }

                    @keyframes fadeIn {
                        from {
                            opacity: 0;
                            transform: translateY(20px);
                        }

                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }
                </style>
            </head>

            <body>
                <!-- Header -->
                <jsp:include page="/includes/navbar.jsp" />

                <div class="book-detail-container">
                    <div class="container">
                        <!-- Breadcrumb -->
                        <nav class="breadcrumb">
                            <a href="${pageContext.request.contextPath}/">
                                <i class="fas fa-home"></i> Trang chủ
                            </a>
                            <span class="breadcrumb-separator">/</span>
                            <a href="${pageContext.request.contextPath}/books">Danh sách sách</a>
                            <span class="breadcrumb-separator">/</span>
                            <span style="color: #718096;">${book.title}</span>
                        </nav>

                        <c:choose>
                            <c:when test="${not empty book}">
                                <!-- Book Hero Section -->
                                <div class="book-hero">
                                    <div class="row g-0">
                                        <div class="col-md-4">
                                            <div
                                                class="book-cover-section d-flex justify-content-center align-items-center">
                                                <img src="${not empty book.coverUrl ? book.coverUrl : pageContext.request.contextPath.concat('/images/default-book.jpg')}"
                                                    class="book-cover-image" alt="${book.title}"
                                                    onerror="this.src='https://via.placeholder.com/300x400/667eea/ffffff?text=📚'">
                                            </div>
                                        </div>
                                        <div class="col-md-8">
                                            <div class="book-info-section">
                                                <h1 class="book-title">${book.title}</h1>

                                                <div class="book-author">
                                                    <i class="fas fa-user-edit"></i>
                                                    <c:choose>
                                                        <c:when test="${not empty book.author}">
                                                            <a href="${pageContext.request.contextPath}/authors/detail/${book.author.authorId}"
                                                                style="color: inherit; text-decoration: none;">
                                                                ${book.author.authorName}
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span>Chưa xác định</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <div class="book-category">
                                                    <i class="fas fa-bookmark"></i>
                                                    <c:choose>
                                                        <c:when test="${not empty book.category}">
                                                            <a href="${pageContext.request.contextPath}/categories/detail/${book.category.categoryId}"
                                                                style="color: inherit; text-decoration: none;">
                                                                ${book.category.categoryName}
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span>Chưa phân loại</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <c:if test="${not empty book.summary}">
                                                    <div class="book-summary">
                                                        "${book.summary}"
                                                    </div>
                                                </c:if>

                                                <!-- Price Section -->
                                                <div class="book-price-section">
                                                    <c:choose>
                                                        <c:when test="${not empty book.price && book.price > 0}">
                                                            <div class="book-price">
                                                                <fmt:formatNumber value="${book.price}" type="number"
                                                                    maxFractionDigits="0" />
                                                                ${not empty book.currency ? book.currency : 'VNĐ'}
                                                            </div>
                                                            <small>Giá bán chính thức</small>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="book-price price-free">
                                                                <i class="fas fa-gift"></i>
                                                                Miễn phí
                                                            </div>
                                                            <small>Đọc ngay không mất phí</small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <!-- Action Buttons -->
                                                <div class="book-actions">
                                                    <a href="${pageContext.request.contextPath}/customer/add-to-cart?bookId=${book.bookId}&quantity=1"
                                                        class="btn-primary-modern" style="background: #10b981;">
                                                        <i class="fas fa-cart-plus"></i>
                                                        Thêm vào giỏ
                                                    </a>
                                                    <a href="#" class="btn-primary-modern" onclick="readBook()">
                                                        <i class="fas fa-book-open"></i>
                                                        Đọc ngay
                                                    </a>
                                                    <a href="#" class="btn-outline-modern" onclick="addToFavorites()">
                                                        <i class="fas fa-heart"></i>
                                                        Yêu thích
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/books"
                                                        class="btn-outline-modern">
                                                        <i class="fas fa-arrow-left"></i>
                                                        Quay lại
                                                    </a>
                                                    <c:if test="${canManageBooks}">
                                                        <a href="${pageContext.request.contextPath}/books/upload/${book.bookId}"
                                                            class="btn-outline-modern">
                                                            <i class="fas fa-upload"></i>
                                                            Cập nhật file
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Book Details Grid -->
                                <div class="book-details-grid">
                                    <!-- Description Card -->
                                    <c:if test="${not empty book.description}">
                                        <div class="detail-card">
                                            <h3>
                                                <i class="fas fa-align-left"></i>
                                                Mô tả chi tiết
                                            </h3>
                                            <p>${book.description}</p>
                                        </div>
                                    </c:if>

                                    <!-- Book Stats Card -->
                                    <div class="detail-card">
                                        <h3>
                                            <i class="fas fa-chart-bar"></i>
                                            Thông tin sách
                                        </h3>
                                        <div class="book-stats">
                                            <c:if test="${not empty book.totalPages}">
                                                <div class="stats-item">
                                                    <span class="stats-label">Số trang</span>
                                                    <span class="stats-value">${book.totalPages} trang</span>
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty book.previewPages}">
                                                <div class="stats-item">
                                                    <span class="stats-label">Trang xem trước</span>
                                                    <span class="stats-value">${book.previewPages} trang</span>
                                                </div>
                                            </c:if>

                                            <div class="stats-item">
                                                <span class="stats-label">Trạng thái</span>
                                                <span class="stats-value" style="color: #48bb78;">
                                                    <i class="fas fa-check-circle"></i>
                                                    Có sẵn
                                                </span>
                                            </div>

                                            <c:if test="${not empty book.createdAt}">
                                                <div class="stats-item">
                                                    <span class="stats-label">Ngày thêm</span>
                                                    <span class="stats-value">
                                                        <fmt:formatDate value="${book.createdAt}"
                                                            pattern="dd/MM/yyyy" />
                                                    </span>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <!-- Author Info Card -->
                                    <c:if test="${not empty book.author && not empty book.author.bio}">
                                        <div class="detail-card">
                                            <h3>
                                                <i class="fas fa-user-circle"></i>
                                                Về tác giả
                                            </h3>
                                            <p><strong>${book.author.authorName}</strong></p>
                                            <p>${book.author.bio}</p>
                                        </div>
                                    </c:if>
                                </div>

                            </c:when>
                            <c:otherwise>
                                <!-- Book Not Found -->
                                <div class="alert alert-warning text-center">
                                    <div class="no-results-content">
                                        <i class="fas fa-exclamation-triangle fa-3x mb-3"></i>
                                        <h4>Không tìm thấy sách</h4>
                                        <p>Sách bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                                        <a href="${pageContext.request.contextPath}/books"
                                            class="btn-primary-modern mt-3">
                                            <i class="fas fa-arrow-left"></i>
                                            Quay lại danh sách sách
                                        </a>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Footer -->
                <footer class="main-footer">
                    <div class="container">
                        <div class="footer-content">
                            <h3>Thư viện Số FPT University</h3>
                            <p>Dự án SWP391 - Hệ thống quản lý thư viện số hiện đại</p>
                        </div>
                    </div>
                </footer>

                <div class="student-badge">
                    <i class="fas fa-graduation-cap"></i>
                    SWP391 Project
                </div>

                <!-- JavaScript -->
                <script>
                    function readBook() {
                        alert('Tính năng đọc sách sẽ được phát triển trong phiên bản tiếp theo!');
                    }

                    function addToFavorites() {
                        alert('Đã thêm vào danh sách yêu thích!');
                    }

                    // Smooth scroll animation
                    document.addEventListener('DOMContentLoaded', function () {
                        // Add loading animation
                        const detailCards = document.querySelectorAll('.detail-card');
                        detailCards.forEach((card, index) => {
                            card.style.animationDelay = (0.2 + index * 0.1) + 's';
                        });
                    });
                </script>
            </body>

            </html>