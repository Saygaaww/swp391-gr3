# Sequence Diagrams - Digital Library Management System

## 1. Đăng ký tài khoản Reader

```mermaid
sequenceDiagram
    actor Reader
    participant Browser
    participant AuthController
    participant ReaderDAO
    participant OtpDAO
    participant EmailUtil
    participant DB as SQL Server

    Reader->>Browser: Truy cập /auth/register
    Browser->>AuthController: GET /auth/register
    AuthController-->>Browser: Hiển thị register.jsp

    Reader->>Browser: Điền form đăng ký
    Browser->>AuthController: POST /auth/register
    AuthController->>ReaderDAO: getReaderByEmail(email)
    ReaderDAO->>DB: SELECT * FROM Reader WHERE email=?
    DB-->>ReaderDAO: null (email chưa tồn tại)
    ReaderDAO-->>AuthController: null

    AuthController->>AuthController: hashPassword(password)
    AuthController->>ReaderDAO: createReader(reader)
    ReaderDAO->>DB: INSERT INTO Reader
    DB-->>ReaderDAO: success
    ReaderDAO-->>AuthController: readerId

    AuthController->>OtpDAO: createOtp(readerId, otp)
    OtpDAO->>DB: INSERT INTO OTP
    DB-->>OtpDAO: success

    AuthController->>EmailUtil: sendOtpEmail(email, otp)
    EmailUtil-->>AuthController: sent

    AuthController-->>Browser: Redirect /auth/verify-otp
    Browser-->>Reader: Hiển thị trang nhập OTP
```

---

## 2. Đăng nhập (Reader & Employee)

```mermaid
sequenceDiagram
    actor User
    participant Browser
    participant AuthController
    participant ReaderDAO
    participant EmployeeDAO
    participant PasswordUtil
    participant Session
    participant DB as SQL Server

    User->>Browser: Truy cập /auth/login
    Browser->>AuthController: GET /auth/login
    AuthController-->>Browser: Hiển thị login.jsp

    User->>Browser: Nhập email + password
    Browser->>AuthController: POST /auth/login

    AuthController->>ReaderDAO: getReaderByEmail(email)
    ReaderDAO->>DB: SELECT * FROM Reader WHERE email=?
    DB-->>ReaderDAO: Reader object

    alt Reader tồn tại
        AuthController->>PasswordUtil: verifyPassword(plain, hash)
        PasswordUtil-->>AuthController: true

        AuthController->>Session: setAttribute("user", reader)
        AuthController->>Session: setAttribute("userRole", "Reader")
        AuthController->>Session: setAttribute("readerId", readerId)
        AuthController-->>Browser: Redirect /books
    else Reader không tồn tại - thử Employee
        AuthController->>EmployeeDAO: getEmployeeByEmail(email)
        EmployeeDAO->>DB: SELECT * FROM Employee WHERE email=?
        DB-->>EmployeeDAO: Employee object

        AuthController->>PasswordUtil: verifyPassword(plain, hash)
        PasswordUtil-->>AuthController: true

        AuthController->>Session: setAttribute("user", employee)
        AuthController->>Session: setAttribute("userRole", roleName)
        AuthController->>Session: setAttribute("employeeId", employeeId)
        AuthController-->>Browser: Redirect /admin/dashboard
    else Sai mật khẩu
        AuthController-->>Browser: Redirect /auth/login?error=invalid
    end
```

---

## 3. Đăng nhập bằng Google OAuth2

```mermaid
sequenceDiagram
    actor Reader
    participant Browser
    participant AuthController
    participant GoogleUtils
    participant GoogleAPI as Google OAuth2 API
    participant LinkedAccountDAO
    participant ReaderDAO
    participant Session
    participant DB as SQL Server

    Reader->>Browser: Click "Đăng nhập Google"
    Browser->>AuthController: GET /auth/google
    AuthController->>GoogleUtils: getAuthorizationUrl()
    GoogleUtils-->>AuthController: authUrl
    AuthController-->>Browser: Redirect to Google

    Browser->>GoogleAPI: Xác thực Google
    GoogleAPI-->>Browser: Redirect /auth/google/callback?code=xxx

    Browser->>AuthController: GET /auth/google/callback?code=xxx
    AuthController->>GoogleUtils: exchangeCodeForToken(code)
    GoogleUtils->>GoogleAPI: POST /token
    GoogleAPI-->>GoogleUtils: access_token
    GoogleUtils-->>AuthController: token

    AuthController->>GoogleUtils: getUserInfo(token)
    GoogleUtils->>GoogleAPI: GET /userinfo
    GoogleAPI-->>GoogleUtils: GoogleAccount
    GoogleUtils-->>AuthController: GoogleAccount

    AuthController->>LinkedAccountDAO: getByProviderUserId("google", sub)
    LinkedAccountDAO->>DB: SELECT * FROM LinkedAccount
    DB-->>LinkedAccountDAO: LinkedAccount or null

    alt Tài khoản đã liên kết
        AuthController->>ReaderDAO: getReaderById(readerId)
        ReaderDAO->>DB: SELECT * FROM Reader
        DB-->>ReaderDAO: Reader
        AuthController->>Session: setAttribute("user", reader)
        AuthController-->>Browser: Redirect /books
    else Tài khoản mới
        AuthController->>ReaderDAO: createReader(newReader)
        ReaderDAO->>DB: INSERT INTO Reader
        DB-->>ReaderDAO: readerId
        AuthController->>LinkedAccountDAO: linkAccount(linkedAccount)
        LinkedAccountDAO->>DB: INSERT INTO LinkedAccount
        AuthController->>Session: setAttribute("user", reader)
        AuthController-->>Browser: Redirect /books
    end
```

---

## 4. Quên mật khẩu / Reset mật khẩu

```mermaid
sequenceDiagram
    actor Reader
    participant Browser
    participant AuthController
    participant ReaderDAO
    participant PasswordResetDAO
    participant TokenUtil
    participant EmailUtil
    participant PasswordUtil
    participant DB as SQL Server

    Reader->>Browser: Truy cập /auth/forgot-password
    Browser->>AuthController: GET /auth/forgot-password
    AuthController-->>Browser: Hiển thị forgot-password.jsp

    Reader->>Browser: Nhập email
    Browser->>AuthController: POST /auth/forgot-password
    AuthController->>ReaderDAO: getReaderByEmail(email)
    ReaderDAO->>DB: SELECT * FROM Reader
    DB-->>ReaderDAO: Reader

    AuthController->>TokenUtil: generateToken()
    TokenUtil-->>AuthController: token

    AuthController->>PasswordResetDAO: createToken(token, readerId)
    PasswordResetDAO->>DB: INSERT INTO PasswordResetToken
    DB-->>PasswordResetDAO: success

    AuthController->>EmailUtil: sendPasswordResetEmail(email, token)
    EmailUtil-->>AuthController: sent
    AuthController-->>Browser: Thông báo "Kiểm tra email"

    Reader->>Browser: Click link trong email
    Browser->>AuthController: GET /auth/reset-password?token=xxx
    AuthController->>PasswordResetDAO: getByToken(token)
    PasswordResetDAO->>DB: SELECT * FROM PasswordResetToken
    DB-->>PasswordResetDAO: PasswordResetToken
    AuthController-->>Browser: Hiển thị reset-password.jsp

    Reader->>Browser: Nhập mật khẩu mới
    Browser->>AuthController: POST /auth/reset-password
    AuthController->>PasswordUtil: hashPassword(newPassword)
    PasswordUtil-->>AuthController: hash

    AuthController->>ReaderDAO: updatePassword(readerId, hash)
    ReaderDAO->>DB: UPDATE Reader SET passwordHash=?
    DB-->>ReaderDAO: success

    AuthController->>PasswordResetDAO: markUsed(tokenId)
    PasswordResetDAO->>DB: UPDATE PasswordResetToken SET used=1
    AuthController-->>Browser: Redirect /auth/login?msg=reset_success
```

---

## 5. Xem danh sách sách và tìm kiếm

```mermaid
sequenceDiagram
    actor User
    participant Browser
    participant BookController
    participant BookDAO
    participant AuthorDAO
    participant CategoryDAO
    participant PaginatedResult
    participant DB as SQL Server

    User->>Browser: Truy cập /books
    Browser->>BookController: GET /books?page=1&search=xxx&category=1
    BookController->>BookDAO: searchBooks(keyword, categoryId, page, size)
    BookDAO->>DB: SELECT * FROM Book WHERE ... OFFSET ... FETCH NEXT
    DB-->>BookDAO: List~Book~
    BookDAO-->>BookController: List~Book~

    BookController->>BookDAO: countBooks(keyword, categoryId)
    BookDAO->>DB: SELECT COUNT(*) FROM Book WHERE ...
    DB-->>BookDAO: totalCount
    BookDAO-->>BookController: totalCount

    BookController->>CategoryDAO: getAllCategories()
    CategoryDAO->>DB: SELECT * FROM Category
    DB-->>CategoryDAO: List~Category~
    CategoryDAO-->>BookController: List~Category~

    BookController->>PaginatedResult: new PaginatedResult(items, total, page, size)
    PaginatedResult-->>BookController: paginatedResult

    BookController->>Browser: forward /jsp/books/list.jsp
    Browser-->>User: Hiển thị danh sách sách
```

---

## 6. Mua sách (Thêm vào giỏ → Checkout → Thanh toán VNPay)

```mermaid
sequenceDiagram
    actor Reader
    participant Browser
    participant CustomerController
    participant CartDAO
    participant OrderDAO
    participant PaymentDAO
    participant ReaderBookOwnershipDAO
    participant VNPayUtil
    participant VNPayGW as VNPay Gateway
    participant DB as SQL Server

    Reader->>Browser: Click "Thêm vào giỏ"
    Browser->>CustomerController: POST /customer/cart/add?bookId=1
    CustomerController->>CartDAO: addToCart(readerId, bookId, price)
    CartDAO->>DB: INSERT/UPDATE CartItem
    DB-->>CartDAO: success
    CustomerController-->>Browser: Redirect /customer/cart

    Reader->>Browser: Xem giỏ hàng
    Browser->>CustomerController: GET /customer/cart
    CustomerController->>CartDAO: getCartByReaderId(readerId)
    CartDAO->>DB: SELECT CartItem JOIN Book
    DB-->>CartDAO: Cart with items
    CustomerController-->>Browser: Hiển thị cart.jsp

    Reader->>Browser: Click "Thanh toán"
    Browser->>CustomerController: POST /customer/checkout
    CustomerController->>OrderDAO: createOrder(order)
    OrderDAO->>DB: INSERT INTO Order + OrderBook
    DB-->>OrderDAO: orderId

    CustomerController->>VNPayUtil: createPaymentUrl(amount, orderId, info, returnUrl, ip)
    VNPayUtil-->>CustomerController: vnpayUrl
    CustomerController-->>Browser: Redirect to VNPay

    Browser->>VNPayGW: Thanh toán
    VNPayGW-->>Browser: Redirect /jsp/vnpay-result.jsp?vnp_ResponseCode=00

    Browser->>CustomerController: GET /customer/payment/return?vnp_ResponseCode=00
    CustomerController->>VNPayUtil: verifyReturnUrl(params)
    VNPayUtil-->>CustomerController: true

    CustomerController->>PaymentDAO: createPayment(payment)
    PaymentDAO->>DB: INSERT INTO Payment
    DB-->>PaymentDAO: success

    CustomerController->>OrderDAO: updateOrderStatus(orderId, "paid")
    OrderDAO->>DB: UPDATE Order SET status="paid"

    CustomerController->>ReaderBookOwnershipDAO: addOwnership(readerId, bookId, "purchase")
    ReaderBookOwnershipDAO->>DB: INSERT INTO ReaderBookOwnership
    DB-->>ReaderBookOwnershipDAO: success

    CustomerController->>CartDAO: clearCart(readerId)
    CartDAO->>DB: DELETE CartItem
    CustomerController-->>Browser: Redirect /customer/orders?msg=success
```

---

## 7. Yêu cầu mượn sách (Reader → Librarian duyệt)

```mermaid
sequenceDiagram
    actor Reader
    actor Librarian
    participant Browser
    participant CustomerController
    participant AdminBorrowApproveServlet
    participant BorrowDAO
    participant NotificationDAO
    participant DB as SQL Server

    Reader->>Browser: Chọn sách và yêu cầu mượn
    Browser->>CustomerController: POST /customer/borrow/request
    CustomerController->>BorrowDAO: createBorrowRequest(borrowRequest)
    BorrowDAO->>DB: INSERT INTO BorrowRequest + BorrowRequestItem
    DB-->>BorrowDAO: requestId
    BorrowDAO-->>CustomerController: requestId
    CustomerController-->>Browser: Redirect /customer/borrow-requests?msg=submitted

    Librarian->>Browser: Xem danh sách yêu cầu mượn
    Browser->>AdminBorrowApproveServlet: GET /admin/borrows
    AdminBorrowApproveServlet->>BorrowDAO: getAllBorrowRequests()
    BorrowDAO->>DB: SELECT BorrowRequest JOIN Reader
    DB-->>BorrowDAO: List~BorrowRequest~
    AdminBorrowApproveServlet-->>Browser: Hiển thị borrow-list.jsp

    Librarian->>Browser: Duyệt yêu cầu
    Browser->>AdminBorrowApproveServlet: POST /admin/borrows/approve?requestId=1
    AdminBorrowApproveServlet->>BorrowDAO: approveBorrowRequest(requestId, employeeId)
    BorrowDAO->>DB: UPDATE BorrowRequest SET status="approved"
    BorrowDAO->>DB: INSERT INTO Borrow + BorrowItem
    DB-->>BorrowDAO: success

    AdminBorrowApproveServlet->>NotificationDAO: createNotification(readerId, "Yêu cầu mượn được duyệt")
    NotificationDAO->>DB: INSERT INTO Notification
    DB-->>NotificationDAO: success

    AdminBorrowApproveServlet-->>Browser: Redirect /admin/borrows?msg=approved
    Browser-->>Librarian: Thông báo duyệt thành công
```

---

## 8. Trả sách và tính phạt

```mermaid
sequenceDiagram
    actor Librarian
    participant Browser
    participant AdminBorrowApproveServlet
    participant BorrowDAO
    participant FineDAO
    participant NotificationDAO
    participant DB as SQL Server

    Librarian->>Browser: Xem chi tiết mượn sách
    Browser->>AdminBorrowApproveServlet: GET /admin/borrows/detail?borrowId=1
    AdminBorrowApproveServlet->>BorrowDAO: getBorrowById(borrowId)
    BorrowDAO->>DB: SELECT Borrow JOIN BorrowItem JOIN BookCopy
    DB-->>BorrowDAO: BorrowedItemView
    AdminBorrowApproveServlet-->>Browser: Hiển thị borrow-detail.jsp

    Librarian->>Browser: Xác nhận trả sách
    Browser->>AdminBorrowApproveServlet: POST /admin/borrows/return?borrowItemId=1
    AdminBorrowApproveServlet->>BorrowDAO: returnBorrowItem(borrowItemId)
    BorrowDAO->>DB: UPDATE BorrowItem SET status="returned", returnDate=NOW()
    DB-->>BorrowDAO: success

    BorrowDAO->>BorrowDAO: Kiểm tra quá hạn
    alt Trả trễ hạn
        AdminBorrowApproveServlet->>FineDAO: createFine(fine)
        FineDAO->>DB: INSERT INTO Fine
        DB-->>FineDAO: fineId

        AdminBorrowApproveServlet->>NotificationDAO: createNotification(readerId, "Bạn có khoản phạt")
        NotificationDAO->>DB: INSERT INTO Notification
    end

    AdminBorrowApproveServlet-->>Browser: Redirect /admin/borrows?msg=returned
```

---

## 9. Đọc sách online (Reader)

```mermaid
sequenceDiagram
    actor Reader
    participant Browser
    participant CustomerController
    participant ReaderBookOwnershipDAO
    participant ReadingHistoryDAO
    participant BookDAO
    participant DB as SQL Server

    Reader->>Browser: Click "Đọc sách"
    Browser->>CustomerController: GET /customer/read?bookId=5
    CustomerController->>ReaderBookOwnershipDAO: hasOwnership(readerId, bookId)
    ReaderBookOwnershipDAO->>DB: SELECT * FROM ReaderBookOwnership
    DB-->>ReaderBookOwnershipDAO: true/false

    alt Đã sở hữu sách
        CustomerController->>BookDAO: getBookById(bookId)
        BookDAO->>DB: SELECT * FROM Book
        DB-->>BookDAO: Book
        BookDAO-->>CustomerController: Book

        CustomerController->>ReadingHistoryDAO: getByReaderId(readerId)
        ReadingHistoryDAO->>DB: SELECT * FROM ReadingHistory WHERE readerId=? AND bookId=?
        DB-->>ReadingHistoryDAO: ReadingHistory
        ReadingHistoryDAO-->>CustomerController: lastPageRead

        CustomerController-->>Browser: forward /jsp/customer/read.jsp
        Browser-->>Reader: Hiển thị PDF viewer tại trang cuối đọc

        Reader->>Browser: Đọc đến trang X
        Browser->>CustomerController: POST /customer/read/progress?bookId=5&page=X
        CustomerController->>ReadingHistoryDAO: upsertHistory(readerId, bookId, page)
        ReadingHistoryDAO->>DB: MERGE INTO ReadingHistory
        DB-->>ReadingHistoryDAO: success
    else Chưa sở hữu
        CustomerController-->>Browser: Redirect /books/5 (xem preview)
    end
```

---

## 10. Quản lý nhân viên (Admin)

```mermaid
sequenceDiagram
    actor Admin
    participant Browser
    participant AdminEmployeeListServlet
    participant AdminEmployeeFormServlet
    participant EmployeeDAO
    participant RoleDAO
    participant PasswordUtil
    participant DB as SQL Server

    Admin->>Browser: Xem danh sách nhân viên
    Browser->>AdminEmployeeListServlet: GET /admin/employees
    AdminEmployeeListServlet->>EmployeeDAO: getAllEmployees()
    EmployeeDAO->>DB: SELECT Employee JOIN Role
    DB-->>EmployeeDAO: List~Employee~
    AdminEmployeeListServlet-->>Browser: Hiển thị employees.jsp

    Admin->>Browser: Click "Thêm nhân viên"
    Browser->>AdminEmployeeFormServlet: GET /admin/employees/new
    AdminEmployeeFormServlet->>RoleDAO: getAllRoles()
    RoleDAO->>DB: SELECT * FROM Role
    DB-->>RoleDAO: List~Role~
    AdminEmployeeFormServlet-->>Browser: Hiển thị employee-form.jsp

    Admin->>Browser: Điền form và submit
    Browser->>AdminEmployeeFormServlet: POST /admin/employees/save
    AdminEmployeeFormServlet->>PasswordUtil: hashPassword(password)
    PasswordUtil-->>AdminEmployeeFormServlet: hash

    AdminEmployeeFormServlet->>EmployeeDAO: createEmployee(employee)
    EmployeeDAO->>DB: INSERT INTO Employee
    DB-->>EmployeeDAO: employeeId
    AdminEmployeeFormServlet-->>Browser: Redirect /admin/employees?msg=created
```

---

## 11. Xem báo cáo doanh thu (Seller)

```mermaid
sequenceDiagram
    actor Seller
    participant Browser
    participant SalesReportServlet
    participant SalesAnalyticsServlet
    participant OrderDAO
    participant PaymentDAO
    participant AuthUtil
    participant DB as SQL Server

    Seller->>Browser: Truy cập /seller/sales-report
    Browser->>SalesReportServlet: GET /seller/sales-report
    SalesReportServlet->>AuthUtil: hasAnyRole(req, "Seller", "Admin")
    AuthUtil-->>SalesReportServlet: true

    SalesReportServlet->>OrderDAO: getAllOrders()
    OrderDAO->>DB: SELECT Order JOIN Reader JOIN OrderBook
    DB-->>OrderDAO: List~Order~
    OrderDAO-->>SalesReportServlet: List~Order~

    loop Mỗi Order
        SalesReportServlet->>PaymentDAO: getByOrderId(orderId)
        PaymentDAO->>DB: SELECT * FROM Payment WHERE orderId=?
        DB-->>PaymentDAO: Payment
        PaymentDAO-->>SalesReportServlet: Payment
    end

    SalesReportServlet-->>Browser: forward /jsp/seller/sales-report.jsp
    Browser-->>Seller: Hiển thị báo cáo doanh thu

    Seller->>Browser: Truy cập /seller/sales-analytics
    Browser->>SalesAnalyticsServlet: GET /seller/sales-analytics
    SalesAnalyticsServlet->>OrderDAO: getTopSellingBooks()
    OrderDAO->>DB: SELECT bookId, COUNT(*) FROM OrderBook GROUP BY bookId
    DB-->>OrderDAO: List~TopSellingBook~
    SalesAnalyticsServlet-->>Browser: forward /jsp/seller/sales-analytics.jsp
    Browser-->>Seller: Hiển thị biểu đồ phân tích
```

---

## 12. Quản lý sách (Librarian/Seller thêm/sửa sách)

```mermaid
sequenceDiagram
    actor Staff
    participant Browser
    participant BookController
    participant BookDAO
    participant AuthorDAO
    participant CategoryDAO
    participant AuthUtil
    participant DB as SQL Server

    Staff->>Browser: Truy cập /books/new
    Browser->>BookController: GET /books/new
    BookController->>AuthUtil: canManageBooks(req)
    AuthUtil-->>BookController: true

    BookController->>AuthorDAO: getAllAuthors()
    AuthorDAO->>DB: SELECT * FROM Author
    DB-->>AuthorDAO: List~Author~

    BookController->>CategoryDAO: getAllCategories()
    CategoryDAO->>DB: SELECT * FROM Category
    DB-->>CategoryDAO: List~Category~

    BookController-->>Browser: forward /jsp/books/form.jsp
    Browser-->>Staff: Hiển thị form thêm sách

    Staff->>Browser: Điền thông tin sách và upload cover
    Browser->>BookController: POST /books/create
    BookController->>AuthUtil: canManageBooks(req)
    AuthUtil-->>BookController: true

    BookController->>BookDAO: createBook(book)
    BookDAO->>DB: INSERT INTO Book
    DB-->>BookDAO: bookId
    BookDAO-->>BookController: bookId

    BookController-->>Browser: Redirect /books/bookId?msg=created
    Browser-->>Staff: Hiển thị chi tiết sách vừa tạo
```

---

## 13. Đặt trước sách (Reservation)

```mermaid
sequenceDiagram
    actor Reader
    participant Browser
    participant CustomerController
    participant ReservationDAO
    participant NotificationDAO
    participant DB as SQL Server

    Reader->>Browser: Click "Đặt trước" trên trang sách
    Browser->>CustomerController: POST /customer/reservations/create?bookId=3
    CustomerController->>ReservationDAO: createReservation(readerId, bookId)
    ReservationDAO->>DB: INSERT INTO Reservation
    DB-->>ReservationDAO: reservationId

    CustomerController->>NotificationDAO: createNotification(readerId, "Đặt trước thành công")
    NotificationDAO->>DB: INSERT INTO Notification
    DB-->>NotificationDAO: success

    CustomerController-->>Browser: Redirect /customer/reservations?msg=reserved

    Reader->>Browser: Xem danh sách đặt trước
    Browser->>CustomerController: GET /customer/reservations
    CustomerController->>ReservationDAO: getReservationsByReaderId(readerId)
    ReservationDAO->>DB: SELECT Reservation JOIN Book
    DB-->>ReservationDAO: List~Reservation~
    CustomerController-->>Browser: forward /jsp/customer/reservations.jsp
    Browser-->>Reader: Hiển thị danh sách đặt trước
```

---

## 14. Viết đánh giá sách (Review)

```mermaid
sequenceDiagram
    actor Reader
    participant Browser
    participant CustomerController
    participant ReviewDAO
    participant ReaderBookOwnershipDAO
    participant DB as SQL Server

    Reader->>Browser: Truy cập trang đánh giá
    Browser->>CustomerController: GET /customer/reviews
    CustomerController->>ReviewDAO: getReviewsByReaderId(readerId)
    ReviewDAO->>DB: SELECT Review JOIN Book
    DB-->>ReviewDAO: List~Review~
    CustomerController-->>Browser: forward /jsp/customer/reviews.jsp

    Reader->>Browser: Viết đánh giá cho sách
    Browser->>CustomerController: POST /customer/reviews/submit
    CustomerController->>ReaderBookOwnershipDAO: hasOwnership(readerId, bookId)
    ReaderBookOwnershipDAO->>DB: SELECT * FROM ReaderBookOwnership
    DB-->>ReaderBookOwnershipDAO: true

    CustomerController->>ReviewDAO: createReview(review)
    ReviewDAO->>DB: INSERT INTO Review
    DB-->>ReviewDAO: reviewId
    CustomerController-->>Browser: Redirect /customer/reviews?msg=submitted
```

---

## 15. Quản lý thông báo (Notification)

```mermaid
sequenceDiagram
    actor Reader
    participant Browser
    participant NotificationController
    participant NotificationDAO
    participant DB as SQL Server

    Reader->>Browser: Truy cập /notifications
    Browser->>NotificationController: GET /notifications
    NotificationController->>NotificationDAO: getByReaderId(readerId)
    NotificationDAO->>DB: SELECT * FROM Notification WHERE readerId=? ORDER BY createdAt DESC
    DB-->>NotificationDAO: List~Notification~
    NotificationDAO-->>NotificationController: List~Notification~

    NotificationController->>NotificationDAO: getUnreadCount(readerId)
    NotificationDAO->>DB: SELECT COUNT(*) FROM Notification WHERE readerId=? AND isRead=0
    DB-->>NotificationDAO: count
    NotificationDAO-->>NotificationController: count

    NotificationController-->>Browser: forward /jsp/notifications/inbox.jsp
    Browser-->>Reader: Hiển thị hộp thư thông báo

    Reader->>Browser: Click "Đánh dấu đã đọc tất cả"
    Browser->>NotificationController: POST /notifications/mark-all-read
    NotificationController->>NotificationDAO: markAllAsRead(readerId)
    NotificationDAO->>DB: UPDATE Notification SET isRead=1 WHERE readerId=?
    DB-->>NotificationDAO: success
    NotificationController-->>Browser: Redirect /notifications
```
