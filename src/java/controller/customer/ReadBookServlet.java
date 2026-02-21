package controller.customer;

import dao.ReaderBookOwnershipDAO;
import dao.ReadingHistoryDAO;
import model.Reader;
import model.ReadingHistory;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Trang đọc sách (chỉ sách đã sở hữu). Có form lưu tiến độ (trang đã đọc).
 */
public class ReadBookServlet extends HttpServlet {
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
        dao.upsert(user.getReaderId(), bookId, position);
        response.sendRedirect(request.getContextPath() + "/customer/read?bookId=" + bookId);
    }
}
