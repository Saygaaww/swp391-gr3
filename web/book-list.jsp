<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Sách - Admin</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f7fa;
            min-height: 100vh;
        }
        
        /* Header */
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 40px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header-left h1 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .header-left p {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .header-right {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        
        .user-info {
            text-align: right;
        }
        
        .user-info strong {
            display: block;
            font-size: 16px;
        }
        
        .user-info small {
            font-size: 12px;
            opacity: 0.8;
        }
        
        .btn-logout {
            padding: 10px 20px;
            background: rgba(255,255,255,0.2);
            border: 2px solid white;
            color: white;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-logout:hover {
            background: white;
            color: #667eea;
        }
        
        /* Container */
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        /* Toolbar */
        .toolbar {
            background: white;
            padding: 25px;
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
            max-width: 500px;
        }
        
        .search-box input {
            flex: 1;
            padding: 12px 18px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .search-box input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .btn {
            padding: 12px 24px;
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-success {
            background: #28a745;
            color: white;
        }
        
        .btn-success:hover {
            background: #218838;
            transform: translateY(-2px);
        }
        
        .btn-warning {
            background: #ffc107;
            color: #212529;
            padding: 8px 16px;
            font-size: 13px;
        }
        
        .btn-warning:hover {
            background: #e0a800;
        }
        
        .btn-danger {
            background: #dc3545;
            color: white;
            padding: 8px 16px;
            font-size: 13px;
        }
        
        .btn-danger:hover {
            background: #c82333;
        }
        
        .btn-info {
            background: #17a2b8;
            color: white;
            padding: 8px 16px;
            font-size: 13px;
        }
        
        .btn-info:hover {
            background: #138496;
        }
        
        /* Stats Card */
        .stats-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .stat-item {
            text-align: center;
            padding: 0 30px;
        }
        
        .stat-item h3 {
            font-size: 36px;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-item p {
            font-size: 14px;
            color: #666;
        }
        
        /* Table Container */
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        th {
            padding: 16px;
            text-align: left;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        tbody tr {
            border-bottom: 1px solid #f0f0f0;
            transition: all 0.3s;
        }
        
        tbody tr:hover {
            background: #f8f9fa;
            transform: scale(1.01);
        }
        
        td {
            padding: 16px;
            font-size: 14px;
            color: #333;
        }
        
        .book-title {
            font-weight: 600;
            color: #667eea;
            max-width: 250px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .book-cover {
            width: 50px;
            height: 70px;
            object-fit: cover;
            border-radius: 4px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
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
        
        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }
        
        .price {
            font-weight: 600;
            color: #28a745;
        }
        
        .actions {
            display: flex;
            gap: 8px;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        
        .empty-state img {
            width: 200px;
            opacity: 0.6;
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            font-size: 24px;
            color: #333;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            font-size: 16px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-left">
            <h1>📚 Quản lý Sách</h1>
            <p>Digital Library Management System</p>
        </div>
        <div class="header-right">
            <div class="user-info">
                <strong>👤 ${currentEmployee.fullName}</strong>
                <small>${currentEmployee.roleName}</small>
            </div>
            <a href="${pageContext.request.contextPath}/mock-logout" class="btn-logout">
                🚪 Logout
            </a>
        </div>
    </div>
    
    <!-- Main Container -->
    <div class="container">
        
        <!-- Stats Card -->
        <div class="stats-card">
            <div class="stat-item">
                <h3>${totalBooks}</h3>
                <p>📖 Tổng số sách</p>
            </div>
            <div class="stat-item">
                <h3>
                    <c:choose>
                        <c:when test="${not empty keyword}">${totalBooks}</c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </h3>
                <p>🔍 Kết quả tìm kiếm</p>
            </div>
            <div class="stat-item">
                <h3>Active</h3>
                <p>✅ Trạng thái hệ thống</p>
            </div>
        </div>
        
        <!-- Toolbar -->
        <div class="toolbar">
            <form action="${pageContext.request.contextPath}/books-list" method="post" class="search-box">
                <input 
                    type="text" 
                    name="keyword" 
                    placeholder="🔍 Tìm kiếm sách theo tên hoặc tác giả..." 
                    value="${keyword}"
                />
                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
            </form>
            
            <div style="display: flex; gap: 10px;">
                <a href="${pageContext.request.contextPath}/books-list" class="btn btn-info">
                    🔄 Làm mới
                </a>
                <a href="${pageContext.request.contextPath}/admin/book-add" class="btn btn-success">
                    ➕ Thêm sách mới
                </a>
            </div>
        </div>
        
        <!-- Table -->
        <div class="table-container">
            <c:choose>
                <c:when test="${empty bookList}">
                    <div class="empty-state">
                        <h3>📭 Không có sách nào</h3>
                        <p>
                            <c:choose>
                                <c:when test="${not empty keyword}">
                                    Không tìm thấy sách với từ khóa "<strong>${keyword}</strong>"
                                </c:when>
                                <c:otherwise>
                                    Hệ thống chưa có sách. Hãy thêm sách mới!
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <a href="${pageContext.request.contextPath}/admin/book-add" class="btn btn-success">
                            ➕ Thêm sách đầu tiên
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Ảnh bìa</th>
                                <th>Tên sách</th>
                                <th>Tác giả</th>
                                <th>Danh mục</th>
                                <th>Giá</th>
                                <th>Tổng trang</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="book" items="${bookList}">
                                <tr>
                                    <td>#${book.bookId}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty book.coverUrl}">
                                                <img src="${book.coverUrl}" alt="${book.title}" class="book-cover" />
                                            </c:when>
                                            <c:otherwise>
                                                <div style="width:50px;height:70px;background:#ddd;border-radius:4px;display:flex;align-items:center;justify-content:center;font-size:24px;">
                                                    📖
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="book-title" title="${book.title}">
                                            ${book.title}
                                        </div>
                                        <c:if test="${not empty book.summary}">
                                            <small style="color:#888;display:block;margin-top:5px;">
                                                ${book.summary.length() > 50 ? book.summary.substring(0,50).concat('...') : book.summary}
                                            </small>
                                        </c:if>
                                    </td>
                                    <td>${book.authorName != null ? book.authorName : '-'}</td>
                                    <td>${book.categoryName != null ? book.categoryName : '-'}</td>
                                    <td class="price">
                                        <c:choose>
                                            <c:when test="${book.price != null}">
                                                <fmt:formatNumber value="${book.price}" type="currency" currencySymbol="${book.currency != null ? book.currency : 'VND'}" />
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${book.totalPages > 0 ? book.totalPages : '-'}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${book.status == 'active'}">
                                                <span class="status-badge status-active">✓ Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-inactive">✗ Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="${pageContext.request.contextPath}/admin/book-edit?id=${book.bookId}" 
                                               class="btn btn-warning" 
                                               title="Sửa">
                                                ✏️ Sửa
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/book-delete?id=${book.bookId}" 
                                               class="btn btn-danger" 
                                               onclick="return confirm('Bạn có chắc muốn xóa sách này?')"
                                               title="Xóa">
                                                🗑️ Xóa
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
        
    </div>
</body>
</html>