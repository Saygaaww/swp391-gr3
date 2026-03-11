<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <%@ page import="model.Employee, model.Role, util.AuthUtil" %>
        <%@ page import="java.util.List" %>
            <% Employee currentAdmin=(Employee) session.getAttribute(AuthUtil.SESSION_USER); if(currentAdmin==null) {
                response.sendRedirect(request.getContextPath() + "/auth/login" ); return; } Employee emp=(Employee)
                request.getAttribute("employee"); String mode=(String) request.getAttribute("mode"); boolean
                isEdit="edit" .equals(mode); %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>
                        <%= isEdit ? "Sửa thông tin Nhân viên" : "Thêm Nhân viên mới" %> - Admin Control Panel
                    </title>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                    <style>
                        *,
                        *::before,
                        *::after {
                            box-sizing: border-box;
                            margin: 0;
                            padding: 0;
                        }

                        body {
                            font-family: 'Inter', sans-serif;
                            background: #f4f7fe;
                            color: #111827;
                            min-height: 100vh;
                            padding: 24px;
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                        }

                        .container {
                            width: 100%;
                            max-width: 800px;
                        }

                        .top-bar {
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            margin-bottom: 24px;
                        }

                        .back-btn {
                            display: inline-flex;
                            align-items: center;
                            gap: 8px;
                            color: #4b5563;
                            text-decoration: none;
                            font-weight: 500;
                            background: #fff;
                            padding: 8px 16px;
                            border-radius: 8px;
                            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                            transition: all 0.2s;
                        }

                        .back-btn:hover {
                            color: #111827;
                            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                        }

                        .page-title {
                            font-size: 1.5rem;
                            font-weight: 700;
                        }

                        .content-panel {
                            background: #fff;
                            border-radius: 16px;
                            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                            padding: 30px;
                        }

                        .alert {
                            padding: 12px 16px;
                            border-radius: 8px;
                            margin-bottom: 24px;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }

                        .alert-error {
                            background: #fee2e2;
                            color: #dc2626;
                            border: 1px solid #f87171;
                        }

                        .form-grid {
                            display: grid;
                            grid-template-columns: 1fr 1fr;
                            gap: 20px;
                        }

                        .form-group {
                            margin-bottom: 20px;
                        }

                        .form-group.full-width {
                            grid-column: span 2;
                        }

                        .form-label {
                            display: block;
                            font-size: 0.9rem;
                            font-weight: 600;
                            color: #374151;
                            margin-bottom: 8px;
                        }

                        .form-control {
                            width: 100%;
                            padding: 10px 14px;
                            border: 1px solid #d1d5db;
                            border-radius: 8px;
                            font-family: inherit;
                            font-size: 0.95rem;
                            color: #111827;
                            outline: none;
                            transition: border-color 0.2s;
                        }

                        .form-control:focus {
                            border-color: #4f46e5;
                            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
                        }

                        .help-text {
                            font-size: 0.8rem;
                            color: #6b7280;
                            margin-top: 6px;
                            display: block;
                        }

                        .form-actions {
                            display: flex;
                            justify-content: flex-end;
                            gap: 12px;
                            margin-top: 30px;
                            padding-top: 20px;
                            border-top: 1px solid #e5e7eb;
                        }

                        .btn {
                            padding: 10px 24px;
                            border-radius: 8px;
                            font-weight: 600;
                            font-size: 0.95rem;
                            cursor: pointer;
                            border: none;
                            transition: all 0.2s;
                        }

                        .btn-cancel {
                            background: #f3f4f6;
                            color: #4b5563;
                            text-decoration: none;
                        }

                        .btn-cancel:hover {
                            background: #e5e7eb;
                        }

                        .btn-submit {
                            background: #4f46e5;
                            color: white;
                            display: inline-flex;
                            align-items: center;
                            gap: 8px;
                        }

                        .btn-submit:hover {
                            background: #4338ca;
                            box-shadow: 0 4px 6px rgba(79, 70, 229, 0.2);
                        }
                    </style>
                </head>

                <body>
                    <div class="container">
                        <!-- Top Bar -->
                        <div class="top-bar">
                            <a href="<%= request.getContextPath() %>/admin/employees" class="back-btn"><i
                                    class="fas fa-arrow-left"></i> Quay lại</a>
                            <h1 class="page-title">
                                <%= isEdit ? "Sửa thông tin Nhân viên" : "Thêm Nhân viên mới" %>
                            </h1>
                            <div style="width: 100px;"></div>
                        </div>

                        <div class="content-panel">
                            <% if (request.getAttribute("errorMessage") !=null) { %>
                                <div class="alert alert-error">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    <%= request.getAttribute("errorMessage") %>
                                </div>
                                <% } %>

                                    <form action="<%= request.getContextPath() %>/admin/employee-form" method="POST">
                                        <% if(isEdit) { %>
                                            <input type="hidden" name="employeeId" value="<%= emp.getEmployeeId() %>">
                                            <% } %>

                                                <div class="form-grid">
                                                    <div class="form-group full-width">
                                                        <label class="form-label">Họ và tên <span
                                                                style="color:red">*</span></label>
                                                        <input type="text" name="fullName" class="form-control"
                                                            value="<%= emp.getFullName() != null ? emp.getFullName() : "" %>"
                                                            required>
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Email làm việc <span
                                                                style="color:red">*</span></label>
                                                        <input type="email" name="email" class="form-control"
                                                            value="<%= emp.getEmail() != null ? emp.getEmail() : "" %>"
                                                            required>
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Mật khẩu <%= !isEdit
                                                                ? "<span style='color:red'>*</span>" : "" %></label>
                                                        <input type="password" name="password" class="form-control"
                                                            <%=!isEdit ? "required" : "" %>>
                                                        <% if(isEdit) { %>
                                                            <span class="help-text">Bỏ trống nếu không đổi mật khẩu
                                                                mới.</span>
                                                            <% } %>
                                                    </div>

                                                    <div class="form-group full-width">
                                                        <h3
                                                            style="font-size: 1rem; color: #111827; margin: 15px 0; border-bottom: 2px solid #e5e7eb; padding-bottom: 8px;">
                                                            Cấp quyền hệ thống</h3>
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Chức vụ / Vai trò <span
                                                                style="color:red">*</span></label>
                                                        <select name="roleId" class="form-control" required>
                                                            <option value="">-- Chọn vai trò --</option>
                                                            <% List<Role> roles = (List<Role>)
                                                                    request.getAttribute("roles");
                                                                    if(roles != null) {
                                                                    for(Role r : roles) {
                                                                    %>
                                                                    <option value="<%= r.getRoleId() %>"
                                                                        <%=emp.getRoleId()==r.getRoleId() ? "selected"
                                                                        : "" %>><%= r.getRoleName() %>
                                                                    </option>
                                                                    <% } } %>
                                                        </select>
                                                    </div>

                                                    <div class="form-group">
                                                        <label class="form-label">Trạng thái làm việc</label>
                                                        <select name="status" class="form-control">
                                                            <option value="active" <%="active" .equals(emp.getStatus())
                                                                ? "selected" : "" %>>Đang làm việc (Active)</option>
                                                            <option value="inactive" <%="inactive"
                                                                .equals(emp.getStatus()) ? "selected" : "" %>>Đã nghỉ
                                                                việc / Khóa tài khoản</option>
                                                        </select>
                                                    </div>
                                                </div>

                                                <div class="form-actions">
                                                    <a href="<%= request.getContextPath() %>/admin/employees"
                                                        class="btn btn-cancel">Hủy bỏ</a>
                                                    <button type="submit" class="btn btn-submit"><i
                                                            class="fas fa-save"></i>
                                                        <%= isEdit ? "Lưu thông tin nhân viên"
                                                            : "Tạo tài khoản nhân viên" %>
                                                    </button>
                                                </div>
                                    </form>
                        </div>
                    </div>
                </body>

                </html>
