<%-- 
    Document   : borrow-list
    Created on : Jan 23, 2026
    Author     : damha
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách yêu cầu mượn</title>
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
                max-width: 1000px;
                margin: 0 auto;
            }
            
            h1 {
                color: #333;
                margin-bottom: 30px;
            }
            
            .request-card {
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                padding: 20px;
                margin-bottom: 20px;
            }
            
            .request-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 15px;
                padding-bottom: 15px;
                border-bottom: 1px solid #eee;
            }
            
            .request-id {
                font-size: 18px;
                font-weight: bold;
                color: #333;
            }
            
            .status-badge {
                padding: 6px 15px;
                border-radius: 20px;
                font-size: 14px;
                font-weight: bold;
            }
            
            .status-pending {
                background-color: #fff3cd;
                color: #856404;
            }
            
            .status-approved {
                background-color: #d4edda;
                color: #155724;
            }
            
            .status-rejected {
                background-color: #f8d7da;
                color: #721c24;
            }
            
            .status-cancelled {
                background-color: #e2e3e5;
                color: #383d41;
            }
            
            .request-info {
                color: #666;
                margin-bottom: 10px;
            }
            
            .request-note {
                background-color: #f8f9fa;
                padding: 10px;
                border-radius: 5px;
                margin-top: 10px;
                color: #555;
            }
            
            .no-requests {
                text-align: center;
                padding: 50px;
                color: #666;
                font-size: 18px;
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
                margin-top: 20px;
            }
            
            .btn-primary {
                background-color: #2196F3;
                color: white;
            }
            
            .btn-primary:hover {
                background-color: #0b7dda;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>📋 Danh sách yêu cầu mượn sách</h1>
            
            <c:if test="${not empty borrowRequests and borrowRequests.size() > 0}">
                <c:forEach var="request" items="${borrowRequests}">
                    <div class="request-card">
                        <div class="request-header">
                            <div class="request-id">Yêu cầu #<c:out value="${request.requestId}"/></div>
                            <div class="status-badge status-${request.status}">
                                <c:choose>
                                    <c:when test="${request.status == 'pending'}">Đang chờ</c:when>
                                    <c:when test="${request.status == 'approved'}">Đã duyệt</c:when>
                                    <c:when test="${request.status == 'rejected'}">Từ chối</c:when>
                                    <c:when test="${request.status == 'cancelled'}">Đã hủy</c:when>
                                    <c:otherwise><c:out value="${request.status}"/></c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        
                        <div class="request-info">
                            <strong>Ngày yêu cầu:</strong> 
                            <fmt:formatDate value="${request.requestedAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </div>
                        
                        <c:if test="${not empty request.processedAt}">
                            <div class="request-info">
                                <strong>Ngày xử lý:</strong> 
                                <fmt:formatDate value="${request.processedAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty request.note}">
                            <div class="request-note">
                                <strong>Ghi chú:</strong> <c:out value="${request.note}"/>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty request.decisionNote}">
                            <div class="request-note">
                                <strong>Ghi chú từ thủ thư:</strong> <c:out value="${request.decisionNote}"/>
                            </div>
                        </c:if>
                    </div>
                </c:forEach>
            </c:if>
            
            <c:if test="${empty borrowRequests or borrowRequests.size() == 0}">
                <div class="no-requests">
                    <p>Bạn chưa có yêu cầu mượn sách nào.</p>
                    <a href="book" class="btn btn-primary">Xem danh sách sách</a>
                </div>
            </c:if>
        </div>
    </body>
</html>

