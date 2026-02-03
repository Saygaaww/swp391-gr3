<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Book"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Digital Library - Thư Viện Số</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Books Section Styles */
        .books-section {
            padding: 80px 0;
            background: var(--bg-secondary);
        }
        
        .books-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }
        
        .book-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--shadow-md);
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .book-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-xl);
        }
        
        .book-cover {
            width: 100%;
            height: 300px;
            background: var(--gradient-primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 64px;
            position: relative;
            overflow: hidden;
        }
        
        .book-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .book-info {
            padding: 20px;
        }
        
        .book-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 10px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .book-author {
            color: var(--text-secondary);
            font-size: 14px;
            margin-bottom: 8px;
        }
        
        .book-category {
            display: inline-block;
            background: var(--bg-tertiary);
            color: var(--text-secondary);
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            margin-bottom: 12px;
        }
        
        .book-price {
            font-size: 20px;
            font-weight: 700;
            color: var(--primary);
            margin-top: 10px;
        }
        
        .book-price.free {
            color: #10b981;
        }
        
        .view-all-books {
            text-align: center;
            margin-top: 40px;
        }
        
        @media (max-width: 768px) {
            .books-grid {
                grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
                gap: 20px;
            }
        }
    </style>
    <style>
        /* Fallback styles in case CSS doesn't load */
        body {
            font-family: 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
        }
        /* Temporary styles to ensure page displays correctly */
        .hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
            color: white !important;
        }
        .navbar {
            background: rgba(255, 255, 255, 0.95) !important;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-logo">
                <a href="<%= request.getContextPath() %>/" style="text-decoration: none; color: inherit; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-book-reader"></i>
                    <span>Digital Library</span>
                </a>
            </div>
            <div class="nav-menu">
                <a href="#features" class="nav-link">Tính Năng</a>
                <a href="#about" class="nav-link">Giới Thiệu</a>
                <a href="#contact" class="nav-link">Liên Hệ</a>
                <a href="<%= request.getContextPath() %>/pages/browse" class="nav-link">Duyệt sách</a>
                <a href="<%= request.getContextPath() %>/pages/register" class="nav-link">Đăng ký</a>
                <a href="<%= request.getContextPath() %>/login" class="btn-login-nav">
                    <i class="fas fa-sign-in-alt"></i>
                    Đăng Nhập
                </a>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-container">
            <div class="hero-content">
                <h1 class="hero-title">
                    Khám Phá Thế Giới <span class="highlight">Tri Thức</span>
                </h1>
                <p class="hero-subtitle">
                    Thư viện số hiện đại với hàng ngàn đầu sách, tài liệu chất lượng cao. 
                    Đọc mọi lúc, mọi nơi trên mọi thiết bị.
                </p>
                <div class="hero-buttons">
                    <a href="<%= request.getContextPath() %>/books" class="btn-primary">
                        <i class="fas fa-book"></i>
                        Xem Sách Miễn Phí
                    </a>
                    <a href="<%= request.getContextPath() %>/login" class="btn-secondary">
                        <i class="fas fa-sign-in-alt"></i>
                        Đăng Nhập Để Mượn Sách
                    </a>
                </div>
                <div class="hero-stats">
                    <div class="stat-item">
                        <div class="stat-number">10,000+</div>
                        <div class="stat-label">Đầu Sách</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">50,000+</div>
                        <div class="stat-label">Thành Viên</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">24/7</div>
                        <div class="stat-label">Hỗ Trợ</div>
                    </div>
                </div>
            </div>
            <div class="hero-image">
                <div class="floating-book">
                    <i class="fas fa-book"></i>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="features">
        <div class="container">
            <h2 class="section-title">Tính Năng Nổi Bật</h2>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-book-open"></i>
                    </div>
                    <h3>Đọc Sách Online</h3>
                    <p>Đọc sách trực tuyến với giao diện thân thiện, hỗ trợ nhiều định dạng</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-download"></i>
                    </div>
                    <h3>Tải Về Offline</h3>
                    <p>Tải sách về máy để đọc offline, không cần kết nối internet</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-bookmark"></i>
                    </div>
                    <h3>Đánh Dấu Trang</h3>
                    <p>Lưu lại vị trí đọc và đánh dấu các trang quan trọng</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <h3>Tìm Kiếm Thông Minh</h3>
                    <p>Tìm kiếm sách nhanh chóng với công nghệ tìm kiếm tiên tiến</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-mobile-alt"></i>
                    </div>
                    <h3>Đa Nền Tảng</h3>
                    <p>Truy cập trên mọi thiết bị: máy tính, tablet, điện thoại</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <h3>Đánh Giá & Review</h3>
                    <p>Chia sẻ đánh giá và nhận xét về các cuốn sách yêu thích</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Books Section -->
    <section id="books" class="books-section">
        <div class="container">
            <h2 class="section-title">Sách Nổi Bật</h2>
            <p style="text-align: center; color: var(--text-secondary); margin-bottom: 20px;">
                Khám phá những cuốn sách miễn phí được yêu thích nhất
            </p>
            
            <%
                List<Book> featuredBooks = (List<Book>) request.getAttribute("featuredBooks");
                if (featuredBooks != null && !featuredBooks.isEmpty()) {
            %>
            <div class="books-grid">
                <% for (Book book : featuredBooks) { %>
                <div class="book-card" onclick="window.location.href='<%= request.getContextPath() %>/books/view?id=<%= book.getBookId() %>'">
                    <div class="book-cover">
                        <% if (book.getCoverUrl() != null && !book.getCoverUrl().isEmpty()) { %>
                        <img src="<%= book.getCoverUrl() %>" alt="<%= book.getTitle() %>">
                        <% } else { %>
                        <i class="fas fa-book"></i>
                        <% } %>
                    </div>
                    <div class="book-info">
                        <div class="book-title"><%= book.getTitle() %></div>
                        <% if (book.getAuthor() != null) { %>
                        <div class="book-author">
                            <i class="fas fa-user"></i> <%= book.getAuthor().getAuthorName() %>
                        </div>
                        <% } %>
                        <% if (book.getCategory() != null) { %>
                        <span class="book-category"><%= book.getCategory().getCategoryName() %></span>
                        <% } %>
                        <% if (book.getPrice() != null && book.getPrice().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                        <div class="book-price">
                            <%= String.format("%,.0f", book.getPrice()) %> 
                            <%= book.getCurrency() != null ? book.getCurrency() : "VND" %>
                        </div>
                        <% } else { %>
                        <div class="book-price free">
                            <i class="fas fa-gift"></i> Miễn Phí
                        </div>
                        <% } %>
                    </div>
                </div>
                <% } %>
            </div>
            
            <div class="view-all-books">
                <a href="<%= request.getContextPath() %>/books" class="btn-primary" style="display: inline-flex; align-items: center; gap: 8px;">
                    <i class="fas fa-book"></i>
                    Xem Tất Cả Sách
                </a>
            </div>
            <% } else { %>
            <div style="text-align: center; padding: 40px; color: var(--text-secondary);">
                <i class="fas fa-book-open" style="font-size: 48px; margin-bottom: 20px; opacity: 0.5;"></i>
                <p>Chưa có sách nào. Hãy quay lại sau!</p>
                <a href="<%= request.getContextPath() %>/books" class="btn-primary" style="margin-top: 20px; display: inline-flex; align-items: center; gap: 8px;">
                    <i class="fas fa-book"></i>
                    Xem Danh Sách Sách
                </a>
            </div>
            <% } %>
        </div>
    </section>

    <!-- About Section -->
    <section id="about" class="about">
        <div class="container">
            <div class="about-content">
                <div class="about-text">
                    <h2 class="section-title">Về Chúng Tôi</h2>
                    <p>
                        Digital Library là nền tảng thư viện số hiện đại, mang đến trải nghiệm đọc sách 
                        tuyệt vời cho mọi người. Với kho tàng sách phong phú và công nghệ tiên tiến, 
                        chúng tôi cam kết mang tri thức đến gần hơn với bạn.
                    </p>
                    <p>
                        Hãy tham gia cùng chúng tôi để khám phá thế giới tri thức vô tận!
                    </p>
                    <a href="<%= request.getContextPath() %>/login" class="btn-primary">
                        Bắt Đầu Ngay
                    </a>
                </div>
                <div class="about-image">
                    <i class="fas fa-users"></i>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta">
        <div class="container">
            <div class="cta-content">
                <h2>Sẵn Sàng Bắt Đầu Hành Trình Đọc Sách?</h2>
                <p>Xem sách miễn phí ngay hoặc đăng nhập để truy cập vào kho tàng sách khổng lồ</p>
                <div style="display: flex; gap: 15px; justify-content: center; flex-wrap: wrap;">
                    <a href="<%= request.getContextPath() %>/books" class="btn-cta">
                        <i class="fas fa-book"></i>
                        Xem Sách Miễn Phí
                    </a>
                    <a href="<%= request.getContextPath() %>/login" class="btn-cta" style="background: rgba(255,255,255,0.2); border: 2px solid white;">
                        <i class="fas fa-sign-in-alt"></i>
                        Đăng Nhập Để Mượn Sách
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer id="contact" class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>Digital Library</h3>
                    <p>Thư viện số hiện đại cho mọi người</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-facebook"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
                <div class="footer-section">
                    <h4>Liên Kết</h4>
                    <ul>
                        <li><a href="#features">Tính Năng</a></li>
                        <li><a href="#about">Giới Thiệu</a></li>
                        <li><a href="#contact">Liên Hệ</a></li>
                        <li><a href="<%= request.getContextPath() %>/login">Đăng Nhập</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>Hỗ Trợ</h4>
                    <ul>
                        <li><a href="#">Câu Hỏi Thường Gặp</a></li>
                        <li><a href="#">Hướng Dẫn Sử Dụng</a></li>
                        <li><a href="#">Chính Sách Bảo Mật</a></li>
                        <li><a href="#">Điều Khoản Sử Dụng</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h4>Liên Hệ</h4>
                    <ul>
                        <li><i class="fas fa-envelope"></i> info@digitallibrary.com</li>
                        <li><i class="fas fa-phone"></i> +84 123 456 789</li>
                        <li><i class="fas fa-map-marker-alt"></i> Hà Nội, Việt Nam</li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2024 Digital Library. All rights reserved.</p>
            </div>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Smooth scroll for anchor links
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });
            
            // Navbar scroll effect
            const navbar = document.querySelector('.navbar');
            if (navbar) {
                let lastScroll = 0;
                
                window.addEventListener('scroll', function() {
                    const currentScroll = window.pageYOffset;
                    
                    if (currentScroll > 100) {
                        navbar.style.boxShadow = '0 4px 6px -1px rgba(0, 0, 0, 0.1)';
                    } else {
                        navbar.style.boxShadow = '0 1px 2px 0 rgba(0, 0, 0, 0.05)';
                    }
                    
                    lastScroll = currentScroll;
                });
            }
            
            // Animate on scroll
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };
            
            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            }, observerOptions);
            
            // Observe feature cards
            document.querySelectorAll('.feature-card').forEach(card => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';
                card.style.transition = 'all 0.6s ease';
                observer.observe(card);
            });
        });
    </script>
</body>
</html>
