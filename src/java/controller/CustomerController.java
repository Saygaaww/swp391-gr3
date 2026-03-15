package controller;

import dao.BookDAO;
import dao.CartDAO;
import dao.ReviewDAO;
import dao.ReaderBookOwnershipDAO;
import dal.BorrowDAO;
import dal.FineDAO;
import dal.ReservationDAO;
import model.Book;
import model.BorrowRequest;
import model.BorrowRequestItem;
import model.BorrowedItemView;
import model.BorrowExtendView;
import model.Cart;
import model.CartItem;
import model.FineView;
import model.Reservation;
import model.ReadingHistory;
import dao.ReadingHistoryDAO;
import dao.BookmarkDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.OrderDAO;
import dao.PaymentDAO;
import model.Order;
import util.AuthUtil;
import util.VNPayUtil;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CustomerController", urlPatterns = { "/customer", "/customer/*" })
public class CustomerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String pathInfo = request.getPathInfo();

        boolean loggedIn = AuthUtil.isLoggedIn(request);
        boolean isReader = AuthUtil.isReader(request);
        if (!loggedIn || !isReader) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        try {
            switch (pathInfo) {
                case "/cart":
                    handleViewCart(request, response);
                    break;
                case "/reviews":
                    handleViewReviews(request, response);
                    break;
                case "/checkout":
                    handleViewCheckout(request, response);
                    break;
                case "/orders":
                    handleOrderHistory(request, response);
                    break;
                case "/order-detail":
                    handleOrderDetail(request, response);
                    break;
                case "/my-library":
                    handleMyLibrary(request, response);
                    break;
                case "/vnpay-return":
                    handleVNPayReturn(request, response);
                    break;
                case "/read":
                    handleReadBook(request, response);
                    break;
                case "/reading-history":
                    handleReadingHistory(request, response);
                    break;
                case "/bookmarks":
                    handleBookmarks(request, response);
                    break;
                case "/add-to-cart":
                    handleAddToCart(request, response);
                    break;
                case "/borrow-request":
                    handleBorrowRequestPage(request, response);
                    break;
                case "/borrow-request-status":
                    handleBorrowRequestsStatus(request, response);
                    break;
                case "/borrowed-items":
                    handleBorrowedItems(request, response);
                    break;
                case "/extend-requests":
                    handleExtendRequests(request, response);
                    break;
                case "/reservations":
                    handleReservations(request, response);
                    break;
                case "/fines":
                    handleFines(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String pathInfo = request.getPathInfo();

        if (!AuthUtil.isLoggedIn(request) || !AuthUtil.isReader(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        try {
            if (pathInfo != null) {
                switch (pathInfo) {
                    case "/cart/add":
                        handleAddToCart(request, response);
                        break;
                    case "/cart/update":
                        handleUpdateCart(request, response, "update");
                        break;
                    case "/cart/remove":
                        handleUpdateCart(request, response, "remove");
                        break;
                    case "/reviews":
                        handleSubmitReview(request, response);
                        break;
                    case "/checkout":
                        handleProcessCheckout(request, response);
                        break;
                    case "/read":
                    case "/reading-history":
                        handleSaveReadProgress(request, response);
                        break;
                    case "/bookmarks":
                        handleSaveBookmarks(request, response);
                        break;
                    case "/borrow-request":
                        handleCreateBorrowRequest(request, response);
                        break;
                    case "/extend-borrow":
                        handleCreateExtendRequest(request, response);
                        break;
                    case "/return-request":
                        handleReturnRequest(request, response);
                        break;
                    case "/reservations":
                        handleCreateOrCancelReservation(request, response);
                        break;
                    case "/fines/pay":
                        handlePayFine(request, response);
                        break;
                    default:
                        response.sendError(HttpServletResponse.SC_NOT_FOUND);
                        break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/cart");
        }
    }

    private void handleViewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.getOrCreateCart(readerId);
        BigDecimal cartTotal = cartDAO.getCartTotal(cart.getCartId());

        request.setAttribute("cart", cart);
        request.setAttribute("cartTotal", cartTotal);
        request.getRequestDispatcher("/jsp/customer/cart.jsp").forward(request, response);
    }

    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        int quantity = 1;
        if (request.getParameter("quantity") != null) {
            quantity = Integer.parseInt(request.getParameter("quantity"));
        }

        HttpSession session = request.getSession();
        BookDAO bookDAO = new BookDAO();
        Book book = bookDAO.getBookById(bookId);

        if (book == null || !"active".equals(book.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        int available = bookDAO.getAvailableStock(bookId);
        if (available <= 0) {
            session.setAttribute("cartError", "Sách \"" + book.getTitle() + "\" Đã hết hàng.");
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.getOrCreateCart(readerId);
        int alreadyInCart = 0;
        if (cart.getItems() != null) {
            for (CartItem item : cart.getItems()) {
                if (item.getBookId() == bookId) {
                    alreadyInCart += item.getQuantity();
                }
            }
        }

        int requestedTotal = alreadyInCart + quantity;
        if (requestedTotal > available) {
            session.setAttribute("cartError", "Sách \"" + book.getTitle() + "\" chỉ còn " + available + " cuốn.");
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }

        boolean success = cartDAO.addItemToCart(cart.getCartId(), bookId, quantity, book.getPrice());
        if (success) {
            session.setAttribute("cartMessage", "Đã thêm sách vào giỏ.");
        } else {
            session.setAttribute("cartError", "Không thể thêm vào giỏ.");
        }

        response.sendRedirect(request.getContextPath() + "/customer/cart");
    }

    private void handleUpdateCart(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        CartDAO cartDAO = new CartDAO();
        int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));

        if ("update".equals(action)) {
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            if (quantity > 0) {
                CartItem item = cartDAO.getCartItemById(cartItemId);
                if (item != null && quantity > item.getAvailableStock()) {
                    quantity = Math.max(1, item.getAvailableStock());
                }
                cartDAO.updateCartItemQuantity(cartItemId, quantity);
            }
        } else if ("remove".equals(action)) {
            cartDAO.removeItemFromCart(cartItemId);
        }

        response.sendRedirect(request.getContextPath() + "/customer/cart");
    }

    private void handleViewReviews(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        ReviewDAO dao = new ReviewDAO();
        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();

        request.setAttribute("reviews", dao.getByReader(readerId));
        request.setAttribute("ownedBooks", ownershipDAO.getByReader(readerId));
        request.getRequestDispatcher("/jsp/customer/reviews.jsp").forward(request, response);
    }

    private void handleMyLibrary(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        request.setAttribute("ownedBooks", ownershipDAO.getByReader(readerId));
        request.getRequestDispatcher("/jsp/customer/my-library.jsp").forward(request, response);
    }

    private void handleSubmitReview(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        String bookIdStr = request.getParameter("bookId");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        if (bookIdStr == null || ratingStr == null) {
            response.sendRedirect(request.getContextPath() + "/customer/reviews");
            return;
        }

        int bookId = Integer.parseInt(bookIdStr);
        int rating = Integer.parseInt(ratingStr);

        if (rating < 1 || rating > 5) {
            request.getSession().setAttribute("reviewError", "Xếp hạng phải từ 1 ?ến 5 sao.");
            response.sendRedirect(request.getContextPath() + "/customer/reviews");
            return;
        }

        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        if (!ownershipDAO.hasOwnership(readerId, bookId)) {
            request.getSession().setAttribute("reviewError", "Bạn ch? có th? ?ánh giá sách bạn ?ã s? hữu.");
            response.sendRedirect(request.getContextPath() + "/customer/reviews");
            return;
        }

        ReviewDAO dao = new ReviewDAO();
        dao.upsert(readerId, bookId, rating, comment);
        response.sendRedirect(request.getContextPath() + "/customer/reviews");
    }

    private void handleViewCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        CartDAO cartDAO = new CartDAO();
        Cart cart = cartDAO.getOrCreateCart(readerId);
        BigDecimal cartTotal = cartDAO.getCartTotal(cart.getCartId());

        if (cart.getItems() == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }

        request.setAttribute("cart", cart);
        request.setAttribute("cartTotal", cartTotal);
        request.getRequestDispatcher("/jsp/customer/checkout.jsp").forward(request, response);
    }

    private void handleProcessCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        HttpSession session = request.getSession();
        String paymentMethod = request.getParameter("paymentMethod");
        CartDAO cartDAO = new CartDAO();
        OrderDAO orderDAO = new OrderDAO();

        Cart cart = cartDAO.getOrCreateCart(readerId);
        BigDecimal cartTotal = cartDAO.getCartTotal(cart.getCartId());

        if (cart.getItems() == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }

        BookDAO bookDAO = new BookDAO();
        StringBuilder stockError = new StringBuilder();
        for (CartItem item : cart.getItems()) {
            int available = bookDAO.getAvailableStock(item.getBookId());
            if (item.getQuantity() > available) {
                stockError.append(item.getBookTitle()).append(" ch? còn ").append(available).append(" cu?n. ");
            }
        }
        if (stockError.length() > 0) {
            session.setAttribute("cartError", "Không ?ủ hàng: " + stockError);
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }

        if ("vnpay".equals(paymentMethod)) {
            String txnRef = "VN" + System.currentTimeMillis() + "-" + readerId;
            session.setAttribute("pendingVnPayRef", txnRef);
            session.setAttribute("pendingVnPayReaderId", readerId);
            try {
                String returnUrl = request.getScheme() + "://" + request.getServerName()
                        + (request.getServerPort() == 80 || request.getServerPort() == 443 ? ""
                                : ":" + request.getServerPort())
                        + request.getContextPath() + "/customer/vnpay-return";
                long amountVnd = cartTotal.longValue(); // cartTotal đã là VND
                String orderInfo = "Thanh toan gio hang " + txnRef;
                String ipAddr = request.getRemoteAddr();
                String vnpayUrl = VNPayUtil.createPaymentUrl(amountVnd, txnRef, orderInfo, returnUrl, ipAddr);
                response.sendRedirect(vnpayUrl);
            } catch (Exception e) {
                e.printStackTrace();
                session.removeAttribute("pendingVnPayRef");
                session.removeAttribute("pendingVnPayReaderId");
                session.setAttribute("cartError", "L?i VNPay: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/customer/cart");
            }
            return;
        }

        // COD logic
        int orderId = orderDAO.createOrder(readerId, cartTotal, "VND");
        if (orderId <= 0) {
            session.setAttribute("cartError", "Tạo ?ơn hàng thất bại. Thử lại.");
            response.sendRedirect(request.getContextPath() + "/customer/cart");
            return;
        }
        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        for (CartItem item : cart.getItems()) {
            orderDAO.addOrderBook(orderId, item.getBookId(), item.getUnitPrice(), item.getQuantity());
            bookDAO.reduceStock(item.getBookId(), item.getQuantity());
            if (!ownershipDAO.hasOwnership(readerId, item.getBookId())) {
                ownershipDAO.grant(readerId, item.getBookId(), "order");
            }
        }
        cartDAO.clearCart(cart.getCartId());
        cartDAO.updateCartStatus(cart.getCartId(), "checked_out");
        session.setAttribute("successMessage", "??ặt hàng thành công. Mã ?ơn: " + orderId);
        response.sendRedirect(request.getContextPath() + "/customer/orders");
    }

    private void handleOrderHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        OrderDAO orderDAO = new OrderDAO();
        java.util.List<Order> orders = orderDAO.getOrdersByReader(readerId);
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/jsp/customer/orders.jsp").forward(request, response);
    }

    private void handleOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        String idParam = request.getParameter("orderId");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/customer/orders");
            return;
        }
        int orderId = Integer.parseInt(idParam);
        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.getOrderById(orderId);

        if (order == null || order.getReaderId() != readerId) {
            request.getSession().setAttribute("error", "??ơn hàng không t?n tại hoặc không có quy??n truy cập.");
            response.sendRedirect(request.getContextPath() + "/customer/orders");
            return;
        }

        PaymentDAO paymentDAO = new PaymentDAO();
        request.setAttribute("order", order);
        request.setAttribute("payment", paymentDAO.getByOrderId(orderId));
        request.getRequestDispatcher("/jsp/customer/order-detail.jsp").forward(request, response);
    }

    private void handleVNPayReturn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!VNPayUtil.verifyReturn(request)) {
            request.setAttribute("message", "Chữ ký không hợp l?.");
            request.setAttribute("success", false);
            request.getRequestDispatcher("/jsp/vnpay-result.jsp").forward(request, response);
            return;
        }

        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");

        HttpSession session = request.getSession();
        String pendingRef = (String) session.getAttribute("pendingVnPayRef");
        Integer pendingReaderId = (Integer) session.getAttribute("pendingVnPayReaderId");

        session.removeAttribute("pendingVnPayRef");
        session.removeAttribute("pendingVnPayReaderId");

        if ("00".equals(vnp_ResponseCode) && vnp_TxnRef != null && vnp_TxnRef.equals(pendingRef)
                && pendingReaderId != null) {
            CartDAO cartDAO = new CartDAO();
            Cart cart = cartDAO.getOrCreateCart(pendingReaderId);
            if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
                request.setAttribute("message", "Gi?? hàng không còn hoặc ?ã hết. Vui lòng ki?m tra ?ơn hàng.");
                request.setAttribute("success", false);
                request.getRequestDispatcher("/jsp/vnpay-result.jsp").forward(request, response);
                return;
            }
            BigDecimal cartTotal = cartDAO.getCartTotal(cart.getCartId());
            BookDAO bookDAO = new BookDAO();
            StringBuilder stockError = new StringBuilder();
            for (CartItem item : cart.getItems()) {
                int available = bookDAO.getAvailableStock(item.getBookId());
                if (item.getQuantity() > available) {
                    stockError.append(item.getBookTitle()).append(" ch? còn ").append(available).append(" cu?n. ");
                }
            }
            if (stockError.length() > 0) {
                request.setAttribute("message", "Không ?ủ hàng: " + stockError + " ??ơn chưa tạo. Gi?? hàng vẫn giữ.");
                request.setAttribute("success", false);
                request.getRequestDispatcher("/jsp/vnpay-result.jsp").forward(request, response);
                return;
            }

            OrderDAO orderDAO = new OrderDAO();
            int orderId = orderDAO.createOrder(pendingReaderId, cartTotal, "VND");
            if (orderId <= 0) {
                request.setAttribute("message", "Tạo ?ơn hàng thất bại. Liên h? h? trợ. Gi?? hàng vẫn giữ.");
                request.setAttribute("success", false);
                request.getRequestDispatcher("/jsp/vnpay-result.jsp").forward(request, response);
                return;
            }

            int orderIdToUse = orderId; // Fix capturing non-final variable in logging if needed
            ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
            for (CartItem item : cart.getItems()) {
                orderDAO.addOrderBook(orderIdToUse, item.getBookId(), item.getUnitPrice(), item.getQuantity());
                bookDAO.reduceStock(item.getBookId(), item.getQuantity());
                if (!ownershipDAO.hasOwnership(pendingReaderId, item.getBookId())) {
                    ownershipDAO.grant(pendingReaderId, item.getBookId(), "order");
                }
            }
            cartDAO.clearCart(cart.getCartId());
            cartDAO.updateCartStatus(cart.getCartId(), "checked_out");
            PaymentDAO paymentDAO = new PaymentDAO();
            paymentDAO.createPayment(orderIdToUse, cartTotal, "VNPAY", vnp_TransactionNo);
            paymentDAO.updatePaymentStatus(orderIdToUse, "success", vnp_TransactionNo);
            orderDAO.updateOrderStatus(orderIdToUse, "paid");

        request.setAttribute("message",
                "Thanh toán thành công. Mã giao d?ch: " + vnp_TransactionNo + ". Mã ?ơn: " + orderIdToUse);
        request.setAttribute("success", true);
        request.setAttribute("orderId", orderIdToUse);
        } else {
            request.setAttribute("message",
                    "Thanh toán thất bại hoặc ?ã hủy. Mã l?i: " + vnp_ResponseCode + ". Gi?? hàng vẫn giữ nguyên.");
            request.setAttribute("success", false);
            request.setAttribute("orderId", vnp_TxnRef);
        }

        request.getRequestDispatcher("/jsp/vnpay-result.jsp").forward(request, response);
    }

    private void handleReadBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        String bookIdStr = request.getParameter("bookId");
        if (bookIdStr == null || bookIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer");
            return;
        }
        int bookId = Integer.parseInt(bookIdStr);
        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        Object book = ownershipDAO.getByReaderAndBook(readerId, bookId);

        // Nếu chưa sở hữu sách, tự cấp quyền sở hữu nếu sách miễn phí (price null hoặc = 0)
        if (book == null) {
            BookDAO bookDAO = new BookDAO();
            Book rawBook = bookDAO.getBookById(bookId);
            if (rawBook == null) {
                response.sendRedirect(request.getContextPath() + "/customer");
                return;
            }
            boolean isFree = rawBook.getPrice() == null
                    || (rawBook.getPrice() != null && rawBook.getPrice().compareTo(BigDecimal.ZERO) <= 0);
            if (isFree) {
                // acquired_via = 'free' để phân biệt với mua qua đơn hàng
                // Chỉ grant nếu chưa có bản ghi ownership để tránh trùng nhiều dòng
                if (!ownershipDAO.hasOwnership(readerId, bookId)) {
                    ownershipDAO.grant(readerId, bookId, "free");
                }
                book = ownershipDAO.getByReaderAndBook(readerId, bookId);
            }
            if (book == null) {
                response.sendRedirect(request.getContextPath() + "/customer");
                return;
            }
        }
        ReadingHistoryDAO historyDAO = new ReadingHistoryDAO();
        java.util.List<ReadingHistory> list = historyDAO.getByReader(readerId);
        ReadingHistory current = null;
        for (ReadingHistory h : list) {
            if (h.getBookId() == bookId) {
                current = h;
                break;
            }
        }
        request.setAttribute("book", book);
        request.setAttribute("lastPosition",
                current != null && current.getLastReadPosition() != null ? current.getLastReadPosition() : 1);
        request.getRequestDispatcher("/jsp/customer/read.jsp").forward(request, response);
    }

    private void handleReadingHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        ReadingHistoryDAO dao = new ReadingHistoryDAO();
        java.util.List<ReadingHistory> history = dao.getByReader(readerId);
        request.setAttribute("historyList", history);
        request.getRequestDispatcher("/jsp/customer/reading-history.jsp").forward(request, response);
    }

    private void handleSaveReadProgress(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        String bookIdStr = request.getParameter("bookId");
        String positionStr = request.getParameter("position");
        String pathInfo = request.getPathInfo();

        if (bookIdStr == null || bookIdStr.trim().isEmpty() || positionStr == null || positionStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/reading-history");
            return;
        }
        int bookId = Integer.parseInt(bookIdStr);
        int position = Integer.parseInt(positionStr);
        if (position < 0)
            position = 0;

        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        if (!ownershipDAO.hasOwnership(readerId, bookId)) {
            response.sendRedirect(request.getContextPath() + "/customer/reading-history");
            return;
        }

        ReadingHistoryDAO dao = new ReadingHistoryDAO();
        dao.upsert(readerId, bookId, position);

        if ("/read".equals(pathInfo)) {
            response.sendRedirect(request.getContextPath() + "/customer/read?bookId=" + bookId);
        } else {
            response.sendRedirect(request.getContextPath() + "/customer/reading-history");
        }
    }

    private void handleBookmarks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        BookmarkDAO dao = new BookmarkDAO();
        ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
        request.setAttribute("bookmarks", dao.getByReader(readerId));
        request.setAttribute("ownedBooks", ownershipDAO.getByReader(readerId));
        request.getRequestDispatcher("/jsp/customer/bookmarks.jsp").forward(request, response);
    }

    private void handleSaveBookmarks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        String action = request.getParameter("action");
        BookmarkDAO dao = new BookmarkDAO();

        if ("delete".equals(action)) {
            String idStr = request.getParameter("bookmarkId");
            if (idStr != null) {
                dao.delete(Integer.parseInt(idStr), readerId);
            }
            response.sendRedirect(request.getContextPath() + "/customer/bookmarks");
            return;
        }

        if ("create".equals(action) || "update".equals(action)) {
            String bookIdStr = request.getParameter("bookId");
            String pageStr = request.getParameter("pageNumber");
            String note = request.getParameter("note");
            if (bookIdStr == null || bookIdStr.trim().isEmpty() || pageStr == null || pageStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/customer/bookmarks");
                return;
            }
            int bookId = Integer.parseInt(bookIdStr);
            int page = Integer.parseInt(pageStr);
            if (page < 1) {
                request.getSession().setAttribute("bookmarkError", "S? trang phải >= 1.");
                response.sendRedirect(request.getContextPath() + "/customer/bookmarks");
                return;
            }
            ReaderBookOwnershipDAO ownershipDAO = new ReaderBookOwnershipDAO();
            if (!ownershipDAO.hasOwnership(readerId, bookId)) {
                request.getSession().setAttribute("bookmarkError", "Bạn ch? có th? ?ánh dấu sách bạn ?ã s? hữu.");
                response.sendRedirect(request.getContextPath() + "/customer/bookmarks");
                return;
            }
            if ("update".equals(action)) {
                String bookmarkIdStr = request.getParameter("bookmarkId");
                if (bookmarkIdStr != null) {
                    dao.update(Integer.parseInt(bookmarkIdStr), readerId, page, note);
                }
            } else {
                dao.create(readerId, bookId, page, note);
            }
        }
        response.sendRedirect(request.getContextPath() + "/customer/bookmarks");
    }

    // =========================
    // Borrowing / Reservations / Fines (Reader)
    // =========================

    private void handleBorrowRequestPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookIdStr = request.getParameter("bookId");
        Book book = null;
        if (bookIdStr != null && !bookIdStr.trim().isEmpty()) {
            try {
                int bookId = Integer.parseInt(bookIdStr);
                BookDAO bookDAO = new BookDAO();
                book = bookDAO.getBookById(bookId);
            } catch (NumberFormatException ignore) {
            }
        }
        request.setAttribute("book", book);
        request.getRequestDispatcher("/jsp/customer/borrow-request.jsp").forward(request, response);
    }

    private void handleCreateBorrowRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        String bookIdStr = request.getParameter("bookId");
        String quantityStr = request.getParameter("quantity");
        String note = request.getParameter("note");

        if (bookIdStr == null || bookIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        int bookId;
        int quantity = 1;
        try {
            bookId = Integer.parseInt(bookIdStr);
            if (quantityStr != null && !quantityStr.isBlank()) {
                quantity = Integer.parseInt(quantityStr);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }
        if (quantity < 1)
            quantity = 1;
        if (quantity > 5)
            quantity = 5;

        BorrowRequestItem item = new BorrowRequestItem();
        item.setBookId(bookId);
        item.setQuantity(quantity);
        List<BorrowRequestItem> items = new ArrayList<>();
        items.add(item);

        BorrowDAO borrowDAO = new BorrowDAO();
        int requestId = borrowDAO.createBorrowRequest(readerId, note, items);
        if (requestId > 0) {
            request.getSession().setAttribute("successMessage", "Đã gửi yêu cầu mượn. Mã yêu cầu: #" + requestId);
            response.sendRedirect(request.getContextPath() + "/customer/borrow-requests");
        } else {
            request.getSession().setAttribute("errorMessage", "Không thể tạo yêu cầu mượn. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/customer/borrow-request?bookId=" + bookId);
        }
    }

    private void handleBorrowRequestsStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        BorrowDAO borrowDAO = new BorrowDAO();
        List<BorrowRequest> requests = borrowDAO.getRequestsByReader(readerId);
        for (BorrowRequest r : requests) {
            r.setItems(borrowDAO.getRequestItems(r.getRequestId()));
        }
        request.setAttribute("requests", requests);
        request.getRequestDispatcher("/jsp/customer/borrow-requests.jsp").forward(request, response);
    }

    private void handleBorrowedItems(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        BorrowDAO borrowDAO = new BorrowDAO();
        List<BorrowedItemView> items = borrowDAO.getActiveBorrowedItemsByReader(readerId);
        request.setAttribute("items", items);
        request.getRequestDispatcher("/jsp/customer/borrowed-items.jsp").forward(request, response);
    }

    private void handleReturnRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        String borrowItemIdStr = request.getParameter("borrowItemId");
        if (borrowItemIdStr == null || borrowItemIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/customer/borrowed-items");
            return;
        }
        try {
            int borrowItemId = Integer.parseInt(borrowItemIdStr);
            BorrowDAO borrowDAO = new BorrowDAO();
            boolean ok = borrowDAO.requestReturn(readerId, borrowItemId);
            request.getSession().setAttribute(ok ? "successMessage" : "errorMessage",
                    ok ? "Đã gửi yêu cầu trả sách." : "Không thể gửi yêu cầu trả sách.");
        } catch (NumberFormatException ignore) {
        }
        response.sendRedirect(request.getContextPath() + "/customer/borrowed-items");
    }

    private void handleCreateExtendRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        String borrowItemIdStr = request.getParameter("borrowItemId");
        String extendDaysStr = request.getParameter("extendDays");
        String note = request.getParameter("note");

        if (borrowItemIdStr == null || borrowItemIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/customer/borrowed-items");
            return;
        }

        try {
            int borrowItemId = Integer.parseInt(borrowItemIdStr);
            int extendDays = 7;
            if (extendDaysStr != null && !extendDaysStr.isBlank()) {
                extendDays = Integer.parseInt(extendDaysStr);
            }
            BorrowDAO borrowDAO = new BorrowDAO();
            boolean ok = borrowDAO.createExtendRequest(readerId, borrowItemId, extendDays, note);
            request.getSession().setAttribute(ok ? "successMessage" : "errorMessage",
                    ok ? "Đã gửi yêu cầu gia hạn." : "Không thể gửi yêu cầu gia hạn.");
        } catch (NumberFormatException ignore) {
        }
        response.sendRedirect(request.getContextPath() + "/customer/extend-requests");
    }

    private void handleExtendRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        BorrowDAO borrowDAO = new BorrowDAO();
        List<BorrowExtendView> list = borrowDAO.getExtendRequestsByReader(readerId);
        request.setAttribute("extendRequests", list);
        request.getRequestDispatcher("/jsp/customer/extend-requests.jsp").forward(request, response);
    }

    private void handleReservations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        ReservationDAO dao = new ReservationDAO();
        List<Reservation> list = dao.getReservationsByReader(readerId);
        request.setAttribute("reservations", list);
        request.getRequestDispatcher("/jsp/customer/reservations.jsp").forward(request, response);
    }

    private void handleCreateOrCancelReservation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        String action = request.getParameter("action");
        ReservationDAO dao = new ReservationDAO();
        boolean ok = false;

        if ("create".equals(action)) {
            String bookIdStr = request.getParameter("bookId");
            if (bookIdStr != null && !bookIdStr.isBlank()) {
                try {
                    ok = dao.createReservation(readerId, Integer.parseInt(bookIdStr));
                } catch (NumberFormatException ignore) {
                }
            }
        } else if ("cancel".equals(action)) {
            String reservationIdStr = request.getParameter("reservationId");
            if (reservationIdStr != null && !reservationIdStr.isBlank()) {
                try {
                    ok = dao.cancelReservation(readerId, Integer.parseInt(reservationIdStr));
                } catch (NumberFormatException ignore) {
                }
            }
        }

        request.getSession().setAttribute(ok ? "successMessage" : "errorMessage",
                ok ? "Thao tác đặt chỗ thành công." : "Không thể thực hiện đặt chỗ.");
        response.sendRedirect(request.getContextPath() + "/customer/reservations");
    }

    private void handleFines(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        FineDAO dao = new FineDAO();
        List<FineView> fines = dao.getFinesByReader(readerId);
        request.setAttribute("fines", fines);
        request.getRequestDispatcher("/jsp/customer/fines.jsp").forward(request, response);
    }

    private void handlePayFine(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = AuthUtil.getReaderId(request);
        String fineIdStr = request.getParameter("fineId");
        if (fineIdStr == null || fineIdStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/customer/fines");
            return;
        }
        boolean ok = false;
        try {
            int fineId = Integer.parseInt(fineIdStr);
            FineDAO dao = new FineDAO();
            ok = dao.markFinePaid(readerId, fineId);
        } catch (NumberFormatException ignore) {
        }
        request.getSession().setAttribute(ok ? "successMessage" : "errorMessage",
                ok ? "Đã ghi nhận thanh toán tiền phạt." : "Không thể thanh toán tiền phạt.");
        response.sendRedirect(request.getContextPath() + "/customer/fines");
    }
}
