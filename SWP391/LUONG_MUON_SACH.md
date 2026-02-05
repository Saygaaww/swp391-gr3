# Luồng hoạt động mượn sách (Borrow Flow)

Tài liệu mô tả chi tiết luồng hoạt động từng bước, từng hàm nối tiếp nhau trong quy trình mượn sách.

---

## Tổng quan luồng

```
[Reader] Xem sách → Chọn sách → Tạo yêu cầu mượn
    ↓
[Librarian] Xem yêu cầu → Duyệt/Từ chối
    ↓ (nếu duyệt)
[Reader] Xem sách đang mượn → Trả sách
```

---

## PHẦN 1: READER – Xem sách và tạo yêu cầu mượn

### Bước 1.1: Xem danh sách sách

**URL:** `GET /book` hoặc `GET /book?action=list`

| Thứ tự | Lớp | Hàm | Mô tả |
|--------|-----|-----|-------|
| 1 | `BookServlet` | `doGet()` | Nhận request, lấy `action` (mặc định `"list"`) |
| 2 | `BookServlet` | `listBooks()` | Gọi khi `action=list` |
| 3 | `BookDAO` | `getAllBooks()` | Query DB: SELECT Book + Author + Category + COUNT(available copies) |
| 4 | `BookServlet` | - | `request.setAttribute("books", books)` |
| 5 | `BookServlet` | - | `forward` → `/view/reader/book.jsp` |

**Kết quả:** Hiển thị danh sách sách trên `book.jsp`.

---

### Bước 1.2: Xem chi tiết sách (tùy chọn)

**URL:** `GET /book?action=detail&id={bookId}`

| Thứ tự | Lớp | Hàm | Mô tả |
|--------|-----|-----|-------|
| 1 | `BookServlet` | `doGet()` | Nhận request, `action=detail` |
| 2 | `BookServlet` | `showBookDetail()` | Parse `bookId` từ param |
| 3 | `BookDAO` | `getBookById(bookId)` | Query DB: SELECT Book theo ID |
| 4 | `BookServlet` | - | `request.setAttribute("book", book)` |
| 5 | `BookServlet` | - | `forward` → `/view/reader/book-detail.jsp` |

**Kết quả:** Hiển thị chi tiết sách. Trang có link "Mượn sách" → `borrow?bookId={id}`.

---

### Bước 1.3: Mở form mượn sách

**URL:** `GET /borrow` hoặc `GET /borrow?bookId={bookId}`

| Thứ tự | Lớp | Hàm | Mô tả |
|--------|-----|-----|-------|
| 1 | `BorrowRequestServlet` | `doGet()` | Nhận request, `action` mặc định `"form"` |
| 2 | `BorrowRequestServlet` | `showBorrowForm()` | Kiểm tra `session.readerId` (redirect login nếu null) |
| 3 | (nếu có `bookId`) | `BookDAO.getBookById(bookId)` | Lấy thông tin sách |
| 4 | (nếu có `bookId`) | `BookCopyDAO.countAvailableCopies(bookId)` | Đếm số bản có sẵn |
| 5 | `BorrowRequestServlet` | - | `setAttribute("book", book)`, `setAttribute("availableCopies", ...)` |
| 6 | `BorrowRequestServlet` | - | `forward` → `/view/reader/borrow.jsp` |

**Kết quả:** Hiển thị form mượn sách (có thể đã chọn sẵn 1 cuốn nếu có `bookId`).

---

### Bước 1.4: Gửi yêu cầu mượn sách (POST)

**URL:** `POST /borrow` với `action=create`, `bookId[]`, `quantity[]`, `note`

| Thứ tự | Lớp | Hàm | Mô tả |
|--------|-----|-----|-------|
| 1 | `BorrowRequestServlet` | `doPost()` | Nhận request, `action=create` |
| 2 | `BorrowRequestServlet` | `createBorrowRequest()` | Lấy `readerId` từ session |
| 3 | `BorrowRequestServlet` | - | Parse `bookIds[]`, `quantities[]`, `note` |
| 4 | Vòng lặp mỗi sách | `BookCopyDAO.countAvailableCopies(bookId)` | Kiểm tra đủ số lượng |
| 5 | `BorrowRequestServlet` | - | Tạo `BorrowRequest` (status=pending) + `List<BorrowRequestItem>` |
| 6 | `BorrowRequestDAO` | `createBorrowRequest(request, items)` | **Transaction:** |
| 6a | `BorrowRequestDAO` | - | INSERT `Borrow_Request` (reader_id, status, note) |
| 6b | `BorrowRequestDAO` | - | Lấy `request_id` (generated key) |
| 6c | `BorrowRequestDAO` | - | INSERT batch `Borrow_Request_Item` (request_id, book_id, quantity) |
| 6d | `BorrowRequestDAO` | - | `commit()` |
| 7 | `BorrowRequestServlet` | - | `setAttribute("success", ...)`, `setAttribute("requestId", ...)` |
| 8 | `BorrowRequestServlet` | - | `forward` → `/view/reader/borrow-success.jsp` |

**Kết quả:** Yêu cầu mượn được tạo, status `pending`. Chuyển sang trang thành công.

---

## PHẦN 2: LIBRARIAN – Duyệt/Từ chối yêu cầu

### Bước 2.1: Xem dashboard (danh sách yêu cầu chờ duyệt)

**URL:** `GET /librarian` hoặc `GET /librarian?action=dashboard`

| Thứ tự | Lớp | Hàm | Mô tả |
|--------|-----|-----|-------|
| 1 | `LibrarianServlet` | `doGet()` | Kiểm tra session (employeeId, userType=librarian) |
| 2 | `LibrarianServlet` | `showDashboard()` | - |
| 3 | `BorrowRequestDAO` | `getPendingRequests()` | SELECT Borrow_Request WHERE status='pending' |
| 4 | Vòng lặp mỗi request | `BorrowRequestDAO.getBorrowRequestItems(requestId)` | Lấy chi tiết từng yêu cầu |
| 5 | `LibrarianServlet` | - | `req.setRequestItems(items)` |
| 6 | `LibrarianServlet` | - | `setAttribute("pendingRequests", ...)`, `forward` → `dashboard.jsp` |

**Kết quả:** Hiển thị danh sách yêu cầu chờ duyệt.

---

### Bước 2.2a: Mở form duyệt (approve)

**URL:** `GET /librarian?action=approve&requestId={id}`

| Thứ tự | Lớp | Hàm | Mô tả |
|--------|-----|-----|-------|
| 1 | `LibrarianServlet` | `doGet()` | `action=approve` |
| 2 | `LibrarianServlet` | `showApproveForm()` | Parse `requestId` |
| 3 | `BorrowRequestDAO` | `getBorrowRequestById(requestId)` | Lấy BorrowRequest |
| 4 | `BorrowRequestDAO` | `getBorrowRequestItems(requestId)` | Lấy danh sách sách trong yêu cầu |
| 5 | Vòng lặp mỗi item | `BookDAO.getBookById(bookId)` | Thông tin sách |
| 6 | Vòng lặp mỗi item | `BookCopyDAO.countAvailableCopies(bookId)` | Số bản có sẵn |
| 7 | `LibrarianServlet` | - | `forward` → `/view/librarian/approve-request.jsp` |

**Kết quả:** Form duyệt yêu cầu với thông tin sách và số bản có sẵn.

---

### Bước 2.2b: Thực hiện duyệt (approve) – POST

**URL:** `POST /librarian` với `action=approve`, `requestId`

| Thứ tự | Lớp | Hàm | Mô tả |
|--------|-----|-----|-------|
| 1 | `LibrarianServlet` | `doPost()` | `action=approve` |
| 2 | `LibrarianServlet` | `approveRequest(..., employeeId)` | - |
| 3 | `BorrowRequestDAO` | `getBorrowRequestById(requestId)` | Kiểm tra request còn pending |
| 4 | `BorrowRequestDAO` | `getBorrowRequestItems(requestId)` | Lấy danh sách sách |
| 5 | Vòng lặp mỗi item | `BookCopyDAO.countAvailableCopies(bookId)` | Kiểm tra đủ số lượng |
| 6 | Vòng lặp mỗi item | `BookCopyDAO.getAvailableCopiesByBookId(bookId)` | Lấy danh sách copy_id available |
| 7 | `LibrarianServlet` | - | Thu thập `copyIds` theo quantity mỗi sách |
| 8 | `BorrowDAO` | `createBorrow(readerId, requestId, copyIds, employeeId)` | **Transaction:** |
| 8a | `BorrowDAO` | - | INSERT `Borrow` (reader_id, request_id, status='active', approved_by) |
| 8b | `BorrowDAO` | - | Lấy `borrow_id` (generated key) |
| 8c | `BorrowDAO` | - | Với mỗi copyId: INSERT `Borrow_Item` (borrow_id, copy_id, due_date=+14 ngày, status='borrowed') |
| 8d | `BorrowDAO` | - | Với mỗi copyId: UPDATE `BookCopy` SET status='borrowed' |
| 8e | `BorrowDAO` | - | UPDATE `Borrow_Request` SET status='approved', processed_at, processed_by |
| 8f | `BorrowDAO` | - | `commit()` |
| 9 | `LibrarianServlet` | - | `redirect` → `librarian?action=dashboard` |

**Kết quả:** Yêu cầu chuyển sang `approved`, tạo `Borrow` và `Borrow_Item`, cập nhật `BookCopy` thành `borrowed`.

---

### Bước 2.3: Từ chối yêu cầu (reject)

**URL (form):** `GET /librarian?action=reject&requestId={id}`  
**URL (submit):** `POST /librarian` với `action=reject`, `requestId`, `decisionNote`

| Thứ tự | Lớp | Hàm | Mô tả |
|--------|-----|-----|-------|
| 1 | `LibrarianServlet` | `doPost()` | `action=reject` |
| 2 | `LibrarianServlet` | `rejectRequest(..., employeeId)` | - |
| 3 | `BorrowRequestDAO` | `rejectRequest(requestId, employeeId, decisionNote)` | UPDATE Borrow_Request SET status='rejected', processed_at, processed_by, decision_note |
| 4 | `LibrarianServlet` | - | `redirect` → `librarian?action=dashboard` |

**Kết quả:** Yêu cầu chuyển sang `rejected`, không tạo Borrow.

---

## PHẦN 3: READER – Xem sách đang mượn và trả sách

### Bước 3.1: Xem sách đang mượn

**URL:** `GET /readerBorrow` hoặc `GET /readerBorrow?action=myBorrows`

| Thứ tự | Lớp | Hàm | Mô tả |
|--------|-----|-----|-------|
| 1 | `ReaderBorrowServlet` | `doGet()` | Kiểm tra `session.readerId` |
| 2 | `ReaderBorrowServlet` | `showMyBorrows(request, response, readerId)` | - |
| 3 | `BorrowDAO` | `getBorrowsByReaderId(readerId)` | SELECT Borrow WHERE reader_id=? |
| 4 | Vòng lặp mỗi borrow | `BorrowDAO.getBorrowItems(borrowId)` | SELECT Borrow_Item WHERE borrow_id=? |
| 5 | `ReaderBorrowServlet` | - | `borrow.setBorrowItems(items)` |
| 6 | `ReaderBorrowServlet` | - | `setAttribute("borrows", borrows)`, `forward` → `my-borrows.jsp` |

**Kết quả:** Hiển thị danh sách phiếu mượn và từng cuốn sách đang mượn, có nút "Trả sách".

---

### Bước 3.2: Mở form trả sách (tùy chọn)

**URL:** `GET /readerBorrow?action=return&borrowItemId={id}`

| Thứ tự | Lớp | Hàm | Mô tả |
|--------|-----|-----|-------|
| 1 | `ReaderBorrowServlet` | `doGet()` | `action=return` |
| 2 | `ReaderBorrowServlet` | `showReturnForm(..., readerId)` | Parse `borrowItemId` |
| 3 | `BorrowDAO` | `getBorrowsByReaderId(readerId)` | Lấy tất cả borrow của reader |
| 4 | Vòng lặp | `BorrowDAO.getBorrowItems(borrowId)` | Tìm BorrowItem có borrowItemId trùng |
| 5 | `ReaderBorrowServlet` | - | `setAttribute("borrowItem", item)`, `forward` → `return-book.jsp` |

**Kết quả:** Form xác nhận trả sách (có thể bỏ qua và trả trực tiếp từ my-borrows).

---

### Bước 3.3: Thực hiện trả sách – POST

**URL:** `POST /readerBorrow` với `action=return`, `borrowItemId`

| Thứ tự | Lớp | Hàm | Mô tả |
|--------|-----|-----|-------|
| 1 | `ReaderBorrowServlet` | `doPost()` | `action=return` |
| 2 | `ReaderBorrowServlet` | `returnBook(..., readerId)` | Parse `borrowItemId` |
| 3 | `BorrowDAO` | `returnBook(borrowItemId)` | **Transaction:** |
| 3a | `BorrowDAO` | - | SELECT copy_id FROM Borrow_Item WHERE borrow_item_id=? |
| 3b | `BorrowDAO` | - | UPDATE Borrow_Item SET returned_at=GETDATE(), status='returned' |
| 3c | `BorrowDAO` | - | UPDATE BookCopy SET status='available' WHERE copy_id=? |
| 3d | `BorrowDAO` | - | `commit()` |
| 4 | `ReaderBorrowServlet` | - | `redirect` → `readerBorrow?action=myBorrows` |

**Kết quả:** Bản sao được trả, `Borrow_Item` cập nhật `returned`, `BookCopy` chuyển về `available`.

---

## Sơ đồ luồng hàm (Sequence)

```
READER                          BORROW REQUEST                    LIBRARIAN
   |                                  DAO                              |
   |-- BookServlet.listBooks() ------> BookDAO.getAllBooks()            |
   |<-- book.jsp                                                       |
   |                                                                   |
   |-- BorrowRequestServlet.showBorrowForm() --> BookDAO.getBookById()  |
   |                              --> BookCopyDAO.countAvailableCopies |
   |<-- borrow.jsp                                                     |
   |                                                                   |
   |-- BorrowRequestServlet.createBorrowRequest()                      |
   |   --> BorrowRequestDAO.createBorrowRequest()                      |
   |       [INSERT Borrow_Request + Borrow_Request_Item]                |
   |<-- borrow-success.jsp                                             |
   |                                                                   |
   |                                    |-- LibrarianServlet.showDashboard() |
   |                                    |   --> BorrowRequestDAO.getPendingRequests() |
   |                                    |   --> getBorrowRequestItems()     |
   |                                    |<-- dashboard.jsp                  |
   |                                    |                                   |
   |                                    |-- LibrarianServlet.approveRequest() |
   |                                    |   --> BorrowRequestDAO.getBorrowRequestById() |
   |                                    |   --> getBorrowRequestItems()     |
   |                                    |   --> BookCopyDAO.getAvailableCopiesByBookId() |
   |                                    |   --> BorrowDAO.createBorrow()    |
   |                                    |       [INSERT Borrow + Borrow_Item] |
   |                                    |       [UPDATE BookCopy borrowed]  |
   |                                    |       [UPDATE Borrow_Request approved] |
   |                                    |<-- redirect dashboard              |
   |                                                                   |
   |-- ReaderBorrowServlet.showMyBorrows() --> BorrowDAO.getBorrowsByReaderId() |
   |                                    --> BorrowDAO.getBorrowItems()  |
   |<-- my-borrows.jsp                                                 |
   |                                                                   |
   |-- ReaderBorrowServlet.returnBook() --> BorrowDAO.returnBook()     |
   |       [UPDATE Borrow_Item returned]                               |
   |       [UPDATE BookCopy available]                                 |
   |<-- redirect my-borrows                                            |
```

---

## Bảng mapping URL → Servlet → Hàm

| URL | Method | Servlet | Hàm gọi |
|-----|--------|---------|---------|
| `/book` | GET | BookServlet | listBooks() |
| `/book?action=detail&id=X` | GET | BookServlet | showBookDetail() |
| `/book?action=search&keyword=X` | GET | BookServlet | searchBooks() |
| `/borrow` | GET | BorrowRequestServlet | showBorrowForm() |
| `/borrow` | POST (action=create) | BorrowRequestServlet | createBorrowRequest() |
| `/borrow?action=list` | GET | BorrowRequestServlet | listBorrowRequests() |
| `/librarian` | GET | LibrarianServlet | showDashboard() |
| `/librarian?action=approve&requestId=X` | GET | LibrarianServlet | showApproveForm() |
| `/librarian?action=approve` | POST | LibrarianServlet | approveRequest() |
| `/librarian?action=reject&requestId=X` | GET | LibrarianServlet | showRejectForm() |
| `/librarian?action=reject` | POST | LibrarianServlet | rejectRequest() |
| `/readerBorrow` | GET | ReaderBorrowServlet | showMyBorrows() |
| `/readerBorrow?action=return&borrowItemId=X` | GET | ReaderBorrowServlet | showReturnForm() |
| `/readerBorrow` | POST (action=return) | ReaderBorrowServlet | returnBook() |

---

## Thay đổi trạng thái dữ liệu

| Bước | Bảng | Trạng thái trước | Trạng thái sau |
|------|------|------------------|----------------|
| Tạo yêu cầu | Borrow_Request | - | status=pending |
| | Borrow_Request_Item | - | INSERT (request_id, book_id, quantity) |
| Duyệt | Borrow_Request | pending | approved |
| | Borrow | - | INSERT (reader_id, request_id, status=active) |
| | Borrow_Item | - | INSERT (borrow_id, copy_id, due_date, status=borrowed) |
| | BookCopy | available | borrowed |
| Từ chối | Borrow_Request | pending | rejected |
| Trả sách | Borrow_Item | borrowed | returned (returned_at set) |
| | BookCopy | borrowed | available |

---

# CHI TIẾT CÁC HÀM BÊN TRONG

Mô tả chi tiết từng hàm: tham số, logic xử lý, câu SQL, giá trị trả về.

---

## 1. CONTROLLER – BookServlet

### 1.1 `init()`
- **Mục đích:** Khởi tạo khi Servlet được load lần đầu.
- **Logic:** Tạo instance `BookDAO` và gán vào `bookDAO`.
- **Gọi:** `super.init()` → `bookDAO = new BookDAO()`.

---

### 1.2 `doGet(request, response)`
- **Input:** `request.getParameter("action")`.
- **Logic:**
  1. Lấy `action`; nếu null/empty → `"list"`.
  2. `switch(action)`:
     - `"list"` → `listBooks()`
     - `"detail"` → `showBookDetail()`
     - `"search"` → `searchBooks()`
     - default → `listBooks()`

---

### 1.3 `listBooks(request, response)`
- **Logic:**
  1. Gọi `bookDAO.getAllBooks()` → `List<Book>`.
  2. `request.setAttribute("books", books)`.
  3. `request.getRequestDispatcher("/view/reader/book.jsp").forward(request, response)`.

---

### 1.4 `showBookDetail(request, response)`
- **Input:** `request.getParameter("id")` (bookId).
- **Logic:**
  1. Nếu `id` null/empty → `response.sendError(400, "Book ID is required")`, return.
  2. Parse `bookId = Integer.parseInt(id)`.
  3. Gọi `bookDAO.getBookById(bookId)`.
  4. Nếu `book == null` → `sendError(404, "Book not found")`, return.
  5. `request.setAttribute("book", book)`.
  6. `forward` → `/view/reader/book-detail.jsp`.
- **Exception:** `NumberFormatException` → `sendError(400, "Invalid Book ID")`.

---

### 1.5 `searchBooks(request, response)`
- **Input:** `request.getParameter("keyword")`.
- **Logic:**
  1. Nếu keyword null/empty → gọi `listBooks()`, return.
  2. Gọi `bookDAO.searchBooks(keyword.trim())`.
  3. `request.setAttribute("books", books)`, `setAttribute("keyword", keyword)`.
  4. `forward` → `/view/reader/book.jsp`.

---

## 2. CONTROLLER – BorrowRequestServlet

### 2.1 `init()`
- **Logic:** Khởi tạo `BookDAO`, `BookCopyDAO`, `BorrowRequestDAO`.

---

### 2.2 `showBorrowForm(request, response)`
- **Logic:**
  1. Lấy `readerId` từ `session.getAttribute("readerId")`.
  2. Nếu null → `response.sendRedirect("login")`, return.
  3. Lấy `bookId` từ `request.getParameter("bookId")`.
  4. Nếu có `bookId`:
     - Parse `bookId`.
     - `book = bookDAO.getBookById(bookId)`.
     - Nếu `book != null`: `availableCopies = bookCopyDAO.countAvailableCopies(bookId)`, `setAttribute("book", book)`, `setAttribute("availableCopies", availableCopies)`.
     - Bỏ qua `NumberFormatException`.
  5. `forward` → `/view/reader/borrow.jsp`.

---

### 2.3 `createBorrowRequest(request, response)`
- **Input (POST):** `bookId[]`, `quantity[]`, `note`.
- **Logic:**
  1. Lấy `readerId` từ session; null → redirect login.
  2. Lấy `bookIds = getParameterValues("bookId")`, `quantities = getParameterValues("quantity")`, `note`.
  3. Nếu `bookIds == null` hoặc length = 0 → `setAttribute("error", "Vui lòng chọn ít nhất một cuốn sách")`, gọi `showBorrowForm()`, return.
  4. Vòng lặp từng `bookIds[i]`:
     - Parse `bookId`, `quantity` (mặc định 1).
     - `availableCopies = bookCopyDAO.countAvailableCopies(bookId)`.
     - Nếu `quantity > availableCopies` → set error, `showBorrowForm()`, return.
     - Tạo `BorrowRequestItem(bookId, quantity)`, add vào list.
     - `NumberFormatException` → set error, `showBorrowForm()`, return.
  5. Tạo `BorrowRequest`: `readerId`, `status="pending"`, `note`.
  6. Gọi `requestId = borrowRequestDAO.createBorrowRequest(borrowRequest, items)`.
  7. Nếu `requestId > 0` → set success + requestId; ngược lại set error.
  8. `forward` → `/view/reader/borrow-success.jsp`.

---

### 2.4 `listBorrowRequests(request, response)`
- **Logic:**
  1. Kiểm tra `readerId` trong session; null → redirect login.
  2. `requests = borrowRequestDAO.getBorrowRequestsByReaderId(readerId)`.
  3. `setAttribute("borrowRequests", requests)`.
  4. `forward` → `/view/reader/borrow-list.jsp`.

---

## 3. CONTROLLER – LibrarianServlet

### 3.1 `doGet(request, response)`
- **Logic:**
  1. Kiểm tra `employeeId`, `userType` trong session; không hợp lệ → `redirect("login?type=librarian")`.
  2. Lấy `action`; mặc định `"dashboard"`.
  3. `switch`: `dashboard` → `showDashboard()`, `approve` → `showApproveForm()`, `reject` → `showRejectForm()`.

---

### 3.2 `showDashboard(request, response)`
- **Logic:**
  1. `pendingRequests = borrowRequestDAO.getPendingRequests()`.
  2. Với mỗi `req`: `items = borrowRequestDAO.getBorrowRequestItems(req.getRequestId())`, `req.setRequestItems(items)`.
  3. `setAttribute("pendingRequests", pendingRequests)`.
  4. `forward` → `/view/librarian/dashboard.jsp`.

---

### 3.3 `showApproveForm(request, response)`
- **Input:** `requestId` từ param.
- **Logic:**
  1. Nếu `requestId` null/empty → redirect dashboard.
  2. Parse `requestId`.
  3. `borrowRequest = borrowRequestDAO.getBorrowRequestById(requestId)`.
  4. Nếu null hoặc status != "pending" → set error, redirect dashboard.
  5. `items = borrowRequestDAO.getBorrowRequestItems(requestId)`, `borrowRequest.setRequestItems(items)`.
  6. Với mỗi item: `book = bookDAO.getBookById(bookId)`, `availableCopies = bookCopyDAO.countAvailableCopies(bookId)`, `item.setBook(book)`, `item.setAvailableCopies(availableCopies)`.
  7. `setAttribute("borrowRequest", borrowRequest)`.
  8. `forward` → `/view/librarian/approve-request.jsp`.

---

### 3.4 `showRejectForm(request, response)`
- **Logic:** Tương tự `showApproveForm` nhưng không load book/availableCopies, chỉ set `borrowRequest` và forward → `reject-request.jsp`.

---

### 3.5 `approveRequest(request, response, employeeId)`
- **Input:** `requestId`, `employeeId`.
- **Logic:**
  1. Kiểm tra `requestId`; null/empty → set error, redirect dashboard.
  2. Parse `requestId`.
  3. `borrowRequest = borrowRequestDAO.getBorrowRequestById(requestId)`; nếu null hoặc không pending → set error, redirect dashboard.
  4. `items = borrowRequestDAO.getBorrowRequestItems(requestId)`.
  5. Với mỗi item:
     - `availableCopies = bookCopyDAO.countAvailableCopies(bookId)`.
     - Nếu `availableCopies < item.getQuantity()` → set error, redirect approve form.
     - `copies = bookCopyDAO.getAvailableCopiesByBookId(bookId)`.
     - Lấy `item.getQuantity()` phần tử đầu từ `copies`, add `copyId` vào list `copyIds`.
  6. `borrowId = borrowDAO.createBorrow(readerId, requestId, copyIds, employeeId)`.
  7. Nếu `borrowId > 0` → set success; ngược lại set error.
  8. `response.sendRedirect("librarian?action=dashboard")`.

---

### 3.6 `rejectRequest(request, response, employeeId)`
- **Input:** `requestId`, `decisionNote`.
- **Logic:**
  1. Kiểm tra `requestId`; null/empty → set error, redirect dashboard.
  2. Parse `requestId`.
  3. `success = borrowRequestDAO.rejectRequest(requestId, employeeId, decisionNote)`.
  4. Set success/error tương ứng.
  5. `redirect` → dashboard.

---

## 4. CONTROLLER – ReaderBorrowServlet

### 4.1 `showMyBorrows(request, response, readerId)`
- **Logic:**
  1. `borrows = borrowDAO.getBorrowsByReaderId(readerId)`.
  2. Với mỗi borrow: `items = borrowDAO.getBorrowItems(borrow.getBorrowId())`, `borrow.setBorrowItems(items)`.
  3. `setAttribute("borrows", borrows)`.
  4. `forward` → `/view/reader/my-borrows.jsp`.

---

### 4.2 `showReturnForm(request, response, readerId)`
- **Input:** `borrowItemId` từ param.
- **Logic:**
  1. Nếu `borrowItemId` null/empty → redirect myBorrows.
  2. Parse `borrowItemId`.
  3. `borrows = borrowDAO.getBorrowsByReaderId(readerId)`.
  4. Duyệt từng borrow và `getBorrowItems(borrowId)` để tìm `BorrowItem` có `borrowItemId` trùng.
  5. Nếu không tìm thấy → set error, redirect myBorrows.
  6. `setAttribute("borrowItem", item)`.
  7. `forward` → `/view/reader/return-book.jsp`.

---

### 4.3 `returnBook(request, response, readerId)`
- **Input:** `borrowItemId` từ POST.
- **Logic:**
  1. Kiểm tra `borrowItemId`; null/empty → set error, redirect myBorrows.
  2. Parse `borrowItemId`.
  3. `success = borrowDAO.returnBook(borrowItemId)`.
  4. Set success/error.
  5. `redirect` → `readerBorrow?action=myBorrows`.

---

## 5. DAO – BookDAO

### 5.1 `getAllBooks()`
- **Trả về:** `List<Book>`.
- **SQL:**
```sql
SELECT b.*, a.author_name, c.category_name,
       COUNT(CASE WHEN bc.status = 'available' THEN 1 END) as available_copies
FROM Book b
LEFT JOIN Author a ON b.author_id = a.author_id
LEFT JOIN Category c ON b.category_id = c.category_id
LEFT JOIN BookCopy bc ON b.book_id = bc.book_id
WHERE b.status = 'active'
GROUP BY b.book_id, ... (tất cả cột)
ORDER BY b.created_at DESC
```
- **Logic:** Duyệt `ResultSet`, map từng dòng thành `Book` (bookId, title, summary, coverUrl, authorName, categoryName, availableCopies, ...), add vào list.

---

### 5.2 `getBookById(int bookId)`
- **Input:** `bookId`.
- **Trả về:** `Book` hoặc `null`.
- **SQL:** Giống `getAllBooks` nhưng thêm `WHERE b.book_id = ?`.
- **Logic:** Nếu `rs.next()` → tạo và trả về 1 `Book`; không thì `null`.

---

### 5.3 `searchBooks(String keyword)`
- **Input:** `keyword`.
- **Trả về:** `List<Book>`.
- **SQL:** Giống `getAllBooks` nhưng thêm:
  `AND (b.title LIKE ? OR a.author_name LIKE ? OR c.category_name LIKE ?)`
  với `?` = `"%" + keyword + "%"`.

---

## 6. DAO – BookCopyDAO

### 6.1 `getAvailableCopiesByBookId(int bookId)`
- **Input:** `bookId`.
- **Trả về:** `List<BookCopy>`.
- **SQL:** `SELECT * FROM BookCopy WHERE book_id = ? AND status = 'available'`
- **Logic:** Map ResultSet → `BookCopy` (copyId, bookId, copyCode, status, createdAt).

---

### 6.2 `countAvailableCopies(int bookId)`
- **Input:** `bookId`.
- **Trả về:** `int`.
- **SQL:** `SELECT COUNT(*) as count FROM BookCopy WHERE book_id = ? AND status = 'available'`
- **Logic:** `rs.getInt("count")`; lỗi → 0.

---

### 6.3 `updateCopyStatus(int copyId, String status)`
- **SQL:** `UPDATE BookCopy SET status = ? WHERE copy_id = ?`
- **Trả về:** `true` nếu `executeUpdate() > 0`.

---

### 6.4 `getCopyById(int copyId)`
- **SQL:** `SELECT * FROM BookCopy WHERE copy_id = ?`
- **Trả về:** `BookCopy` hoặc `null`.

---

## 7. DAO – BorrowRequestDAO

### 7.1 `createBorrowRequest(BorrowRequest request, List<BorrowRequestItem> items)`
- **Input:** `request` (readerId, note), `items` (bookId, quantity).
- **Trả về:** `requestId` (int) hoặc -1 nếu lỗi.
- **Logic (transaction):**
  1. `setAutoCommit(false)`.
  2. INSERT `Borrow_Request`: `(reader_id, status='pending', requested_at=GETDATE(), note)`.
  3. Lấy `request_id` từ `getGeneratedKeys()`.
  4. Với mỗi item: `addBatch` INSERT `Borrow_Request_Item (request_id, book_id, quantity)`.
  5. `executeBatch()`.
  6. `commit()`, `setAutoCommit(true)`.
  7. Lỗi → `rollback()`, return -1.

---

### 7.2 `getBorrowRequestsByReaderId(int readerId)`
- **SQL:** `SELECT * FROM Borrow_Request WHERE reader_id = ? ORDER BY requested_at DESC`
- **Trả về:** `List<BorrowRequest>`.

---

### 7.3 `getBorrowRequestById(int requestId)`
- **SQL:** `SELECT * FROM Borrow_Request WHERE request_id = ?`
- **Trả về:** `BorrowRequest` hoặc `null`.

---

### 7.4 `getBorrowRequestItems(int requestId)`
- **SQL:** `SELECT * FROM Borrow_Request_Item WHERE request_id = ?`
- **Trả về:** `List<BorrowRequestItem>` (requestItemId, requestId, bookId, quantity).

---

### 7.5 `getPendingRequests()`
- **SQL:** `SELECT * FROM Borrow_Request WHERE status = 'pending' ORDER BY requested_at ASC`
- **Trả về:** `List<BorrowRequest>`.

---

### 7.6 `rejectRequest(int requestId, int employeeId, String decisionNote)`
- **SQL:** `UPDATE Borrow_Request SET status = 'rejected', processed_at = GETDATE(), processed_by_employee_id = ?, decision_note = ? WHERE request_id = ? AND status = 'pending'`
- **Trả về:** `true` nếu `affectedRows > 0`.

---

## 8. DAO – BorrowDAO

### 8.1 `createBorrow(int readerId, int requestId, List<Integer> copyIds, Integer approvedByEmployeeId)`
- **Input:** `readerId`, `requestId`, `copyIds`, `approvedByEmployeeId`.
- **Trả về:** `borrowId` hoặc -1.
- **Hằng số:** `DEFAULT_BORROW_DAYS = 14`.
- **Logic (transaction):**
  1. `setAutoCommit(false)`.
  2. Tính `dueDate = Calendar.getInstance() + 14 ngày`.
  3. INSERT `Borrow`: `(reader_id, request_id, borrow_date=GETDATE(), status='active', created_at=GETDATE(), approved_by_employee_id)`.
  4. Lấy `borrow_id` từ `getGeneratedKeys()`.
  5. Với mỗi `copyId` trong `copyIds`:
     - `addBatch` INSERT `Borrow_Item (borrow_id, copy_id, due_date, status='borrowed')`.
     - `addBatch` UPDATE `BookCopy SET status = 'borrowed' WHERE copy_id = ?`.
  6. `executeBatch()` cho cả hai.
  7. UPDATE `Borrow_Request SET status = 'approved', processed_at = GETDATE(), processed_by_employee_id = ? WHERE request_id = ?`.
  8. `commit()`.
  9. Lỗi → `rollback()`, return -1.

---

### 8.2 `getBorrowsByReaderId(int readerId)`
- **SQL:** `SELECT * FROM Borrow WHERE reader_id = ? ORDER BY created_at DESC`
- **Trả về:** `List<Borrow>`.

---

### 8.3 `getBorrowItems(int borrowId)`
- **SQL:** `SELECT * FROM Borrow_Item WHERE borrow_id = ?`
- **Trả về:** `List<BorrowItem>` (borrowItemId, borrowId, copyId, dueDate, returnedAt, status).

---

### 8.4 `getBorrowById(int borrowId)`
- **SQL:** `SELECT * FROM Borrow WHERE borrow_id = ?`
- **Trả về:** `Borrow` hoặc `null`.

---

### 8.5 `returnBook(int borrowItemId)`
- **Input:** `borrowItemId`.
- **Trả về:** `boolean`.
- **Logic (transaction):**
  1. `setAutoCommit(false)`.
  2. SELECT `copy_id` FROM `Borrow_Item` WHERE `borrow_item_id = ?`; không có → rollback, return false.
  3. UPDATE `Borrow_Item SET returned_at = GETDATE(), status = 'returned' WHERE borrow_item_id = ?`.
  4. UPDATE `BookCopy SET status = 'available' WHERE copy_id = ?`.
  5. `commit()`.
  6. Lỗi → `rollback()`, return false.

---

## 9. DBContext

### 9.1 Constructor
- **Logic:** Kết nối SQL Server: `jdbc:sqlserver://localhost:1433;databaseName=DigitalLibraryDB`, user `sa`, password `sa`.
- **Kết quả:** Gán `connection` cho các DAO kế thừa.
