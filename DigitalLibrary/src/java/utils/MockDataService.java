package utils;

import model.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

/**
 * Mock data for all screens. Use only in-memory data to avoid DB errors.
 */
public final class MockDataService {

    private static final List<Role> ROLES = new ArrayList<>();
    private static final List<Author> AUTHORS = new ArrayList<>();
    private static final List<Category> CATEGORIES = new ArrayList<>();
    private static final List<Book> BOOKS = new ArrayList<>();
    private static final List<Reader> READERS = new ArrayList<>();
    private static final List<Employee> EMPLOYEES = new ArrayList<>();
    private static final List<ReaderAccount> READER_ACCOUNTS = new ArrayList<>();
    private static final List<ReaderBookOwnership> OWNERSHIPS = new ArrayList<>();
    private static final List<Order> ORDERS = new ArrayList<>();
    private static final List<OrderBook> ORDER_BOOKS = new ArrayList<>();
    private static final List<Payment> PAYMENTS = new ArrayList<>();
    private static final List<Cart> CARTS = new ArrayList<>();
    private static final List<CartItem> CART_ITEMS = new ArrayList<>();
    private static final List<BorrowRequest> BORROW_REQUESTS = new ArrayList<>();
    private static final List<BorrowRequestItem> BORROW_REQUEST_ITEMS = new ArrayList<>();
    private static final List<Borrow> BORROWS = new ArrayList<>();
    private static final List<BorrowItem> BORROW_ITEMS = new ArrayList<>();
    private static final List<BorrowExtend> BORROW_EXTENDS = new ArrayList<>();
    private static final List<BookCopy> BOOK_COPIES = new ArrayList<>();
    private static final List<Reservation> RESERVATIONS = new ArrayList<>();
    private static final List<FineType> FINE_TYPES = new ArrayList<>();
    private static final List<Fine> FINES = new ArrayList<>();
    private static final List<ReadingHistory> READING_HISTORIES = new ArrayList<>();
    private static final List<Bookmark> BOOKMARKS = new ArrayList<>();
    private static final List<Review> REVIEWS = new ArrayList<>();
    private static final List<Notification> NOTIFICATIONS = new ArrayList<>();

    static {
        try {
            initRoles();
            initAuthors();
            initCategories();
            initBooks();
            initReaders();
            initEmployees();
            initReaderAccounts();
            initOwnerships();
            initOrders();
            initPayments();
            initCarts();
            initBorrowRequests();
            initBookCopies();
            initBorrows();
            initBorrowExtends();
            initReservations();
            initFineTypes();
            initFines();
            initReadingHistories();
            initBookmarks();
            initReviews();
            initNotifications();
        } catch (Throwable t) {
            t.printStackTrace();
            // Lists stay empty; getters return empty lists so app does not crash
        }
    }

    private static void initRoles() {
        ROLES.add(createRole(1, "ADMIN", "Quản trị hệ thống"));
        ROLES.add(createRole(2, "LIBRARIAN", "Thủ thư"));
        ROLES.add(createRole(3, "SELLER", "Nhân viên bán hàng"));
        ROLES.add(createRole(4, "USER", "Đọc giả"));
    }

    private static void initAuthors() {
        AUTHORS.add(createAuthor(1, "Nguyễn Nhật Ánh", "Nhà văn Việt Nam chuyên viết cho thiếu nhi."));
        AUTHORS.add(createAuthor(2, "Paulo Coelho", "Tác giả Nhà giả kim."));
        AUTHORS.add(createAuthor(3, "Dale Carnegie", "Tác giả Đắc nhân tâm."));
        AUTHORS.add(createAuthor(4, "James Clear", "Tác giả Atomic Habits."));
        AUTHORS.add(createAuthor(5, "Ngô Tất Tố", "Nhà văn hiện thực Việt Nam."));
    }

    private static void initCategories() {
        CATEGORIES.add(createCategory(1, "Văn học", "Tiểu thuyết, truyện ngắn"));
        CATEGORIES.add(createCategory(2, "Kinh doanh", "Sách kinh tế, khởi nghiệp"));
        CATEGORIES.add(createCategory(3, "Kỹ năng sống", "Phát triển bản thân"));
        CATEGORIES.add(createCategory(4, "Thiếu nhi", "Sách cho trẻ em"));
        CATEGORIES.add(createCategory(5, "Công nghệ", "Lập trình, IT"));
    }

    private static void initBooks() {
        Book b1 = createBook(1, "Đắc Nhân Tâm", "Nghệ thuật giao tiếp", new BigDecimal("89000"), 1, 1);
        Book b2 = createBook(2, "Nhà Giả Kim", "Hành trình tìm kho báu", new BigDecimal("75000"), 2, 1);
        Book b3 = createBook(3, "Atomic Habits", "Thay đổi nhỏ, kết quả lớn", new BigDecimal("120000"), 4, 3);
        Book b4 = createBook(4, "Kính Vạn Hoa", "Bộ truyện thiếu nhi", new BigDecimal("0"), 1, 4);
        Book b5 = createBook(5, "Tôi Tài Giỏi Bạn Cũng Thế", "Kỹ năng học tập", new BigDecimal("95000"), 3, 3);
        Book b6 = createBook(6, "Clean Code", "Lập trình sạch", new BigDecimal("150000"), 5, 5);
        for (Book b : Arrays.asList(b1, b2, b3, b4, b5, b6)) {
            b.setAuthor(AUTHORS.stream().filter(a -> a.getAuthorId() == b.getAuthorId()).findFirst().orElse(null));
            b.setCategory(CATEGORIES.stream().filter(c -> c.getCategoryId() == b.getCategoryId()).findFirst().orElse(null));
            BOOKS.add(b);
        }
    }

    private static void initReaders() {
        Reader r1 = createReader(1, "Nguyễn Văn A", "reader1@test.com", 4);
        Reader r2 = createReader(2, "Trần Thị B", "reader2@test.com", 4);
        READERS.add(r1);
        READERS.add(r2);
    }

    private static void initEmployees() {
        EMPLOYEES.add(createEmployee(1, "Admin User", "admin@lib.com", 1));
        EMPLOYEES.add(createEmployee(2, "Librarian Mai", "librarian@lib.com", 2));
        EMPLOYEES.add(createEmployee(3, "Seller Lan", "seller@lib.com", 3));
    }

    private static void initReaderAccounts() {
        READER_ACCOUNTS.add(createReaderAccount(1, 1, "local", null));
        READER_ACCOUNTS.add(createReaderAccount(2, 1, "google", "google-123"));
    }

    private static void initOwnerships() {
        ReaderBookOwnership o1 = new ReaderBookOwnership();
        o1.setOwnershipId(1);
        o1.setReaderId(1);
        o1.setBookId(1);
        o1.setAcquiredVia("order");
        o1.setStatus("active");
        o1.setAcquiredAt(LocalDateTime.now().minusDays(30));
        o1.setBook(BOOKS.get(0));
        o1.setReader(READERS.get(0));
        OWNERSHIPS.add(o1);
        ReaderBookOwnership o2 = new ReaderBookOwnership();
        o2.setOwnershipId(2);
        o2.setReaderId(1);
        o2.setBookId(4);
        o2.setAcquiredVia("order");
        o2.setStatus("active");
        o2.setAcquiredAt(LocalDateTime.now().minusDays(10));
        o2.setBook(BOOKS.get(3));
        o2.setReader(READERS.get(0));
        OWNERSHIPS.add(o2);
    }

    private static void initOrders() {
        Order ord1 = createOrder(1, 1, "paid", new BigDecimal("164000"), "VND");
        Order ord2 = createOrder(2, 1, "pending", new BigDecimal("95000"), "VND");
        ORDERS.add(ord1);
        ORDERS.add(ord2);
    }

    private static void initPayments() {
        Payment p1 = new Payment();
        p1.setPaymentId(1);
        p1.setOrderId(1);
        p1.setAmount(new BigDecimal("164000"));
        p1.setPaymentMethod("bank_transfer");
        p1.setPaymentStatus("success");
        p1.setTransactionCode("TXN-001");
        p1.setPaidAt(LocalDateTime.now().minusDays(30));
        p1.setCreatedAt(LocalDateTime.now().minusDays(30));
        PAYMENTS.add(p1);
    }

    private static void initCarts() {
        Cart c = new Cart(1);
        c.setCartId(1);
        c.setStatus("active");
        c.setReader(READERS.get(0));
        CartItem ci = new CartItem(1, 5, 1);
        ci.setCartItemId(1);
        ci.setBook(BOOKS.get(4));
        CART_ITEMS.add(ci);
        c.setItems(new ArrayList<>(CART_ITEMS));
        CARTS.add(c);
    }

    private static void initBorrowRequests() {
        BorrowRequest br = new BorrowRequest(1, "pending");
        br.setRequestId(1);
        br.setRequestedAt(LocalDateTime.now().minusDays(2));
        br.setNote("Mượn sách tham khảo");
        br.setReader(READERS.get(0));
        BORROW_REQUESTS.add(br);
        BorrowRequestItem bri = new BorrowRequestItem(1, 6, 1);
        bri.setRequestItemId(1);
        bri.setBook(BOOKS.get(5));
        BORROW_REQUEST_ITEMS.add(bri);
    }

    private static void initBorrows() {
        Borrow bor = new Borrow(1, "active");
        bor.setBorrowId(1);
        bor.setRequestId(1);
        bor.setBorrowDate(LocalDateTime.now().minusDays(5));
        bor.setCreatedAt(LocalDateTime.now().minusDays(5));
        bor.setReader(READERS.get(0));
        bor.setApprovedByEmployee(EMPLOYEES.get(1));
        BORROWS.add(bor);
        BorrowItem bi = new BorrowItem(1, 1, LocalDateTime.now().plusDays(9), "borrowed");
        bi.setBorrowItemId(1);
        if (!BOOK_COPIES.isEmpty()) {
            bi.setBookCopy(BOOK_COPIES.get(0));
        }
        BORROW_ITEMS.add(bi);
    }

    private static void initBorrowExtends() {
        BorrowExtend be = new BorrowExtend();
        be.setExtendId(1);
        be.setBorrowItemId(1);
        be.setOldDueDate(LocalDateTime.now().plusDays(5));
        be.setRequestedDueDate(LocalDateTime.now().plusDays(19));
        be.setStatus("pending");
        be.setRequestedAt(LocalDateTime.now());
        BORROW_EXTENDS.add(be);
    }

    private static void initBookCopies() {
        BookCopy bc = new BookCopy(6, "COPY-001", "borrowed");
        bc.setCopyId(1);
        bc.setCreatedAt(LocalDateTime.now().minusMonths(1));
        bc.setBook(BOOKS.get(5));
        BOOK_COPIES.add(bc);
    }

    private static void initReservations() {
        Reservation res = new Reservation();
        res.setReservationId(1);
        res.setReaderId(1);
        res.setBookId(2);
        res.setStatus("pending");
        res.setCreatedAt(LocalDateTime.now().minusDays(1));
        res.setExpiresAt(LocalDateTime.now().plusDays(6));
        res.setBook(BOOKS.get(1));
        res.setReader(READERS.get(0));
        RESERVATIONS.add(res);
    }

    private static void initFineTypes() {
        FINE_TYPES.add(createFineType(1, "late_return", "Trả trễ", new BigDecimal("5000"), new BigDecimal("5000")));
        FINE_TYPES.add(createFineType(2, "lost", "Mất sách", new BigDecimal("100000"), null));
        FINE_TYPES.add(createFineType(3, "damaged", "Hư hỏng", new BigDecimal("50000"), null));
    }

    private static void initFines() {
        Fine f = new Fine(1, 1, 1, new BigDecimal("15000"), "unpaid");
        f.setFineId(1);
        f.setReason("Trả sách trễ 3 ngày");
        f.setCreatedAt(LocalDateTime.now().minusDays(2));
        f.setReader(READERS.get(0));
        f.setFineType(FINE_TYPES.get(0));
        FINES.add(f);
    }

    private static void initReadingHistories() {
        ReadingHistory rh = new ReadingHistory(1, 1);
        rh.setHistoryId(1);
        rh.setLastReadPosition(120);
        rh.setLastReadAt(LocalDateTime.now().minusHours(2));
        rh.setBook(BOOKS.get(0));
        rh.setReader(READERS.get(0));
        READING_HISTORIES.add(rh);
    }

    private static void initBookmarks() {
        Bookmark bm = new Bookmark(1, 1, 45);
        bm.setBookmarkId(1);
        bm.setNote("Phần quan trọng");
        bm.setCreatedAt(LocalDateTime.now().minusDays(1));
        bm.setBook(BOOKS.get(0));
        bm.setReader(READERS.get(0));
        BOOKMARKS.add(bm);
    }

    private static void initReviews() {
        Review rv = new Review(1, 1, 5, "Sách rất hay, đáng đọc!");
        rv.setReviewId(1);
        rv.setCreatedAt(LocalDateTime.now().minusDays(15));
        rv.setReader(READERS.get(0));
        rv.setBook(BOOKS.get(0));
        REVIEWS.add(rv);
    }

    private static void initNotifications() {
        NOTIFICATIONS.add(createNotification(1, 1, "Nhắc trả sách", "Sách Clean Code đến hạn trả vào 10/02.", "overdue", false));
        NOTIFICATIONS.add(createNotification(2, 1, "Đơn hàng đã thanh toán", "Đơn #1 đã thanh toán thành công.", "order", true));
        NOTIFICATIONS.add(createNotification(3, 1, "Đặt chỗ sẵn sàng", "Sách Nhà Giả Kim đã có bản copy.", "reservation", false));
    }

    private static Role createRole(int id, String name, String desc) {
        Role r = new Role();
        r.setRoleId(id);
        r.setRoleName(name);
        r.setDescription(desc);
        return r;
    }

    private static Author createAuthor(int id, String name, String bio) {
        Author a = new Author(name, bio);
        a.setAuthorId(id);
        return a;
    }

    private static Category createCategory(int id, String name, String desc) {
        Category c = new Category(name, desc);
        c.setCategoryId(id);
        return c;
    }

    private static Book createBook(int id, String title, String summary, BigDecimal price, int authorId, int categoryId) {
        Book b = new Book();
        b.setBookId(id);
        b.setTitle(title);
        b.setSummary(summary);
        b.setPrice(price);
        b.setCurrency("VND");
        b.setStatus("active");
        b.setAuthorId(authorId);
        b.setCategoryId(categoryId);
        b.setTotalPages(250);
        b.setPreviewPages(20);
        b.setCreatedAt(LocalDateTime.now().minusMonths(2));
        return b;
    }

    private static Reader createReader(int id, String name, String email, int roleId) {
        Reader r = new Reader();
        r.setReaderId(id);
        r.setFullName(name);
        r.setEmail(email);
        r.setPhone("0901234567");
        r.setStatus("active");
        r.setRoleId(roleId);
        r.setRole(ROLES.get(roleId - 1));
        r.setCreatedAt(LocalDateTime.now().minusYears(1));
        return r;
    }

    private static Employee createEmployee(int id, String name, String email, int roleId) {
        Employee e = new Employee();
        e.setEmployeeId(id);
        e.setFullName(name);
        e.setEmail(email);
        e.setStatus("active");
        e.setRoleId(roleId);
        e.setRole(ROLES.get(roleId - 1));
        e.setCreatedAt(LocalDateTime.now().minusYears(1));
        return e;
    }

    private static ReaderAccount createReaderAccount(int id, int readerId, String provider, String providerUserId) {
        ReaderAccount ra = new ReaderAccount(readerId, provider, providerUserId);
        ra.setAccountId(id);
        ra.setCreatedAt(LocalDateTime.now().minusMonths(6));
        return ra;
    }

    private static Order createOrder(int id, int readerId, String status, BigDecimal total, String currency) {
        Order o = new Order(readerId, status, total, currency);
        o.setOrderId(id);
        o.setCreatedAt(LocalDateTime.now().minusDays(30));
        o.setReader(READERS.get(0));
        return o;
    }

    private static BorrowItem createBorrowItem(int id, int borrowId, int copyId, LocalDateTime due, LocalDateTime returned, String status) {
        BorrowItem bi = new BorrowItem();
        bi.setBorrowItemId(id);
        bi.setBorrowId(borrowId);
        bi.setCopyId(copyId);
        bi.setDueDate(due);
        bi.setReturnedAt(returned);
        bi.setStatus(status);
        return bi;
    }

    private static FineType createFineType(int id, String name, String desc, BigDecimal defaultAmt, BigDecimal perDay) {
        FineType ft = new FineType(name, desc, defaultAmt, perDay);
        ft.setFineTypeId(id);
        return ft;
    }

    private static Notification createNotification(int id, int readerId, String title, String message, String type, boolean read) {
        Notification n = new Notification(readerId, title, message, type);
        n.setNotificationId(id);
        n.setRead(read);
        n.setCreatedAt(LocalDateTime.now().minusDays(1));
        return n;
    }

    // --- Getters (copy to avoid mutation) ---

    public static List<Role> getRoles() {
        return new ArrayList<>(ROLES);
    }

    public static List<Author> getAuthors() {
        return new ArrayList<>(AUTHORS);
    }

    public static List<Category> getCategories() {
        return new ArrayList<>(CATEGORIES);
    }

    public static List<Book> getBooks() {
        return new ArrayList<>(BOOKS);
    }

    public static List<Book> getFeaturedBooks() {
        return new ArrayList<>(BOOKS.subList(0, Math.min(6, BOOKS.size())));
    }

    public static List<Category> getPopularCategories() {
        return new ArrayList<>(CATEGORIES.subList(0, Math.min(5, CATEGORIES.size())));
    }

    public static List<Reader> getReaders() {
        return new ArrayList<>(READERS);
    }

    public static List<Employee> getEmployees() {
        return new ArrayList<>(EMPLOYEES);
    }

    public static List<ReaderAccount> getLinkedAccounts(int readerId) {
        List<ReaderAccount> list = new ArrayList<>();
        for (ReaderAccount ra : READER_ACCOUNTS) {
            if (ra.getReaderId() == readerId) list.add(ra);
        }
        return list;
    }

    public static List<ReaderBookOwnership> getOwnedBooks(int readerId) {
        List<ReaderBookOwnership> list = new ArrayList<>();
        for (ReaderBookOwnership o : OWNERSHIPS) {
            if (o.getReaderId() == readerId && "active".equals(o.getStatus())) list.add(o);
        }
        return list;
    }

    public static List<Order> getOrders(int readerId) {
        List<Order> list = new ArrayList<>();
        for (Order o : ORDERS) {
            if (o.getReaderId() == readerId) list.add(o);
        }
        return list;
    }

    public static List<Order> getAllOrders() {
        return new ArrayList<>(ORDERS);
    }

    public static List<Payment> getPayments() {
        return new ArrayList<>(PAYMENTS);
    }

    public static List<Payment> getPaymentsByOrderId(int orderId) {
        List<Payment> list = new ArrayList<>();
        for (Payment p : PAYMENTS) {
            if (p.getOrderId() == orderId) list.add(p);
        }
        return list;
    }

    public static Cart getCart(int readerId) {
        for (Cart c : CARTS) {
            if (c.getReaderId() == readerId && "active".equals(c.getStatus())) return c;
        }
        Cart c = new Cart(readerId);
        c.setCartId(1);
        c.setItems(new ArrayList<>());
        for (CartItem ci : CART_ITEMS) {
            if (ci.getCartId() == 1) c.getItems().add(ci);
        }
        return c;
    }

    public static List<BorrowRequest> getBorrowRequests() {
        return new ArrayList<>(BORROW_REQUESTS);
    }

    public static List<BorrowRequestItem> getBorrowRequestItems(int requestId) {
        List<BorrowRequestItem> list = new ArrayList<>();
        for (BorrowRequestItem bri : BORROW_REQUEST_ITEMS) {
            if (bri.getRequestId() == requestId) list.add(bri);
        }
        return list;
    }

    public static List<Borrow> getBorrows(int readerId) {
        List<Borrow> list = new ArrayList<>();
        for (Borrow b : BORROWS) {
            if (b.getReaderId() == readerId) list.add(b);
        }
        return list;
    }

    public static List<Borrow> getActiveBorrows() {
        List<Borrow> list = new ArrayList<>();
        for (Borrow b : BORROWS) {
            if ("active".equals(b.getStatus()) || "overdue".equals(b.getStatus())) list.add(b);
        }
        return list;
    }

    public static List<BorrowItem> getBorrowItems(int borrowId) {
        List<BorrowItem> list = new ArrayList<>();
        for (BorrowItem bi : BORROW_ITEMS) {
            if (bi.getBorrowId() == borrowId) list.add(bi);
        }
        return list;
    }

    public static List<BorrowExtend> getBorrowExtends() {
        return new ArrayList<>(BORROW_EXTENDS);
    }

    public static List<BookCopy> getBookCopies() {
        return new ArrayList<>(BOOK_COPIES);
    }

    public static List<Reservation> getReservations() {
        return new ArrayList<>(RESERVATIONS);
    }

    public static List<FineType> getFineTypes() {
        return new ArrayList<>(FINE_TYPES);
    }

    public static List<Fine> getFines(int readerId) {
        List<Fine> list = new ArrayList<>();
        for (Fine f : FINES) {
            if (f.getReaderId() == readerId) list.add(f);
        }
        return list;
    }

    public static List<Fine> getAllFines() {
        return new ArrayList<>(FINES);
    }

    public static List<ReadingHistory> getReadingHistories(int readerId) {
        List<ReadingHistory> list = new ArrayList<>();
        for (ReadingHistory rh : READING_HISTORIES) {
            if (rh.getReaderId() == readerId) list.add(rh);
        }
        return list;
    }

    public static List<Bookmark> getBookmarks(int readerId) {
        List<Bookmark> list = new ArrayList<>();
        for (Bookmark bm : BOOKMARKS) {
            if (bm.getReaderId() == readerId) list.add(bm);
        }
        return list;
    }

    public static List<Review> getReviews(int bookId) {
        List<Review> list = new ArrayList<>();
        for (Review r : REVIEWS) {
            if (r.getBookId() == bookId) list.add(r);
        }
        return list;
    }

    public static List<Review> getAllReviews() {
        return new ArrayList<>(REVIEWS);
    }

    public static List<Notification> getNotifications(int readerId) {
        List<Notification> list = new ArrayList<>();
        for (Notification n : NOTIFICATIONS) {
            if (n.getReaderId() == readerId) list.add(n);
        }
        return list;
    }

    public static Reader getCurrentReader() {
        return READERS.isEmpty() ? null : READERS.get(0);
    }

    public static Employee getCurrentEmployee() {
        return EMPLOYEES.isEmpty() ? null : EMPLOYEES.get(0);
    }

    public static Book getBookById(int id) {
        for (Book b : BOOKS) {
            if (b.getBookId() == id) return b;
        }
        return null;
    }

    public static List<BorrowItem> getOverdueItems() {
        List<BorrowItem> list = new ArrayList<>();
        for (BorrowItem bi : BORROW_ITEMS) {
            if ("overdue".equals(bi.getStatus()) || (bi.getDueDate() != null && bi.getDueDate().isBefore(LocalDateTime.now()) && bi.getReturnedAt() == null))
                list.add(bi);
        }
        return list;
    }
}
