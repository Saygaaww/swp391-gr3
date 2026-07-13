<%--
  Trang đọc sách - chỉ sách đã sở hữu, lưu tiến độ.
  Hiển thị file PDF khi Book.content_path có giá trị (URL đầy đủ hoặc đường dẫn tương đối: uploads/books/<id>.pdf).
--%>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@include file="/includes/header.jsp"%>
<% String ctx = request.getContextPath();%>
<style>
    .user-home {
        background: #fff;
        min-height: 100vh;
        color: #333;
    }
    .user-home .btn-card {
        border: 2px solid #000;
        color: #000;
        background: #fff;
        font-weight: 500;
    }
    .user-home .btn-card:hover {
        background: #000;
        color: #fff;
    }
    .no-content-placeholder {
        background: #f8f9fa;
        border: 2px dashed #dee2e6;
        border-radius: 12px;
        padding: 3rem;
        text-align: center;
        color: #6c757d;
    }
</style>
<%@include file="/includes/navbar.jsp"%>
<div class="user-home">
    <div class="container py-5">
        <h2 class="fw-bold mb-2">${book.bookTitle}</h2>
        <p class="text-muted small mb-4">${book.authorName}</p>

        <c:if test="${param.saved == '1'}">
            <div class="alert alert-success py-2">Đã lưu tiến độ đọc.</div>
        </c:if>
        <c:if test="${param.error == 'save_failed'}">
            <div class="alert alert-danger py-2">Không lưu được tiến độ. Kiểm tra sách có trong My Library và thử lại. Nếu vẫn lỗi, xem log server.</div>
        </c:if>

        <c:set var="contentUrl" value="${book.contentPath}"/>
        <c:if test="${contentUrl != null && !contentUrl.isEmpty() && !fn:startsWith(contentUrl, 'http://') && !fn:startsWith(contentUrl, 'https://')}">
            <c:set var="contentUrl" value="${pageContext.request.contextPath}/jsp/${book.contentPath}"/>
        </c:if>
        <%-- Encode spaces in path so filenames like "George Orwell - 1984.pdf" work in iframe --%>
        <c:if test="${contentUrl != null && !contentUrl.isEmpty()}">
            <c:set var="contentUrl" value="${fn:replace(contentUrl, ' ', '%20')}"/>
        </c:if>
        <c:if test="${book.contentPath != null && !book.contentPath.isEmpty()}">
            <c:if test="${lastPosition > 1}">
                <div class="alert alert-info py-2 d-flex align-items-center gap-2 mb-2">
                    <i class="fa fa-bookmark"></i>
                    <span>Lần trước bạn đọc tới <strong>trang ${lastPosition}</strong><c:if test="${book.bookTotalPages != null}"> / ${book.bookTotalPages}</c:if>.
                        Nhập <strong>${lastPosition}</strong> vào ô số trang trên thanh công cụ PDF để tiếp tục.</span>
                </div>
            </c:if>
            <div class="mb-2">
                <iframe id="pdfViewer" data-url="${contentUrl}" data-page="${lastPosition}" title="${book.bookTitle}" style="width:100%;height:70vh;border:1px solid #ddd;" class="rounded"></iframe>
            </div>
            <div class="d-flex flex-wrap align-items-center gap-2 mb-3 p-2 rounded" style="background:#f8f9fa;">
                <span class="fw-bold small text-secondary">Bookmark:</span>
                <a href="<%= ctx%>/customer/bookmarks?addBookId=${book.bookId}&pageNumber=${lastPosition}" class="btn btn-dark btn-sm">
                    <i class="fa fa-bookmark"></i> Đánh dấu trang ${lastPosition}
                </a>
                <a href="<%= ctx%>/customer/bookmarks" class="btn btn-outline-dark btn-sm">Xem tất cả bookmark</a>
            </div>
        </c:if>
        <c:if test="${book.contentPath == null || book.contentPath.isEmpty()}">
            <div class="no-content-placeholder mb-3">
                <p class="mb-2"><i class="fa fa-book fa-3x text-secondary"></i></p>
                <p class="fw-bold mb-1">Nội dung sách chưa có file</p>
                <p class="small mb-0">Thư viện có thể sẽ cập nhật file PDF sau. Bạn vẫn có thể <strong>lưu tiến độ đọc</strong> bên dưới (ví dụ nếu đọc bản in hoặc khi file đã có).</p>
            </div>
            <div class="d-flex flex-wrap align-items-center gap-2 mb-3 p-2 rounded" style="background:#f8f9fa;">
                <span class="fw-bold small text-secondary">Bookmark:</span>
                <a href="<%= ctx%>/customer/bookmarks?addBookId=${book.bookId}&pageNumber=${lastPosition}" class="btn btn-dark btn-sm">
                    <i class="fa fa-bookmark"></i> Đánh dấu trang ${lastPosition}
                </a>
                <a href="<%= ctx%>/customer/bookmarks" class="btn btn-outline-dark btn-sm">Xem tất cả bookmark</a>
            </div>
        </c:if>

        <div class="card">
            <div class="card-header fw-bold">Lưu tiến độ đọc</div>
            <div class="card-body">
                <p class="small text-muted mb-2">Để lần sau vào lại vẫn ở đúng trang: nhập <strong>số trang bạn vừa đọc tới</strong> (xem trên thanh công cụ PDF) rồi bấm <strong>Lưu tiến độ</strong> trước khi thoát.</p>
                <form id="saveProgressForm" action="<%= ctx%>/customer/read" method="post" class="row g-2 align-items-end">
                    <input type="hidden" name="bookId" value="${book.bookId}">
                    <div class="col-auto">
                        <label class="form-label">Trang đã đọc đến</label>
                        <input type="number" name="position" id="positionInput" value="${lastPosition}" min="1" max="${book.bookTotalPages != null ? book.bookTotalPages : 9999}" class="form-control" style="width:100px">
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
        <div class="mt-3">
            <a href="<%= ctx%>/customer/my-library" class="btn btn-outline-dark">Về My Library</a>
            <a href="<%= ctx%>/customer/reading-history" class="btn btn-outline-dark">Lịch sử đọc</a>
            <a href="<%= ctx%>/customer/bookmarks" class="btn btn-outline-dark">Bookmarks</a>
        </div>
    </div>
</div>
<script>
    (function () {
        var iframe = document.getElementById('pdfViewer');
        if (!iframe)
            return;
        var url = iframe.getAttribute('data-url');
        var page = iframe.getAttribute('data-page') || '1';
        iframe.src = url + '?t=' + Date.now() + '#page=' + page;
    })();
</script>
<%@include file="/includes/footer.jsp"%>

