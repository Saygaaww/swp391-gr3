package controller.borrow;

import dao.BookDAO;
import dao.BorrowDAO;
import dao.BorrowRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Book;
import model.Reader;

import java.io.IOException;

public class RequestBorrowServlet extends HttpServlet {
    private static final int MAX_QUANTITY = 3;
    private static final int MAX_ACTIVE_BORROWS = 5;
    private static final int MAX_NOTE_LENGTH = 500;

    private final BookDAO bookDAO = new BookDAO();
    private final BorrowDAO borrowDAO = new BorrowDAO();
    private final BorrowRequestDAO borrowRequestDAO = new BorrowRequestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String contextPath = request.getContextPath();
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null || !"USER".equals(user.getRoleName())) {
            response.sendRedirect(contextPath + "/auth/login.jsp");
            return;
        }

        String bookIdParam = request.getParameter("book_id");
        String quantityParam = request.getParameter("quantity");
        if (bookIdParam == null || bookIdParam.isBlank()) {
            response.sendRedirect(contextPath + "/BookListServlet?error=invalid");
            return;
        }
        int bookId;
        try {
            bookId = Integer.parseInt(bookIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(contextPath + "/BookListServlet?error=invalid");
            return;
        }

        // Kiểm tra sách tồn tại và đang active
        Book book = bookDAO.getById(bookId);
        if (book == null || !"active".equalsIgnoreCase(book.getStatus())) {
            response.sendRedirect(contextPath + "/BookListServlet?error=book_not_found");
            return;
        }

        // Validate quantity
        int quantity = 1;
        if (quantityParam != null && !quantityParam.isBlank()) {
            try {
                quantity = Integer.parseInt(quantityParam);
                if (quantity < 1) quantity = 1;
            } catch (NumberFormatException ignored) {}
        }
        if (quantity > MAX_QUANTITY) {
            response.sendRedirect(contextPath + "/BookDetailServlet?id=" + bookId + "&error=quantity_exceeded");
            return;
        }

        // Kiểm tra tổng số sách đang mượn không vượt giới hạn
        int activeBorrows = borrowDAO.countActiveBorrows(user.getReaderId());
        if (activeBorrows + quantity > MAX_ACTIVE_BORROWS) {
            response.sendRedirect(contextPath + "/BookDetailServlet?id=" + bookId + "&error=borrow_limit_exceeded");
            return;
        }

        // Kiểm tra reader đang mượn cuốn sách này rồi
        if (borrowDAO.isCurrentlyBorrowing(user.getReaderId(), bookId)) {
            response.sendRedirect(contextPath + "/BookDetailServlet?id=" + bookId + "&error=already_borrowing");
            return;
        }

        // Không thể gửi nhiều request với 1 quyển sách
        if (borrowRequestDAO.hasPendingRequestForBook(user.getReaderId(), bookId)) {
            response.sendRedirect(contextPath + "/BookDetailServlet?id=" + bookId + "&error=already_requested");
            return;
        }

        int available = bookDAO.countAvailableCopies(bookId);
        if (available < quantity) {
            response.sendRedirect(contextPath + "/BookDetailServlet?id=" + bookId + "&error=not_enough");
            return;
        }

        // Giới hạn độ dài note
        String note = request.getParameter("note");
        if (note != null && note.length() > MAX_NOTE_LENGTH) {
            note = note.substring(0, MAX_NOTE_LENGTH);
        }

        int requestId = borrowRequestDAO.createRequest(user.getReaderId(), bookId, quantity, note);
        if (requestId > 0) {
            response.sendRedirect(contextPath + "/BookDetailServlet?id=" + bookId + "&success=request_sent");
        } else {
            response.sendRedirect(contextPath + "/BookDetailServlet?id=" + bookId + "&error=create_failed");
        }
    }
}
