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
                background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }

            .card {
                background: rgba(255, 255, 255, 0.06);
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.12);
                border-radius: 20px;
                padding: 40px;
                width: 100%;
                max-width: 420px;
                box-shadow: 0 25px 50px rgba(0, 0, 0, 0.4);
            }

            .logo {
                text-align: center;
                margin-bottom: 30px;
            }

            .logo i {
                font-size: 2.5rem;
                color: #a78bfa;
                margin-bottom: 10px;
                display: block;
            }

            .logo h1 {
                font-size: 1.5rem;
                font-weight: 700;
                color: #fff;
            }

            .logo p {
                color: rgba(255, 255, 255, 0.55);
                font-size: 0.875rem;
                margin-top: 4px;
            }

            .alert-error {
                background: rgba(239, 68, 68, 0.15);
                border: 1px solid rgba(239, 68, 68, 0.3);
                color: #fca5a5;
                border-radius: 10px;
                padding: 12px 16px;
                margin-bottom: 20px;
                font-size: 0.875rem;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .alert-success {
                background: rgba(34, 197, 94, 0.15);
                border: 1px solid rgba(34, 197, 94, 0.3);
                color: #86efac;
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
                color: rgba(255, 255, 255, 0.7);
                font-size: 0.85rem;
                font-weight: 500;
                margin-bottom: 7px;
            }

            .input-wrap {
                position: relative;
            }

            .input-wrap i.icon {
                position: absolute;
                left: 14px;
                top: 50%;
                transform: translateY(-50%);
                color: rgba(255, 255, 255, 0.35);
                font-size: 0.9rem;
            }

            input[type="email"],
            input[type="password"] {
                width: 100%;
                padding: 12px 14px 12px 40px;
                background: rgba(255, 255, 255, 0.08);
                border: 1px solid rgba(255, 255, 255, 0.15);
                border-radius: 10px;
                color: #fff;
                font-size: 0.95rem;
                font-family: inherit;
                transition: border-color 0.2s, background 0.2s;
                outline: none;
            }

            input:focus {
                border-color: #a78bfa;
                background: rgba(255, 255, 255, 0.12);
            }

            input::placeholder {
                color: rgba(255, 255, 255, 0.3);
            }

            .toggle-password {
                position: absolute;
                right: 14px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: rgba(255, 255, 255, 0.35);
                cursor: pointer;
                padding: 0;
                font-size: 0.9rem;
            }

            .toggle-password:hover {
                color: rgba(255, 255, 255, 0.6);
            }

            .forgot-link {
                display: block;
                text-align: right;
                color: #a78bfa;
                text-decoration: none;
                font-size: 0.8rem;
                margin-top: 8px;
            }

            .forgot-link:hover {
                text-decoration: underline;
            }

            .btn-primary {
                width: 100%;
                padding: 13px;
                background: linear-gradient(135deg, #6366f1, #8b5cf6);
                border: none;
                border-radius: 10px;
                color: #fff;
                font-size: 1rem;
                font-weight: 600;
                font-family: inherit;
                cursor: pointer;
                transition: all 0.2s;
                margin-top: 8px;
                letter-spacing: 0.3px;
            }

            .btn-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
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
                background: rgba(255, 255, 255, 0.12);
            }

            .divider span {
                color: rgba(255, 255, 255, 0.4);
                font-size: 0.8rem;
            }

            .social-btn {
                width: 100%;
                padding: 11px;
                border-radius: 10px;
                border: 1px solid rgba(255, 255, 255, 0.15);
                background: rgba(255, 255, 255, 0.06);
                color: #fff;
                font-size: 0.9rem;
                font-family: inherit;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                transition: all 0.2s;
                margin-bottom: 10px;
                text-decoration: none;
            }

            .social-btn:hover {
                background: rgba(255, 255, 255, 0.1);
            }

            .google-btn .fab {
                color: #ea4335;
            }

            .fb-btn .fab {
                color: #1877f2;
            }

            .footer-link {
                text-align: center;
                margin-top: 22px;
                color: rgba(255, 255, 255, 0.5);
                font-size: 0.875rem;
            }

            .footer-link a {
                color: #a78bfa;
                text-decoration: none;
                font-weight: 500;
            }

            .footer-link a:hover {
                text-decoration: underline;
            }
        </style>
    </head>

    <body>
        <div class="card">
            <div class="logo">
                <i class="fas fa-book-open"></i>
                <h1>Digital Library</h1>
                <p>Chào mừng trở lại!</p>
            </div>

            <% if (request.getAttribute("error") !=null) { %>
                <div class="alert-error"><i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>
                    <% String logout=request.getParameter("logout"); String reset=request.getParameter("reset"); %>
                        <% if ("1".equals(logout)) { %>
                            <div class="alert-success"><i class="fas fa-check-circle"></i>Bạn đã đăng xuất thành công.
                            </div>
                            <% } else if ("1".equals(reset)) { %>
                                <div class="alert-success"><i class="fas fa-check-circle"></i>Đặt lại mật khẩu thành
                                    công! Hãy đăng nhập.</div>
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
                                                                placeholder="example@email.com" required autofocus>
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
                                                        <i class="fas fa-sign-in-alt" style="margin-right:8px;"></i>Đăng
                                                        nhập
                                                    </button>
                                    </form>

                                    <div class="divider"><span>hoặc đăng nhập với</span></div>

                                    <a href="<%= request.getContextPath() %>/auth/oauth/google"
                                        class="social-btn google-btn">
                                        <i class="fab fa-google"></i> Tiếp tục với Google
                                    </a>
                                    <a href="<%= request.getContextPath() %>/auth/oauth/facebook"
                                        class="social-btn fb-btn">
                                        <i class="fab fa-facebook-f"></i> Tiếp tục với Facebook
                                    </a>

                                    <div class="footer-link">
                                        Chưa có tài khoản? <a href="<%= request.getContextPath() %>/auth/register">Đăng
                                            ký ngay</a>
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