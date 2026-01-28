<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Thư viện Số FPT - SWP391</title>
</head>
<body>
    <h1>Chào mừng đến với Thư viện Số FPT!</h1>
    <p>Dự án SWP391 - Hệ thống quản lý thư viện số</p>
    
    <div>
        <h2>Truy cập các trang:</h2>
        <ul>
            <li><a href="${pageContext.request.contextPath}/books">📚 Tìm kiếm sách</a></li>
            <li><a href="${pageContext.request.contextPath}/authors">👨‍💼 Danh sách tác giả</a></li>
            <li><a href="${pageContext.request.contextPath}/categories">📂 Danh sách thể loại</a></li>
        </ul>
    </div>
</body>
</html>