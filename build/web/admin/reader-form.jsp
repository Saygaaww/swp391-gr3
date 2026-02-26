<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${mode == 'edit' ? 'Sửa' : 'Thêm'} Độc giả - Admin</title>
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
            background: ${mode == 'edit' ? 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)' : 'linear-gradient(135deg, #11998e 0%, #38ef7d 100%)'};
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header h1 {
            font-size: 24px;
        }
        
        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #11998e;
            text-decoration: none;
            font-weight: 600;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
        
        .form-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        
        .form-header {
            background: ${mode == 'edit' ? '#f5576c' : '#11998e'};
            color: white;
            padding: 20px 30px;
        }
        
        .form-header h2 {
            font-size: 20px;
        }
        
        .form-body {
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-group label .required {
            color: #dc3545;
        }
        
        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #11998e;
            box-shadow: 0 0 0 3px rgba(17, 153, 142, 0.1);
        }
        
        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background: ${mode == 'edit' ? '#f5576c' : '#11998e'};
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .hint {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        
        @media (max-width: 600px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div>
            <h1>${mode == 'edit' ? '✏️ Sửa Độc giả' : '➕ Thêm Độc giả'}</h1>
            <small>Reader Form</small>
        </div>
    </div>
    
    <div class="container">
        <a href="${pageContext.request.contextPath}/admin/readers" class="back-link">← Quay lại danh sách</a>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <div class="form-card">
            <div class="form-header">
                <h2>${mode == 'edit' ? 'Cập nhật thông tin độc giả' : 'Điền thông tin độc giả mới'}</h2>
            </div>
            
            <div class="form-body">
                <form action="${pageContext.request.contextPath}/admin/reader-form" method="post">
                    
                    <!-- Hidden field để phân biệt Add/Edit -->
                    <c:if test="${mode == 'edit'}">
                        <input type="hidden" name="readerId" value="${reader.readerId}">
                    </c:if>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>Họ tên <span class="required">*</span></label>
                            <input type="text" name="fullName" class="form-control" 
                                   value="${reader.fullName}" required
                                   placeholder="Nhập họ tên độc giả">
                        </div>
                        
                        <div class="form-group">
                            <label>Email <span class="required">*</span></label>
                            <input type="email" name="email" class="form-control" 
                                   value="${reader.email}" required
                                   placeholder="example@email.com">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label>
                                Mật khẩu 
                                <c:if test="${mode != 'edit'}"><span class="required">*</span></c:if>
                            </label>
                            <input type="password" name="password" class="form-control" 
                                   ${mode != 'edit' ? 'required' : ''}
                                   placeholder="${mode == 'edit' ? 'Để trống nếu không đổi' : 'Nhập mật khẩu'}">
                            <c:if test="${mode == 'edit'}">
                                <p class="hint">Để trống nếu không muốn thay đổi mật khẩu</p>
                            </c:if>
                        </div>
                        
                        <div class="form-group">
                            <label>Số điện thoại</label>
                            <input type="tel" name="phone" class="form-control" 
                                   value="${reader.phone}"
                                   placeholder="0901234567">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Địa chỉ</label>
                        <textarea name="address" class="form-control" 
                                  placeholder="Nhập địa chỉ đầy đủ">${reader.address}</textarea>
                    </div>
                    
                    <div class="form-group">
                        <label>Trạng thái</label>
                        <select name="status" class="form-control">
                            <option value="active" ${reader.status == 'active' || empty reader.status ? 'selected' : ''}>
                                Active - Đang hoạt động
                            </option>
                            <option value="inactive" ${reader.status == 'inactive' ? 'selected' : ''}>
                                Inactive - Tạm ngưng
                            </option>
                            <option value="blocked" ${reader.status == 'blocked' ? 'selected' : ''}>
                                Blocked - Bị khóa
                            </option>
                        </select>
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            ${mode == 'edit' ? 'Lưu thay đổi' : 'Thêm độc giả'}
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/readers" class="btn btn-secondary">
                            Hủy
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>