<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="util.AuthUtil" %>
<% boolean isLoggedIn = AuthUtil.isLoggedIn(request);
    boolean isAdmin = AuthUtil.isAdmin(request);
    String contextPath = request.getContextPath();%>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thư viện Số FPT | Khám Phá Tri Thức</title>
        <!-- Fonts & Icons -->
        <link
            href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            /* Base Reset */
            :root {
                --primary: #475569;
                --primary-light: #64748b;
                --secondary: #94a3b8;
                --dark: #1e293b;
                --gray: #64748b;
                --light: #f8fafc;
            }

            *,
            *::before,
            *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Outfit', sans-serif;
                background-color: var(--light);
                color: var(--dark);
                line-height: 1.6;
                overflow-x: hidden;
            }

            /* Navbar */
            .navbar {
                position: fixed;
                top: 0;
                width: 100%;
                padding: 20px 5%;
                display: flex;
                justify-content: space-between;
                align-items: center;
                z-index: 1000;
                transition: all 0.3s ease;
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(10px);
                border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            }

            .brand {
                font-size: 1.5rem;
                font-weight: 800;
                color: var(--dark);
                text-decoration: none;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .brand i {
                color: var(--primary);
                font-size: 1.8rem;
            }

            .nav-links {
                display: flex;
                gap: 20px;
                align-items: center;
            }

            .btn {
                padding: 12px 28px;
                border-radius: 50px;
                font-weight: 600;
                text-decoration: none;
                transition: all 0.3s;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-outline {
                color: var(--dark);
                border: 2px solid #e2e8f0;
            }

            .btn-outline:hover {
                border-color: var(--primary);
                color: var(--primary);
            }

            .btn-primary {
                background: linear-gradient(135deg, var(--primary), var(--primary-light));
                color: white;
                box-shadow: 0 4px 15px rgba(99, 102, 241, 0.3);
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
                color: white;
            }

            /* Hero Section */
            .hero {
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 120px 5% 60px;
                position: relative;
                background: radial-gradient(circle at top right, rgba(71, 85, 105, 0.05), transparent 50%),
                    radial-gradient(circle at bottom left, rgba(148, 163, 184, 0.05), transparent 50%);
            }

            .hero-content {
                flex: 1;
                max-width: 600px;
                position: relative;
                z-index: 2;
            }

            .badge {
                display: inline-block;
                padding: 8px 16px;
                background: rgba(99, 102, 241, 0.1);
                color: var(--primary);
                border-radius: 50px;
                font-size: 0.9rem;
                font-weight: 600;
                margin-bottom: 24px;
                letter-spacing: 0.5px;
            }

            .hero-title {
                font-family: 'Playfair Display', serif;
                font-size: 4.5rem;
                line-height: 1.1;
                margin-bottom: 24px;
                color: var(--dark);
            }

            .hero-title span {
                background: linear-gradient(135deg, var(--primary), var(--secondary));
                background-clip: text;
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .hero-desc {
                font-size: 1.1rem;
                color: var(--gray);
                margin-bottom: 40px;
                line-height: 1.8;
            }

            .hero-visual {
                flex: 1;
                display: flex;
                justify-content: center;
                position: relative;
                z-index: 1;
            }

            .book-mockup {
                width: 90%;
                max-width: 500px;
                aspect-ratio: 4/5;
                background: url('https://images.unsplash.com/photo-1507842217343-583bb7270b66?q=80&w=1200') center/cover;
                border-radius: 30px;
                box-shadow: -20px 20px 60px rgba(0, 0, 0, 0.15);
                position: relative;
                animation: float 6s ease-in-out infinite;
            }

            .book-mockup::before {
                content: '';
                position: absolute;
                inset: 0;
                border-radius: 30px;
                background: linear-gradient(45deg, rgba(71, 85, 105, 0.2), rgba(148, 163, 184, 0.2));
                z-index: 1;
            }

            /* Floating elements */
            .glass-card {
                position: absolute;
                background: rgba(255, 255, 255, 0.85);
                backdrop-filter: blur(12px);
                padding: 20px;
                border-radius: 20px;
                border: 1px solid rgba(255, 255, 255, 0.5);
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
                z-index: 2;
            }

            .card-1 {
                bottom: 40px;
                left: -40px;
                animation: float 5s ease-in-out infinite reverse;
            }

            .card-2 {
                top: 40px;
                right: -20px;
                animation: float 7s ease-in-out infinite 1s;
            }

            .stat-icon {
                width: 45px;
                height: 45px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.2rem;
                margin-bottom: 12px;
            }

            .stat-icon.pu {
                background: #f1f5f9;
                color: var(--primary);
            }

            .stat-icon.pi {
                background: #f1f5f9;
                color: var(--secondary);
            }

            .stat-num {
                font-size: 1.5rem;
                font-weight: 800;
                margin-bottom: 4px;
            }

            .stat-text {
                font-size: 0.85rem;
                color: var(--gray);
                font-weight: 500;
            }

            @keyframes float {
                0% {
                    transform: translateY(0px);
                }
                50% {
                    transform: translateY(-15px);
                }
                100% {
                    transform: translateY(0px);
                }
            }

            /* Features Section */
            .features {
                padding: 100px 5%;
                background: white;
                position: relative;
            }

            .section-header {
                text-align: center;
                margin-bottom: 70px;
            }

            .features-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 40px;
            }

            .feature-box {
                padding: 40px 30px;
                border-radius: 24px;
                background: var(--light);
                transition: all 0.3s;
                border: 1px solid transparent;
            }

            .feature-box:hover {
                transform: translateY(-5px);
                background: white;
                border-color: #e2e8f0;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.04);
            }

            .feature-box i {
                font-size: 2.5rem;
                color: var(--primary);
                margin-bottom: 24px;
            }

            .feature-box h3 {
                font-size: 1.4rem;
                margin-bottom: 16px;
            }

            .feature-box p {
                color: var(--gray);
                font-size: 0.95rem;
            }

            /* Responsive */
            @media (max-width: 900px) {
                .hero {
                    flex-direction: column;
                    text-align: center;
                    padding-top: 150px;
                }

                .hero-title {
                    font-size: 3.5rem;
                }

                .nav-links {
                    display: none;
                }

                .hero-visual {
                    margin-top: 60px;
                    width: 100%;
                }

                .glass-card {
                    display: none;
                }
            }
        </style>
    </head>

    <body>

        <!-- NAV BAR -->
        <nav class="navbar">
            <a href="<%= contextPath%>/" class="brand">
                <i class="fas fa-book-reader"></i> DigitalLibrary
            </a>
            <div class="nav-links">
                <% if (isAdmin) {%>
                <a href="<%= contextPath%>/admin" class="btn btn-primary">Quản trị hệ thống <i
                        class="fas fa-arrow-right"></i></a>
                <a href="<%= contextPath%>/auth/logout" class="btn btn-outline" style="border:none;">Đăng
                    xuất</a>
                    <% } else if (isLoggedIn) {%>
                <a href="<%= contextPath%>/books" class="btn btn-outline" style="border: none;">Kho
                    sách</a>
                <a href="<%= contextPath%>/profile" class="btn btn-primary">Tài khoản <i
                        class="fas fa-arrow-right"></i></a>
                    <% } else {%>
                <a href="<%= contextPath%>/auth/login" class="btn btn-outline">Đăng nhập</a>
                <a href="<%= contextPath%>/auth/register" class="btn btn-primary">Tạo tài khoản
                    miễn phí <i class="fas fa-arrow-right"></i></a>
                    <% } %>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <section class="hero">
            <div class="hero-content">
                <div class="badge">Nền tảng tri thức Đại học FPT</div>
                <h1 class="hero-title">Đọc sách mọi lúc,<br>Học tập <span>mọi nơi</span></h1>
                <p class="hero-desc">Trải nghiệm hệ sinh thái sách điện tử khổng lồ dành riêng cho sinh viên và
                    giảng viên. Truy cập hàng ngàn tài liệu học thuật chuyên sâu và sách tham khảo kỹ năng chỉ
                    với một cú click.</p>

                <div style="display: flex; gap: 16px; flex-wrap: wrap; justify-content: flex-start;">
                    <% if (isAdmin) {%>
                    <a href="<%= contextPath%>/admin" class="btn btn-primary"
                       style="padding: 16px 36px; font-size: 1.1rem;">
                        <i class="fas fa-tachometer-alt"></i> Vào Bảng điều khiển
                    </a>
                    <% } else if (isLoggedIn) {%>
                    <a href="<%= contextPath%>/books" class="btn btn-primary"
                       style="padding: 16px 36px; font-size: 1.1rem;">
                        <i class="fas fa-search"></i> Khám phá Thư viện
                    </a>
                    <% } else {%>
                    <a href="<%= contextPath%>/auth/login" class="btn btn-primary"
                       style="padding: 16px 36px; font-size: 1.1rem;">
                        <i class="fas fa-sign-in-alt"></i> Đăng nhập để Khám phá
                    </a>
                    <a href="<%= contextPath%>/auth/register" class="btn btn-outline"
                       style="padding: 16px 36px; font-size: 1.1rem;">
                        Tìm hiểu thêm
                    </a>
                    <% }%>
                </div>
            </div>

            <div class="hero-visual">
                <div class="book-mockup">
                    <!-- Floating Stats -->
                    <div class="glass-card card-1">
                        <div class="stat-icon pu"><i class="fas fa-book-open"></i></div>
                        <div class="stat-num">5,000+</div>
                        <div class="stat-text">Sách Trực tuyến</div>
                    </div>
                    <div class="glass-card card-2">
                        <div class="stat-icon pi"><i class="fas fa-users"></i></div>
                        <div class="stat-num">12.5k</div>
                        <div class="stat-text">Độc giả Tích cực</div>
                    </div>
                </div>
            </div>
        </section>

        <!-- FEATURES -->
        <section class="features">
            <div class="section-header">
                <div class="badge" style="margin-bottom: 16px;">Về chúng tôi</div>
                <h2 class="hero-title" style="font-size: 3rem; margin-bottom: 0;">Tại sao chọn hệ thống của
                    chúng tôi?</h2>
            </div>
            <div class="features-grid">
                <div class="feature-box">
                    <i class="fas fa-mobile-screen-button"></i>
                    <h3>Trải nghiệm đa nền tảng</h3>
                    <p>Nền tảng được tối ưu hóa cho màn hình Desktop, Tablet hay ngay cả Smartphone nhỏ gọn. Bạn
                        có thể đọc tiếp trang sách mọi lúc mọi nơi.</p>
                </div>
                <div class="feature-box">
                    <i class="fas fa-shield-halved"></i>
                    <h3>Tôn trọng bản quyền</h3>
                    <p>Mọi tài nguyên điện tử, giáo trình và tài liệu nghiên cứu trên hệ thống cấu bảo mật
                        nghiêm ngặt và chia sẻ đúng bản quyền số.</p>
                </div>
                <div class="feature-box">
                    <i class="fas fa-magnifying-glass-chart"></i>
                    <h3>Khám phá thông minh</h3>
                    <p>Thuật toán tìm kiếm theo tác giả, thể loại một cách nhanh chóng. Hỗ trợ hàng ngàn truy
                        vấn cùng một thời điểm.</p>
                </div>
            </div>
        </section>

    </body>

</html>
