<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${pageTitle}</title>

        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/additional-styles.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/author-category-styles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            .detail-container {
                background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                min-height: 100vh;
                padding: 2rem 0;
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

            .author-hero {
                background: white;
                border-radius: 24px;
                box-shadow: 0 20px 60px rgba(0,0,0,0.1);
                overflow: hidden;
                margin-bottom: 2rem;
                animation: slideUp 0.6s ease-out;
            }

            .author-banner {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                padding: 3rem 2rem;
                display: flex;
                align-items: center;
                gap: 2rem;
                flex-wrap: wrap;
            }

            .author-avatar {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                background: rgba(255,255,255,0.2);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 3rem;
                color: white;
                flex-shrink: 0;
                border: 4px solid rgba(255,255,255,0.4);
            }

            .author-banner-info h1 {
                font-family: 'Playfair Display', serif;
                font-size: 2.2rem;
                color: white;
                margin: 0 0 0.5rem 0;
            }

            .author-banner-info .author-book-count {
                color: rgba(255,255,255,0.85);
                font-family: 'Inter', sans-serif;
                font-size: 1rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .author-body {
                padding: 2.5rem 3rem;
            }

            .author-bio-section {
                margin-bottom: 2rem;
            }

            .author-bio-section h3 {
                font-family: 'Playfair Display', serif;
                font-size: 1.3rem;
                color: #1a202c;
                margin-bottom: 0.75rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .author-bio-section p {
                font-family: 'Inter', sans-serif;
                color: #4a5568;
                line-height: 1.8;
                font-size: 1rem;
            }

            .author-actions {
                display: flex;
                gap: 1rem;
                flex-wrap: wrap;
                margin-top: 1.5rem;
            }

            .btn-primary-modern {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 10px;
                color: white;
                font-family: 'Inter', sans-serif;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
            }

            .btn-primary-modern:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.4);
                color: white;
                text-decoration: none;
            }

            .btn-outline-modern {
                background: transparent;
                border: 2px solid #667eea;
                padding: 0.75rem 1.5rem;
                border-radius: 10px;
                color: #667eea;
                font-family: 'Inter', sans-serif;
                font-weight: 600;
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

            .btn-warning-modern {
                background: linear-gradient(135deg, #f6ad55 0%, #ed8936 100%);
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 10px;
                color: white;
                font-family: 'Inter', sans-serif;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
            }

            .btn-warning-modern:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(237, 137, 54, 0.4);
                color: white;
                text-decoration: none;
            }

            /* Books Section */
            .books-section {
                margin-top: 1rem;
            }

            .section-title {
                font-family: 'Playfair Display', serif;
                font-size: 1.6rem;
                color: #1a202c;
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }

            .section-title .badge {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                font-family: 'Inter', sans-serif;
                font-size: 0.85rem;
                font-weight: 600;
                padding: 0.3rem 0.75rem;
                border-radius: 20px;
            }

            .books-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
                gap: 1.5rem;
            }

            .book-card {
                background: white;
                border-radius: 16px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.08);
                border: 1px solid #e2e8f0;
                overflow: hidden;
                transition: all 0.3s ease;
                animation: fadeIn 0.5s ease-out;
            }

            .book-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 30px rgba(0,0,0,0.15);
            }

            .book-card-cover {
                width: 100%;
                height: 180px;
                object-fit: cover;
                background: linear-gradient(135deg, #667eea, #764ba2);
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 2.5rem;
            }

            .book-card-cover img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .book-card-body {
                padding: 1rem 1.25rem;
            }

            .book-card-title {
                font-family: 'Inter', sans-serif;
                font-weight: 600;
                font-size: 0.95rem;
                color: #1a202c;
                margin-bottom: 0.4rem;
                line-height: 1.4;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
            }

            .book-card-category {
                font-family: 'Inter', sans-serif;
                font-size: 0.8rem;
                color: #718096;
                margin-bottom: 0.75rem;
            }

            .book-card-price {
                font-family: 'Inter', sans-serif;
                font-size: 0.9rem;
                font-weight: 600;
                color: #667eea;
                margin-bottom: 0.75rem;
            }

            .book-card-price.free {
                color: #48bb78;
            }

            .book-card-footer {
                padding: 0.75rem 1.25rem;
                border-top: 1px solid #e2e8f0;
                background: #f8fafc;
            }

            .book-card-footer a {
                font-family: 'Inter', sans-serif;
                font-size: 0.85rem;
                color: #667eea;
                text-decoration: none;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 0.4rem;
                transition: color 0.2s;
            }

            .book-card-footer a:hover {
                color: #764ba2;
            }

            .no-books {
                text-align: center;
                padding: 3rem;
                background: white;
                border-radius: 16px;
                border: 2px dashed #e2e8f0;
                color: #718096;
                font-family: 'Inter', sans-serif;
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
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @media (max-width: 768px) {
                .author-banner {
                    flex-direction: column;
                    text-align: center;
                }
                .author-body {
                    padding: 1.5rem;
                }
                .author-banner-info h1 {
                    font-size: 1.7rem;
                }
                .books-grid {
                    grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
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
                        <li><a href="${pageContext.request.contextPath}/books" class="nav-link">
                                <i class="fas fa-search"></i> Tìm sách
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/authors" class="nav-link active">
                                <i class="fas fa-user-edit"></i> Tác giả
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/categories" class="nav-link">
                                <i class="fas fa-tags"></i> Thể loại
                            </a></li>
                    </ul>
                </nav>
            </div>
        </header>

        <div class="detail-container">
            <div class="container">
                <!-- Breadcrumb -->
                <nav class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Trang chủ</a>
                    <span class="breadcrumb-separator">/</span>
                    <a href="${pageContext.request.contextPath}/authors">Danh sách tác giả</a>
                    <span class="breadcrumb-separator">/</span>
                    <span style="color: #718096;">${author.authorName}</span>
                </nav>

                <c:choose>
                    <c:when test="${not empty author}">
                        <!-- Author Hero -->
                        <div class="author-hero">
                            <div class="author-banner">
                                <div class="author-avatar">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div class="author-banner-info">
                                    <h1>${author.authorName}</h1>
                                    <div class="author-book-count">
                                        <i class="fas fa-book"></i>
                                        ${bookCount} cuốn sách trong thư viện
                                    </div>
                                </div>
                            </div>

                            <div class="author-body">
                                <c:if test="${not empty author.bio}">
                                    <div class="author-bio-section">
                                        <h3><i class="fas fa-info-circle"></i> Giới thiệu</h3>
                                        <p>${author.bio}</p>
                                    </div>
                                </c:if>

                                <div class="author-actions">
                                    <a href="${pageContext.request.contextPath}/books?authorId=${author.authorId}"
                                       class="btn-primary-modern">
                                        <i class="fas fa-book-open"></i> Xem tất cả sách
                                    </a>
                                    <c:if test="${canManageCatalog}">
                                        <a href="${pageContext.request.contextPath}/authors/edit/${author.authorId}"
                                           class="btn-warning-modern">
                                            <i class="fas fa-edit"></i> Chỉnh sửa
                                        </a>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/authors"
                                       class="btn-outline-modern">
                                        <i class="fas fa-arrow-left"></i> Quay lại
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Books by this Author -->
                        <div class="books-section">
                            <h2 class="section-title">
                                <i class="fas fa-books"></i>
                                Tác phẩm của ${author.authorName}
                                <span class="badge">${bookCount} cuốn</span>
                            </h2>

                            <c:choose>
                                <c:when test="${not empty authorBooks}">
                                    <div class="books-grid">
                                        <c:forEach var="book" items="${authorBooks}">
                                            <div class="book-card">
                                                <div class="book-card-cover">
                                                    <c:choose>
                                                        <c:when test="${not empty book.coverUrl}">
                                                            <img src="${book.coverUrl}" alt="${book.title}"
                                                                 onerror="this.parentElement.innerHTML='<i class=\'fas fa-book\'></i>'">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fas fa-book"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="book-card-body">
                                                    <div class="book-card-title">${book.title}</div>
                                                    <c:if test="${not empty book.category}">
                                                        <div class="book-card-category">
                                                            <i class="fas fa-tag"></i> ${book.category.categoryName}
                                                        </div>
                                                    </c:if>
                                                    <div class="book-card-price ${(empty book.price || book.price == 0) ? 'free' : ''}">
                                                        <c:choose>
                                                            <c:when test="${not empty book.price && book.price > 0}">
                                                                <i class="fas fa-tag"></i>
                                                                <fmt:formatNumber value="${book.price}" type="number" maxFractionDigits="0"/>
                                                                ${not empty book.currency ? book.currency : 'VNĐ'}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="fas fa-gift"></i> Miễn phí
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                                <div class="book-card-footer">
                                                    <a href="${pageContext.request.contextPath}/books/detail/${book.bookId}">
                                                        <i class="fas fa-eye"></i> Xem chi tiết
                                                    </a>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-books">
                                        <i class="fas fa-book-open fa-3x" style="margin-bottom: 1rem; color: #cbd5e0;"></i>
                                        <p style="font-size: 1rem;">Chưa có sách nào của tác giả này trong thư viện.</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning text-center" style="padding: 3rem; background: white; border-radius: 16px;">
                            <i class="fas fa-exclamation-triangle fa-3x" style="color: #ed8936; margin-bottom: 1rem;"></i>
                            <h4>Không tìm thấy tác giả</h4>
                            <p>Tác giả bạn đang tìm không tồn tại hoặc đã bị xóa.</p>
                            <a href="${pageContext.request.contextPath}/authors" class="btn-primary-modern" style="margin-top: 1rem; display: inline-flex;">
                                <i class="fas fa-arrow-left"></i> Quay lại danh sách tác giả
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

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
    </body>
</html>
