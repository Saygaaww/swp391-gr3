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
        String readerIdStr = request.getParameter("readerId");
        String conditionStatus = request.getParameter("conditionStatus"); // "returned", "damaged", "lost"
        String fineAmountStr = request.getParameter("fineAmount");
        String fineTypeIdStr = request.getParameter("fineTypeId");
        
        if (conditionStatus == null || conditionStatus.isEmpty()) {
            conditionStatus = "returned";
        }
        
        if (borrowItemIdStr != null && !borrowItemIdStr.isBlank() && readerIdStr != null && !readerIdStr.isBlank()) {
            try {
                int borrowItemId = Integer.parseInt(borrowItemIdStr);
                int readerId = Integer.parseInt(readerIdStr);
                
                double fineAmount = 0;
                if (fineAmountStr != null && !fineAmountStr.isBlank()) {
                    fineAmount = Double.parseDouble(fineAmountStr);
                }
                
                int fineTypeId = 0;
                if (fineTypeIdStr != null && !fineTypeIdStr.isBlank()) {
                    fineTypeId = Integer.parseInt(fineTypeIdStr);
                }

                BorrowDAO borrowDAO = new BorrowDAO();
                boolean success = borrowDAO.processReturn(borrowItemId, readerId, conditionStatus, fineAmount, fineTypeId);
                
                if (success) {
                    request.getSession().setAttribute("successMessage", "Đã xác nhận trả sách thành công.");
                } else {
                    request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xác nhận trả sách.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Dữ liệu yêu cầu trả sách không hợp lệ.");
            }
        } else {
            request.getSession().setAttribute("errorMessage", "Thiếu dữ liệu.");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/borrowed-items");
    }
}
