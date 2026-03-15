<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Employee, util.AuthUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<% Employee currentAdmin = (Employee) session.getAttribute(AuthUtil.SESSION_USER);%>

<jsp:include page="/includes/header.jsp" />

<style>
    .detail-cover {
        width: 160px;
        height: 220px;
        object-fit: cover;
        border-radius: 8px;
        border: 1px solid #e5e7eb;
    }
    .status-badge {
        padding: 4px 10px;
        border-radius: 4px;
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
    }
</style>

<main class="container py-5 my-5" style="min-height: 70vh;">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none"><i class="fas fa-home"></i> Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/book-list" class="text-decoration-none">Danh sách sách</a></li>
            <li class="breadcrumb-item active">Chi tiết</li>
        </ol>
    </nav>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${errorMessage}</div>
    </c:if>

    <c:if test="${empty book}">
        <div class="alert alert-warning">Không tìm thấy sách.</div>
    </c:if>

    <c:if test="${not empty book}">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="mb-0" style="font-weight: 700;">
                <i class="fas fa-book" style="color:#4f46e5;"></i> Chi tiết sách
            </h2>
            <div>
                <a href="${pageContext.request.contextPath}/admin/book-form?id=${book.bookId}" class="btn btn-primary" style="background:#1a1a2e; border-color:#1a1a2e;"><i class="fas fa-edit"></i> Sửa</a>
                <a href="${pageContext.request.contextPath}/books/upload/${book.bookId}" class="btn btn-outline-info"><i class="fas fa-upload"></i> Upload nội dung</a>
                <form action="${pageContext.request.contextPath}/admin/book-delete" method="post" style="display:inline;" onsubmit="return confirm('Vô hiệu hóa sách này?');">
                    <input type="hidden" name="id" value="${book.bookId}">
                    <button type="submit" class="btn btn-outline-danger"><i class="fas fa-ban"></i> Vô hiệu hóa</button>
                </form>
            </div>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-body">
                <div class="row">
                    <div class="col-md-3 text-center">
                        <c:choose>
                            <c:when test="${not empty book.coverUrl}">
                                <img src="${book.coverUrl}" alt="" class="detail-cover">
                            </c:when>
                            <c:otherwise>
                                <div class="book-cover-placeholder"><i class="fas fa-book"></i></div>
                                </c:otherwise>
                            </c:choose>
                    </div>
                    <div class="col-md-9">
                        <h4>${book.title}</h4>
                        <p class="mb-1"><strong>Trạng thái:</strong> <span class="status-badge" style="background:${statusColor}; color:#fff;">${statusLabel}</span></p>
                        <p class="mb-1"><strong>Tác giả:</strong> ${author != null ? author.authorName : (book.authorName != null ? book.authorName : '—')}</p>
                        <p class="mb-1"><strong>Danh mục:</strong> ${category != null ? category.categoryName : (book.categoryName != null ? book.categoryName : '—')}</p>
                        <p class="mb-1"><strong>Giá:</strong> <fmt:formatNumber value="${book.price}" type="number"/> ${book.currency != null ? book.currency : 'VND'}</p>
                        <p class="mb-1"><strong>Tổng trang:</strong> ${book.totalPages != null ? book.totalPages : '—'}</p>
                        <p class="mb-1"><strong>Xem trước:</strong> ${book.previewPages != null ? book.previewPages : '—'} trang</p>
                        <p class="mb-1"><strong>Đường dẫn nội dung:</strong> ${book.contentPath != null ? book.contentPath : '—'}</p>
                        <c:if test="${not empty book.summary}">
                            <p class="mt-2"><strong>Tóm tắt:</strong><br/>${book.summary}</p>
                            </c:if>
                            <c:if test="${not empty book.description}">
                            <p><strong>Mô tả:</strong><br/>${book.description}</p>
                            </c:if>
                    </div>
                </div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/admin/book-list" class="btn btn-outline-secondary mt-3"><i class="fas fa-arrow-left"></i> Về danh sách</a>
    </c:if>
</main>

<jsp:include page="/includes/footer.jsp" />
