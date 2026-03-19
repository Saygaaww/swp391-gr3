<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Reader" %>
<%@ page import="util.AuthUtil" %>
<% Reader currentReader = (Reader) session.getAttribute(AuthUtil.SESSION_USER);%>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chỉnh sửa hồ sơ - Digital Library</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">
        <link rel="stylesheet"
              href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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

            .profile-header {
                display: flex;
                align-items: center;
                gap: 24px;
                margin-bottom: 32px;
            }

            .avatar-circle {
                width: 80px;
                height: 80px;
                border-radius: 50%;
                background: linear-gradient(135deg, #6366f1, #8b5cf6);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.8rem;
                font-weight: 700;
                color: #fff;
                flex-shrink: 0;
                border: 3px solid rgba(255, 255, 255, 0.2);
                overflow: hidden;
            }

            .avatar-circle img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .profile-header-text h1 {
                font-size: 1.4rem;
                font-weight: 700;
                color: #111827;
            }

            .profile-header-text p {
                color: #6b7280;
                font-size: 0.875rem;
                margin-top: 4px;
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

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 16px;
            }

            .form-group {
                margin-bottom: 18px;
            }

            .form-group.full {
                grid-column: 1 / -1;
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

            .input-wrap i {
                position: absolute;
                left: 14px;
                top: 50%;
                transform: translateY(-50%);
                color: #9ca3af;
                font-size: 0.875rem;
            }

            input[type="text"],
            input[type="tel"],
            input[type="url"] {
                width: 100%;
                padding: 11px 14px 11px 40px;
                background: #f9fafb;
                border: 1px solid #d1d5db;
                border-radius: 10px;
                color: #111827;
                font-size: 0.9rem;
                font-family: inherit;
                outline: none;
                transition: border-color 0.2s;
            }

            input[type="text"]:focus,
            input[type="tel"]:focus,
            input[type="url"]:focus {
                border-color: #7c3aed;
                background: #ffffff;
            }

            input[readonly] {
                cursor: not-allowed;
                opacity: 0.5;
            }

            input::placeholder {
                color: #9ca3af;
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

            @media (max-width: 500px) {
                .form-row {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>

    <body>
        <div class="container">
            <a href="<%= request.getContextPath()%>/books" class="back-link"><i
                    class="fas fa-arrow-left"></i> Về trang chính</a>

            <div class="profile-header">
                <div class="avatar-circle">
                    <% if (currentReader != null && currentReader.getAvatarUrl() != null
                                            && !currentReader.getAvatarUrl().isBlank()) {%>
                    <img src="<%= currentReader.getAvatarUrl()%>" alt="Avatar">
                    <% } else {%>
                    <%= currentReader != null ? currentReader.getInitials() : "?"%>
                    <% }%>
                </div>
                <div class="profile-header-text">
                    <h1>
                        <%= currentReader != null ? currentReader.getFullName() : "Người dùng"%>
                    </h1>
                    <p>
                        <%= currentReader != null ? currentReader.getEmail() : ""%>
                    </p>
                </div>
            </div>

            <div class="nav-tabs">
                <a href="<%= request.getContextPath()%>/profile/view" class="nav-tab">
                    <i class="fas fa-user"></i> Hồ sơ
                </a>
                <a href="<%= request.getContextPath()%>/profile/edit" class="nav-tab active">
                    <i class="fas fa-user-edit"></i> Chỉnh sửa
                </a>
                <a href="<%= request.getContextPath()%>/profile/change-password" class="nav-tab">
                    <i class="fas fa-lock"></i> Mật khẩu
                </a>
                <a href="<%= request.getContextPath()%>/profile/linked-accounts" class="nav-tab">
                    <i class="fas fa-link"></i> Tài khoản liên kết
                </a>
            </div>

            <% if (request.getAttribute("error") != null) {%>
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error")%>
            </div>
            <% } %>
            <% if (request.getAttribute("success") != null) {%>
            <div class="alert alert-success"><i class="fas fa-check-circle"></i>
                <%= request.getAttribute("success")%>
            </div>
            <% }%>

            <div class="card">
                <div class="card-title"><i class="fas fa-user-edit"></i> Chỉnh sửa thông tin
                    cá nhân</div>
                <form method="post" action="<%= request.getContextPath()%>/profile/edit">
                    <div class="form-row">
                        <div class="form-group full">
                            <label for="fullName">Họ và tên *</label>
                            <div class="input-wrap">
                                <i class="fas fa-user"></i>
                                <input type="text" id="fullName" name="fullName" required
                                       value="<%= currentReader != null ? currentReader.getFullName() : ""%>"
                                       placeholder="Nguyễn Văn A">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <div class="input-wrap">
                                <i class="fas fa-envelope"></i>
                                <input type="text" readonly
                                       value="<%= currentReader != null ? currentReader.getEmail() : ""%>">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="phone">Số điện thoại</label>
                            <div class="input-wrap">
                                <i class="fas fa-phone"></i>
                                <input type="tel" id="phone" name="phone"
                                       placeholder="0901 234 567"
                                       value="<%= currentReader != null && currentReader.getPhone() != null ? currentReader.getPhone() : ""%>">
                            </div>
                        </div>
                        <div class="form-group full">
                            <label for="avatarUrl">URL ảnh đại diện</label>
                            <div class="input-wrap">
                                <i class="fas fa-image"></i>
                                <input type="url" id="avatarUrl" name="avatarUrl"
                                       placeholder="https://example.com/avatar.jpg"
                                       value="<%= currentReader != null && currentReader.getAvatarUrl() != null ? currentReader.getAvatarUrl() : ""%>">
                            </div>
                        </div>
                    </div>
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-save" style="margin-right:7px;"></i>Lưu thay đổi
                    </button>
                </form>
            </div>
        </div>
    </body>

</html>