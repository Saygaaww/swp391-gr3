package controller.admin;

import dal.FineDAO;
import model.FineView;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import util.AuthUtil;

@WebServlet(name = "AdminFineListServlet", urlPatterns = {"/admin/fines"})
public class AdminFineListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        FineDAO fineDAO = new FineDAO();
        List<FineView> fines = fineDAO.getAllFines();
        request.setAttribute("fines", fines);
        request.getRequestDispatcher("/jsp/admin/fine-list.jsp").forward(request, response);
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
