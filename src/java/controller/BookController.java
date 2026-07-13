package controller;

import dao.BookDAO;
import dao.AuthorDAO;
import dao.CategoryDAO;
import dao.ReviewDAO;
import dal.BorrowDAO;
import dal.FineDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Book;
import model.Author;
import model.BorrowRequest;
import model.BorrowedItemView;
import model.Category;
import model.FineView;
import util.StringUtil;
import util.PaginatedResult;
import util.AuthUtil;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * BookController - Enhanced with Complete Pagination Support
 *
 * @author FPT Student Team
 */
@WebServlet(name = "BookController", urlPatterns = {"/books", "/books/*"})
public class BookController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(BookController.class.getName());

    // Regex validate định dạng dd-MM-yyyy
    private static final java.util.regex.Pattern DATE_DD_MM_YYYY
            = java.util.regex.Pattern.compile("^(0[1-9]|[12]\\d|3[01])-(0[1-9]|1[0-2])-(\\d{4})$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                handleBookListing(request, response);

            } else if (pathInfo.equals("/dashboard")) {
                // Librarian/Admin management dashboard
                if (!AuthUtil.canManageCatalog(request)) {
                    handleUnauthorized(request, response);
                    return;
                }
                handleLibrarianDashboard(request, response);

            } else if (pathInfo.equals("/list")) {
                // Force book list even for Librarian (e.g. browse mode)
                handleBookListing(request, response);

            } else if (pathInfo.equals("/create")) {
                // Tạo sách mới: /books/create
                if (!AuthUtil.canManageCatalog(request)) {
                    handleUnauthorized(request, response);
                    return;
                }
                handleBookForm(request, response, null);

            } else if (pathInfo.startsWith("/edit/")) {
                // Chỉnh sửa sách: /books/edit/{id}
                if (!AuthUtil.canManageCatalog(request)) {
                    handleUnauthorized(request, response);
                    return;
                }
                handleBookForm(request, response, pathInfo);

            } else if (pathInfo.startsWith("/detail/")) {
                // Handle book detail: /books/detail/{id}
                handleBookDetail(request, response, pathInfo);

            } else if (pathInfo.startsWith("/category/")) {
                // Handle books by category: /books/category/{id}
                handleBooksByCategory(request, response, pathInfo);

            } else if (pathInfo.equals("/latest")) {
                // Handle latest books: /books/latest
                handleLatestBooks(request, response);

            } else if (pathInfo.equals("/free")) {
                // Handle free books: /books/free
                handleFreeBooks(request, response);

            } else if (pathInfo.startsWith("/preview/")) {

                handleBookPreview(request, response, pathInfo);

            } else if (pathInfo.startsWith("/file/")) {

                handleServeFile(request, response, pathInfo);

            } else {
                // Path not found
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in BookController", e);
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu. Vui lòng thử lại.");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/books/list.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        try {
            if (pathInfo != null && (pathInfo.equals("/create") || pathInfo.startsWith("/update/"))) {
                if (!AuthUtil.canManageCatalog(request)) {
                    handleUnauthorized(request, response);
                    return;
                }
                handleSaveBook(request, response, pathInfo);
            } else {
                doGet(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in BookController POST", e);
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/books/form.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void handleBookPreview(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {

        int bookId;
        try {
            bookId = Integer.parseInt(pathInfo.substring("/preview/".length()));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sách không hợp lệ");
            return;
        }

        BookDAO bookDAO = new BookDAO();
        try {
            Book book = bookDAO.getBookById(bookId);
            if (book == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sách");
                return;
            }

            // Nếu sách miễn phí thì chuyển sang đọc toàn bộ luôn
            if (book.getPrice() == null || book.getPrice().compareTo(java.math.BigDecimal.ZERO) <= 0) {
                response.sendRedirect(request.getContextPath() + "/customer/read?bookId=" + bookId);
                return;
            }

            // previewPages = số trang được phép xem, mặc định 10 nếu chưa cấu hình
            Integer previewPages = book.getPreviewPages();
            int allowedPages = (previewPages != null && previewPages > 0) ? previewPages : 10;

            request.setAttribute("book", book);
            request.setAttribute("allowedPages", allowedPages);
            request.getRequestDispatcher("/jsp/books/preview.jsp").forward(request, response);

        } finally {
            bookDAO.close();
        }
    }

    private void handleServeFile(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {

        // Chỉ cho phép user đã đăng nhập mới được stream PDF
        if (!AuthUtil.isLoggedIn(request)) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Vui lòng đăng nhập để xem tài liệu.");
            return;
        }

        int bookId;
        try {
            bookId = Integer.parseInt(pathInfo.substring("/file/".length()));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sách không hợp lệ");
            return;
        }

        BookDAO dao = new BookDAO();
        try {
            Book book = dao.getBookById(bookId);

            if (book == null || book.getContentPath() == null || book.getContentPath().trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy file sách (đường dẫn trống)");
                return;
            }

            // Nếu ContentPath là đường dẫn web tương đối (books/content/...) hoặc bắt đầu bằng /,
            // map sang đường dẫn vật lý trong webapp
            String rawPath = book.getContentPath().trim();
            
            // Handle directory rename from web/books to web/book-files
            if (rawPath.startsWith("books/")) {
                rawPath = "book-files/" + rawPath.substring(6);
            } else if (rawPath.startsWith("/books/")) {
                rawPath = "/book-files/" + rawPath.substring(7);
            }

            String physicalPath;
            if (rawPath.startsWith("/") || rawPath.startsWith("\\")) {
                // Đã là đường dẫn web từ gốc context
                physicalPath = getServletContext().getRealPath(rawPath);
            } else {
                // Đường dẫn tương đối (ví dụ: books/content/mat-biec.pdf) → thêm "/" phía trước
                physicalPath = getServletContext().getRealPath("/" + rawPath);
            }

            java.io.File file = new java.io.File(physicalPath);

            if (!file.exists() || !file.isFile()) {
                LOGGER.warning("PDF file not found on disk. BookID=" + bookId + ", path=" + physicalPath);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File không tồn tại trên server");
                return;
            }

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");
            response.setContentLengthLong(file.length());
            java.nio.file.Files.copy(file.toPath(), response.getOutputStream());

        } finally {
            dao.close();
        }
    }

    /**
     * Handle book detail requests
     */
    private void handleBookDetail(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {

        try {
            String bookIdStr = pathInfo.substring("/detail/".length());
            int bookId = Integer.parseInt(bookIdStr);

            LOGGER.info("Book detail request for ID: " + bookId);

            BookDAO bookDAO = new BookDAO();

            try {
                Book book = bookDAO.getBookById(bookId);

                if (book != null) {
                    request.setAttribute("book", book);
                    request.setAttribute("pageTitle", book.getTitle() + " - Thư viện Số FPT");
                    // Authorization flag for book management (upload/update file, etc.)
                    request.setAttribute("canManageBooks", AuthUtil.canManageBooks(request));
                    // Format createdAt thành dd-MM-yyyy để hiển thị trên JSP
                    if (book.getCreatedAt() != null) {
                        String createdAtFormatted = book.getCreatedAt()
                                .format(java.time.format.DateTimeFormatter.ofPattern("dd-MM-yyyy"));
                        request.setAttribute("createdAtFormatted", createdAtFormatted);
                    }

                    int availableStock = bookDAO.getAvailableStock(bookId);
                    request.setAttribute("availableStock", availableStock);

                    // Fetch reviews – visible to all users including guests
                    ReviewDAO reviewDAO = new ReviewDAO();
                    request.setAttribute("reviews", reviewDAO.getByBook(bookId));

                    RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/books/detail.jsp");
                    dispatcher.forward(request, response);

                } else {
                    LOGGER.warning("Book not found for ID: " + bookId);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sách không tồn tại");
                }

            } finally {
                bookDAO.close();
            }

        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid book ID format: " + pathInfo);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sách không hợp lệ");
        }
    }

    /**
     * Handle book listing with complete pagination support
     */
    private void handleBookListing(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get all filter parameters
        String searchTitle = StringUtil.cleanInput(request.getParameter("title"));
        String authorIdStr = StringUtil.cleanInput(request.getParameter("authorId"));
        String categoryIdStr = StringUtil.cleanInput(request.getParameter("categoryId"));
        String minPriceStr = StringUtil.cleanInput(request.getParameter("minPrice"));
        String maxPriceStr = StringUtil.cleanInput(request.getParameter("maxPrice"));
        String keyword = StringUtil.cleanInput(request.getParameter("keyword"));
        String language = StringUtil.cleanInput(request.getParameter("language"));
        String yearRange = StringUtil.cleanInput(request.getParameter("publicationYear"));
        String priceType = StringUtil.cleanInput(request.getParameter("priceType"));
        String sortBy = StringUtil.cleanInput(request.getParameter("sortBy"));

        // Pagination parameters
        String pageStr = StringUtil.cleanInput(request.getParameter("page"));
        String pageSizeStr = StringUtil.cleanInput(request.getParameter("pageSize"));

        int page = parseInteger(pageStr) != null ? parseInteger(pageStr) : 1;
        int pageSize = parseInteger(pageSizeStr) != null ? parseInteger(pageSizeStr) : 12;

        // Validate pagination parameters
        if (page < 1) {
            page = 1;
        }
        if (pageSize < 6) {
            pageSize = 6;
        }
        if (pageSize > 48) {
            pageSize = 48; // Prevent abuse
        }
        LOGGER.info("Paginated search - page: " + page + ", pageSize: " + pageSize
            + ", keyword: " + keyword + ", filters applied");

        BookDAO bookDAO = new BookDAO();
        AuthorDAO authorDAO = new AuthorDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        try {
            PaginatedResult<Book> paginatedResult;
            String searchSummary = "";

            // Parse filter parameters
            Integer selectedAuthorId = parseInteger(authorIdStr);
            Integer selectedCategoryId = parseInteger(categoryIdStr);
            BigDecimal selectedMinPrice = parseBigDecimal(minPriceStr);
            BigDecimal selectedMaxPrice = parseBigDecimal(maxPriceStr);

            // Perform paginated search
            if (!StringUtil.isBlank(keyword)) {
                // Keyword search with pagination
                paginatedResult = bookDAO.searchByKeywordWithPagination(keyword, page, pageSize);
                searchSummary = buildKeywordSearchSummary(paginatedResult.getTotalCount(), keyword);
            } else {
                // Advanced filter search with pagination
                paginatedResult = bookDAO.searchBooksWithPagination(
                        searchTitle, selectedAuthorId, selectedCategoryId,
                        selectedMinPrice, selectedMaxPrice,
                        language, yearRange, priceType, sortBy,
                        page, pageSize);
                searchSummary = buildAdvancedSearchSummary(paginatedResult.getTotalCount(),
                        searchTitle, selectedAuthorId, selectedCategoryId,
                        language, yearRange, priceType);
            }

            // Get dropdown options
            List<Author> authors = authorDAO.getAuthorsWithBooks();
            List<Category> categories = categoryDAO.getCategoriesWithBooks();

            // controller gui cho JSP
            request.setAttribute("paginatedResult", paginatedResult);
            request.setAttribute("books", paginatedResult.getItems()); // Backward compatibility
            request.setAttribute("authors", authors); // 12
            request.setAttribute("categories", categories);
            request.setAttribute("searchSummary", searchSummary);

            // Pagination info
            request.setAttribute("currentPage", page);// 1
            request.setAttribute("totalPages", paginatedResult.getTotalPages());// 13
            request.setAttribute("totalCount", paginatedResult.getTotalCount());
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("hasPreviousPage", paginatedResult.hasPreviousPage());
            request.setAttribute("hasNextPage", paginatedResult.hasNextPage());
            request.setAttribute("paginationInfo", paginatedResult.getPaginationInfo());

            // Keep all selected values for form state
            request.setAttribute("selectedTitle", searchTitle);
            request.setAttribute("selectedAuthorId", selectedAuthorId);
            request.setAttribute("selectedCategoryId", selectedCategoryId);
            request.setAttribute("selectedMinPrice", selectedMinPrice);
            request.setAttribute("selectedMaxPrice", selectedMaxPrice);
            request.setAttribute("selectedKeyword", keyword);
            request.setAttribute("selectedLanguage", language);
            request.setAttribute("selectedYearRange", yearRange);
            request.setAttribute("selectedPriceType", priceType);
            request.setAttribute("selectedSortBy", sortBy != null ? sortBy : "newest");
            request.setAttribute("isAdmin", AuthUtil.isAdmin(request));
            request.setAttribute("canManageCatalog", AuthUtil.canManageCatalog(request));

            // Build current URL for pagination links
            String currentUrl = buildCurrentUrl(request);
            request.setAttribute("currentUrl", currentUrl);

            request.setAttribute("pageTitle", "Tìm kiếm sách - Trang " + page + " - Thư viện Số FPT");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/books/list.jsp");
            dispatcher.forward(request, response);

        } finally {
            bookDAO.close();
            authorDAO.close();
            categoryDAO.close();
        }
    }

    /**
     * Handle books by category with pagination
     */
    private void handleBooksByCategory(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {

        try {
            String categoryIdStr = pathInfo.substring("/category/".length());
            int categoryId = Integer.parseInt(categoryIdStr);

            // Get pagination parameters
            String pageStr = request.getParameter("page");
            int page = parseInteger(pageStr) != null ? parseInteger(pageStr) : 1;
            int pageSize = 12; // Default page size for category browsing

            BookDAO bookDAO = new BookDAO();
            CategoryDAO categoryDAO = new CategoryDAO();

            try {
                // Use pagination for category results too
                PaginatedResult<Book> paginatedResult = bookDAO.searchBooksWithPagination(
                        null, null, categoryId, null, null, null, null, null, "newest", page, pageSize);

                Category category = categoryDAO.getCategoryById(categoryId);

                String searchSummary = category != null ? String.format("Hiển thị %d cuốn sách trong thể loại \"%s\"",
                        paginatedResult.getTotalCount(), category.getCategoryName())
                        : "Hiển thị " + paginatedResult.getTotalCount() + " cuốn sách";

                request.setAttribute("paginatedResult", paginatedResult);
                request.setAttribute("books", paginatedResult.getItems());
                request.setAttribute("searchSummary", searchSummary);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", paginatedResult.getTotalPages());
                request.setAttribute("hasNextPage", paginatedResult.hasNextPage());
                request.setAttribute("hasPreviousPage", paginatedResult.hasPreviousPage());
                request.setAttribute("currentUrl", request.getRequestURI() + "?");

                request.setAttribute("pageTitle",
                        (category != null ? category.getCategoryName() : "Thể loại") + " - Thư viện Số FPT");

                RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/books/list.jsp");
                dispatcher.forward(request, response);

            } finally {
                bookDAO.close();
                categoryDAO.close();
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID thể loại không hợp lệ");
        }
    }

    /**
     * Handle latest books with pagination
     */
    private void handleLatestBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pageStr = request.getParameter("page");
        int page = parseInteger(pageStr) != null ? parseInteger(pageStr) : 1;
        int pageSize = 12;

        BookDAO bookDAO = new BookDAO();

        try {
            // Use advanced search with date sorting for latest books
            PaginatedResult<Book> paginatedResult = bookDAO.searchBooksWithPagination(
                    null, null, null, null, null, null, null, null, "newest", page, pageSize);

            request.setAttribute("paginatedResult", paginatedResult);
            request.setAttribute("books", paginatedResult.getItems());
            request.setAttribute("searchSummary",
                    "Hiển thị " + paginatedResult.getTotalCount() + " cuốn sách mới nhất");
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", paginatedResult.getTotalPages());
            request.setAttribute("hasNextPage", paginatedResult.hasNextPage());
            request.setAttribute("hasPreviousPage", paginatedResult.hasPreviousPage());
            request.setAttribute("currentUrl", request.getRequestURI() + "?");
            request.setAttribute("pageTitle", "Sách mới nhất - Thư viện Số FPT");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/books/list.jsp");
            dispatcher.forward(request, response);

        } finally {
            bookDAO.close();
        }
    }

    /**
     * Handle free books with pagination
     */
    private void handleFreeBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pageStr = request.getParameter("page");
        int page = parseInteger(pageStr) != null ? parseInteger(pageStr) : 1;
        int pageSize = 12;

        BookDAO bookDAO = new BookDAO();

        try {
            // Use advanced search with free price type
            PaginatedResult<Book> paginatedResult = bookDAO.searchBooksWithPagination(
                    null, null, null, null, null, null, null, "free", "newest", page, pageSize);

            request.setAttribute("paginatedResult", paginatedResult);
            request.setAttribute("books", paginatedResult.getItems());
            request.setAttribute("searchSummary",
                    "Hiển thị " + paginatedResult.getTotalCount() + " cuốn sách miễn phí");
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", paginatedResult.getTotalPages());
            request.setAttribute("hasNextPage", paginatedResult.hasNextPage());
            request.setAttribute("hasPreviousPage", paginatedResult.hasPreviousPage());
            request.setAttribute("currentUrl", request.getRequestURI() + "?");
            request.setAttribute("pageTitle", "Sách miễn phí - Thư viện Số FPT");

            RequestDispatcher dispatcher = request.getRequestDispatcher("/jsp/books/list.jsp");
            dispatcher.forward(request, response);

        } finally {
            bookDAO.close();
        }
    }

    // ========== UTILITY METHODS ==========
    private Integer parseInteger(String value) {
        if (StringUtil.isBlank(value)) {
            return null;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private BigDecimal parseBigDecimal(String value) {
        if (StringUtil.isBlank(value)) {
            return null;
        }
        try {
            return new BigDecimal(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String buildCurrentUrl(HttpServletRequest request) {
        StringBuilder url = new StringBuilder(request.getRequestURI());
        String queryString = request.getQueryString();

        if (queryString != null && !queryString.isEmpty()) {
            // Remove page parameter if exists
            String cleanQuery = queryString.replaceAll("(&?)page=\\d+", "")
                    .replaceAll("^&", "")
                    .replaceAll("&$", "");

            if (!cleanQuery.isEmpty()) {
                url.append("?").append(cleanQuery);
                return url.toString() + "&";
            }
        }

        return url.toString() + "?";
    }

    private String buildKeywordSearchSummary(int totalCount, String keyword) {
        return String.format("Tìm thấy %d cuốn sách với từ khóa \"%s\"", totalCount, keyword);
    }

    private String buildAdvancedSearchSummary(int totalCount, String title, Integer authorId,
            Integer categoryId, String language,
            String yearRange, String priceType) {

        if (StringUtil.isBlank(title) && authorId == null && categoryId == null
                && StringUtil.isBlank(language) && StringUtil.isBlank(yearRange)
                && StringUtil.isBlank(priceType)) {
            return String.format("Tổng cộng %d cuốn sách", totalCount);
        }

        StringBuilder summary = new StringBuilder(String.format("Tìm thấy %d cuốn sách", totalCount));
        List<String> criteria = new ArrayList<>();

        if (!StringUtil.isBlank(title)) {
            criteria.add("tên chứa \"" + title + "\"");
        }

        if (!StringUtil.isBlank(language)) {
            criteria.add("ngôn ngữ " + language);
        }

        if (!StringUtil.isBlank(yearRange)) {
            criteria.add("xuất bản " + getYearRangeText(yearRange));
        }

        if (!StringUtil.isBlank(priceType)) {
            criteria.add(priceType.equals("free") ? "miễn phí" : "có phí");
        }

        if (!criteria.isEmpty()) {
            summary.append(" với ").append(String.join(", ", criteria));
        }

        return summary.toString();
    }

    private String getYearRangeText(String yearRange) {
        switch (yearRange) {
            case "2020-2024":
                return "2020-2024";
            case "2010-2019":
                return "2010-2019";
            case "2000-2009":
                return "2000-2009";
            case "1990-1999":
                return "1990-1999";
            case "1980-1989":
                return "1980-1989";
            case "before-1980":
                return "trước 1980";
            default:
                return yearRange;
        }
    }

    /**
     * Hiển thị form tạo mới hoặc chỉnh sửa sách
     */
    private void handleBookForm(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {
        Book book = null;
        boolean isEdit = false;
        if (pathInfo != null && pathInfo.startsWith("/edit/")) {
            try {
                int bookId = Integer.parseInt(pathInfo.substring("/edit/".length()));
                BookDAO bookDAO = new BookDAO();
                try {
                    book = bookDAO.getBookById(bookId);
                } finally {
                    bookDAO.close();
                }
                if (book == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                isEdit = true;
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
        } else {
            book = new Book();
        }

        AuthorDAO authorDAO = new AuthorDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        try {
            request.setAttribute("book", book);
            request.setAttribute("isEdit", isEdit);
            request.setAttribute("authors", authorDAO.getAllAuthors());
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("pageTitle", (isEdit ? "Chỉnh sửa" : "Thêm mới") + " sách - Thư viện Số FPT");
            request.getRequestDispatcher("/jsp/books/form.jsp").forward(request, response);
        } finally {
            authorDAO.close();
            categoryDAO.close();
        }
    }

    /**
     * Xử lý POST tạo mới hoặc cập nhật sách
     */
    private void handleSaveBook(HttpServletRequest request, HttpServletResponse response, String pathInfo)
            throws ServletException, IOException {
        String title = StringUtil.cleanInput(request.getParameter("title"));
        String summary = StringUtil.cleanInput(request.getParameter("summary"));
        String description = StringUtil.cleanInput(request.getParameter("description"));
        String coverUrl = StringUtil.cleanInput(request.getParameter("coverUrl"));
        String language = StringUtil.cleanInput(request.getParameter("language"));
        String createdAtStr = StringUtil.cleanInput(request.getParameter("createdAt"));

        Integer authorId = parseIntOrNull(request.getParameter("authorId"));
        Integer categoryId = parseIntOrNull(request.getParameter("categoryId"));
        Integer totalPages = parseIntOrNull(request.getParameter("totalPages"));
        Integer previewPages = parseIntOrNull(request.getParameter("previewPages"));
        Integer pubYear = parseIntOrNull(request.getParameter("publicationYear"));
        java.math.BigDecimal price = parseBdOrNull(request.getParameter("price"));

        String formPath = pathInfo.startsWith("/update/") ? pathInfo.replace("/update/", "/edit/") : null;

        if (StringUtil.isBlank(title)) { request.setAttribute("error", "Tá»±a sÃ¡ch khÃ´ng Ä‘Æ°á»£c Ä‘á»ƒ trá»‘ng."); handleBookForm(request, response, formPath); return; }

        // Validate createdAt: nếu có nhập thì phải đúng định dạng dd-MM-yyyy
        java.time.LocalDateTime createdAt = null;
        if (!StringUtil.isBlank(createdAtStr)) {
            if (!DATE_DD_MM_YYYY.matcher(createdAtStr.trim()).matches()) {
                request.setAttribute("error", "Ngày tạo không hợp lệ. Định dạng phải là dd-MM-yyyy (ví dụ: 25-12-2024).");
                handleBookForm(request, response, formPath);
                return;
            }
            try {
                java.time.LocalDate date = java.time.LocalDate.parse(
                        createdAtStr.trim(),
                        java.time.format.DateTimeFormatter.ofPattern("dd-MM-yyyy"));
                createdAt = date.atStartOfDay();
            } catch (java.time.format.DateTimeParseException e) {
                request.setAttribute("error", "Ngày tạo không hợp lệ. Vui lòng kiểm tra lại ngày/tháng.");
                handleBookForm(request, response, formPath);
                return;
            }
        }

        Book book = new Book();
        book.setTitle(title);
        book.setSummary(summary);
        book.setDescription(description);
        book.setCoverUrl(coverUrl);
        book.setLanguage(language);
        book.setAuthorId(authorId);
        book.setCategoryId(categoryId);
        book.setTotalPages(totalPages);
        book.setPreviewPages(previewPages);
        book.setPublicationYear(pubYear);
        book.setPrice(price);
        book.setCurrency("VND");
        if (createdAt != null) {
            book.setCreatedAt(createdAt);
        }

        BookDAO bookDAO = new BookDAO();
        try {
            if (pathInfo.equals("/create")) {
                int newId = bookDAO.createBook(book);
                if (newId > 0) {
                    response.sendRedirect(request.getContextPath() + "/books/detail/" + newId);
                } else {
                    request.setAttribute("error", "Không thể tạo sách. Vui lòng thử lại.");
                    handleBookForm(request, response, null);
                }
            } else {
                // /update/{id}
                int bookId = Integer.parseInt(pathInfo.substring("/update/".length()));
                book.setBookId(bookId);
                if (bookDAO.updateBook(book)) {
                    response.sendRedirect(request.getContextPath() + "/books/detail/" + bookId);
                } else {
                    request.setAttribute("error", "Không thể cập nhật sách.");
                    handleBookForm(request, response, "/edit/" + bookId);
                }
            }
        } finally {
            bookDAO.close();
        }
    }

    private Integer parseIntOrNull(String s) {
        if (s == null || s.isBlank()) {
            return null;
        }
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private java.math.BigDecimal parseBdOrNull(String s) {
        if (s == null || s.isBlank()) {
            return null;
        }
        try {
            return new java.math.BigDecimal(s.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private void handleUnauthorized(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!AuthUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login?error=unauthorized");
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền thực hiện thao tác này.");
        }
    }

    private void handleLibrarianDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BookDAO bookDAO = new BookDAO();
        AuthorDAO authorDAO = new AuthorDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        BorrowDAO borrowDAO = new BorrowDAO();
        FineDAO fineDAO = new FineDAO();
        try {
            int totalBooks = bookDAO.getTotalBookCount();
            int totalAuthors = authorDAO.getAllAuthors().size();
            int totalCategories = categoryDAO.getAllCategories().size();
            List<Book> recentBooks = bookDAO.getLatestBooks(8);

            // Notifications for librarian: new borrow requests, return requests, and paid fines.
            int pendingBorrowCount = borrowDAO.countByStatus("pending");
            List<BorrowRequest> pendingBorrowNotifications = borrowDAO.getRequestsFiltered(null, "pending", 1, 5);

            List<BorrowedItemView> allReturnRequests = borrowDAO.getReturnRequests();
            int returnRequestCount = allReturnRequests.size();
            List<BorrowedItemView> returnRequestNotifications =
                    allReturnRequests.size() > 5 ? allReturnRequests.subList(0, 5) : allReturnRequests;

            List<FineView> allFines = fineDAO.getAllFines();
            List<FineView> paidFineNotifications = new ArrayList<>();
            int paidFineCount = 0;
            java.time.LocalDateTime recentThreshold = java.time.LocalDateTime.now().minusDays(2);
            for (FineView fine : allFines) {
                if (fine == null || fine.getStatus() == null || fine.getPaidAt() == null) {
                    continue;
                }
                if ("paid".equalsIgnoreCase(fine.getStatus()) && fine.getPaidAt().isAfter(recentThreshold)) {
                    paidFineCount++;
                    if (paidFineNotifications.size() < 5) {
                        paidFineNotifications.add(fine);
                    }
                }
            }

            request.setAttribute("totalBooks", totalBooks);
            request.setAttribute("totalAuthors", totalAuthors);
            request.setAttribute("totalCategories", totalCategories);
            request.setAttribute("recentBooks", recentBooks);
            request.setAttribute("canManageBooks", true);
            request.setAttribute("pendingBorrowCount", pendingBorrowCount);
            request.setAttribute("pendingBorrowNotifications", pendingBorrowNotifications);
            request.setAttribute("returnRequestCount", returnRequestCount);
            request.setAttribute("returnRequestNotifications", returnRequestNotifications);
            request.setAttribute("paidFineCount", paidFineCount);
            request.setAttribute("paidFineNotifications", paidFineNotifications);
            request.setAttribute("adminNotifCount", pendingBorrowCount + returnRequestCount + paidFineCount);

            String role = (String) request.getSession().getAttribute(AuthUtil.SESSION_USER_ROLE);
            String jspPath = "/jsp/librarian/dashboard.jsp";
            if (AuthUtil.ROLE_SELLER.equals(role)) {
                jspPath = "/jsp/seller/dashboard.jsp";
            }

            RequestDispatcher rd = request.getRequestDispatcher(jspPath);
            rd.forward(request, response);
        } finally {
            bookDAO.close();
            authorDAO.close();
            categoryDAO.close();
        }
    }
}

