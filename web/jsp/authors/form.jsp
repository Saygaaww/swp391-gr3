<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Thư viện Số FPT</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/additional-styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/author-category-styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        .form-section {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .form-label.required::after {
            content: " *";
            color: #e53e3e;
        }
        
        .form-control, .form-textarea {
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            padding: 0.75rem;
            font-size: 0.95rem;
            transition: border-color 0.2s ease;
            width: 100%;
        }
        
        .form-control:focus, .form-textarea:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            outline: none;
        }
        
        .form-textarea {
            min-height: 120px;
            resize: vertical;
            font-family: inherit;
        }
        
        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px solid #e2e8f0;
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-cancel {
            background: transparent;
            border: 2px solid #e2e8f0;
            color: #718096;
            padding: 0.75rem 2rem;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-cancel:hover {
            border-color: #cbd5e0;
            background: #f7fafc;
            color: #718096;
            text-decoration: none;
        }
        
        .error-message {
            background: #fed7d7;
            border: 2px solid #fc8181;
            color: #c53030;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .success-message {
            background: #c6f6d5;
            border: 2px solid #68d391;
            color: #22543d;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .form-help-text {
            font-size: 0.875rem;
            color: #718096;
            margin-top: 0.25rem;
        }
        
        @media (max-width: 768px) {
            .form-actions {
                flex-direction: column;
            }
            
            .btn-submit, .btn-cancel {
                width: 100%;
                justify-content: center;
            }
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
                    <li><a href="${pageContext.request.contextPath}/authors" class="nav-link active">
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
        <div class="page-header">
            <h1>
                <i class="fas fa-${isEdit ? 'edit' : 'plus-circle'}"></i>
                ${isEdit ? 'Chỉnh sửa' : 'Thêm mới'} Tác giả
            </h1>
            <p>${isEdit ? 'Cập nhật thông tin tác giả' : 'Thêm tác giả mới vào hệ thống'}</p>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty error}">
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Success Message -->
        <c:if test="${not empty success}">
            <div class="success-message">
                <i class="fas fa-check-circle"></i>
                <span>${success}</span>
            </div>
        </c:if>

        <!-- Author Form -->
        <section class="form-section">
            <form method="post" 
                  action="${pageContext.request.contextPath}/authors${isEdit ? '/update/' : '/create'}${isEdit ? author.authorId : ''}" 
                  id="authorForm" novalidate>
                
                <c:if test="${isEdit && not empty author.authorId}">
                    <input type="hidden" name="authorId" value="${author.authorId}">
                    <input type="hidden" name="action" value="update">
                </c:if>
                <c:if test="${not isEdit}">
                    <input type="hidden" name="action" value="create">
                </c:if>
                
                <!-- Author Name -->
                <div class="form-group">
                    <label for="authorName" class="form-label required">
                        <i class="fas fa-user"></i>
                        Tên tác giả
                    </label>
                    <input type="text" 
                           id="authorName" 
                           name="authorName" 
                           class="form-control" 
                           placeholder="Nhập tên tác giả..." 
                           value="${not empty author.authorName ? author.authorName : ''}"
                           required
                           maxlength="255">
                    <div class="form-help-text">
                        Tên tác giả là bắt buộc và không được trùng với tác giả khác
                    </div>
                </div>
                
                <!-- Bio -->
                <div class="form-group">
                    <label for="bio" class="form-label">
                        <i class="fas fa-info-circle"></i>
                        Tiểu sử
                    </label>
                    <textarea id="bio" 
                              name="bio" 
                              class="form-textarea" 
                              placeholder="Nhập tiểu sử tác giả (tùy chọ?n)..."
                              maxlength="2000">${not empty author.bio ? author.bio : ''}</textarea>
                    <div class="form-help-text">
                        Giới thiệu về tác giả, các tác phẩm nổi bật, giải thưởng... (tối đa 2000 ký tự)
                    </div>
                </div>
                
                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="submit" class="btn-submit">
                        <i class="fas fa-${isEdit ? 'save' : 'plus'}"></i>
                        ${isEdit ? 'Cập nhật' : 'Thêm mới'}
                    </button>
                    <a href="${pageContext.request.contextPath}/authors" class="btn-cancel">
                        <i class="fas fa-times"></i>
                        Hủy
                    </a>
                    <c:if test="${isEdit && not empty author.authorId}">
                        <a href="${pageContext.request.contextPath}/authors/detail/${author.authorId}" class="btn-cancel">
                            <i class="fas fa-eye"></i>
                            Xem chi tiết
                        </a>
                    </c:if>
                </div>
            </form>
        </section>
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

    <div class="student-badge">
        <i class="fas fa-graduation-cap"></i>
        SWP391 Project
    </div>

    <!-- JavaScript -->
    <script>
        // Form validation
        document.getElementById('authorForm').addEventListener('submit', function(e) {
            const authorName = document.getElementById('authorName').value.trim();
            
            if (!authorName) {
                e.preventDefault();
                alert('Vui lòng nhập tên tác giả');
                document.getElementById('authorName').focus();
                return false;
            }
            
            if (authorName.length < 2) {
                e.preventDefault();
                alert('Tên tác giả phải có ít nhất 2 ký tự');
                document.getElementById('authorName').focus();
                return false;
            }
            
            // Show loading state
            const submitBtn = this.querySelector('.btn-submit');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
            submitBtn.disabled = true;
        });
        
        // Character counter for bio
        const bioTextarea = document.getElementById('bio');
        if (bioTextarea) {
            const maxLength = 2000;
            const helpText = bioTextarea.nextElementSibling;
            
            function updateCounter() {
                const currentLength = bioTextarea.value.length;
                const remaining = maxLength - currentLength;
                
                if (helpText) {
                    const baseText = helpText.textContent.split('(')[0].trim();
                    helpText.textContent = baseText + " (" + currentLength + "/" + maxLength + " ký tự)";
                    
                    if (remaining < 100) {
                        helpText.style.color = '#e53e3e';
                    } else {
                        helpText.style.color = '#718096';
                    }
                }
            }
            
            bioTextarea.addEventListener('input', updateCounter);
            updateCounter(); // Initial count
        }
        
        // Auto-focus on author name if empty
        if (!document.getElementById('authorName').value) {
            document.getElementById('authorName').focus();
        }
    </script>
</body>
</html>

