<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="model.Reader, model.LinkedAccount, util.AuthUtil, java.util.List" %>
        <% Reader currentReader=(Reader) session.getAttribute(AuthUtil.SESSION_USER); List<LinkedAccount> linkedAccounts
            = (List<LinkedAccount>) request.getAttribute("linkedAccounts");
                Boolean isGoogleLinked = (Boolean) request.getAttribute("isGoogleLinked");
                Boolean isFacebookLinked = (Boolean) request.getAttribute("isFacebookLinked");
                %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Tài khoản liên kết - Digital Library</title>
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
                            margin-bottom: 8px;
                            display: flex;
                            align-items: center;
                            gap: 8px;
                        }

                        .card-title i {
                            color: #7c3aed;
                        }

                        .card-desc {
                            color: #6b7280;
                            font-size: 0.85rem;
                            margin-bottom: 24px;
                        }

                        .provider-row {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            padding: 16px;
                            background: #f9fafb;
                            border: 1px solid #e5e7eb;
                            border-radius: 12px;
                            margin-bottom: 12px;
                        }

                        .provider-info {
                            display: flex;
                            align-items: center;
                            gap: 14px;
                        }

                        .provider-icon {
                            width: 44px;
                            height: 44px;
                            border-radius: 10px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-size: 1.2rem;
                            flex-shrink: 0;
                        }

                        .google-icon {
                            background: rgba(234, 67, 53, 0.15);
                            color: #ea4335;
                        }

                        .facebook-icon {
                            background: rgba(24, 119, 242, 0.15);
                            color: #1877f2;
                        }

                        .provider-name {
                            font-weight: 600;
                            color: #111827;
                            font-size: 0.95rem;
                        }

                        .provider-email {
                            color: #6b7280;
                            font-size: 0.8rem;
                            margin-top: 2px;
                        }

                        .badge-linked {
                            background: #f0fdf4;
                            color: #16a34a;
                            border: 1px solid #bbf7d0;
                            padding: 3px 10px;
                            border-radius: 99px;
                            font-size: 0.75rem;
                            font-weight: 600;
                        }

                        .btn-link-account {
                            padding: 8px 16px;
                            background: linear-gradient(135deg, #6366f1, #8b5cf6);
                            border: none;
                            border-radius: 8px;
                            color: #fff;
                            font-size: 0.8rem;
                            font-weight: 600;
                            font-family: inherit;
                            cursor: pointer;
                            text-decoration: none;
                            transition: all 0.2s;
                        }

                        .btn-link-account:hover {
                            transform: translateY(-1px);
                            box-shadow: 0 5px 15px rgba(99, 102, 241, 0.35);
                        }

                        .btn-unlink {
                            padding: 8px 16px;
                            background: #fef2f2;
                            border: 1px solid #fecaca;
                            border-radius: 8px;
                            color: #dc2626;
                            font-size: 0.8rem;
                            font-weight: 600;
                            font-family: inherit;
                            cursor: pointer;
                            transition: all 0.2s;
                        }

                        .btn-unlink:hover {
                            background: #fee2e2;
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

                        .alert-success {
                            background: #f0fdf4;
                            border: 1px solid #bbf7d0;
                            color: #16a34a;
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
                        <a href="<%= request.getContextPath() %>/books" class="back-link"><i
                                class="fas fa-arrow-left"></i> Về trang chính</a>

                        <div class="nav-tabs">
                            <a href="<%= request.getContextPath() %>/profile/view" class="nav-tab"><i
                                    class="fas fa-user"></i> Hồ sơ</a>
                            <a href="<%= request.getContextPath() %>/profile/change-password" class="nav-tab"><i
                                    class="fas fa-lock"></i> Mật khẩu</a>
                            <a href="<%= request.getContextPath() %>/profile/linked-accounts" class="nav-tab active"><i
                                    class="fas fa-link"></i> Tài khoản liên kết</a>
                        </div>

                        <% if ("1".equals(request.getParameter("unlinked"))) { %>
                            <div class="alert alert-success"><i class="fas fa-check-circle"></i>Đã gỡ liên kết tài khoản
                                thành công.</div>
                            <% } %>

                                <div class="card">
                                    <div class="card-title"><i class="fas fa-link"></i> Tài khoản liên kết</div>
                                    <div class="card-desc">Kết nối với Google hoặc Facebook để đăng nhập nhanh hơn.
                                    </div>

                                    <%-- Google --%>
                                        <div class="provider-row">
                                            <div class="provider-info">
                                                <div class="provider-icon google-icon"><i class="fab fa-google"></i>
                                                </div>
                                                <div>
                                                    <div class="provider-name">Google</div>
                                                    <div class="provider-email">
                                                        <% if (Boolean.TRUE.equals(isGoogleLinked) && linkedAccounts
                                                            !=null) { for (LinkedAccount la : linkedAccounts) { if
                                                            ("google".equals(la.getProvider())) { %>
                                                            <%= la.getProviderEmail() !=null ? la.getProviderEmail()
                                                                : "Đã liên kết" %>
                                                                <% } } } else { %>
                                                                    Chưa liên kết
                                                                    <% } %>
                                                    </div>
                                                </div>
                                            </div>
                                            <% if (Boolean.TRUE.equals(isGoogleLinked) && linkedAccounts !=null) { for
                                                (LinkedAccount la : linkedAccounts) { if
                                                ("google".equals(la.getProvider())) { %>
                                                <div style="display:flex;align-items:center;gap:10px;">
                                                    <span class="badge-linked"><i class="fas fa-check"
                                                            style="margin-right:4px;"></i>Đã liên kết</span>
                                                    <form method="post"
                                                        action="<%= request.getContextPath() %>/profile/linked-accounts/unlink"
                                                        style="margin:0;"
                                                        onsubmit="return confirm('Xác nhận gỡ liên kết Google?')">
                                                        <input type="hidden" name="linkId"
                                                            value="<%= la.getLinkId() %>">
                                                        <button type="submit" class="btn-unlink">Gỡ liên kết</button>
                                                    </form>
                                                </div>
                                                <% } } } else { %>
                                                    <a href="<%= request.getContextPath() %>/auth/oauth/google?action=link"
                                                        class="btn-link-account">
                                                        <i class="fas fa-plus" style="margin-right:4px;"></i>Liên kết
                                                    </a>
                                                    <% } %>
                                        </div>

                                        <%-- Facebook --%>
                                            <div class="provider-row">
                                                <div class="provider-info">
                                                    <div class="provider-icon facebook-icon"><i
                                                            class="fab fa-facebook-f"></i></div>
                                                    <div>
                                                        <div class="provider-name">Facebook</div>
                                                        <div class="provider-email">
                                                            <% if (Boolean.TRUE.equals(isFacebookLinked) &&
                                                                linkedAccounts !=null) { for (LinkedAccount la :
                                                                linkedAccounts) { if
                                                                ("facebook".equals(la.getProvider())) { %>
                                                                <%= la.getProviderEmail() !=null ? la.getProviderEmail()
                                                                    : "Đã liên kết" %>
                                                                    <% } } } else { %>
                                                                        Chưa liên kết
                                                                        <% } %>
                                                        </div>
                                                    </div>
                                                </div>
                                                <% if (Boolean.TRUE.equals(isFacebookLinked) && linkedAccounts !=null) {
                                                    for (LinkedAccount la : linkedAccounts) { if
                                                    ("facebook".equals(la.getProvider())) { %>
                                                    <div style="display:flex;align-items:center;gap:10px;">
                                                        <span class="badge-linked"><i class="fas fa-check"
                                                                style="margin-right:4px;"></i>Đã liên kết</span>
                                                        <form method="post"
                                                            action="<%= request.getContextPath() %>/profile/linked-accounts/unlink"
                                                            style="margin:0;"
                                                            onsubmit="return confirm('Xác nhận gỡ liên kết Facebook?')">
                                                            <input type="hidden" name="linkId"
                                                                value="<%= la.getLinkId() %>">
                                                            <button type="submit" class="btn-unlink">Gỡ liên
                                                                kết</button>
                                                        </form>
                                                    </div>
                                                    <% } } } else { %>
                                                        <a href="<%= request.getContextPath() %>/auth/oauth/facebook?action=link"
                                                            class="btn-link-account">
                                                            <i class="fas fa-plus" style="margin-right:4px;"></i>Liên
                                                            kết
                                                        </a>
                                                        <% } %>
                                            </div>
                                </div>
                    </div>
                <% } %></body>

                </html>