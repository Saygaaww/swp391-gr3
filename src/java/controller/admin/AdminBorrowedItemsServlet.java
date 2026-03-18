package controller.admin;

import dal.BorrowDAO;
import model.BorrowedItemView;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminBorrowedItemsServlet", urlPatterns = {"/admin/borrowed-items"})
public class AdminBorrowedItemsServlet extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword != null) {
            keyword = keyword.trim();
            if (keyword.isEmpty()) {
                keyword = null;
            }
        }

        String status = request.getParameter("status");
        if (status != null) {
            status = status.trim();
            if (status.isEmpty()) {
                status = null;
            }
        }

        int page = parsePositiveInt(request.getParameter("page"), 1);
        int pageSize = parsePageSize(request.getParameter("pageSize"));

        BorrowDAO borrowDAO = new BorrowDAO();
        List<BorrowedItemView> allItems = borrowDAO.getAllBorrowedItems();

        List<BorrowedItemView> filtered = new ArrayList<>();
        for (BorrowedItemView item : allItems) {
            boolean matches = true;

            if (status != null && item.getStatus() != null && !status.equalsIgnoreCase(item.getStatus())) {
                matches = false;
            } else if (status != null && item.getStatus() == null) {
                matches = false;
            }

            if (matches && keyword != null) {
                String kw = keyword.toLowerCase();
                String readerName = item.getReaderName() != null ? item.getReaderName().toLowerCase() : "";
                String readerEmail = item.getReaderEmail() != null ? item.getReaderEmail().toLowerCase() : "";
                String bookTitle = item.getBookTitle() != null ? item.getBookTitle().toLowerCase() : "";
                String copyCode = item.getCopyCode() != null ? item.getCopyCode().toLowerCase() : "";

                if (!readerName.contains(kw) && !readerEmail.contains(kw)
                        && !bookTitle.contains(kw) && !copyCode.contains(kw)) {
                    matches = false;
                }
            }

            if (matches) {
                filtered.add(item);
            }
        }

        int totalItems = filtered.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
        if (page > totalPages) {
            page = totalPages;
        }

        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);
        List<BorrowedItemView> pageItems = fromIndex < toIndex ? filtered.subList(fromIndex, toIndex) : new ArrayList<>();

        request.setAttribute("items", pageItems);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", String.valueOf(pageSize));
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.getRequestDispatcher("/jsp/admin/borrowed-items.jsp").forward(request, response);
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
