<%-- 
    Document   : home
    Created on : Jan 27, 2026, 1:36:27 AM
    Author     : admin
--%>

<%@page import="model.Reader"%>
<%@include file="/includes/header.jsp"%>

<%
    Reader user = (Reader) session.getAttribute("user");
    if (user == null || !"USER".equalsIgnoreCase(user.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
%>

<%@include file="/includes/navbar.jsp"%>

<div class="container my-5">
    <h2>Welcome to Digital Library</h2>
    <p>Hello, <b><%= user.getFullName() %></b></p>

    <div class="row mt-4">
        <div class="col-md-4">
            <div class="card p-4 shadow text-center">
                <h5>Browse Books</h5>
                <p>View details and request to borrow</p>
                <a href="<%= request.getContextPath() %>/BookListServlet" class="btn btn-outline-dark">View Books</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 shadow text-center">
                <h5>Borrow History</h5>
                <p>Books you have borrowed or are borrowing</p>
                <a href="<%= request.getContextPath() %>/MyBorrowHistoryServlet" class="btn btn-outline-dark">My Borrow History</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 shadow text-center">
                <h5>My Profile</h5>
                <p>Update your information</p>
                <a href="#" class="btn btn-outline-dark">Profile</a>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp"%>
