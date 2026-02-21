package controller.customer;

import dao.ReadingHistoryDAO;
import model.Reader;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ReadingHistoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        ReadingHistoryDAO dao = new ReadingHistoryDAO();
        List<?> history = dao.getByReader(user.getReaderId());
        request.setAttribute("historyList", history);
        request.getRequestDispatcher("/customer/reading-history.jsp").forward(request, response);
    }

    /** Lưu tiến độ đọc (gọi từ trang đọc sách hoặc form). */
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
            response.sendRedirect(request.getContextPath() + "/customer/reading-history");
            return;
        }
        int bookId = Integer.parseInt(bookIdStr);
        int position = Integer.parseInt(positionStr);
        if (position < 0) position = 0;
        ReadingHistoryDAO dao = new ReadingHistoryDAO();
        dao.upsert(user.getReaderId(), bookId, position);
        response.sendRedirect(request.getContextPath() + "/customer/reading-history");
    }
}
