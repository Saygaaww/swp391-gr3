package controller.admin;

import dal.BookDAO;
import dal.AuthorDAO;
import dal.CategoryDAO;
import model.Book;
import model.Author;
import model.Category;
import model.Employee;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/admin/book-form")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 50,
    maxRequestSize = 1024 * 1024 * 60
)
public class AdminBookFormServlet extends HttpServlet {

    private BookDAO bookDAO;
    private AuthorDAO authorDAO;
    private CategoryDAO categoryDAO;
    private static final String UPLOAD_DIR_COVERS = "uploads/covers";
    private static final String UPLOAD_DIR_BOOKS = "uploads/books";

    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
        authorDAO = new AuthorDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            String idStr = request.getParameter("id");
            Book book = null;
            String mode = "add";

            if (idStr != null && !idStr.trim().isEmpty()) {
                int bookId = Integer.parseInt(idStr);
                if (bookId <= 0 || bookId > 999999999) {
                    response.sendRedirect(request.getContextPath() + "/admin/book-list");
                    return;
                }
                book = bookDAO.getBookById(bookId);
                if (book == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/book-list");
                    return;
                }
                mode = "edit";
            } else {
                book = new Book();
            }

            request.setAttribute("book", book);
            request.setAttribute("mode", mode);
            request.setAttribute("authors", authorDAO.getAllAuthors());
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("currentEmployee", session.getAttribute("user"));
            request.getRequestDispatcher("/WEB-INF/jsp/admin/book-form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/book-list");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/book-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        try {
            Employee employee = (Employee) session.getAttribute("user");

            BigDecimal maxPriceAllowed = bookDAO.getMaxPrice().multiply(new BigDecimal("1.2"));
            int maxPagesAllowed = (int) (bookDAO.getMaxTotalPages() * 1.2);
            if (maxPriceAllowed.compareTo(new BigDecimal("1000000")) < 0) maxPriceAllowed = new BigDecimal("100000000");
            if (maxPagesAllowed < 1000) maxPagesAllowed = 10000;

            String bookIdStr = request.getParameter("bookId");
            boolean isEdit = (bookIdStr != null && !bookIdStr.trim().isEmpty());

            String title = request.getParameter("title");
            String summary = request.getParameter("summary");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String currency = request.getParameter("currency");
            String totalPagesStr = request.getParameter("totalPages");
            String previewPagesStr = request.getParameter("previewPages");
            String status = request.getParameter("status");
            String authorIdStr = request.getParameter("authorId");
            String categoryIdStr = request.getParameter("categoryId");

            String coverUrl = request.getParameter("oldCoverUrl");
            String uploadResult = handleFileUpload(request, "coverFile", UPLOAD_DIR_COVERS,
                                                    new String[]{"jpg", "jpeg", "png", "gif"});
            if ("INVALID".equals(uploadResult)) {
                request.setAttribute("error", "Anh bia chi chap nhan JPG, PNG, GIF!");
                reloadFormWithError(request, response, isEdit, bookIdStr);
                return;
            }
            if (uploadResult != null) coverUrl = uploadResult;

            String contentPath = request.getParameter("oldContentPath");
            uploadResult = handleFileUpload(request, "contentFile", UPLOAD_DIR_BOOKS,
                                             new String[]{"pdf"});
            if ("INVALID".equals(uploadResult)) {
                request.setAttribute("error", "File noi dung chi chap nhan PDF!");
                reloadFormWithError(request, response, isEdit, bookIdStr);
                return;
            }
            if (uploadResult != null) contentPath = uploadResult;

            StringBuilder errors = new StringBuilder();

            if (title == null || title.trim().isEmpty()) errors.append("Ten sach khong duoc de trong. ");
            else if (title.trim().length() > 500) errors.append("Ten sach khong duoc qua 500 ky tu. ");

            BigDecimal price = BigDecimal.ZERO;
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                try {
                    price = new BigDecimal(priceStr.trim());
                    if (price.compareTo(BigDecimal.ZERO) < 0) errors.append("Gia tien khong duoc am. ");
                    if (price.compareTo(maxPriceAllowed) > 0) errors.append("Gia tien vuot qua gioi han. ");
                } catch (NumberFormatException e) {
                    errors.append("Gia tien khong hop le. ");
                }
            }

            int totalPages = parseIntSafe(totalPagesStr, 0);
            if (totalPagesStr != null && !totalPagesStr.trim().isEmpty()) {
                if (totalPages < 1) errors.append("So trang phai lon hon 0. ");
                if (totalPages > maxPagesAllowed) errors.append("So trang vuot qua gioi han. ");
            }

            int previewPages = parseIntSafe(previewPagesStr, 0);
            if (previewPages < 0) errors.append("So trang xem truoc khong duoc am. ");
            if (previewPages > totalPages && totalPages > 0) errors.append("So trang xem truoc lon hon tong trang. ");

            int authorId = parseIntSafe(authorIdStr, 0);
            if (authorId > 0 && authorDAO.getAuthorById(authorId) == null) errors.append("Tac gia khong ton tai. ");

            int categoryId = parseIntSafe(categoryIdStr, 0);
            if (categoryId > 0 && categoryDAO.getCategoryById(categoryId) == null) errors.append("Danh muc khong ton tai. ");

            if (status != null && !status.equals("active") && !status.equals("inactive") && !status.equals("draft")) {
                status = "active";
            }

            int bookId = 0;
            if (isEdit) {
                bookId = parseIntSafe(bookIdStr, 0);
                if (bookId > 0 && bookDAO.getBookById(bookId) == null) errors.append("Sach khong ton tai. ");
            }

            if (errors.length() > 0) {
                request.setAttribute("error", errors.toString());
                reloadFormWithError(request, response, isEdit, bookIdStr);
                return;
            }

            Book book = new Book();
            book.setTitle(title.trim());
            book.setSummary(summary != null ? summary.trim() : null);
            book.setDescription(description);
            book.setCoverUrl(coverUrl);
            book.setContentPath(contentPath);
            book.setPrice(price);
            book.setCurrency(currency != null && !currency.isEmpty() ? currency : "VND");
            book.setTotalPages(totalPages);
            book.setPreviewPages(previewPages);
            book.setStatus(status != null && !status.isEmpty() ? status : "active");
            book.setAuthorId(authorId);
            book.setCategoryId(categoryId);

            boolean success;
            if (isEdit) {
                book.setBookId(bookId);
                book.setUpdatedByEmployeeId(employee.getEmployeeId());
                success = bookDAO.updateBook(book);
            } else {
                book.setCreatedByEmployeeId(employee.getEmployeeId());
                success = bookDAO.addBook(book);
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/book-list");
            } else {
                request.setAttribute("error", "Khong the luu sach!");
                reloadFormWithError(request, response, isEdit, bookIdStr);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Loi he thong: " + e.getMessage());
            request.setAttribute("mode", "add");
            request.setAttribute("book", new Book());
            request.setAttribute("authors", authorDAO.getAllAuthors());
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/WEB-INF/jsp/admin/book-form.jsp").forward(request, response);
        }
    }

    private String handleFileUpload(HttpServletRequest request, String partName,
                                     String uploadDir, String[] allowedExts)
            throws IOException, ServletException {

        Part filePart = request.getPart(partName);
        if (filePart == null || filePart.getSize() <= 0) return null;

        String fileName = getFileName(filePart);
        if (fileName == null || fileName.isEmpty()) return null;

        String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

        boolean valid = false;
        for (String ext : allowedExts) {
            if (ext.equals(fileExt)) { valid = true; break; }
        }
        if (!valid) return "INVALID";

        String newFileName = UUID.randomUUID().toString() + "." + fileExt;
        String buildPath = getServletContext().getRealPath("") + File.separator + uploadDir;
        String webPath = getServletContext().getRealPath("").replace(
            "build" + File.separator + "web", "web") + File.separator + uploadDir;

        new File(buildPath).mkdirs();
        new File(webPath).mkdirs();

        String buildFilePath = buildPath + File.separator + newFileName;
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, Paths.get(buildFilePath), StandardCopyOption.REPLACE_EXISTING);
        }
        Files.copy(Paths.get(buildFilePath),
                   Paths.get(webPath + File.separator + newFileName),
                   StandardCopyOption.REPLACE_EXISTING);

        return uploadDir + "/" + newFileName;
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String token : contentDisp.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return null;
    }

    private int parseIntSafe(String str, int defaultVal) {
        if (str == null || str.trim().isEmpty()) return defaultVal;
        try { return Integer.parseInt(str.trim()); }
        catch (NumberFormatException e) { return defaultVal; }
    }

    private void reloadFormWithError(HttpServletRequest request, HttpServletResponse response,
                                      boolean isEdit, String bookIdStr)
            throws ServletException, IOException {

        if (isEdit && bookIdStr != null && !bookIdStr.isEmpty()) {
            try {
                Book existingBook = bookDAO.getBookById(Integer.parseInt(bookIdStr));
                request.setAttribute("book", existingBook != null ? existingBook : new Book());
            } catch (NumberFormatException e) {
                request.setAttribute("book", new Book());
            }
            request.setAttribute("mode", "edit");
        } else {
            request.setAttribute("mode", "add");
            request.setAttribute("book", new Book());
        }
        request.setAttribute("authors", authorDAO.getAllAuthors());
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.getRequestDispatcher("/WEB-INF/jsp/admin/book-form.jsp").forward(request, response);
    }
}
