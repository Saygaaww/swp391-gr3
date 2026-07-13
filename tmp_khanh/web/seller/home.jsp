<%-- 
    Document   : home
    Created on : Jan 27, 2026, 1:38:41 AM
    Author     : admin
--%>
<%@ page pageEncoding="UTF-8" %>
<%@page import="model.User"%>
<%@include file="/includes/header.jsp"%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"SELLER".equalsIgnoreCase(user.getRoleName())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<%@include file="/includes/navbar.jsp"%>

<div class="container my-5">
    <h2>? Seller Dashboard</h2>
    <p>Welcome back, <b><%= user.getFullName() %></b></p>

    <div class="row mt-4">
        <div class="col-md-4">
            <div class="card p-4 shadow">
                <h5>My Books</h5>
                <p>Manage books you sell</p>
                <a href="#" class="btn btn-dark">Manage</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 shadow">
                <h5>Orders</h5>
                <p>Customer orders</p>
                <a href="#" class="btn btn-dark">View Orders</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-4 shadow">
                <h5>Revenue</h5>
                <p>Sales statistics</p>
                <a href="#" class="btn btn-dark">View Report</a>
            </div>
        </div>
    </div>
</div>

<%@include file="/includes/footer.jsp"%>
