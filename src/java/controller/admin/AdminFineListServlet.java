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
}
