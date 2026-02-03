package controller;

import dao.ReaderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Reader;
import model.Employee;
import utils.AuthenticationService;
import utils.GoogleOAuthUtil;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    
    private AuthenticationService authService;
    
    @Override
    public void init() throws ServletException {
        authService = new AuthenticationService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Nếu đã đăng nhập (Reader hoặc Employee), redirect theo role
        if (session != null) {
            if (session.getAttribute("reader") != null) {
                Reader reader = (Reader) session.getAttribute("reader");
                String redirectPath = determineRedirectPath(reader.getRole() != null ? reader.getRole().getRoleName() : "USER");
                response.sendRedirect(request.getContextPath() + redirectPath);
                return;
            } else if (session.getAttribute("employee") != null) {
                Employee employee = (Employee) session.getAttribute("employee");
                String redirectPath = determineRedirectPath(employee.getRole() != null ? employee.getRole().getRoleName() : "USER");
                response.sendRedirect(request.getContextPath() + redirectPath);
                return;
            }
        }
        
        // Lấy Google OAuth URL
        String googleAuthUrl = GoogleOAuthUtil.getAuthorizationUrl(request);
        request.setAttribute("googleAuthUrl", googleAuthUrl);
        
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        String errorMessage = null;
        
        // Validation
        if (email == null || email.trim().isEmpty()) {
            errorMessage = "Email không được để trống";
        } else if (password == null || password.trim().isEmpty()) {
            errorMessage = "Mật khẩu không được để trống";
        } else if (!isValidEmail(email)) {
            errorMessage = "Email không hợp lệ";
        }
        
        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
            String googleAuthUrl = GoogleOAuthUtil.getAuthorizationUrl(request);
            request.setAttribute("googleAuthUrl", googleAuthUrl);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Xác thực từ cả Reader và Employee
            AuthenticationService.AuthenticationResult authResult = authService.authenticate(email.trim(), password);
            
            if (authResult != null) {
                // Kiểm tra trạng thái tài khoản (đã được kiểm tra trong AuthenticationService)
                // Chỉ cần kiểm tra lại nếu cần thiết
                String status = null;
                if (authResult.getUserType() == AuthenticationService.UserType.READER) {
                    status = authResult.getReader().getStatus();
                } else {
                    status = authResult.getEmployee().getStatus();
                }
                
                // Nếu status là "inactive", từ chối đăng nhập
                if (status != null && "inactive".equalsIgnoreCase(status)) {
                    request.setAttribute("error", "Tài khoản của bạn đã bị khóa");
                    String googleAuthUrl = GoogleOAuthUtil.getAuthorizationUrl(request);
                    request.setAttribute("googleAuthUrl", googleAuthUrl);
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }
                
                // Tạo session
                HttpSession session = request.getSession();
                String roleName = authResult.getRoleName();
                
                if (authResult.getUserType() == AuthenticationService.UserType.READER) {
                    // Lưu thông tin Reader vào session
                    session.setAttribute("reader", authResult.getReader());
                    session.setAttribute("userType", "READER");
                    session.setAttribute("userId", authResult.getReader().getReaderId());
                    session.setAttribute("userName", authResult.getFullName());
                    session.setAttribute("userEmail", authResult.getEmail());
                    session.setAttribute("userRole", roleName);
                } else {
                    // Lưu thông tin Employee vào session
                    session.setAttribute("employee", authResult.getEmployee());
                    session.setAttribute("userType", "EMPLOYEE");
                    session.setAttribute("userId", authResult.getEmployee().getEmployeeId());
                    session.setAttribute("userName", authResult.getFullName());
                    session.setAttribute("userEmail", authResult.getEmail());
                    session.setAttribute("userRole", roleName);
                }
                
                // Redirect dựa trên role từ database
                String redirectPath = determineRedirectPath(roleName);
                response.sendRedirect(request.getContextPath() + redirectPath);
            } else {
                request.setAttribute("error", "Email hoặc mật khẩu không đúng");
                String googleAuthUrl = GoogleOAuthUtil.getAuthorizationUrl(request);
                request.setAttribute("googleAuthUrl", googleAuthUrl);
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
            String sqlErrorMessage = "Có lỗi xảy ra khi kết nối database: ";
            if (e.getMessage() != null && (e.getMessage().contains("Connection refused") || e.getMessage().contains("TCP/IP"))) {
                sqlErrorMessage += "Không thể kết nối đến SQL Server. Vui lòng kiểm tra SQL Server đã được khởi động và đang lắng nghe trên port 1433.";
            } else {
                sqlErrorMessage += e.getMessage();
            }
            request.setAttribute("error", sqlErrorMessage);
            String googleAuthUrl = GoogleOAuthUtil.getAuthorizationUrl(request);
            request.setAttribute("googleAuthUrl", googleAuthUrl);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại sau: " + (e.getMessage() != null ? e.getMessage() : e.getClass().getName()));
            String googleAuthUrl = GoogleOAuthUtil.getAuthorizationUrl(request);
            request.setAttribute("googleAuthUrl", googleAuthUrl);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@(.+)$");
    }
    
    /**
     * Xác định đường dẫn redirect dựa trên role từ database
     * Phân quyền theo logic: ADMIN, LIBRARIAN, SELLER từ Employee, USER từ Reader
     */
    private String determineRedirectPath(String roleName) {
        if (roleName == null) {
            return "/user/dashboard";
        }
        
        switch (roleName.toUpperCase()) {
            case "ADMIN":
                return "/admin/dashboard";
            case "LIBRARIAN":
                return "/librarian/dashboard";
            case "SELLER":
                return "/seller/dashboard";
            case "USER":
            default:
                return "/user/dashboard";
        }
    }
}
