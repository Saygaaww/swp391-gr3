<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiet sach - Admin</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f0f0;
            min-height: 100vh;
        }
        .header {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: white;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header h1 { font-size: 24px; }
        .header-right { display: flex; gap: 15px; align-items: center; }
        .btn-logout {
            padding: 10px 20px;
            background: rgba(255,255,255,0.2);
            border: 2px solid white;
            color: white;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
        }
        .btn-logout:hover { background: white; color: #2c3e50; }
        .container { max-width: 1000px; margin: 30px auto; padding: 0 20px; }
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #3498db;
            text-decoration: none;
            font-weight: 600;
        }
        .back-link:hover { text-decoration: underline; }

        .alert { padding: 15px 20px; border-radius: 8px; margin-bottom: 20px; }
        .alert-danger { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        .detail-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            overflow: hidden;
            margin-bottom: 20px;
        }
        .detail-header {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: white;
            padding: 25px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .detail-header h2 { font-size: 22px; }
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            color: white;
        }

        .detail-body { padding: 30px; }
        .detail-grid {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 30px;
        }

        .cover-section { text-align: center; }
        .cover-section img {
            max-width: 100%;
            max-height: 350px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.15);
            object-fit: cover;
        }
        .no-cover {
            width: 200px;
            height: 280px;
            background: #e9ecef;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #adb5bd;
            font-size: 48px;
            margin: 0 auto;
        }

        .info-section {}
        .info-group { margin-bottom: 18px; }
        .info-label {
            font-size: 12px;
            text-transform: uppercase;
            color: #999;
            font-weight: 600;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .info-value {
            font-size: 15px;
            color: #333;
            line-height: 1.5;
        }
        .info-value.title { font-size: 20px; font-weight: 700; color: #2c3e50; }
        .info-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }

        .tag {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
        }
        .tag-category { background: #e8f4fd; color: #1976d2; }
        .tag-author { background: #fce4ec; color: #c62828; }
        .tag-price {
            font-size: 18px;
            font-weight: 700;
            color: #e74c3c;
        }

        .section-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            overflow: hidden;
        }
        .section-title {
            background: #f8f9fa;
            padding: 15px 25px;
            font-weight: 600;
            color: #333;
            border-bottom: 1px solid #e0e0e0;
        }
        .section-body { padding: 25px; }
        .section-body p { line-height: 1.8; color: #555; }

        .meta-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; }
        .meta-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            text-align: center;
        }
        .meta-item .label { font-size: 12px; color: #999; margin-bottom: 5px; }
        .meta-item .value { font-size: 16px; font-weight: 600; color: #333; }

        .action-bar {
            display: flex;
            gap: 10px;
            margin-top: 20px;
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
        .btn:hover { transform: translateY(-2px); box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
        .btn-edit { background: #ffc107; color: #212529; }
        .btn-delete { background: #dc3545; color: white; }
        .btn-list { background: #3498db; color: white; }
        .btn-content { background: #28a745; color: white; }

        @media (max-width: 768px) {
            .detail-grid { grid-template-columns: 1fr; }
            .info-row { grid-template-columns: 1fr; }
            .meta-grid { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>
<body>
    <div class="header">
        <div>
            <h1>Chi tiet Sach</h1>
            <small>Book Detail</small>
        </div>
        <div class="header-right">
            <span>${currentEmployee.fullName}</span>
            <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Dang xuat</a>
        </div>
    </div>

    <div class="container">
        <a href="${pageContext.request.contextPath}/books-list" class="back-link">← Quay lai danh sach sach</a>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <c:if test="${not empty book}">
            <%-- Main Detail Card --%>
            <div class="detail-card">
                <div class="detail-header">
                    <h2>Sach #${book.bookId}</h2>
                    <span class="status-badge" style="background: ${statusColor};">${statusLabel}</span>
                </div>
                <div class="detail-body">
                    <div class="detail-grid">
                        <%-- Cover Image --%>
                        <div class="cover-section">
                            <c:choose>
                                <c:when test="${not empty book.coverUrl}">
                                    <img src="${pageContext.request.contextPath}/${book.coverUrl}" 
                                         alt="${book.title}"
                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                    <div class="no-cover" style="display:none;">&#128218;</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-cover">&#128218;</div>
                                </c:otherwise>
                            </c:choose>

                            <c:if test="${not empty book.contentPath}">
                                <div style="margin-top: 15px;">
                                    <a href="${pageContext.request.contextPath}/${book.contentPath}" 
                                       class="btn btn-content" target="_blank">
                                        &#128196; Xem file noi dung
                                    </a>
                                </div>
                            </c:if>
                        </div>

                        <%-- Info Section --%>
                        <div class="info-section">
                            <div class="info-group">
                                <div class="info-label">Tieu de sach</div>
                                <div class="info-value title">${book.title}</div>
                            </div>

                            <div class="info-row">
                                <div class="info-group">
                                    <div class="info-label">Tac gia</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty author}">
                                                <span class="tag tag-author">${author.authorName}</span>
                                            </c:when>
                                            <c:when test="${not empty book.authorName}">
                                                <span class="tag tag-author">${book.authorName}</span>
                                            </c:when>
                                            <c:otherwise><em style="color:#999;">Chua gan</em></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-group">
                                    <div class="info-label">Danh muc</div>
                                    <div class="info-value">
                                        <c:choose>
                                            <c:when test="${not empty category}">
                                                <span class="tag tag-category">${category.categoryName}</span>
                                            </c:when>
                                            <c:when test="${not empty book.categoryName}">
                                                <span class="tag tag-category">${book.categoryName}</span>
                                            </c:when>
                                            <c:otherwise><em style="color:#999;">Chua gan</em></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="info-row">
                                <div class="info-group">
                                    <div class="info-label">Gia ban</div>
                                    <div class="info-value tag-price">
                                        <c:choose>
                                            <c:when test="${book.price != null && book.price > 0}">
                                                <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true"/> ${book.currency}
                                            </c:when>
                                            <c:otherwise>Mien phi</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="info-group">
                                    <div class="info-label">So trang</div>
                                    <div class="info-value">
                                        ${book.totalPages > 0 ? book.totalPages : 'Chua cap nhat'} trang
                                        <c:if test="${book.previewPages > 0}">
                                            <span style="color:#999; font-size:13px;">(${book.previewPages} trang xem truoc)</span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <c:if test="${not empty book.summary}">
                                <div class="info-group">
                                    <div class="info-label">Tom tat</div>
                                    <div class="info-value">${book.summary}</div>
                                </div>
                            </c:if>

                            <%-- Action Buttons --%>
                            <div class="action-bar">
                                <a href="${pageContext.request.contextPath}/admin/book-form?id=${book.bookId}" class="btn btn-edit">
                                    &#9998; Chinh sua
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/book-delete?id=${book.bookId}" 
                                   class="btn btn-delete"
                                   onclick="return confirm('Ban co chac chan muon xoa sach nay?');">
                                    &#128465; Xoa sach
                                </a>
                                <a href="${pageContext.request.contextPath}/books-list" class="btn btn-list">
                                    &#128218; Danh sach sach
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Mo ta chi tiet --%>
            <c:if test="${not empty book.description}">
                <div class="section-card">
                    <div class="section-title">&#128196; Mo ta chi tiet</div>
                    <div class="section-body">
                        <p>${book.description}</p>
                    </div>
                </div>
            </c:if>

            <%-- Tieu su tac gia --%>
            <c:if test="${not empty author && not empty author.bio}">
                <div class="section-card">
                    <div class="section-title">&#128100; Ve tac gia: ${author.authorName}</div>
                    <div class="section-body">
                        <p>${author.bio}</p>
                    </div>
                </div>
            </c:if>

            <%-- Thong tin danh muc --%>
            <c:if test="${not empty category && not empty category.description}">
                <div class="section-card">
                    <div class="section-title">&#128193; Danh muc: ${category.categoryName}</div>
                    <div class="section-body">
                        <p>${category.description}</p>
                    </div>
                </div>
            </c:if>

            <%-- Metadata --%>
            <div class="section-card">
                <div class="section-title">&#128295; Thong tin he thong</div>
                <div class="section-body">
                    <div class="meta-grid">
                        <div class="meta-item">
                            <div class="label">Ma sach</div>
                            <div class="value">#${book.bookId}</div>
                        </div>
                        <div class="meta-item">
                            <div class="label">Trang thai</div>
                            <div class="value" style="color: ${statusColor};">${statusLabel}</div>
                        </div>
                        <div class="meta-item">
                            <div class="label">Don vi tien</div>
                            <div class="value">${not empty book.currency ? book.currency : 'VND'}</div>
                        </div>
                        <div class="meta-item">
                            <div class="label">Trang xem truoc</div>
                            <div class="value">${book.previewPages}</div>
                        </div>
                        <div class="meta-item">
                            <div class="label">Ngay tao</div>
                            <div class="value">
                                <c:choose>
                                    <c:when test="${not empty book.createdAt}">
                                        <fmt:formatDate value="${book.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </c:when>
                                    <c:otherwise>N/A</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="meta-item">
                            <div class="label">Cap nhat lan cuoi</div>
                            <div class="value">
                                <c:choose>
                                    <c:when test="${not empty book.updatedAt}">
                                        <fmt:formatDate value="${book.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </c:when>
                                    <c:otherwise>Chua cap nhat</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</body>
</html>
