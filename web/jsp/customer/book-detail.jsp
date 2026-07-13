<%-- Book Detail - Chi tiết sách --%>
    <%@ page language="java" pageEncoding="UTF-8" %>
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
                <%@include file="/includes/header.jsp" %>
                    <% String ctx=request.getContextPath(); %>
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
                                    <c:if test="${empty book}">
                                        <p class="text-muted">Không tìm thấy sách.</p>
                                        <a href="<%= ctx %>/customer/browse-books" class="btn btn-card">Duyệt sách</a>
                                    </c:if>

                                    <c:if test="${not empty book}">
                                        <div class="row mb-4">
                                            <div class="col-md-4">
                                                <img src="${not empty book.coverUrl ? book.coverUrl : 'https://via.placeholder.com/300x400?text=No+Cover'}"
                                                    class="img-fluid rounded shadow-sm" alt="${book.title}"
                                                    style="max-height:420px;object-fit:cover;">
                                            </div>
                                            <div class="col-md-8">
                                                <h1 class="fw-bold mb-2">${book.title}</h1>
                                                <p class="text-muted mb-1"><strong>Tác giả:</strong> ${not empty
                                                    book.authorName ? book.authorName : '—'}</p>
                                                <p class="text-muted mb-1"><strong>Thể loại:</strong> ${not empty
                                                    book.categoryName ? book.categoryName : '—'}</p>
                                                <p class="mb-2"><strong>Giáá:</strong>
                                                    <fmt:formatNumber value="${book.price}" type="currency"
                                                        currencySymbol="₫" />
                                                    <c:if test="${not empty book.currency}">(${book.currency})</c:if>
                                                </p>
                                                <p class="text-secondary mb-3">Còn ${book.stockQuantity} cuốn</p>

                                                <c:if test="${not empty book.summary}">
                                                    <h6 class="fw-bold mt-3">Tóm tắt</h6>
                                                    <p class="text-secondary">${book.summary}</p>
                                                </c:if>

                                                <c:choose>
                                                    <c:when test="${book.stockQuantity <= 0}">
                                                        <button type="button"
                                                            class="btn btn-outline-secondary disabled">Hết hàng</button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <form action="<%= ctx %>/customer/cart/add" method="post"
                                                            class="d-flex align-items-center">
                                                            <input type="hidden" name="bookId" value="${book.bookId}">
                                                            <input type="number" name="quantity" value="1" min="1"
                                                                max="${book.stockQuantity}" class="form-control me-2"
                                                                style="width: 80px;">
                                                            <button type="submit" class="btn btn-card">Thêm vào
                                                                giỏ?</button>
                                                        </form>
                                                    </c:otherwise>
                                                </c:choose>
                                                <a href="<%= ctx %>/customer/browse-books"
                                                    class="btn btn-outline-dark ms-2">Duyệt sách</a>
                                            </div>
                                        </div>

                                        <c:if test="${not empty book.description}">
                                            <div class="card mb-4">
                                                <div class="card-header fw-bold">Mô tả</div>
                                                <div class="card-body">
                                                    <p class="mb-0">${book.description}</p>
                                                </div>
                                            </div>
                                        </c:if>

                                        <div class="card">
                                            <div class="card-header fw-bold">Đánh giá (${not empty reviews ?
                                                reviews.size() : 0})</div>
                                            <div class="card-body">
                                                <c:choose>
                                                    <c:when test="${empty reviews}">
                                                        <p class="text-muted mb-0">Chưa có đánh giá nào.</p>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <ul class="list-group list-group-flush">
                                                            <c:forEach items="${reviews}" var="r">
                                                                <li class="list-group-item px-0">
                                                                    <div class="d-flex justify-content-between">
                                                                        <strong>${r.readerName}</strong>
                                                                        <span class="text-warning">
                                                                            <c:forEach begin="1"
                                                                                end="${r.rating != null ? r.rating : 0}">
                                                                                ★</c:forEach>
                                                                            <c:forEach
                                                                                begin="${r.rating != null ? r.rating + 1 : 1}"
                                                                                end="5">☆</c:forEach>
                                                                        </span>
                                                                    </div>
                                                                    <c:if test="${not empty r.comment}">
                                                                        <p class="mb-0 mt-1">${r.comment}</p>
                                                                    </c:if>
                                                                    <small class="text-muted">${r.createdAt}</small>
                                                                </li>
                                                            </c:forEach>
                                                        </ul>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${not empty sessionScope.user}">
                                                    <p class="mt-3 mb-0"><a href="<%= ctx %>/customer/reviews">Viết đánh
                                                            giá</a></p>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            <%@include file="/includes/footer.jsp" %>
