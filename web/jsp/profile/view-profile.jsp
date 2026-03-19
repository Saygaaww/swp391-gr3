<%@page import="model.Employee"%>
<%@page import="jakarta.security.auth.message.config.AuthConfig"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Reader, util.AuthUtil" %>
<% Reader currentReader = (Reader) session.getAttribute(AuthUtil.SESSION_USER);
    Employee currentEmployee = (Employee) session.getAttribute(AuthUtil.SESSION_EMPLOYEE_ID);
%>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hồ sơ cá nhân</title>
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
                background: #f3f4f6;
                padding: 30px 20px;
                color: #111827;
            }

            .container {
                max-width: 680px;
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

            /* Sub-nav */
            .sub-nav {
                display: flex;
                gap: 4px;
                background: #f3f4f6;
                padding: 4px;
                border-radius: 12px;
                margin-bottom: 20px;
            }

            .sub-tab {
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

            .sub-tab.active {
                background: linear-gradient(135deg, #6366f1, #8b5cf6);
                color: #fff;
                font-weight: 600;
            }

            .sub-tab:hover:not(.active) {
                color: #374151;
                background: #e5e7eb;
            }

            /* Hero */
            .profile-hero {
                background: #ffffff;
                border: 1px solid #e5e7eb;
                border-radius: 20px;
                padding: 1.75rem 2rem;
                margin-bottom: 16px;
                box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
                display: flex;
                align-items: center;
                gap: 1.5rem;
                position: relative;
            }

            .avatar-circle {
                width: 88px;
                height: 88px;
                border-radius: 50%;
                background: linear-gradient(135deg, #6366f1, #8b5cf6);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2rem;
                font-weight: 700;
                color: #fff;
                flex-shrink: 0;
                overflow: hidden;
                border: 3px solid #ede9fe;
            }

            .avatar-circle img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .hero-name {
                font-size: 1.4rem;
                font-weight: 700;
                color: #111827;
                margin-bottom: 4px;
            }

            .hero-email {
                color: #6b7280;
                font-size: 0.875rem;
                display: flex;
                align-items: center;
                gap: 6px;
                margin-bottom: 10px;
            }

            .role-badge {
                display: inline-flex;
                align-items: center;
                gap: 5px;
                padding: 3px 12px;
                border-radius: 99px;
                font-size: 0.75rem;
                font-weight: 600;
                background: #ede9fe;
                color: #7c3aed;
            }

            .edit-btn {
                position: absolute;
                top: 1.5rem;
                right: 1.5rem;
                display: inline-flex;
                align-items: center;
                gap: 7px;
                padding: 9px 18px;
                background: linear-gradient(135deg, #6366f1, #8b5cf6);
                color: #fff;
                border-radius: 10px;
                font-size: 0.875rem;
                font-weight: 600;
                cursor: pointer;
                border: none;
                transition: all 0.2s;
                box-shadow: 0 3px 10px rgba(99, 102, 241, 0.25);
            }

            .edit-btn:hover {
                transform: translateY(-1px);
                box-shadow: 0 6px 18px rgba(99, 102, 241, 0.35);
            }

            /* Info card */
            .info-card {
                background: #ffffff;
                border: 1px solid #e5e7eb;
                border-radius: 20px;
                padding: 1.75rem 2rem;
                margin-bottom: 16px;
                box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            }

            .info-card-title {
                font-size: 0.78rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.06em;
                color: #9ca3af;
                margin-bottom: 1.25rem;
                display: flex;
                align-items: center;
                gap: 7px;
            }

            .info-card-title i {
                color: #7c3aed;
            }

            .info-row {
                display: flex;
                align-items: flex-start;
                padding: 12px 0;
                border-bottom: 1px solid #f3f4f6;
            }

            .info-row:last-child {
                border-bottom: none;
            }

            .info-label {
                width: 140px;
                flex-shrink: 0;
                font-size: 0.82rem;
                font-weight: 600;
                color: #6b7280;
                display: flex;
                align-items: center;
                gap: 7px;
            }

            .info-label i {
                color: #a78bfa;
                width: 14px;
                text-align: center;
            }

            .info-value {
                flex: 1;
                font-size: 0.9rem;
                color: #111827;
                font-weight: 500;
            }

            .info-value.empty {
                color: #d1d5db;
                font-style: italic;
                font-weight: 400;
            }

            /* Alert */
            .alert {
                border-radius: 10px;
                padding: 12px 16px;
                margin-bottom: 16px;
                font-size: 0.875rem;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .alert-success {
                background: #f0fdf4;
                border: 1px solid #bbf7d0;
                color: #16a34a;
            }

            .alert-error {
                background: #fef2f2;
                border: 1px solid #fecaca;
                color: #dc2626;
            }

            /* ── MODAL OVERLAY ── */
            .modal-overlay {
                position: fixed;
                inset: 0;
                background: rgba(0, 0, 0, 0.45);
                backdrop-filter: blur(3px);
                z-index: 1000;
                display: none;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }

            .modal-overlay.open {
                display: flex;
            }

            .modal {
                background: #ffffff;
                border-radius: 20px;
                padding: 2rem;
                width: 100%;
                max-width: 480px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.18);
                animation: slideUp 0.25s ease;
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

            .modal-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 1.5rem;
            }

            .modal-title {
                font-size: 1.1rem;
                font-weight: 700;
                color: #111827;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .modal-title i {
                color: #7c3aed;
            }

            .modal-close {
                background: none;
                border: none;
                font-size: 1.2rem;
                color: #9ca3af;
                cursor: pointer;
                padding: 4px;
                border-radius: 6px;
                transition: all 0.15s;
            }

            .modal-close:hover {
                background: #f3f4f6;
                color: #374151;
            }

            .form-group {
                margin-bottom: 1.1rem;
            }

            .form-label {
                display: block;
                font-size: 0.82rem;
                font-weight: 600;
                color: #374151;
                margin-bottom: 6px;
            }

            .form-input {
                width: 100%;
                padding: 10px 14px;
                background: #f9fafb;
                border: 1.5px solid #d1d5db;
                border-radius: 10px;
                font-size: 0.9rem;
                font-family: inherit;
                color: #111827;
                transition: border-color 0.2s;
                outline: none;
            }

            .form-input:focus {
                border-color: #7c3aed;
                background: #fff;
            }

            .form-input:disabled {
                opacity: 0.55;
                cursor: not-allowed;
            }

            /* Avatar upload preview */
            .avatar-upload-wrap {
                display: flex;
                align-items: center;
                gap: 14px;
                margin-bottom: 8px;
            }

            .avatar-preview {
                width: 72px;
                height: 72px;
                border-radius: 50%;
                background: linear-gradient(135deg, #6366f1, #8b5cf6);
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.6rem;
                font-weight: 700;
                color: #fff;
                overflow: hidden;
                flex-shrink: 0;
                border: 3px solid #ede9fe;
            }

            .avatar-preview img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .upload-btn-label {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 8px 14px;
                background: #f9fafb;
                border: 1.5px solid #d1d5db;
                border-radius: 8px;
                font-size: 0.82rem;
                font-weight: 600;
                color: #374151;
                cursor: pointer;
                transition: all 0.15s;
            }

            .upload-btn-label:hover {
                border-color: #7c3aed;
                color: #7c3aed;
                background: #faf5ff;
            }

            #avatarFile {
                display: none;
            }

            .modal-footer {
                display: flex;
                gap: 10px;
                justify-content: flex-end;
                margin-top: 1.5rem;
            }

            .btn-cancel-modal {
                padding: 10px 20px;
                background: #fff;
                border: 1.5px solid #d1d5db;
                border-radius: 10px;
                font-size: 0.875rem;
                font-weight: 600;
                color: #374151;
                cursor: pointer;
                transition: all 0.15s;
            }

            .btn-cancel-modal:hover {
                background: #f3f4f6;
            }

            .btn-save {
                padding: 10px 22px;
                background: linear-gradient(135deg, #6366f1, #8b5cf6);
                border: none;
                border-radius: 10px;
                font-size: 0.875rem;
                font-weight: 600;
                color: #fff;
                cursor: pointer;
                transition: all 0.2s;
                box-shadow: 0 3px 10px rgba(99, 102, 241, 0.25);
            }

            .btn-save:hover {
                transform: translateY(-1px);
                box-shadow: 0 6px 18px rgba(99, 102, 241, 0.35);
            }
        </style>
    </head>

    <body>
        <div class="container">
            <a href="<%= request.getContextPath()%>/books" class="back-link">
                <i class="fas fa-arrow-left"></i> Về trang chính
            </a>

            <!-- Sub nav (không có tab Chỉnh sửa) -->
            <div class="sub-nav">
                <a href="<%= request.getContextPath()%>/profile/view" class="sub-tab active">
                    <i class="fas fa-user"></i> Hồ sơ
                </a>
                <a href="<%= request.getContextPath()%>/profile/change-password" class="sub-tab">
                    <i class="fas fa-lock"></i> Mật khẩu
                </a>
                <a href="<%= request.getContextPath()%>/profile/linked-accounts" class="sub-tab">
                    <i class="fas fa-link"></i> Tài khoản liên kết
                </a>
            </div>

            <!-- Alert messages -->
            <% if ("1".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> Cập nhật hồ sơ thành công!
            </div>
            <% } %>
            <% if (request.getAttribute("error") != null) {%>
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error")%>
            </div>
            <% } %>

            <!-- Hero card -->
            <div class="profile-hero">
                <div class="avatar-circle" id="heroAvatar">
                    <% if (currentReader != null && currentReader.getAvatarUrl() != null
                                && !currentReader.getAvatarUrl().isBlank()) {%>
                    <img src="<%= currentReader.getAvatarUrl()%>" alt="Avatar"
                         id="heroAvatarImg">
                    <% } else {%>
                    <span id="heroAvatarInitials">
                        <%= currentReader != null ? currentReader.getInitials() : "?"%>
                    </span>
                    <% }%>
                </div>
                <div>
                    <div class="hero-name">
                        <%= currentReader != null ? currentReader.getFullName() : "—"%>
                    </div>
                    <div class="hero-email">
                        <i class="fas fa-envelope" style="color:#a78bfa;"></i>
                        <%= currentReader != null ? currentReader.getEmail() : "—"%>
                    </div>
                    <span class="role-badge">
                        <i class="fas fa-user-circle"></i>
                        <%= session.getAttribute("userRole") != null
                                ? session.getAttribute("userRole") : "User"%>
                    </span>
                </div>
                <button class="edit-btn" onclick="openModal()">
                    <i class="fas fa-pen"></i> Chỉnh sửa
                </button>
            </div>

            <!-- Info card -->
            <div class="info-card">
                <div class="info-card-title"><i class="fas fa-id-card"></i> Thông tin cá nhân
                </div>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-user"></i> Họ và tên</div>
                    <div class="info-value">
                        <%= currentReader != null ? currentReader.getFullName() : "—"%>
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-envelope"></i> Email</div>
                    <div class="info-value">
                        <%= currentReader != null ? currentReader.getEmail() : "—"%>
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-phone"></i> Điện thoại</div>
                    <% String phone = currentReader != null ? currentReader.getPhone() : null;%>
                    <div class="info-value <%= (phone == null || phone.isBlank()) ? " empty"
                                 : ""%>">
                        <%= (phone != null && !phone.isBlank()) ? phone : "Chưa cập nhật"%>
                    </div>
                </div>
                <div class="info-row">
                    <div class="info-label"><i class="fas fa-shield-alt"></i> Xác thực</div>
                    <% boolean hasPwd = currentReader != null && currentReader.hasPassword(); %>
                    <div class="info-value">
                        <% if (hasPwd) { %>
                        <span style="color:#16a34a;"><i class="fas fa-check-circle"></i>
                            Có mật khẩu</span>
                            <% } else { %>
                        <span style="color:#6b7280;"><i
                                class="fas fa-info-circle"></i> Đăng nhập qua mạng
                            xã hội</span>
                            <% }%>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── MODAL CHỈNH SỬA ── -->
        <div class="modal-overlay" id="editModal" onclick="closeOnOverlay(event)">
            <div class="modal">
                <div class="modal-header">
                    <div class="modal-title"><i class="fas fa-pen"></i> Chỉnh sửa hồ sơ</div>
                    <button class="modal-close" onclick="closeModal()"><i class="fas fa-times"></i></button>
                </div>

                <form method="post" action="<%= request.getContextPath()%>/profile/edit" id="editForm">
                    <!-- Avatar upload -->
                    <div class="form-group">
                        <div class="form-label">Ảnh đại diện</div>
                        <div class="avatar-upload-wrap">
                            <div class="avatar-preview" id="modalAvatar">
                                <% if (currentReader != null && currentReader.getAvatarUrl() != null
                                            && !currentReader.getAvatarUrl().isBlank()) {%>
                                <img src="<%= currentReader.getAvatarUrl()%>" alt="preview"
                                     id="avatarPreviewImg">
                                <% } else {%>
                                <span id="avatarPreviewInitials">
                                    <%= currentReader != null ? currentReader.getInitials() : "?"%>
                                </span>
                                <% }%>
                            </div>
                            <label for="avatarFile" class="upload-btn-label">
                                <i class="fas fa-camera"></i> Chọn ảnh
                            </label>
                            <input type="file" id="avatarFile" accept=".jpg, .jpeg, .gif"
                                   onchange="previewAvatar(this)">
                        </div>
                        <!-- Hidden field chứa base64 hoặc URL -->
                        <input type="hidden" name="avatarUrl" id="avatarUrlHidden"
                               value="<%= currentReader != null && currentReader.getAvatarUrl() != null ? currentReader.getAvatarUrl() : ""%>">
                        <div style="font-size:0.75rem;color:#9ca3af;margin-top:4px;">Hỗ trợ JPG, PNG, GIF. Tối
                            đa 2MB.</div>
                    </div>

                    <!-- Họ tên -->
                    <div class="form-group">
                        <label class="form-label" for="fullName">Họ và tên <span
                                style="color:#dc2626;">*</span></label>
                        <input type="text" id="fullName" name="fullName" class="form-input"
                               value="<%= currentReader != null && currentReader.getFullName() != null ? currentReader.getFullName() : ""%>"
                               placeholder="Nhập họ và tên" required>
                    </div>

                    <!-- Email (chỉ xem) -->
                    <div class="form-group">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-input" disabled
                               value="<%= currentReader != null && currentReader.getEmail() != null ? currentReader.getEmail() : ""%>">
                        <div style="font-size:0.75rem;color:#9ca3af;margin-top:4px;">Email không thể thay đổi.
                        </div>
                    </div>

                    <!-- Điện thoại -->
                    <div class="form-group">
                        <label class="form-label" for="phone">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" class="form-input"
                               value="<%= currentReader != null && currentReader.getPhone() != null ? currentReader.getPhone() : ""%>"
                               placeholder="Vd: 0901234567" oninput="validatePhone(this)">
                        <div id="phoneError"
                             style="display:none;font-size:0.75rem;color:#dc2626;margin-top:4px;">
                            <i class="fas fa-exclamation-circle"></i> Số điện thoại không hợp lệ (10 chữ số, bắt
                            đầu bằng 0).
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn-cancel-modal" onclick="closeModal()">Hủy</button>
                        <button type="submit" class="btn-save"><i class="fas fa-save"></i> Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function openModal() {
                document.getElementById('editModal').classList.add('open');
                document.body.style.overflow = 'hidden';
            }
            function closeModal() {
                document.getElementById('editModal').classList.remove('open');
                document.body.style.overflow = '';
            }
            function closeOnOverlay(e) {
                if (e.target === document.getElementById('editModal'))
                    closeModal();
            }
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape')
                    closeModal();
            });

            function validatePhone(input) {
                const val = input.value.trim();
                const err = document.getElementById('phoneError');
                if (val === '') {
                    err.style.display = 'none';
                    input.style.borderColor = '';
                    return true;
                }
                // Số VN: 10 chữ số bắt đầu bằng 0, hoặc +84 + 9 chữ số
                const ok = /^(0[3-9][0-9]{8}|(\+84)[3-9][0-9]{8})$/.test(val);
                if (ok) {
                    err.style.display = 'none';
                    input.style.borderColor = '#16a34a';
                } else {
                    err.style.display = 'block';
                    input.style.borderColor = '#dc2626';
                }
                return ok;
            }

            document.getElementById('editForm').addEventListener('submit', function (e) {
                const phoneInput = document.getElementById('phone');
                if (phoneInput.value.trim() !== '' && !validatePhone(phoneInput)) {
                    e.preventDefault();
                    phoneInput.focus();
                }
            });

            function previewAvatar(input) {
                if (!input.files || !input.files[0])
                    return;
                const file = input.files[0];


                const validTypes = ['image/jpeg', 'image/jpg', 'image/gif'];
                if (!validTypes.includes(file.type)) {
                    alert('Chỉ chấp nhận file ảnh định dạng JPG hoặc GIF!');
                    input.value = ''; // Xóa tệp đã chọn
                    return;
                }

                if (file.size > 2 * 1024 * 1024) {
                    alert('Ảnh quá lớn! Vui lòng chọn ảnh nhỏ hơn 2MB.');
                    input.value = '';
                    return;
                }
                const reader = new FileReader();
                reader.onload = function (e) {
                    const dataUrl = e.target.result;
                    // Update hidden field
                    document.getElementById('avatarUrlHidden').value = dataUrl;
                    // Update modal preview
                    const preview = document.getElementById('modalAvatar');
                    preview.innerHTML = '<img src="' + dataUrl + '" alt="preview" style="width:100%;height:100%;object-fit:cover;">';
                };
                reader.readAsDataURL(file);
            }
        </script>
    </body>

</html>