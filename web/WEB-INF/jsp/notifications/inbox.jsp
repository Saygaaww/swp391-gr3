<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="model.Reader, model.Notification, util.AuthUtil, java.util.List" %>
        <% Reader currentReader=(Reader) session.getAttribute(AuthUtil.SESSION_USER); List<Notification> notifications =
            (List<Notification>) request.getAttribute("notifications");
                Integer unreadCount = (Integer) request.getAttribute("unreadCount");
                if (unreadCount == null) unreadCount = 0;
                %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Hộp thư thông báo - Digital Library</title>
                    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
                    <style>
                        *,
                        *::before,
                        *::after {
                            box-sizing: border-box;
                            margin: 0;
                            padding: 0;
                        }

                        body {
                            font-family: 'Inter', sans-serif;
                            min-height: 100vh;
                            background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
                            padding: 30px 20px;
                        }

                        .container {
                            max-width: 760px;
                            margin: 0 auto;
                        }

                        .back-link {
                            color: rgba(255, 255, 255, 0.5);
                            text-decoration: none;
                            font-size: 0.875rem;
                            display: inline-flex;
                            align-items: center;
                            gap: 6px;
                            margin-bottom: 20px;
                        }

                        .back-link:hover {
                            color: #a78bfa;
                        }

                        .page-header {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            margin-bottom: 24px;
                        }

                        .page-header h1 {
                            font-size: 1.4rem;
                            font-weight: 700;
                            color: #fff;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }

                        .badge-unread {
                            background: linear-gradient(135deg, #6366f1, #8b5cf6);
                            color: #fff;
                            font-size: 0.75rem;
                            font-weight: 700;
                            padding: 2px 8px;
                            border-radius: 99px;
                        }

                        .btn-mark-all {
                            padding: 8px 16px;
                            background: rgba(255, 255, 255, 0.07);
                            border: 1px solid rgba(255, 255, 255, 0.15);
                            border-radius: 8px;
                            color: rgba(255, 255, 255, 0.7);
                            font-size: 0.8rem;
                            font-family: inherit;
                            cursor: pointer;
                            transition: all 0.2s;
                        }

                        .btn-mark-all:hover {
                            background: rgba(255, 255, 255, 0.12);
                            color: #fff;
                        }

                        .notif-list {
                            display: flex;
                            flex-direction: column;
                            gap: 8px;
                        }

                        .notif-item {
                            background: rgba(255, 255, 255, 0.06);
                            border: 1px solid rgba(255, 255, 255, 0.1);
                            border-radius: 14px;
                            padding: 16px 18px;
                            display: flex;
                            gap: 14px;
                            align-items: flex-start;
                            transition: all 0.2s;
                            cursor: pointer;
                            position: relative;
                        }

                        .notif-item.unread {
                            background: rgba(99, 102, 241, 0.1);
                            border-color: rgba(99, 102, 241, 0.25);
                        }

                        .notif-item:hover {
                            transform: translateX(4px);
                            background: rgba(255, 255, 255, 0.09);
                        }

                        .notif-item.unread::before {
                            content: '';
                            position: absolute;
                            left: -1px;
                            top: 50%;
                            transform: translateY(-50%);
                            width: 3px;
                            height: 60%;
                            background: linear-gradient(#6366f1, #8b5cf6);
                            border-radius: 0 3px 3px 0;
                        }

                        .notif-icon-wrap {
                            width: 42px;
                            height: 42px;
                            border-radius: 10px;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            flex-shrink: 0;
                            font-size: 1rem;
                        }

                        .icon-general {
                            background: rgba(99, 102, 241, 0.2);
                            color: #a78bfa;
                        }

                        .icon-overdue {
                            background: rgba(239, 68, 68, 0.2);
                            color: #f87171;
                        }

                        .icon-reservation {
                            background: rgba(234, 179, 8, 0.2);
                            color: #fbbf24;
                        }

                        .icon-order {
                            background: rgba(34, 197, 94, 0.2);
                            color: #4ade80;
                        }

                        .notif-body {
                            flex: 1;
                            min-width: 0;
                        }

                        .notif-title {
                            font-weight: 600;
                            color: #fff;
                            font-size: 0.9rem;
                            margin-bottom: 4px;
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }

                        .notif-message {
                            color: rgba(255, 255, 255, 0.55);
                            font-size: 0.82rem;
                            line-height: 1.5;
                            display: -webkit-box;
                            -webkit-line-clamp: 2;
                            -webkit-box-orient: vertical;
                            overflow: hidden;
                        }

                        .notif-time {
                            color: rgba(255, 255, 255, 0.35);
                            font-size: 0.75rem;
                            margin-top: 6px;
                        }

                        .notif-actions {
                            display: flex;
                            flex-direction: column;
                            align-items: flex-end;
                            gap: 6px;
                            flex-shrink: 0;
                        }

                        .dot-unread {
                            width: 9px;
                            height: 9px;
                            background: #6366f1;
                            border-radius: 50%;
                        }

                        .btn-read {
                            background: none;
                            border: none;
                            color: rgba(255, 255, 255, 0.3);
                            font-size: 0.75rem;
                            cursor: pointer;
                            font-family: inherit;
                            white-space: nowrap;
                        }

                        .btn-read:hover {
                            color: #a78bfa;
                        }

                        .empty-state {
                            text-align: center;
                            padding: 60px 20px;
                            color: rgba(255, 255, 255, 0.4);
                        }

                        .empty-state i {
                            font-size: 3.5rem;
                            margin-bottom: 16px;
                            display: block;
                            color: rgba(255, 255, 255, 0.15);
                        }

                        .empty-state p {
                            font-size: 0.95rem;
                        }

                        .filter-tabs {
                            display: flex;
                            gap: 8px;
                            margin-bottom: 20px;
                            flex-wrap: wrap;
                        }

                        .filter-tab {
                            padding: 6px 14px;
                            border-radius: 99px;
                            border: 1px solid rgba(255, 255, 255, 0.12);
                            background: rgba(255, 255, 255, 0.05);
                            color: rgba(255, 255, 255, 0.6);
                            font-size: 0.8rem;
                            cursor: pointer;
                            transition: all 0.2s;
                            font-family: inherit;
                        }

                        .filter-tab.active,
                        .filter-tab:hover {
                            background: rgba(99, 102, 241, 0.2);
                            border-color: rgba(99, 102, 241, 0.4);
                            color: #a78bfa;
                        }
                    </style>
                </head>

                <body>
                    <div class="container">
                        <a href="<%= request.getContextPath() %>/books" class="back-link"><i
                                class="fas fa-arrow-left"></i> Về trang chính</a>

                        <div class="page-header">
                            <h1>
                                <i class="fas fa-bell" style="color:#a78bfa;"></i>
                                Thông báo
                                <% if (unreadCount> 0) { %>
                                    <span class="badge-unread">
                                        <%= unreadCount %> mới
                                    </span>
                                    <% } %>
                            </h1>
                            <% if (unreadCount> 0) { %>
                                <form method="post" action="<%= request.getContextPath() %>/notifications/mark-read"
                                    style="margin:0;">
                                    <input type="hidden" name="notificationId" value="all">
                                    <button type="submit" class="btn-mark-all">
                                        <i class="fas fa-check-double" style="margin-right:5px;"></i>Đánh dấu tất cả đã
                                        đọc
                                    </button>
                                </form>
                                <% } %>
                        </div>

                        <% if (notifications==null || notifications.isEmpty()) { %>
                            <div class="empty-state">
                                <i class="fas fa-bell-slash"></i>
                                <p>Bạn chưa có thông báo nào</p>
                            </div>
                            <% } else { %>
                                <div class="notif-list" id="notifList">
                                    <% for (Notification n : notifications) { %>
                                        <div class="notif-item <%= !n.isRead() ? " unread" : "" %>" id="notif-<%=
                                                n.getNotificationId() %>">
                                                <div class="notif-icon-wrap icon-<%= n.getNotifType() != null ? n.getNotifType() : "
                                                    general" %>">
                                                    <i class="fas <%= n.getTypeIcon() %>"></i>
                                                </div>
                                                <div class="notif-body">
                                                    <div class="notif-title">
                                                        <%= n.getTitle() %>
                                                    </div>
                                                    <div class="notif-message">
                                                        <%= n.getMessage() %>
                                                    </div>
                                                    <div class="notif-time"><i class="fas fa-clock"
                                                            style="margin-right:4px;"></i>
                                                        <%= n.getTimeAgo() %>
                                                    </div>
                                                </div>
                                                <div class="notif-actions">
                                                    <% if (!n.isRead()) { %>
                                                        <span class="dot-unread" title="Chưa đọc"></span>
                                                        <button type="button" class="btn-read"
                                                            onclick="markRead(<%= n.getNotificationId() %>, this)">
                                                            <i class="fas fa-check"></i> Đã đọc
                                                        </button>
                                                        <% } %>
                                                </div>
                                        </div>
                                        <% } %>
                                </div>
                                <% } %>
                    </div>

                    <script>
                        function markRead(notifId, btn) {
                            fetch('<%= request.getContextPath() %>/notifications/mark-read', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Accept': 'application/json' },
                                body: 'notificationId=' + notifId
                            }).then(function () {
                                var item = document.getElementById('notif-' + notifId);
                                if (item) {
                                    item.classList.remove('unread');
                                    var actions = item.querySelector('.notif-actions');
                                    if (actions) actions.innerHTML = '';
                                }
                            });
                        }
                    </script>
                </body>

                </html>