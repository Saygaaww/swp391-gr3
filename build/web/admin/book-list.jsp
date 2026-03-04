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
                background: #f0f0f0;
                min-height: 100vh;
            }

            .header {
                background: #5a5a5a;
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
                color: #5a5a5a;
            }

            /* ========== CONTAINER ========== */
            .container {
                max-width: 1400px;
                margin: 30px auto;
                padding: 0 20px;
            }

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
                border-color: #888888;
                box-shadow: 0 0 0 3px rgba(136, 136, 136, 0.1);
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
                background: #888888;
                color: white;
                box-shadow: 0 4px 15px rgba(136, 136, 136, 0.3);
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(136, 136, 136, 0.4);
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

            /* ========== STATS CARD ========== */
            .stats-card {
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.08);
                margin-bottom: 20px;
                display: flex;
                justify-content: space-around;
                align-items: center;
                flex-wrap: wrap;
                gap: 20px;
            }

            .stat-item {
                text-align: center;
                padding: 10px 30px;
            }

            .stat-item h3 {
                font-size: 32px;
                color: #5a5a5a;
                margin-bottom: 5px;
            }

            .stat-item p {
                font-size: 14px;
                color: #666;
            }

            /* ========== TABLE ========== */
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
                background: #5a5a5a;
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

            td {
                padding: 15px 16px;
                border-bottom: 1px solid #f0f0f0;
                vertical-align: middle;
            }

            tbody tr:hover {
                background: #f8f9fa;
            }

            .book-title {
                font-weight: 600;
                color: #333;
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

            .book-cover-placeholder {
                width: 50px;
                height: 70px;
                background: #ddd;
                border-radius: 4px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
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

            /* ========== EMPTY STATE ========== */
            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #666;
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

            /* ========== PAGINATION ========== */
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

            .pagination-info {
                color: #666;
                font-size: 14px;
            }

            .pagination-info strong {
                color: #333;
            }

            .pagination {
                display: flex;
                gap: 8px;
                align-items: center;
                flex-wrap: wrap;
            }

            .pagination a,
            .pagination span {
                padding: 10px 16px;
                border-radius: 8px;
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
                transition: all 0.3s;
            }

            .pagination a {
                background: #f0f0f0;
                color: #333;
            }

            .pagination a:hover {
                background: #5a5a5a;
                color: white;
            }

            .pagination .active {
                background: #5a5a5a;
                color: white;
            }

            .pagination .disabled {
                background: #e9ecef;
                color: #adb5bd;
                cursor: not-allowed;
            }

            /* ========== RESPONSIVE ========== */
            @media (max-width: 992px) {
                .header {
                    flex-direction: column;
                    gap: 15px;
                    text-align: center;
                }

                .header-right {
                    flex-direction: column;
                }

                .user-info {
                    text-align: center;
                }
            }

            @media (max-width: 768px) {
                .toolbar {
                    flex-direction: column;
                }

                .search-box {
                    max-width: 100%;
                    width: 100%;
                }

                .stats-card {
                    flex-direction: column;
                }

                .stat-item {
                    padding: 10px;
                }

                table {
                    font-size: 12px;
                }

                th, td {
                    padding: 10px 8px;
                }

                .actions {
                    flex-direction: column;
                    gap: 5px;
                }

                .pagination-container {
                    flex-direction: column;
                    text-align: center;
                }
            }
            /* ========== DROPDOWN CHON SO TRANG ========== */
            .page-size-dropdown {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .page-size-dropdown label {
                font-size: 14px;
                color: #555;
            }

            .page-size-dropdown select {
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                background: white;
                cursor: pointer;
                min-width: 100px;
            }

            .page-size-dropdown select:hover {
                border-color: #667eea;
            }

            .page-size-dropdown select:focus {
                outline: none;
                border-color: #667eea;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.2);
            }
        </style>
    </head>
    <body>
        <div class="header">
            <div class="header-left">
                <h1>Quản lý Sách</h1>
                <p>Digital Library Management System</p>
            </div>
            <div class="header-right">
                <div class="user-info">
                    <strong>👤 ${currentEmployee.fullName}</strong>
                    <small>${currentEmployee.roleName}</small>
                </div>
                <a href="${pageContext.request.contextPath}/mock-logout" class="btn-logout">
                    Logout
                </a>
            </div>
        </div>

        <div class="container">

            <div class="stats-card">
                <div class="stat-item">
                    <h3>${totalBooks}</h3>
                    <p>Tổng số sách</p>
                </div>
                <div class="stat-item">
                    <h3>${currentPage} / ${totalPages}</h3>
                    <p> Trang hiện tại</p>
                </div>
                <div class="stat-item">
                    <h3>${pageSize}</h3>
                    <p> Sách mỗi trang</p>
                </div>
                <c:if test="${not empty keyword}">
                    <div class="stat-item">
                        <h3>${totalBooks}</h3>
                        <p>🔍 Kết quả: "${keyword}"</p>
                    </div>
                </c:if>
            </div>

            <div class="toolbar">
                <div class="toolbar-left">
                    <a href="${pageContext.request.contextPath}/books-list" class="btn btn-info"">Lam moi</a>
                    <a href="${pageContext.request.contextPath}/admin/book-form" class="btn btn-success">Them sach moi</a>

                    <span style="margin-left: 15px;">Hien thi:</span>
                    <select id="pageSizeSelect" onchange="applyFilters()" style="padding: 6px 10px; border: 1px solid #ddd; border-radius: 6px;">
                        <option value="5" ${pageSize == '5' ? 'selected' : ''}>5</option>
                        <option value="10" ${pageSize == '10' ? 'selected' : ''}>10</option>
                        <option value="20" ${pageSize == '20' ? 'selected' : ''}>20</option>
                        <option value="all" ${pageSize == 'all' ? 'selected' : ''}>Tat ca</option>
                    </select>
                </div>

                <div class="toolbar-right">
                    <input type="text" id="searchKeyword" placeholder="Tim theo ten sach, tac gia..."
                           value="${keyword}" style="padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; width: 220px;" />
                    <button onclick="applyFilters()" class="btn btn-primary">Tim kiem</button>
                </div>
            </div>

            <%-- ===== BO LOC MOI - TANG COMPLEXITY ===== --%>
            <div class="filter-bar" style="display: flex; gap: 15px; margin: 15px 0; padding: 15px 20px; background: #f8f9fa; border-radius: 8px; flex-wrap: wrap; align-items: center;">
                <div style="display: flex; align-items: center; gap: 8px;">
                    <label style="font-weight: 600; font-size: 13px; color: #555;">Danh muc:</label>
                    <select id="filterCategory" style="padding: 6px 10px; border: 1px solid #ddd; border-radius: 6px; min-width: 150px;">
                        <option value="">-- Tat ca --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryId}" ${filterCategoryId == cat.categoryId ? 'selected' : ''}>
                                ${cat.categoryName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div style="display: flex; align-items: center; gap: 8px;">
                    <label style="font-weight: 600; font-size: 13px; color: #555;">Tac gia:</label>
                    <select id="filterAuthor" style="padding: 6px 10px; border: 1px solid #ddd; border-radius: 6px; min-width: 150px;">
                        <option value="">-- Tat ca --</option>
                        <c:forEach var="author" items="${authors}">
                            <option value="${author.authorId}" ${filterAuthorId == author.authorId ? 'selected' : ''}>
                                ${author.authorName}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div style="display: flex; align-items: center; gap: 8px;">
                    <label style="font-weight: 600; font-size: 13px; color: #555;">Trang thai:</label>
                    <select id="filterStatus" style="padding: 6px 10px; border: 1px solid #ddd; border-radius: 6px; min-width: 120px;">
                        <option value="">-- Tat ca --</option>
                        <option value="active" ${filterStatus == 'active' ? 'selected' : ''}>Active</option>
                        <option value="inactive" ${filterStatus == 'inactive' ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>

                <button onclick="applyFilters()" class="btn btn-primary" style="padding: 6px 16px;">Loc</button>
                <button onclick="clearFilters()" class="btn btn-info" style="padding: 6px 16px;">Xoa loc</button>
            </div>

            <script>
                function changePageSize(size) {
                    var keyword = '${keyword}';
                    var url = '${pageContext.request.contextPath}/books-list?page=1&pageSize=' + size;
                    if (keyword && keyword.trim() !== '') {
                        url += '&keyword=' + encodeURIComponent(keyword);
                    }
                    window.location.href = url;
                }
            </script>

            <div class="info-text">
                <c:choose>
                    <c:when test="${showAll}">
                        Hien thi tat ca ${totalBooks} sach
                    </c:when>
                    <c:otherwise>
                        Hien thi ${bookList.size()} / ${totalBooks} sach | 
                        Trang ${currentPage} / ${totalPages}
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="table-container">
                <c:choose>
                    <c:when test="${empty bookList}">
                        <div class="empty-state">
                            <h3>Không có sách nào</h3>
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
                            <a href="${pageContext.request.contextPath}/admin/book-form" class="btn btn-success">
                                Thêm sách đầu tiên
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
                                    <th>Số trang</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="book" items="${bookList}">
                                    <tr>
                                        <td><strong>#${book.bookId}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty book.coverUrl}">
                                                    <img src="${pageContext.request.contextPath}/${book.coverUrl}" alt="${book.title}" class="book-cover" onerror="this.style.display='none'" />
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="book-cover-placeholder">📖</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="book-title" title="${book.title}">
                                                ${book.title}
                                            </div>
                                            <c:if test="${not empty book.summary}">
                                                <small style="color:#888; display:block; margin-top:5px; max-width:200px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">
                                                    ${book.summary}
                                                </small>
                                            </c:if>
                                        </td>
                                        <td>${not empty book.authorName ? book.authorName : '-'}</td>
                                        <td>${not empty book.categoryName ? book.categoryName : '-'}</td>
                                        <td class="price">
                                            <c:choose>
                                                <c:when test="${book.price != null && book.price > 0}">
                                                    <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true"/>
                                                    ${not empty book.currency ? book.currency : 'VND'}
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${book.totalPages > 0 ? book.totalPages : '-'}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${book.status == 'active'}">
                                                    <span class="status-badge status-active">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-inactive">Inactive</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="actions">

                                                <a href="${pageContext.request.contextPath}/admin/book-form?id=${book.bookId}" 
                                                   class="btn btn-warning" 
                                                   title="Sửa sách">
                                                    Sửa
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/book-delete?id=${book.bookId}" 
                                                   class="btn btn-danger" 
                                                   onclick="return confirm('Bạn có chắc chắn muốn xóa sách này?\n\nTên sách: ${book.title}')"
                                                   title="Xóa sách">
                                                    Xóa
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
            <c:if test="${totalPages > 1 && !showAll}">
                <div class="pagination-container">
                    <div style="color:#666; font-size:14px;">
                        Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                        | Tong: <strong>${totalBooks}</strong> sach
                    </div>
                    <div class="pagination">
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="javascript:goToPage(${currentPage - 1})">← Truoc</a>
                            </c:when>
                            <c:otherwise>
                                <span class="disabled">← Truoc</span>
                            </c:otherwise>
                        </c:choose>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="active">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="javascript:goToPage(${i})">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <a href="javascript:goToPage(${currentPage + 1})">Sau →</a>
                            </c:when>
                            <c:otherwise>
                                <span class="disabled">Sau →</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
        </div>
        <script>
            function applyFilters() {
                var url = '${pageContext.request.contextPath}/books-list?';
                var params = [];

                var keyword = document.getElementById('searchKeyword').value.trim();
                if (keyword)
                    params.push('keyword=' + encodeURIComponent(keyword));

                var pageSize = document.getElementById('pageSizeSelect').value;
                if (pageSize)
                    params.push('pageSize=' + pageSize);

                var catId = document.getElementById('filterCategory').value;
                if (catId)
                    params.push('categoryId=' + catId);

                var authorId = document.getElementById('filterAuthor').value;
                if (authorId)
                    params.push('authorId=' + authorId);

                var status = document.getElementById('filterStatus').value;
                if (status)
                    params.push('status=' + status);

                window.location.href = url + params.join('&');
            }

            function clearFilters() {
                window.location.href = '${pageContext.request.contextPath}/books-list';
            }

            // Enter key to search
            document.getElementById('searchKeyword').addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    applyFilters();
                }
            });
            
            function goToPage(page) {
                var url = '${pageContext.request.contextPath}/books-list?page=' + page;

                var keyword = document.getElementById('searchKeyword').value.trim();
                if (keyword) url += '&keyword=' + encodeURIComponent(keyword);

                var pageSize = document.getElementById('pageSizeSelect').value;
                if (pageSize) url += '&pageSize=' + pageSize;

                var catId = document.getElementById('filterCategory').value;
                if (catId) url += '&categoryId=' + catId;

                var authorId = document.getElementById('filterAuthor').value;
                if (authorId) url += '&authorId=' + authorId;

                var status = document.getElementById('filterStatus').value;
                if (status) url += '&status=' + status;

                window.location.href = url;
            }
        </script>
    </body>
</html>