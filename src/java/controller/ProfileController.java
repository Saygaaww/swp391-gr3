package controller;

import dao.LinkedAccountDAO;
import dao.ReaderDAO;
import model.Reader;
import model.Employee;
import dao.EmployeeDAO;
import util.AuthUtil;
import util.PasswordUtil;
import util.StringUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.InputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Base64;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ProfileController - Edit Profile, Change Password, Linked Accounts
 * URL: /profile/*
 */
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 5,       // 5 MB
    maxRequestSize = 1024 * 1024 * 10    // 10 MB
)
public class ProfileController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ProfileController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Phải đăng nhập mới vào được
        if (!requireLogin(request, response))
            return;

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/view";

        switch (pathInfo) {
            case "/view":
                request.getRequestDispatcher("/jsp/profile/view-profile.jsp").forward(request, response);
                break;
            case "/edit":
                handleShowEditProfile(request, response);
                break;
            case "/change-password":
                request.getRequestDispatcher("/jsp/profile/change-password.jsp").forward(request, response);
                break;
            case "/linked-accounts":
                handleShowLinkedAccounts(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/profile/view");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!requireLogin(request, response))
            return;
        request.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "";

        switch (pathInfo) {
            case "/edit":
                handleUpdateProfile(request, response);
                break;
            case "/change-password":
                handleChangePassword(request, response);
                break;
            case "/linked-accounts/unlink":
                handleUnlinkAccount(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/profile/edit");
        }
    }

    // ========================= EDIT PROFILE =========================

    private void handleShowEditProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Reader đã có trong session
        request.getRequestDispatcher("/jsp/profile/edit-profile.jsp").forward(request, response);
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Object userAttr = request.getSession().getAttribute(AuthUtil.SESSION_USER);
        if (!(userAttr instanceof Reader)) {
            response.sendRedirect(request.getContextPath() + "/profile/view");
            return;
        }
        Reader sessionReader = (Reader) userAttr;
        String fullName = StringUtil.cleanInput(request.getParameter("fullName"));
        String phone = StringUtil.cleanInput(request.getParameter("phone"));
        
        // Handle avatar file upload instead of Base64 parameter
        String avatarUrl = sessionReader.getAvatarUrl(); // keep old by default
        try {
            Part filePart = request.getPart("avatarFile");
            if (filePart != null && filePart.getSize() > 0) {
                String contentType = filePart.getContentType();
                if (contentType != null && (contentType.equals("image/jpeg") || contentType.equals("image/png") || contentType.equals("image/gif"))) {
                    if (filePart.getSize() <= 2 * 1024 * 1024) { // Max 2MB
                        InputStream fileContent = filePart.getInputStream();
                        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
                        int nRead;
                        byte[] data = new byte[16384];
                        while ((nRead = fileContent.read(data, 0, data.length)) != -1) {
                            buffer.write(data, 0, nRead);
                        }
                        byte[] fileBytes = buffer.toByteArray();
                        String base64Image = Base64.getEncoder().encodeToString(fileBytes);
                        avatarUrl = "data:" + contentType + ";base64," + base64Image;
                    } else {
                        request.setAttribute("error", "Ảnh quá lớn! Vui lòng chọn ảnh nhỏ hơn 2MB.");
                        request.getRequestDispatcher("/jsp/profile/view-profile.jsp").forward(request, response);
                        return;
                    }
                } else {
                    request.setAttribute("error", "Định dạng ảnh không hợp lệ! Vui lòng chọn JPG, PNG hoặc GIF.");
                    request.getRequestDispatcher("/jsp/profile/view-profile.jsp").forward(request, response);
                    return;
                }
            }
        } catch (Exception e) {
            // Ignore if part not found or not multipart request
            LOGGER.log(Level.WARNING, "Error parsing multipart avatar data", e);
        }

        if (StringUtil.isBlank(fullName)) {
            request.setAttribute("error", "Họ tên không được để trống.");
            request.getRequestDispatcher("/jsp/profile/view-profile.jsp").forward(request, response);
            return;
        }

        // F04: Validation Tuổi >= 15
        String dobStr = request.getParameter("dob");
        if (dobStr != null && !dobStr.isEmpty()) {
            try {
                java.time.LocalDate dob = java.time.LocalDate.parse(dobStr);
                if (java.time.LocalDate.now().minusYears(15).isBefore(dob)) {
                    request.setAttribute("error", "Bạn chưa đủ 15 tuổi.");
                    request.getRequestDispatcher("/jsp/profile/view-profile.jsp").forward(request, response);
                    return;
                }
            } catch (Exception e) {
                request.setAttribute("error", "Ngày sinh không hợp lệ.");
                request.getRequestDispatcher("/jsp/profile/view-profile.jsp").forward(request, response);
                return;
            }
        }

        ReaderDAO readerDAO = null;
        try {
            readerDAO = new ReaderDAO();
            Reader updated = new Reader();
            updated.setReaderId(sessionReader.getReaderId());
            updated.setFullName(fullName);
            updated.setPhone(phone);
            updated.setAvatarUrl(avatarUrl);

            // BUG_003: Nếu SĐT bị trùng, DB ném SQLIntegrityConstraintViolationException
            // Cố tình ném thẳng ra lỗi RuntimeException để sập Web (Crash DB) thay vì báo lỗi thân thiện.
            if (readerDAO.updateProfile(updated)) {
                // Cập nhật session
                Reader freshReader = readerDAO.findById(sessionReader.getReaderId());
                request.getSession().setAttribute(AuthUtil.SESSION_USER, freshReader);
                response.sendRedirect(request.getContextPath() + "/profile/view?success=1");
                return;
            } else {
                request.setAttribute("error", "Không thể cập nhật hồ sơ. Vui lòng thử lại.");
            }
            request.getRequestDispatcher("/jsp/profile/view-profile.jsp").forward(request, response);
        } catch (Exception e) {
            // Ném thẳng lỗi để tạo Bug 500 như kịch bản
            throw new RuntimeException("BUG_003: Crash DB do trùng số điện thoại", e);
        } finally {
            if (readerDAO != null) {
                readerDAO.close();
            }
        }
    }

    // ========================= CHANGE PASSWORD =========================

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Object userAttr = request.getSession().getAttribute(AuthUtil.SESSION_USER);
        if (userAttr == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        boolean isReader = userAttr instanceof model.Reader;
        boolean hasPassword = false;
        int userId = -1;
        String currentHash = "";
        
        if (isReader) {
            model.Reader r = (model.Reader) userAttr;
            hasPassword = r.hasPassword();
            userId = r.getReaderId();
            currentHash = r.getPasswordHash();
        } else if (userAttr instanceof model.Employee) {
            model.Employee e = (model.Employee) userAttr;
            hasPassword = e.hasPassword();
            userId = e.getEmployeeId();
            currentHash = e.getPasswordHash();
        }

        if (isReader && !hasPassword) {
            request.setAttribute("error", "Tài kho?n c?a b?n dang nh?p qua m?ng xã h?i. Vui lòng thi?t l?p m?t kh?u.");
            request.getRequestDispatcher("/jsp/profile/change-password.jsp").forward(request, response);
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        try {
            if (!util.PasswordUtil.verifyPassword(currentPassword, currentHash)) {
                request.setAttribute("error", "M?t kh?u hi?n t?i không dúng.");
                request.getRequestDispatcher("/jsp/profile/change-password.jsp").forward(request, response);
                return;
            }
            if (!util.PasswordUtil.isStrongPassword(newPassword)) {
                request.setAttribute("error", "M?t kh?u m?i ph?i có ít nh?t 8 ký t?, ch? hoa, ch? thu?ng và s?.");
                request.getRequestDispatcher("/jsp/profile/change-password.jsp").forward(request, response);
                return;
            }
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Xác nh?n m?t kh?u m?i không kh?p.");
                request.getRequestDispatcher("/jsp/profile/change-password.jsp").forward(request, response);
                return;
            }

            boolean success = false;
            if (isReader) {
                dao.ReaderDAO readerDAO = new dao.ReaderDAO();
                success = readerDAO.updatePasswordHash(userId, util.PasswordUtil.hashPassword(newPassword));
                if (success) {
                   model.Reader updatedReader = readerDAO.findById(userId);
                   request.getSession().setAttribute(util.AuthUtil.SESSION_USER, updatedReader);
                }
                readerDAO.close();
            } else {
                dao.EmployeeDAO empDAO = new dao.EmployeeDAO();
                success = empDAO.updatePasswordHash(userId, util.PasswordUtil.hashPassword(newPassword));
                if (success) {
                   model.Employee updatedEmp = empDAO.findById(userId);
                   request.getSession().setAttribute(util.AuthUtil.SESSION_USER, updatedEmp);
                }
                empDAO.close();
            }

            if (success) {
                request.setAttribute("success", "Ð?i m?t kh?u thành công!");
            } else {
                request.setAttribute("error", "Không th? d?i m?t kh?u. Vui lòng th? l?i.");
            }
            request.getRequestDispatcher("/jsp/profile/change-password.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có l?i x?y ra.");
            request.getRequestDispatcher("/jsp/profile/change-password.jsp").forward(request, response);
        }
    }

    private void handleShowLinkedAccounts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Reader reader = (Reader) request.getSession().getAttribute(AuthUtil.SESSION_USER);
        LinkedAccountDAO dao = null;
        try {
            dao = new LinkedAccountDAO();
            request.setAttribute("linkedAccounts", dao.getLinkedAccounts(reader.getReaderId()));
            request.setAttribute("isGoogleLinked", dao.isLinked(reader.getReaderId(), "google"));

            request.getRequestDispatcher("/jsp/profile/linked-accounts.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Show linked accounts error", e);
            request.setAttribute("error", "Có lỗi xảy ra.");
            request.getRequestDispatcher("/jsp/profile/linked-accounts.jsp").forward(request, response);
        } finally {
            if (dao != null)
                dao.close();
        }
    }

    private void handleUnlinkAccount(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Reader reader = (Reader) request.getSession().getAttribute(AuthUtil.SESSION_USER);
        String linkIdStr = request.getParameter("linkId");
        try {
            int linkId = Integer.parseInt(linkIdStr);
            LinkedAccountDAO dao = new LinkedAccountDAO();
            try {
                dao.unlinkAccount(linkId, reader.getReaderId());
            } finally {
                dao.close();
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Unlink account error", e);
        }
        response.sendRedirect(request.getContextPath() + "/profile/linked-accounts?unlinked=1");
    }

    // ========================= Helpers =========================

    private boolean requireLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!AuthUtil.isLoggedIn(request)) {
            String currentPath = request.getRequestURI().replace(request.getContextPath(), "");
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=" + currentPath);
            return false;
        }
        return true;
    }
}

