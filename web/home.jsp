<%-- 
    Document   : home
    Created on : Jan 26, 2026, 3:15:51 PM
    Author     : admin
--%>

<%@page import="model.Reader"%>
<%@include file="/includes/header.jsp"%>

<%
    Reader user = (Reader) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@include file="/includes/navbar.jsp"%>

<div class="container my-5">
    <h2>Admin Dashboard</h2>
    <p>Welcome, <b><%= user.getFullName() %></b></p>

    <div class="row">
        <div class="col-md-4">
            <div class="card p-3 shadow">Total Users</div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 shadow">Total Books</div>
        </div>
        <div class="col-md-4">
            <div class="card p-3 shadow">Reports</div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp"%>
