package controller.admin;

import dal.BorrowDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.BorrowedItemView;

@WebServlet(name = "AdminReturnListServlet", urlPatterns = {"/admin/return-list"})
public class AdminReturnListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BorrowDAO borrowDAO = new BorrowDAO();
        List<BorrowedItemView> returnRequests = borrowDAO.getReturnRequests();
        request.setAttribute("returnRequests", returnRequests);
        request.getRequestDispatcher("/jsp/admin/return-list.jsp").forward(request, response);
    }
}
