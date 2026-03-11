<%-- 
    Document   : home
    Created on : Jan 27, 2026, 1:36:40 AM
    Author     : admin
--%>

<%@page import="model.Reader"%>
<%@include file="/includes/header.jsp"%>

<%
    Reader user = (Reader) session.getAttribute("user");
    if (user == null || !"LIBRARIAN".equalsIgnoreCase(user.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
%>

<%@include file="/includes/navbar.jsp"%>

<div class="container my-5">
    <h2>Librarian Dashboard</h2>
    <p>Hello, <b><%= user.getFullName() %></b></p>

    <div class="row mt-4">
        <div class="col-md-4">
            <div class="card p-4 shadow">
                <h5>Manage Books</h5>
                <p>Add / update library books</p>
                <a href="#" class="btn btn-primary">Books</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 shadow">
                <h5>Borrow Requests</h5>
                <p>Approve or reject borrow requests</p>
                <a href="<%= request.getContextPath() %>/PendingBorrowRequestsServlet" class="btn btn-primary">View Requests</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 shadow">
                <h5>Reports</h5>
                <p>Library statistics</p>
                <a href="#" class="btn btn-primary">Reports</a>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp"%>
