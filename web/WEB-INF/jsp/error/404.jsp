<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Không tìm thấy trang</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f8fafc; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; color: #1e293b; }
        .container { text-align: center; padding: 2rem; }
        h1 { font-size: 6rem; margin: 0; color: #94a3b8; }
        h2 { font-size: 1.5rem; margin: 0.5rem 0 1rem; }
        p { color: #64748b; margin-bottom: 2rem; }
        a { display: inline-block; padding: 0.75rem 2rem; background: #475569; color: #fff; text-decoration: none; border-radius: 8px; }
        a:hover { background: #334155; }
    </style>
</head>
<body>
    <div class="container">
        <h1>404</h1>
        <h2>Không tìm thấy trang</h2>
        <p>Trang bạn đang tìm không tồn tại hoặc đã bị di chuyển.</p>
        <a href="${pageContext.request.contextPath}/">Về trang chủ</a>
    </div>
</body>
</html>
