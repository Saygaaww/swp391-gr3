<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Management - Seller</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background: #f0f0f0; color: #333; }
        .sidebar-panel { min-height: 100vh; background: #fff; border-right: 1px solid #e0e0e0; }
        .sidebar-panel a { color: #333; padding: 12px 20px; display: block; text-decoration: none; }
        .sidebar-panel a:hover, .sidebar-panel a.active { background: #e8e8e8; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-2 sidebar-panel p-0">
                <div class="p-4">
                    <h4 class="text-dark mb-4"><i class="fas fa-store"></i> Seller Panel</h4>
                </div>
                <nav>
                    <a href="<%= request.getContextPath() %>/home"><i class="fas fa-home"></i> Home</a>
                    <a href="<%= request.getContextPath() %>/seller/dashboard"><i class="fas fa-dashboard"></i> Dashboard</a>
                    <a href="<%= request.getContextPath() %>/seller/books" class="active"><i class="fas fa-book"></i> Books</a>
                    <a href="<%= request.getContextPath() %>/seller/orders"><i class="fas fa-shopping-cart"></i> Orders</a>
                    <a href="<%= request.getContextPath() %>/seller/sales-report"><i class="fas fa-chart-line"></i> Sales Report</a>
                    <a href="<%= request.getContextPath() %>/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </nav>
            </div>

            <div class="col-md-10 p-4">
                <h2 class="mb-4"><i class="fas fa-book"></i> Book Management</h2>

                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show">
                        ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <% session.removeAttribute("successMessage"); %>
                </c:if>

                <!-- Add / Edit Form -->
                <div class="card mb-4 border border-secondary border-opacity-25">
                    <div class="card-header bg-white border-bottom border-secondary border-opacity-25">
                        <h5 class="mb-0">${not empty editBook ? 'Edit Book' : 'Add New Book'}</h5>
                    </div>
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/seller/books" method="post">
                            <input type="hidden" name="action" value="${not empty editBook ? 'update' : 'add'}">
                            <c:if test="${not empty editBook}">
                                <input type="hidden" name="bookId" value="${editBook.bookId}">
                            </c:if>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label">Title *</label>
                                    <input type="text" name="title" class="form-control" required
                                           value="${not empty editBook ? editBook.title : ''}">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Author</label>
                                    <select name="authorId" class="form-select">
                                        <option value="">-- Select --</option>
                                        <c:forEach items="${authors}" var="a">
                                            <option value="${a.authorId}" ${not empty editBook && editBook.authorId == a.authorId ? 'selected' : ''}>${a.authorName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Category</label>
                                    <select name="categoryId" class="form-select">
                                        <option value="">-- Select --</option>
                                        <c:forEach items="${categories}" var="c">
                                            <option value="${c.categoryId}" ${not empty editBook && editBook.categoryId == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Price</label>
                                    <input type="number" step="0.01" name="price" class="form-control" min="0"
                                           value="${not empty editBook ? editBook.price : ''}">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Currency</label>
                                    <input type="text" name="currency" class="form-control" maxlength="10"
                                           value="${not empty editBook ? editBook.currency : 'VND'}">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Stock</label>
                                    <input type="number" name="stockQuantity" class="form-control" min="0"
                                           value="${not empty editBook ? editBook.stockQuantity : '0'}">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Total Pages</label>
                                    <input type="number" name="totalPages" class="form-control" min="0"
                                           value="${not empty editBook ? editBook.totalPages : ''}">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Preview Pages</label>
                                    <input type="number" name="previewPages" class="form-control" min="0"
                                           value="${not empty editBook ? editBook.previewPages : ''}">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Status</label>
                                    <select name="status" class="form-select">
                                        <option value="active" ${not empty editBook && editBook.status == 'active' ? 'selected' : ''}>Active</option>
                                        <option value="inactive" ${not empty editBook && editBook.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Cover URL</label>
                                    <input type="text" name="coverUrl" class="form-control"
                                           value="${not empty editBook ? editBook.coverUrl : ''}">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Summary</label>
                                    <input type="text" name="summary" class="form-control"
                                           value="${not empty editBook ? editBook.summary : ''}">
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Description</label>
                                    <textarea name="description" class="form-control" rows="3">${not empty editBook ? editBook.description : ''}</textarea>
                                </div>
                                <div class="col-12">
                                    <button type="submit" class="btn btn-dark">
                                        <i class="fas fa-save"></i> ${not empty editBook ? 'Update Book' : 'Add Book'}
                                    </button>
                                    <c:if test="${not empty editBook}">
                                        <a href="<%= request.getContextPath() %>/seller/books" class="btn btn-outline-secondary ms-2">Cancel</a>
                                    </c:if>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Book List -->
                <div class="card border border-secondary border-opacity-25">
                    <div class="card-header bg-white border-bottom border-secondary border-opacity-25">
                        <h5 class="mb-0">All Books (${books.size()})</h5>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty books}">
                                <p class="text-muted p-3 mb-0">No books yet.</p>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Cover</th>
                                                <th>Title</th>
                                                <th>Author</th>
                                                <th>Category</th>
                                                <th class="text-end">Price</th>
                                                <th class="text-center">Stock</th>
                                                <th class="text-center">Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${books}" var="b">
                                                <tr>
                                                    <td>${b.bookId}</td>
                                                    <td>
                                                        <c:if test="${not empty b.coverUrl}">
                                                            <img src="${b.coverUrl}" alt="" style="width:40px;height:55px;object-fit:cover;" class="rounded">
                                                        </c:if>
                                                    </td>
                                                    <td>${b.title}</td>
                                                    <td>${b.authorName}</td>
                                                    <td>${b.categoryName}</td>
                                                    <td class="text-end"><fmt:formatNumber value="${b.price}" type="currency" currencySymbol="₫" maxFractionDigits="0" minFractionDigits="0"/></td>
                                                    <td class="text-center">
                                                        <span class="${b.stockQuantity <= 0 ? 'text-danger fw-bold' : ''}">${b.stockQuantity}</span>
                                                    </td>
                                                    <td class="text-center">
                                                        <span class="badge ${b.status == 'active' ? 'bg-success' : 'bg-secondary'}">${b.status}</span>
                                                    </td>
                                                    <td>
                                                        <a href="<%= request.getContextPath() %>/seller/books?action=edit&bookId=${b.bookId}" class="btn btn-sm btn-outline-dark" title="Edit">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <form action="<%= request.getContextPath() %>/seller/books" method="post" style="display:inline;">
                                                            <input type="hidden" name="action" value="toggleStatus">
                                                            <input type="hidden" name="bookId" value="${b.bookId}">
                                                            <button type="submit" class="btn btn-sm ${b.status == 'active' ? 'btn-outline-warning' : 'btn-outline-success'}" title="${b.status == 'active' ? 'Deactivate' : 'Activate'}">
                                                                <i class="fas ${b.status == 'active' ? 'fa-ban' : 'fa-check'}"></i>
                                                            </button>
                                                        </form>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
