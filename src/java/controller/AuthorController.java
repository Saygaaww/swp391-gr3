package controller;

import dao.AuthorDAO;
import dao.BookDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Author;
import model.Book;
import util.StringUtil;
import util.AuthUtil;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * AuthorController - Servlet for handling author-related requests
 * 
 * @author FPT Student Team
 */
@WebServlet(name = "AuthorController", urlPatterns = { "/authors", "/authors/*" })
public class AuthorController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AuthorController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                handleAuthorListing(request, response);
            } else if (pathInfo.startsWith("/detail/")) {
                handleAuthorDetail(request, response, pathInfo);
            } else if (pathInfo.equals("/create")) {
                // Check authorization
                if (!AuthUtil.canManageCatalog(request)) {
                    handleUnauthorized(request, response);
                    return;
                }
                handleAuthorForm(request, response, null);
            } else if (pathInfo.startsWith("/edit/")) {
                // Check authorization
                if (!AuthUtil.canManageCatalog(request)) {
                    handleUnauthorized(request, response);
                    return;
                }
                handleAuthorForm(request, response, pathInfo);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in AuthorController", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu. Vui lòng thử lại.");
            response.getWriter().println("<h1>Error: " + e.getMessage() + "</h1>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String pathInfo = request.getPathInfo();

        try {
            if ("create".equals(action) || (pathInfo != null && pathInfo.equals("/create"))) {
                // Check authorization
                if (!AuthUtil.canManageCatalog(request)) {
                    handleUnauthorized(request, response);
                    return;
                }
                handleCreateAuthor(request, response);
            } else if ("update".equals(action) || (pathInfo != null && pathInfo.startsWith("/update/"))) {
                // Check authorization
                if (!AuthUtil.canManageCatalog(request)) {
                    handleUnauthorized(request, response);
                    return;
                }
                handleUpdateAuthor(request, response, pathInfo);
            } else {
                doGet(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in AuthorController POST", e);
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/authors/form.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void handleAuthorListing(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchName = StringUtil.cleanInput(request.getParameter("name"));
        String keyword = StringUtil.cleanInput(request.getParameter("keyword"));
        String effectiveKeyword = !StringUtil.isBlank(keyword) ? keyword : searchName;

        LOGGER.info("Author listing - name: " + searchName + ", keyword: " + keyword
            + ", effectiveKeyword: " + effectiveKeyword);

        AuthorDAO authorDAO = new AuthorDAO();
        BookDAO bookDAO = new BookDAO();

        try {
            List<Author> authors;
            String searchSummary = "";

            if (!StringUtil.isBlank(effectiveKeyword)) {
                authors = authorDAO.searchAuthorsByName(effectiveKeyword);
                searchSummary = "Tìm thấy " + authors.size() + " tác giả với từ khóa \"" + effectiveKeyword + "\"";
            } else {
                authors = authorDAO.getAllAuthors();
                searchSummary = "Hiển thị tất cả " + authors.size() + " tác giả";
            }

            // Get book count for each author
            for (Author author : authors) {
                List<Book> authorBooks = bookDAO.getBooksByAuthor(author.getAuthorId());
                request.setAttribute("bookCount_" + author.getAuthorId(), authorBooks.size());
            }

            request.setAttribute("authors", authors);
            request.setAttribute("searchSummary", searchSummary);
            request.setAttribute("selectedName", searchName);
            request.setAttribute("selectedKeyword", effectiveKeyword);
            request.setAttribute("pageTitle", "Danh sách tác giả - Thư viện Số FPT");
            request.setAttribute("totalAuthors", authorDAO.getAllAuthors().size());

            // Set authorization flag for JSP
            request.setAttribute("canManageCatalog", AuthUtil.canManageCatalog(request));

            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/authors/list.jsp");
            dispatcher.forward(request, response);

        } finally {
            authorDAO.close();
            bookDAO.close();
        }
    }

    private void handleAuthorDetail(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {

        try {
            String authorIdStr = pathInfo.substring("/detail/".length());
            int authorId = Integer.parseInt(authorIdStr);

            LOGGER.info("Author detail request for ID: " + authorId);

            AuthorDAO authorDAO = new AuthorDAO();
            BookDAO bookDAO = new BookDAO();

            try {
                Author author = authorDAO.getAuthorById(authorId);

                if (author != null) {
                    List<Book> authorBooks = bookDAO.getBooksByAuthor(authorId);

                    request.setAttribute("author", author);
                    request.setAttribute("authorBooks", authorBooks);
                    request.setAttribute("bookCount", authorBooks.size());
                    request.setAttribute("pageTitle", author.getAuthorName() + " - Thư viện Số FPT");

                    RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/authors/detail.jsp");
                    dispatcher.forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }

            } finally {
                authorDAO.close();
                bookDAO.close();
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tác giả không hợp lệ");
        }
    }

    /**
     * Handle author form display (for create or edit)
     */
    private void handleAuthorForm(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {

        Author author = null;
        boolean isEdit = false;

        if (pathInfo != null && pathInfo.startsWith("/edit/")) {
            try {
                String authorIdStr = pathInfo.substring("/edit/".length());
                int authorId = Integer.parseInt(authorIdStr);

                AuthorDAO authorDAO = new AuthorDAO();
                try {
                    author = authorDAO.getAuthorById(authorId);
                    if (author == null) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tác giả không tồn tại");
                        return;
                    }
                    isEdit = true;
                } finally {
                    authorDAO.close();
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tác giả không hợp lệ");
                return;
            }
        } else {
            // Create mode
            author = new Author();
            isEdit = false;
        }

        request.setAttribute("author", author);
        request.setAttribute("isEdit", isEdit);
        request.setAttribute("pageTitle", (isEdit ? "Chỉnh sửa" : "Thêm mới") + " tác giả - Thư viện Số FPT");

        RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/authors/form.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Handle create author request
     */
    private void handleCreateAuthor(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String authorName = StringUtil.cleanInput(request.getParameter("authorName"));
        String bio = StringUtil.cleanInput(request.getParameter("bio"));

        // Validation
        if (StringUtil.isBlank(authorName)) {
            request.setAttribute("error", "Tên tác giả không được để trống");
            request.setAttribute("author", new Author(authorName, bio));
            request.setAttribute("isEdit", false);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/authors/form.jsp");
            dispatcher.forward(request, response);
            return;
        }

        AuthorDAO authorDAO = new AuthorDAO();
        try {
            // Check duplicate name
            if (authorDAO.authorNameExists(authorName, null)) {
                request.setAttribute("error", "Tên tác giả \"" + authorName + "\" đã tồn tại");
                request.setAttribute("author", new Author(authorName, bio));
                request.setAttribute("isEdit", false);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/authors/form.jsp");
                dispatcher.forward(request, response);
                return;
            }

            Author author = new Author(authorName, bio);
            if (authorDAO.createAuthor(author)) {
                LOGGER.info("Author created successfully: " + author.getAuthorId());
                response.sendRedirect(request.getContextPath() + "/authors/detail/" + author.getAuthorId());
            } else {
                request.setAttribute("error", "Không thể tạo tác giả mới. Vui lòng thử lại.");
                request.setAttribute("author", author);
                request.setAttribute("isEdit", false);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/authors/form.jsp");
                dispatcher.forward(request, response);
            }
        } finally {
            authorDAO.close();
        }
    }

    /**
     * Handle update author request
     */
    private void handleUpdateAuthor(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {

        try {
            String authorIdStr = null;
            if (pathInfo != null && pathInfo.startsWith("/update/")) {
                authorIdStr = pathInfo.substring("/update/".length());
            } else {
                authorIdStr = request.getParameter("authorId");
            }

            if (authorIdStr == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID tác giả");
                return;
            }

            int authorId = Integer.parseInt(authorIdStr);
            String authorName = StringUtil.cleanInput(request.getParameter("authorName"));
            String bio = StringUtil.cleanInput(request.getParameter("bio"));

            // Validation
            if (StringUtil.isBlank(authorName)) {
                request.setAttribute("error", "Tên tác giả không được để trống");
                AuthorDAO authorDAO = new AuthorDAO();
                try {
                    Author author = authorDAO.getAuthorById(authorId);
                    if (author != null) {
                        author.setAuthorName(authorName);
                        author.setBio(bio);
                    }
                    request.setAttribute("author", author);
                    request.setAttribute("isEdit", true);
                } finally {
                    authorDAO.close();
                }
                RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/authors/form.jsp");
                dispatcher.forward(request, response);
                return;
            }

            AuthorDAO authorDAO = new AuthorDAO();
            try {
                // Check if author exists
                Author existingAuthor = authorDAO.getAuthorById(authorId);
                if (existingAuthor == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Tác giả không tồn tại");
                    return;
                }

                // Check duplicate name (exclude current author)
                if (authorDAO.authorNameExists(authorName, authorId)) {
                    request.setAttribute("error", "Tên tác giả \"" + authorName + "\" đã tồn tại");
                    Author author = new Author(authorName, bio);
                    author.setAuthorId(authorId);
                    request.setAttribute("author", author);
                    request.setAttribute("isEdit", true);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/authors/form.jsp");
                    dispatcher.forward(request, response);
                    return;
                }

                Author author = new Author(authorName, bio);
                author.setAuthorId(authorId);

                if (authorDAO.updateAuthor(author)) {
                    LOGGER.info("Author updated successfully: " + authorId);
                    response.sendRedirect(request.getContextPath() + "/authors/detail/" + authorId);
                } else {
                    request.setAttribute("error", "Không thể cập nhật tác giả. Vui lòng thử lại.");
                    request.setAttribute("author", author);
                    request.setAttribute("isEdit", true);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/authors/form.jsp");
                    dispatcher.forward(request, response);
                }
            } finally {
                authorDAO.close();
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID tác giả không hợp lệ");
        }
    }

    /**
     * Handle unauthorized access
     */
    private void handleUnauthorized(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("error",
            "Bạn không có quyền truy cập chức năng này. Chỉ Admin/Librarian/Seller mới có thể quản lý tác giả.");
        request.setAttribute("pageTitle", "Không có quyền truy cập - Thư viện Số FPT");

        // Try to redirect to login if not logged in, otherwise show error
        if (!AuthUtil.isLoggedIn(request)) {
            // Store the requested URL to redirect after login
            String requestedURL = request.getRequestURI();
            if (request.getQueryString() != null) {
                requestedURL += "?" + request.getQueryString();
            }
            request.getSession().setAttribute("redirectAfterLogin", requestedURL);
            response.sendRedirect(request.getContextPath() + "/auth/login?error=unauthorized");
        } else {
            // User is logged in but doesn't have permission
            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/error/unauthorized.jsp");
            dispatcher.forward(request, response);
        }
    }
}
