package controller.admin;

import dal.BorrowDAO;
import model.BorrowRequest;
import model.Employee;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/borrow-detail")
public class AdminBorrowDetailServlet extends HttpServlet {
    
    private BorrowDAO borrowDAO;
    
    @Override
    public void init() throws ServletException {
        borrowDAO = new BorrowDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        String idStr = request.getParameter("id");
        
        // Validate ID
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/borrow-list");
            return;
        }
        
        try {
            int requestId = Integer.parseInt(idStr);
            
            if (requestId < 1 || requestId > 999999999) {
                response.sendRedirect(request.getContextPath() + "/admin/borrow-list");
                return;
            }
            
            BorrowRequest borrowRequest = borrowDAO.getRequestById(requestId);
            if (borrowRequest != null) {
                borrowRequest.setItems(borrowDAO.getRequestItems(requestId));
            }

            if (borrowRequest == null) {
                request.setAttribute("errorMessage", "Khong tim thay yeu cau ID: " + requestId);
                request.setAttribute("currentEmployee", session.getAttribute("user"));
                request.getRequestDispatcher("/jsp/admin/borrow-detail.jsp").forward(request, response);
                return;
            }
            
            request.setAttribute("borrowRequest", borrowRequest);
            request.setAttribute("currentEmployee", session.getAttribute("user"));
            if (session.getAttribute("successMessage") != null) {
                request.setAttribute("successMessage", session.getAttribute("successMessage"));
                session.removeAttribute("successMessage");
            }
            if (session.getAttribute("errorMessage") != null) {
                request.setAttribute("errorMessage", session.getAttribute("errorMessage"));
                session.removeAttribute("errorMessage");
            }
            request.getRequestDispatcher("/jsp/admin/borrow-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/borrow-list");
        } catch (Exception e) {
            System.err.println("AdminBorrowDetailServlet Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/borrow-list");
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
            Employee employee = (Employee) session.getAttribute("user");
            
            String requestIdStr = request.getParameter("requestId");
            String action = request.getParameter("action");
            String note = request.getParameter("note");
            
            if (requestIdStr == null || action == null) {
                response.sendRedirect(request.getContextPath() + "/admin/borrow-list");
                return;
            }
            
            int requestId = Integer.parseInt(requestIdStr);
            
            // Kiem tra yeu cau ton tai va dang pending
            BorrowRequest borrowReq = borrowDAO.getRequestById(requestId);
            if (borrowReq == null) {
                response.sendRedirect(request.getContextPath() + "/admin/borrow-list");
                return;
            }
            
            if (!"pending".equals(borrowReq.getStatus())) {
                // Yeu cau da duoc xu ly roi, khong cho xu ly lai
                response.sendRedirect(request.getContextPath() + "/admin/borrow-detail?id=" + requestId);
                return;
            }
            
            // Validate note
            if (note != null) {
                note = note.trim();
                if (note.length() > 500) {
                    note = note.substring(0, 500);
                }
                if (note.isEmpty()) note = null;
            }
            
            boolean success = false;
            
            if ("approve".equals(action)) {
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                java.time.LocalDate startDate = java.time.LocalDate.now();
                java.time.LocalDate endDate = startDate.plusDays(7);
                try {
                    if (startDateStr != null && !startDateStr.isBlank()) {
                        startDate = java.time.LocalDate.parse(startDateStr);
                    }
                    if (endDateStr != null && !endDateStr.isBlank()) {
                        endDate = java.time.LocalDate.parse(endDateStr);
                    }
                } catch (java.time.format.DateTimeParseException e) {
                    System.err.println("Invalid date format: " + e.getMessage());
                }
                success = borrowDAO.approveRequest(requestId, employee.getEmployeeId(), note, startDate, endDate);
            } else if ("reject".equals(action)) {
                success = borrowDAO.rejectRequest(requestId, employee.getEmployeeId(), note);
            }
            
            if (success) {
                session.setAttribute("successMessage",
                    "approve".equals(action) ? "Da duyet yeu cau #" + requestId
                                             : "Da tu choi yeu cau #" + requestId);
                
                // Gui email thong bao cho nguoi muon
                if (borrowReq.getReaderEmail() != null && !borrowReq.getReaderEmail().trim().isEmpty()) {
                    try {
                        String readerEmail = borrowReq.getReaderEmail();
                        String readerName = borrowReq.getReaderName() != null ? borrowReq.getReaderName() : "Bạn đọc";
                        System.out.println("Dang gui email den: " + readerEmail);
                        boolean mailSent;
                        if ("approve".equals(action)) {
                            String endDateStr = request.getParameter("endDate");
                            java.time.LocalDate endDate = java.time.LocalDate.now().plusDays(7);
                            try {
                                if (endDateStr != null && !endDateStr.isBlank()) {
                                    endDate = java.time.LocalDate.parse(endDateStr);
                                }
                            } catch (java.time.format.DateTimeParseException ignore) {}
                            mailSent = util.EmailUtil.sendBorrowApprovedEmail(readerEmail, readerName, requestId, endDate.toString(), note);
                        } else {
                            mailSent = util.EmailUtil.sendBorrowRejectedEmail(readerEmail, readerName, requestId, note);
                        }
                        System.out.println("Trang thai gui email: " + mailSent + " den " + readerEmail);
                    } catch (Exception emailEx) {
                        System.err.println("Loi khi gui email thong bao: " + emailEx.getMessage());
                    }
                } else {
                    System.out.println("Khong co email nguoi muon cho yeu cau #" + requestId);
                }
            } else {
                session.setAttribute("errorMessage", "Xu ly that bai, vui long thu lai");
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/borrow-detail?id=" + requestId);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/borrow-list");
        } catch (Exception e) {
            System.err.println("AdminBorrowDetailServlet POST Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/borrow-list");
        }
    }
}

