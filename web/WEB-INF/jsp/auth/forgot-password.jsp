<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quên mật khẩu - Digital Library</title>
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
                font-size: 1.4rem;
                font-weight: 700;
                color: #fff;
            }

            .logo p {
                color: rgba(255, 255, 255, 0.55);
                font-size: 0.85rem;
                margin-top: 4px;
                line-height: 1.5;
            }

            .alert {
                border-radius: 10px;
                padding: 12px 16px;
                margin-bottom: 20px;
                font-size: 0.875rem;
                display: flex;
                align-items: flex-start;
                gap: 8px;
            }

            .alert-error {
                background: rgba(239, 68, 68, 0.15);
                border: 1px solid rgba(239, 68, 68, 0.3);
                color: #fca5a5;
            }

            .alert-success {
                background: rgba(34, 197, 94, 0.15);
                border: 1px solid rgba(34, 197, 94, 0.3);
                color: #86efac;
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

            .input-wrap i {
                position: absolute;
                left: 14px;
                top: 50%;
                transform: translateY(-50%);
                color: rgba(255, 255, 255, 0.35);
            }

            input[type="email"] {
                width: 100%;
                padding: 12px 14px 12px 40px;
                background: rgba(255, 255, 255, 0.08);
                border: 1px solid rgba(255, 255, 255, 0.15);
                border-radius: 10px;
                color: #fff;
                font-size: 0.95rem;
                font-family: inherit;
                outline: none;
                transition: border-color 0.2s;
            }

            input:focus {
                border-color: #a78bfa;
                background: rgba(255, 255, 255, 0.12);
            }

            input::placeholder {
                color: rgba(255, 255, 255, 0.3);
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
            }

            .btn-primary:hover {
                transform: translateY(-1px);
                box-shadow: 0 8px 25px rgba(99, 102, 241, 0.4);
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
        </style>
    </head>

    <body>
        <div class="card">
            <div class="logo">
                <i class="fas fa-key"></i>
                <h1>Quên mật khẩu?</h1>
                <p>Nhập email của bạn, chúng tôi sẽ gửi link đặt lại mật khẩu.</p>
            </div>

            <% if (request.getAttribute("error") !=null) { %>
                <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>
                    <% if (request.getAttribute("success") !=null) { %>
                        <div class="alert alert-success"><i class="fas fa-check-circle"></i>
                            <%= request.getAttribute("success") %>
                        </div>
                        <% } else { %>
                            <form method="post" action="<%= request.getContextPath() %>/auth/forgot-password">
                                <div class="form-group">
                                    <label for="email">Email đã đăng ký</label>
                                    <div class="input-wrap">
                                        <i class="fas fa-envelope"></i>
                                        <input type="email" id="email" name="email" placeholder="example@email.com"
                                            required autofocus>
                                    </div>
                                </div>
                                <button type="submit" class="btn-primary">
                                    <i class="fas fa-paper-plane" style="margin-right:8px;"></i>Gửi link đặt lại
                                </button>
                            </form>
                            <% } %>

                                <div class="footer-link">
                                    <a href="<%= request.getContextPath() %>/auth/login"><i class="fas fa-arrow-left"
                                            style="margin-right:4px;"></i>Quay lại đăng nhập</a>
                                </div>
        </div>
    </body>

    </html>