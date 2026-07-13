package controller.admin;

import dal.BorrowDAO;
import dao.NotificationDAO;
import model.Notification;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import util.AuthUtil;

@WebServlet(name = "AdminReturnProcessServlet", urlPatterns = {"/admin/return-process"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,       // 1 MB
    maxFileSize       = 1024 * 1024 * 5,   // 5 MB
    maxRequestSize    = 1024 * 1024 * 10   // 10 MB
)
public class AdminReturnProcessServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads/evidence";
    private static final String[] ALLOWED_EXTENSIONS = {"jpg", "jpeg", "png", "gif"};
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String borrowItemIdStr = request.getParameter("borrowItemId");
        String readerIdStr = request.getParameter("readerId");
        String conditionStatus = request.getParameter("conditionStatus"); // "returned", "damaged", "lost", "late"
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
                    BigDecimal rawAmount = new BigDecimal(fineAmountStr.trim());
                    BigDecimal normalized = rawAmount.setScale(0, RoundingMode.HALF_UP);
                    fineAmount = normalized.longValue();
                }

                String normalizedType = null;
                boolean needsFine = "damaged".equalsIgnoreCase(conditionStatus)
                        || "lost".equalsIgnoreCase(conditionStatus)
                        || "late".equalsIgnoreCase(conditionStatus);

                if (needsFine) {
                    if (violationType == null || violationType.isBlank()) {
                        violationType = conditionStatus;
                    }
                    normalizedType = "lost".equalsIgnoreCase(violationType) ? "lost" : ("late".equalsIgnoreCase(violationType) ? "late" : "damaged");
                    if (fineAmount <= 0) {
                        request.getSession().setAttribute("errorMessage", "Vui lòng nhập số tiền phạt > 0 cho sách trễ/hư/mất.");
                        response.sendRedirect(request.getContextPath() + buildReturnPath(returnTo, borrowItemId));
                        return;
                    }
                }

                // --- Handle evidence image upload ---
                String evidenceImageUrl = null;
                if (needsFine) {
                    evidenceImageUrl = handleEvidenceUpload(request, conditionStatus);
                    if ("INVALID_TYPE".equals(evidenceImageUrl)) {
                        request.getSession().setAttribute("errorMessage", "Ảnh bằng chứng chỉ chấp nhận JPG, PNG, GIF.");
                        response.sendRedirect(request.getContextPath() + buildReturnPath(returnTo, borrowItemId));
                        return;
                    }
                    if ("TOO_LARGE".equals(evidenceImageUrl)) {
                        request.getSession().setAttribute("errorMessage", "Ảnh bằng chứng không được vượt quá 5MB.");
                        response.sendRedirect(request.getContextPath() + buildReturnPath(returnTo, borrowItemId));
                        return;
                    }
                    // Required for damaged/lost
                    if (("damaged".equalsIgnoreCase(conditionStatus) || "lost".equalsIgnoreCase(conditionStatus))
                            && (evidenceImageUrl == null || evidenceImageUrl.isBlank())) {
                        request.getSession().setAttribute("errorMessage", "Vui lòng tải lên ảnh bằng chứng cho sách hư hỏng/mất.");
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
                        employeeId,
                        evidenceImageUrl);
                
                if (success) {
                    request.getSession().setAttribute("successMessage", "Đã xác nhận trả sách thành công.");
                    try {
                        NotificationDAO notifDAO = new NotificationDAO();
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

    /**
     * Handle evidence image upload. Returns:
     * - relative URL path on success
     * - null if no file uploaded
     * - "INVALID_TYPE" if file type not allowed
     * - "TOO_LARGE" if file exceeds max size
     */
    private String handleEvidenceUpload(HttpServletRequest request, String conditionStatus)
            throws IOException, ServletException {
        Part filePart = request.getPart("evidenceImage");
        if (filePart == null || filePart.getSize() <= 0) {
            return null;
        }

        // Check file size
        if (filePart.getSize() > MAX_FILE_SIZE) {
            return "TOO_LARGE";
        }

        // Get filename and validate extension
        String fileName = getFileName(filePart);
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }

        String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        boolean valid = false;
        for (String ext : ALLOWED_EXTENSIONS) {
            if (ext.equals(fileExt)) { valid = true; break; }
        }
        if (!valid) {
            return "INVALID_TYPE";
        }

        // Save file
        String newFileName = UUID.randomUUID().toString() + "." + fileExt;
        String buildPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        String webPath = getServletContext().getRealPath("").replace(
            "build" + File.separator + "web", "web") + File.separator + UPLOAD_DIR;

        new File(buildPath).mkdirs();
        new File(webPath).mkdirs();

        String buildFilePath = buildPath + File.separator + newFileName;
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, Paths.get(buildFilePath), StandardCopyOption.REPLACE_EXISTING);
        }
        Files.copy(Paths.get(buildFilePath),
                   Paths.get(webPath + File.separator + newFileName),
                   StandardCopyOption.REPLACE_EXISTING);

        return UPLOAD_DIR + "/" + newFileName;
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp != null) {
            for (String token : contentDisp.split(";")) {
                if (token.trim().startsWith("filename")) {
                    String name = token.substring(token.indexOf("=") + 2, token.length() - 1);
                    return java.nio.file.Paths.get(name).getFileName().toString();
                }
            }
        }
        return part.getSubmittedFileName();
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
