package controller.customer;

import dao.ReaderBookOwnershipDAO;
import dao.ReviewDAO;
import model.Reader;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ReviewsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        ReviewDAO dao = new ReviewDAO();
        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        request.setAttribute("reviews", dao.getByReader(user.getReaderId()));
        request.setAttribute("ownedBooks", ownershipDAO.getByReader(user.getReaderId()));
        request.getRequestDispatcher("/customer/reviews.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.setCharacterEncoding("UTF-8");
        String bookIdStr = request.getParameter("bookId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");
        String ctx = request.getContextPath();

        if (bookIdStr == null || ratingStr == null) {
            response.sendRedirect(ctx + "/customer/reviews");
            return;
        }
        int bookId = Integer.parseInt(bookIdStr);
        int rating = Integer.parseInt(ratingStr);
        if (rating < 1 || rating > 5) {
            request.getSession().setAttribute("reviewError", "Xếp hạng phải từ 1 đến 5 sao.");
            response.sendRedirect(ctx + "/customer/reviews");
            return;
        }
        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        if (!ownershipDAO.hasOwnership(user.getReaderId(), bookId)) {
            request.getSession().setAttribute("reviewError", "Bạn chỉ có thể đánh giá sách bạn đã sở hữu.");
            response.sendRedirect(ctx + "/customer/reviews");
            return;
        }
        ReviewDAO dao = new ReviewDAO();
        dao.upsert(user.getReaderId(), bookId, rating, comment);
        response.sendRedirect(ctx + "/customer/reviews");
    }
}
