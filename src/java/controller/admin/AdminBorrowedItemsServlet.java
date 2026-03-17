package controller.admin;

import dal.BorrowDAO;
import model.BorrowedItemView;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminBorrowedItemsServlet", urlPatterns = {"/admin/borrowed-items"})
public class AdminBorrowedItemsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BorrowDAO borrowDAO = new BorrowDAO();
        List<BorrowedItemView> items = borrowDAO.getAllBorrowedItems();
        request.setAttribute("items", items);
        request.getRequestDispatcher("/jsp/admin/borrowed-items.jsp").forward(request, response);
    }
}
