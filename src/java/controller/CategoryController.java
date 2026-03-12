package controller;

import dao.CategoryDAO;
import dao.BookDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category;
import model.Book;
import util.StringUtil;
import util.AuthUtil;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * CategoryController - Servlet for handling category-related requests
 * 
 * @author FPT Student Team
 */
@WebServlet(name = "CategoryController", urlPatterns = { "/categories", "/categories/*" })
public class CategoryController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CategoryController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                handleCategoryListing(request, response);
            } else if (pathInfo.startsWith("/detail/")) {
                handleCategoryDetail(request, response, pathInfo);
            } else if (pathInfo.equals("/create")) {
                // Only Librarian/Seller can create categories
                if (!AuthUtil.canManageCatalog(request)) {
                    handleUnauthorized(request, response);
                    return;
                }
                handleCategoryForm(request, response, null);
            } else if (pathInfo.startsWith("/edit/")) {
                // Only Librarian/Seller can edit categories
                if (!AuthUtil.canManageCatalog(request)) {
                    handleUnauthorized(request, response);
                    return;
                }
                handleCategoryForm(request, response, pathInfo);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in CategoryController", e);
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
                if (!AuthUtil.canManageCatalog(request)) {
                    handleUnauthorized(request, response);
                    return;
                }
                handleCreateCategory(request, response);
            } else if ("update".equals(action) || (pathInfo != null && pathInfo.startsWith("/update/"))) {
                if (!AuthUtil.canManageCatalog(request)) {
                    handleUnauthorized(request, response);
                    return;
                }
                handleUpdateCategory(request, response, pathInfo);
            } else {
                doGet(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in CategoryController POST", e);
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/categories/form.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void handleCategoryListing(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchName = StringUtil.cleanInput(request.getParameter("name"));
        String keyword = StringUtil.cleanInput(request.getParameter("keyword"));
        String sortBy = StringUtil.cleanInput(request.getParameter("sort"));

        CategoryDAO categoryDAO = new CategoryDAO();

        try {
            List<Category> categories;
            String searchSummary = "";

            if (!StringUtil.isBlank(searchName)) {
                categories = categoryDAO.searchCategoriesByName(searchName);
                searchSummary = "Tìm thấy " + categories.size() + " thể loại với tên chứa \"" + searchName + "\"";
            } else if (!StringUtil.isBlank(keyword)) {
                categories = categoryDAO.searchCategoriesByName(keyword);
                searchSummary = "Tìm thấy " + categories.size() + " thể loại với từ khóa \"" + keyword + "\"";
            } else if ("popular".equals(sortBy)) {
                categories = categoryDAO.getTopCategoriesByBookCount(50);
                searchSummary = "Hiển thị các thể loại phổ biến nhất";
            } else {
                categories = categoryDAO.getAllCategories();
                searchSummary = "Hiển thị tất cả " + categories.size() + " thể loại";
            }

            // Get book count for each category
            for (Category category : categories) {
                int bookCount = categoryDAO.countBooksByCategory(category.getCategoryId());
                request.setAttribute("bookCount_" + category.getCategoryId(), bookCount);
            }

            request.setAttribute("categories", categories);
            request.setAttribute("searchSummary", searchSummary);
            request.setAttribute("selectedName", searchName);
            request.setAttribute("selectedKeyword", keyword);
            request.setAttribute("selectedSort", sortBy);
            request.setAttribute("pageTitle", "Danh sách thể loại - Thư viện Số FPT");
            request.setAttribute("totalCategories", categoryDAO.getAllCategories().size());

            // Authorization flag for JSP
            request.setAttribute("canManageCatalog", AuthUtil.canManageCatalog(request));

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/categories/list.jsp");
            dispatcher.forward(request, response);

        } finally {
            categoryDAO.close();
        }
    }

    private void handleCategoryDetail(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {

        try {
            String categoryIdStr = pathInfo.substring("/detail/".length());
            int categoryId = Integer.parseInt(categoryIdStr);

            CategoryDAO categoryDAO = new CategoryDAO();
            BookDAO bookDAO = new BookDAO();

            try {
                Category category = categoryDAO.getCategoryById(categoryId);

                if (category != null) {
                    List<Book> categoryBooks = bookDAO.getBooksByCategory(categoryId);

                    request.setAttribute("category", category);
                    request.setAttribute("categoryBooks", categoryBooks);
                    request.setAttribute("totalBooks", categoryBooks.size());
                    request.setAttribute("pageTitle", category.getCategoryName() + " - Thư viện Số FPT");

                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/categories/detail.jsp");
                    dispatcher.forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }

            } finally {
                categoryDAO.close();
                bookDAO.close();
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID thể loại không hợp lệ");
        }
    }

    /**
     * Show category form for create or edit
     */
    private void handleCategoryForm(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {

        Category category = null;
        boolean isEdit = false;

        if (pathInfo != null && pathInfo.startsWith("/edit/")) {
            try {
                String categoryIdStr = pathInfo.substring("/edit/".length());
                int categoryId = Integer.parseInt(categoryIdStr);

                CategoryDAO categoryDAO = new CategoryDAO();
                try {
                    category = categoryDAO.getCategoryById(categoryId);
                    if (category == null) {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Thể loại không tồn tại");
                        return;
                    }
                    isEdit = true;
                } finally {
                    categoryDAO.close();
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID thể loại không hợp lệ");
                return;
            }
        } else {
            // Create mode
            category = new Category();
            isEdit = false;
        }

        request.setAttribute("category", category);
        request.setAttribute("isEdit", isEdit);
        request.setAttribute("pageTitle", (isEdit ? "Chỉnh sửa" : "Thêm mới") + " thể loại - Thư viện Số FPT");

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/categories/form.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Handle create category request
     */
    private void handleCreateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryName = StringUtil.cleanInput(request.getParameter("categoryName"));
        String description = StringUtil.cleanInput(request.getParameter("description"));

        // Validation
        if (StringUtil.isBlank(categoryName)) {
            request.setAttribute("error", "Tên thể loại không được để trống");
            Category category = new Category();
            category.setCategoryName(categoryName);
            category.setDescription(description);
            request.setAttribute("category", category);
            request.setAttribute("isEdit", false);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/categories/form.jsp");
            dispatcher.forward(request, response);
            return;
        }

        CategoryDAO categoryDAO = new CategoryDAO();
        try {
            // Check duplicate
            if (categoryDAO.categoryNameExists(categoryName, null)) {
                request.setAttribute("error", "Tên thể loại \"" + categoryName + "\" đã tồn tại");
                Category category = new Category();
                category.setCategoryName(categoryName);
                category.setDescription(description);
                request.setAttribute("category", category);
                request.setAttribute("isEdit", false);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/categories/form.jsp");
                dispatcher.forward(request, response);
                return;
            }

            Category category = new Category();
            category.setCategoryName(categoryName);
            category.setDescription(description);

            if (categoryDAO.createCategory(category)) {
                LOGGER.info("Category created successfully: " + category.getCategoryId());
                response.sendRedirect(request.getContextPath() + "/categories/detail/" + category.getCategoryId());
            } else {
                request.setAttribute("error", "Không thể tạo thể loại mới. Vui lòng thử lại.");
                request.setAttribute("category", category);
                request.setAttribute("isEdit", false);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/categories/form.jsp");
                dispatcher.forward(request, response);
            }
        } finally {
            categoryDAO.close();
        }
    }

    /**
     * Handle update category request
     */
    private void handleUpdateCategory(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {

        try {
            String categoryIdStr;
            if (pathInfo != null && pathInfo.startsWith("/update/")) {
                categoryIdStr = pathInfo.substring("/update/".length());
            } else {
                categoryIdStr = request.getParameter("categoryId");
            }

            if (categoryIdStr == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID thể loại");
                return;
            }

            int categoryId = Integer.parseInt(categoryIdStr);
            String categoryName = StringUtil.cleanInput(request.getParameter("categoryName"));
            String description = StringUtil.cleanInput(request.getParameter("description"));

            // Validation
            if (StringUtil.isBlank(categoryName)) {
                request.setAttribute("error", "Tên thể loại không được để trống");
                CategoryDAO categoryDAO = new CategoryDAO();
                try {
                    Category category = categoryDAO.getCategoryById(categoryId);
                    if (category != null) {
                        category.setCategoryName(categoryName);
                        category.setDescription(description);
                    }
                    request.setAttribute("category", category);
                    request.setAttribute("isEdit", true);
                } finally {
                    categoryDAO.close();
                }
                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/categories/form.jsp");
                dispatcher.forward(request, response);
                return;
            }

            CategoryDAO categoryDAO = new CategoryDAO();
            try {
                Category existingCategory = categoryDAO.getCategoryById(categoryId);
                if (existingCategory == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Thể loại không tồn tại");
                    return;
                }

                // Check duplicate name
                if (categoryDAO.categoryNameExists(categoryName, categoryId)) {
                    request.setAttribute("error", "Tên thể loại \"" + categoryName + "\" đã tồn tại");
                    Category category = new Category();
                    category.setCategoryId(categoryId);
                    category.setCategoryName(categoryName);
                    category.setDescription(description);
                    request.setAttribute("category", category);
                    request.setAttribute("isEdit", true);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/categories/form.jsp");
                    dispatcher.forward(request, response);
                    return;
                }

                Category category = new Category();
                category.setCategoryId(categoryId);
                category.setCategoryName(categoryName);
                category.setDescription(description);

                if (categoryDAO.updateCategory(category)) {
                    LOGGER.info("Category updated successfully: " + categoryId);
                    response.sendRedirect(request.getContextPath() + "/categories/detail/" + categoryId);
                } else {
                    request.setAttribute("error", "Không thể cập nhật thể loại. Vui lòng thử lại.");
                    request.setAttribute("category", category);
                    request.setAttribute("isEdit", true);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/categories/form.jsp");
                    dispatcher.forward(request, response);
                }
            } finally {
                categoryDAO.close();
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID thể loại không hợp lệ");
        }
    }

    /**
     * Handle unauthorized access
     */
    private void handleUnauthorized(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("error",
                "Bạn không có quyền truy cập chức năng này. Chỉ Librarian/Seller mới có thể quản lý thể loại.");
        request.setAttribute("pageTitle", "Không có quyền truy cập - Thư viện Số FPT");

        if (!AuthUtil.isLoggedIn(request)) {
            String requestedURL = request.getRequestURI();
            if (request.getQueryString() != null) {
                requestedURL += "?" + request.getQueryString();
            }
            request.getSession().setAttribute("redirectAfterLogin", requestedURL);
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
        } else {
            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/error/unauthorized.jsp");
            dispatcher.forward(request, response);
        }
    }
}