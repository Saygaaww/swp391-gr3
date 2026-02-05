<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Độc giả - Admin</title>
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
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header h1 {
            font-size: 24px;
        }
        
        .header-right {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        
        .btn-logout {
            padding: 10px 20px;
            background: rgba(255,255,255,0.2);
            border: 2px solid white;
            color: white;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
        }
        
        .btn-logout:hover {
            background: white;
            color: #11998e;
        }
        
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .stats-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 20px;
        }
        
        .stat-item {
            text-align: center;
            padding: 10px 30px;
        }
        
        .stat-item h3 {
            font-size: 32px;
            color: #11998e;
        }
        
        .stat-item p {
            color: #666;
        }
        
        .toolbar {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .search-box {
            display: flex;
            gap: 10px;
            flex: 1;
            max-width: 400px;
        }
        
        .search-box input {
            flex: 1;
            padding: 10px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
        }
        
        .search-box input:focus {
            outline: none;
            border-color: #11998e;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: #11998e;
            color: white;
        }
        
        .btn-primary:hover {
            background: #0d7a6f;
        }
        
        .btn-success {
            background: #28a745;
            color: white;
        }
        
        .btn-success:hover {
            background: #218838;
        }
        
        .btn-warning {
            background: #ffc107;
            color: #212529;
            padding: 6px 12px;
            font-size: 12px;
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
            padding: 6px 12px;
            font-size: 12px;
        }
        
        .btn-info {
            background: #17a2b8;
            color: white;
        }
        
        .table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        thead {
            background: #11998e;
            color: white;
        }
        
        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
        }
        
        td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        tbody tr:hover {
            background: #f8f9fa;
        }
        
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .status-active {
            background: #d4edda;
            color: #155724;
        }
        
        .status-blocked {
            background: #f8d7da;
            color: #721c24;
        }
        
        .status-inactive {
            background: #fff3cd;
            color: #856404;
        }
        
        .actions {
            display: flex;
            gap: 5px;
        }
        
        .pagination-container {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .pagination {
            display: flex;
            gap: 5px;
        }
        
        .pagination a, .pagination span {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            text-decoration: none;
            color: #333;
        }
        
        .pagination a:hover {
            background: #11998e;
            color: white;
            border-color: #11998e;
        }
        
        .pagination .active {
            background: #11998e;
            color: white;
            border-color: #11998e;
        }
        
        .pagination .disabled {
            background: #e9ecef;
            color: #adb5bd;
            cursor: not-allowed;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px;
            color: #666;
        }
        
        .empty-state h3 {
            margin-bottom: 10px;
            color: #333;
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
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
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
    </style>
</head>
<body>
    <div class="header">
        <div>
            <h1>Quản lý Độc giả</h1>
            <small>Reader Management</small>
        </div>
        <div class="header-right">
            <span>👤 ${currentEmployee.fullName}</span>
            <a href="${pageContext.request.contextPath}/mock-logout" class="btn-logout">Đăng xuất</a>
        </div>
    </div>
    
    <div class="container">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">← Quay lại Dashboard</a>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        
        <c:if test="${param.success == 'added'}">
            <div class="alert alert-success">Thêm độc giả thành công!</div>
        </c:if>
        
        <c:if test="${param.success == 'updated'}">
            <div class="alert alert-success">Cập nhật độc giả thành công!</div>
        </c:if>
        
        <div class="stats-card">
            <div class="stat-item">
                <h3>${totalReaders}</h3>
                <p>Tổng độc giả</p>
            </div>
            <div class="stat-item">
                <h3>${activeCount}</h3>
                <p>Đang hoạt động</p>
            </div>
            <div class="stat-item">
                <h3>${blockedCount}</h3>
                <p>Bị khóa</p>
            </div>
            <div class="stat-item">
                <h3>${currentPage}/${totalPages}</h3>
                <p>Trang hiện tại</p>
            </div>
        </div>
        
        <div class="toolbar">
            <form action="${pageContext.request.contextPath}/admin/readers" method="post" class="search-box">
                <input type="text" name="keyword" placeholder="🔍 Tìm theo tên, email hoặc SĐT..." value="${keyword}">
                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
            </form>
            
            <div style="display: flex; gap: 10px;">
                <a href="${pageContext.request.contextPath}/admin/readers" class="btn btn-info">Làm mới</a>
                <a href="${pageContext.request.contextPath}/admin/reader-form" class="btn btn-success">Thêm độc giả</a>
            </div>
        </div>
        
        <c:if test="${not empty keyword}">
            <div class="alert" style="background: #e7f3ff; color: #004085; border: 1px solid #b8daff;">
                🔍 Kết quả tìm kiếm cho: "<strong>${keyword}</strong>" - Tìm thấy <strong>${totalReaders}</strong> kết quả
            </div>
        </c:if>
        
        <div class="table-container">
            <c:choose>
                <c:when test="${empty readerList}">
                    <div class="empty-state">
                        <h3>📭 Không có độc giả nào</h3>
                        <p>
                            <c:choose>
                                <c:when test="${not empty keyword}">
                                    Không tìm thấy độc giả với từ khóa "${keyword}"
                                </c:when>
                                <c:otherwise>
                                    Hệ thống chưa có độc giả. Hãy thêm độc giả mới!
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Số điện thoại</th>
                                <th>Địa chỉ</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="reader" items="${readerList}">
                                <tr>
                                    <td><strong>#${reader.readerId}</strong></td>
                                    <td>${reader.fullName}</td>
                                    <td>${reader.email}</td>
                                    <td>${not empty reader.phone ? reader.phone : '-'}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty reader.address}">
                                                <span title="${reader.address}">
                                                    ${reader.address.length() > 30 ? reader.address.substring(0, 30).concat('...') : reader.address}
                                                </span>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${reader.status == 'active'}">
                                                <span class="status-badge status-active">Active</span>
                                            </c:when>
                                            <c:when test="${reader.status == 'blocked'}">
                                                <span class="status-badge status-blocked">Blocked</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-inactive">${reader.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${reader.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="${pageContext.request.contextPath}/admin/reader-form?id=${reader.readerId}" 
                                               class="btn btn-warning" title="Sửa">✏️</a>
                                            
                                            <c:choose>
                                                <c:when test="${reader.status == 'blocked'}">
                                                    <a href="${pageContext.request.contextPath}/admin/readers?action=unblock&id=${reader.readerId}" 
                                                       class="btn btn-success" 
                                                       onclick="return confirm('Mở khóa độc giả này?')"
                                                       title="Mở khóa">🔓</a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/admin/readers?action=block&id=${reader.readerId}" 
                                                       class="btn btn-danger" 
                                                       onclick="return confirm('Khóa độc giả này?')"
                                                       title="Khóa">🔒</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
        
        <c:if test="${totalPages > 1}">
            <div class="pagination-container">
                <div>
                    Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                    | Tổng: <strong>${totalReaders}</strong> độc giả
                </div>
                
                <div class="pagination">
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/admin/readers?page=${currentPage - 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}">← Trước</a>
                        </c:when>
                        <c:otherwise>
                            <span class="disabled">← Trước</span>
                        </c:otherwise>
                    </c:choose>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <span class="active">${i}</span>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/admin/readers?page=${i}${not empty keyword ? '&keyword='.concat(keyword) : ''}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/admin/readers?page=${currentPage + 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}">Sau →</a>
                        </c:when>
                        <c:otherwise>
                            <span class="disabled">Sau →</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>
    </div>
</body>
</html>