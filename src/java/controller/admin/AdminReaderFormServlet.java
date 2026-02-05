package controller.admin;

import dal.ReaderDAO;
import model.Reader;
import model.Employee;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/admin/reader-form")
public class AdminReaderFormServlet extends HttpServlet {
    
    private ReaderDAO readerDAO;
    
    @Override
    public void init() throws ServletException {
        readerDAO = new ReaderDAO();
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
            String idStr = request.getParameter("id");
            
            if (idStr != null && !idStr.trim().isEmpty()) {
                int readerId = Integer.parseInt(idStr);
                Reader reader = readerDAO.getReaderById(readerId);
                
                if (reader != null) {
                    request.setAttribute("mode", "edit");
                    request.setAttribute("reader", reader);
                    System.out.println("Edit reader: " + reader.getFullName());
                } else {
                    request.setAttribute("errorMessage", "Không tìm thấy độc giả với ID: " + readerId);
                    request.setAttribute("mode", "add");
                    request.setAttribute("reader", new Reader());
                }
                
            } else {
                request.setAttribute("mode", "add");
                request.setAttribute("reader", new Reader());
                System.out.println("Add new reader");
            }
            
            request.setAttribute("currentEmployee", currentEmployee);
            request.getRequestDispatcher("/admin/reader-form.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid reader ID: " + request.getParameter("id"));
            request.setAttribute("errorMessage", "ID độc giả không hợp lệ");
            request.setAttribute("mode", "add");
            request.setAttribute("reader", new Reader());
            request.getRequestDispatcher("/admin/reader-form.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("AdminReaderFormServlet.doGet Error: " + e.getMessage());
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
            String address = request.getParameter("address");
            String status = request.getParameter("status");
            String password = request.getParameter("password");
            
            StringBuilder errors = new StringBuilder();
            
            if (fullName == null || fullName.trim().isEmpty()) {
                errors.append("Họ tên không được để trống. ");
            }
            
            if (email == null || email.trim().isEmpty()) {
                errors.append("Email không được để trống. ");
            } else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                errors.append("Email không đúng định dạng. ");
            } else {
                if (isEdit) {
                    int readerId = Integer.parseInt(readerIdStr);
                    if (readerDAO.isEmailExistsExcept(email, readerId)) {
                        errors.append("Email đã được sử dụng bởi tài khoản khác. ");
                    }
                } else {
                    if (readerDAO.isEmailExists(email)) {
                        errors.append("Email đã tồn tại trong hệ thống. ");
                    }
                }
            }
            
            if (!isEdit && (password == null || password.trim().isEmpty())) {
                errors.append("Mật khẩu không được để trống khi thêm mới. ");
            }
            
            if (errors.length() > 0) {
                request.setAttribute("errorMessage", errors.toString());
                reloadFormWithError(request, response, isEdit, readerIdStr, 
                                   fullName, email, phone, address, status);
                return;
            }
            
            boolean success;
            
            if (isEdit) {
                int readerId = Integer.parseInt(readerIdStr);
                Reader reader = new Reader();
                reader.setReaderId(readerId);
                reader.setFullName(fullName.trim());
                reader.setEmail(email.trim());
                reader.setPhone(phone != null ? phone.trim() : null);
                reader.setAddress(address != null ? address.trim() : null);
                reader.setStatus(status != null ? status : "active");
                
                success = readerDAO.updateReader(reader);
                
                // Nếu có nhập password mới thì update password
                if (password != null && !password.trim().isEmpty()) {
                    readerDAO.updateReaderPassword(readerId, password.trim());
                }
                
                if (success) {
                    System.out.println("Reader updated: " + fullName);
                    response.sendRedirect(request.getContextPath() + "/admin/readers?success=updated");
                } else {
                    request.setAttribute("errorMessage", "Cập nhật thất bại. Vui lòng thử lại.");
                    reloadFormWithError(request, response, isEdit, readerIdStr, 
                                       fullName, email, phone, address, status);
                }
                
            } else {
                Reader reader = new Reader();
                reader.setFullName(fullName.trim());
                reader.setEmail(email.trim());
                reader.setPasswordHash(password.trim());
                reader.setPhone(phone != null ? phone.trim() : null);
                reader.setAddress(address != null ? address.trim() : null);
                reader.setStatus(status != null ? status : "active");
                
                success = readerDAO.addReader(reader);
                
                if (success) {
                    System.out.println("Reader added: " + fullName);
                    response.sendRedirect(request.getContextPath() + "/admin/readers?success=added");
                } else {
                    request.setAttribute("errorMessage", "Thêm mới thất bại. Vui lòng thử lại.");
                    reloadFormWithError(request, response, isEdit, readerIdStr, 
                                       fullName, email, phone, address, status);
                }
            }
            
        } catch (Exception e) {
            System.err.println("AdminReaderFormServlet.doPost Error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/admin/reader-form.jsp").forward(request, response);
        }
    }
    
    private void reloadFormWithError(HttpServletRequest request, HttpServletResponse response,
                                     boolean isEdit, String readerIdStr,
                                     String fullName, String email, String phone, 
                                     String address, String status) 
            throws ServletException, IOException {
        
        Reader reader = new Reader();
        
        if (isEdit && readerIdStr != null) {
            reader.setReaderId(Integer.parseInt(readerIdStr));
            request.setAttribute("mode", "edit");
        } else {
            request.setAttribute("mode", "add");
        }
        
        reader.setFullName(fullName);
        reader.setEmail(email);
        reader.setPhone(phone);
        reader.setAddress(address);
        reader.setStatus(status);
        
        request.setAttribute("reader", reader);
        request.setAttribute("currentEmployee", request.getSession().getAttribute("employee"));
        request.getRequestDispatcher("/admin/reader-form.jsp").forward(request, response);
    }
}