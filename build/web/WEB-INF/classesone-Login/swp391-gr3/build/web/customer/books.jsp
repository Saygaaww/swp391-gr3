<%--
    Document   : books
    Book list for user - click to go to detail
--%>
<%@page import="model.Reader"%>
<%@page import="model.Book"%>
<%@page import="java.util.List"%>
<%@include file="/includes/header.jsp"%>

<%
    Reader user = (Reader) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
%>

<%@include file="/includes/navbar.jsp"%>

<div class="container my-5">
    <h2 class="mb-4">Library Books</h2>
    <p class="text-muted">Click a book to view details and request to borrow.</p>

    <div class="row g-4">
        <%
            List<Book> books = (List<Book>) request.getAttribute("books");
            if (books != null && !books.isEmpty()) {
                for (Book b : books) {
        %>
        <div class="col-md-4 col-lg-3">
            <div class="card h-100 shadow-sm">
                <% if (b.getCoverUrl() != null && !b.getCoverUrl().isEmpty()) { %>
                    <img src="<%= b.getCoverUrl() %>" class="card-img-top" alt="<%= b.getTitle() %>" style="height: 200px; object-fit: cover;">
                <% } else { %>
                    <div class="card-img-top bg-light d-flex align-items-center justify-content-center" style="height: 200px;">
                        <i class="fa fa-book fa-3x text-secondary"></i>
                    </div>
                <% } %>
                <div class="card-body">
                    <h6 class="card-title text-truncate" title="<%= b.getTitle() %>"><%= b.getTitle() %></h6>
                    <% if (b.getAuthorName() != null) { %>
                        <p class="card-text small text-muted"><%= b.getAuthorName() %></p>
                    <% } %>
                    <a href="<%= request.getContextPath() %>/BookDetailServlet?id=<%= b.getBookId() %>" class="btn btn-outline-dark btn-sm w-100">View Details</a>
                </div>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div class="col-12">
            <div class="alert alert-info">No books available.</div>
        </div>
        <% } %>
    </div>
</div>

<%@include file="/includes/footer.jsp"%>
