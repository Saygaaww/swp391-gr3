package controller.admin;

import dal.FineDAO;
import model.FineView;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import util.AuthUtil;

@WebServlet(name = "AdminFineListServlet", urlPatterns = {"/admin/fines"})
public class AdminFineListServlet extends HttpServlet {

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

        FineDAO fineDAO = new FineDAO();
        List<FineView> allFines = fineDAO.getAllFines();

        List<FineView> filtered = new ArrayList<>();
        for (FineView fine : allFines) {
            boolean matches = true;

            if (status != null && fine.getStatus() != null && !status.equalsIgnoreCase(fine.getStatus())) {
                matches = false;
            } else if (status != null && fine.getStatus() == null) {
                matches = false;
            }

            if (matches && keyword != null) {
                String kw = keyword.toLowerCase();
                String readerName = fine.getReaderName() != null ? fine.getReaderName().toLowerCase() : "";
                String readerEmail = fine.getReaderEmail() != null ? fine.getReaderEmail().toLowerCase() : "";
                String bookTitle = fine.getBookTitle() != null ? fine.getBookTitle().toLowerCase() : "";
                String fineType = fine.getFineTypeName() != null ? fine.getFineTypeName().toLowerCase() : "";

                if (!readerName.contains(kw) && !readerEmail.contains(kw)
                        && !bookTitle.contains(kw) && !fineType.contains(kw)) {
                    matches = false;
                }
            }

            if (matches) {
                filtered.add(fine);
            }
        }

        int totalItems = filtered.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / pageSize));
        if (page > totalPages) {
            page = totalPages;
        }

        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);
        List<FineView> pageItems = fromIndex < toIndex ? filtered.subList(fromIndex, toIndex) : new ArrayList<>();

        request.setAttribute("fines", pageItems);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", String.valueOf(pageSize));
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.getRequestDispatcher("/jsp/admin/fine-list.jsp").forward(request, response);
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("mark_paid".equalsIgnoreCase(action)) {
            String fineIdStr = request.getParameter("fineId");
            try {
                int fineId = Integer.parseInt(fineIdStr);
                FineDAO fineDAO = new FineDAO();
                Integer employeeId = AuthUtil.getEmployeeId(request);
                boolean ok = fineDAO.markFinePaidByAdmin(fineId, employeeId);
                if (ok) {
                    request.getSession().setAttribute("successMessage", "Đã cập nhật khoản phạt sang trạng thái PAID.");
                } else {
                    request.getSession().setAttribute("errorMessage", "Không thể cập nhật trạng thái khoản phạt.");
                }
            } catch (Exception e) {
                request.getSession().setAttribute("errorMessage", "Fine ID không hợp lệ.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/fines");
    }
}

