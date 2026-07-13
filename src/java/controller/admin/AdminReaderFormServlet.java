package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/reader-form")
public class AdminReaderFormServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        String cccd = request.getParameter("cccd");
        String depositStr = request.getParameter("deposit");
        
        StringBuilder errors = new StringBuilder();
        
        // F03 - Validate CCCD (12 số)
        if (cccd == null || !cccd.matches("^\\d{12}$")) {
            errors.append("CCCD phải đủ 12 chữ số. ");
        }
        
        // F03 - Validate Tiền cọc (50k -> 10M)
        if (depositStr != null && !depositStr.isEmpty()) {
            try {
                long deposit = Long.parseLong(depositStr);
                if (deposit < 50000) {
                    errors.append("Tiền cọc tối thiểu là 50,000. ");
                }
                if (deposit > 10000000) {
                    errors.append("Tiền cọc tối đa là 10,000,000. ");
                }
            } catch (NumberFormatException e) {
                errors.append("Tiền cọc không hợp lệ. ");
            }
        } else {
            errors.append("Vui lòng nhập tiền cọc. ");
        }
        
        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
            request.getRequestDispatcher("/jsp/admin/reader-form.jsp").forward(request, response);
            return;
        }
        
        // Thành công (Fake DB logic)
        response.sendRedirect(request.getContextPath() + "/admin/readers");
    }
}
