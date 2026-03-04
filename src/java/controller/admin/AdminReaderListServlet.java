package controller.admin;

import dal.ReaderDAO;
import dal.RoleDAO;
import model.Reader;
import model.Role;
import model.Employee;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/readers")
public class AdminReaderListServlet extends HttpServlet {
    
    private ReaderDAO readerDAO;
    private RoleDAO roleDAO;
    private static final int DEFAULT_PAGE_SIZE = 10;
    
    @Override
    public void init() throws ServletException {
        readerDAO = new ReaderDAO();
        roleDAO = new RoleDAO();
        System.out.println("AdminReaderListServlet initialized");
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
        request.setCharacterEncoding("UTF-8");
        
        try {
            int pageSize = DEFAULT_PAGE_SIZE;
            String pageSizeStr = request.getParameter("pageSize");
            if (pageSizeStr != null && !pageSizeStr.trim().isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeStr);
                    if (pageSize != 5 && pageSize != 10 && pageSize != 20) {
                        pageSize = DEFAULT_PAGE_SIZE;
                    }
                } catch (NumberFormatException e) {
                    pageSize = DEFAULT_PAGE_SIZE;
                }
            }
            
            int currentPage = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            String keyword = request.getParameter("keyword");
            if (keyword != null) {
                keyword = keyword.trim().replaceAll("\\s+", " ");
                if (keyword.isEmpty()) keyword = null;
            }
            
            String filterStatus = request.getParameter("status");
            if (filterStatus != null && filterStatus.trim().isEmpty()) {
                filterStatus = null;
            }
            
            int filterRoleId = 0;
            String roleIdStr = request.getParameter("roleId");
            if (roleIdStr != null && !roleIdStr.trim().isEmpty()) {
                try {
                    filterRoleId = Integer.parseInt(roleIdStr);
                } catch (NumberFormatException e) {
                    filterRoleId = 0;
                }
            }
            
            int totalReaders = readerDAO.countReadersFiltered(keyword, filterStatus, filterRoleId);
            
            int totalPages = (int) Math.ceil((double) totalReaders / pageSize);
            if (totalPages < 1) totalPages = 1;
            if (currentPage > totalPages) currentPage = totalPages;
            
            List<Reader> readerList = readerDAO.getReadersFiltered(
                    keyword, filterStatus, filterRoleId, currentPage, pageSize);
            
            int activeCount = readerDAO.countReadersByStatus("active");
            int blockedCount = readerDAO.countReadersByStatus("blocked");
            int inactiveCount = readerDAO.countReadersByStatus("inactive");
            
            List<Role> roles = roleDAO.getAllRoles();
            
            request.setAttribute("readerList", readerList);
            request.setAttribute("totalReaders", totalReaders);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", String.valueOf(pageSize));
            request.setAttribute("currentEmployee", currentEmployee);
            request.setAttribute("activeCount", activeCount);
            request.setAttribute("blockedCount", blockedCount);
            request.setAttribute("inactiveCount", inactiveCount);
            
            // Filter data
            request.setAttribute("roles", roles);
            request.setAttribute("keyword", keyword);
            request.setAttribute("filterStatus", filterStatus);
            request.setAttribute("filterRoleId", filterRoleId);
            
            request.getRequestDispatcher("/admin/reader-list.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Loi he thong: " + e.getMessage());
            request.getRequestDispatcher("/admin/reader-list.jsp").forward(request, response);
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
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");
        
        if (action != null && idStr != null) {
            try {
                int readerId;
                try {
                    readerId = Integer.parseInt(idStr.trim());
                } catch (NumberFormatException e) {
                    System.err.println("Invalid reader ID format: " + idStr);
                    session.setAttribute("errorMessage", "ID doc gia khong hop le!");
                    response.sendRedirect(request.getContextPath() + "/admin/readers");
                    return;
                }
                
                if (readerId <= 0 || readerId > 999999999) {
                    System.err.println("Reader ID out of range: " + idStr);
                    session.setAttribute("errorMessage", "ID doc gia ngoai pham vi!");
                    response.sendRedirect(request.getContextPath() + "/admin/readers");
                    return;
                }
                
                Reader reader = readerDAO.getReaderById(readerId);
                
                if (reader == null) {
                    System.err.println("Reader not found: " + readerId);
                    session.setAttribute("errorMessage", "Khong tim thay doc gia ID: " + readerId);
                    response.sendRedirect(request.getContextPath() + "/admin/readers");
                    return;
                }
                
                boolean success = false;
                
                if ("block".equals(action)) {
                    if ("blocked".equals(reader.getStatus())) {
                        session.setAttribute("errorMessage", "Doc gia nay da bi khoa roi!");
                    } else {
                        success = readerDAO.updateReaderStatus(readerId, "blocked");
                        if (success) {
                            session.setAttribute("successMessage", "Da khoa doc gia: " + reader.getFullName());
                            System.out.println("Blocked reader ID: " + readerId);
                        } else {
                            session.setAttribute("errorMessage", "Khoa doc gia that bai!");
                        }
                    }
                } else if ("unblock".equals(action)) {
                    if ("active".equals(reader.getStatus())) {
                        session.setAttribute("errorMessage", "Doc gia nay dang active roi!");
                    } else {
                        success = readerDAO.updateReaderStatus(readerId, "active");
                        if (success) {
                            session.setAttribute("successMessage", "Da mo khoa doc gia: " + reader.getFullName());
                            System.out.println("Unblocked reader ID: " + readerId);
                        } else {
                            session.setAttribute("errorMessage", "Mo khoa doc gia that bai!");
                        }
                    }
                } else {
                    session.setAttribute("errorMessage", "Hanh dong khong hop le: " + action);
                }
                
            } catch (Exception e) {
                System.err.println("Error processing action: " + e.getMessage());
                e.printStackTrace();
                session.setAttribute("errorMessage", "Loi he thong: " + e.getMessage());
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/readers");
            return;
        }
        
        String keyword = request.getParameter("keyword");
        String redirectUrl = request.getContextPath() + "/admin/readers";
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            try {
                String encodedKeyword = URLEncoder.encode(keyword.trim(), "UTF-8");
                redirectUrl += "?keyword=" + encodedKeyword;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect(redirectUrl);
    }
}