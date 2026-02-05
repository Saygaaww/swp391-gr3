package controller;

import dal.BorrowDAO;
import dal.BorrowRequestDAO;
import dal.BookCopyDAO;
import model.Borrow;
import model.BorrowItem;
import model.BorrowRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class ReaderBorrowServlet extends HttpServlet {
    
    private BorrowDAO borrowDAO;
    private BorrowRequestDAO borrowRequestDAO;
    private BookCopyDAO bookCopyDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        borrowDAO = new BorrowDAO();
        borrowRequestDAO = new BorrowRequestDAO();
        bookCopyDAO = new BookCopyDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer readerId = (Integer) session.getAttribute("readerId");
        
        if (readerId == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null || action.isEmpty()) {
            action = "myBorrows";
        }
        
        switch (action) {
            case "myBorrows":
                showMyBorrows(request, response, readerId);
                break;
            case "return":
                showReturnForm(request, response, readerId);
                break;
            default:
                showMyBorrows(request, response, readerId);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer readerId = (Integer) session.getAttribute("readerId");
        
        if (readerId == null) {
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("return".equals(action)) {
            returnBook(request, response, readerId);
        } else {
            response.sendRedirect("readerBorrow?action=myBorrows");
        }
    }
    
    private void showMyBorrows(HttpServletRequest request, HttpServletResponse response, int readerId)
            throws ServletException, IOException {
        
        List<Borrow> borrows = borrowDAO.getBorrowsByReaderId(readerId);
        
        // Get borrow items for each borrow
        for (Borrow borrow : borrows) {
            List<BorrowItem> items = borrowDAO.getBorrowItems(borrow.getBorrowId());
            borrow.setBorrowItems(items);
        }
        
        request.setAttribute("borrows", borrows);
        request.getRequestDispatcher("/view/reader/my-borrows.jsp").forward(request, response);
    }
    
    private void showReturnForm(HttpServletRequest request, HttpServletResponse response, int readerId)
            throws ServletException, IOException {
        
        String borrowItemIdStr = request.getParameter("borrowItemId");
        
        if (borrowItemIdStr == null || borrowItemIdStr.isEmpty()) {
            response.sendRedirect("readerBorrow?action=myBorrows");
            return;
        }
        
        try {
            int borrowItemId = Integer.parseInt(borrowItemIdStr);
            
            // Get borrow item by checking all borrows of this reader
            List<Borrow> borrows = borrowDAO.getBorrowsByReaderId(readerId);
            BorrowItem item = null;
            
            for (Borrow borrow : borrows) {
                List<BorrowItem> items = borrowDAO.getBorrowItems(borrow.getBorrowId());
                for (BorrowItem i : items) {
                    if (i.getBorrowItemId() == borrowItemId) {
                        item = i;
                        break;
                    }
                }
                if (item != null) break;
            }
            
            if (item == null) {
                request.setAttribute("error", "Không tìm thấy thông tin mượn sách");
                response.sendRedirect("readerBorrow?action=myBorrows");
                return;
            }
            
            request.setAttribute("borrowItem", item);
            request.getRequestDispatcher("/view/reader/return-book.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect("readerBorrow?action=myBorrows");
        }
    }
    
    private void returnBook(HttpServletRequest request, HttpServletResponse response, int readerId)
            throws ServletException, IOException {
        
        String borrowItemIdStr = request.getParameter("borrowItemId");
        
        if (borrowItemIdStr == null || borrowItemIdStr.isEmpty()) {
            request.setAttribute("error", "Thông tin không hợp lệ");
            response.sendRedirect("readerBorrow?action=myBorrows");
            return;
        }
        
        try {
            int borrowItemId = Integer.parseInt(borrowItemIdStr);
            boolean success = borrowDAO.returnBook(borrowItemId);
            
            if (success) {
                request.setAttribute("success", "Trả sách thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi trả sách");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Thông tin không hợp lệ");
        }
        
        response.sendRedirect("readerBorrow?action=myBorrows");
    }
}
