<%--
    Document   : login
--%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@include file="/includes/header.jsp"%>

<div class="container d-flex justify-content-center align-items-center vh-100">
    <form class="card p-4 shadow"
          action="<%=request.getContextPath()%>/LoginServlet"
          method="post"
          style="width: 400px;">

        <h3 class="text-center mb-3">Đăng nhập</h3>

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

        <button class="btn btn-dark w-100 mb-2">
            Đăng nhập
        </button>

        <a href="<%=request.getContextPath()%>/auth/forgot-password.jsp">
            Quên mật khẩu?
        </a>

        <br>

        <a href="<%=request.getContextPath()%>/GoogleLoginServlet"
           class="btn btn-danger w-100">
            <i class="fab fa-google"></i> Đăng nhập bằng Google
        </a>

        <p class="mt-3 text-center">
            Chưa có tài khoản?
            <a href="<%=request.getContextPath()%>/RegisterServlet">Đăng ký</a>
        </p>
    </form>
</div>

<%@include file="/includes/footer.jsp"%>
