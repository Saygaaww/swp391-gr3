<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Từ chối yêu cầu mượn sách</title>
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
            }
            
            .card {
                background: white;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }
            
            h1 {
                color: #333;
                margin-bottom: 20px;
            }
            
            .info-section {
                margin-bottom: 25px;
            }
            
            .info-row {
                display: flex;
                justify-content: space-between;
                padding: 10px 0;
                border-bottom: 1px solid #f0f0f0;
            }
            
            .info-label {
                font-weight: 500;
                color: #666;
            }
            
            .info-value {
                color: #333;
            }
            
            .form-group {
                margin-bottom: 20px;
            }
            
            label {
                display: block;
                margin-bottom: 8px;
                color: #333;
                font-weight: 500;
            }
            
            textarea {
                width: 100%;
                padding: 12px;
                font-size: 14px;
                border: 2px solid #e0e0e0;
                border-radius: 5px;
                resize: vertical;
                min-height: 100px;
                font-family: inherit;
            }
            
            textarea:focus {
                outline: none;
                border-color: #f5576c;
            }
            
            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                display: inline-block;
                font-size: 14px;
                transition: background-color 0.3s;
                margin-right: 10px;
            }
            
            .btn-warning {
                background-color: #ff9800;
                color: white;
            }
            
            .btn-warning:hover {
                background-color: #e68900;
            }
            
            .btn-secondary {
                background-color: #9e9e9e;
                color: white;
            }
            
            .btn-secondary:hover {
                background-color: #757575;
            }
            
            .actions {
                margin-top: 30px;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="card">
                <h1>Từ chối yêu cầu mượn sách</h1>
                
                <c:if test="${not empty borrowRequest}">
                    <div class="info-section">
                        <div class="info-row">
                            <span class="info-label">Mã yêu cầu:</span>
                            <span class="info-value">#${borrowRequest.requestId}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Người đọc ID:</span>
                            <span class="info-value">#${borrowRequest.readerId}</span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Ngày yêu cầu:</span>
                            <span class="info-value">
                                <fmt:formatDate value="${borrowRequest.requestedAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </span> 
                        </div>
                    </div>
                    
                    <form method="post" action="librarian">
                        <input type="hidden" name="action" value="reject">
                        <input type="hidden" name="requestId" value="${borrowRequest.requestId}">
                        
                        <div class="form-group">
                            <label for="decisionNote">Lý do từ chối:</label>
                            <textarea id="decisionNote" name="decisionNote" 
                                      placeholder="Nhập lý do từ chối yêu cầu mượn sách..." required></textarea>
                        </div>
                        
                        <div class="actions">
                            <button type="submit" class="btn btn-warning">Xác nhận từ chối</button>
                            <a href="librarian?action=dashboard" class="btn btn-secondary">Hủy</a>
                        </div>
                    </form>
                </c:if>
            </div>
        </div>
    </body>
</html>
