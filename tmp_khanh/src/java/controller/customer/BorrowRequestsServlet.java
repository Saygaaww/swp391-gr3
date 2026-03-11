package controller.customer;

import model.Reader;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class BorrowRequestsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/customer/borrow-requests.jsp").forward(request, response);
    }
}
