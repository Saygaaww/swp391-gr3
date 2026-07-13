<%-- My Library - Sách sở hữu (Reader_Book_Ownership) --%>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@include file="/includes/header.jsp" %>
<% String ctx = request.getContextPath();%>
<style>
    .user-home {
        background: #fff;
        min-height: 100vh;
        color: #333;
    }

    .user-home .card {
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
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
</style>
<%@include file="/includes/navbar.jsp" %>
<div class="user-home">
    <div class="container py-5">
        <h2 class="fw-bold mb-4">My Library (Owned Books)</h2>
        <p class="text-muted">Sách bạn sở hữu vĩnh viễn. Mua qua đơn hàng sẽ tự thêm vào
            đây.</p>

        <c:choose>
            <c:when test="${empty ownedBooks}">
                <p class="text-muted">Chưa có sách nào. Mua sách để sở hữu và đọc.</p>
                <a href="<%= ctx%>/books" class="btn btn-card">Mua sách</a>
                <a href="<%= ctx%>" class="btn btn-card">Về Trang chủ</a>
            </c:when>
            <c:otherwise>
                <div class="row g-3">
                    <c:forEach items="${ownedBooks}" var="o">
                        <div class="col-md-3">
                            <div class="card h-100">
                                <img src="${o.bookCoverUrl != null && !o.bookCoverUrl.isEmpty() ? o.bookCoverUrl : 'https://via.placeholder.com/200x280?text=No+Cover'}"
                                     class="card-img-top" alt="${o.bookTitle}"
                                     style="height:200px;object-fit:cover;">
                                <div class="card-body">
                                    <h6 class="card-title">${o.bookTitle}</h6>
                                    <p class="text-muted small mb-1">${o.authorName}</p>
                                    <p class="small text-secondary mb-2">Sở hữu:
                                        ${o.acquiredAt}</p>
                                    <a href="<%= ctx%>/customer/read?bookId=${o.bookId}"
                                       class="btn btn-card btn-sm w-100">Đọc sách</a>
                                    <a href="<%= ctx%>/customer/bookmarks?addBookId=${o.bookId}"
                                       class="btn btn-outline-dark btn-sm w-100 mt-1">Thêm
                                        bookmark</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<%@include file="/includes/footer.jsp" %>
