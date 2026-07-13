<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Digital Library</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
            display: flex; align-items: center; justify-content: center;
            padding: 20px;
        }
        .card {
            background: rgba(255,255,255,0.06);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 20px;
            padding: 40px;
            width: 100%; max-width: 460px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.4);
        }
        .logo { text-align: center; margin-bottom: 30px; }
        .logo i { font-size: 2.5rem; color: #a78bfa; margin-bottom: 10px; display: block; }
        .logo h1 { font-size: 1.5rem; font-weight: 700; color: #fff; }
        .logo p { color: rgba(255,255,255,0.55); font-size: 0.875rem; margin-top: 4px; }

        .alert-error {
            background: rgba(239,68,68,0.15);
            border: 1px solid rgba(239,68,68,0.3);
            color: #fca5a5;
            border-radius: 10px;
            padding: 12px 16px;
            margin-bottom: 20px;
            font-size: 0.875rem;
            display: flex; align-items: center; gap: 8px;
        }

        .form-group { margin-bottom: 18px; }
        label { display: block; color: rgba(255,255,255,0.7); font-size: 0.85rem; font-weight: 500; margin-bottom: 7px; }
        .input-wrap { position: relative; }
        .input-wrap i { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: rgba(255,255,255,0.35); font-size: 0.9rem; }
        input[type="text"], input[type="email"], input[type="password"], input[type="tel"] {
            width: 100%; padding: 12px 14px 12px 40px;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 10px;
            color: #fff; font-size: 0.95rem; font-family: inherit;
            transition: border-color 0.2s, background 0.2s;
            outline: none;
        }
        input:focus { border-color: #a78bfa; background: rgba(255,255,255,0.12); }
        input::placeholder { color: rgba(255,255,255,0.3); }

        .btn-primary {
            width: 100%; padding: 13px;
            background: linear-gradient(135deg, #6366f1, #8b5cf6);
            border: none; border-radius: 10px;
            color: #fff; font-size: 1rem; font-weight: 600; font-family: inherit;
            cursor: pointer; transition: all 0.2s;
            margin-top: 8px; letter-spacing: 0.3px;
        }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 8px 25px rgba(99,102,241,0.4); }
        .btn-primary:active { transform: none; }

        .divider { display: flex; align-items: center; gap: 12px; margin: 20px 0; }
        .divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: rgba(255,255,255,0.12); }
        .divider span { color: rgba(255,255,255,0.4); font-size: 0.8rem; white-space: nowrap; }

        .social-btn {
            width: 100%; padding: 11px;
            border-radius: 10px; border: 1px solid rgba(255,255,255,0.15);
            background: rgba(255,255,255,0.06);
            color: #fff; font-size: 0.9rem; font-family: inherit;
            cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 10px;
            transition: all 0.2s; margin-bottom: 10px; text-decoration: none;
        }
        .social-btn:hover { background: rgba(255,255,255,0.1); border-color: rgba(255,255,255,0.25); }
        .social-btn .fab { font-size: 1rem; }
        .google-btn .fab { color: #ea4335; }
        .fb-btn .fab { color: #1877f2; }

        .footer-link { text-align: center; margin-top: 22px; color: rgba(255,255,255,0.5); font-size: 0.875rem; }
        .footer-link a { color: #a78bfa; text-decoration: none; font-weight: 500; }
        .footer-link a:hover { text-decoration: underline; }

        .password-hint { font-size: 0.75rem; color: rgba(255,255,255,0.35); margin-top: 5px; }
    </style>
</head>
<body>
<div class="card">
    <div class="logo">
        <i class="fas fa-book-open"></i>
        <h1>Digital Library</h1>
        <p>Tạo tài khoản mới</p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert-error">
        <i class="fas fa-exclamation-circle"></i>
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form method="post" action="<%= request.getContextPath() %>/auth/register">
        <div class="form-group">
            <label for="fullName">Họ và tên *</label>
            <div class="input-wrap">
                <i class="fas fa-user"></i>
                <input type="text" id="fullName" name="fullName" placeholder="Nguyễn Văn A"
                       value="<%= request.getAttribute("inputFullName") != null ? request.getAttribute("inputFullName") : "" %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="email">Email *</label>
            <div class="input-wrap">
                <i class="fas fa-envelope"></i>
                <input type="email" id="email" name="email" placeholder="example@email.com"
                       value="<%= request.getAttribute("inputEmail") != null ? request.getAttribute("inputEmail") : "" %>" required>
            </div>
        </div>
        <div class="form-group">
            <label for="phone">Số điện thoại</label>
            <div class="input-wrap">
                <i class="fas fa-phone"></i>
                <input type="tel" id="phone" name="phone" placeholder="0901 234 567"
                       value="<%= request.getAttribute("inputPhone") != null ? request.getAttribute("inputPhone") : "" %>">
            </div>
        </div>
        <div class="form-group">
            <label for="password">Mật khẩu *</label>
            <div class="input-wrap">
                <i class="fas fa-lock"></i>
                <input type="password" id="password" name="password" placeholder="Tối thiểu 8 ký tự" required>
            </div>
            <div class="password-hint">Phải có chữ hoa, chữ thường và số</div>
        </div>
        <div class="form-group">
            <label for="confirmPassword">Xác nhận mật khẩu *</label>
            <div class="input-wrap">
                <i class="fas fa-lock"></i>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu" required>
            </div>
        </div>
        <button type="submit" class="btn-primary">
            <i class="fas fa-user-plus" style="margin-right:8px;"></i>Tạo tài khoản
        </button>
    </form>

    <div class="divider"><span>hoặc đăng ký với</span></div>

    <a href="<%= request.getContextPath() %>/auth/oauth/google" class="social-btn google-btn">
        <i class="fab fa-google"></i> Tiếp tục với Google
    </a>


    <div class="footer-link">
        Đã có tài khoản? <a href="<%= request.getContextPath() %>/auth/login">Đăng nhập</a>
    </div>
</div>
</body>
</html>
