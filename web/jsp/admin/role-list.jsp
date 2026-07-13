<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <%@ page import="model.Role, model.Employee, util.AuthUtil" %>
        <%@ page import="java.util.List" %>
            <% Employee currentAdmin=(Employee) session.getAttribute(AuthUtil.SESSION_USER); if(currentAdmin==null ||
                !"ADMIN".equalsIgnoreCase(currentAdmin.getRoleName())) { response.sendRedirect(request.getContextPath()
                + "/admin/dashboard" ); return; } %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Quản lý Vai trò - Admin Control Panel</title>
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
                            max-width: 1000px;
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

                        .alert {
                            padding: 12px 16px;
                            border-radius: 8px;
                            margin-bottom: 20px;
                        }

                        .alert-error {
                            background: #fee2e2;
                            color: #dc2626;
                            border: 1px solid #f87171;
                        }

                        .main-layout {
                            display: grid;
                            grid-template-columns: 1fr 300px;
                            gap: 24px;
                            align-items: start;
                        }

                        @media (max-width: 768px) {
                            .main-layout {
                                grid-template-columns: 1fr;
                            }
                        }

                        .content-panel {
                            background: #fff;
                            border-radius: 16px;
                            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
                            padding: 24px;
                        }

                        .panel-heading {
                            font-size: 1.1rem;
                            font-weight: 600;
                            border-bottom: 1px solid #e5e7eb;
                            padding-bottom: 12px;
                            margin-bottom: 16px;
                        }

                        /* Table */
                        .table-container {
                            overflow-x: auto;
                        }

                        table {
                            width: 100%;
                            border-collapse: collapse;
                        }

                        th,
                        td {
                            padding: 12px;
                            text-align: left;
                            border-bottom: 1px solid #e5e7eb;
                        }

                        th {
                            background: #f9fafb;
                            font-weight: 600;
                            color: #4b5563;
                            font-size: 0.85rem;
                            text-transform: uppercase;
                        }

                        td {
                            color: #111827;
                            font-size: 0.95rem;
                            vertical-align: middle;
                        }

                        .role-badge {
                            display: inline-block;
                            padding: 4px 10px;
                            border-radius: 6px;
                            font-size: 0.85rem;
                            font-weight: 600;
                            background: #e0e7ff;
                            color: #4338ca;
                        }

                        .emp-count {
                            background: #f3f4f6;
                            color: #4b5563;
                            padding: 2px 8px;
                            border-radius: 20px;
                            font-size: 0.8rem;
                            font-weight: 600;
                        }

                        /* Form */
                        .form-group {
                            margin-bottom: 16px;
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
                            padding: 10px;
                            border: 1px solid #d1d5db;
                            border-radius: 6px;
                            font-family: inherit;
                            font-size: 0.9rem;
                            outline: none;
                        }

                        .form-control:focus {
                            border-color: #4f46e5;
                        }

                        .btn {
                            padding: 8px 16px;
                            border-radius: 6px;
                            font-weight: 500;
                            cursor: pointer;
                            border: none;
                            transition: all 0.2s;
                            font-size: 0.9rem;
                            display: inline-flex;
                            align-items: center;
                            justify-content: center;
                            gap: 6px;
                        }

                        .btn-primary {
                            background: #4f46e5;
                            color: white;
                            width: 100%;
                        }

                        .btn-primary:hover {
                            background: #4338ca;
                        }

                        .btn-icon {
                            width: 32px;
                            height: 32px;
                            padding: 0;
                            border-radius: 6px;
                            display: inline-flex;
                            color: white;
                            text-decoration: none;
                        }

                        .edit-btn {
                            background: #3b82f6;
                        }

                        .delete-btn {
                            background: #ef4444;
                        }

                        /* Modal */
                        .modal {
                            display: none;
                            position: fixed;
                            z-index: 1000;
                            left: 0;
                            top: 0;
                            width: 100%;
                            height: 100%;
                            background-color: rgba(0, 0, 0, 0.5);
                            align-items: center;
                            justify-content: center;
                        }

                        .modal-content {
                            background: #fff;
                            padding: 24px;
                            border-radius: 12px;
                            width: 100%;
                            max-width: 400px;
                            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                        }

                        .modal-close {
                            float: right;
                            cursor: pointer;
                            font-size: 1.2rem;
                            color: #9ca3af;
                        }
                    </style>
                </head>

                <body>
                    <div class="container">
                        <!-- Top Bar -->
                        <div class="top-bar">
                            <a href="<%= request.getContextPath() %>/admin/dashboard" class="back-btn"><i
                                    class="fas fa-arrow-left"></i> Về Dashboard</a>
                            <h1 class="page-title">Quản lý Vai trò Hệ thống</h1>
                            <div style="width: 140px;"></div>
                        </div>

                        <% if (request.getAttribute("errorMessage") !=null) { %>
                            <div class="alert alert-error">
                                <i class="fas fa-exclamation-circle"></i>
                                <%= request.getAttribute("errorMessage") %>
                            </div>
                            <% } %>

                                <% String keyword=(String) request.getAttribute("keyword");
                                    String pageSize=(String) request.getAttribute("pageSize");
                                    Integer currentPage=(Integer) request.getAttribute("currentPage");
                                    Integer totalPages=(Integer) request.getAttribute("totalPages");
                                    Integer totalItems=(Integer) request.getAttribute("totalItems");
                                    if(pageSize==null) pageSize="10";
                                    if(currentPage==null) currentPage=1;
                                    if(totalPages==null) totalPages=1;
                                    if(totalItems==null) totalItems=0;
                                    String encodedKeyword=keyword !=null ? java.net.URLEncoder.encode(keyword,
                                    java.nio.charset.StandardCharsets.UTF_8) : ""; %>

                                    <div class="content-panel" style="margin-bottom:16px;">
                                        <form action="<%= request.getContextPath() %>/admin/roles" method="GET"
                                            style="display:grid; grid-template-columns:2fr 1fr auto auto; gap:10px; align-items:end;">
                                            <div>
                                                <label class="form-label">Từ khóa</label>
                                                <input type="text" name="keyword" class="form-control"
                                                    placeholder="Mã vai trò, mô tả..."
                                                    value="<%= keyword != null ? keyword : "" %>">
                                            </div>
                                            <div>
                                                <label class="form-label">Số dòng</label>
                                                <select name="pageSize" class="form-control">
                                                    <option value="5" <%= "5".equals(pageSize) ? "selected" : ""
                                                        %>>5</option>
                                                    <option value="10" <%= "10".equals(pageSize) ? "selected" : ""
                                                        %>>10</option>
                                                    <option value="20" <%= "20".equals(pageSize) ? "selected" : ""
                                                        %>>20</option>
                                                </select>
                                            </div>
                                            <button type="submit" class="btn btn-primary" style="width:auto;"><i
                                                    class="fas fa-search"></i> Lọc</button>
                                            <a href="<%= request.getContextPath() %>/admin/roles" class="btn"
                                                style="background:#f3f4f6; color:#374151; text-decoration:none;">Xóa</a>
                                        </form>
                                    </div>

                                <div class="main-layout">
                                    <!-- Left: Table -->
                                    <div class="content-panel table-container">
                                        <div class="panel-heading">Danh sách vai trò</div>
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Mã Vai Trò</th>
                                                    <th>Mô tả</th>
                                                    <th>Số NV</th>
                                                    <th width="90">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% List<Role> roles = (List<Role>) request.getAttribute("roleList");
                                                        if(roles != null && !roles.isEmpty()) {
                                                        for(Role r : roles) {
                                                        %>
                                                        <tr>
                                                            <td>
                                                                <%= r.getRoleId() %>
                                                            </td>
                                                            <td><span class="role-badge">
                                                                    <%= r.getRoleName() %>
                                                                </span></td>
                                                            <td>
                                                                <%= r.getDescription() !=null ? r.getDescription() : ""
                                                                    %>
                                                            </td>
                                                            <td><span class="emp-count">
                                                                    <%= r.getEmployeeCount() %>
                                                                </span></td>
                                                            <td>
                                                                <div style="display:flex; gap:6px;">
                                                                    <button type="button" class="btn btn-icon edit-btn"
                                                                        onclick="openEditModal(<%= r.getRoleId() %>, '<%= r.getRoleName() %>', '<%= r.getDescription()!=null ? r.getDescription().replace("'", "\\'") : "" %>')"><i
                                                                            class="fas fa-edit"></i></button>
                                                                    <form
                                                                        action="<%= request.getContextPath() %>/admin/roles"
                                                                        method="POST" style="display:inline;"
                                                                        onsubmit="return confirm('Bạn có chắc muốn xóa vai trò này?');">
                                                                        <input type="hidden" name="action"
                                                                            value="delete">
                                                                        <input type="hidden" name="roleId"
                                                                            value="<%= r.getRoleId() %>">
                                                                        <button type="submit"
                                                                            class="btn btn-icon delete-btn"><i
                                                                                class="fas fa-trash"></i></button>
                                                                    </form>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                        <% } } else { %>
                                                            <tr>
                                                                <td colspan="5"
                                                                    style="text-align:center; padding: 20px;">Không có
                                                                    dữ liệu</td>
                                                            </tr>
                                                            <% } %>
                                            </tbody>
                                        </table>

                                        <div
                                            style="display:flex; justify-content:space-between; align-items:center; margin-top:12px;">
                                            <small style="color:#6b7280;">Tổng: <%= totalItems %> vai trò</small>
                                            <% if (totalPages > 1) { %>
                                                <div style="display:flex; gap:6px; align-items:center;">
                                                    <a class="btn"
                                                        style="background:#f3f4f6; color:#111827; text-decoration:none; padding:6px 10px;"
                                                        href="<%= request.getContextPath() %>/admin/roles?page=<%= currentPage - 1 %>&keyword=<%= encodedKeyword %>&pageSize=<%= pageSize %>">
                                                        «
                                                    </a>
                                                    <% for (int i=1; i <=totalPages; i++) { %>
                                                        <a class="btn"
                                                            style="text-decoration:none; padding:6px 10px; <%= i == currentPage ? "background:#4f46e5;color:#fff;" : "background:#f3f4f6;color:#111827;" %>"
                                                            href="<%= request.getContextPath() %>/admin/roles?page=<%= i %>&keyword=<%= encodedKeyword %>&pageSize=<%= pageSize %>">
                                                            <%= i %>
                                                        </a>
                                                        <% } %>
                                                            <a class="btn"
                                                                style="background:#f3f4f6; color:#111827; text-decoration:none; padding:6px 10px;"
                                                                href="<%= request.getContextPath() %>/admin/roles?page=<%= currentPage + 1 %>&keyword=<%= encodedKeyword %>&pageSize=<%= pageSize %>">
                                                                »
                                                            </a>
                                                </div>
                                                <% } %>
                                        </div>
                                    </div>

                                    <!-- Right: Add Form -->
                                    <div class="content-panel">
                                        <div class="panel-heading">Thêm vai trò mới</div>
                                        <form action="<%= request.getContextPath() %>/admin/roles" method="POST">
                                            <input type="hidden" name="action" value="add">
                                            <div class="form-group">
                                                <label class="form-label">Tên mã vai trò (VD: LIBRARIAN) <span
                                                        style="color:red">*</span></label>
                                                <input type="text" name="roleName" class="form-control" required
                                                    style="text-transform: uppercase;">
                                            </div>
                                            <div class="form-group">
                                                <label class="form-label">Mô tả chi tiết</label>
                                                <textarea name="description" class="form-control" rows="3"></textarea>
                                            </div>
                                            <button type="submit" class="btn btn-primary"><i class="fas fa-plus"></i>
                                                Tạo mới</button>
                                        </form>
                                    </div>
                                </div>
                    </div>

                    <!-- Edit Modal -->
                    <div id="editModal" class="modal">
                        <div class="modal-content">
                            <span class="modal-close" onclick="closeEditModal()">&times;</span>
                            <div class="panel-heading" style="margin-top:0;">Chỉnh sửa vai trò</div>
                            <form action="<%= request.getContextPath() %>/admin/roles" method="POST">
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="roleId" id="editRoleId">
                                <div class="form-group">
                                    <label class="form-label">Tên mã vai trò <span style="color:red">*</span></label>
                                    <input type="text" name="roleName" id="editRoleName" class="form-control" required
                                        style="text-transform: uppercase;">
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Mô tả</label>
                                    <textarea name="description" id="editRoleDesc" class="form-control"
                                        rows="3"></textarea>
                                </div>
                                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Cập
                                    nhật</button>
                            </form>
                        </div>
                    </div>

                    <script>
                        function openEditModal(id, name, desc) {
                            document.getElementById('editRoleId').value = id;
                            document.getElementById('editRoleName').value = name;
                            document.getElementById('editRoleDesc').value = desc;
                            document.getElementById('editModal').style.display = 'flex';
                        }
                        function closeEditModal() {
                            document.getElementById('editModal').style.display = 'none';
                        }
                        window.onclick = function (event) {
                            if (event.target == document.getElementById('editModal')) {
                                closeEditModal();
                            }
                        }
                    </script>
                </body>

                </html>
