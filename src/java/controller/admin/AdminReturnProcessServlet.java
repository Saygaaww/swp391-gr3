package controller.admin;

import dal.BorrowDAO;
import dao.NotificationDAO;
import model.Notification;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import util.AuthUtil;

@WebServlet(name = "AdminReturnProcessServlet", urlPatterns = {"/admin/return-process"})
public class AdminReturnProcessServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String borrowItemIdStr = request.getParameter("borrowItemId");
        String readerIdStr = request.getParameter("readerId");
        String conditionStatus = request.getParameter("conditionStatus"); // "returned", "damaged", "lost"
        String fineAmountStr = request.getParameter("fineAmount");
        String violationType = request.getParameter("violationType");
        String severity = request.getParameter("severity");
        String description = request.getParameter("description");
        String returnTo = request.getParameter("returnTo");
        
        if (conditionStatus == null || conditionStatus.isEmpty()) {
            conditionStatus = "returned";
        }
        
        if (borrowItemIdStr != null && !borrowItemIdStr.isBlank() && readerIdStr != null && !readerIdStr.isBlank()) {
            try {
                int borrowItemId = Integer.parseInt(borrowItemIdStr);
                int readerId = Integer.parseInt(readerIdStr);
                
                long fineAmount = 0;
                if (fineAmountStr != null && !fineAmountStr.isBlank()) {
                    // Keep fine amount as clean integer to avoid floating artifacts like 100001.
                    BigDecimal rawAmount = new BigDecimal(fineAmountStr.trim());
                    BigDecimal normalized = rawAmount.setScale(0, RoundingMode.HALF_UP);
                    fineAmount = normalized.longValue();
                }

                String normalizedType = null;
                if ("damaged".equalsIgnoreCase(conditionStatus) || "lost".equalsIgnoreCase(conditionStatus)) {
                    if (violationType == null || violationType.isBlank()) {
                        violationType = conditionStatus;
                    }
                    normalizedType = "lost".equalsIgnoreCase(violationType) ? "lost" : "damaged";
                    if (fineAmount <= 0) {
                        request.getSession().setAttribute("errorMessage", "Vui lòng nhập số tiền phạt > 0 cho sách hư/mất.");
                        response.sendRedirect(request.getContextPath() + buildReturnPath(returnTo, borrowItemId));
                        return;
                    }
                }

                Integer employeeId = AuthUtil.getEmployeeId(request);
                StringBuilder reasonBuilder = new StringBuilder();
                if (severity != null && !severity.isBlank()) {
                    reasonBuilder.append("Mức độ: ").append(severity.trim());
                }
                if (description != null && !description.isBlank()) {
                    if (reasonBuilder.length() > 0) {
                        reasonBuilder.append(" | ");
                    }
                    reasonBuilder.append(description.trim());
                }

                BorrowDAO borrowDAO = new BorrowDAO();
                boolean success = borrowDAO.processReturn(
                        borrowItemId,
                        readerId,
                        conditionStatus,
                        fineAmount,
                        normalizedType,
                        reasonBuilder.toString(),
                        employeeId);
                
                if (success) {
                    request.getSession().setAttribute("successMessage", "Đã xác nhận trả sách thành công.");
                    try {
                        NotificationDAO notifDAO = new NotificationDAO();
                        // Get book title if possible? We don't have it easily here so just a generic message.
                        String notifTitle = "Xác nhận trả sách thành công";
                        String notifMsg = "Yêu cầu trả sách (Mã mượn: " + borrowItemId + ") đã được thủ thư xác nhận.";
                        if (fineAmount > 0) {
                            notifMsg += " Bạn bị phạt " + String.format("%,d", fineAmount) + "đ vì lỗi: " + conditionStatus + ".";
                        }
                        Notification notif = new Notification(readerId, notifTitle, notifMsg, "general");
                        notifDAO.createNotification(notif);
                        notifDAO.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } else {
                    request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi xác nhận trả sách.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Dữ liệu yêu cầu trả sách không hợp lệ.");
            }
        } else {
            request.getSession().setAttribute("errorMessage", "Thiếu dữ liệu.");
        }
        
        response.sendRedirect(request.getContextPath() + buildReturnPath(returnTo, null));
    }

    private String buildReturnPath(String returnTo, Integer borrowItemId) {
        if ("detail".equalsIgnoreCase(returnTo) && borrowItemId != null) {
            return "/admin/borrow/return/" + borrowItemId;
        }
        if ("detail".equalsIgnoreCase(returnTo)) {
            return "/admin/return-list";
        }
        return "/admin/borrowed-items";
    }
}
