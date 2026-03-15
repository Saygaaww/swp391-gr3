<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${pageTitle != null ? pageTitle : 'Sales Analytics'}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
            background: #f4f7fe;
            margin: 0;
            padding: 24px;
        }
        .wrap {
            max-width: 1200px;
            margin: 0 auto;
        }
        h1 {
            font-size: 1.6rem;
            margin-bottom: 0.25rem;
        }
        .subtitle {
            color: #6b7280;
            margin-bottom: 1.5rem;
        }
        .card {
            background: #fff;
            border-radius: 12px;
            padding: 20px 24px;
            box-shadow: 0 4px 12px rgba(15,23,42,.06);
        }
        .placeholder {
            padding: 40px 0;
            text-align: center;
            color: #6b7280;
        }
    </style>
</head>
<body>
<div class="wrap">
    <h1><i class="fas fa-chart-line"></i> Sales Analytics</h1>
    <p class="subtitle">Thống kê doanh số, doanh thu và sách bán chạy.</p>

    <div class="card">
        <div class="placeholder">
            Dashboard phân tích doanh số (top-selling books, doanh thu theo thời gian, ...) sẽ được xây dựng tại đây.<br>
            (Hiện tại là trang placeholder để các nút dashboard dẫn đến đúng trang.)
        </div>
    </div>
</div>
</body>
</html>

