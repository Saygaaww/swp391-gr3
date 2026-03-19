<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER); %>

<jsp:include page="/includes/header.jsp" />

<main class="container py-5 my-5" style="min-height: 70vh;">
    <div class="mb-4">
        <h2 style="font-weight: 700;">
            <i class="fas fa-user" style="color:#4f46e5;"></i> ${mode == 'edit' ? 'Sửa đọc giả' : 'Thêm đọc giả mới'}
        </h2>
    </div>
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none"><i class="fas fa-home"></i> Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/readers" class="text-decoration-none">Đọc giả</a></li>
            <li class="breadcrumb-item active">${mode == 'edit' ? 'Sửa' : 'Thêm'}</li>
        </ol>
    </nav>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${errorMessage}</div>
    </c:if>

    <div class="card shadow-sm border-0">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/reader-form" method="post">
                <c:if test="${mode == 'edit'}">
                    <input type="hidden" name="readerId" value="${reader.readerId}">
                </c:if>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Họ tên <span class="text-danger">*</span></label>
                        <input type="text" name="fullName" class="form-control" value="${reader.fullName}" required maxlength="255">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Email <span class="text-danger">*</span></label>
                        <input type="email" name="email" class="form-control" value="${reader.email}" required maxlength="255" <c:if test="${mode == 'edit'}">readonly</c:if>>
                        <c:if test="${mode == 'edit'}"><small class="text-muted">Không đổi email khi sửa.</small></c:if>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" name="phone" class="form-control" value="${reader.phone}" maxlength="30">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Vai trò <span class="text-danger">*</span></label>
                        <select name="roleId" class="form-select" required>
                            <option value="">-- Chọn vai trò --</option>
                            <c:forEach var="r" items="${roles}">
                                <option value="${r.roleId}" <c:if test="${reader.roleId == r.roleId}">selected</c:if>>${r.roleName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="active" <c:if test="${reader.status == 'active'}">selected</c:if>>Active</option>
                            <option value="blocked" <c:if test="${reader.status == 'blocked'}">selected</c:if>>Blocked</option>
                            <option value="inactive" <c:if test="${reader.status == 'inactive'}">selected</c:if>>Inactive</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Mật khẩu ${mode == 'edit' ? '(để trống nếu không đổi)' : '*'}</label>
                        <input type="password" name="password" class="form-control" placeholder="Mật khẩu" minlength="3" <c:if test="${mode != 'edit'}">required</c:if>>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary" style="background:#1a1a2e; border-color:#1a1a2e;"><i class="fas fa-save"></i> Lưu</button>
                        <a href="${pageContext.request.contextPath}/admin/readers" class="btn btn-outline-secondary">Hủy</a>
                    </div>
                </div>
            </form>

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
            errors.push('Họ tên không được để trống');
            fullName.style.borderColor = '#dc3545';
        } else if (fullName && fullName.value.trim().length > 255) {
            errors.push('Họ tên không được quá 255 ký tự');
            fullName.style.borderColor = '#dc3545';
        } else if (fullName) {
            fullName.style.borderColor = '#e0e0e0';
        }
        
        // Validate email
        var email = document.querySelector('input[name="email"]');
        if (email && !email.value.trim()) {
            errors.push('Email không được để trống');
            email.style.borderColor = '#dc3545';
        } else if (email && !/^[A-Za-z0-9+_.-]+@(.+)$/.test(email.value.trim())) {
            errors.push('Email không đúng định dạng');
            email.style.borderColor = '#dc3545';
        } else if (email) {
            email.style.borderColor = '#e0e0e0';
        }
        
        // Validate mat khau (bat buoc khi them moi)
        var password = document.querySelector('input[name="password"]');
        var isEdit = document.querySelector('input[name="readerId"]') != null;
        if (password && !isEdit && !password.value.trim()) {
            errors.push('Mật khẩu không được để trống khi thêm mới');
            password.style.borderColor = '#dc3545';
        } else if (password && password.value.trim() && password.value.trim().length < 3) {
            errors.push('Mật khẩu phải có ít nhất 3 ký tự');
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
                errors.push('Số điện thoại chỉ được chứa các chữ số');
                phone.style.borderColor = '#dc3545';
            } else if (cleanPhone.length < 10) {
                errors.push('Số điện thoại phải có ít nhất 10 chữ số');
                phone.style.borderColor = '#dc3545';
            } else if (cleanPhone.length > 15) {
                errors.push('Số điện thoại không được quá 15 chữ số');
                phone.style.borderColor = '#dc3545';
            } else {
                phone.style.borderColor = '#e0e0e0';
            }
        }
        
        // Validate vai tro
        var roleId = document.querySelector('select[name="roleId"]');
        if (roleId && !roleId.value) {
            errors.push('Vui lòng chọn vai trò');
            roleId.style.borderColor = '#dc3545';
        } else if (roleId) {
            roleId.style.borderColor = '#e0e0e0';
        }
        
        if (errors.length > 0) {
            e.preventDefault();
            var alertDiv = document.querySelector('.alert-danger.validation-errors');
            if (!alertDiv) {
                alertDiv = document.createElement('div');
                alertDiv.className = 'alert alert-danger validation-errors';
                alertDiv.style.cssText = 'padding:15px 20px;border-radius:8px;margin-bottom:20px;background:#f8d7da;color:#721c24;border:1px solid #f5c6cb;';
                document.querySelector('.card-body').prepend(alertDiv);
            }
            alertDiv.innerHTML = '<i class="fas fa-exclamation-circle"></i> <strong>Vui lòng sửa các lỗi sau:</strong><br>' + errors.join('<br>');
            alertDiv.scrollIntoView({behavior: 'smooth', block: 'center'});
        }
    });

    // Xoa vien do khi nguoi dung bat dau nhap lai
    document.querySelectorAll('input, select, textarea').forEach(function(el) {
        el.addEventListener('input', function() {
            this.style.borderColor = '#e0e0e0';
        });
        el.addEventListener('change', function() {
            this.style.borderColor = '#e0e0e0';
        });
    });
</script>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
