<%-- 
    Document   : forgot-password
    Created on : Feb 2, 2026, 8:41:55 PM
    Author     : admin
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<form action="<%=request.getContextPath()%>/reset-password" method="post">
    <h3>Forget password</h3>

    <!-- EMAIL -->
    <label>Your Email Address:</label>
    <input type="email" name="email"
           value="${email}"
           required
           <c:if test="${showOtpForm}">readonly</c:if> />

    <br/><br/>

    <!-- OTP + NEW PASSWORD -->
    <c:if test="${showOtpForm}">
        <label>OTP Code:</label>
        <input type="text" name="otp" required />

        <br/><br/>

        <label>New Password:</label>
        <input type="password" name="newPassword" required />

        <br/><br/>

        <button type="submit">Reset Password</button>
    </c:if>

    <!-- SEND OTP -->
    <c:if test="${!showOtpForm}">
        <button type="submit">Send OTP</button>
    </c:if>

    <p style="color:red">${error}</p>
    <p style="color:green">${message}</p>
</form>
