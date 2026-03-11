<%--
    Browse Books - Duyệt danh mục sách theo theme đen/trắng
--%>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/includes/header.jsp"%>
<%
    String ctx = request.getContextPath();
%>
<style>
    .user-home { background: #fff; min-height: 100vh; color: #333; }
    .user-home .card { border: 1px solid #e0e0e0; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); transition: box-shadow 0.2s; }
    .user-home .card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.12); }
    .user-home .btn-card { border: 2px solid #000; color: #000; background: #fff; font-weight: 500; }
    .user-home .btn-card:hover { background: #000; color: #fff; }
</style>
<%@include file="/includes/navbar.jsp"%>

<div class="user-home">
<div class="container py-5">
    <h2 class="fw-bold mb-4">Browse Books</h2>

    <form action="${pageContext.request.contextPath}/customer/browse-books" method="get" class="row g-2 mb-3">
        <div class="col-md-7">
            <input type="text" name="keyword" value="${keyword}" class="form-control" placeholder="Search by title, author, keyword...">
        </div>
        <div class="col-md-2">
            <select name="category" class="form-select">
                <option value="">All categories</option>
                <c:forEach items="${categories}" var="c">
                    <option value="${c.categoryId}" ${selectedCategory == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                </c:forEach>
            </select>
        </div>
        <input type="hidden" name="pageSize" value="${pageSize}">
        <div class="col-md-1">
            <button type="submit" class="btn btn-dark w-100">Search</button>
        </div>
    </form>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <span class="text-muted small">${totalBooks} sách — Trang ${currentPage} / ${totalPages}</span>
        <div class="btn-group btn-group-sm">
            <a href="${pageContext.request.contextPath}/customer/browse-books?pageSize=4&keyword=${keyword}&category=${selectedCategory}"
               class="btn ${pageSize == 4 ? 'btn-dark' : 'btn-outline-dark'}">4 / trang</a>
            <a href="${pageContext.request.contextPath}/customer/browse-books?pageSize=8&keyword=${keyword}&category=${selectedCategory}"
               class="btn ${pageSize == 8 ? 'btn-dark' : 'btn-outline-dark'}">8 / trang</a>
        </div>
    </div>

    <div class="row g-4">
        <c:choose>
            <c:when test="${empty books}">
                <p class="text-muted">No books found.</p>
            </c:when>
            <c:otherwise>
                <c:forEach items="${books}" var="b">
                    <div class="col-md-3">
                        <div class="card h-100 shadow-sm">
                            <a href="${pageContext.request.contextPath}/customer/book-detail?bookId=${b.bookId}">
                                <img src="${b.coverUrl != null && !b.coverUrl.isEmpty() ? b.coverUrl : 'https://via.placeholder.com/200x280?text=No+Cover'}" class="card-img-top" alt="${b.title}" style="height:200px;object-fit:cover;">
                            </a>
                            <div class="card-body">
                                <h6 class="card-title"><a href="${pageContext.request.contextPath}/customer/book-detail?bookId=${b.bookId}" class="text-dark text-decoration-none">${b.title}</a></h6>
                                <p class="text-muted small mb-2">${b.authorName}</p>
                                <p class="mb-2"><fmt:formatNumber value="${b.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" minFractionDigits="0"/></p>
                                <p class="small text-secondary mb-2">Còn ${b.stockQuantity} cuốn</p>
                                <c:choose>
                                    <c:when test="${b.stockQuantity <= 0}">
                                        <span class="btn btn-outline-secondary btn-sm w-100 disabled">Hết hàng</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/customer/add-to-cart?bookId=${b.bookId}&quantity=1" class="btn btn-card btn-sm w-100">Thêm vào giỏ</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <c:if test="${totalPages > 1}">
        <nav class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link text-dark" href="${pageContext.request.contextPath}/customer/browse-books?page=${currentPage - 1}&pageSize=${pageSize}&keyword=${keyword}&category=${selectedCategory}">&laquo;</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link ${currentPage == i ? 'bg-dark border-dark' : 'text-dark'}" href="${pageContext.request.contextPath}/customer/browse-books?page=${i}&pageSize=${pageSize}&keyword=${keyword}&category=${selectedCategory}">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link text-dark" href="${pageContext.request.contextPath}/customer/browse-books?page=${currentPage + 1}&pageSize=${pageSize}&keyword=${keyword}&category=${selectedCategory}">&raquo;</a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>
</div>

<%@include file="/includes/footer.jsp"%>
