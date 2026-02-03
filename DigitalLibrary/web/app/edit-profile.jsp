<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Reader"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa hồ sơ - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container" style="max-width: 520px; margin: 0 auto;">
            <h2 class="section-title">Chỉnh sửa hồ sơ (Mock)</h2>
            <% Reader r = (Reader) request.getAttribute("reader"); %>
            <form action="#" method="post" style="background: white; padding: 32px; border-radius: 12px; box-shadow: var(--shadow-md);">
                <div style="margin-bottom: 16px;">
                    <label style="display: block; margin-bottom: 6px; font-weight: 500;">Họ tên</label>
                    <input type="text" name="fullName" value="<%= r != null && r.getFullName() != null ? r.getFullName() : "" %>" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px;">
                </div>
                <div style="margin-bottom: 16px;">
                    <label style="display: block; margin-bottom: 6px; font-weight: 500;">Email</label>
                    <input type="email" name="email" value="<%= r != null && r.getEmail() != null ? r.getEmail() : "" %>" readonly style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px; background: #f5f5f5;">
                </div>
                <div style="margin-bottom: 16px;">
                    <label style="display: block; margin-bottom: 6px; font-weight: 500;">Số điện thoại</label>
                    <input type="tel" name="phone" value="<%= r != null && r.getPhone() != null ? r.getPhone() : "" %>" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px;">
                </div>
                <div style="margin-bottom: 16px;">
                    <label style="display: block; margin-bottom: 6px; font-weight: 500;">Avatar (URL)</label>
                    <input type="text" name="avatar" placeholder="https://..." style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px;">
                </div>
                <button type="submit" class="btn-primary" style="width: 100%; padding: 14px;">Lưu thay đổi</button>
            </form>
            <p style="margin-top: 16px;"><a href="<%= request.getContextPath() %>/pages/change-password">Đổi mật khẩu</a> | <a href="<%= request.getContextPath() %>/pages/linked-accounts">Tài khoản liên kết</a></p>
        </div>
    </section>
</body>
</html>
