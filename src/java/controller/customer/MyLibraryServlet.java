package controller.customer;

import dao.ReaderBookOwnershipDAO;
import model.Reader;
import model.ReaderBookOwnership;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * Servlet thư viện của tôi: hiển thị danh sách sách reader đã sở hữu (mua hoặc được cấp).
 * Chỉ GET; không thao tác CRUD, chỉ lấy danh sách từ ReaderBookOwnershipDAO.getByReader và forward my-library.jsp.
 */
public class MyLibraryServlet extends HttpServlet {

    /**
     * Lấy danh sách sách đã sở hữu của reader (ReaderBookOwnership) và hiển thị trang my-library.
     * Kiểm tra đăng nhập và role USER; set ownedBooks; forward my-library.jsp.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!"USER".equalsIgnoreCase(user.getRoleName() != null ? user.getRoleName() : "")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        ReaderBookOwnershipDAO dao = new ReaderBookOwnershipDAO();
        List<ReaderBookOwnership> owned = dao.getByReader(user.getReaderId());
        request.setAttribute("ownedBooks", owned);
        request.getRequestDispatcher("/customer/my-library.jsp").forward(request, response);
    }
}
