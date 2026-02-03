<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.ReaderAccount"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài khoản liên kết - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .account-list { max-width: 560px; margin: 0 auto; }
        .account-item { display: flex; justify-content: space-between; align-items: center; padding: 16px; background: white; border-radius: 8px; margin-bottom: 12px; box-shadow: var(--shadow-sm); }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Tài khoản liên kết (Mock)</h2>
            <p style="color: var(--text-secondary); margin-bottom: 24px;">Google, Facebook, GitHub... (Reader_Account)</p>
            <div class="account-list">
                <% List<ReaderAccount> linkedList = (List<ReaderAccount>)request.getAttribute("linkedAccounts"); if (linkedList == null) linkedList = java.util.Collections.emptyList();
                for (ReaderAccount ra : linkedList) { %>
                <div class="account-item">
                    <span><strong><%= ra.getProvider() %></strong> <% if (ra.getProviderUserId() != null) { %> - <%= ra.getProviderUserId() %><% } %></span>
                    <button type="button" class="btn-secondary" style="padding: 8px 14px;">Hủy liên kết</button>
                </div>
                <% } %>
                <p style="margin-top: 20px;"><a href="#" class="btn-primary">Liên kết thêm (Google / Facebook)</a></p>
            </div>
        </div>
    </section>
</body>
</html>
