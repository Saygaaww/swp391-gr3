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
        System.out.println("AdminBookFormServlet initialized with file upload");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }

        try {
            String idStr = request.getParameter("id");
            Book book = null;
            String mode = "add";

            if (idStr != null && !idStr.trim().isEmpty()) {
                int bookId = Integer.parseInt(idStr);

                if (bookId <= 0 || bookId > 999999999) {
                    response.sendRedirect(request.getContextPath() + "/books-list");
                    return;
                }

                book = bookDAO.getBookById(bookId);

                if (book == null) {
                    response.sendRedirect(request.getContextPath() + "/books-list");
                    return;
                }

                mode = "edit";
            } else {
                book = new Book();
            }

            List<Author> authors = authorDAO.getAllAuthors();
            List<Category> categories = categoryDAO.getAllCategories();

            request.setAttribute("book", book);
            request.setAttribute("mode", mode);
            request.setAttribute("authors", authors);
            request.setAttribute("categories", categories);
            request.setAttribute("currentEmployee", session.getAttribute("employee"));

            request.getRequestDispatcher("/admin/book-form.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/books-list");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/books-list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        try {
            Employee employee = (Employee) session.getAttribute("employee");

            BigDecimal maxPriceFromDB = bookDAO.getMaxPrice();
            int maxPagesFromDB = bookDAO.getMaxTotalPages();
            BigDecimal maxPriceAllowed = maxPriceFromDB.multiply(new BigDecimal("1.2"));
            int maxPagesAllowed = (int) (maxPagesFromDB * 1.2);

            if (maxPriceAllowed.compareTo(new BigDecimal("1000000")) < 0) {
                maxPriceAllowed = new BigDecimal("100000000");
            }
            if (maxPagesAllowed < 1000) {
                maxPagesAllowed = 10000;
            }

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

            String oldCoverUrl = request.getParameter("oldCoverUrl");
            String oldContentPath = request.getParameter("oldContentPath");

            String coverUrl = oldCoverUrl;

            Part coverPart = request.getPart("coverFile");
            if (coverPart != null && coverPart.getSize() > 0) {
                String fileName = getFileName(coverPart);

                if (fileName != null && !fileName.isEmpty()) {
                    String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

                    if (fileExt.equals("jpg") || fileExt.equals("jpeg")
                            || fileExt.equals("png") || fileExt.equals("gif")) {

                        String newFileName = UUID.randomUUID().toString() + "." + fileExt;

                        String buildPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR_COVERS;

                        String webPath = getServletContext().getRealPath("").replace("build" + File.separator + "web", "web")
                                + File.separator + UPLOAD_DIR_COVERS;

                        new File(buildPath).mkdirs();
                        new File(webPath).mkdirs();

                        String buildFilePath = buildPath + File.separator + newFileName;
                        try (InputStream input = coverPart.getInputStream()) {
                            Files.copy(input, Paths.get(buildFilePath), StandardCopyOption.REPLACE_EXISTING);
                        }

                        String webFilePath = webPath + File.separator + newFileName;
                        Files.copy(Paths.get(buildFilePath), Paths.get(webFilePath), StandardCopyOption.REPLACE_EXISTING);

                        coverUrl = UPLOAD_DIR_COVERS + "/" + newFileName;
                        System.out.println("Upload anh bia: " + buildFilePath);
                        System.out.println("Backup to: " + webFilePath);

                    } else {
                        request.setAttribute("error", "Anh bia chi chap nhan JPG, PNG, GIF!");
                        reloadFormWithError(request, response, isEdit, bookIdStr);
                        return;
                    }
                }
            }

            String contentPath = oldContentPath;

            Part pdfPart = request.getPart("contentFile");
            if (pdfPart != null && pdfPart.getSize() > 0) {
                String fileName = getFileName(pdfPart);

                if (fileName != null && !fileName.isEmpty()) {
                    String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

                    if (fileExt.equals("pdf")) {

                        String newFileName = UUID.randomUUID().toString() + ".pdf";

                        String buildPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR_BOOKS;

                        String webPath = getServletContext().getRealPath("").replace("build" + File.separator + "web", "web")
                                + File.separator + UPLOAD_DIR_BOOKS;

                        new File(buildPath).mkdirs();
                        new File(webPath).mkdirs();

                        String buildFilePath = buildPath + File.separator + newFileName;
                        try (InputStream input = pdfPart.getInputStream()) {
                            Files.copy(input, Paths.get(buildFilePath), StandardCopyOption.REPLACE_EXISTING);
                        }

                        String webFilePath = webPath + File.separator + newFileName;
                        Files.copy(Paths.get(buildFilePath), Paths.get(webFilePath), StandardCopyOption.REPLACE_EXISTING);

                        contentPath = UPLOAD_DIR_BOOKS + "/" + newFileName;
                        System.out.println("Upload PDF: " + buildFilePath);
                        System.out.println("Backup to: " + webFilePath);

                    } else {
                        request.setAttribute("error", "File noi dung chi chap nhan PDF!");
                        reloadFormWithError(request, response, isEdit, bookIdStr);
                        return;
                    }
                }
            }

            StringBuilder errors = new StringBuilder();

            if (title == null || title.trim().isEmpty()) {
                errors.append("Ten sach khong duoc de trong. ");
            } else if (title.trim().length() > 500) {
                errors.append("Ten sach khong duoc qua 500 ky tu. ");
            }

            BigDecimal price = BigDecimal.ZERO;
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                try {
                    price = new BigDecimal(priceStr.trim());
                    if (price.compareTo(BigDecimal.ZERO) < 0) {
                        errors.append("Gia tien khong duoc am. ");
                    }
                    if (price.compareTo(maxPriceAllowed) > 0) {
                        errors.append("Gia tien khong duoc vuot qua " + maxPriceAllowed.toBigInteger() + " VND. ");
                    }
                } catch (NumberFormatException e) {
                    errors.append("Gia tien khong hop le. ");
                }
            }

            int totalPages = 0;
            if (totalPagesStr != null && !totalPagesStr.trim().isEmpty()) {
                try {
                    totalPages = Integer.parseInt(totalPagesStr.trim());
                    if (totalPages < 1) {
                        errors.append("So trang phai lon hon 0. ");
                    }
                    if (totalPages > maxPagesAllowed) {
                        errors.append("So trang khong duoc vuot qua " + maxPagesAllowed + ". ");
                    }
                } catch (NumberFormatException e) {
                    errors.append("So trang khong hop le. ");
                }
            }

            int previewPages = 0;
            if (previewPagesStr != null && !previewPagesStr.trim().isEmpty()) {
                try {
                    previewPages = Integer.parseInt(previewPagesStr.trim());
                    if (previewPages < 0) {
                        errors.append("So trang xem truoc khong duoc am. ");
                    }
                    if (previewPages > totalPages && totalPages > 0) {
                        errors.append("So trang xem truoc khong duoc lon hon tong so trang. ");
                    }
                } catch (NumberFormatException e) {
                    errors.append("So trang xem truoc khong hop le. ");
                }
            }

            int authorId = 0;
            if (authorIdStr != null && !authorIdStr.trim().isEmpty()) {
                try {
                    authorId = Integer.parseInt(authorIdStr.trim());
                    if (authorId > 0) {
                        Author author = authorDAO.getAuthorById(authorId);
                        if (author == null) {
                            errors.append("Tac gia khong ton tai. ");
                        }
                    }
                } catch (NumberFormatException e) {
                    errors.append("ID tac gia khong hop le. ");
                }
            }

            int categoryId = 0;
            if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryIdStr.trim());
                    if (categoryId > 0) {
                        Category category = categoryDAO.getCategoryById(categoryId);
                        if (category == null) {
                            errors.append("Danh muc khong ton tai. ");
                        }
                    }
                } catch (NumberFormatException e) {
                    errors.append("ID danh muc khong hop le. ");
                }
            }

            if (status != null && !status.isEmpty()) {
                if (!status.equals("active") && !status.equals("inactive") && !status.equals("draft")) {
                    status = "active";
                }
            }

            int bookId = 0;
            if (isEdit) {
                try {
                    bookId = Integer.parseInt(bookIdStr.trim());
                    if (bookId > 0) {
                        Book existingBook = bookDAO.getBookById(bookId);
                        if (existingBook == null) {
                            errors.append("Sach khong ton tai. ");
                        }
                    }
                } catch (NumberFormatException e) {
                    errors.append("ID sach khong hop le. ");
                }
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
                response.sendRedirect(request.getContextPath() + "/books-list");
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
            request.getRequestDispatcher("/admin/book-form.jsp").forward(request, response);
        }
    }

    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return null;
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
        request.getRequestDispatcher("/admin/book-form.jsp").forward(request, response);
    }
}
