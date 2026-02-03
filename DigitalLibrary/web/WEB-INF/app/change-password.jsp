<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container" style="max-width: 480px; margin: 0 auto;">
            <h2 class="section-title">Đổi mật khẩu (Mock)</h2>
            <form action="#" method="post" style="background: white; padding: 32px; border-radius: 12px; box-shadow: var(--shadow-md);">
                <div style="margin-bottom: 16px;">
                    <label style="display: block; margin-bottom: 6px; font-weight: 500;">Mật khẩu hiện tại</label>
                    <input type="password" name="currentPassword" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px;">
                </div>
                <div style="margin-bottom: 16px;">
                    <label style="display: block; margin-bottom: 6px; font-weight: 500;">Mật khẩu mới</label>
                    <input type="password" name="newPassword" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px;">
                </div>
                <div style="margin-bottom: 16px;">
                    <label style="display: block; margin-bottom: 6px; font-weight: 500;">Xác nhận mật khẩu mới</label>
                    <input type="password" name="confirmPassword" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px;">
                </div>
                <button type="submit" class="btn-primary" style="width: 100%; padding: 14px;">Cập nhật mật khẩu</button>
            </form>
        </div>
    </section>
</body>
</html>
