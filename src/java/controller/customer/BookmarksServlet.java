package controller.customer;

import dao.BookmarkDAO;
import dao.ReaderBookOwnershipDAO;
import model.Reader;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class BookmarksServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Reader user = (Reader) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        BookmarkDAO dao = new BookmarkDAO();
        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        request.setAttribute("bookmarks", dao.getByReader(user.getReaderId()));
        request.setAttribute("ownedBooks", ownershipDAO.getByReader(user.getReaderId()));
        request.getRequestDispatcher("/customer/bookmarks.jsp").forward(request, response);
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
        String action = request.getParameter("action");
        BookmarkDAO dao = new BookmarkDAO();
        String ctx = request.getContextPath();

        if ("delete".equals(action)) {
            String idStr = request.getParameter("bookmarkId");
            if (idStr != null) {
                dao.delete(Integer.parseInt(idStr), user.getReaderId());
            }
            response.sendRedirect(ctx + "/customer/bookmarks");
            return;
        }

        if ("create".equals(action) || "update".equals(action)) {
            String bookIdStr = request.getParameter("bookId");
            String pageStr = request.getParameter("pageNumber");
            String note = request.getParameter("note");
            if (bookIdStr == null || pageStr == null) {
                response.sendRedirect(ctx + "/customer/bookmarks");
                return;
            }
            int bookId = Integer.parseInt(bookIdStr);
            int page = Integer.parseInt(pageStr);
            if (page < 1) {
                request.getSession().setAttribute("bookmarkError", "Số trang phải >= 1.");
                response.sendRedirect(ctx + "/customer/bookmarks");
                return;
            }
            ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
            if (!ownershipDAO.hasOwnership(user.getReaderId(), bookId)) {
                request.getSession().setAttribute("bookmarkError", "Bạn chỉ có thể đánh dấu sách bạn đã sở hữu.");
                response.sendRedirect(ctx + "/customer/bookmarks");
                return;
            }
            if ("update".equals(action)) {
                String bookmarkIdStr = request.getParameter("bookmarkId");
                if (bookmarkIdStr != null) {
                    dao.update(Integer.parseInt(bookmarkIdStr), user.getReaderId(), page, note);
                }
            } else {
                dao.create(user.getReaderId(), bookId, page, note);
            }
        }
        response.sendRedirect(ctx + "/customer/bookmarks");
    }
}
