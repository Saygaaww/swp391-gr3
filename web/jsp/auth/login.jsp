<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Digital Library</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
            rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            *,
            *::before,
            *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Inter', sans-serif;
                min-height: 100vh;
                background: #f0f2f5;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }

            .page-wrapper {
                display: flex;
                width: 100%;
                max-width: 900px;
                min-height: 560px;
                border-radius: 20px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.10);
                overflow: hidden;
            }

            /* Left banner */
            .banner {
                flex: 1;
                background: linear-gradient(145deg, #6366f1 0%, #8b5cf6 60%, #a78bfa 100%);
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 48px 36px;
                color: #fff;
            }

            .banner i {
                font-size: 3.5rem;
                margin-bottom: 16px;
                opacity: 0.95;
            }

            .banner h2 {
                font-size: 1.8rem;
                font-weight: 700;
                margin-bottom: 10px;
            }

            .banner p {
                font-size: 0.95rem;
                opacity: 0.8;
                text-align: center;
                line-height: 1.6;
            }

            /* Right form */
            .card {
                flex: 1;
                background: #ffffff;
                padding: 48px 40px;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }

            .card-title {
                font-size: 1.5rem;
                font-weight: 700;
                color: #111827;
                margin-bottom: 6px;
            }

            .card-subtitle {
                font-size: 0.875rem;
                color: #6b7280;
                margin-bottom: 28px;
            }

            .alert-error {
                background: #fef2f2;
                border: 1px solid #fecaca;
                color: #dc2626;
                border-radius: 10px;
                padding: 12px 16px;
                margin-bottom: 20px;
                font-size: 0.875rem;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .alert-success {
                background: #f0fdf4;
                border: 1px solid #bbf7d0;
                color: #16a34a;
                border-radius: 10px;
                padding: 12px 16px;
                margin-bottom: 20px;
                font-size: 0.875rem;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .form-group {
                margin-bottom: 18px;
            }

            label {
                display: block;
                color: #374151;
                font-size: 0.875rem;
                font-weight: 500;
                margin-bottom: 7px;
            }

            .input-wrap {
                position: relative;
            }

            .input-wrap i.icon {
                position: absolute;
                left: 13px;
                top: 50%;
                transform: translateY(-50%);
                color: #9ca3af;
                font-size: 0.9rem;
            }

            input[type="email"],
            input[type="password"] {
                width: 100%;
                padding: 11px 14px 11px 38px;
                background: #f9fafb;
                border: 1.5px solid #e5e7eb;
                border-radius: 9px;
                color: #111827;
                font-size: 0.95rem;
                font-family: inherit;
                transition: border-color 0.2s, box-shadow 0.2s;
                outline: none;
            }

            input:focus {
                border-color: #6366f1;
                background: #fafafe;
                box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
            }

            input::placeholder {
                color: #d1d5db;
            }

            .toggle-password {
                position: absolute;
                right: 12px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: #9ca3af;
                cursor: pointer;
                padding: 0;
                font-size: 0.9rem;
            }

            .toggle-password:hover {
                color: #6b7280;
            }

            .forgot-link {
                display: block;
                text-align: right;
                color: #6366f1;
                text-decoration: none;
                font-size: 0.8rem;
                margin-top: 7px;
                font-weight: 500;
            }

            .forgot-link:hover {
                text-decoration: underline;
            }

            .btn-primary {
                width: 100%;
                padding: 12px;
                background: linear-gradient(135deg, #6366f1, #8b5cf6);
                border: none;
                border-radius: 9px;
                color: #fff;
                font-size: 0.95rem;
                font-weight: 600;
                font-family: inherit;
                cursor: pointer;
                transition: all 0.2s;
                margin-top: 8px;
                letter-spacing: 0.3px;
            }

            .btn-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 6px 20px rgba(99, 102, 241, 0.35);
            }

            .divider {
                display: flex;
                align-items: center;
                gap: 12px;
                margin: 20px 0;
            }

            .divider::before,
            .divider::after {
                content: '';
                flex: 1;
                height: 1px;
                background: #e5e7eb;
            }

            .divider span {
                color: #9ca3af;
                font-size: 0.8rem;
            }

            .social-btn {
                width: 100%;
                padding: 10px;
                border-radius: 9px;
                border: 1.5px solid #e5e7eb;
                background: #fff;
                color: #374151;
                font-size: 0.875rem;
                font-family: inherit;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                transition: all 0.2s;
                margin-bottom: 10px;
                text-decoration: none;
                font-weight: 500;
            }

            .social-btn:hover {
                background: #f9fafb;
                border-color: #d1d5db;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            }

            .google-logo {
                width: 18px;
                height: 18px;
            }

            .fb-btn .fab {
                color: #1877f2;
                font-size: 1.1rem;
            }

            .footer-link {
                text-align: center;
                margin-top: 20px;
                color: #6b7280;
                font-size: 0.875rem;
            }

            .footer-link a {
                color: #6366f1;
                text-decoration: none;
                font-weight: 500;
            }

            .footer-link a:hover {
                text-decoration: underline;
            }

            @media (max-width: 640px) {
                .page-wrapper {
                    flex-direction: column;
                }

                .banner {
                    padding: 32px 24px;
                    min-height: 160px;
                }

                .card {
                    padding: 32px 24px;
                }
            }
        </style>
    </head>

    <body>
        <div class="page-wrapper">
            <!-- Left Banner -->
            <div class="banner">
                <i class="fas fa-book-open"></i>
                <h2>Digital Library</h2>
                <p>Khám phá kho sách phong phú<br>với hàng nghìn đầu sách hay.</p>
            </div>

            <!-- Right Form -->
            <div class="card">
                <div class="card-title">Đăng nhập</div>
                <div class="card-subtitle">Chào mừng trở lại! Vui lòng đăng nhập để tiếp tục.</div>

                <% if (request.getAttribute("error") !=null) { %>
                    <div class="alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>
                        <% String logout=request.getParameter("logout"); String reset=request.getParameter("reset"); %>
                            <% if ("1".equals(logout)) { %>
                                <div class="alert-success">
                                    <i class="fas fa-check-circle"></i>Bạn đã đăng xuất thành công.
                                </div>
                                <% } else if ("1".equals(reset)) { %>
                                    <div class="alert-success">
                                        <i class="fas fa-check-circle"></i>Đặt lại mật khẩu thành công! Hãy đăng nhập.
                                    </div>
                                    <% } %>

                                        <form method="post" action="<%= request.getContextPath() %>/auth/login">
                                            <% String redirect=request.getParameter("redirect"); %>
                                                <% if (redirect !=null && !redirect.isBlank()) { %>
                                                    <input type="hidden" name="redirect" value="<%= redirect %>">
                                                    <% } %>

                                                        <div class="form-group">
                                                            <label for="email">Email</label>
                                                            <div class="input-wrap">
                                                                <i class="fas fa-envelope icon"></i>
                                                                <input type="email" id="email" name="email"
                                                                    placeholder="example@email.com" required autofocus
                                                                    value="<%= request.getAttribute(" inputEmail")
                                                                    !=null ? request.getAttribute("inputEmail") : ""
                                                                    %>">
                                                            </div>
                                                        </div>

                                                        <div class="form-group">
                                                            <label for="password">Mật khẩu</label>
                                                            <div class="input-wrap">
                                                                <i class="fas fa-lock icon"></i>
                                                                <input type="password" id="password" name="password"
                                                                    placeholder="••••••••" required>
                                                                <button type="button" class="toggle-password"
                                                                    onclick="togglePwd()" id="toggleBtn">
                                                                    <i class="fas fa-eye" id="toggleIcon"></i>
                                                                </button>
                                                            </div>
                                                            <a href="<%= request.getContextPath() %>/auth/forgot-password"
                                                                class="forgot-link">Quên mật khẩu?</a>
                                                        </div>

                                                        <button type="submit" class="btn-primary">
                                                            <i class="fas fa-sign-in-alt"
                                                                style="margin-right:8px;"></i>Đăng nhập
                                                        </button>
                                        </form>

                                        <div class="divider"><span>hoặc đăng nhập với</span></div>

                                        <a href="<%= request.getContextPath() %>/auth/oauth/google" class="social-btn">
                                            <!-- Google SVG logo -->
                                            <svg class="google-logo" viewBox="0 0 48 48"
                                                xmlns="http://www.w3.org/2000/svg">
                                                <path fill="#FFC107"
                                                    d="M43.6 20.5H42V20H24v8h11.3C33.7 32.9 29.3 36 24 36c-6.6 0-12-5.4-12-12s5.4-12 12-12c3.1 0 5.9 1.1 8 3l5.7-5.7C34.6 6.7 29.6 4.5 24 4.5 13.8 4.5 5.5 12.8 5.5 23S13.8 41.5 24 41.5c10.2 0 18.5-8.3 18.5-18.5 0-1.2-.1-2.3-.4-3.4-.1-.4-.3-1-.5-1z" />
                                                <path fill="#FF3D00"
                                                    d="M6.3 14.7l6.6 4.8C14.5 16 19 13 24 13c3.1 0 5.9 1.1 8 3l5.7-5.7C34.6 6.7 29.6 4.5 24 4.5c-7.7 0-14.3 4.4-17.7 10.2z" />
                                                <path fill="#4CAF50"
                                                    d="M24 41.5c5.4 0 10.3-2.1 14-5.4l-6.5-5.5C29.5 32.6 26.9 33.5 24 33.5c-5.3 0-9.6-3.1-11.3-7.4l-6.6 5.1C9.6 37 16.3 41.5 24 41.5z" />
                                                <path fill="#1976D2"
                                                    d="M43.6 20.5H42V20H24v8h11.3c-.9 2.4-2.5 4.4-4.6 5.8l6.5 5.5C42.7 35.5 44 30 44 24c0-1.2-.1-2.3-.4-3.5z" />
                                            </svg>
                                            Tiếp tục với Google
                                        </a>
                                        <a href="<%= request.getContextPath() %>/auth/oauth/facebook"
                                            class="social-btn fb-btn">
                                            <i class="fab fa-facebook-f"></i> Tiếp tục với Facebook
                                        </a>

                                        <div class="footer-link">
                                            Chưa có tài khoản? <a
                                                href="<%= request.getContextPath() %>/auth/register">Đăng ký ngay</a>
                                        </div>
            </div>
        </div>

        <script>
            function togglePwd() {
                const pwd = document.getElementById('password');
                const icon = document.getElementById('toggleIcon');
                if (pwd.type === 'password') { pwd.type = 'text'; icon.className = 'fas fa-eye-slash'; }
                else { pwd.type = 'password'; icon.className = 'fas fa-eye'; }
            }
        </script>
    </body>

    </html>