<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="model.Reader, util.AuthUtil" %>
        <% Reader currentReader=(Reader) session.getAttribute(AuthUtil.SESSION_USER); %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đổi mật khẩu - Digital Library</title>
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
                        background: #f9fafb;
                        padding: 30px 20px;
                    }

                    .container {
                        max-width: 700px;
                        margin: 0 auto;
                    }

                    .back-link {
                        color: #6b7280;
                        text-decoration: none;
                        font-size: 0.875rem;
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        margin-bottom: 20px;
                        transition: color 0.2s;
                    }

                    .back-link:hover {
                        color: #7c3aed;
                    }

                    .card {
                        background: #ffffff;
                        border: 1px solid #e5e7eb;
                        border-radius: 20px;
                        padding: 32px;
                        margin-bottom: 20px;
                        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
                    }

                    .card-title {
                        font-size: 1rem;
                        font-weight: 600;
                        color: #111827;
                        margin-bottom: 24px;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .card-title i {
                        color: #7c3aed;
                    }

                    .form-group {
                        margin-bottom: 18px;
                    }

                    label {
                        display: block;
                        color: #374151;
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
                        color: #9ca3af;
                        font-size: 0.875rem;
                    }

                    input[type="password"] {
                        width: 100%;
                        padding: 11px 40px 11px 40px;
                        background: #f9fafb;
                        border: 1px solid #d1d5db;
                        border-radius: 10px;
                        color: #111827;
                        font-size: 0.9rem;
                        font-family: inherit;
                        outline: none;
                        transition: border-color 0.2s;
                    }

                    input:focus {
                        border-color: #7c3aed;
                        background: #ffffff;
                    }

                    input::placeholder {
                        color: #9ca3af;
                    }

                    .toggle-password {
                        position: absolute;
                        right: 14px;
                        top: 50%;
                        transform: translateY(-50%);
                        background: none;
                        border: none;
                        color: #9ca3af;
                        cursor: pointer;
                        font-size: 0.875rem;
                    }

                    .password-hint {
                        font-size: 0.75rem;
                        color: #9ca3af;
                        margin-top: 5px;
                    }

                    .alert {
                        border-radius: 10px;
                        padding: 12px 16px;
                        margin-bottom: 20px;
                        font-size: 0.875rem;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .alert-error {
                        background: #fef2f2;
                        border: 1px solid #fecaca;
                        color: #dc2626;
                    }

                    .alert-success {
                        background: #f0fdf4;
                        border: 1px solid #bbf7d0;
                        color: #16a34a;
                    }

                    .btn-primary {
                        padding: 11px 28px;
                        background: linear-gradient(135deg, #6366f1, #8b5cf6);
                        border: none;
                        border-radius: 10px;
                        color: #fff;
                        font-size: 0.9rem;
                        font-weight: 600;
                        font-family: inherit;
                        cursor: pointer;
                        transition: all 0.2s;
                    }

                    .btn-primary:hover {
                        transform: translateY(-1px);
                        box-shadow: 0 8px 20px rgba(99, 102, 241, 0.35);
                    }

                    .nav-tabs {
                        display: flex;
                        gap: 4px;
                        background: #f3f4f6;
                        padding: 4px;
                        border-radius: 12px;
                        margin-bottom: 24px;
                    }

                    .nav-tab {
                        flex: 1;
                        padding: 9px 12px;
                        border-radius: 8px;
                        border: none;
                        background: none;
                        color: #6b7280;
                        font-family: inherit;
                        font-size: 0.82rem;
                        cursor: pointer;
                        text-align: center;
                        transition: all 0.2s;
                        text-decoration: none;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        gap: 6px;
                    }

                    .nav-tab.active {
                        background: linear-gradient(135deg, #6366f1, #8b5cf6);
                        color: #fff;
                        font-weight: 600;
                    }

                    .nav-tab:hover:not(.active) {
                        color: #374151;
                        background: #e5e7eb;
                    }
                </style>
            </head>

            <body>
                <div class="container">
                    <a href="<%= request.getContextPath() %>/books" class="back-link"><i class="fas fa-arrow-left"></i>
                        Về trang chính</a>

                    <div class="nav-tabs">
                        <a href="<%= request.getContextPath() %>/profile/view" class="nav-tab">
                            <i class="fas fa-user"></i> Hồ sơ
                        </a>
                        <a href="<%= request.getContextPath() %>/profile/change-password" class="nav-tab active">
                            <i class="fas fa-lock"></i> Mật khẩu
                        </a>
                        <a href="<%= request.getContextPath() %>/profile/linked-accounts" class="nav-tab">
                            <i class="fas fa-link"></i> Tài khoản liên kết
                        </a>
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
                                <% } %>

                                    <div class="card">
                                        <div class="card-title"><i class="fas fa-lock"></i> Đổi mật khẩu</div>

                                        <% if (currentReader !=null && !currentReader.hasPassword()) { %>
                                            <div class="alert alert-error" style="margin-bottom:0;">
                                                <i class="fas fa-info-circle"></i>
                                                Tài khoản của bạn đăng nhập qua mạng xã hội. Vui lòng thiết lập mật khẩu
                                                để dùng tính năng này.
                                            </div>
                                            <% } else { %>
                                                <form method="post"
                                                    action="<%= request.getContextPath() %>/profile/change-password">
                                                    <div class="form-group">
                                                        <label for="currentPassword">Mật khẩu hiện tại *</label>
                                                        <div class="input-wrap">
                                                            <i class="fas fa-lock icon"></i>
                                                            <input type="password" id="currentPassword"
                                                                name="currentPassword" placeholder="Mật khẩu hiện tại"
                                                                required>
                                                            <button type="button" class="toggle-password"
                                                                onclick="togglePwd('currentPassword','i1')"><i
                                                                    class="fas fa-eye" id="i1"></i></button>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="newPassword">Mật khẩu mới *</label>
                                                        <div class="input-wrap">
                                                            <i class="fas fa-key icon"></i>
                                                            <input type="password" id="newPassword" name="newPassword"
                                                                placeholder="Tối thiểu 8 ký tự" required>
                                                            <button type="button" class="toggle-password"
                                                                onclick="togglePwd('newPassword','i2')"><i
                                                                    class="fas fa-eye" id="i2"></i></button>
                                                        </div>
                                                        <div class="password-hint">Phải có chữ hoa, chữ thường và số
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="confirmPassword">Xác nhận mật khẩu mới *</label>
                                                        <div class="input-wrap">
                                                            <i class="fas fa-key icon"></i>
                                                            <input type="password" id="confirmPassword"
                                                                name="confirmPassword"
                                                                placeholder="Nhập lại mật khẩu mới" required>
                                                            <button type="button" class="toggle-password"
                                                                onclick="togglePwd('confirmPassword','i3')"><i
                                                                    class="fas fa-eye" id="i3"></i></button>
                                                        </div>
                                                    </div>
                                                    <button type="submit" class="btn-primary">
                                                        <i class="fas fa-check" style="margin-right:7px;"></i>Cập nhật
                                                        mật khẩu
                                                    </button>
                                                </form>
                                                <% } %>
                                    </div>
                </div>
                <script>
                    function togglePwd(id, iconId) {
                        const el = document.getElementById(id), icon = document.getElementById(iconId);
                        if (el.type === 'password') { el.type = 'text'; icon.className = 'fas fa-eye-slash'; }
                        else { el.type = 'password'; icon.className = 'fas fa-eye'; }
                    }
                </script>
            </body>

            </html>