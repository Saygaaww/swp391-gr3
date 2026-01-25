package controller;

import dal.BookDAO;
import dal.BookCopyDAO;
import dal.BorrowRequestDAO;
import model.Book;
import model.BorrowRequest;
import model.BorrowRequestItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class BorrowRequestServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    private BookCopyDAO bookCopyDAO;
    private BorrowRequestDAO borrowRequestDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        bookDAO = new BookDAO();
        bookCopyDAO = new BookCopyDAO();
        borrowRequestDAO = new BorrowRequestDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "form";
        }
        
        switch (action) {
            case "form":
                showBorrowForm(request, response);
                break;
            case "list":
                listBorrowRequests(request, response);
                break;
            default:
                showBorrowForm(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createBorrowRequest(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    
    private void showBorrowForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bookIdStr = request.getParameter("bookId");
        
        if (bookIdStr != null && !bookIdStr.isEmpty()) {
            try {
                int bookId = Integer.parseInt(bookIdStr);
                Book book = bookDAO.getBookById(bookId);
                
                if (book != null) {
                    int availableCopies = bookCopyDAO.countAvailableCopies(bookId);
                    request.setAttribute("book", book);
                    request.setAttribute("availableCopies", availableCopies);
                }
            } catch (NumberFormatException e) {
                // Invalid book ID, continue without book
            }
        }
        
        request.getRequestDispatcher("/view/reader/borrow.jsp").forward(request, response);
    }
    
    private void createBorrowRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Get reader_id from session (assuming user is logged in)
        // For now, we'll use a default value or get from session
        Integer readerId = (Integer) session.getAttribute("readerId");
        
        if (readerId == null) {
            // For testing, you can set a default reader_id
            // In production, redirect to login if not authenticated
            readerId = 1; // Default for testing
        }
        
        String[] bookIds = request.getParameterValues("bookId");
        String[] quantities = request.getParameterValues("quantity");
        String note = request.getParameter("note");
        
        if (bookIds == null || bookIds.length == 0) {
            request.setAttribute("error", "Vui lòng chọn ít nhất một cuốn sách");
            showBorrowForm(request, response);
            return;
        }
        
        List<BorrowRequestItem> items = new ArrayList<>();
        
        for (int i = 0; i < bookIds.length; i++) {
            try {
                int bookId = Integer.parseInt(bookIds[i]);
                int quantity = 1;
                
                if (quantities != null && i < quantities.length && quantities[i] != null && !quantities[i].isEmpty()) {
                    quantity = Integer.parseInt(quantities[i]);
                }
                
                // Check if book has available copies
                int availableCopies = bookCopyDAO.countAvailableCopies(bookId);
                if (quantity > availableCopies) {
                    request.setAttribute("error", "Sách ID " + bookId + " chỉ còn " + availableCopies + " bản có sẵn");
                    showBorrowForm(request, response);
                    return;
                }
                
                BorrowRequestItem item = new BorrowRequestItem();
                item.setBookId(bookId);
                item.setQuantity(quantity);
                items.add(item);
                
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Dữ liệu không hợp lệ");
                showBorrowForm(request, response);
                return;
            }
        }
        
        BorrowRequest borrowRequest = new BorrowRequest();
        borrowRequest.setReaderId(readerId);
        borrowRequest.setStatus("pending");
        borrowRequest.setNote(note);
        
        int requestId = borrowRequestDAO.createBorrowRequest(borrowRequest, items);
        
        if (requestId > 0) {
            request.setAttribute("success", "Tạo yêu cầu mượn sách thành công! Mã yêu cầu: " + requestId);
            request.setAttribute("requestId", requestId);
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi tạo yêu cầu mượn sách");
        }
        
        request.getRequestDispatcher("/view/reader/borrow-success.jsp").forward(request, response);
    }
    
    private void listBorrowRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer readerId = (Integer) session.getAttribute("readerId");
        
        if (readerId == null) {
            readerId = 1; // Default for testing
        }
        
        List<BorrowRequest> requests = borrowRequestDAO.getBorrowRequestsByReaderId(readerId);
        request.setAttribute("borrowRequests", requests);
        request.getRequestDispatcher("/view/reader/borrow-list.jsp").forward(request, response);
    }
}

