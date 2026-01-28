<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"="width=device-width, initial-scale=1.0">
    <title>Thêm sách mới - Admin</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f0f0;
            min-height: 100vh;
        }
        
        .header {
            background: #5a5a5a;
            color: white;
            padding: 20px 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        
        .header h1 {
            font-size: 28px;
            font-weight: 600;
        }
        
        .container {
            max-width: 900px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            padding: 40px;
        }
        
        .card-header {
            margin-bottom: 30px;
        }
        
        .card-header h2 {
            font-size: 24px;
            color: #333;
            margin-bottom: 10px;
        }
        
        .card-header p {
            color: #666;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }
        
        .form-group label span {
            color: #dc3545;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #888888;
            box-shadow: 0 0 0 3px rgba(136, 136, 136, 0.1);
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .alert-error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid #f0f0f0;
        }
        
        .btn {
            padding: 14px 30px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background: #888888;
            color: white;
            box-shadow: 0 4px 15px rgba(136, 136, 136, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(136, 136, 136, 0.4);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .form-help {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>➕ Thêm sách mới</h1>
    </div>
    
    <div class="container">
        <div class="card">
            <div class="card-header">
                <h2>Thông tin sách</h2>
                <p>Điền đầy đủ thông tin để thêm sách mới vào hệ thống</p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    ⚠️ ${error}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/admin/book-add" method="post">
                
                <!-- Tên sách -->
                <div class="form-group">
                    <label>Tên sách <span>*</span></label>
                    <input type="text" name="title" required placeholder="Nhập tên sách...">
                </div>
                
                <!-- Tóm tắt -->
                <div class="form-group">
                    <label>Tóm tắt</label>
                    <textarea name="summary" placeholder="Tóm tắt ngắn gọn về nội dung sách..."></textarea>
                    <div class="form-help">Mô tả ngắn gọn (1-2 câu)</div>
                </div>
                
                <!-- Mô tả chi tiết -->
                <div class="form-group">
                    <label>Mô tả chi tiết</label>
                    <textarea name="description" rows="5" placeholder="Mô tả chi tiết về sách..."></textarea>
                </div>
                
                <!-- URL ảnh bìa -->
                <div class="form-group">
                    <label>URL ảnh bìa</label>
                    <input type="url" name="coverUrl" placeholder="https://example.com/cover.jpg">
                    <div class="form-help">Link ảnh bìa sách (để trống nếu chưa có)</div>
                </div>
                
                <!-- Đường dẫn file -->
                <div class="form-group">
                    <label>Đường dẫn file PDF</label>
                    <input type="text" name="contentPath" placeholder="/books/filename.pdf">
                </div>
                
                <!-- Giá và Đơn vị -->
                <div class="form-row">
                    <div class="form-group">
                        <label>Giá</label>
                        <input type="number" name="price" step="0.01" min="0" placeholder="0.00">
                    </div>
                    <div class="form-group">
                        <label>Đơn vị tiền tệ</label>
                        <select name="currency">
                            <option value="VND" selected>VND (₫)</option>
                            <option value="USD">USD ($)</option>
                            <option value="EUR">EUR (€)</option>
                        </select>
                    </div>
                </div>
                
                <!-- Tổng trang và Preview -->
                <div class="form-row">
                    <div class="form-group">
                        <label>Tổng số trang</label>
                        <input type="number" name="totalPages" min="1" placeholder="250">
                    </div>
                    <div class="form-group">
                        <label>Số trang xem trước</label>
                        <input type="number" name="previewPages" min="0" placeholder="20">
                    </div>
                </div>
                
                <!-- Tác giả và Danh mục -->
                <div class="form-row">
                    <div class="form-group">
                        <label>Tác giả</label>
                        <select name="authorId">
                            <option value="">-- Chọn tác giả --</option>
                            <c:forEach var="author" items="${authors}">
                                <option value="${author.authorId}">${author.authorName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Danh mục</label>
                        <select name="categoryId">
                            <option value="">-- Chọn danh mục --</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryId}">${category.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                
                <!-- Trạng thái -->
                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="active" selected>✓ Active (Hoạt động)</option>
                        <option value="inactive">✗ Inactive (Không hoạt động)</option>
                    </select>
                </div>
                
                <!-- Nút hành động -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        ✅ Thêm sách
                    </button>
                    <a href="${pageContext.request.contextPath}/books-list" class="btn btn-secondary">
                        ← Quay lại
                    </a>
                </div>
                
            </form>
        </div>
    </div>
</body>
</html>