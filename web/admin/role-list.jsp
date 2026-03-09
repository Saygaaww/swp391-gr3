<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quan ly Vai tro - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f4f5f7; min-height: 100vh; }
        .header { background: #1a1a2e; color: #fff; padding: 0 40px; height: 64px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 12px rgba(0,0,0,0.3); }
        .header-left { display: flex; align-items: center; gap: 24px; }
        .header h1 { font-size: 18px; font-weight: 700; }
        .header h1 i { margin-right: 8px; }
        .header-nav { display: flex; gap: 4px; }
        .header-nav a { color: #ccc; text-decoration: none; padding: 8px 14px; border-radius: 6px; font-size: 13px; font-weight: 500; transition: all 0.2s; }
        .header-nav a:hover { color: #fff; background: rgba(255,255,255,0.1); }
        .header-nav a.active { color: #fff; background: rgba(255,255,255,0.12); }
        .header-right { display: flex; align-items: center; gap: 16px; }
        .user-badge { display: flex; align-items: center; gap: 8px; color: #ccc; font-size: 13px; }
        .user-badge strong { color: #fff; }
        .role-tag { background: #e74c3c; color: #fff; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; text-transform: uppercase; }
        .btn-logout { padding: 7px 14px; border: 1px solid rgba(255,255,255,0.25); color: #fff; border-radius: 6px; text-decoration: none; font-size: 13px; transition: all 0.2s; }
        .btn-logout:hover { background: rgba(255,255,255,0.1); }
        .container { max-width: 1300px; margin: 24px auto; padding: 0 20px; }
        .breadcrumb { display: flex; align-items: center; gap: 8px; margin-bottom: 20px; font-size: 13px; color: #888; }
        .breadcrumb a { color: #1a1a2e; text-decoration: none; font-weight: 500; }
        .breadcrumb a:hover { text-decoration: underline; }
        .alert { padding: 12px 18px; border-radius: 8px; margin-bottom: 16px; font-size: 13px; }
        .alert-danger { background: #fff0f0; color: #e74c3c; border: 1px solid #fdd; }
        .alert-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .two-col { display: grid; grid-template-columns: 380px 1fr; gap: 24px; align-items: start; }
        .card { background: #fff; border-radius: 12px; border: 1px solid #eee; box-shadow: 0 2px 8px rgba(0,0,0,0.04); }
        .card-header { background: #1a1a2e; color: #fff; padding: 16px 22px; border-radius: 12px 12px 0 0; font-size: 15px; font-weight: 700; display: flex; align-items: center; gap: 8px; }
        .card-body { padding: 22px; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 12px; font-weight: 600; color: #555; text-transform: uppercase; margin-bottom: 6px; }
        .form-group input, .form-group textarea { width: 100%; padding: 10px 14px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; font-family: inherit; transition: border-color 0.2s; }
        .form-group input:focus, .form-group textarea:focus { outline: none; border-color: #1a1a2e; box-shadow: 0 0 0 3px rgba(26,26,46,0.06); }
        .form-group textarea { resize: vertical; min-height: 80px; }
        .btn { padding: 10px 18px; border: none; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; transition: all 0.2s; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; }
        .btn:hover { transform: translateY(-1px); }
        .btn-dark { background: #1a1a2e; color: #fff; } .btn-dark:hover { background: #2d2d4e; }
        .btn-green { background: #16a34a; color: #fff; width: 100%; justify-content: center; } .btn-green:hover { background: #15803d; }
        .btn-outline { background: #fff; color: #555; border: 1px solid #ddd; } .btn-outline:hover { background: #f8f8f8; }
        .btn-amber { background: #fef3c7; color: #92400e; border: 1px solid #fde68a; } .btn-amber:hover { background: #fde68a; }
        .btn-red { background: #fff0f0; color: #e74c3c; border: 1px solid #fdd; } .btn-red:hover { background: #fde0e0; }
        .btn-sm { padding: 6px 12px; font-size: 12px; }
        .role-list { display: flex; flex-direction: column; gap: 12px; }
        .role-item { background: #fff; border: 1px solid #eee; border-radius: 10px; padding: 18px 22px; display: flex; align-items: center; justify-content: space-between; transition: box-shadow 0.2s; }
        .role-item:hover { box-shadow: 0 3px 12px rgba(0,0,0,0.06); }
        .role-left { display: flex; align-items: center; gap: 14px; }
        .role-icon { width: 44px; height: 44px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 18px; }
        .ri-admin { background: #fce4ec; color: #c62828; }
        .ri-librarian { background: #e0f2fe; color: #0369a1; }
        .ri-seller { background: #dcfce7; color: #166534; }
        .ri-user { background: #eef2ff; color: #4f46e5; }
        .ri-default { background: #f0f0f0; color: #555; }
        .role-meta h3 { font-size: 16px; font-weight: 700; color: #1a1a2e; margin-bottom: 2px; }
        .role-meta p { font-size: 12px; color: #888; }
        .role-meta .emp-count { font-size: 11px; color: #4f46e5; font-weight: 600; margin-top: 4px; }
        .role-right { display: flex; gap: 6px; }
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center; }
        .modal-overlay.active { display: flex; }
        .modal { background: #fff; border-radius: 12px; width: 100%; max-width: 480px; box-shadow: 0 20px 60px rgba(0,0,0,0.2); }
        .modal-header { background: #1a1a2e; color: #fff; padding: 16px 22px; border-radius: 12px 12px 0 0; display: flex; justify-content: space-between; align-items: center; }
        .modal-header h3 { font-size: 15px; font-weight: 700; }
        .modal-close { background: none; border: none; color: #ccc; font-size: 18px; cursor: pointer; } .modal-close:hover { color: #fff; }
        .modal-body { padding: 22px; }
        .modal-footer { padding: 16px 22px; border-top: 1px solid #eee; display: flex; justify-content: flex-end; gap: 10px; }
        @media (max-width: 992px) { .two-col { grid-template-columns: 1fr; } .header-nav { display: none; } }
        @media (max-width: 768px) { .header { padding: 0 16px; } }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-left">
            <h1><i class="fas fa-key"></i> Quan ly Vai tro</h1>
            <nav class="header-nav">
                <a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chu</a>
                <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="${pageContext.request.contextPath}/books-list"><i class="fas fa-book"></i> Sach</a>
                <a href="${pageContext.request.contextPath}/admin/readers"><i class="fas fa-users"></i> Doc gia</a>
                <a href="${pageContext.request.contextPath}/admin/employees"><i class="fas fa-user-tie"></i> Nhan vien</a>
                <a href="${pageContext.request.contextPath}/admin/borrow-list"><i class="fas fa-clipboard-list"></i> Muon tra</a>
                <a href="${pageContext.request.contextPath}/admin/roles" class="active"><i class="fas fa-key"></i> Vai tro</a>
            </nav>
        </div>
        <div class="header-right">
            <div class="user-badge"><i class="fas fa-user-circle" style="font-size:20px;"></i> <strong>${currentEmployee.fullName}</strong> <span class="role-tag">${currentEmployee.roleName}</span></div>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout"><i class="fas fa-sign-out-alt"></i> Dang xuat</a>
        </div>
    </div>
    <div class="container">
        <div class="breadcrumb"><a href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Trang chu</a><span>/</span><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a><span>/</span><span style="color:#555;font-weight:600;">Quan ly Vai tro</span></div>
        <c:if test="${not empty error}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>
        <c:if test="${not empty success}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div></c:if>
        <div class="two-col">
            <div class="card">
                <div class="card-header"><i class="fas fa-plus-circle"></i> Them vai tro moi</div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/roles" method="post">
                        <input type="hidden" name="action" value="add">
                        <div class="form-group"><label>Ten vai tro</label><input type="text" name="roleName" placeholder="Nhap ten vai tro..." required></div>
                        <div class="form-group"><label>Mo ta</label><textarea name="description" placeholder="Mo ta vai tro..."></textarea></div>
                        <button type="submit" class="btn btn-green"><i class="fas fa-plus"></i> Them vai tro</button>
                    </form>
                </div>
            </div>
            <div>
                <div class="card" style="margin-bottom:16px;">
                    <div class="card-header"><i class="fas fa-list"></i> Danh sach vai tro (${roleList.size()})</div>
                </div>
                <div class="role-list">
                    <c:forEach var="role" items="${roleList}">
                        <div class="role-item">
                            <div class="role-left">
                                <div class="role-icon <c:choose><c:when test="${role.roleName == 'ADMIN'}">ri-admin</c:when><c:when test="${role.roleName == 'LIBRARIAN'}">ri-librarian</c:when><c:when test="${role.roleName == 'SELLER'}">ri-seller</c:when><c:when test="${role.roleName == 'USER'}">ri-user</c:when><c:otherwise>ri-default</c:otherwise></c:choose>">
                                    <c:choose><c:when test="${role.roleName == 'ADMIN'}"><i class="fas fa-crown"></i></c:when><c:when test="${role.roleName == 'LIBRARIAN'}"><i class="fas fa-book-reader"></i></c:when><c:when test="${role.roleName == 'SELLER'}"><i class="fas fa-cash-register"></i></c:when><c:when test="${role.roleName == 'USER'}"><i class="fas fa-user"></i></c:when><c:otherwise><i class="fas fa-tag"></i></c:otherwise></c:choose>
                                </div>
                                <div class="role-meta">
                                    <h3>${role.roleName}</h3>
                                    <p>${role.description}</p>
                                    <div class="emp-count"><i class="fas fa-users"></i> ${role.employeeCount} nhan vien</div>
                                </div>
                            </div>
                            <div class="role-right">
                                <button onclick="openEditModal(${role.roleId}, '${role.roleName}', '${role.description}')" class="btn btn-amber btn-sm"><i class="fas fa-pen"></i> Sua</button>
                                <c:if test="${role.employeeCount == 0}">
                                    <form action="${pageContext.request.contextPath}/admin/roles" method="post" style="display:inline;"><input type="hidden" name="action" value="delete"><input type="hidden" name="roleId" value="${role.roleId}"><button type="submit" class="btn btn-red btn-sm" onclick="return confirm('Xoa vai tro nay?')"><i class="fas fa-trash"></i> Xoa</button></form>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
    <div class="modal-overlay" id="editModal">
        <div class="modal">
            <div class="modal-header"><h3><i class="fas fa-pen"></i> Chinh sua vai tro</h3><button class="modal-close" onclick="closeEditModal()"><i class="fas fa-times"></i></button></div>
            <form action="${pageContext.request.contextPath}/admin/roles" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="roleId" id="editRoleId">
                <div class="modal-body">
                    <div class="form-group"><label>Ten vai tro</label><input type="text" name="roleName" id="editRoleName" required></div>
                    <div class="form-group"><label>Mo ta</label><textarea name="description" id="editDescription"></textarea></div>
                </div>
                <div class="modal-footer"><button type="button" class="btn btn-outline" onclick="closeEditModal()"><i class="fas fa-times"></i> Huy</button><button type="submit" class="btn btn-dark"><i class="fas fa-save"></i> Luu thay doi</button></div>
            </form>
        </div>
    </div>
    <script>
        function openEditModal(id,name,desc){document.getElementById('editRoleId').value=id;document.getElementById('editRoleName').value=name;document.getElementById('editDescription').value=desc||'';document.getElementById('editModal').classList.add('active');}
        function closeEditModal(){document.getElementById('editModal').classList.remove('active');}
        document.getElementById('editModal').addEventListener('click',function(e){if(e.target===this)closeEditModal();});
    </script>
</body>
</html>