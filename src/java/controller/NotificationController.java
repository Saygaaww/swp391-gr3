package controller;

import dao.NotificationDAO;
import model.Reader;
import util.AuthUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * NotificationController - Inbox và mark as read
 * URL: /notifications/*
 */
public class NotificationController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(NotificationController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!requireReaderLogin(request, response))
            return;

        Reader reader = (Reader) request.getSession().getAttribute(AuthUtil.SESSION_USER);
        NotificationDAO dao = null;
        try {
            dao = new NotificationDAO();
            request.setAttribute("notifications", dao.getAllNotifications(reader.getReaderId()));
            request.setAttribute("unreadCount", dao.getUnreadCount(reader.getReaderId()));
            request.getRequestDispatcher("/jsp/notifications/inbox.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Get notifications error", e);
            request.setAttribute("error", "Có lỗi xảy ra khi tải thông báo.");
            request.getRequestDispatcher("/jsp/notifications/inbox.jsp").forward(request, response);
        } finally {
            if (dao != null)
                dao.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!requireReaderLogin(request, response))
            return;
        Reader reader = (Reader) request.getSession().getAttribute(AuthUtil.SESSION_USER);

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "";

        NotificationDAO dao = null;
        try {
            dao = new NotificationDAO();
            if ("/mark-read".equals(pathInfo)) {
                String notifIdStr = request.getParameter("notificationId");
                if ("all".equals(notifIdStr)) {
                    dao.markAllAsRead(reader.getReaderId());
                } else {
                    int notifId = Integer.parseInt(notifIdStr);
                    dao.markAsRead(notifId, reader.getReaderId());
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Mark notification error", e);
        } finally {
            if (dao != null)
                dao.close();
        }

        // Trả về JSON hoặc redirect
        String accept = request.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":true}");
        } else {
            response.sendRedirect(request.getContextPath() + "/notifications");
        }
    }

    private boolean requireReaderLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!AuthUtil.isLoggedIn(request) || !AuthUtil.ROLE_READER.equals(AuthUtil.getUserRole(request))) {
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=/notifications");
            return false;
        }
        return true;
    }
}
