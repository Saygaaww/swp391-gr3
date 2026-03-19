<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Kết quả thanh toán VNPay</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container py-5">
            <div class="card shadow">
                <div class="card-body text-center p-5">
                    <% if (Boolean.TRUE.equals(request.getAttribute("success"))) {%>
                    <h2 class="text-success mb-3">Thanh toán thành công</h2>
                    <p class="text-muted">${message}</p>
                    <a href="<%= request.getContextPath()%>/customer/orders" class="btn btn-primary mt-3">Xem đơn hàng</a>
                    <% } else {%>
                    <h2 class="text-danger mb-3">Thanh toán thất bại</h2>
                    <p class="text-muted">${message}</p>
                    <a href="<%= request.getContextPath()%>/customer/cart" class="btn btn-outline-secondary mt-3">Quay lại giỏ hàng</a>
                    <% }%>
                    <a href="<%= request.getContextPath()%>/" class="btn btn-outline-primary mt-3">Về trang chủ</a>
                </div>
            </div>
        </div>
    </body>
</html>
