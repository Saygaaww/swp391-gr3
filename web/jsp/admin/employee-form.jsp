<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER); %>

<jsp:include page="/includes/header.jsp" />

<main class="container py-5 my-5" style="min-height: 70vh;">
    <div class="mb-4">
        <h2 style="font-weight: 700;">
            <i class="fas fa-user-tie" style="color:#4f46e5;"></i> ${mode == 'edit' ? 'Sửa nhân viên' : 'Thêm nhân viên mới'}
        </h2>
    </div>
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none"><i class="fas fa-home"></i> Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/employees" class="text-decoration-none">Nhân viên</a></li>
            <li class="breadcrumb-item active">${mode == 'edit' ? 'Sửa' : 'Thêm'}</li>
        </ol>
    </nav>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${errorMessage}</div>
    </c:if>

    <div class="card shadow-sm border-0">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/employee-form" method="post">
                <c:if test="${mode == 'edit'}">
                    <input type="hidden" name="employeeId" value="${employee.employeeId}">
                </c:if>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Họ tên <span class="text-danger">*</span></label>
                        <input type="text" name="fullName" class="form-control" value="${employee.fullName}" required maxlength="255">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Email <span class="text-danger">*</span></label>
                        <input type="email" name="email" class="form-control" value="${employee.email}" required maxlength="255">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Vai trò <span class="text-danger">*</span></label>
                        <select name="roleId" class="form-select" required>
                            <option value="">-- Chọn vai trò --</option>
                            <c:forEach var="r" items="${roles}">
                                <option value="${r.roleId}" <c:if test="${employee.roleId == r.roleId}">selected</c:if>>${r.roleName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="active" <c:if test="${employee.status == 'active'}">selected</c:if>>Active</option>
                            <option value="blocked" <c:if test="${employee.status == 'blocked'}">selected</c:if>>Blocked</option>
                            <option value="inactive" <c:if test="${employee.status == 'inactive'}">selected</c:if>>Inactive</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Mật khẩu ${mode == 'edit' ? '(để trống nếu không đổi)' : '*'}</label>
                        <input type="password" name="password" class="form-control" placeholder="Mật khẩu" <c:if test="${mode != 'edit'}">required</c:if>>
                    </div>
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary" style="background:#1a1a2e; border-color:#1a1a2e;"><i class="fas fa-save"></i> Lưu</button>
                        <a href="${pageContext.request.contextPath}/admin/employees" class="btn btn-outline-secondary">Hủy</a>
                    </div>
                </div>
            </form>
        </div>
    </div>
</main>

<jsp:include page="/includes/footer.jsp" />
