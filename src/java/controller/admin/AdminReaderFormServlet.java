package controller.admin;

import dal.ReaderDAO;
import dal.RoleDAO;
import model.Reader;
import model.Role;
import model.Employee;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/reader-form")
public class AdminReaderFormServlet extends HttpServlet {

    private ReaderDAO readerDAO;
    private RoleDAO roleDAO;

    @Override
    public void init() throws ServletException {
        readerDAO = new ReaderDAO();
        roleDAO = new RoleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            request.setAttribute("roles", roleDAO.getAllRoles());
            String idStr = request.getParameter("id");

            if (idStr != null && !idStr.trim().isEmpty()) {
                int readerId = Integer.parseInt(idStr.trim());
                if (readerId <= 0 || readerId > 999999999) {
                    response.sendRedirect(request.getContextPath() + "/admin/readers");
                    return;
                }

                Reader reader = readerDAO.getReaderById(readerId);
                if (reader == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/readers");
                    return;
                }

                request.setAttribute("mode", "edit");
                request.setAttribute("reader", reader);
            } else {
                request.setAttribute("mode", "add");
                request.setAttribute("reader", new Reader());
            }

            request.setAttribute("currentEmployee", session.getAttribute("user"));
            request.getRequestDispatcher("/jsp/admin/reader-form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/readers");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/readers");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        try {
            String readerIdStr = request.getParameter("readerId");
            boolean isEdit = (readerIdStr != null && !readerIdStr.trim().isEmpty());

            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String status = request.getParameter("status");
            String password = request.getParameter("password");
            String roleIdStr = request.getParameter("roleId");

            // Validate
            StringBuilder errors = new StringBuilder();

            if (fullName == null || fullName.trim().isEmpty()) errors.append("Ho ten khong duoc de trong. ");
            else if (fullName.trim().length() > 255) errors.append("Ho ten khong duoc qua 255 ky tu. ");

            if (email == null || email.trim().isEmpty()) {
                errors.append("Email khong duoc de trong. ");
            } else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                errors.append("Email khong dung dinh dang. ");
            } else if (email.trim().length() > 255) {
                errors.append("Email khong duoc qua 255 ky tu. ");
            } else {
                // Kiem tra trung email
                if (isEdit) {
                    if (readerDAO.isEmailExistsExcept(email, Integer.parseInt(readerIdStr))) {
                        errors.append("Email da duoc su dung boi tai khoan khac. ");
                    }
                } else {
                    if (readerDAO.isEmailExists(email)) {
                        errors.append("Email da ton tai trong he thong. ");
                    }
                }
            }

            if (!isEdit && (password == null || password.trim().isEmpty())) {
                errors.append("Mat khau khong duoc de trong khi them moi. ");
            } else if (password != null && !password.trim().isEmpty() && password.trim().length() < 3) {
                errors.append("Mat khau phai co it nhat 3 ky tu. ");
            }

            if (phone != null && !phone.trim().isEmpty()) {
                if (phone.trim().length() > 30) errors.append("So dien thoai khong duoc qua 30 ky tu. ");
                if (!phone.trim().matches("^[0-9+\\-\\s()]+$")) errors.append("So dien thoai chi duoc chua so va ky tu +, -, (, ). ");
                // Kiem tra trung so dien thoai
                if (phone.trim().length() <= 30 && phone.trim().matches("^[0-9+\\-\\s()]+$")) {
                    if (isEdit) {
                        if (readerDAO.isPhoneExistsExcept(phone.trim(), Integer.parseInt(readerIdStr))) {
                            errors.append("So dien thoai da duoc su dung boi tai khoan khac. ");
                        }
                    } else {
                        if (readerDAO.isPhoneExists(phone.trim())) {
                            errors.append("So dien thoai da ton tai trong he thong. ");
                        }
                    }
                }
            }

            int roleId = 0;
            if (roleIdStr != null && !roleIdStr.trim().isEmpty()) {
                try {
                    roleId = Integer.parseInt(roleIdStr);
                    if (roleId > 0 && roleDAO.getRoleById(roleId) == null) {
                        errors.append("Vai tro khong ton tai. ");
                    }
                } catch (NumberFormatException e) {
                    errors.append("Vai tro khong hop le. ");
                }
            }
            if (roleId <= 0) errors.append("Vui long chon vai tro. ");

            if (status != null && !status.equals("active") && !status.equals("inactive") && !status.equals("blocked")) {
                status = "active";
            }

            // Neu co loi, quay lai form
            if (errors.length() > 0) {
                request.setAttribute("errorMessage", errors.toString());
                reloadForm(request, response, isEdit, readerIdStr, fullName, email, phone, status, roleId);
                return;
            }

            // Luu du lieu
            boolean success;

            if (isEdit) {
                int readerId = Integer.parseInt(readerIdStr.trim());
                if (readerId <= 0 || readerId > 999999999 || readerDAO.getReaderById(readerId) == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/readers");
                    return;
                }

                Reader reader = new Reader();
                reader.setReaderId(readerId);
                reader.setFullName(fullName.trim());
                reader.setEmail(email.trim());
                reader.setPhone(phone != null ? phone.trim() : null);
                reader.setStatus(status != null ? status : "active");
                reader.setRoleId(roleId);
                success = readerDAO.updateReader(reader);

                // Cap nhat mat khau neu co nhap
                if (password != null && !password.trim().isEmpty()) {
                    readerDAO.updateReaderPassword(readerId, util.PasswordUtil.hash(password.trim()));
                }
            } else {
                Reader reader = new Reader();
                reader.setFullName(fullName.trim());
                reader.setEmail(email.trim());
                reader.setPasswordHash(util.PasswordUtil.hash(password.trim()));
                reader.setPhone(phone != null ? phone.trim() : null);
                reader.setStatus(status != null ? status : "active");
                reader.setRoleId(roleId);
                success = readerDAO.addReader(reader);
            }

            if (success) {
                session.setAttribute("successMessage", isEdit ? "Cap nhat doc gia thanh cong." : "Them doc gia moi thanh cong.");
                response.sendRedirect(request.getContextPath() + "/admin/readers");
            } else {
                request.setAttribute("errorMessage", isEdit ? "Cap nhat that bai!" : "Them moi that bai!");
                reloadForm(request, response, isEdit, readerIdStr, fullName, email, phone, status, roleId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Loi he thong: " + e.getMessage());
            request.setAttribute("roles", roleDAO.getAllRoles());
            request.setAttribute("mode", "add");
            request.setAttribute("reader", new Reader());
            request.setAttribute("currentEmployee", request.getSession().getAttribute("employee"));
            request.getRequestDispatcher("/jsp/admin/reader-form.jsp").forward(request, response);
        }
    }

    private void reloadForm(HttpServletRequest request, HttpServletResponse response,
                             boolean isEdit, String readerIdStr,
                             String fullName, String email, String phone,
                             String status, int roleId)
            throws ServletException, IOException {

        request.setAttribute("roles", roleDAO.getAllRoles());

        Reader reader = new Reader();
        if (isEdit && readerIdStr != null) {
            try { reader.setReaderId(Integer.parseInt(readerIdStr)); }
            catch (NumberFormatException e) { }
            request.setAttribute("mode", "edit");
        } else {
            request.setAttribute("mode", "add");
        }

        reader.setFullName(fullName);
        reader.setEmail(email);
        reader.setPhone(phone);
        reader.setStatus(status);
        reader.setRoleId(roleId);

        request.setAttribute("reader", reader);
        request.setAttribute("currentEmployee", request.getSession().getAttribute("employee"));
        request.getRequestDispatcher("/jsp/admin/reader-form.jsp").forward(request, response);
    }
}
