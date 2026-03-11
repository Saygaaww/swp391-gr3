<%--
    Document   : register
--%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@include file="/includes/header.jsp"%>

<div class="container d-flex justify-content-center align-items-center vh-100">
    <form class="card p-4 shadow"
          action="<%=request.getContextPath()%>/RegisterServlet"
          method="post"
          style="width: 400px;">

        <h3 class="text-center mb-3">Đăng ký</h3>

        <input class="form-control mb-3"
               name="fullName"
               placeholder="Họ và tên"
               required>

        <input class="form-control mb-3"
               type="email"
               name="email"
               placeholder="Email"
               required>

        <input class="form-control mb-3"
               type="password"
               name="password"
               placeholder="Mật khẩu"
               required>

        <c:if test="${not empty error}">
            <div class="alert alert-danger text-center">
                ${error}
            </div>
        </c:if>

        <button class="btn btn-dark w-100">
            Đăng ký
        </button>

        <p class="mt-3 text-center">
            Đã có tài khoản?
            <a href="<%=request.getContextPath()%>/login">Đăng nhập</a>
        </p>
    </form>
</div>

<%@include file="/includes/footer.jsp"%>
