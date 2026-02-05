<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sách đang mượn</title>
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
            
            .header {
                background: white;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            
            .header h1 {
                color: #333;
            }
            
            .header-actions {
                display: flex;
                gap: 10px;
            }
            
            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                font-size: 14px;
                transition: background-color 0.3s;
            }
            
            .btn-primary {
                background-color: #2196F3;
                color: white;
            }
            
            .btn-success {
                background-color: #4CAF50;
                color: white;
            }
            
            .btn-danger {
                background-color: #f44336;
                color: white;
            }
            
            .container {
                max-width: 1200px;
                margin: 0 auto;
            }
            
            .borrow-card {
                background: white;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            
            .borrow-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
                padding-bottom: 15px;
                border-bottom: 2px solid #f0f0f0;
            }
            
            .borrow-id {
                font-size: 18px;
                font-weight: bold;
                color: #333;
            }
            
            .borrow-status {
                padding: 5px 15px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: bold;
            }
            
            .status-active {
                background-color: #4CAF50;
                color: white;
            }
            
            .status-overdue {
                background-color: #f44336;
                color: white;
            }
            
            .status-completed {
                background-color: #9e9e9e;
                color: white;
            }
            
            .borrow-info {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                margin-bottom: 15px;
            }
            
            .info-item {
                display: flex;
                flex-direction: column;
            }
            
            .info-label {
                font-size: 12px;
                color: #666;
                margin-bottom: 5px;
            }
            
            .info-value {
                font-size: 14px;
                color: #333;
                font-weight: 500;
            }
            
            .items-list {
                margin-top: 15px;
            }
            
            .item-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 10px;
                background-color: #f9f9f9;
                border-radius: 5px;
                margin-bottom: 10px;
            }
            
            .item-info {
                flex: 1;
            }
            
            .item-title {
                font-weight: bold;
                color: #333;
                margin-bottom: 5px;
            }
            
            .item-details {
                font-size: 12px;
                color: #666;
            }
            
            .no-borrows {
                text-align: center;
                padding: 50px;
                color: #666;
                font-size: 18px;
            }
            
            .message {
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
            }
            
            .message-success {
                background-color: #d4edda;
                color: #155724;
                border-left: 4px solid #28a745;
            }
            
            .message-error {
                background-color: #f8d7da;
                color: #721c24;
                border-left: 4px solid #dc3545;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>📚 Sách đang mượn</h1>
                <div class="header-actions">
                    <a href="book" class="btn btn-primary">Xem sách</a>
                    <a href="login?action=logout" class="btn btn-danger">Đăng xuất</a>
                </div>
            </div>
            
            <c:if test="${not empty success}">
                <div class="message message-success">
                    <c:out value="${success}"/>
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="message message-error">
                    <c:out value="${error}"/>
                </div>
            </c:if>
            
            <c:if test="${not empty borrows and borrows.size() > 0}">
                <c:forEach var="borrow" items="${borrows}">
                    <div class="borrow-card">
                        <div class="borrow-header">
                            <div class="borrow-id">Mã mượn: #${borrow.borrowId}</div>
                            <span class="borrow-status status-${borrow.status}">
                                <c:choose>
                                    <c:when test="${borrow.status == 'active'}">Đang mượn</c:when>
                                    <c:when test="${borrow.status == 'overdue'}">Quá hạn</c:when>
                                    <c:when test="${borrow.status == 'completed'}">Đã trả</c:when>
                                    <c:otherwise>${borrow.status}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        
                        <div class="borrow-info">
                            <div class="info-item">
                                <span class="info-label">Ngày mượn:</span>
                                <span class="info-value">
                                    <fmt:formatDate value="${borrow.borrowDate}" pattern="dd/MM/yyyy"/>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Ngày tạo:</span>
                                <span class="info-value">
                                    <fmt:formatDate value="${borrow.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>
                        </div>
                        
                        <div class="items-list">
                            <h3 style="margin-bottom: 10px; font-size: 16px;">Danh sách sách:</h3>
                            <c:forEach var="item" items="${borrow.borrowItems}">
                                <div class="item-row">
                                    <div class="item-info">
                                        <div class="item-title">Mã bản sao: ${item.copyId}</div>
                                        <div class="item-details">
                                            Hạn trả: <fmt:formatDate value="${item.dueDate}" pattern="dd/MM/yyyy"/>
                                            <c:if test="${not empty item.returnedAt}">
                                                | Đã trả: <fmt:formatDate value="${item.returnedAt}" pattern="dd/MM/yyyy"/>
                                            </c:if>
                                        </div>
                                    </div>
                                    <c:if test="${item.status == 'borrowed' or item.status == 'overdue'}">
                                        <a href="readerBorrow?action=return&borrowItemId=${item.borrowItemId}" 
                                           class="btn btn-success">Trả sách</a>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
            
            <c:if test="${empty borrows or borrows.size() == 0}">
                <div class="no-borrows">
                    <p>Bạn chưa mượn sách nào.</p>
                    <a href="book" class="btn btn-primary" style="margin-top: 20px;">Xem sách</a>
                </div>
            </c:if>
        </div>
    </body>
</html>
