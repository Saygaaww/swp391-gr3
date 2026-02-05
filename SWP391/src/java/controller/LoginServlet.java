package controller;

import dal.ReaderDAO;
import dal.EmployeeDAO;
import model.Reader;
import model.Employee;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    
    private ReaderDAO readerDAO;
    private EmployeeDAO employeeDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        readerDAO = new ReaderDAO();
        employeeDAO = new EmployeeDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("logout".equals(action)) {
            logout(request, response);
        } else {
            String userType = request.getParameter("type");
            if ("librarian".equals(userType)) {
                request.getRequestDispatcher("/view/librarian/login.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/view/reader/login.jsp").forward(request, response);
            }
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userType = request.getParameter("userType");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
            if ("librarian".equals(userType)) {
                request.getRequestDispatcher("/view/librarian/login.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/view/reader/login.jsp").forward(request, response);
            }
            return;
        }
        
        HttpSession session = request.getSession();
        
        if ("librarian".equals(userType)) {
            Employee employee = employeeDAO.login(email, password);
            if (employee != null) {
                // Check if employee is librarian
                if ("LIBRARIAN".equalsIgnoreCase(employee.getRoleName())) {
                    session.setAttribute("employee", employee);
                    session.setAttribute("employeeId", employee.getEmployeeId());
                    session.setAttribute("userType", "librarian");
                    session.setAttribute("fullName", employee.getFullName());
                    response.sendRedirect("librarian?action=dashboard");
                } else {
                    request.setAttribute("error", "Bạn không có quyền truy cập trang này");
                    request.getRequestDispatcher("/view/librarian/login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Email hoặc mật khẩu không đúng");
                request.getRequestDispatcher("/view/librarian/login.jsp").forward(request, response);
            }
        } else {
            Reader reader = readerDAO.login(email, password);
            if (reader != null) {
                session.setAttribute("reader", reader);
                session.setAttribute("readerId", reader.getReaderId());
                session.setAttribute("userType", "reader");
                session.setAttribute("fullName", reader.getFullName());
                response.sendRedirect("book");
            } else {
                request.setAttribute("error", "Email hoặc mật khẩu không đúng");
                request.getRequestDispatcher("/view/reader/login.jsp").forward(request, response);
            }
        }
    }
    
    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.invalidate();
        response.sendRedirect("book");
    }
}
