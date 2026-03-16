package controller.admin;

import dal.BorrowDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminReturnProcessServlet", urlPatterns = {"/admin/return-process"})
public class AdminReturnProcessServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String borrowItemIdStr = request.getParameter("borrowItemId");
        
        if (borrowItemIdStr != null && !borrowItemIdStr.isBlank()) {
            try {
                int borrowItemId = Integer.parseInt(borrowItemIdStr);
                BorrowDAO borrowDAO = new BorrowDAO();
                boolean success = borrowDAO.processReturn(borrowItemId);
                
                if (success) {
                    request.getSession().setAttribute("successMessage", "Đã xác nhận trả sách thành công.");
                } else {
                    request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xác nhận trả sách.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "ID yêu cầu trả sách không hợp lệ.");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/return-list");
    }
}
