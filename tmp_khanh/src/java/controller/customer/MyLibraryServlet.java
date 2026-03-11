package controller.customer;

import dao.ReaderBookOwnershipDAO;
import model.Reader;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class MyLibraryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        ReaderBookOwnershipDAO dao = new ReaderBookOwnershipDAO();
        List<?> owned = dao.getByReader(user.getReaderId());
        request.setAttribute("ownedBooks", owned);
        request.getRequestDispatcher("/customer/my-library.jsp").forward(request, response);
    }
}
