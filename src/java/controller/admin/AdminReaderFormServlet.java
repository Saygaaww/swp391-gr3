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
        System.out.println("AdminReaderFormServlet initialized");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }
        
        Employee currentEmployee = (Employee) session.getAttribute("employee");
        
        try {
            List<Role> roles = roleDAO.getAllRoles();
            request.setAttribute("roles", roles);
            
            String idStr = request.getParameter("id");
            
            if (idStr != null && !idStr.trim().isEmpty()) {
                int readerId;
                try {
                    readerId = Integer.parseInt(idStr.trim());
                } catch (NumberFormatException e) {
                    System.err.println("Invalid reader ID format: " + idStr);
                    response.sendRedirect(request.getContextPath() + "/admin/readers");
                    return;
                }
                
                if (readerId <= 0 || readerId > 999999999) {
                    System.err.println("Reader ID out of range: " + readerId);
                    response.sendRedirect(request.getContextPath() + "/admin/readers");
                    return;
                }
                
                Reader reader = readerDAO.getReaderById(readerId);
                
                if (reader != null) {
                    request.setAttribute("mode", "edit");
                    request.setAttribute("reader", reader);
                    System.out.println("Edit reader ID: " + readerId);
                } else {
                    System.err.println("Reader not found: " + readerId);
                    response.sendRedirect(request.getContextPath() + "/admin/readers");
                    return;
                }
                
            } else {
                request.setAttribute("mode", "add");
                request.setAttribute("reader", new Reader());
                System.out.println("Add new reader");
            }
            
            request.setAttribute("currentEmployee", currentEmployee);
            request.getRequestDispatcher("/admin/reader-form.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in doGet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/readers");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
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
            
            StringBuilder errors = new StringBuilder();
            
            if (fullName == null || fullName.trim().isEmpty()) {
                errors.append("Ho ten khong duoc de trong. ");
            } else if (fullName.trim().length() > 255) {
                errors.append("Ho ten khong duoc qua 255 ky tu. ");
            }
            
            if (email == null || email.trim().isEmpty()) {
                errors.append("Email khong duoc de trong. ");
            } else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                errors.append("Email khong dung dinh dang. ");
            } else if (email.trim().length() > 255) {
                errors.append("Email khong duoc qua 255 ky tu. ");
            } else {
                if (isEdit) {
                    int readerId = Integer.parseInt(readerIdStr);
                    if (readerDAO.isEmailExistsExcept(email, readerId)) {
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
                if (phone.trim().length() > 30) {
                    errors.append("So dien thoai khong duoc qua 30 ky tu. ");
                }
                if (!phone.trim().matches("^[0-9+\\-\\s()]+$")) {
                    errors.append("So dien thoai chi duoc chua so va ky tu +, -, (, ). ");
                }
            }
            
            int roleId = 0;
            if (roleIdStr != null && !roleIdStr.trim().isEmpty()) {
                try {
                    roleId = Integer.parseInt(roleIdStr);
                    if (roleId > 0) {
                        Role role = roleDAO.getRoleById(roleId);
                        if (role == null) {
                            errors.append("Vai tro khong ton tai trong he thong. ");
                        }
                    }
                } catch (NumberFormatException e) {
                    errors.append("Vai tro khong hop le. ");
                }
            }
            if (roleId <= 0) {
                errors.append("Vui long chon vai tro cho doc gia. ");
            }
            
            if (status != null && !status.isEmpty()) {
                if (!status.equals("active") && !status.equals("inactive") && !status.equals("blocked")) {
                    status = "active";
                }
            }
            
            if (errors.length() > 0) {
                request.setAttribute("errorMessage", errors.toString());
                reloadFormWithError(request, response, isEdit, readerIdStr, 
                                   fullName, email, phone, status, roleId);
                return;
            }
            
            boolean success;
            
            if (isEdit) {
                int readerId;
                try {
                    readerId = Integer.parseInt(readerIdStr.trim());
                } catch (NumberFormatException e) {
                    request.getSession().setAttribute("errorMessage", "ID doc gia khong hop le!");
                    response.sendRedirect(request.getContextPath() + "/admin/readers");
                    return;
                }
                
                if (readerId <= 0 || readerId > 999999999) {
                    request.getSession().setAttribute("errorMessage", "ID doc gia ngoai pham vi!");
                    response.sendRedirect(request.getContextPath() + "/admin/readers");
                    return;
                }
                
                Reader existingReader = readerDAO.getReaderById(readerId);
                if (existingReader == null) {
                    request.getSession().setAttribute("errorMessage", "Doc gia khong ton tai!");
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
                    readerDAO.updateReaderPassword(readerId, password.trim());
                }
                
                if (success) {
                    System.out.println("Reader updated: " + fullName);
                    response.sendRedirect(request.getContextPath() + "/admin/readers?success=updated");
                } else {
                    request.setAttribute("errorMessage", "Cap nhat that bai!");
                    reloadFormWithError(request, response, isEdit, readerIdStr, 
                                       fullName, email, phone, status, roleId);
                }
                
            } else {
                Reader reader = new Reader();
                reader.setFullName(fullName.trim());
                reader.setEmail(email.trim());
                reader.setPasswordHash(password.trim());
                reader.setPhone(phone != null ? phone.trim() : null);
                reader.setStatus(status != null ? status : "active");
                reader.setRoleId(roleId);
                
                success = readerDAO.addReader(reader);
                
                if (success) {
                    System.out.println("Reader added: " + fullName);
                    response.sendRedirect(request.getContextPath() + "/admin/readers?success=added");
                } else {
                    request.setAttribute("errorMessage", "Them moi that bai!");
                    reloadFormWithError(request, response, isEdit, readerIdStr, 
                                       fullName, email, phone, status, roleId);
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error in doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Loi he thong: " + e.getMessage());
            
            // Reload form data khi exception
            request.setAttribute("roles", roleDAO.getAllRoles());
            request.setAttribute("mode", "add");
            request.setAttribute("reader", new Reader());
            request.setAttribute("currentEmployee", request.getSession().getAttribute("employee"));
            request.getRequestDispatcher("/admin/reader-form.jsp").forward(request, response);
        }
    }
    
    private void reloadFormWithError(HttpServletRequest request, HttpServletResponse response,
                                     boolean isEdit, String readerIdStr,
                                     String fullName, String email, String phone, 
                                     String status, int roleId) 
            throws ServletException, IOException {
        
        request.setAttribute("roles", roleDAO.getAllRoles());
        
        Reader reader = new Reader();
        
        if (isEdit && readerIdStr != null) {
            try {
                reader.setReaderId(Integer.parseInt(readerIdStr));
            } catch (NumberFormatException e) {
                // bo qua
            }
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
        request.getRequestDispatcher("/admin/reader-form.jsp").forward(request, response);
    }
}