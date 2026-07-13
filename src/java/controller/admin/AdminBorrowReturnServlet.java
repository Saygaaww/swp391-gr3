package controller.admin;

import dal.BorrowDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.BorrowedItemView;

import java.io.IOException;

@WebServlet(name = "AdminBorrowReturnServlet", urlPatterns = {"/admin/borrow/return/*"})
public class AdminBorrowReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer borrowItemId = parseBorrowItemId(request.getPathInfo());
        if (borrowItemId == null || borrowItemId <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/return-list");
            return;
        }

        BorrowDAO dao = new BorrowDAO();
        BorrowedItemView item = dao.getReturnRequestByBorrowItemId(borrowItemId);
        if (item == null) {
            request.getSession().setAttribute("errorMessage", "Không tìm thấy yêu cầu trả sách hoặc yêu cầu đã được xử lý.");
            response.sendRedirect(request.getContextPath() + "/admin/return-list");
            return;
        }

        request.setAttribute("item", item);
        request.getRequestDispatcher("/jsp/admin/return-detail.jsp").forward(request, response);
    }

    private Integer parseBorrowItemId(String pathInfo) {
        if (pathInfo == null || pathInfo.isBlank() || "/".equals(pathInfo)) {
            return null;
        }
        String idPart = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        try {
            return Integer.parseInt(idPart);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}

