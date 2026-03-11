package controller.common;

import model.Reader;
import model.Employee;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Trang Home chung cho mọi role đã đăng nhập.
 * Hiển thị welcome + nút điều hướng về dashboard theo role.
 */
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Reader user = (Reader) session.getAttribute("user");
        Employee employee = (Employee) session.getAttribute("employee");

        if (user == null && employee == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/home-dashboard.jsp").forward(request, response);
    }
}
