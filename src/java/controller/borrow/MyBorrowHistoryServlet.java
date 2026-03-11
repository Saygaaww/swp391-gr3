package controller.borrow;

import dao.BorrowDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Reader;

import java.io.IOException;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

import model.BorrowHistoryItem;

public class MyBorrowHistoryServlet extends HttpServlet {
    private final BorrowDAO borrowDAO = new BorrowDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }
        String q = request.getParameter("q");
        String qNorm = (q == null) ? "" : q.trim();

        List<BorrowHistoryItem> all = borrowDAO.listHistoryByReader(user.getReaderId());

        // Count how many times the reader borrowed the same book (by bookId)
        Map<Integer, Long> counts = all.stream()
                .collect(Collectors.groupingBy(BorrowHistoryItem::getBookId, Collectors.counting()));
        for (BorrowHistoryItem item : all) {
            long c = counts.getOrDefault(item.getBookId(), 0L);
            item.setBorrowCountForBook((int) Math.min(Integer.MAX_VALUE, c));
        }

        List<BorrowHistoryItem> history = all;
        if (!qNorm.isEmpty()) {
            final String needle = qNorm.toLowerCase(Locale.ROOT);
            history = all.stream()
                    .filter(i -> i.getBookTitle() != null && i.getBookTitle().toLowerCase(Locale.ROOT).contains(needle))
                    .collect(Collectors.toList());
        }
        request.setAttribute("q", qNorm);
        request.setAttribute("history", history);
        request.getRequestDispatcher("/customer/my-borrow-history.jsp").forward(request, response);
    }
}
