<%-- 
    Document   : register
    Created on : Jan 26, 2026, 4:35:09 PM
    Author     : admin
--%>

<%@include file="/includes/header.jsp"%>

<div class="container d-flex justify-content-center align-items-center vh-100">
    <form class="card p-4 shadow"
          action="<%=request.getContextPath()%>/RegisterServlet"
          method="post"
          style="width: 400px;">

        <h3 class="text-center mb-3">Register</h3>

        <!-- Full name -->
        <input class="form-control mb-3"
               name="fullName"
               placeholder="Full name"
               required>

        <!-- Email -->
        <input class="form-control mb-3"
               type="email"
               name="email"
               placeholder="Email address"
               required>

        <!-- Password -->
        <input class="form-control mb-3"
               type="password"
               name="password"
               placeholder="Password"
               required>

        <!-- Error message -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger text-center">
                ${error}
            </div>
        </c:if>

        <button class="btn btn-dark w-100">
            Register
        </button>

        <p class="mt-3 text-center">
            Already have an account?
            <a href="<%=request.getContextPath()%>/login">Login</a>
        </p>
    </form>
</div>

<%@include file="/includes/footer.jsp"%>
