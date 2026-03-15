package controller;

import dao.EmployeeDAO;
import dao.ReaderDAO;
import dao.NotificationDAO;
import model.Employee;
import model.GoogleAccount;
import model.LinkedAccount;
import model.Notification;
import model.Reader;
import util.AuthUtil;
import util.EmailUtil;
import util.GoogleUtils;
import util.PasswordUtil;
import util.StringUtil;
import util.TokenUtil;
import dao.LinkedAccountDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * AuthController - Xử lý Register, Login, Logout, Forgot/Reset Password
 * URL mappings: /auth/*
 */
public class AuthController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AuthController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo(); // e.g. "/login", "/register"
        if (pathInfo == null)
            pathInfo = "/login";

        switch (pathInfo) {
            case "/register":
                // Nếu đã login → redirect về home
                if (isLoggedInAsReader(request)) {
                    response.sendRedirect(request.getContextPath() + "/books");
                    return;
                }
                forward(request, response, "/jsp/auth/register.jsp");
                break;
            case "/login":
                if (isLoggedInAsReader(request)) {
                    response.sendRedirect(request.getContextPath() + "/books");
                    return;
                }
                forward(request, response, "/jsp/auth/login.jsp");
                break;
            case "/logout":
                handleLogout(request, response);
                break;
            case "/forgot-password":
                forward(request, response, "/jsp/auth/forgot-password.jsp");
                break;
            case "/reset-password":
                handleShowResetPassword(request, response);
                break;
            case "/oauth/google":
                handleGoogleOAuthRedirect(request, response);
                break;
            case "/google-callback":
                handleGoogleCallback(request, response);
                break;
            case "/verify-google-otp":
                if (request.getSession().getAttribute("pendingGoogleEmail") == null) {
                    response.sendRedirect(request.getContextPath() + "/auth/login");
                } else {
                    forward(request, response, "/jsp/auth/verify-google-otp.jsp");
                }
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/auth/login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();
        if (pathInfo == null)
            pathInfo = "";

        switch (pathInfo) {
            case "/register":
                handleRegister(request, response);
                break;
            case "/login":
                handleLogin(request, response);
                break;
            case "/forgot-password":
                handleForgotPassword(request, response);
                break;
            case "/reset-password":
                handleResetPassword(request, response);
                break;
            case "/verify-google-otp":
                handleVerifyGoogleOtp(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/auth/login");
        }
    }

    // ========================= REGISTER =========================

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = StringUtil.cleanInput(request.getParameter("fullName"));
        String email = StringUtil.cleanInput(request.getParameter("email"));
        String phone = StringUtil.cleanInput(request.getParameter("phone"));
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");

        // Validation
        if (StringUtil.isBlank(fullName)) {
            setErrorAndForward(request, response, "Vui lòng nhập họ tên.", "/jsp/auth/register.jsp");
            return;
        }
        if (StringUtil.isBlank(email) || !email.matches("^[\\w._%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$")) {
            setErrorAndForward(request, response, "Email không hợp lệ.", "/jsp/auth/register.jsp");
            return;
        }
        if (StringUtil.isBlank(password) || password.length() < 8) {
            setErrorAndForward(request, response, "Mật khẩu phải có ít nhất 8 ký tự.",
                    "/jsp/auth/register.jsp");
            return;
        }
        if (!PasswordUtil.isStrongPassword(password)) {
            setErrorAndForward(request, response, "Mật khẩu phải có chữ hoa, chữ thường và số.",
                    "/jsp/auth/register.jsp");
            return;
        }
        if (!password.equals(confirm)) {
            setErrorAndForward(request, response, "Xác nhận mật khẩu không khớp.", "/jsp/auth/register.jsp");
            return;
        }

        ReaderDAO readerDAO = null;
        try {
            readerDAO = new ReaderDAO();
            if (readerDAO.emailExists(email)) {
                setErrorAndForward(request, response, "Email này đã được đăng ký.", "/jsp/auth/register.jsp");
                return;
            }

            Reader reader = new Reader(fullName, email, PasswordUtil.hashPassword(password));
            reader.setPhone(phone);
            if (readerDAO.createReader(reader)) {
                // Gửi email chào mừng
                try {
                    EmailUtil.sendWelcomeEmail(email, fullName);
                } catch (Exception e) {
                    LOGGER.warning("Failed to send welcome email: " + e.getMessage());
                }
                // Tạo thông báo welcome
                NotificationDAO nDao = null;
                try {
                    nDao = new NotificationDAO();
                    nDao.createNotification(new Notification(reader.getReaderId(),
                            "Chào mừng bạn đến với Digital Library!",
                            "Tài khoản của bạn đã được tạo thành công. Hãy khám phá kho sách phong phú!",
                            "general"));
                } catch (Exception e) {
                    // ignore welcome notification failure
                } finally {
                    if (nDao != null)
                        nDao.close();
                }

                // Auto login sau đăng ký
                loginSession(request, reader);
                response.sendRedirect(request.getContextPath() + "/books?registered=1");
            } else {
                setErrorAndForward(request, response, "Đăng ký thất bại. Vui lòng thử lại.",
                        "/jsp/auth/register.jsp");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Register error", e);
            setErrorAndForward(request, response, "Có lỗi xảy ra. Vui lòng thử lại sau.",
                    "/jsp/auth/register.jsp");
        } finally {
            if (readerDAO != null)
                readerDAO.close();
        }
    }

    // ========================= LOGIN =========================

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = StringUtil.cleanInput(request.getParameter("email"));
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        if (StringUtil.isBlank(email) || StringUtil.isBlank(password)) {
            setErrorAndForward(request, response, "Vui lòng nhập email và mật khẩu.", "/jsp/auth/login.jsp");
            return;
        }

        // ---- Bước 1: Kiểm tra tài khoản Employee (Admin / Librarian / Seller) ----
        EmployeeDAO employeeDAO = null;
        try {
            employeeDAO = new EmployeeDAO();
            Employee employee = employeeDAO.findByEmail(email);

            if (employee != null && employee.hasPassword()
                    && verifyEmployeePassword(password, employee.getPasswordHash(), employee, employeeDAO)) {
                if (!employee.isActive()) {
                    setErrorAndForward(request, response, "Tài khoản nhân viên đã bị vô hiệu hóa.",
                            "/jsp/auth/login.jsp");
                    return;
                }
                // Đăng nhập thành công với role từ DB
                loginEmployeeSession(request, employee);

                // Redirect dựa trên role
                if (AuthUtil.ROLE_ADMIN.equals(employee.getAuthRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/books");
                }
                return;
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Employee login check error", e);
            // Tiếp tục thử Reader
        } finally {
            if (employeeDAO != null)
                employeeDAO.close();
        }

        // ---- Bước 2: Kiểm tra tài khoản Reader (người đọc thông thường) ----
        ReaderDAO readerDAO = null;
        try {
            readerDAO = new ReaderDAO();
            Reader reader = readerDAO.findByEmail(email);

            // Hỗ trợ cả mật khẩu hash (salt:hash) và plain text cũ, tương tự Employee
            if (reader == null || !reader.hasPassword()
                    || !verifyReaderPassword(password, reader.getPasswordHash(), reader, readerDAO)) {
                setErrorAndForward(request, response, "Email hoặc mật khẩu không đúng.", "/jsp/auth/login.jsp");
                return;
            }
            if (reader.isBanned()) {
                setErrorAndForward(request, response, "Tài khoản của bạn đã bị vô hiệu hóa.",
                        "/jsp/auth/login.jsp");
                return;
            }

            loginSession(request, reader);

            // Redirect về trang yêu cầu hoặc books
            if (redirect != null && !redirect.isBlank() && redirect.startsWith("/")) {
                response.sendRedirect(request.getContextPath() + redirect);
            } else {
                response.sendRedirect(request.getContextPath() + "/books");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Login error", e);
            setErrorAndForward(request, response, "Có lỗi xảy ra. Vui lòng thử lại.", "/jsp/auth/login.jsp");
        } finally {
            if (readerDAO != null)
                readerDAO.close();
        }
    }

    // ========================= GOOGLE OAUTH =========================

    private void handleGoogleOAuthRedirect(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String clientId = "427012296318-vp0ktmvucmettvj9ejttj6oo9uqtcqqg.apps.googleusercontent.com";
        String redirectUri = request.getScheme() + "://" + request.getServerName()
                + ":" + request.getServerPort()
                + request.getContextPath() + "/auth/google-callback";
        String scope = "openid%20email%20profile";
        String authUrl = "https://accounts.google.com/o/oauth2/v2/auth"
                + "?client_id=" + clientId
                + "&redirect_uri=" + java.net.URLEncoder.encode(redirectUri, "UTF-8")
                + "&response_type=code"
                + "&scope=" + scope
                + "&access_type=offline"
                + "&prompt=select_account";
        response.sendRedirect(authUrl);
    }

    private void handleGoogleCallback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        String error = request.getParameter("error");

        if (error != null || code == null || code.isBlank()) {
            setErrorAndForward(request, response, "Đăng nhập Google bị hủy hoặc thất bại.",
                    "/jsp/auth/login.jsp");
            return;
        }

        try {
            // Override redirect_uri to match what Google sends back to
            String redirectUri = request.getScheme() + "://" + request.getServerName()
                    + ":" + request.getServerPort()
                    + request.getContextPath() + "/auth/google-callback";

            // Temporarily set system property so GoogleUtils can use dynamic URI
            // We call getToken with dynamic redirect uri by constructing ourselves
            String accessToken = GoogleUtils.getTokenWithRedirect(code, redirectUri);
            GoogleAccount googleAccount = GoogleUtils.getUserInfo(accessToken);

            if (googleAccount == null || googleAccount.getEmail() == null) {
                setErrorAndForward(request, response, "Không lấy được thông tin tài khoản Google.",
                        "/jsp/auth/login.jsp");
                return;
            }

            String googleEmail = googleAccount.getEmail();
            String googleName = googleAccount.getName() != null ? googleAccount.getName() : googleEmail;

            // Tìm hoặc tạo Reader
            ReaderDAO readerDAO = null;
            try {
                readerDAO = new ReaderDAO();
                Reader reader = readerDAO.findByEmail(googleEmail);

                if (reader == null) {
                    // Tạo tài khoản mới cho Google user
                    // Cột password_hash trong DB là NOT NULL nên phải set một mật khẩu ngẫu nhiên
                    String randomPassword = TokenUtil.generateToken();
                    String randomHash = PasswordUtil.hashPassword(randomPassword);

                    reader = new Reader(googleName, googleEmail, randomHash);
                    reader.setStatus("active");
                    // role_id được mặc định = 4 (USER) trong ReaderDAO.createReader
                    readerDAO.createReader(reader);
                    reader = readerDAO.findByEmail(googleEmail);
                }

                if (reader == null) {
                    setErrorAndForward(request, response, "Không thể tạo tài khoản. Vui lòng thử lại.",
                            "/jsp/auth/login.jsp");
                    return;
                }

                if (reader.isBanned()
                        || (reader.getStatus() != null && !reader.getStatus().equalsIgnoreCase("active"))) {
                    setErrorAndForward(request, response, "Tài khoản của bạn đã bị vô hiệu hóa hoặc đang bị khóa.",
                            "/jsp/auth/login.jsp");
                    return;
                }

                LinkedAccountDAO linkedAccountDAO = new LinkedAccountDAO();
                try {
                    // Chuẩn hóa provider = "google" (lowercase) để đồng nhất với ProfileController/LinkedAccountDAO
                    if (!linkedAccountDAO.isLinked(reader.getReaderId(), "google")) {
                        LinkedAccount la = new LinkedAccount();
                        la.setReaderId(reader.getReaderId());
                        la.setProvider("google");
                        la.setProviderUserId(googleAccount.getId());
                        la.setProviderEmail(googleAccount.getEmail());
                        linkedAccountDAO.linkAccount(la);
                    }
                } finally {
                    linkedAccountDAO.close();
                }

                // ==== Gửi OTP xác nhận qua email ====
                String otp = TokenUtil.generateOTP();
                long expiry = System.currentTimeMillis() + 5 * 60 * 1000; // 5 phút

                HttpSession otpSession = request.getSession(true);
                otpSession.setAttribute("pendingGoogleEmail", googleEmail);
                otpSession.setAttribute("pendingGoogleName", googleName);
                otpSession.setAttribute("pendingGoogleReaderId", reader.getReaderId());
                otpSession.setAttribute("googleOtp", otp);
                otpSession.setAttribute("googleOtpExpiry", expiry);

                EmailUtil.sendGoogleLoginOtp(googleEmail, googleName, otp);
                response.sendRedirect(request.getContextPath() + "/auth/verify-google-otp");

            } finally {
                if (readerDAO != null)
                    readerDAO.close();
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Google OAuth callback error", e);
            setErrorAndForward(request, response, "Lỗi đăng nhập Google: " + e.getMessage(),
                    "/jsp/auth/login.jsp");
        }
    }

    // ========================= LOGOUT =========================

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/auth/login?logout=1");
    }

    // ========================= FORGOT PASSWORD =========================

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = StringUtil.cleanInput(request.getParameter("email"));
        if (StringUtil.isBlank(email)) {
            setErrorAndForward(request, response, "Vui lòng nhập email.", "/jsp/auth/forgot-password.jsp");
            return;
        }

        ReaderDAO readerDAO = null;
        try {
            readerDAO = new ReaderDAO();
            Reader reader = readerDAO.findByEmail(email);

            // Luôn hiện thông báo thành công để tránh email enumeration
            if (reader != null) {
                String token = TokenUtil.generateToken();
                if (readerDAO.saveResetToken(reader.getReaderId(), token)) {
                    String resetLink = request.getScheme() + "://" + request.getServerName()
                            + ":" + request.getServerPort()
                            + request.getContextPath()
                            + "/auth/reset-password?token=" + token;
                    EmailUtil.sendPasswordResetEmail(email, reader.getFullName(), resetLink);
                }
            }
            request.setAttribute("success",
                    "Nếu email tồn tại trong hệ thống, chúng tôi đã gửi link đặt lại mật khẩu.");
            forward(request, response, "/jsp/auth/forgot-password.jsp");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Forgot password error", e);
            setErrorAndForward(request, response, "Có lỗi xảy ra. Vui lòng thử lại.",
                    "/jsp/auth/forgot-password.jsp");
        } finally {
            if (readerDAO != null)
                readerDAO.close();
        }
    }

    // ========================= RESET PASSWORD =========================

    private void handleShowResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        if (!TokenUtil.isValidTokenFormat(token)) {
            request.setAttribute("error", "Link đặt lại mật khẩu không hợp lệ hoặc đã hết hạn.");
            forward(request, response, "/jsp/auth/reset-password.jsp");
            return;
        }
        ReaderDAO readerDAO = null;
        try {
            readerDAO = new ReaderDAO();
            int readerId = readerDAO.validateResetToken(token);
            if (readerId < 0) {
                request.setAttribute("error", "Link đặt lại mật khẩu đã hết hạn hoặc đã được sử dụng.");
            } else {
                request.setAttribute("token", token);
            }
            forward(request, response, "/jsp/auth/reset-password.jsp");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Show reset password error", e);
            request.setAttribute("error", "Có lỗi xảy ra.");
            forward(request, response, "/jsp/auth/reset-password.jsp");
        } finally {
            if (readerDAO != null)
                readerDAO.close();
        }
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");

        if (!TokenUtil.isValidTokenFormat(token)) {
            request.setAttribute("error", "Token không hợp lệ.");
            forward(request, response, "/jsp/auth/reset-password.jsp");
            return;
        }
        if (!PasswordUtil.isStrongPassword(password)) {
            request.setAttribute("token", token);
            request.setAttribute("error", "Mật khẩu phải có ít nhất 8 ký tự, chữ hoa, chữ thường và số.");
            forward(request, response, "/jsp/auth/reset-password.jsp");
            return;
        }
        if (!password.equals(confirm)) {
            request.setAttribute("token", token);
            request.setAttribute("error", "Xác nhận mật khẩu không khớp.");
            forward(request, response, "/jsp/auth/reset-password.jsp");
            return;
        }

        ReaderDAO readerDAO = null;
        try {
            readerDAO = new ReaderDAO();
            int readerId = readerDAO.validateResetToken(token);
            if (readerId < 0) {
                request.setAttribute("error", "Link đặt lại mật khẩu đã hết hạn.");
                forward(request, response, "/jsp/auth/reset-password.jsp");
                return;
            }
            readerDAO.updatePasswordHash(readerId, PasswordUtil.hashPassword(password));
            readerDAO.markTokenUsed(token);
            response.sendRedirect(request.getContextPath() + "/auth/login?reset=1");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Reset password error", e);
            request.setAttribute("token", token);
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
            forward(request, response, "/jsp/auth/reset-password.jsp");
        } finally {
            if (readerDAO != null)
                readerDAO.close();
        }
    }

    // ========================= Helpers =========================

    private void loginSession(HttpServletRequest request, Reader reader) {
        HttpSession session = request.getSession(true);
        session.setAttribute(AuthUtil.SESSION_USER, reader);
        session.setAttribute(AuthUtil.SESSION_USER_ID, reader.getReaderId());
        session.setAttribute(AuthUtil.SESSION_USER_ROLE, AuthUtil.ROLE_READER);
        session.setAttribute("readerId", reader.getReaderId());
    }

    /** Tạo session cho Employee (Admin / Librarian / Seller) */
    private void loginEmployeeSession(HttpServletRequest request, Employee employee) {
        HttpSession session = request.getSession(true);
        session.setAttribute(AuthUtil.SESSION_USER, employee);
        session.setAttribute(AuthUtil.SESSION_USER_ID, employee.getEmployeeId());
        session.setAttribute(AuthUtil.SESSION_EMPLOYEE_ID, employee.getEmployeeId());
        // Lưu thêm attribute "employee" để AuthFilter có thể lấy ra
        session.setAttribute("employee", employee);
        // Role từ DB được map sang hằng trong AuthUtil: ADMIN → "Admin", LIBRARIAN → "Librarian", SELLER → "Seller"
        session.setAttribute(AuthUtil.SESSION_USER_ROLE, employee.getAuthRole());
    }

    /**
     * Verify mật khẩu Employee — hỗ trợ:
     * 1. salt:hash (format mới đúng chuẩn)
     * 2. Legacy SHA-256 hex (script SQL cũ)
     * 3. Plain text (dữ liệu dev) — và tự động upgrade lên hash mới
     */
    private boolean verifyEmployeePassword(String rawPassword, String storedHash,
            Employee employee, EmployeeDAO employeeDAO) {
        if (storedHash == null) {
            return false;
        }
        // 1) Đúng chuẩn salt:hash mới
        if (storedHash.contains(":")) {
            return PasswordUtil.verifyPassword(rawPassword, storedHash);
        }
        // 2) Legacy SHA-256 hex không có salt/pepper (dùng trong script seed DB)
        if (storedHash.length() == 64 && PasswordUtil.verifyLegacySha256(rawPassword, storedHash)) {
            try {
                String newHash = PasswordUtil.hashPassword(rawPassword);
                employeeDAO.updatePasswordHash(employee.getEmployeeId(), newHash);
                LOGGER.info("Auto-upgraded legacy SHA-256 Employee password to salted hash for: " + employee.getEmail());
            } catch (Exception ex) {
                LOGGER.warning("Could not upgrade legacy employee password hash: " + ex.getMessage());
            }
            return true;
        }
        // 3) Plain text fallback (legacy / dev data)
        if (rawPassword.equals(storedHash)) {
            try {
                String newHash = PasswordUtil.hashPassword(rawPassword);
                employeeDAO.updatePasswordHash(employee.getEmployeeId(), newHash);
                LOGGER.info("Auto-upgraded Employee password to hash for: " + employee.getEmail());
            } catch (Exception ex) {
                LOGGER.warning("Could not upgrade employee password hash: " + ex.getMessage());
            }
            return true;
        }
        return false;
    }

    /**
     * Verify mật khẩu Reader — hỗ trợ:
     * 1. salt:hash (format mới đúng chuẩn)
     * 2. Legacy SHA-256 hex (script SQL cũ)
     * 3. Plain text (dữ liệu cũ/dev) — tự động upgrade
     */
    private boolean verifyReaderPassword(String rawPassword, String storedHash,
            Reader reader, ReaderDAO readerDAO) {
        if (storedHash == null) {
            return false;
        }
        // 1) Nếu đã ở format salt:hash chuẩn
        if (storedHash.contains(":")) {
            return PasswordUtil.verifyPassword(rawPassword, storedHash);
        }
        // 2) Legacy SHA-256 hex (script SQL)
        if (storedHash.length() == 64 && PasswordUtil.verifyLegacySha256(rawPassword, storedHash)) {
            try {
                String newHash = PasswordUtil.hashPassword(rawPassword);
                readerDAO.updatePasswordHash(reader.getReaderId(), newHash);
                LOGGER.info("Auto-upgraded legacy SHA-256 Reader password to salted hash for: " + reader.getEmail());
            } catch (Exception ex) {
                LOGGER.warning("Could not upgrade legacy reader password hash: " + ex.getMessage());
            }
            return true;
        }
        // 3) Plain text fallback (legacy / dev data)
        if (rawPassword.equals(storedHash)) {
            try {
                String newHash = PasswordUtil.hashPassword(rawPassword);
                readerDAO.updatePasswordHash(reader.getReaderId(), newHash);
                LOGGER.info("Auto-upgraded Reader password to hash for: " + reader.getEmail());
            } catch (Exception ex) {
                LOGGER.warning("Could not upgrade reader password hash: " + ex.getMessage());
            }
            return true;
        }
        return false;
    }

    private boolean isLoggedInAsReader(HttpServletRequest request) {
        return AuthUtil.isLoggedIn(request) && AuthUtil.ROLE_READER.equals(AuthUtil.getUserRole(request));
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String path)
            throws ServletException, IOException {
        req.getRequestDispatcher(path).forward(req, resp);
    }

    private void setErrorAndForward(HttpServletRequest req, HttpServletResponse resp, String error, String path)
            throws ServletException, IOException {
        req.setAttribute("error", error);
        // Preserve form input
        req.setAttribute("inputFullName", req.getParameter("fullName"));
        req.setAttribute("inputEmail", req.getParameter("email"));
        req.setAttribute("inputPhone", req.getParameter("phone"));
        forward(req, resp, path);
    }

    // ========================= VERIFY GOOGLE OTP =========================

    private void handleVerifyGoogleOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        String inputOtp = request.getParameter("otp");
        String sessionOtp = session != null ? (String) session.getAttribute("googleOtp") : null;
        Long expiry = session != null ? (Long) session.getAttribute("googleOtpExpiry") : null;
        Integer readerId = session != null ? (Integer) session.getAttribute("pendingGoogleReaderId") : null;

        if (session == null || sessionOtp == null || readerId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // Kiểm tra hết hạn
        if (expiry == null || System.currentTimeMillis() > expiry) {
            session.removeAttribute("googleOtp");
            request.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng đăng nhập lại.");
            forward(request, response, "/jsp/auth/verify-google-otp.jsp");
            return;
        }

        // Kiểm tra OTP
        if (!sessionOtp.equals(inputOtp != null ? inputOtp.trim() : "")) {
            request.setAttribute("error", "Mã OTP không đúng. Vui lòng thử lại.");
            forward(request, response, "/jsp/auth/verify-google-otp.jsp");
            return;
        }

        // OTP hợp lệ: xóa dữ liệu tạm + đăng nhập
        session.removeAttribute("googleOtp");
        session.removeAttribute("googleOtpExpiry");
        session.removeAttribute("pendingGoogleEmail");
        session.removeAttribute("pendingGoogleName");
        session.removeAttribute("pendingGoogleReaderId");

        ReaderDAO readerDAO = null;
        try {
            readerDAO = new ReaderDAO();
            Reader reader = readerDAO.findById(readerId);
            if (reader == null) {
                setErrorAndForward(request, response, "Tài khoản không tồn tại.", "/jsp/auth/login.jsp");
                return;
            }
            loginSession(request, reader);
            response.sendRedirect(request.getContextPath() + "/books");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Verify Google OTP error", e);
            setErrorAndForward(request, response, "Có lỗi xảy ra. Vui lòng thử lại.", "/jsp/auth/login.jsp");
        } finally {
            if (readerDAO != null)
                readerDAO.close();
        }
    }
}
