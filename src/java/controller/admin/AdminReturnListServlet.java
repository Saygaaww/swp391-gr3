package controller.admin;

import dal.BorrowDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.BorrowedItemView;

@WebServlet(name = "AdminReturnListServlet", urlPatterns = {"/admin/return-list"})
public class AdminReturnListServlet extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = normalize(request.getParameter("keyword"));
        int page = parsePositiveInt(request.getParameter("page"), 1);
        int pageSize = parsePageSize(request.getParameter("pageSize"));

        BorrowDAO borrowDAO = new BorrowDAO();
        List<BorrowedItemView> allItems = borrowDAO.getReturnRequests();

        List<BorrowedItemView> filtered = new ArrayList<>();
        for (BorrowedItemView item : allItems) {
            if (keyword == null) {
                filtered.add(item);
            } else {
                String kw = keyword.toLowerCase();
                String readerName = item.getReaderName() != null ? item.getReaderName().toLowerCase() : "";
                String readerEmail = item.getReaderEmail() != null ? item.getReaderEmail().toLowerCase() : "";
                String bookTitle = item.getBookTitle() != null ? item.getBookTitle().toLowerCase() : "";
                String copyCode = item.getCopyCode() != null ? item.getCopyCode().toLowerCase() : "";

                if (readerName.contains(kw) || readerEmail.contains(kw)
                        || bookTitle.contains(kw) || copyCode.contains(kw)) {
                    filtered.add(item);
                }
            }
        }

        int totalItems = filtered.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
        if (page > totalPages) {
            page = totalPages;
        }

        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);
        List<BorrowedItemView> pageItems = fromIndex < toIndex
                ? filtered.subList(fromIndex, toIndex)
                : new ArrayList<>();

        request.setAttribute("returnRequests", pageItems);
        request.setAttribute("keyword", keyword);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", String.valueOf(pageSize));
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.getRequestDispatcher("/jsp/admin/return-list.jsp").forward(request, response);
    }

    private String normalize(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private int parsePositiveInt(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            int parsed = Integer.parseInt(value.trim());
            return parsed > 0 ? parsed : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private int parsePageSize(String value) {
        int parsed = parsePositiveInt(value, DEFAULT_PAGE_SIZE);
        return (parsed == 10 || parsed == 20 || parsed == 50) ? parsed : DEFAULT_PAGE_SIZE;
    }
}
