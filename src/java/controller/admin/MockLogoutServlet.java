package controller.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * ⚠️ MOCK LOGOUT - CHỈ DÙNG CHO INTER 1 ⚠️
 * XÓA KHI GHÉP VỚI LOGIN THẬT
 * @author Member E - Dũng
 */
@WebServlet("/mock-logout")
public class MockLogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Hủy session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
            System.out.println("✅ MOCK LOGOUT - Session đã bị hủy");
        }
        
        // Chuyển về trang login
        response.sendRedirect(request.getContextPath() + "/mock-login.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}