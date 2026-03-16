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

        <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;0,700;1,400;1,600&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/additional-styles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

        <style>
            :root {
                --bg:        #f4f1eb;
                --surface:   #ffffff;
                --ink:       #1c1a17;
                --ink2:      #4a4640;
                --muted:     #9a948a;
                --teal:      #2d6a5e;
                --teal-lt:   #3d8b7a;
                --teal-bg:   #eaf3f1;
                --amber:     #c8892a;
                --green:     #2e7d32;
                --green-lt:  #388e3c;
                --line:      #e4dfd7;
                --shadow:    0 2px 16px rgba(28,26,23,.07);
                --shadow-lg: 0 12px 48px rgba(28,26,23,.13);
                --r:         10px;
            }

            *, *::before, *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                background: var(--bg);
                font-family: 'Outfit', sans-serif;
                color: var(--ink);
            }

            /* ── PAGE WRAP ─────────────────────────── */
            .bd-wrap {
                max-width: 1180px;
                margin: 0 auto;
                padding: 40px 24px 80px;
            }

            /* ── BREADCRUMB ────────────────────────── */
            .bd-breadcrumb {
                display: flex;
                align-items: center;
                gap: 6px;
                font-size: 13px;
                color: var(--muted);
                margin-bottom: 32px;
                flex-wrap: wrap;
            }
            .bd-breadcrumb a {
                color: var(--teal);
                text-decoration: none;
                transition: color .2s;
            }
            .bd-breadcrumb a:hover {
                color: var(--teal-lt);
            }
            .bd-breadcrumb .sep {
                color: var(--line);
            }
            .bd-breadcrumb .cur {
                color: var(--ink2);
                font-weight: 500;
            }

            /* ── HERO CARD ─────────────────────────── */
            .bd-hero {
                background: var(--surface);
                border-radius: var(--r);
                box-shadow: var(--shadow-lg);
                display: grid;
                grid-template-columns: 280px 1fr;
                overflow: hidden;
                margin-bottom: 28px;
                animation: riseUp .5s cubic-bezier(.22,.68,0,1.2) both;
            }
            @keyframes riseUp {
                from {
                    opacity:0;
                    transform:translateY(24px);
                }
                to   {
                    opacity:1;
                    transform:translateY(0);
                }
            }

            /* ── COVER PANEL ───────────────────────── */
            .bd-cover-panel {
                background: var(--ink);
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 48px 32px;
                position: relative;
                overflow: hidden;
            }
            .bd-cover-panel::after {
                content: '';
                position: absolute;
                inset: 0;
                background:
                    radial-gradient(ellipse at 30% 20%, rgba(45,106,94,.4) 0%, transparent 60%),
                    radial-gradient(ellipse at 80% 80%, rgba(200,137,42,.18) 0%, transparent 50%);
                pointer-events: none;
            }
            .bd-cover-panel img {
                width: 100%;
                max-width: 200px;
                border-radius: 6px;
                box-shadow: 0 20px 56px rgba(0,0,0,.55);
                position: relative;
                z-index: 1;
                transition: transform .4s ease;
            }
            .bd-cover-panel img:hover {
                transform: scale(1.03) rotate(-1deg);
            }

            /* ── INFO PANEL ────────────────────────── */
            .bd-info-panel {
                padding: 44px 48px 40px 44px;
                display: flex;
                flex-direction: column;
            }

            .bd-cat-tag {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                background: var(--teal-bg);
                color: var(--teal);
                font-size: 11px;
                font-weight: 600;
                letter-spacing: .12em;
                text-transform: uppercase;
                padding: 5px 12px;
                border-radius: 20px;
                margin-bottom: 18px;
                align-self: flex-start;
                text-decoration: none;
                transition: all .2s;
            }
            .bd-cat-tag:hover {
                background: var(--teal);
                color: #fff;
            }

            .bd-title {
                font-family: 'Cormorant Garamond', serif;
                font-size: clamp(28px, 3.5vw, 44px);
                font-weight: 700;
                line-height: 1.15;
                color: var(--ink);
                margin-bottom: 10px;
            }

            .bd-author-line {
                font-size: 15px;
                color: var(--muted);
                margin-bottom: 22px;
                display: flex;
                align-items: center;
                gap: 7px;
            }
            .bd-author-line a, .bd-author-line .name {
                color: var(--teal);
                font-weight: 500;
                font-style: italic;
                font-family: 'Cormorant Garamond', serif;
                font-size: 18px;
                text-decoration: none;
            }
            .bd-author-line a:hover {
                text-decoration: underline;
            }

            .bd-summary {
                font-family: 'Cormorant Garamond', serif;
                font-size: 18px;
                font-style: italic;
                color: var(--ink2);
                line-height: 1.7;
                border-left: 3px solid var(--teal);
                padding-left: 18px;
                margin-bottom: 28px;
            }

            /* ── PRICE BOX ─────────────────────────── */
            .bd-price-box {
                display: inline-flex;
                align-items: baseline;
                gap: 10px;
                background: var(--bg);
                border: 1px solid var(--line);
                border-radius: 8px;
                padding: 14px 24px;
                margin-bottom: 28px;
                align-self: flex-start;
            }
            .bd-price-num {
                font-family: 'Cormorant Garamond', serif;
                font-size: 30px;
                font-weight: 700;
                color: var(--teal);
            }
            .bd-price-unit {
                font-size: 13px;
                color: var(--muted);
            }
            .bd-price-box.free {
                background: #e8f5e9;
                border-color: #c8e6c9;
            }
            .bd-price-box.free .bd-price-num {
                color: var(--green);
                font-size: 22px;
            }

            /* ── BUTTONS ───────────────────────────── */
            .bd-actions {
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
                margin-top: auto;
            }
            .bd-btn {
                display: inline-flex;
                align-items: center;
                gap: 7px;
                height: 44px;
                padding: 0 22px;
                border-radius: 8px;
                font-family: 'Outfit', sans-serif;
                font-size: 13px;
                font-weight: 600;
                letter-spacing: .04em;
                text-decoration: none;
                cursor: pointer;
                border: none;
                transition: all .2s ease;
            }
            .bd-btn-teal  {
                background: var(--teal);
                color: #fff;
            }
            .bd-btn-teal:hover  {
                background: var(--teal-lt);
                color:#fff;
                transform:translateY(-2px);
                box-shadow:0 6px 20px rgba(45,106,94,.35);
            }
            .bd-btn-green {
                background: var(--green);
                color: #fff;
            }
            .bd-btn-green:hover {
                background: var(--green-lt);
                color:#fff;
                transform:translateY(-2px);
                box-shadow:0 6px 20px rgba(46,125,50,.3);
            }
            .bd-btn-outline {
                background: transparent;
                border: 1.5px solid var(--line);
                color: var(--ink2);
            }
            .bd-btn-outline:hover {
                border-color: var(--teal);
                color: var(--teal);
                background: var(--teal-bg);
            }

            /* ── DETAILS GRID ──────────────────────── */
            .bd-grid {
                display: grid;
                grid-template-columns: 1fr 360px;
                gap: 24px;
                animation: riseUp .55s .15s cubic-bezier(.22,.68,0,1.2) both;
            }
            .bd-left {
                display: flex;
                flex-direction: column;
                gap: 24px;
            }

            .bd-card {
                background: var(--surface);
                border-radius: var(--r);
                box-shadow: var(--shadow);
                overflow: hidden;
            }
            .bd-card-hd {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 16px 24px;
                border-bottom: 1px solid var(--line);
                font-size: 12px;
                font-weight: 600;
                letter-spacing: .1em;
                text-transform: uppercase;
                color: var(--muted);
            }
            .bd-card-hd i {
                color: var(--teal);
                font-size: 13px;
            }
            .bd-card-bd {
                padding: 24px;
            }

            .bd-desc {
                font-size: 15px;
                line-height: 1.85;
                color: var(--ink2);
            }

            /* ── STAT ROWS ─────────────────────────── */
            .bd-stat {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 13px 0;
                border-bottom: 1px solid var(--line);
                font-size: 14px;
            }
            .bd-stat:last-child {
                border-bottom: none;
            }
            .bd-stat-lbl {
                color: var(--muted);
            }
            .bd-stat-val {
                color: var(--ink);
                font-weight: 500;
            }
            .bd-stat-val.ok {
                color: var(--green);
            }

            /* ── AUTHOR BIO ────────────────────────── */
            .bd-bio-name {
                font-family: 'Cormorant Garamond', serif;
                font-size: 20px;
                font-weight: 600;
                color: var(--ink);
                margin-bottom: 8px;
            }
            .bd-bio-txt {
                font-size: 14px;
                line-height: 1.75;
                color: var(--ink2);
            }

            /* ── NOT FOUND ─────────────────────────── */
            .bd-notfound {
                text-align: center;
                padding: 80px 24px;
                background: var(--surface);
                border-radius: var(--r);
                box-shadow: var(--shadow);
            }
            .bd-notfound i {
                font-size: 48px;
                color: var(--line);
                margin-bottom: 16px;
                display: block;
            }
            .bd-notfound h4 {
                font-family:'Cormorant Garamond',serif;
                font-size:26px;
                margin-bottom:8px;
            }
            .bd-notfound p {
                color: var(--muted);
                margin-bottom: 24px;
            }

            /* ── SWP BADGE ─────────────────────────── */
            .student-badge {
                position: fixed;
                bottom: 20px;
                right: 20px;
                background: var(--ink);
                color: rgba(255,255,255,.8);
                font-size: 11px;
                font-weight: 500;
                letter-spacing: .08em;
                padding: 6px 14px;
                border-radius: 20px;
                display: flex;
                align-items: center;
                gap: 6px;
                z-index: 999;
            }
            .student-badge i {
                color: var(--amber);
            }

            /* ── RESPONSIVE ────────────────────────── */
            @media (max-width: 860px) {
                .bd-hero {
                    grid-template-columns: 1fr;
                }
                .bd-cover-panel {
                    padding: 36px 24px;
                }
                .bd-cover-panel img {
                    max-width: 160px;
                }
                .bd-info-panel {
                    padding: 28px 24px;
                }
                .bd-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>

    <body>
        <jsp:include page="/includes/navbar.jsp" />

        <div class="bd-wrap">

            <!-- Breadcrumb -->
            <nav class="bd-breadcrumb">
                <a href="${pageContext.request.contextPath}/"><i class="fas fa-house" style="font-size:11px;"></i>&nbsp;Trang chủ</a>
                <span class="sep">/</span>
                <a href="${pageContext.request.contextPath}/books">Danh sách sách</a>
                <span class="sep">/</span>
                <span class="cur">${book.title}</span>
            </nav>

            <c:choose>
                <c:when test="${not empty book}">

                    <!-- ── HERO ── -->
                    <div class="bd-hero">

                        <div class="bd-cover-panel">
                            <img src="${not empty book.coverUrl ? book.coverUrl : pageContext.request.contextPath.concat('/images/default-book.jpg')}"
                                 alt="${book.title}"
                                 onerror="this.src='https://via.placeholder.com/300x400/2d6a5e/ffffff?text=📚'">
                        </div>

                        <div class="bd-info-panel">

                            <!-- Category -->
                            <c:choose>
                                <c:when test="${not empty book.category}">
                                    <a href="${pageContext.request.contextPath}/categories/detail/${book.category.categoryId}" class="bd-cat-tag">
                                        <i class="fas fa-bookmark"></i> ${book.category.categoryName}
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="bd-cat-tag"><i class="fas fa-bookmark"></i> Chưa phân loại</span>
                                </c:otherwise>
                            </c:choose>

                            <!-- Title -->
                            <h1 class="bd-title">${book.title}</h1>

                            <!-- Author -->
                            <div class="bd-author-line">
                                <i class="fas fa-feather-pointed" style="color:var(--muted);font-size:11px;"></i>
                                <c:choose>
                                    <c:when test="${not empty book.author}">
                                        <a href="${pageContext.request.contextPath}/authors/detail/${book.author.authorId}" class="name">${book.author.authorName}</a>
                                    </c:when>
                                    <c:otherwise><span class="name">Chưa xác định</span></c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Summary -->
                            <c:if test="${not empty book.summary}">
                                <blockquote class="bd-summary">${book.summary}</blockquote>
                            </c:if>

                            <!-- Price -->
                            <div class="bd-price-box ${empty book.price or book.price == 0 ? 'free' : ''}">
                                <c:choose>
                                    <c:when test="${not empty book.price && book.price > 0}">
                                        <span class="bd-price-num">
                                            <fmt:formatNumber value="${book.price}" type="number" maxFractionDigits="0" />
                                        </span>
                                        <span class="bd-price-unit">${not empty book.currency ? book.currency : 'VNĐ'}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="bd-price-num"><i class="fas fa-gift" style="font-size:17px;"></i> Miễn phí</span>
                                        <span class="bd-price-unit">Đọc ngay không mất phí</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- Actions -->
                            <div class="bd-actions">
                                <a href="${pageContext.request.contextPath}/customer/add-to-cart?bookId=${book.bookId}&quantity=1"
                                   class="bd-btn bd-btn-green">
                                    <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                                </a>

                                <c:choose>
                                    <c:when test="${not empty sessionScope.user and sessionScope.userRole == 'Reader'}">
                                        <a href="${pageContext.request.contextPath}/customer/borrow-request?bookId=${book.bookId}"
                                           class="bd-btn bd-btn-teal">
                                            <i class="fas fa-hand-holding"></i> Mượn sách
                                        </a>
                                        <form action="${pageContext.request.contextPath}/customer/reservations" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="create" />
                                            <input type="hidden" name="bookId" value="${book.bookId}" />
                                            <button type="submit" class="bd-btn bd-btn-outline">
                                                <i class="fas fa-clock-rotate-left"></i> Đặt sách
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/auth/login"
                                           class="bd-btn bd-btn-teal">
                                            <i class="fas fa-hand-holding"></i> Mượn sách
                                        </a>
                                    </c:otherwise>
                                </c:choose>

                                <c:choose>
                                    <c:when test="${empty book.price or book.price == 0}">
                                        <a href="${pageContext.request.contextPath}/customer/read?bookId=${book.bookId}"
                                           class="bd-btn bd-btn-teal">
                                            <i class="fas fa-book-open"></i> Đọc ngay
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/books/preview/${book.bookId}"
                                           class="bd-btn bd-btn-teal">
                                            <i class="fas fa-eye"></i>
                                            Xem trước (${book.previewPages} trang)
                                        </a>
                                    </c:otherwise>
                                </c:choose>

                                <a href="#" class="bd-btn bd-btn-outline" onclick="addToFavorites()">
                                    <i class="fas fa-heart"></i> Yêu thích
                                </a>

                                <a href="${pageContext.request.contextPath}/books" class="bd-btn bd-btn-outline">
                                    <i class="fas fa-arrow-left"></i> Quay lại
                                </a>

                                <c:if test="${canManageBooks}">
                                    <a href="${pageContext.request.contextPath}/books/upload/${book.bookId}"
                                       class="bd-btn bd-btn-outline">
                                        <i class="fas fa-upload"></i> Cập nhật file
                                    </a>
                                </c:if>
                            </div>

                        </div>
                    </div>

                    <!-- ── DETAILS GRID ── -->
                    <div class="bd-grid">

                        <div class="bd-left">
                            <c:if test="${not empty book.description}">
                                <div class="bd-card">
                                    <div class="bd-card-hd"><i class="fas fa-align-left"></i> Mô tả chi tiết</div>
                                    <div class="bd-card-bd"><p class="bd-desc">${book.description}</p></div>
                                </div>
                            </c:if>

                            <c:if test="${not empty book.author && not empty book.author.bio}">
                                <div class="bd-card">
                                    <div class="bd-card-hd"><i class="fas fa-user-circle"></i> Về tác giả</div>
                                    <div class="bd-card-bd">
                                        <p class="bd-bio-name">${book.author.authorName}</p>
                                        <p class="bd-bio-txt">${book.author.bio}</p>
                                    </div>
                                </div>
                            </c:if>
                        </div>

                        <!-- Stats sidebar -->
                        <div class="bd-card" style="align-self:start;">
                            <div class="bd-card-hd"><i class="fas fa-circle-info"></i> Thông tin sách</div>
                            <div class="bd-card-bd">

                                <c:if test="${not empty book.totalPages}">
                                    <div class="bd-stat">
                                        <span class="bd-stat-lbl">Số trang</span>
                                        <span class="bd-stat-val">${book.totalPages} trang</span>
                                    </div>
                                </c:if>

                                <c:if test="${not empty book.previewPages}">
                                    <div class="bd-stat">
                                        <span class="bd-stat-lbl">Trang xem trước</span>
                                        <span class="bd-stat-val">${book.previewPages} trang</span>
                                    </div>
                                </c:if>

                                <div class="bd-stat">
                                    <span class="bd-stat-lbl">Trạng thái</span>
                                    <span class="bd-stat-val ok"><i class="fas fa-circle-check"></i> Có sẵn</span>
                                </div>

                                <c:if test="${not empty createdAtFormatted}">
                                    <div class="bd-stat">
                                        <span class="bd-stat-lbl">Ngày thêm</span>
                                        <span class="bd-stat-val">
                                            ${createdAtFormatted}
                                        </span>
                                    </div>
                                </c:if>

                                <c:if test="${not empty book.author}">
                                    <div class="bd-stat">
                                        <span class="bd-stat-lbl">Tác giả</span>
                                        <span class="bd-stat-val">${book.author.authorName}</span>
                                    </div>
                                </c:if>

                                <c:if test="${not empty book.category}">
                                    <div class="bd-stat">
                                        <span class="bd-stat-lbl">Thể loại</span>
                                        <span class="bd-stat-val">${book.category.categoryName}</span>
                                    </div>
                                </c:if>

                                <c:if test="${not empty book.currency}">
                                    <div class="bd-stat">
                                        <span class="bd-stat-lbl">Đơn vị tiền tệ</span>
                                        <span class="bd-stat-val">${book.currency}</span>
                                    </div>
                                </c:if>

                            </div>
                        </div>

                    </div>

                </c:when>
                <c:otherwise>
                    <div class="bd-notfound">
                        <i class="fas fa-triangle-exclamation"></i>
                        <h4>Không tìm thấy sách</h4>
                        <p>Sách bạn đang tìm kiếm không tồn tại hoặc đã bị xóa.</p>
                        <a href="${pageContext.request.contextPath}/books" class="bd-btn bd-btn-teal">
                            <i class="fas fa-arrow-left"></i> Quay lại danh sách sách
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

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

        <script>
            function readBook() {
                alert('Tính năng đọc sách sẽ được phát triển trong phiên bản tiếp theo!');
            }
            function addToFavorites() {
                alert('Đã thêm vào danh sách yêu thích!');
            }
            document.addEventListener('DOMContentLoaded', function () {
                const cards = document.querySelectorAll('.bd-card');
                cards.forEach((card, i) => {
                    card.style.animationDelay = (0.2 + i * 0.1) + 's';
                });
            });
        </script>
    </body>
</html>
