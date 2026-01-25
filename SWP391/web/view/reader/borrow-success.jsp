<%-- 
    Document   : borrow-success
    Created on : Jan 23, 2026
    Author     : damha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Kết quả mượn sách</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f5f5;
                padding: 20px;
            }
            
            .container {
                max-width: 600px;
                margin: 0 auto;
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 40px;
                text-align: center;
            }
            
            .success-icon {
                font-size: 80px;
                color: #4CAF50;
                margin-bottom: 20px;
            }
            
            .error-icon {
                font-size: 80px;
                color: #f44336;
                margin-bottom: 20px;
            }
            
            h1 {
                color: #333;
                margin-bottom: 20px;
            }
            
            .message {
                font-size: 18px;
                color: #666;
                margin-bottom: 30px;
                line-height: 1.6;
            }
            
            .success {
                color: #4CAF50;
            }
            
            .error {
                color: #f44336;
            }
            
            .request-id {
                background-color: #e3f2fd;
                padding: 15px;
                border-radius: 5px;
                margin: 20px 0;
                font-size: 20px;
                font-weight: bold;
                color: #1976d2;
            }
            
            .actions {
                display: flex;
                gap: 15px;
                justify-content: center;
                margin-top: 30px;
            }
            
            .btn {
                padding: 12px 30px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                font-size: 16px;
                transition: background-color 0.3s;
            }
            
            .btn-primary {
                background-color: #2196F3;
                color: white;
            }
            
            .btn-primary:hover {
                background-color: #0b7dda;
            }
            
            .btn-success {
                background-color: #4CAF50;
                color: white;
            }
            
            .btn-success:hover {
                background-color: #45a049;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <c:choose>
                <c:when test="${not empty success}">
                    <div class="success-icon">✓</div>
                    <h1>Thành công!</h1>
                    <div class="message success">
                        <c:out value="${success}"/>
                    </div>
                    <c:if test="${not empty requestId}">
                        <div class="request-id">
                            Mã yêu cầu: #<c:out value="${requestId}"/>
                        </div>
                    </c:if>
                    <div class="message">
                        Yêu cầu mượn sách của bạn đã được gửi thành công. 
                        Vui lòng chờ thủ thư xử lý yêu cầu của bạn.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="error-icon">✗</div>
                    <h1>Lỗi!</h1>
                    <div class="message error">
                        <c:out value="${error}"/>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <div class="actions">
                <a href="book" class="btn btn-primary">Xem danh sách sách</a>
                <a href="borrow?action=list" class="btn btn-success">Xem yêu cầu của tôi</a>
            </div>
        </div>
    </body>
</html>

