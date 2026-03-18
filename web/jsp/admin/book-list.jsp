<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER);%>

<jsp:include page="/includes/header.jsp" />


<style>
    :root {
        --ink:       #0d0d14;
        --ink-soft:  #3b3b52;
        --ink-muted: #8b8ba0;
        --surface:   #f6f6fa;
        --card:      #ffffff;
        --accent:    #5243e8;
        --accent-lt: #ede9ff;
        --green:     #12b76a;
        --green-lt:  #d1fae5;
        --amber:     #f59e0b;
        --amber-lt:  #fef3c7;
        --red:       #ef4444;
        --red-lt:    #fee2e2;
        --border:    #e8e8f0;
        --radius:    12px;
        --shadow:    0 2px 12px rgba(13,13,20,.07);
        --shadow-lg: 0 8px 32px rgba(13,13,20,.12);
    }

    *, *::before, *::after {
        box-sizing: border-box;
    }

    body {
        background: var(--surface);
        color: var(--ink);
    }

    /* ── PAGE SHELL ── */
    .bl-wrap {
        max-width: 1280px;
        margin: 0 auto;
        padding: 40px 24px 80px;
    }

    /* ── HEADER ── */
    .bl-header {
        display: flex;
        align-items: flex-end;
        justify-content: space-between;
        margin-bottom: 8px;
        gap: 16px;
        flex-wrap: wrap;
    }
    .bl-title {
        font-size: 28px;
        font-weight: 800;
        color: var(--ink);
        letter-spacing: -.5px;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .bl-title-dot {
        width: 10px;
        height: 10px;
        background: var(--accent);
        border-radius: 50%;
        display: inline-block;
    }
    .btn-add {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 10px 20px;
        background: var(--ink);
        color: #fff;
        border-radius: 8px;

        font-weight: 700;
        font-size: 13px;
        text-decoration: none;
        letter-spacing: .3px;
        transition: background .18s, transform .12s;
        border: none;
        cursor: pointer;
    }
    .btn-add:hover {
        background: var(--accent);
        color: #fff;
        transform: translateY(-1px);
    }

    /* ── BREADCRUMB ── */
    .bl-breadcrumb {
        font-size: 12px;
        color: var(--ink-muted);
        margin-bottom: 28px;
        display: flex;
        align-items: center;
        gap: 6px;
    }
    .bl-breadcrumb a {
        color: var(--ink-muted);
        text-decoration: none;
    }
    .bl-breadcrumb a:hover {
        color: var(--accent);
    }
    .bl-breadcrumb span {
        color: var(--ink-soft);
        font-weight: 500;
    }

    /* ── STAT CARDS ── */
    .stat-row {
        display: flex;
        gap: 16px;
        margin-bottom: 24px;
        flex-wrap: wrap;
    }
    .stat-card {
        background: var(--card);
        border: 1px solid var(--border);
        border-radius: var(--radius);
        padding: 18px 22px;
        display: flex;
        align-items: center;
        gap: 16px;
        min-width: 180px;
        box-shadow: var(--shadow);
        flex: 1;
        max-width: 240px;
    }
    .stat-icon {
        width: 44px;
        height: 44px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        flex-shrink: 0;
    }
    .si-purple {
        background: var(--accent-lt);
        color: var(--accent);
    }
    .si-green  {
        background: var(--green-lt);
        color: var(--green);
    }
    .stat-val {
        font-size: 22px;
        font-weight: 800;
        color: var(--ink);
        line-height: 1;
        margin-bottom: 3px;
    }
    .stat-lbl {
        font-size: 11px;
        color: var(--ink-muted);
        font-weight: 500;
        letter-spacing: .3px;
        text-transform: uppercase;
    }

    /* ── ALERTS ── */
    .alert-ok, .alert-err {
        border-radius: var(--radius);
        padding: 12px 18px;
        font-size: 13px;
        margin-bottom: 18px;
        display: flex;
        align-items: center;
        gap: 10px;
        border: 1px solid transparent;
    }
    .alert-ok  {
        background: var(--green-lt);
        color: #065f46;
        border-color: #a7f3d0;
    }
    .alert-err {
        background: var(--red-lt);
        color: #7f1d1d;
        border-color: #fca5a5;
    }

    /* ── FILTER BAR ── */
    .filter-bar {
        background: var(--card);
        border: 1px solid var(--border);
        border-radius: var(--radius);
        padding: 16px 20px;
        margin-bottom: 20px;
        box-shadow: var(--shadow);
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        align-items: center;
    }
    .filter-input, .filter-select {
        border: 1px solid var(--border);
        border-radius: 8px;
        padding: 8px 12px;
        font-size: 13px;
        color: var(--ink);
        background: var(--surface);
        outline: none;
        transition: border-color .15s;
    }
    .filter-input:focus, .filter-select:focus {
        border-color: var(--accent);
        background: #fff;
    }
    .filter-input {
        min-width: 220px;
    }
    .filter-select {
        min-width: 130px;
    }

    .btn-filter {
        padding: 8px 16px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 700;
        cursor: pointer;
        border: none;
        transition: all .15s;
        display: inline-flex;
        align-items: center;
        gap: 6px;
    }
    .btn-filter-primary {
        background: var(--ink);
        color: #fff;
    }
    .btn-filter-primary:hover {
        background: var(--accent);
    }
    .btn-filter-ghost {
        background: transparent;
        color: var(--ink-muted);
        border: 1px solid var(--border);
    }
    .btn-filter-ghost:hover {
        border-color: var(--ink-soft);
        color: var(--ink);
    }
    .btn-refresh {
        padding: 8px 14px;
        border-radius: 8px;
        font-size: 13px;
        background: transparent;
        border: 1px solid var(--border);
        color: var(--ink-muted);
        cursor: pointer;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        transition: all .15s;
    }
    .btn-refresh:hover {
        border-color: var(--accent);
        color: var(--accent);
    }

    /* ── TABLE CARD ── */
    .table-card {
        background: var(--card);
        border: 1px solid var(--border);
        border-radius: var(--radius);
        box-shadow: var(--shadow);
        overflow: visible;
    }
    .table-wrap {
        overflow-x: auto;
    }
    table {
        width: 100%;
        border-collapse: collapse;
    }
    thead tr {
        border-bottom: 2px solid var(--border);
    }
    thead th {
        padding: 14px 16px;
        font-size: 11px;
        font-weight: 700;
        color: var(--ink-muted);
        letter-spacing: .8px;
        text-transform: uppercase;
        white-space: nowrap;
        background: var(--surface);
    }
    thead th:first-child {
        border-radius: var(--radius) 0 0 0;
    }
    thead th:last-child  {
        border-radius: 0 var(--radius) 0 0;
    }

    tbody tr {
        border-bottom: 1px solid var(--border);
        transition: background .12s;
    }
    tbody tr:last-child {
        border-bottom: none;
    }
    tbody tr:hover {
        background: #fafafe;
    }
    tbody td {
        padding: 14px 16px;
        font-size: 13.5px;
        vertical-align: middle;
    }

    /* book cover */
    .book-cover {
        width: 42px;
        height: 58px;
        object-fit: cover;
        border-radius: 6px;
        border: 1px solid var(--border);
        box-shadow: 0 2px 6px rgba(0,0,0,.1);
        display: block;
    }
    .book-cover-placeholder {
        width: 42px;
        height: 58px;
        border-radius: 6px;
        background: var(--accent-lt);
        display: flex;
        align-items: center;
        justify-content: center;
        color: var(--accent);
        font-size: 16px;
        border: 1px solid #ddd8ff;
    }

    .book-title {
        font-weight: 600;
        color: var(--ink);
        font-size: 14px;
    }
    .book-subtitle {
        font-size: 11.5px;
        color: var(--ink-muted);
        margin-top: 2px;
    }

    /* badges */
    .badge {
        display: inline-flex;
        align-items: center;
        padding: 3px 10px;
        border-radius: 20px;
        font-size: 10.5px;
        font-weight: 700;
        letter-spacing: .4px;
        text-transform: uppercase;
        gap: 5px;
    }
    .badge::before {
        content: '';
        width: 5px;
        height: 5px;
        border-radius: 50%;
    }
    .badge-active   {
        background: var(--green-lt);
        color: #065f46;
    }
    .badge-active::before   {
        background: var(--green);
    }
    .badge-inactive {
        background: var(--red-lt);
        color: #7f1d1d;
    }
    .badge-inactive::before {
        background: var(--red);
    }
    .badge-draft    {
        background: var(--amber-lt);
        color: #78350f;
    }
    .badge-draft::before    {
        background: var(--amber);
    }

    .price-tag {
        font-weight: 600;
        color: var(--ink);
        font-size: 13px;
    }

    /* action buttons */
    .action-group {
        display: flex;
        gap: 6px;
        flex-wrap: wrap;
    }
    .btn-act {
        padding: 5px 11px;
        border-radius: 6px;
        font-size: 11.5px;
        font-weight: 600;
        cursor: pointer;
        border: 1px solid transparent;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 4px;
        transition: all .13s;
        white-space: nowrap;
    }
    .btn-act-gray   {
        border-color: var(--border);
        color: var(--ink-soft);
        background: transparent;
    }
    .btn-act-gray:hover   {
        background: var(--surface);
        color: var(--ink);
    }
    .btn-act-blue   {
        border-color: #bfdbfe;
        color: #1e40af;
        background: #eff6ff;
    }
    .btn-act-blue:hover   {
        background: #dbeafe;
    }
    .btn-act-teal   {
        border-color: #99f6e4;
        color: #115e59;
        background: #f0fdfa;
    }
    .btn-act-teal:hover   {
        background: #ccfbf1;
    }
    .btn-act-red    {
        border-color: #fecaca;
        color: #991b1b;
        background: #fff5f5;
    }
    .btn-act-red:hover    {
        background: #fee2e2;
    }

    /* empty state */
    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: var(--ink-muted);
    }
    .empty-state i {
        font-size: 40px;
        margin-bottom: 16px;
        color: var(--border);
        display: block;
    }
    .empty-state h5 {
        font-weight: 700;
        color: var(--ink-soft);
    }

    /* ── PAGINATION ── */
    .pagi-footer {
        padding: 16px 20px;
        border-top: 1px solid var(--border);
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 12px;
        overflow: visible;
    }
    .pagi-info {
        font-size: 12px;
        color: var(--ink-muted);
    }
    .pagi-info strong {
        color: var(--ink-soft);
    }

    .pagi-list {
        display: flex;
        gap: 4px;
        list-style: none;
        margin: 0;
        padding: 0;
        flex-wrap: wrap;
        overflow: visible;
    }
    .pagi-list li {
        overflow: visible;
    }
    .pagi-list a, .pagi-list span {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-width: 34px;
        height: 34px;
        padding: 0 10px;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 600;
        text-decoration: none;
        color: var(--ink-soft);
        background: var(--surface);
        border: 1px solid var(--border);
        cursor: pointer;
        transition: all .15s;
        white-space: nowrap;
    }
    .pagi-list a:hover {
        background: var(--accent-lt);
        color: var(--accent);
        border-color: #c4b8ff;
    }
    .pagi-list .active a, .pagi-list .active span {
        background: var(--accent);
        color: #fff;
        border-color: var(--accent);
    }
    .pagi-list .disabled a, .pagi-list .disabled span {
        opacity: .4;
        cursor: not-allowed;
        pointer-events: none;
    }

    /* fade-in rows */
    @keyframes rowIn {
        from {
            opacity: 0;
            transform: translateY(6px);
        }
        to   {
            opacity: 1;
            transform: none;
        }
    }
    tbody tr {
        animation: rowIn .25s ease both;
    }
    tbody tr:nth-child(1)  {
        animation-delay: .03s;
    }
    tbody tr:nth-child(2)  {
        animation-delay: .06s;
    }
    tbody tr:nth-child(3)  {
        animation-delay: .09s;
    }
    tbody tr:nth-child(4)  {
        animation-delay: .12s;
    }
    tbody tr:nth-child(5)  {
        animation-delay: .15s;
    }
    tbody tr:nth-child(n+6){
        animation-delay: .18s;
    }

    /* responsive */
    @media (max-width: 768px) {
        .bl-title {
            font-size: 22px;
        }
        .stat-card {
            max-width: 100%;
        }
        .filter-input {
            min-width: 100%;
        }
    }
</style>

<main class="container-fluid py-5 my-4" style="min-height:70vh; background: var(--surface);">
    <div class="bl-wrap">

        <%-- Header --%>
        <div class="bl-header">
            <h2 class="bl-title">
                <span class="bl-title-dot"></span>
                Danh sách sách
            </h2>
            <a href="${pageContext.request.contextPath}/admin/book-form" class="btn-add">
                <i class="fas fa-plus"></i> Thêm sách mới
            </a>
        </div>

        <%-- Breadcrumb --%>
        <div class="bl-breadcrumb">
            <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Trang chủ</a>
            <i class="fas fa-chevron-right" style="font-size:9px;"></i>
            <span>Danh sách sách</span>
        </div>

        <%-- Alerts --%>
        <c:if test="${not empty successMessage}">
            <div class="alert-ok"><i class="fas fa-check-circle"></i> ${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert-err"><i class="fas fa-exclamation-circle"></i> ${errorMessage}</div>
        </c:if>

        <%-- Stats --%>
        <div class="stat-row">
            <div class="stat-card">
                <div class="stat-icon si-purple"><i class="fas fa-book-open"></i></div>
                <div>
                    <div class="stat-val">${totalBooks}</div>
                    <div class="stat-lbl">Tổng sách</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon si-green"><i class="fas fa-layers"></i></div>
                <div>
                    <div class="stat-val">${currentPage}<span style="font-size:14px;color:var(--ink-muted);font-weight:500;">/${totalPages}</span></div>
                    <div class="stat-lbl">Trang hiện tại</div>
                </div>
            </div>
                    <div class="stat-card">
                <div class="stat-icon "><i class="fas fa-layer-group"></i></div>
                <div>
                    <div class="stat-val">${pageSize}</div>
                    <div class="stat-lbl">Sách Mỗi Trang</div>
                </div>
            </div>
            <c:if test="${not empty keyword}">
                <div class="stat-card">
                    <div class="stat-icon "><i class="fas fa-search"></i></div>
                    <div>
                        <div class="stat-val">${totalBooks}</div>
                        <div class="stat-lbl">Kết quả: "${keyword}"</div>
                    </div>
                </div>
            </c:if>
            <c:if test="${empty keyword}">
                <div class="stat-card">
                    <div class="stat-icon "><i class="fas fa-tags"></i></div>
                    <div>
                        <div class="stat-val">${categories.size()}</div>
                        <div class="stat-lbl">Danh Mục</div>
                    </div>
                </div>
            </c:if>
        </div>

        <%-- Filter bar --%>
        <div class="filter-bar">
            <a href="${pageContext.request.contextPath}/admin/book-list" class="btn-refresh">
                <i class="fas fa-sync-alt"></i> Làm mới
            </a>

            <input type="text" class="filter-input" id="searchKeyword"
                   placeholder="&#xF002;  Tìm tiêu đề, tác giả..." value="${keyword}">

            <select id="filterCategoryId" class="filter-select">
                <option value="">Danh mục...</option>
                <c:forEach var="c" items="${categories}">
                    <option value="${c.categoryId}" <c:if test="${filterCategoryId == c.categoryId}">selected</c:if>>${c.categoryName}</option>
                </c:forEach>
            </select>

            <select id="filterAuthorId" class="filter-select">
                <option value="">Tác giả...</option>
                <c:forEach var="a" items="${authors}">
                    <option value="${a.authorId}" <c:if test="${filterAuthorId == a.authorId}">selected</c:if>>${a.authorName}</option>
                </c:forEach>
            </select>

            <select id="filterStatus" class="filter-select" style="min-width:120px;">
                <option value="">Trạng thái...</option>
                <option value="active"   <c:if test="${filterStatus == 'active'}">selected</c:if>>Active</option>
                <option value="inactive" <c:if test="${filterStatus == 'inactive'}">selected</c:if>>Inactive</option>
                <option value="draft"    <c:if test="${filterStatus == 'draft'}">selected</c:if>>Draft</option>
                </select>

                <select id="filterPageSize" class="filter-select" style="min-width:100px;">
                    <option value="5"   <c:if test="${pageSize == '5'}">selected</c:if>>5 / trang</option>
                <option value="10"  <c:if test="${pageSize == '10'}">selected</c:if>>10 / trang</option>
                <option value="20"  <c:if test="${pageSize == '20'}">selected</c:if>>20 / trang</option>
                <option value="all" <c:if test="${pageSize == 'all'}">selected</c:if>>Tất cả</option>
                </select>

                <button type="button" onclick="applyFilters()" class="btn-filter btn-filter-primary">
                    <i class="fas fa-filter"></i> Lọc
                </button>
                <button type="button" onclick="clearFilters()" class="btn-filter btn-filter-ghost">
                    <i class="fas fa-times"></i> Xóa lọc
                </button>
            </div>

        <%-- Table card --%>
        <div class="table-card">
            <div class="table-wrap">
                <c:choose>
                    <c:when test="${empty bookList}">
                        <div class="empty-state">
                            <i class="fas fa-book-open"></i>
                            <h5>Không có dữ liệu sách</h5>
                            <p style="font-size:13px;">Thêm sách mới hoặc thay đổi bộ lọc.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th style="width:60px;">Bìa</th>
                                    <th>Tiêu đề</th>
                                    <th>Tác giả</th>
                                    <th>Danh mục</th>
                                    <th>Giá</th>
                                    <th>Trạng thái</th>
                                    <th style="width:260px;">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="b" items="${bookList}">
                                    <tr>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty b.coverUrl}">
                                                    <img src="${b.coverUrl}" alt="" class="book-cover">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="book-cover-placeholder"><i class="fas fa-book"></i></div>
                                                    </c:otherwise>
                                                </c:choose>
                                        </td>
                                        <td>
                                            <div class="book-title">${b.title}</div>
                                            <div class="book-subtitle">#${b.bookId}</div>
                                        </td>
                                        <td style="color:var(--ink-soft);">${b.authorName != null ? b.authorName : '—'}</td>
                                        <td style="color:var(--ink-soft);">${b.categoryName != null ? b.categoryName : '—'}</td>
                                        <td>
                                            <span class="price-tag">
                                                <c:choose>
                                                    <c:when test="${b.price == null or b.price == 0}">
                                                        <span style="color:var(--green);font-weight:700;">Miễn phí</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber value="${b.price}" type="number"/>
                                                        <span style="font-size:11px;color:var(--ink-muted);"> ${b.currency != null ? b.currency : 'VND'}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge ${b.status == 'active' ? 'badge-active' : (b.status == 'inactive' ? 'badge-inactive' : 'badge-draft')}">${b.status}</span>
                                        </td>
                                        <td>
                                            <div class="action-group">
                                                <a href="${pageContext.request.contextPath}/admin/book-detail?id=${b.bookId}" class="btn-act btn-act-gray">
                                                    <i class="fas fa-eye"></i> Chi tiết
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/book-form?id=${b.bookId}" class="btn-act btn-act-blue">
                                                    <i class="fas fa-pen"></i> Sửa
                                                </a>
                                                <a href="${pageContext.request.contextPath}/books/upload/${b.bookId}" class="btn-act btn-act-teal">
                                                    <i class="fas fa-upload"></i> Upload
                                                </a>
                                                <c:choose>
                                                    <c:when test="${b.status == 'inactive'}">
                                                        <form action="${pageContext.request.contextPath}/admin/book-delete" method="post"
                                                              style="display:inline;"
                                                              onsubmit="return confirm('Xóa vĩnh viễn sách này? Hành động không thể hoàn tác.');">
                                                            <input type="hidden" name="id" value="${b.bookId}">
                                                            <input type="hidden" name="mode" value="hard">
                                                            <button type="submit" class="btn-act btn-act-red">
                                                                <i class="fas fa-trash"></i> Xóa vĩnh viễn
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form action="${pageContext.request.contextPath}/admin/book-delete" method="post"
                                                              style="display:inline;"
                                                              onsubmit="return confirm('Vô hiệu hóa sách này (soft delete)?');">
                                                            <input type="hidden" name="id" value="${b.bookId}">
                                                            <button type="submit" class="btn-act btn-act-red">
                                                                <i class="fas fa-ban"></i> Vô hiệu hóa
                                                            </button>
                                                        </form>
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

            <%-- Pagination --%>
            <c:if test="${totalPages > 1}">
                <div class="pagi-footer">
                    <div class="pagi-info">
                        Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                        &nbsp;·&nbsp; Tổng <strong>${totalBooks}</strong> sách
                    </div>
                    <ul class="pagi-list">
                        <li class="${currentPage <= 1 ? 'disabled' : ''}">
                            <a href="javascript:goToPage(${currentPage - 1})"><i class="fas fa-chevron-left" style="font-size:10px;"></i> Trước</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a href="javascript:goToPage(${i})">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="${currentPage >= totalPages ? 'disabled' : ''}">
                            <a href="javascript:goToPage(${currentPage + 1})">Sau <i class="fas fa-chevron-right" style="font-size:10px;"></i></a>
                        </li>
                    </ul>
                </div>
            </c:if>
        </div>

    </div>
</main>

<script>
    function applyFilters() {
        var u = '${pageContext.request.contextPath}/admin/book-list?page=1';
        var k = document.getElementById('searchKeyword').value.trim();
        if (k)
            u += '&keyword=' + encodeURIComponent(k);
        var cat = document.getElementById('filterCategoryId').value;
        if (cat)
            u += '&categoryId=' + cat;
        var auth = document.getElementById('filterAuthorId').value;
        if (auth)
            u += '&authorId=' + auth;
        var st = document.getElementById('filterStatus').value;
        if (st)
            u += '&status=' + st;
        var ps = document.getElementById('filterPageSize').value;
        if (ps)
            u += '&pageSize=' + ps;
        window.location.href = u;
    }
    function clearFilters() {
        window.location.href = '${pageContext.request.contextPath}/admin/book-list';
    }
    function goToPage(pg) {
        var u = '${pageContext.request.contextPath}/admin/book-list?page=' + pg;
        var k = document.getElementById('searchKeyword').value.trim();
        if (k)
            u += '&keyword=' + encodeURIComponent(k);
        var cat = document.getElementById('filterCategoryId').value;
        if (cat)
            u += '&categoryId=' + cat;
        var auth = document.getElementById('filterAuthorId').value;
        if (auth)
            u += '&authorId=' + auth;
        var st = document.getElementById('filterStatus').value;
        if (st)
            u += '&status=' + st;
        var ps = document.getElementById('filterPageSize').value;
        if (ps)
            u += '&pageSize=' + ps;
        window.location.href = u;
    }
    document.getElementById('searchKeyword').addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            applyFilters();
        }
    });
</script>

<jsp:include page="/includes/footer.jsp" />
