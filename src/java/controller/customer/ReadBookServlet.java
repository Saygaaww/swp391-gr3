package controller.customer;

import dao.ReaderBookOwnershipDAO;
import dao.ReadingHistoryDAO;
import model.Reader;
import model.ReadingHistory;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet trang đọc sách: chỉ cho phép đọc sách reader đã sở hữu; lưu/và hiển thị tiến độ đọc (trang đã đọc) qua ReadingHistory.
 */
public class ReadBookServlet extends HttpServlet {

    /**
     * Hiển thị trang đọc sách (read.jsp) với bookId.
     * Kiểm tra đăng nhập; lấy bookId; kiểm tra sở hữu (getByReaderAndBook)—không sở hữu redirect my-library; lấy lastPosition từ ReadingHistory (getByReader, tìm bản ghi theo bookId), mặc định 1; set book, lastPosition; forward read.jsp.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String bookIdStr = request.getParameter("bookId");
        if (bookIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/customer/my-library");
            return;
        }
        int bookId = Integer.parseInt(bookIdStr);
        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        var book = ownershipDAO.getByReaderAndBook(user.getReaderId(), bookId);
        if (book == null) {
            response.sendRedirect(request.getContextPath() + "/customer/my-library");
            return;
        }
        ReadingHistoryDAO historyDAO = new ReadingHistoryDAO();
        var list = historyDAO.getByReader(user.getReaderId());
        ReadingHistory current = null;
        for (var h : list) {
            if (h.getBookId() == bookId) { current = h; break; }
        }
        request.setAttribute("book", book);
        request.setAttribute("lastPosition", current != null && current.getLastReadPosition() != null ? current.getLastReadPosition() : 1);
        request.getRequestDispatcher("/customer/read.jsp").forward(request, response);
    }

    /**
     * Lưu tiến độ đọc: bookId, position (số trang).
     * Kiểm tra đăng nhập và sở hữu sách; position < 0 thì coi là 0; gọi ReadingHistoryDAO.upsert(readerId, bookId, position); redirect /customer/read?bookId=...&saved=1 hoặc &error=save_failed.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String bookIdStr = request.getParameter("bookId");
        String positionStr = request.getParameter("position");
        if (bookIdStr == null || positionStr == null) {
            response.sendRedirect(request.getContextPath() + "/customer/my-library");
            return;
        }
        int bookId = Integer.parseInt(bookIdStr);
        int position = Integer.parseInt(positionStr);
        if (position < 0) position = 0;
        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        if (!ownershipDAO.hasOwnership(user.getReaderId(), bookId)) {
            response.sendRedirect(request.getContextPath() + "/customer/my-library");
            return;
        }
        ReadingHistoryDAO dao = new ReadingHistoryDAO();
        boolean saved = dao.upsert(user.getReaderId(), bookId, position);
        String redirect = request.getContextPath() + "/customer/read?bookId=" + bookId;
        if (saved) {
            response.sendRedirect(redirect + "&saved=1");
        } else {
            response.sendRedirect(redirect + "&error=save_failed");
        }
    }
}
