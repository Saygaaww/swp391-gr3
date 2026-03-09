package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.AuthUtil;
import java.io.IOException;

/**
 * AdminController - Quản lý Admin Dashboard
 * 
 * @author FPT Student Team
 */
@WebServlet(name = "AdminController", urlPatterns = { "/admin", "/admin/*" })
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Cực kỳ quan trọng: Check role Admin
        if (!AuthUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
            showDashboard(request, response);
            return;
        }

        switch (pathInfo) {
            case "/users":
                showUsers(request, response);
                break;
            case "/employees":
                showEmployees(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Admin Page Not Found");
                break;
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tạm thời chỉ forward tới view. Tương lai có thể fetch thống kê (tổng người
        // dùng, tổng doanh thu,...) từ DAO
        request.setAttribute("pageTitle", "Dashboard - Admin Control Panel");
        request.getRequestDispatcher("/WEB-INF/jsp/admin/dashboard.jsp").forward(request, response);
    }

    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tạm thời trả về view
        request.setAttribute("pageTitle", "Quản lý Người dùng - Admin Control Panel");
        // Giả sử có "users.jsp" - ở đây forward tạm về dashboard với thông báo
        request.setAttribute("message", "Tính năng quản lý người dùng đang được phát triển.");
        request.getRequestDispatcher("/WEB-INF/jsp/admin/dashboard.jsp").forward(request, response);
    }

    private void showEmployees(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tạm thời trả về view
        request.setAttribute("pageTitle", "Quản lý Nhân viên - Admin Control Panel");
        request.setAttribute("message", "Tính năng quản lý nhân viên đang được phát triển.");
        request.getRequestDispatcher("/WEB-INF/jsp/admin/dashboard.jsp").forward(request, response);
    }
}
