# TÓM TẮT BUY FLOW - ĐÃ CẬP NHẬT THEO SCHEMA MỚI

## ✅ CÁC FILE ĐÃ ĐƯỢC CẬP NHẬT

### 1. MODEL CLASSES
- ✅ **Cart.java**: `userId` → `readerId`, thêm `status` (active, checked_out, abandoned)
- ✅ **CartItem.java**: Bỏ `price`, `currency`; thêm `addedAt`; giá lấy từ Book
- ✅ **Order.java**: `userId` → `readerId`; bỏ `orderNumber`, `shippingName`, `shippingAddress`, `shippingPhone`, `notes`, `updatedAt`; `status`: pending, paid, cancelled, refunded
- ✅ **OrderBook.java** (đổi từ OrderItem): Bỏ `currency`, `subtotal`; giữ `price`, `quantity`
- ✅ **Payment.java**: `transactionId` → `transactionCode`; bỏ `paymentGateway`, `currency`, `notes`; `paymentStatus`: pending, success, failed

### 2. DAO CLASSES
- ✅ **CartDAO.java**: 
  - Dùng `readerId` thay vì `userId`
  - Bảng `Cart` và `Cart_Item` (không phải `carts`, `cart_items`)
  - Thêm method `markCartAsCheckedOut()`
  - Lấy giá từ Book khi load CartItem
  
- ✅ **OrderDAO.java**:
  - Dùng `readerId` thay vì `userId`
  - Bảng `Order` và `Order_Book` (không phải `orders`, `order_items`)
  - Bỏ các tham số shipping trong `createOrder()`
  - Bỏ method `getOrderByOrderNumber()` (không còn orderNumber)
  
- ✅ **PaymentDAO.java**:
  - Dùng `transactionCode` thay vì `transactionId`
  - Bỏ tham số `currency` và `paymentGateway` trong `createPayment()`
  - Payment status: pending, success, failed

### 3. SERVLET CLASSES
- ✅ **CartServlet.java**:
  - Chỉ sử dụng Reader (bỏ Employee)
  - Tất cả methods dùng `readerId`
  
- ✅ **CheckoutServlet.java**:
  - Chỉ sử dụng Reader (bỏ Employee)
  - Bỏ form shipping (không còn xử lý shippingName, shippingAddress, shippingPhone, notes)
  - Đổi OrderItem → OrderBook
  - Payment status: "success" thay vì "completed"
  - Order status: "paid" thay vì "processing"
  - Redirect với `orderId` thay vì `orderNumber`

### 4. JSP FILES
- ✅ **checkout.jsp**:
  - Bỏ form shipping (Thông Tin Giao Hàng)
  - Bỏ form notes
  - Chỉ còn form chọn phương thức thanh toán
  - Lấy giá từ `item.getBook().getPrice()` thay vì `item.getPrice()`
  - Bỏ import Employee
  
- ✅ **success.jsp**:
  - Đổi OrderItem → OrderBook
  - Bỏ hiển thị orderNumber (thay bằng orderId)
  - Bỏ hiển thị shippingName, shippingPhone, shippingAddress
  - Thêm hiển thị ngày đặt hàng
  - Bỏ import Employee
  
- ✅ **cart.jsp**:
  - Lấy giá từ `item.getBook().getPrice()` thay vì `item.getPrice()`
  - Bỏ import Employee

### 5. SQL SCRIPT
- ✅ **create_buy_flow_tables.sql**:
  - Cập nhật để khớp với schema mới
  - Bảng: `Cart`, `Cart_Item`, `Order`, `Order_Book`, `Payment`
  - Foreign keys đúng với schema

## 📋 SCHEMA MỚI

### Cart
- `cart_id` (PK)
- `reader_id` (FK → Reader)
- `status` (active, checked_out, abandoned)
- `created_at`, `updated_at`

### Cart_Item
- `cart_item_id` (PK)
- `cart_id` (FK → Cart)
- `book_id` (FK → Book)
- `quantity`
- `added_at`
- **KHÔNG CÓ**: price, currency

### Order
- `order_id` (PK)
- `reader_id` (FK → Reader)
- `total_amount`
- `currency`
- `status` (pending, paid, cancelled, refunded)
- `created_at`
- **KHÔNG CÓ**: order_number, shipping_name, shipping_address, shipping_phone, notes, updated_at

### Order_Book
- `order_book_id` (PK)
- `order_id` (FK → Order)
- `book_id` (FK → Book)
- `quantity`
- `price`
- **KHÔNG CÓ**: currency, subtotal

### Payment
- `payment_id` (PK)
- `order_id` (FK → Order)
- `amount`
- `payment_method`
- `payment_status` (pending, success, failed)
- `transaction_code`
- `paid_at`
- `created_at`
- **KHÔNG CÓ**: currency, payment_gateway, notes

## 🔄 CÁC THAY ĐỔI CHÍNH

1. **User ID**: Tất cả `userId` → `readerId` (chỉ Reader có thể mua sách)
2. **CartItem**: Không lưu giá, lấy từ Book khi cần
3. **Order**: Đơn giản hóa, bỏ thông tin shipping
4. **OrderBook**: Thay OrderItem, không có currency/subtotal
5. **Payment**: Đơn giản hóa, chỉ có transaction_code

## ✅ CHECKLIST HOÀN THÀNH

- [x] Models đã cập nhật
- [x] DAOs đã cập nhật
- [x] Servlets đã cập nhật
- [x] JSPs đã cập nhật
- [x] SQL script đã cập nhật
- [x] Bỏ các tham chiếu đến fields đã xóa
- [x] Đổi OrderItem → OrderBook
- [x] Bỏ form shipping trong checkout
- [x] Cập nhật payment status values

## 🚀 CÁCH SỬ DỤNG

1. Chạy SQL script `create_buy_flow_tables.sql` để tạo các bảng
2. Build project trong NetBeans
3. Deploy lên Tomcat
4. Test flow: Thêm vào giỏ → Xem giỏ hàng → Checkout → Xác nhận

## ⚠️ LƯU Ý

- Chỉ Reader có thể mua sách (không phải Employee)
- Giá sách được lấy từ Book, không lưu trong CartItem
- Không còn thông tin shipping trong Order
- Payment là mock payment (tự động thành công)
