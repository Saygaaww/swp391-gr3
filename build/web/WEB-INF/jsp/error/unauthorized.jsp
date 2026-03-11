<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Không có quyền truy cập - Thư viện Số FPT</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/additional-styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        .error-container {
            text-align: center;
            padding: 4rem 2rem;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .error-icon {
            font-size: 5rem;
            color: #e53e3e;
            margin-bottom: 1.5rem;
        }
        
        .error-title {
            font-size: 2rem;
            color: #2d3748;
            margin-bottom: 1rem;
        }
        
        .error-message {
            font-size: 1.1rem;
            color: #718096;
            margin-bottom: 2rem;
            line-height: 1.6;
        }
        
        .error-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .btn-action {
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-primary-action {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary-action:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            color: white;
            text-decoration: none;
        }
        
        .btn-secondary-action {
            background: transparent;
            border: 2px solid #e2e8f0;
            color: #718096;
        }
        
        .btn-secondary-action:hover {
            border-color: #cbd5e0;
            background: #f7fafc;
            color: #718096;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="main-header">
        <div class="container">
            <nav class="navbar">
                <a href="${pageContext.request.contextPath}/" class="navbar-brand">
                    <i class="fas fa-book-open"></i>
                    Thư viện Số FPT
                </a>
                <ul class="navbar-nav">
                    <li><a href="${pageContext.request.contextPath}/books" class="nav-link">
                        <i class="fas fa-search"></i> Tìm sách
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/authors" class="nav-link">
                        <i class="fas fa-user-edit"></i> Tác giả
                    </a></li>
                    <li><a href="${pageContext.request.contextPath}/categories" class="nav-link">
                        <i class="fas fa-tags"></i> Thể loại
                    </a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main class="container">
        <div class="error-container">
            <div class="error-icon">
                <i class="fas fa-shield-alt"></i>
            </div>
            
            <h1 class="error-title">Không có quyền truy cập</h1>
            
            <p class="error-message">
                <c:choose>
                    <c:when test="${not empty error}">
                        ${error}
                    </c:when>
                    <c:otherwise>
                        Bạn không có quyền truy cập chức năng này.<br>
                        Chỉ <strong>Librarian</strong> hoặc <strong>Seller</strong> mới có thể quản lý tác giả và thể loại.
                    </c:otherwise>
                </c:choose>
            </p>
            
            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/authors" class="btn-action btn-secondary-action">
                    <i class="fas fa-arrow-left"></i>
                    Quay lại danh sách
                </a>
                <a href="${pageContext.request.contextPath}/" class="btn-action btn-primary-action">
                    <i class="fas fa-home"></i>
                    Về trang chủ
                </a>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="main-footer">
        <div class="container">
            <div class="footer-content">
                <h3 class="footer-title">Thư viện Số FPT University</h3>
                <p class="footer-text">
                    Dự án SWP391 - Hệ thống quản lý thư viện số hiện đại và thân thiện
                </p>
            </div>
        </div>
    </footer>
</body>
</html>
