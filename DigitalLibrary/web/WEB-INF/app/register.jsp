<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/login.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container" style="max-width: 480px; margin: 0 auto;">
            <h2 class="section-title">Đăng ký tài khoản</h2>
            <p style="text-align: center; color: var(--text-secondary); margin-bottom: 24px;">Tạo tài khoản để sử dụng thư viện số (Mock)</p>
            <form action="#" method="post" style="background: white; padding: 32px; border-radius: 12px; box-shadow: var(--shadow-md);">
                <div style="margin-bottom: 16px;">
                    <label style="display: block; margin-bottom: 6px; font-weight: 500;">Họ tên</label>
                    <input type="text" name="fullName" placeholder="Nguyễn Văn A" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px;">
                </div>
                <div style="margin-bottom: 16px;">
                    <label style="display: block; margin-bottom: 6px; font-weight: 500;">Email</label>
                    <input type="email" name="email" placeholder="email@example.com" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px;">
                </div>
                <div style="margin-bottom: 16px;">
                    <label style="display: block; margin-bottom: 6px; font-weight: 500;">Số điện thoại</label>
                    <input type="tel" name="phone" placeholder="0901234567" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px;">
                </div>
                <div style="margin-bottom: 16px;">
                    <label style="display: block; margin-bottom: 6px; font-weight: 500;">Mật khẩu</label>
                    <input type="password" name="password" placeholder="••••••••" style="width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px;">
                </div>
                <button type="submit" class="btn-primary" style="width: 100%; padding: 14px;">Đăng ký</button>
            </form>
            <p style="text-align: center; margin-top: 20px;">
                Đã có tài khoản? <a href="<%= request.getContextPath() %>/login">Đăng nhập</a>
            </p>
        </div>
    </section>
</body>
</html>
