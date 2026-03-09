package controller;

import dao.BookDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Book;
import util.AuthUtil;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * BookFileController - Handle upload/update of book digital content file (contentPath)
 * Only Librarian/Seller can access these endpoints.
 */
@WebServlet(name = "BookFileController", urlPatterns = {"/books/upload/*"})
@MultipartConfig(maxFileSize = 50 * 1024 * 1024) // 50MB
public class BookFileController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(BookFileController.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AuthUtil.canManageBooks(request)) {
            handleUnauthorized(request, response);
            return;
        }

        String pathInfo = request.getPathInfo(); // /{id}
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID sách");
            return;
        }

        try {
            String idStr = pathInfo.substring(1);
            int bookId = Integer.parseInt(idStr);

            BookDAO bookDAO = new BookDAO();
            try {
                Book book = bookDAO.getBookById(bookId);
                if (book == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sách không tồn tại");
                    return;
                }

                request.setAttribute("book", book);
                request.setAttribute("pageTitle", "Cập nhật file nội dung - " + book.getTitle());

                RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/books/upload.jsp");
                dispatcher.forward(request, response);
            } finally {
                bookDAO.close();
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sách không hợp lệ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!AuthUtil.canManageBooks(request)) {
            handleUnauthorized(request, response);
            return;
        }

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID sách");
            return;
        }

        try {
            String idStr = pathInfo.substring(1);
            int bookId = Integer.parseInt(idStr);

            Part filePart = request.getPart("contentFile");
            if (filePart == null || filePart.getSize() == 0) {
                setErrorAndForward(request, response, bookId, "Vui lòng chọn file để upload");
                return;
            }

            String submittedFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            if (submittedFileName.isEmpty()) {
                setErrorAndForward(request, response, bookId, "Tên file không hợp lệ");
                return;
            }

            // Simple content type validation (optional)
            String contentType = filePart.getContentType();
            LOGGER.info("Uploading file for book " + bookId + " - name=" + submittedFileName + ", type=" + contentType);

            // Determine upload directory (inside webapp /uploads/books)
            String uploadsDirPath = getServletContext().getRealPath("/uploads/books");
            if (uploadsDirPath == null) {
                uploadsDirPath = getServletContext().getRealPath("/") + File.separator + "uploads" + File.separator + "books";
            }
            Files.createDirectories(Paths.get(uploadsDirPath));

            // Create unique file name to avoid conflicts
            String fileExtension = "";
            int dotIndex = submittedFileName.lastIndexOf('.');
            if (dotIndex >= 0) {
                fileExtension = submittedFileName.substring(dotIndex);
            }
            String baseName = dotIndex > 0 ? submittedFileName.substring(0, dotIndex) : submittedFileName;
            String safeBaseName = baseName.replaceAll("[^a-zA-Z0-9-_]", "_");
            String uniqueFileName = "book_" + bookId + "_" + System.currentTimeMillis() + "_" + safeBaseName + fileExtension;

            File outFile = new File(uploadsDirPath, uniqueFileName);

            try (InputStream input = filePart.getInputStream();
                 FileOutputStream output = new FileOutputStream(outFile)) {
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }

            // Store relative path in DB (to be used with context path in views)
            String relativePath = "/uploads/books/" + uniqueFileName;

            BookDAO bookDAO = new BookDAO();
            try {
                if (bookDAO.updateBookContentPath(bookId, relativePath)) {
                    response.sendRedirect(request.getContextPath() + "/books/detail/" + bookId);
                } else {
                    setErrorAndForward(request, response, bookId, "Không thể cập nhật đường dẫn file. Vui lòng thử lại.");
                }
            } finally {
                bookDAO.close();
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID sách không hợp lệ");
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error saving uploaded file", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi lưu file");
        }
    }

    private void setErrorAndForward(HttpServletRequest request, HttpServletResponse response, int bookId, String errorMessage)
            throws ServletException, IOException {

        BookDAO bookDAO = new BookDAO();
        try {
            Book book = bookDAO.getBookById(bookId);
            if (book == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Sách không tồn tại");
                return;
            }

            request.setAttribute("book", book);
            request.setAttribute("error", errorMessage);
            request.setAttribute("pageTitle", "Cập nhật file nội dung - " + book.getTitle());

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/jsp/books/upload.jsp");
            dispatcher.forward(request, response);
        } finally {
            bookDAO.close();
        }
    }

    private void handleUnauthorized(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("error", "Bạn không có quyền cập nhật file nội dung sách. Chỉ Librarian/Seller mới có thể thực hiện thao tác này.");
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

