package controller;

import dao.LinkedAccountDAO;
import dao.ReaderDAO;
import model.Reader;
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
        if (!requireReaderLogin(request, response))
            return;

        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "/view";

        switch (pathInfo) {
            case "/view":
                request.getRequestDispatcher("/WEB-INF/jsp/profile/view-profile.jsp").forward(request, response);
                break;
            case "/edit":
                handleShowEditProfile(request, response);
                break;
            case "/change-password":
                request.getRequestDispatcher("/WEB-INF/jsp/profile/change-password.jsp").forward(request, response);
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

        if (!requireReaderLogin(request, response))
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
        request.getRequestDispatcher("/WEB-INF/jsp/profile/edit-profile.jsp").forward(request, response);
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Reader sessionReader = (Reader) request.getSession().getAttribute(AuthUtil.SESSION_USER);
        String fullName = StringUtil.cleanInput(request.getParameter("fullName"));
        String phone = StringUtil.cleanInput(request.getParameter("phone"));
        String avatarUrl = StringUtil.cleanInput(request.getParameter("avatarUrl"));

        if (StringUtil.isBlank(fullName)) {
            request.setAttribute("error", "Họ tên không được để trống.");
            request.getRequestDispatcher("/WEB-INF/jsp/profile/view-profile.jsp").forward(request, response);
            return;
        }

        // Validate ảnh đại diện chỉ nhận JPG, Jpeg, Gif
        if (avatarUrl != null && !avatarUrl.isEmpty() && !avatarUrl.startsWith("http")) { // Bỏ qua URL từ Google/FB
                                                                                          // (http...)
            if (!avatarUrl.startsWith("data:image/jpeg;base64,") &&
                    !avatarUrl.startsWith("data:image/jpg;base64,") &&
                    !avatarUrl.startsWith("data:image/gif;base64,")) {

                request.setAttribute("error", "Định dạng ảnh không hợp lệ! Vui lòng chọn JPG hoặc GIF.");
                request.getRequestDispatcher("/WEB-INF/jsp/profile/view-profile.jsp").forward(request, response);
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
            request.getRequestDispatcher("/WEB-INF/jsp/profile/view-profile.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Update profile error", e);
            request.setAttribute("error", "Có lỗi xảy ra.");
            request.getRequestDispatcher("/WEB-INF/jsp/profile/edit-profile.jsp").forward(request, response);
        } finally {
            if (readerDAO != null)
                readerDAO.close();
        }
    }

    // ========================= CHANGE PASSWORD =========================

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Reader sessionReader = (Reader) request.getSession().getAttribute(AuthUtil.SESSION_USER);

        // Kiểm tra Reader có password không (phòng trường hợp chỉ dùng Social Login)
        if (!sessionReader.hasPassword()) {
            request.setAttribute("error", "Tài khoản của bạn không sử dụng mật khẩu (đăng nhập qua mạng xã hội).");
            request.getRequestDispatcher("/WEB-INF/jsp/profile/change-password.jsp").forward(request, response);
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        ReaderDAO readerDAO = null;
        try {
            readerDAO = new ReaderDAO();
            Reader reader = readerDAO.findById(sessionReader.getReaderId());

            if (!PasswordUtil.verifyPassword(currentPassword, reader.getPasswordHash())) {
                request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
                request.getRequestDispatcher("/WEB-INF/jsp/profile/change-password.jsp").forward(request, response);
                return;
            }
            if (!PasswordUtil.isStrongPassword(newPassword)) {
                request.setAttribute("error", "Mật khẩu mới phải có ít nhất 8 ký tự, chữ hoa, chữ thường và số.");
                request.getRequestDispatcher("/WEB-INF/jsp/profile/change-password.jsp").forward(request, response);
                return;
            }
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Xác nhận mật khẩu mới không khớp.");
                request.getRequestDispatcher("/WEB-INF/jsp/profile/change-password.jsp").forward(request, response);
                return;
            }

            if (readerDAO.updatePasswordHash(reader.getReaderId(), PasswordUtil.hashPassword(newPassword))) {
                request.setAttribute("success", "Đổi mật khẩu thành công!");
            } else {
                request.setAttribute("error", "Không thể đổi mật khẩu. Vui lòng thử lại.");
            }
            request.getRequestDispatcher("/WEB-INF/jsp/profile/change-password.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Change password error", e);
            request.setAttribute("error", "Có lỗi xảy ra.");
            request.getRequestDispatcher("/WEB-INF/jsp/profile/change-password.jsp").forward(request, response);
        } finally {
            if (readerDAO != null)
                readerDAO.close();
        }
    }

    // ========================= LINKED ACCOUNTS =========================

    private void handleShowLinkedAccounts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Reader reader = (Reader) request.getSession().getAttribute(AuthUtil.SESSION_USER);
        LinkedAccountDAO dao = null;
        try {
            dao = new LinkedAccountDAO();
            request.setAttribute("linkedAccounts", dao.getLinkedAccounts(reader.getReaderId()));
            request.setAttribute("isGoogleLinked", dao.isLinked(reader.getReaderId(), "google"));
            request.setAttribute("isFacebookLinked", dao.isLinked(reader.getReaderId(), "facebook"));
            request.getRequestDispatcher("/WEB-INF/jsp/profile/linked-accounts.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Show linked accounts error", e);
            request.setAttribute("error", "Có lỗi xảy ra.");
            request.getRequestDispatcher("/WEB-INF/jsp/profile/linked-accounts.jsp").forward(request, response);
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

    private boolean requireReaderLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String role = AuthUtil.getUserRole(request);
        boolean allowed = AuthUtil.isLoggedIn(request) &&
                (AuthUtil.ROLE_READER.equals(role) || "User".equals(role));
        if (!allowed) {
            String currentPath = request.getRequestURI().replace(request.getContextPath(), "");
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=" + currentPath);
            return false;
        }
        return true;
    }
}
