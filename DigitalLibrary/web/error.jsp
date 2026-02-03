<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lỗi hệ thống - Digital Library</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: #f3f4f6;
            font-family: 'Poppins', sans-serif;
        }
        .error-wrapper {
            max-width: 720px;
            margin: 60px auto;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.15);
            padding: 32px 28px;
            text-align: left;
        }
        .error-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 16px;
        }
        .error-icon {
            width: 48px;
            height: 48px;
            border-radius: 999px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #fee2e2;
            color: #b91c1c;
            flex-shrink: 0;
        }
        .error-title {
            font-size: 20px;
            font-weight: 700;
            color: #111827;
        }
        .error-message {
            margin-top: 8px;
            color: #4b5563;
            font-size: 14px;
        }
        .error-tech {
            margin-top: 14px;
            padding: 12px 14px;
            background: #f9fafb;
            border-radius: 10px;
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
            font-size: 12px;
            color: #6b7280;
            max-height: 180px;
            overflow: auto;
        }
        .actions {
            margin-top: 20px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .btn {
            padding: 10px 16px;
            border-radius: 999px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-primary {
            background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            color: #ffffff;
        }
        .btn-secondary {
            background: #e5e7eb;
            color: #111827;
        }
    </style>
</head>
<body>
    <div class="error-wrapper">
        <div class="error-header">
            <div class="error-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <div>
                <div class="error-title">Đã xảy ra lỗi khi xử lý yêu cầu</div>
                <div class="error-message">
                    <% 
                        String msg = (String) request.getAttribute("error");
                        if (msg == null || msg.isEmpty()) {
                            msg = "Hệ thống đang gặp sự cố hoặc dữ liệu không tồn tại.";
                        }
                    %>
                    <%= msg %>
                </div>
            </div>
        </div>

        <% if (exception != null) { %>
        <div class="error-tech">
            <strong>Chi tiết kỹ thuật (stacktrace):</strong><br/>
            <pre style="margin:6px 0 0; white-space:pre-wrap;">
<%
    exception.printStackTrace(new java.io.PrintWriter(out));
%>
            </pre>
        </div>
        <% } %>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                <i class="fas fa-home"></i> Về trang chính
            </a>
            <button class="btn btn-secondary" type="button" onclick="history.back()">
                <i class="fas fa-arrow-left"></i> Quay lại
            </button>
        </div>
    </div>
</body>
</html>

