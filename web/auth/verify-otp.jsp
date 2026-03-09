<%-- 
    Document   : verify-otp
    Created on : Jan 26, 2026, 4:35:21 PM
    Author     : admin
--%>

<%@include file="/includes/header.jsp"%>

<div class="container d-flex justify-content-center align-items-center vh-100">
    <form class="card p-4 shadow"
          action="<%=request.getContextPath()%>/register"
          method="post"
          style="width: 350px;">

        <h4 class="text-center mb-2">Verify Phone Number</h4>

        <p class="text-center text-muted">
            OTP has been sent to your phone
        </p>

        <input class="form-control mb-3"
               name="otp"
               placeholder="Enter 6-digit OTP"
               pattern="[0-9]{6}"
               required>

        <button class="btn btn-success w-100">
            Verify
        </button>
    </form>
</div>

<%@include file="/includes/footer.jsp"%>
