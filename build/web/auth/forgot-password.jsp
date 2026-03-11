<%-- 
    Document   : forgot-password
    Created on : Feb 2, 2026, 8:41:55 PM
    Author     : admin
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<form action="<%=request.getContextPath()%>/ResetPasswordServlet" method="post">
    <h3>Quên mật khẩu</h3>

    <label>Email của bạn:</label>
    <input type="email" name="email"
           value="${email}"
           required
           <c:if test="${showOtpForm}">readonly</c:if> />

    <br/><br/>

    <c:if test="${showOtpForm}">
        <label>Mã OTP:</label>
        <input type="text" name="otp" required />

        <br/><br/>

        <label>Mật khẩu mới:</label>
        <input type="password" name="newPassword" required />

        <br/><br/>

        <button type="submit">Đặt lại mật khẩu</button>
    </c:if>

    <c:if test="${!showOtpForm}">
        <button type="submit">Gửi mã OTP</button>
    </c:if>

    <p style="color:red">${error}</p>
    <p style="color:green">${message}</p>
</form>
