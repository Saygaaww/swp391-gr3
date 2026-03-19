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
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * ProfileController - Edit Profile, Change Password, Linked Accounts
 * URL: /profile/*
 */
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
        String avatarUrl = StringUtil.cleanInput(request.getParameter("avatarUrl"));

        if (StringUtil.isBlank(fullName)) {
            request.setAttribute("error", "Họ tên không được để trống.");
            request.getRequestDispatcher("/jsp/profile/view-profile.jsp").forward(request, response);
            return;
        }

        // Validate ảnh đại diện chỉ nhận JPG, Jpeg, Gif
        if (avatarUrl != null && !avatarUrl.isEmpty() && !avatarUrl.startsWith("http")) { // Bỏ qua URL từ Google/FB
                                                                                          // (http...)
            if (!avatarUrl.startsWith("data:image/jpeg;base64,") &&
                    !avatarUrl.startsWith("data:image/jpg;base64,") &&
                    !avatarUrl.startsWith("data:image/gif;base64,")) {

                request.setAttribute("error", "Định dạng ảnh không hợp lệ! Vui lòng chọn JPG hoặc GIF.");
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
            LOGGER.log(Level.SEVERE, "Update profile error", e);
            request.setAttribute("error", "Có lỗi xảy ra.");
            request.getRequestDispatcher("/jsp/profile/edit-profile.jsp").forward(request, response);
        } finally {
            if (readerDAO != null)
                readerDAO.close();
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
            request.setAttribute("isFacebookLinked", dao.isLinked(reader.getReaderId(), "facebook"));
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
