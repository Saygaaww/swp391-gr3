<%--
  Trang đọc sách - chỉ sách đã sở hữu, lưu tiến độ.
  Hiển thị file PDF khi Book.content_path có giá trị (URL đầy đủ hoặc đường dẫn tương đối: uploads/books/<id>.pdf).
--%>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@include file="/includes/header.jsp"%>
<% String ctx = request.getContextPath(); %>
<style>
    .user-home { background: #fff; min-height: 100vh; color: #333; }
    .user-home .btn-card { border: 2px solid #000; color: #000; background: #fff; font-weight: 500; }
    .user-home .btn-card:hover { background: #000; color: #fff; }
    .no-content-placeholder { background: #f8f9fa; border: 2px dashed #dee2e6; border-radius: 12px; padding: 3rem; text-align: center; color: #6c757d; }
</style>
<%@include file="/includes/navbar.jsp"%>
<div class="user-home">
<div class="container py-5">
    <h2 class="fw-bold mb-2">${book.bookTitle}</h2>
    <p class="text-muted small mb-4">${book.authorName}</p>

    <c:set var="contentUrl" value="${book.contentPath}"/>
    <c:if test="${contentUrl != null && !contentUrl.isEmpty() && !fn:startsWith(contentUrl, 'http://') && !fn:startsWith(contentUrl, 'https://')}">
        <c:set var="contentUrl" value="${pageContext.request.contextPath}/${book.contentPath}"/>
    </c:if>
    <%-- Encode spaces in path so filenames like "George Orwell - 1984.pdf" work in iframe --%>
    <c:if test="${contentUrl != null && !contentUrl.isEmpty()}">
        <c:set var="contentUrl" value="${fn:replace(contentUrl, ' ', '%20')}"/>
    </c:if>
    <c:if test="${book.contentPath != null && !book.contentPath.isEmpty()}">
        <div class="mb-3">
            <iframe src="${contentUrl}" title="${book.bookTitle}" style="width:100%;height:70vh;border:1px solid #ddd;" class="rounded"></iframe>
        </div>
    </c:if>
    <c:if test="${book.contentPath == null || book.contentPath.isEmpty()}">
        <div class="no-content-placeholder mb-4">
            <p class="mb-2"><i class="fa fa-book fa-3x text-secondary"></i></p>
            <p class="fw-bold mb-1">Nội dung sách chưa có file</p>
            <p class="small mb-0">Thư viện có thể sẽ cập nhật file PDF sau. Bạn vẫn có thể <strong>lưu tiến độ đọc</strong> bên dưới (ví dụ nếu đọc bản in hoặc khi file đã có).</p>
        </div>
    </c:if>

    <div class="card">
        <div class="card-header fw-bold">Lưu tiến độ đọc</div>
        <div class="card-body">
            <form action="<%= ctx %>/customer/read" method="post" class="row g-2 align-items-end">
                <input type="hidden" name="bookId" value="${book.bookId}">
                <div class="col-auto">
                    <label class="form-label">Trang đã đọc đến</label>
                    <input type="number" name="position" value="${lastPosition}" min="1" max="${book.bookTotalPages != null ? book.bookTotalPages : 9999}" class="form-control" style="width:100px">
                </div>
                <c:if test="${book.bookTotalPages != null}">
                    <div class="col-auto pt-4">/ ${book.bookTotalPages} trang</div>
                </c:if>
                <div class="col-auto">
                    <button type="submit" class="btn btn-card">Lưu tiến độ</button>
                </div>
            </form>
        </div>
    </div>
    <a href="<%= ctx %>/customer/my-library" class="btn btn-outline-dark mt-3">← My Library</a>
    <a href="<%= ctx %>/customer/reading-history" class="btn btn-outline-dark mt-3">Lịch sử đọc</a>
</div>
</div>
<%@include file="/includes/footer.jsp"%>
