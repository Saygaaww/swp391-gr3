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
            <h1>${mode == 'edit' ? 'Sua Doc gia' : 'Them Doc gia'}</h1>
            <small>Reader Form</small>
        </div>
    </div>
    
    <div class="container">
        <a href="${pageContext.request.contextPath}/admin/readers" class="back-link">← Quay lai danh sach</a>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <div class="form-card">
            <div class="form-header">
                <h2>${mode == 'edit' ? 'Cap nhat thong tin doc gia' : 'Dien thong tin doc gia moi'}</h2>
            </div>
            
            <div class="form-body">
                <form action="${pageContext.request.contextPath}/admin/reader-form" method="post">
                    
                    <%-- Hidden field de phan biet Add/Edit --%>
                    <c:if test="${mode == 'edit'}">
                        <input type="hidden" name="readerId" value="${reader.readerId}">
                    </c:if>
                    
                    <%-- Ho ten + Email --%>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Ho ten <span class="required">*</span></label>
                            <input type="text" name="fullName" class="form-control" 
                                   value="${reader.fullName}" required
                                   placeholder="Nhap ho ten doc gia" maxlength="255">
                        </div>
                        
                        <div class="form-group">
                            <label>Email <span class="required">*</span></label>
                            <input type="email" name="email" class="form-control" 
                                   value="${reader.email}" required
                                   placeholder="example@email.com" maxlength="255">
                        </div>
                    </div>
                    
                    <%-- Mat khau + So dien thoai --%>
                    <div class="form-row">
                        <div class="form-group">
                            <label>
                                Mat khau 
                                <c:if test="${mode != 'edit'}"><span class="required">*</span></c:if>
                            </label>
                            <input type="password" name="password" class="form-control" 
                                   ${mode != 'edit' ? 'required' : ''}
                                   placeholder="${mode == 'edit' ? 'De trong neu khong doi' : 'Nhap mat khau'}">
                            <c:if test="${mode == 'edit'}">
                                <p class="hint">De trong neu khong muon thay doi mat khau</p>
                            </c:if>
                        </div>
                        
                        <div class="form-group">
                            <label>So dien thoai</label>
                            <input type="tel" name="phone" id="phoneInput" class="form-control" 
                                   value="${reader.phone}"
                                   placeholder="0901234567" minlength="10" maxlength="15"
                                   oninput="this.value = this.value.replace(/[^0-9]/g, ''); updatePhoneCounter();"
                                   onpaste="setTimeout(function(){ document.getElementById('phoneInput').value = document.getElementById('phoneInput').value.replace(/[^0-9]/g, ''); updatePhoneCounter(); }, 0);">
                            <p class="hint" id="phoneHint">Chi nhap so (10-15 ky tu). <span id="phoneCount">0</span>/15</p>
                        </div>
                    </div>
                    
                    <%-- Vai tro + Trang thai (THAY 'address' BANG 'roleId') --%>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Vai tro <span class="required">*</span></label>
                            <select name="roleId" class="form-control" required>
                                <option value="">-- Chon vai tro --</option>
                                <c:forEach var="role" items="${roles}">
                                    <option value="${role.roleId}" 
                                            ${reader.roleId == role.roleId ? 'selected' : ''}>
                                        ${role.roleName}
                                        <c:if test="${not empty role.description}"> - ${role.description}</c:if>
                                    </option>
                                </c:forEach>
                            </select>
                            <p class="hint">Vai tro quyet dinh quyen han cua doc gia trong he thong</p>
                        </div>
                        
                        <div class="form-group">
                            <label>Trang thai</label>
                            <select name="status" class="form-control">
                                <option value="active" ${reader.status == 'active' || empty reader.status ? 'selected' : ''}>
                                    Active - Dang hoat dong
                                </option>
                                <option value="inactive" ${reader.status == 'inactive' ? 'selected' : ''}>
                                    Inactive - Tam ngung
                                </option>
                                <option value="blocked" ${reader.status == 'blocked' ? 'selected' : ''}>
                                    Blocked - Bi khoa
                                </option>
                            </select>
                        </div>
                    </div>
                    
                    <%-- Thong tin bo sung khi edit --%>
                    <c:if test="${mode == 'edit'}">
                        <div style="background: #f8f9fa; padding: 15px 20px; border-radius: 8px; margin-top: 10px;">
                            <p style="font-size: 13px; color: #666;">
                                <strong>ID:</strong> #${reader.readerId} | 
                                <strong>Vai tro hien tai:</strong> ${reader.roleName}
                            </p>
                        </div>
                    </c:if>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            ${mode == 'edit' ? 'Luu thay doi' : 'Them doc gia'}
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/readers" class="btn btn-secondary">
                            Huy
                        </a>
                    </div>
                            
                    <script>
                        // Real-time phone counter
                        function updatePhoneCounter() {
                            var phone = document.getElementById('phoneInput');
                            var counter = document.getElementById('phoneCount');
                            var hint = document.getElementById('phoneHint');
                            if (phone && counter) {
                                counter.textContent = phone.value.length;
                                if (phone.value.length > 0 && phone.value.length < 10) {
                                    hint.style.color = '#dc3545';
                                } else if (phone.value.length >= 10) {
                                    hint.style.color = '#28a745';
                                } else {
                                    hint.style.color = '#999';
                                }
                            }
                        }
                        // Init counter on page load
                        updatePhoneCounter();
                        
                        document.querySelector('form').addEventListener('submit', function(e) {
                            var errors = [];
                            
                            // Validate ho ten
                            var fullName = document.querySelector('input[name="fullName"]');
                            if (fullName && !fullName.value.trim()) {
                                errors.push('Ho ten khong duoc de trong');
                                fullName.style.borderColor = '#dc3545';
                            } else if (fullName && fullName.value.trim().length > 255) {
                                errors.push('Ho ten khong duoc qua 255 ky tu');
                                fullName.style.borderColor = '#dc3545';
                            } else if (fullName) {
                                fullName.style.borderColor = '#e0e0e0';
                            }
                            
                            // Validate email
                            var email = document.querySelector('input[name="email"]');
                            if (email && !email.value.trim()) {
                                errors.push('Email khong duoc de trong');
                                email.style.borderColor = '#dc3545';
                            } else if (email && !/^[A-Za-z0-9+_.-]+@(.+)$/.test(email.value.trim())) {
                                errors.push('Email khong dung dinh dang');
                                email.style.borderColor = '#dc3545';
                            } else if (email) {
                                email.style.borderColor = '#e0e0e0';
                            }
                            
                            // Validate mat khau (bat buoc khi them moi)
                            var password = document.querySelector('input[name="password"]');
                            var isEdit = document.querySelector('input[name="readerId"]') != null;
                            if (password && !isEdit && !password.value.trim()) {
                                errors.push('Mat khau khong duoc de trong khi them moi');
                                password.style.borderColor = '#dc3545';
                            } else if (password && password.value.trim() && password.value.trim().length < 3) {
                                errors.push('Mat khau phai co it nhat 3 ky tu');
                                password.style.borderColor = '#dc3545';
                            } else if (password) {
                                password.style.borderColor = '#e0e0e0';
                            }
                            
                            // Validate so dien thoai (chi so, 10-15 ky tu)
                            var phone = document.getElementById('phoneInput');
                            if (phone && phone.value.trim()) {
                                var cleanPhone = phone.value.replace(/\s/g, '');
                                phone.value = cleanPhone; // strip any remaining whitespace
                                if (!/^[0-9]+$/.test(cleanPhone)) {
                                    errors.push('So dien thoai chi duoc chua cac chu so');
                                    phone.style.borderColor = '#dc3545';
                                } else if (cleanPhone.length < 10) {
                                    errors.push('So dien thoai phai co it nhat 10 chu so');
                                    phone.style.borderColor = '#dc3545';
                                } else if (cleanPhone.length > 15) {
                                    errors.push('So dien thoai khong duoc qua 15 chu so');
                                    phone.style.borderColor = '#dc3545';
                                } else {
                                    phone.style.borderColor = '#e0e0e0';
                                }
                            }
                            
                            // Validate vai tro
                            var roleId = document.querySelector('select[name="roleId"]');
                            if (roleId && !roleId.value) {
                                errors.push('Vui long chon vai tro');
                                roleId.style.borderColor = '#dc3545';
                            } else if (roleId) {
                                roleId.style.borderColor = '#e0e0e0';
                            }
                            
                            if (errors.length > 0) {
                                e.preventDefault();
                                var alertDiv = document.querySelector('.alert-danger');
                                if (!alertDiv) {
                                    alertDiv = document.createElement('div');
                                    alertDiv.className = 'alert alert-danger';
                                    alertDiv.style.cssText = 'padding:15px 20px;border-radius:8px;margin-bottom:20px;background:#f8d7da;color:#721c24;border:1px solid #f5c6cb;';
                                    document.querySelector('.form-card').before(alertDiv);
                                }
                                alertDiv.innerHTML = errors.join('<br>');
                                alertDiv.scrollIntoView({behavior: 'smooth'});
                            }
                        });
                    </script>        
                </form>
            </div>
        </div>
    </div>
</body>
</html>