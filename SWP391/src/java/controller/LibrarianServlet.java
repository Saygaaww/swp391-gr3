package controller;

import dal.BorrowDAO;
import dal.BorrowRequestDAO;
import dal.BookCopyDAO;
import dal.BookDAO;
import model.BorrowRequest;
import model.BorrowRequestItem;
import model.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class LibrarianServlet extends HttpServlet {
    
    private BorrowRequestDAO borrowRequestDAO;
    private BorrowDAO borrowDAO;
    private BookCopyDAO bookCopyDAO;
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        borrowRequestDAO = new BorrowRequestDAO();
        borrowDAO = new BorrowDAO();
        bookCopyDAO = new BookCopyDAO();
        bookDAO = new BookDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer employeeId = (Integer) session.getAttribute("employeeId");
        String userType = (String) session.getAttribute("userType");
        
        if (employeeId == null || !"librarian".equals(userType)) {
            response.sendRedirect("login?type=librarian");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "dashboard";
        }
        
        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "approve":
                showApproveForm(request, response);
                break;
            case "reject":
                showRejectForm(request, response);
                break;
            default:
                showDashboard(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer employeeId = (Integer) session.getAttribute("employeeId");
        String userType = (String) session.getAttribute("userType");
        
        if (employeeId == null || !"librarian".equals(userType)) {
            response.sendRedirect("login?type=librarian");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("approve".equals(action)) {
            approveRequest(request, response, employeeId);
        } else if ("reject".equals(action)) {
            rejectRequest(request, response, employeeId);
        } else {
            response.sendRedirect("librarian?action=dashboard");
        }
    }
    
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<BorrowRequest> pendingRequests = borrowRequestDAO.getPendingRequests();
        
        for (BorrowRequest req : pendingRequests) {
            List<BorrowRequestItem> items = borrowRequestDAO.getBorrowRequestItems(req.getRequestId());
            req.setRequestItems(items);
        }
        
        request.setAttribute("pendingRequests", pendingRequests);
        request.getRequestDispatcher("/view/librarian/dashboard.jsp").forward(request, response);
    }
    
    private void showApproveForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String requestIdStr = request.getParameter("requestId");
        
        if (requestIdStr == null || requestIdStr.isEmpty()) {
            response.sendRedirect("librarian?action=dashboard");
            return;
        }
        
        try {
            int requestId = Integer.parseInt(requestIdStr);
            BorrowRequest borrowRequest = borrowRequestDAO.getBorrowRequestById(requestId);
            
            if (borrowRequest == null || !"pending".equals(borrowRequest.getStatus())) {
                request.setAttribute("error", "Yêu cầu không tồn tại hoặc đã được xử lý");
                response.sendRedirect("librarian?action=dashboard");
                return;
            }
            
            List<BorrowRequestItem> items = borrowRequestDAO.getBorrowRequestItems(requestId);
            borrowRequest.setRequestItems(items);
            
            // Get book details for each item
            for (BorrowRequestItem item : items) {
                Book book = bookDAO.getBookById(item.getBookId());
                item.setBook(book);
                
                // Check available copies
                int availableCopies = bookCopyDAO.countAvailableCopies(item.getBookId());
                item.setAvailableCopies(availableCopies);
            }
            
            request.setAttribute("borrowRequest", borrowRequest);
            request.getRequestDispatcher("/view/librarian/approve-request.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("librarian?action=dashboard");
        }
    }
    
    private void showRejectForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String requestIdStr = request.getParameter("requestId");
        
        if (requestIdStr == null || requestIdStr.isEmpty()) {
            response.sendRedirect("librarian?action=dashboard");
            return;
        }
        
        try {
            int requestId = Integer.parseInt(requestIdStr);
            BorrowRequest borrowRequest = borrowRequestDAO.getBorrowRequestById(requestId);
            
            if (borrowRequest == null || !"pending".equals(borrowRequest.getStatus())) {
                request.setAttribute("error", "Yêu cầu không tồn tại hoặc đã được xử lý");
                response.sendRedirect("librarian?action=dashboard");
                return;
            }
            
            request.setAttribute("borrowRequest", borrowRequest);
            request.getRequestDispatcher("/view/librarian/reject-request.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("librarian?action=dashboard");
        }
    }
    
    private void approveRequest(HttpServletRequest request, HttpServletResponse response, int employeeId)
            throws ServletException, IOException {
        
        String requestIdStr = request.getParameter("requestId");
        
        if (requestIdStr == null || requestIdStr.isEmpty()) {
            request.setAttribute("error", "Thông tin không hợp lệ");
            response.sendRedirect("librarian?action=dashboard");
            return;
        }
        
        try {
            int requestId = Integer.parseInt(requestIdStr);
            BorrowRequest borrowRequest = borrowRequestDAO.getBorrowRequestById(requestId);
            
            if (borrowRequest == null || !"pending".equals(borrowRequest.getStatus())) {
                request.setAttribute("error", "Yêu cầu không tồn tại hoặc đã được xử lý");
                response.sendRedirect("librarian?action=dashboard");
                return;
            }
            
            List<BorrowRequestItem> items = borrowRequestDAO.getBorrowRequestItems(requestId);
            
            // Get available copies for each book
            List<Integer> copyIds = new java.util.ArrayList<>();
            for (BorrowRequestItem item : items) {
                int availableCopies = bookCopyDAO.countAvailableCopies(item.getBookId());
                if (availableCopies < item.getQuantity()) {
                    request.setAttribute("error", "Sách ID " + item.getBookId() + " không đủ số lượng");
                    response.sendRedirect("librarian?action=approve&requestId=" + requestId);
                    return;
                }
                
                // Get available copy IDs
                List<model.BookCopy> copies = bookCopyDAO.getAvailableCopiesByBookId(item.getBookId());
                for (int i = 0; i < item.getQuantity() && i < copies.size(); i++) {
                    copyIds.add(copies.get(i).getCopyId());
                }
            }
            
            // Create borrow record
            int borrowId = borrowDAO.createBorrow(borrowRequest.getReaderId(), requestId, copyIds, employeeId);
            
            if (borrowId > 0) {
                request.setAttribute("success", "Duyệt yêu cầu mượn sách thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi duyệt yêu cầu");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Thông tin không hợp lệ");
        }
        
        response.sendRedirect("librarian?action=dashboard");
    }
    
    private void rejectRequest(HttpServletRequest request, HttpServletResponse response, int employeeId)
            throws ServletException, IOException {
        
        String requestIdStr = request.getParameter("requestId");
        String decisionNote = request.getParameter("decisionNote");
        
        if (requestIdStr == null || requestIdStr.isEmpty()) {
            request.setAttribute("error", "Thông tin không hợp lệ");
            response.sendRedirect("librarian?action=dashboard");
            return;
        }
        
        try {
            int requestId = Integer.parseInt(requestIdStr);
            boolean success = borrowRequestDAO.rejectRequest(requestId, employeeId, decisionNote);
            
            if (success) {
                request.setAttribute("success", "Từ chối yêu cầu mượn sách thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi từ chối yêu cầu");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Thông tin không hợp lệ");
        }
        
        response.sendRedirect("librarian?action=dashboard");
    }
}
