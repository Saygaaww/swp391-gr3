package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.MockDataService;

import java.io.IOException;

/** Servlet điều hướng các trang mock. Mỗi URL khai báo trong web.xml (/pages/register, /pages/browse, ...). JSP trong WEB-INF/app/. */
public class AppServlet extends HttpServlet {

    private static final String APP_JSP = "/WEB-INF/app/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String servletPath = request.getServletPath();
            String page = (servletPath != null && servletPath.startsWith("/pages/"))
                    ? servletPath.substring("/pages/".length()).replace("/", "")
                    : "browse";
            if (page.isEmpty()) page = "browse";
            int readerId = 1;
            request.setAttribute("readerId", readerId);

            switch (page) {
            case "register":
                request.setAttribute("roles", MockDataService.getRoles());
                request.getRequestDispatcher(APP_JSP + "register.jsp").forward(request, response);
                return;
            case "forgot-password":
                request.getRequestDispatcher(APP_JSP + "forgot-password.jsp").forward(request, response);
                return;
            case "browse":
                request.setAttribute("books", MockDataService.getBooks());
                request.setAttribute("categories", MockDataService.getCategories());
                request.setAttribute("authors", MockDataService.getAuthors());
                request.getRequestDispatcher(APP_JSP + "browse.jsp").forward(request, response);
                return;
            case "my-library":
                request.setAttribute("ownedBooks", MockDataService.getOwnedBooks(readerId));
                request.getRequestDispatcher(APP_JSP + "my-library.jsp").forward(request, response);
                return;
            case "edit-profile":
                request.setAttribute("reader", MockDataService.getCurrentReader());
                request.getRequestDispatcher(APP_JSP + "edit-profile.jsp").forward(request, response);
                return;
            case "change-password":
                request.getRequestDispatcher(APP_JSP + "change-password.jsp").forward(request, response);
                return;
            case "linked-accounts":
                request.setAttribute("linkedAccounts", MockDataService.getLinkedAccounts(readerId));
                request.getRequestDispatcher(APP_JSP + "linked-accounts.jsp").forward(request, response);
                return;
            case "reading-history":
                request.setAttribute("readingHistories", MockDataService.getReadingHistories(readerId));
                request.getRequestDispatcher(APP_JSP + "reading-history.jsp").forward(request, response);
                return;
            case "bookmarks":
                request.setAttribute("bookmarks", MockDataService.getBookmarks(readerId));
                request.getRequestDispatcher(APP_JSP + "bookmarks.jsp").forward(request, response);
                return;
            case "reviews":
                request.setAttribute("reviews", MockDataService.getAllReviews());
                request.setAttribute("books", MockDataService.getBooks());
                request.getRequestDispatcher(APP_JSP + "reviews.jsp").forward(request, response);
                return;
            case "notifications":
                request.setAttribute("notifications", MockDataService.getNotifications(readerId));
                request.getRequestDispatcher(APP_JSP + "notifications.jsp").forward(request, response);
                return;
            case "cart":
                request.setAttribute("cart", MockDataService.getCart(readerId));
                request.getRequestDispatcher(APP_JSP + "cart.jsp").forward(request, response);
                return;
            case "order-history":
                request.setAttribute("orders", MockDataService.getOrders(readerId));
                request.getRequestDispatcher(APP_JSP + "order-history.jsp").forward(request, response);
                return;
            case "borrow-request":
                request.setAttribute("books", MockDataService.getBooks());
                request.setAttribute("borrowRequests", MockDataService.getBorrowRequests());
                request.getRequestDispatcher(APP_JSP + "borrow-request.jsp").forward(request, response);
                return;
            case "borrow-status":
                request.setAttribute("borrowRequests", MockDataService.getBorrowRequests());
                request.getRequestDispatcher(APP_JSP + "borrow-status.jsp").forward(request, response);
                return;
            case "borrowed-items":
                request.setAttribute("borrows", MockDataService.getBorrows(readerId));
                request.setAttribute("borrowItems", MockDataService.getBorrowItems(1));
                request.getRequestDispatcher(APP_JSP + "borrowed-items.jsp").forward(request, response);
                return;
            case "extend-request":
                request.setAttribute("borrowExtends", MockDataService.getBorrowExtends());
                request.getRequestDispatcher(APP_JSP + "extend-request.jsp").forward(request, response);
                return;
            case "reservation":
                request.setAttribute("reservations", MockDataService.getReservations());
                request.setAttribute("books", MockDataService.getBooks());
                request.getRequestDispatcher(APP_JSP + "reservation.jsp").forward(request, response);
                return;
            case "fine-summary":
                request.setAttribute("fines", MockDataService.getFines(readerId));
                request.setAttribute("fineTypes", MockDataService.getFineTypes());
                request.getRequestDispatcher(APP_JSP + "fine-summary.jsp").forward(request, response);
                return;
            case "pay-fine":
                request.setAttribute("fines", MockDataService.getFines(readerId));
                request.getRequestDispatcher(APP_JSP + "pay-fine.jsp").forward(request, response);
                return;
            case "admin-readers":
                request.setAttribute("readers", MockDataService.getReaders());
                request.getRequestDispatcher(APP_JSP + "admin-readers.jsp").forward(request, response);
                return;
            case "admin-employees":
                request.setAttribute("employees", MockDataService.getEmployees());
                request.setAttribute("roles", MockDataService.getRoles());
                request.getRequestDispatcher(APP_JSP + "admin-employees.jsp").forward(request, response);
                return;
            case "admin-authors":
                request.setAttribute("authors", MockDataService.getAuthors());
                request.getRequestDispatcher(APP_JSP + "admin-authors.jsp").forward(request, response);
                return;
            case "admin-categories":
                request.setAttribute("categories", MockDataService.getCategories());
                request.getRequestDispatcher(APP_JSP + "admin-categories.jsp").forward(request, response);
                return;
            case "admin-books":
                request.setAttribute("books", MockDataService.getBooks());
                request.setAttribute("categories", MockDataService.getCategories());
                request.setAttribute("authors", MockDataService.getAuthors());
                request.getRequestDispatcher(APP_JSP + "admin-books.jsp").forward(request, response);
                return;
            case "admin-book-copies":
                request.setAttribute("bookCopies", MockDataService.getBookCopies());
                request.setAttribute("books", MockDataService.getBooks());
                request.getRequestDispatcher(APP_JSP + "admin-book-copies.jsp").forward(request, response);
                return;
            case "admin-borrow-requests":
                request.setAttribute("borrowRequests", MockDataService.getBorrowRequests());
                request.getRequestDispatcher(APP_JSP + "admin-borrow-requests.jsp").forward(request, response);
                return;
            case "admin-active-borrows":
                request.setAttribute("activeBorrows", MockDataService.getActiveBorrows());
                request.getRequestDispatcher(APP_JSP + "admin-active-borrows.jsp").forward(request, response);
                return;
            case "admin-fine-types":
                request.setAttribute("fineTypes", MockDataService.getFineTypes());
                request.getRequestDispatcher(APP_JSP + "admin-fine-types.jsp").forward(request, response);
                return;
            case "admin-fines":
                request.setAttribute("fines", MockDataService.getAllFines());
                request.getRequestDispatcher(APP_JSP + "admin-fines.jsp").forward(request, response);
                return;
            case "admin-orders":
                request.setAttribute("orders", MockDataService.getAllOrders());
                request.getRequestDispatcher(APP_JSP + "admin-orders.jsp").forward(request, response);
                return;
            case "admin-payments":
                request.setAttribute("payments", MockDataService.getPayments());
                request.getRequestDispatcher(APP_JSP + "admin-payments.jsp").forward(request, response);
                return;
            case "admin-reviews":
                request.setAttribute("reviews", MockDataService.getAllReviews());
                request.getRequestDispatcher(APP_JSP + "admin-reviews.jsp").forward(request, response);
                return;
            default:
                request.setAttribute("books", MockDataService.getBooks());
                request.setAttribute("categories", MockDataService.getCategories());
                request.getRequestDispatcher(APP_JSP + "browse.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            String msg = e.getMessage();
            if (e.getCause() != null && e.getCause().getMessage() != null) {
                msg = msg + " | Nguyên nhân: " + e.getCause().getMessage();
            }
            request.setAttribute("error", msg != null ? msg : e.getClass().getName());
            try {
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            } catch (Exception ex) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi: " + (msg != null ? msg : "Internal error"));
            }
        }
    }
}
