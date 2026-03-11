<%-- verify-otp --%>
<%@page pageEncoding="UTF-8"%>
<%@include file="/includes/header.jsp"%>

<div class="container d-flex justify-content-center align-items-center vh-100">
    <form class="card p-4 shadow"
          action="<%=request.getContextPath()%>/VerifyOtpServlet"
          method="post"
          style="width: 350px;">

        <h4 class="text-center mb-2">Xác thực số điện thoại</h4>

        <p class="text-center text-muted">
            Mã OTP đã được gửi đến số điện thoại của bạn
        </p>

        <input class="form-control mb-3"
               name="otp"
               placeholder="Nhập mã OTP 6 số"
               pattern="[0-9]{6}"
               required>

        <button class="btn btn-success w-100">
            Xác thực
        </button>
    </form>
</div>

<%@include file="/includes/footer.jsp"%>
