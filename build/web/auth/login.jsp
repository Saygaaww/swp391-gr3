<%-- 
    Document   : login
    Created on : Jan 26, 2026, 4:35:00 PM
    Author     : admin
--%>

<%@include file="/includes/header.jsp"%>

<div class="container d-flex justify-content-center align-items-center vh-100">
    <form class="card p-4 shadow"
          action="<%=request.getContextPath()%>/LoginServlet"
          method="post"
          style="width: 400px;">

        <h3 class="text-center mb-3">Login</h3>

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

        <!-- Error -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger text-center">
                ${error}
            </div>
        </c:if>

        <button class="btn btn-dark w-100 mb-2">
            Login
        </button>

        <a href="<%=request.getContextPath()%>/auth/forgot-password.jsp">
            Forget password?
        </a>

        <br><!-- comment -->


        <!-- Google login -->
        <a href="<%=request.getContextPath()%>/GoogleLoginServlet"
           class="btn btn-danger w-100">
            <i class="fab fa-google"></i> Login with Google
        </a>

        <p class="mt-3 text-center">
            No account?
            <a href="<%=request.getContextPath()%>/RegisterServlet">Register</a>
        </p>
    </form>
</div>

<%@include file="/includes/footer.jsp"%>
