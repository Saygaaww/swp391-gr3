# HƯỚNG DẪN SELLER - DIGITAL LIBRARY

## 🎯 LOGIC CỦA SELLER TRONG HỆ THỐNG

### 1. Vai trò của Seller
**Seller** là nhân viên bán hàng trong hệ thống Digital Library, chịu trách nhiệm:
- **Quản lý sách để bán**: Thêm, sửa, xóa sách (tương tự Admin/Librarian)
- **Quản lý đơn hàng**: Xem, xử lý, cập nhật trạng thái đơn hàng
- **Theo dõi doanh thu**: Xem báo cáo bán hàng, thống kê
- **Quản lý kho**: Theo dõi số lượng sách, tồn kho

### 2. Phân biệt với các Role khác

| Role | Chức năng chính | Quyền hạn |
|------|----------------|-----------|
| **ADMIN** | Quản trị toàn hệ thống | Tất cả quyền (users, books, orders, system) |
| **LIBRARIAN** | Quản lý thư viện | Quản lý sách, mượn/trả sách, borrow requests |
| **SELLER** | Quản lý bán hàng | Quản lý sách để bán, đơn hàng, doanh thu |
| **USER/READER** | Người dùng | Mua sách, mượn sách, đọc sách |

### 3. Seller vs Librarian
- **Librarian**: Quản lý sách để **MƯỢN** (borrow flow)
- **Seller**: Quản lý sách để **BÁN** (buy flow)

---

## 🔐 CÁCH TẠO TÀI KHOẢN SELLER

### Cách 1: Sử dụng Servlet (Khuyến nghị)
1. Truy cập: `http://localhost:8080/DigitalLibrary/create-employee-accounts`
2. Servlet sẽ tự động tạo:
   - **Email**: `seller@digitallibrary.com`
   - **Password**: `seller123`
   - **Role**: SELLER

### Cách 2: Chạy SQL Script
Chạy file: `create_employee_accounts.sql`
```sql
-- Tạo tài khoản SELLER
INSERT INTO Employee (full_name, email, password_hash, status, role_id, created_at)
VALUES (
    N'Người Bán',
    'seller@digitallibrary.com',
    'hash_của_seller123', -- Cần hash từ PasswordUtil
    'active',
    (SELECT role_id FROM Role WHERE role_name = 'SELLER'),
    SYSUTCDATETIME()
);
```

### Cách 3: Tạo từ Admin Dashboard (Chưa có)
- Admin có thể tạo Seller account từ giao diện
- Form tạo Employee với role = SELLER

---

## 📋 CÁC TÍNH NĂNG SELLER NÊN CÓ

### ✅ Đã có (Đã implement):
1. ✅ **Seller Dashboard** - Trang chủ với thống kê thực tế
   - Tổng đơn hàng, đơn đã thanh toán, đơn chờ xử lý
   - Tổng doanh thu
   - SellerDashboardServlet.java
   - seller/dashboard.jsp

2. ✅ **Quản Lý Đơn Hàng (Order Management)**
   - ✅ Danh sách đơn hàng với pagination
   - ✅ Filter theo trạng thái (pending, paid, cancelled, refunded)
   - ✅ Chi tiết đơn hàng (thông tin khách hàng, danh sách sách, payment)
   - ✅ Cập nhật trạng thái đơn hàng
   - ✅ SellerOrderServlet.java
   - ✅ seller/order-list.jsp, seller/order-detail.jsp

3. ✅ **Báo Cáo Bán Hàng (Sales Report)**
   - ✅ Tổng doanh thu, tổng đơn hàng
   - ✅ Phân tích theo trạng thái (paid, pending, cancelled, refunded)
   - ✅ Tỷ lệ đơn hàng thành công
   - ✅ Doanh thu trung bình mỗi đơn
   - ✅ SellerReportServlet.java
   - ✅ seller/reports.jsp

4. ✅ **Xem Sách** - Seller có thể xem danh sách sách (chỉ xem, không sửa)

### ❌ Chưa có (Cần implement):

#### 1. Quản Lý Sách (Book Management) - QUAN TRỌNG
**Vấn đề**: Hiện tại Seller KHÔNG THỂ thêm/sửa/xóa sách vì `BookServlet.hasManagePermission()` chỉ cho phép ADMIN và LIBRARIAN.

**Cần làm**:
- ⚠️ **Thêm quyền SELLER vào BookServlet**: Sửa method `hasManagePermission()` để cho phép SELLER
- ❌ **Thêm sách mới**: Form thêm sách với đầy đủ thông tin (giá, mô tả, cover)
- ❌ **Sửa sách**: Cập nhật thông tin, giá, tồn kho
- ❌ **Xóa sách**: Soft delete (đánh dấu deleted)
- ❌ **Upload nội dung**: Upload PDF/EPUB cho sách
- ❌ **Upload cover**: Upload ảnh bìa sách

**Link**: `/books` (cần sửa BookServlet để cho phép SELLER)

#### 1.1. Workflow Phê Duyệt Sách (Book Approval Workflow) - 🔴 QUAN TRỌNG NHẤT
**Yêu cầu**: Seller có thể thêm sách, nhưng **PHẢI ĐƯỢC ADMIN DUYỆT** trước khi được phép bán.

**Workflow**:
1. **Seller tạo sách** → Trạng thái: `pending_approval` (chờ duyệt)
2. **Admin xem danh sách sách chờ duyệt** → `/admin/books/pending`
3. **Admin duyệt/từ chối** → Trạng thái: `approved` hoặc `rejected`
4. **Sách đã duyệt** → Hiển thị trên website, có thể bán
5. **Sách bị từ chối** → Seller có thể sửa và gửi lại

**Cần implement**:

**Database Changes**:
```sql
-- Thêm field approval_status vào Book table
ALTER TABLE Book ADD approval_status NVARCHAR(20) DEFAULT 'pending_approval';
-- Giá trị: pending_approval, approved, rejected

-- Thêm field approved_by (employee_id của admin duyệt)
ALTER TABLE Book ADD approved_by_employee_id INT NULL;
ALTER TABLE Book ADD FOREIGN KEY (approved_by_employee_id) REFERENCES Employee(employee_id);

-- Thêm field approval_notes (ghi chú từ admin)
ALTER TABLE Book ADD approval_notes NVARCHAR(MAX) NULL;

-- Thêm field approved_at (thời gian duyệt)
ALTER TABLE Book ADD approved_at DATETIME2 NULL;

-- Tạo index cho tìm kiếm nhanh
CREATE INDEX idx_book_approval_status ON Book(approval_status);
```

**Code Changes**:

1. **Book Model** (`src/java/model/Book.java`):
   - Thêm field: `approvalStatus`, `approvedByEmployeeId`, `approvalNotes`, `approvedAt`
   - Thêm getters/setters

2. **BookServlet** (`src/java/controller/BookServlet.java`):
   - Seller tạo sách → tự động set `approval_status = 'pending_approval'`
   - Seller sửa sách đã bị reject → reset về `pending_approval`
   - Seller KHÔNG THỂ sửa sách đã được approve (chỉ admin có thể)

3. **AdminBookApprovalServlet** (TẠO MỚI):
   - `/admin/books/pending` - Danh sách sách chờ duyệt
   - `/admin/books/approve?id=123` - Duyệt sách
   - `/admin/books/reject?id=123` - Từ chối sách (có thể thêm lý do)

4. **JSP Pages**:
   - `admin/book-pending-list.jsp` - Danh sách sách chờ duyệt
   - `admin/book-approve-form.jsp` - Form duyệt/từ chối
   - `seller/book-pending-list.jsp` - Seller xem sách của mình đang chờ duyệt

5. **BookDAO** (`src/java/dao/BookDAO.java`):
   - `getBooksByApprovalStatus(String status)` - Lấy sách theo trạng thái duyệt
   - `updateApprovalStatus(int bookId, String status, int adminId, String notes)` - Cập nhật trạng thái duyệt

6. **Logic hiển thị sách**:
   - Chỉ hiển thị sách có `approval_status = 'approved'` cho User/Reader
   - Seller xem được tất cả sách của mình (kể cả pending/rejected)
   - Admin xem được tất cả sách

**Trạng thái sách**:
- `pending_approval`: Chờ admin duyệt (Seller vừa tạo/sửa)
- `approved`: Đã được duyệt, có thể bán
- `rejected`: Bị từ chối, Seller cần sửa lại

**Link**:
- Seller: `/seller/books` - Quản lý sách của mình
- Admin: `/admin/books/pending` - Duyệt sách từ seller

#### 2. Báo Cáo Nâng Cao (Advanced Reports)
**Hiện tại chỉ có báo cáo cơ bản, cần thêm**:
- ❌ **Doanh thu theo thời gian**: Filter theo ngày/tuần/tháng/năm
- ❌ **Biểu đồ doanh thu**: Line chart, bar chart (Chart.js)
- ❌ **Top sách bán chạy**: Top 10 sách được mua nhiều nhất
- ❌ **Top khách hàng**: Khách hàng mua nhiều nhất
- ❌ **Xuất báo cáo**: Export to CSV/Excel/PDF
- ❌ **So sánh kỳ**: So sánh doanh thu giữa các kỳ
- ❌ **Phân tích xu hướng**: Tăng/giảm doanh thu theo thời gian

**Link**: `/seller/reports` (cần nâng cấp)

#### 3. Quản Lý Kho (Inventory Management)
- ❌ **Tồn kho sách**: Hiển thị số lượng sách còn lại (cần thêm field `stock` vào Book table)
- ❌ **Cảnh báo hết hàng**: Alert khi sách sắp hết (dưới ngưỡng nhất định)
- ❌ **Nhập kho**: Form thêm số lượng sách vào kho
- ❌ **Xuất kho**: Ghi nhận khi bán (tự động trừ khi order thành công)
- ❌ **Lịch sử nhập/xuất**: Theo dõi các giao dịch kho
- ❌ **Báo cáo tồn kho**: Sách nào sắp hết, sách nào đã hết

**Link**: `/seller/inventory` (cần tạo mới)

#### 4. Tìm Kiếm & Lọc Đơn Hàng Nâng Cao
**Hiện tại chỉ có filter theo status, cần thêm**:
- ❌ **Tìm kiếm**: Theo order ID, tên khách hàng, email
- ❌ **Lọc theo ngày**: Date range picker (từ ngày - đến ngày)
- ❌ **Lọc theo giá**: Đơn hàng trên/dưới một mức giá
- ❌ **Lọc theo khách hàng**: Chọn khách hàng cụ thể
- ❌ **Sắp xếp**: Theo ngày, giá, trạng thái
- ❌ **Export đơn hàng**: Xuất danh sách ra CSV/Excel

**Link**: `/seller/orders` (cần nâng cấp)

#### 5. Quản Lý Khách Hàng (Customer Management)
- ❌ **Danh sách khách hàng**: Tất cả khách hàng đã mua
- ❌ **Chi tiết khách hàng**: Thông tin, lịch sử mua hàng
- ❌ **Thống kê khách hàng**: Tổng số đơn, tổng tiền đã mua
- ❌ **Phân loại khách hàng**: VIP, thường xuyên, mới
- ❌ **Ghi chú khách hàng**: Lưu thông tin đặc biệt

**Link**: `/seller/customers` (cần tạo mới)

#### 6. Ghi Chú Đơn Hàng (Order Notes)
- ❌ **Thêm ghi chú**: Seller có thể thêm ghi chú vào đơn hàng
- ❌ **Lịch sử ghi chú**: Xem tất cả ghi chú đã thêm
- ❌ **Ghi chú nội bộ**: Chỉ seller/admin mới thấy

**Cần thêm**: Bảng `Order_Note` hoặc field `notes` trong Order table

#### 7. Thông Báo & Cảnh Báo
- ❌ **Thông báo đơn mới**: Alert khi có đơn hàng mới
- ❌ **Cảnh báo đơn chờ lâu**: Đơn pending quá lâu
- ❌ **Cảnh báo hết hàng**: Sách sắp hết trong kho
- ❌ **Dashboard notifications**: Hiển thị số thông báo chưa đọc

#### 8. Export & In Ấn
- ❌ **In đơn hàng**: Print order details
- ❌ **Export báo cáo**: CSV, Excel, PDF
- ❌ **Export danh sách đơn**: Xuất danh sách đơn hàng
- ❌ **Email báo cáo**: Tự động gửi báo cáo định kỳ

#### 9. Cài Đặt & Tùy Chỉnh
- ❌ **Cài đặt thông báo**: Bật/tắt các loại thông báo
- ❌ **Cài đặt cảnh báo kho**: Ngưỡng cảnh báo hết hàng
- ❌ **Cài đặt báo cáo**: Mặc định filter, format
- ❌ **Đổi mật khẩu**: Seller có thể đổi mật khẩu
- ❌ **Cập nhật thông tin**: Sửa tên, email

#### 10. Phân Quyền & Bảo Mật
- ❌ **Log hoạt động**: Ghi lại mọi thao tác của seller
- ❌ **Phân quyền chi tiết**: Seller có thể làm gì, không làm gì
- ❌ **Session timeout**: Tự động đăng xuất sau thời gian không hoạt động

---

## 🛠️ IMPLEMENTATION PLAN

### ✅ Phase 1: Order Management (ĐÃ HOÀN THÀNH)
1. ✅ **SellerOrderServlet** - Xử lý các action:
   - ✅ `/seller/orders` - Danh sách đơn hàng
   - ✅ `/seller/orders/view?id=123` - Chi tiết đơn hàng
   - ✅ `/seller/orders/update-status` - Cập nhật trạng thái

2. ✅ **order-list.jsp** - Hiển thị danh sách đơn hàng:
   - ✅ Table với pagination
   - ✅ Filter: status
   - ⚠️ Chưa có: Search, date range filter

3. ✅ **order-detail.jsp** - Chi tiết đơn hàng:
   - ✅ Thông tin đơn hàng
   - ✅ Danh sách sách đã mua
   - ✅ Payment information
   - ✅ Update status button

### ✅ Phase 2: Sales Report (ĐÃ HOÀN THÀNH CƠ BẢN)
1. ✅ **SellerReportServlet** - Xử lý báo cáo cơ bản
2. ✅ **reports.jsp** - Dashboard với stats
3. ❌ Chưa có: Charts (Chart.js), filter theo thời gian, top sách bán chạy

### 🔄 Phase 3: Book Management (CẦN SỬA)
1. ⚠️ **Sửa BookServlet**: Thêm quyền SELLER vào `hasManagePermission()`
2. ✅ Seller đã có thể XEM sách (book-list.jsp)
3. ❌ Seller chưa thể THÊM/SỬA/XÓA sách
4. ❌ Chưa có: Upload nội dung PDF/EPUB

### ❌ Phase 4: Inventory Management (CHƯA CÓ)
1. ❌ **InventoryServlet** - Quản lý kho
2. ❌ **inventory.jsp** - Danh sách tồn kho
3. ❌ Alert khi sách sắp hết
4. ❌ Cần thêm field `stock` vào Book table

### ❌ Phase 5: Advanced Features (CHƯA CÓ)
1. ❌ **Customer Management**: Quản lý khách hàng
2. ❌ **Advanced Reports**: Charts, filters, exports
3. ❌ **Order Notes**: Ghi chú đơn hàng
4. ❌ **Notifications**: Thông báo đơn mới, cảnh báo
5. ❌ **Export/Print**: Xuất báo cáo, in đơn hàng

---

## 📝 CẤU TRÚC DATABASE

### Bảng liên quan đến Seller:

```sql
-- Employee (đã có)
Employee (employee_id, full_name, email, password_hash, role_id, status)

-- Order (đã có)
Order (order_id, reader_id, total_amount, currency, status, created_at)

-- Order_Book (đã có)
Order_Book (order_book_id, order_id, book_id, quantity, price)

-- Payment (đã có)
Payment (payment_id, order_id, amount, payment_method, payment_status, transaction_code)

-- Book (đã có)
Book (book_id, title, price, currency, status, ...)
```

**Lưu ý**: Hiện tại chưa có bảng riêng để Seller quản lý kho. Có thể thêm:
- `Inventory` table để track số lượng
- Hoặc dùng field trong `Book` table

---

## 🔗 NAVIGATION CHO SELLER

### Sidebar Menu (seller/dashboard.jsp):
```
- Trang Chủ (/seller/dashboard) ✅ Đã có
- Xem Sách (/books) ✅ Đã có (chỉ xem, không sửa)
- Đơn Hàng (/seller/orders) ✅ Đã có
- Báo Cáo Bán Hàng (/seller/reports) ✅ Đã có (cơ bản)
- Quản Lý Kho (/seller/inventory) ❌ Chưa có
- Quản Lý Khách Hàng (/seller/customers) ❌ Chưa có
```

---

## 🚀 CÁCH SỬ DỤNG HIỆN TẠI

### Bước 1: Tạo tài khoản Seller
```
Truy cập: http://localhost:8080/DigitalLibrary/create-employee-accounts
```

### Bước 2: Đăng nhập
```
Email: seller@digitallibrary.com
Password: seller123
```

### Bước 3: Truy cập Dashboard
```
Tự động redirect đến: /seller/dashboard
```

### Bước 4: Sử dụng tính năng
- ✅ **Dashboard**: Xem thống kê tổng quan (đơn hàng, doanh thu)
- ✅ **Đơn Hàng**: Xem danh sách, chi tiết, cập nhật trạng thái
- ✅ **Báo Cáo**: Xem báo cáo bán hàng cơ bản
- ✅ **Xem Sách**: Xem danh sách sách (chỉ xem, không sửa)
- ❌ **Quản Lý Sách**: Chưa thể thêm/sửa/xóa (cần sửa BookServlet)
- ❌ **Quản Lý Kho**: Chưa có
- ❌ **Quản Lý Khách Hàng**: Chưa có

---

## 💡 ĐỀ XUẤT

### Option 1: Seller = Admin cho Buy Flow
- Seller có quyền tương tự Admin nhưng chỉ focus vào Buy Flow
- Có thể quản lý sách, đơn hàng, payment
- Không quản lý users, borrow flow

### Option 2: Seller chuyên biệt
- Seller chỉ quản lý đơn hàng và báo cáo
- Admin/Librarian quản lý sách
- Seller xem và xử lý đơn hàng từ Reader

### Option 3: Seller = Publisher/Author
- Seller là người bán sách (publisher, author)
- Có thể upload sách của mình
- Quản lý sách và đơn hàng của mình
- Cần thêm field `seller_id` vào `Book` table

---

## ❓ CÂU HỎI CẦN LÀM RÕ

1. **Seller có thể thêm/sửa sách không?**
   - Nếu có: Dùng chung BookServlet với Admin/Librarian
   - Nếu không: Chỉ xem và quản lý đơn hàng

2. **Seller quản lý đơn hàng như thế nào?**
   - Xem tất cả đơn hàng?
   - Chỉ xem đơn hàng của sách mình bán?
   - Có thể cập nhật trạng thái đơn hàng?

3. **Seller có cần quản lý kho không?**
   - Có field `stock` trong Book table không?
   - Cần track inventory riêng?

4. **Seller có thể xem doanh thu của ai?**
   - Tất cả doanh thu?
   - Chỉ doanh thu của sách mình bán?

---

## 📌 KẾT LUẬN

### ✅ Đã Hoàn Thành:
1. ✅ **Seller Dashboard** - Thống kê tổng quan
2. ✅ **Order Management** - Quản lý đơn hàng đầy đủ (list, detail, update status)
3. ✅ **Sales Report** - Báo cáo cơ bản (tổng doanh thu, phân tích trạng thái)
4. ✅ **Xem Sách** - Seller có thể xem danh sách sách

### ⚠️ Cần Sửa Ngay:
1. **Book Management**: Sửa `BookServlet.hasManagePermission()` để cho phép SELLER thêm/sửa/xóa sách
   - File: `src/java/controller/BookServlet.java`
   - Method: `hasManagePermission()` - thêm `|| "SELLER".equals(role)`

### ❌ Cần Làm Tiếp:
1. **Nâng cấp Báo Cáo**: Thêm charts, filter theo thời gian, top sách bán chạy, export
2. **Quản Lý Kho**: Thêm field `stock` vào Book table, tạo InventoryServlet
3. **Tìm kiếm đơn hàng nâng cao**: Search, date range, export
4. **Quản Lý Khách Hàng**: Danh sách, chi tiết, thống kê
5. **Ghi chú đơn hàng**: Thêm notes vào đơn hàng
6. **Thông báo**: Alert đơn mới, cảnh báo
7. **Export/Print**: Xuất báo cáo, in đơn hàng

### 📊 Tổng Kết:
- **Đã hoàn thành**: 4/10 tính năng chính (40%)
- **Cần sửa**: 1 tính năng (Book Management)
- **Cần làm**: 5+ tính năng nâng cao

**Cách tạo Seller account**: Dùng servlet `/create-employee-accounts` hoặc SQL script.

---

## 🎯 ƯU TIÊN PHÁT TRIỂN

### 🔴 Priority 1 - QUAN TRỌNG NHẤT (Làm ngay):
1. **Workflow Phê Duyệt Sách (Book Approval Workflow)** ⭐
   - Thêm field `approval_status` vào Book table
   - Seller tạo sách → status = `pending_approval`
   - Admin duyệt/từ chối sách
   - Chỉ sách `approved` mới được bán
   - **Thời gian**: 6-8 giờ
   - **Tác động**: Kiểm soát chất lượng sách, bảo vệ thương hiệu

2. **Sửa BookServlet để Seller quản lý sách**
   - File: `src/java/controller/BookServlet.java`
   - Sửa method `hasManagePermission()` dòng 480-486
   - Thêm: `|| "SELLER".equals(role)`
   - Seller tạo sách → tự động set `approval_status = 'pending_approval'`
   - **Thời gian**: 1 giờ
   - **Tác động**: Seller có thể thêm sách (chờ duyệt)

3. **Nâng cấp tìm kiếm đơn hàng**
   - Thêm search box: tìm theo order ID, tên khách hàng
   - Thêm date range picker: lọc theo khoảng thời gian
   - **Thời gian**: 2-3 giờ
   - **Tác động**: Seller tìm đơn hàng dễ dàng hơn

### 🟡 Priority 2 - QUAN TRỌNG (Làm sau Priority 1):
3. **Nâng cấp Báo Cáo với Charts**
   - Tích hợp Chart.js hoặc tương tự
   - Biểu đồ doanh thu theo thời gian (line chart)
   - Top 10 sách bán chạy (bar chart)
   - Filter theo ngày/tuần/tháng/năm
   - **Thời gian**: 4-6 giờ
   - **Tác động**: Báo cáo trực quan, dễ phân tích

4. **Quản Lý Kho (Inventory)**
   - Thêm field `stock` (INT) vào bảng `Book`
   - Tạo InventoryServlet và inventory.jsp
   - Cảnh báo khi sách sắp hết (dưới 10 cuốn)
   - Form nhập/xuất kho
   - **Thời gian**: 6-8 giờ
   - **Tác động**: Quản lý tồn kho hiệu quả

### 🟢 Priority 3 - BỔ SUNG (Làm sau):
5. **Quản Lý Khách Hàng**
   - Danh sách khách hàng đã mua
   - Chi tiết khách hàng + lịch sử mua hàng
   - Thống kê: tổng đơn, tổng tiền
   - **Thời gian**: 4-5 giờ

6. **Export & Print**
   - Export báo cáo ra CSV/Excel
   - Export danh sách đơn hàng
   - Print đơn hàng
   - **Thời gian**: 3-4 giờ

7. **Ghi Chú Đơn Hàng**
   - Thêm bảng `Order_Note` hoặc field `notes` TEXT
   - Form thêm/sửa/xóa ghi chú
   - **Thời gian**: 2-3 giờ

8. **Thông Báo**
   - Thông báo đơn hàng mới
   - Cảnh báo đơn chờ lâu
   - Cảnh báo hết hàng
   - **Thời gian**: 4-5 giờ

---

## 📝 GHI CHÚ KỸ THUẬT

### Database Changes Cần Thiết:

#### 1. Book Approval Workflow (QUAN TRỌNG NHẤT):
```sql
-- Thêm field approval_status vào Book table
ALTER TABLE Book ADD approval_status NVARCHAR(20) DEFAULT 'pending_approval';
-- Giá trị: pending_approval, approved, rejected

-- Thêm field approved_by (employee_id của admin duyệt)
ALTER TABLE Book ADD approved_by_employee_id INT NULL;
ALTER TABLE Book ADD FOREIGN KEY (approved_by_employee_id) REFERENCES Employee(employee_id);

-- Thêm field approval_notes (ghi chú từ admin)
ALTER TABLE Book ADD approval_notes NVARCHAR(MAX) NULL;

-- Thêm field approved_at (thời gian duyệt)
ALTER TABLE Book ADD approved_at DATETIME2 NULL;

-- Tạo index cho tìm kiếm nhanh
CREATE INDEX idx_book_approval_status ON Book(approval_status);

-- Update các sách hiện tại (của Admin/Librarian) → approved
UPDATE Book SET approval_status = 'approved' WHERE approval_status IS NULL;
```

#### 2. Inventory Management:
```sql
-- Thêm field stock vào Book table (nếu chưa có)
ALTER TABLE Book ADD stock INT DEFAULT 0;
```

#### 3. Order Notes:
```sql
-- Tạo bảng Order_Note (cho ghi chú đơn hàng)
CREATE TABLE Order_Note (
    note_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    employee_id INT,
    note_text NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (order_id) REFERENCES [Order](order_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);
```

#### 4. Indexes cho Performance:
```sql
-- Tạo index cho tìm kiếm nhanh
CREATE INDEX idx_order_created_at ON [Order](created_at);
CREATE INDEX idx_order_status ON [Order](status);
```

### Code Changes Cần Thiết:

#### 1. Book Approval Workflow:

**Book.java** - Thêm fields:
```java
private String approvalStatus; // pending_approval, approved, rejected
private Integer approvedByEmployeeId;
private String approvalNotes;
private LocalDateTime approvedAt;

// Getters and Setters
public String getApprovalStatus() { return approvalStatus; }
public void setApprovalStatus(String approvalStatus) { this.approvalStatus = approvalStatus; }
// ... tương tự cho các field khác
```

**BookServlet.java** (dòng 480-486):
```java
private boolean hasManagePermission(String userRole) {
    if (userRole == null) {
        return false;
    }
    String role = userRole.toUpperCase();
    return "ADMIN".equals(role) || "LIBRARIAN".equals(role) || "SELLER".equals(role);
}

// Khi Seller tạo sách mới
private void handleCreate(HttpServletRequest request, HttpServletResponse response, String userRole, Employee employee) {
    Book book = extractBookFromRequest(request);
    if (employee != null) {
        book.setCreatedByEmployeeId(employee.getEmployeeId());
        // Nếu là SELLER, set approval_status = pending_approval
        if ("SELLER".equals(userRole)) {
            book.setApprovalStatus("pending_approval");
        } else {
            // ADMIN/LIBRARIAN tự động approved
            book.setApprovalStatus("approved");
        }
    }
    // ... tạo sách
}
```

**BookDAO.java** - Thêm methods:
```java
// Lấy sách theo approval status
public List<Book> getBooksByApprovalStatus(String approvalStatus, int offset, int pageSize) throws SQLException;

// Cập nhật approval status
public boolean updateApprovalStatus(int bookId, String status, int adminId, String notes) throws SQLException;

// Đếm sách chờ duyệt
public int countPendingBooks() throws SQLException;
```

**AdminBookApprovalServlet.java** (TẠO MỚI):
```java
@WebServlet(name = "AdminBookApprovalServlet", urlPatterns = {
    "/admin/books/pending",
    "/admin/books/approve",
    "/admin/books/reject"
})
public class AdminBookApprovalServlet extends HttpServlet {
    // Xem danh sách sách chờ duyệt
    // Duyệt sách
    // Từ chối sách
}
```

#### 2. OrderDAO.java** - Thêm methods:
```java
// Tìm kiếm đơn hàng
List<Order> searchOrders(String keyword, int offset, int pageSize);
List<Order> getOrdersByDateRange(LocalDateTime start, LocalDateTime end, int offset, int pageSize);

// Top sách bán chạy
List<BookSalesStats> getTopSellingBooks(int limit, LocalDateTime startDate, LocalDateTime endDate);
```

#### 3. Thêm Chart.js vào reports.jsp**:
```html
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
```

---

## 🔍 CHECKLIST HOÀN THIỆN SELLER

### Core Features:
- [x] Dashboard với stats
- [x] Quản lý đơn hàng (list, detail, update status)
- [x] Báo cáo cơ bản
- [ ] Quản lý sách (thêm/sửa/xóa) - **CẦN SỬA BookServlet**
- [ ] Tìm kiếm đơn hàng nâng cao
- [ ] Báo cáo với charts
- [ ] Quản lý kho
- [ ] Quản lý khách hàng

### Advanced Features:
- [ ] Export báo cáo
- [ ] Print đơn hàng
- [ ] Ghi chú đơn hàng
- [ ] Thông báo
- [ ] Cài đặt seller
- [ ] Log hoạt động

### UX Improvements:
- [ ] Loading states
- [ ] Error handling tốt hơn
- [ ] Responsive design (mobile)
- [ ] Keyboard shortcuts
- [ ] Dark mode (optional)
