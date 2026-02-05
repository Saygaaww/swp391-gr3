<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard - Thủ thư</title>
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
            
            .header-info {
                display: flex;
                align-items: center;
                gap: 20px;
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
            
            .btn-danger {
                background-color: #f44336;
                color: white;
            }
            
            .container {
                max-width: 1200px;
                margin: 0 auto;
            }
            
            .request-card {
                background: white;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            
            .request-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
                padding-bottom: 15px;
                border-bottom: 2px solid #f0f0f0;
            }
            
            .request-id {
                font-size: 18px;
                font-weight: bold;
                color: #333;
            }
            
            .request-info {
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
                margin-bottom: 15px;
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
            
            .actions {
                display: flex;
                gap: 10px;
                margin-top: 15px;
            }
            
            .btn-success {
                background-color: #4CAF50;
                color: white;
            }
            
            .btn-success:hover {
                background-color: #45a049;
            }
            
            .btn-warning {
                background-color: #ff9800;
                color: white;
            }
            
            .btn-warning:hover {
                background-color: #e68900;
            }
            
            .no-requests {
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
                <h1>📚 Dashboard - Thủ thư</h1>
                <div class="header-info">
                    <span>Xin chào, ${sessionScope.fullName}</span>
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
            
            <h2 style="margin-bottom: 20px; color: #333;">Yêu cầu mượn sách đang chờ duyệt</h2>
            
            <c:if test="${not empty pendingRequests and pendingRequests.size() > 0}">
                <c:forEach var="request" items="${pendingRequests}">
                    <div class="request-card">
                        <div class="request-header">
                            <div class="request-id">Yêu cầu #${request.requestId}</div>
                            <span style="color: #ff9800; font-weight: bold;">Chờ duyệt</span>
                        </div>
                        
                        <div class="request-info">
                            <div class="info-item">
                                <span class="info-label">Người đọc ID:</span>
                                <span class="info-value">#${request.readerId}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Ngày yêu cầu:</span>
                                <span class="info-value">
                                    <fmt:formatDate value="${request.requestedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">Ghi chú:</span>
                                <span class="info-value">${request.note != null ? request.note : 'Không có'}</span>
                            </div>
                        </div>
                        
                        <div class="items-list">
                            <h3 style="margin-bottom: 10px; font-size: 16px;">Danh sách sách:</h3>
                            <c:forEach var="item" items="${request.requestItems}">
                                <div class="item-row">
                                    <div class="item-info">
                                        <div class="item-title">Sách ID: ${item.bookId}</div>
                                        <div class="item-details">
                                            Số lượng: ${item.quantity} bản
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <div class="actions">
                            <a href="librarian?action=approve&requestId=${request.requestId}" 
                               class="btn btn-success">Duyệt</a>
                            <a href="librarian?action=reject&requestId=${request.requestId}" 
                               class="btn btn-warning">Từ chối</a>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
            
            <c:if test="${empty pendingRequests or pendingRequests.size() == 0}">
                <div class="no-requests">
                    <p>Không có yêu cầu mượn sách nào đang chờ duyệt.</p>
                </div>
            </c:if>
        </div>
    </body>
</html>
