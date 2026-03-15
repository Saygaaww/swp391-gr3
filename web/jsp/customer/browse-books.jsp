<%-- Browse Books - Modern layout --%>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@include file="/includes/header.jsp" %>
<% String ctx=request.getContextPath(); %>

<%@include file="/includes/navbar.jsp" %>

<div class="books-page">
    <div class="container">
        <div class="books-hero">
            <div class="d-flex flex-wrap justify-content-between align-items-end gap-3">
                <div>
                    <h2 class="fw-bold">Browse Books</h2>
                    <p class="books-subtitle">Tìm sách theo tên, tác giả hoặc thể loại. Thêm vào giỏ chỉ với 1 click.</p>
                </div>
                <c:if test="${not empty books}">
                    <div class="meta-pill">
                        <i class="fa-solid fa-layer-group"></i>
                        ${books.size()} kết quả
                    </div>
                </c:if>
            </div>
        </div>

        <div class="books-toolbar">
            <form action="<%= ctx %>/customer/browse-books" method="get" class="row g-2 align-items-center">
                <div class="col-lg-7">
                    <div class="input-group">
                        <span class="input-group-text"
                            style="border-radius:14px 0 0 14px; border:1px solid rgba(17,24,39,0.12); background:#fff;">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </span>
                        <input type="text" name="keyword" value="${keyword}" class="form-control"
                            placeholder="Tìm theo tên sách, tác giả, từ khóa...">
                    </div>
                </div>
                <div class="col-lg-3">
                    <select name="category" class="form-select">
                        <option value="">All categories</option>
                        <c:forEach items="${categories}" var="c">
                            <option value="${c.categoryId}" ${selectedCategory==c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-lg-2 d-grid">
                    <button type="submit" class="btn-books-primary">
                        <i class="fa-solid fa-filter"></i>
                        Search
                    </button>
                </div>
            </form>
        </div>

        <c:choose>
            <c:when test="${empty books}">
                <div class="book-section text-center">
                    <div class="no-results-content">
                        <i class="fa-solid fa-book-open-reader fa-3x mb-3"></i>
                        <h4>Không tìm thấy sách phù hợp</h4>
                        <p>Hãy thử từ khóa khác hoặc chọn một thể loại khác.</p>
                        <a class="btn-books-outline" href="<%= ctx %>/customer/browse-books">
                            <i class="fa-solid fa-rotate-right"></i>
                            Xem tất cả
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-3 g-md-4 row-cols-2 row-cols-md-3 row-cols-lg-4">
                    <c:forEach items="${books}" var="b">
                        <div class="col">
                            <div class="book-card">
                                <a href="<%= ctx %>/customer/book-detail?bookId=${b.bookId}" class="book-cover">
                                    <c:choose>
                                        <c:when test="${not empty b.coverUrl}">
                                            <img src="${b.coverUrl}" alt="${b.title}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://via.placeholder.com/360x480/EEF2FF/111827?text=No+Cover" alt="${b.title}">
                                        </c:otherwise>
                                    </c:choose>
                                    <c:choose>
                                        <c:when test="${b.stockQuantity <= 0}">
                                            <span class="book-badge out">Hết hàng</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="book-badge">Còn ${b.stockQuantity}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                                <div class="book-card-body">
                                    <div class="book-title">
                                        <a href="<%= ctx %>/customer/book-detail?bookId=${b.bookId}" style="color:inherit;">
                                            ${b.title}
                                        </a>
                                    </div>
                                    <div class="book-author">
                                        <i class="fa-regular fa-pen-to-square me-1"></i>
                                        ${b.authorName}
                                    </div>

                                    <div class="book-price-row">
                                        <div class="book-price">
                                            <fmt:formatNumber value="${b.price}" type="currency" currencySymbol="₫" />
                                        </div>
                                        <div class="book-stock">Kho</div>
                                    </div>

                                    <c:choose>
                                        <c:when test="${b.stockQuantity <= 0}">
                                            <button type="button" class="btn-books-outline book-cta" disabled
                                                style="opacity:.6; cursor:not-allowed;">
                                                <i class="fa-solid fa-ban"></i>
                                                Hết hàng
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="<%= ctx %>/customer/cart/add" method="post" class="m-0">
                                                <input type="hidden" name="bookId" value="${b.bookId}">
                                                <input type="hidden" name="quantity" value="1">
                                                <button type="submit" class="btn-books-primary book-cta"
                                                    style="background:linear-gradient(135deg,#10b981,#059669);">
                                                    <i class="fa-solid fa-cart-plus"></i>
                                                    Thêm vào giỏ
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
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