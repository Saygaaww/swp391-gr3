# Phân Tích Chi Tiết Chức Năng Add to Cart và Cart

## Tổng Quan Dự Án

Dự án **Digital Library** là ứng dụng web Java Servlet/JSP quản lý thư viện số, hỗ trợ mua bán sách. Hệ thống có **2 luồng giỏ hàng** chính:

1. **Cart cho Reader (Người đọc)** - Người dùng tự thêm sách vào giỏ và thanh toán
2. **Cart cho Seller (Người bán)** - Nhân viên bán hàng chọn khách hàng và thêm sách vào giỏ thay cho khách

---

## 1. Kiến Trúc và Cấu Trúc File

### 1.1 Các File Liên Quan

| Thành phần | File | Mô tả |
|------------|------|-------|
| **Controller - Reader** | `src/java/controller/CartServlet.java` | Xử lý giỏ hàng của người đọc |
| **Controller - Seller** | `src/java/controller/SellerCartServlet.java` | Xử lý giỏ hàng khi Seller bán cho khách |
| **DAO** | `src/java/dao/CartDAO.java` | Truy cập dữ liệu Cart, Cart_Item |
| **Model** | `src/java/model/Cart.java` | Entity giỏ hàng |
| **Model** | `src/java/model/CartItem.java` | Entity item trong giỏ |
| **View - Reader** | `web/cart/cart.jsp` | Giao diện giỏ hàng người đọc |
| **View - Seller** | `web/seller/cart.jsp` | Giao diện giỏ hàng Seller |
| **View - Add** | `web/books/book-detail.jsp` | Trang chi tiết sách có nút "Thêm vào giỏ" |
| **View - Select Customer** | `web/seller/select-customer.jsp` | Chọn khách hàng (Seller) |

### 1.2 Cơ Sở Dữ Liệu

- **Bảng Cart**: `cart_id`, `reader_id`, `status` (active/checked_out/abandoned), `created_at`, `updated_at`
- **Bảng Cart_Item**: `cart_item_id`, `cart_id`, `book_id`, `quantity`, `added_at`
- **Ràng buộc**: Mỗi (cart_id, book_id) là duy nhất - thêm cùng sách sẽ cập nhật quantity

---

## 2. Luồng Business (Business Flow)

### 2.1 Luồng Reader - Tự Mua Sách

```
[Reader đăng nhập] 
    → [Xem danh sách sách] 
    → [Vào trang chi tiết sách] 
    → [Nhấn "Thêm Vào Giỏ Hàng"] 
    → [Hệ thống validate: đăng nhập, sách tồn tại, còn hàng, số lượng]
    → [Thêm vào Cart của Reader]
    → [Redirect về trang sách hoặc /cart với message thành công]
    → [Reader vào /cart xem giỏ]
    → [Cập nhật số lượng / Xóa item / Xóa giỏ]
    → [Thanh toán → Checkout]
```

### 2.2 Luồng Seller - Bán Cho Khách

```
[Seller đăng nhập với role SELLER]
    → [Vào /seller/cart]
    → [Chưa chọn khách → Redirect /seller/cart/select-customer]
    → [Tìm kiếm/Chọn khách hàng (Reader)]
    → [Lưu readerId vào session: sellerSelectedReaderId]
    → [Redirect /seller/cart - hiển thị giỏ của khách]
    → [Vào /books xem sách → Nhấn "Thêm (Bán)"]
    → [Thêm vào Cart của khách đã chọn]
    → [Cập nhật/Xóa item trong giỏ]
    → [Checkout → Tạo đơn cho khách]
```

---

## 3. Luồng Xử Lý Chi Tiết (Processing Flow)

### 3.1 ADD TO CART - Reader

| Bước | File | Hàm/Method | Mô tả |
|------|------|------------|-------|
| 1 | `web/books/book-detail.jsp` | Form POST | Form gửi POST đến `/cart/add` với `bookId`, `quantity`, `redirect` |
| 2 | `CartServlet.java` | `doPost()` | Nhận request, kiểm tra session và Reader |
| 3 | `CartServlet.java` | `handleAddToCart(request, response, readerId)` | Xử lý logic thêm vào giỏ |
| 4 | `CartServlet.handleAddToCart` | Validation | Kiểm tra bookId, quantity (1-999), book tồn tại, status, stock |
| 5 | `CartDAO.java` | `getOrCreateCart(readerId)` | Lấy hoặc tạo Cart cho reader |
| 6 | `CartDAO.java` | `getCartItem(cartId, bookId)` | Kiểm tra sách đã có trong giỏ chưa |
| 7 | `CartServlet.handleAddToCart` | Stock check | totalQuantity = existing + new; nếu > stock → redirect lỗi |
| 8 | `CartDAO.java` | `addToCart(cartId, bookId, quantity)` | INSERT hoặc UPDATE Cart_Item |
| 9 | `CartServlet.handleAddToCart` | Redirect | Thành công → redirect + `message=added_to_cart`; Thất bại → `error=add_to_cart_failed` |

**Hiển thị kết quả:**
- Thành công: `book-detail.jsp` hiển thị alert màu xanh "Đã thêm sách vào giỏ hàng thành công!"
- Lỗi: `book-detail.jsp` hiển thị alert đỏ với nội dung tương ứng (out_of_stock, insufficient_stock, book_not_found, add_to_cart_failed)

### 3.2 ADD TO CART - Seller

| Bước | File | Hàm/Method | Mô tả |
|------|------|------------|-------|
| 1 | `web/books/book-detail.jsp` | Form POST | Nếu `userRole == "SELLER"` → POST `/seller/cart/add` |
| 2 | `SellerCartServlet.java` | `doPost()` | Kiểm tra Employee + role SELLER |
| 3 | `SellerCartServlet.java` | `handleAddToCart()` | Lấy `sellerSelectedReaderId` từ session |
| 4 | `SellerCartServlet.handleAddToCart` | Validation | Nếu chưa chọn khách → redirect select-customer |
| 5 | `CartDAO.java` | `getOrCreateCart(selectedReaderId)` | Giỏ của khách đã chọn |
| 6 | `CartDAO.java` | `addToCart(cartId, bookId, quantity)` | Thêm vào giỏ |
| 7 | Redirect | `/seller/cart?message=added_to_cart` | Về trang giỏ Seller |

### 3.3 XEM GIỎ HÀNG - GET /cart

| Bước | File | Hàm/Method | Mô tả |
|------|------|------------|-------|
| 1 | `CartServlet.java` | `doGet()` | Kiểm tra session, Reader |
| 2 | `CartServlet.doGet` | Path check | `/cart/remove` qua GET → handleRemoveFromCart |
| 3 | `CartDAO.java` | `getOrCreateCart(readerId)` | Lấy Cart kèm items |
| 4 | `CartServlet.doGet` | `request.setAttribute("cart", cart)` | Gán cart vào request |
| 5 | `CartServlet.doGet` | `forward("/cart/cart.jsp")` | Chuyển đến JSP |
| 6 | `web/cart/cart.jsp` | JSP render | Hiển thị danh sách CartItem, tổng tiền, nút Thanh toán |

### 3.4 CẬP NHẬT SỐ LƯỢNG - POST /cart/update

| Bước | File | Hàm/Method | Mô tả |
|------|------|------------|-------|
| 1 | `web/cart/cart.jsp` | JavaScript `updateQuantity()` | Tạo form ẩn POST đến `/cart/update` |
| 2 | `CartServlet.java` | `handleUpdateCart()` | Nhận cartItemId, quantity |
| 3 | Validation | cartItemId, quantity (0-999) | 0 = xóa item |
| 4 | Security | `getCartItemById` + `getCartById` | Đảm bảo cartItem thuộc reader hiện tại |
| 5 | `CartDAO.java` | `updateCartItemQuantity()` hoặc `removeCartItem()` | Cập nhật DB |
| 6 | Redirect | `/cart?message=cart_updated` | Về trang giỏ |

### 3.5 XÓA ITEM - POST /cart/remove

| Bước | File | Hàm/Method | Mô tả |
|------|------|------------|-------|
| 1 | `web/cart/cart.jsp` | Form POST hoặc link + confirm | Gửi cartItemId |
| 2 | `CartServlet.java` | `handleRemoveFromCart()` | Validate + kiểm tra quyền |
| 3 | `CartDAO.java` | `removeCartItem(cartItemId)` | DELETE FROM Cart_Item |
| 4 | Redirect | `/cart?message=item_removed` | Về trang giỏ |

### 3.6 XÓA TOÀN BỘ GIỎ - POST /cart/clear

| Bước | File | Hàm/Method | Mô tả |
|------|------|------------|-------|
| 1 | `SellerCartServlet` / `CartServlet` | `handleClearCart()` | Chỉ Seller có nút này trong cart |
| 2 | `CartDAO.java` | `clearCart(cartId)` | DELETE FROM Cart_Item WHERE cart_id = ? |
| 3 | Redirect | `/cart?message=cart_cleared` | Về trang giỏ |

---

## 4. Validation Chi Tiết

### 4.1 Add to Cart - Reader (CartServlet.handleAddToCart)

| Validation | Điều kiện | Redirect khi lỗi |
|------------|-----------|------------------|
| bookId | Không null, không rỗng | `/books?error=missing_book_id` |
| bookId | Parse được Integer | `/books?error=invalid_book_id` |
| quantity | Mặc định 1, parse được Integer | `/books/view?id=X&error=invalid_quantity` |
| quantity | 1 ≤ quantity ≤ 999 | `quantity_too_small` / `quantity_too_large` |
| Book | Tồn tại (getBookById) | `/books?error=book_not_found` |
| Book | status != "deleted" | `/books?error=book_deleted` |
| Book | stock > 0 (nếu có stock) | `out_of_stock` |
| Stock | totalQuantity (existing + new) ≤ stock | `insufficient_stock&available=X&in_cart=Y` |
| CartDAO.addToCart | Trả về true | `add_to_cart_failed` |

### 4.2 Update Cart (CartServlet.handleUpdateCart)

| Validation | Điều kiện | Redirect khi lỗi |
|------------|-----------|------------------|
| cartItemId | Không null | `missing_cart_item_id` |
| quantity | Không null | `missing_quantity` |
| cartItemId | Parse Integer | `invalid_cart_item_id` |
| quantity | Parse Integer | `invalid_quantity` |
| quantity | 0 ≤ quantity ≤ 999 | `quantity_invalid` / `quantity_too_large` |
| CartItem | Tồn tại | `cart_item_not_found` |
| Security | cart.readerId == readerId | `unauthorized` |
| Book | Còn tồn tại, chưa xóa | Xóa item + `book_deleted&message=item_removed` |
| Stock | quantity ≤ book.stock | `insufficient_stock&available=X` |

### 4.3 CartDAO.addToCart (Tầng DAO)

| Validation | Điều kiện | Trả về |
|------------|-----------|--------|
| quantity | 0 < quantity ≤ 999 | false nếu vi phạm |
| Existing item | Đã có (cart_id, book_id) | Gọi updateCartItemQuantity thay vì INSERT |
| New quantity | existing + new ≤ 999 | Capped at 999 |

---

## 5. URL Mapping và Routing

| URL | Method | Servlet | Hàm xử lý |
|-----|--------|---------|-----------|
| `/cart` | GET | CartServlet | doGet → getOrCreateCart → forward cart.jsp |
| `/cart/add` | POST | CartServlet | handleAddToCart |
| `/cart/update` | POST | CartServlet | handleUpdateCart |
| `/cart/remove` | GET/POST | CartServlet | handleRemoveFromCart |
| `/cart/clear` | POST | CartServlet | handleClearCart |
| `/seller/cart` | GET | SellerCartServlet | handleViewCart |
| `/seller/cart/select-customer` | GET | SellerCartServlet | handleSelectCustomer |
| `/seller/cart/select-customer` | POST | SellerCartServlet | handleSetCustomer |
| `/seller/cart/add` | POST | SellerCartServlet | handleAddToCart |
| `/seller/cart/update` | POST | SellerCartServlet | handleUpdateCart |
| `/seller/cart/remove` | POST | SellerCartServlet | handleRemoveFromCart |
| `/seller/cart/clear` | POST | SellerCartServlet | handleClearCart |

---

## 6. Năm Câu Hỏi và Câu Trả Lời

### Câu 1: Khi người dùng nhấn "Thêm Vào Giỏ Hàng" trên trang chi tiết sách, request được gửi đến đâu và xử lý như thế nào?

**Trả lời:**  
Request được gửi qua **POST** đến URL `/cart/add` (Reader) hoặc `/seller/cart/add` (Seller). 

- **Reader**: Form trong `book-detail.jsp` (dòng 371-378) gửi `bookId`, `quantity=1`, `redirect=/books/view?id=X`. `CartServlet.doPost()` gọi `handleAddToCart()`, validate toàn bộ, gọi `CartDAO.addToCart()`, sau đó redirect về trang sách với `message=added_to_cart` hoặc về `/books` với `error=add_to_cart_failed`.
- **Seller**: Form gửi đến `/seller/cart/add`. `SellerCartServlet` lấy `sellerSelectedReaderId` từ session, gọi `CartDAO.addToCart()` cho giỏ của khách đó, redirect về `/seller/cart?message=added_to_cart`.

---

### Câu 2: Tại sao khi thêm cùng một cuốn sách nhiều lần, giỏ hàng không tạo ra nhiều dòng Cart_Item mà chỉ tăng quantity?

**Trả lời:**  
Trong `CartDAO.addToCart()` (dòng 108-117), trước khi INSERT mới, code gọi `getCartItem(cartId, bookId)` để kiểm tra sách đã có trong giỏ chưa. Nếu đã có (`existingItem != null`), thay vì INSERT, nó gọi `updateCartItemQuantity(existingItem.getCartItemId(), newQuantity)` với `newQuantity = existingItem.getQuantity() + quantity`. Ngoài ra, bảng `Cart_Item` có UNIQUE INDEX trên `(cart_id, book_id)` nên database cũng đảm bảo không có 2 dòng trùng (cart_id, book_id).

---

### Câu 3: Khi Reader chưa đăng nhập mà truy cập /cart hoặc thêm vào giỏ, hệ thống xử lý thế nào?

**Trả lời:**  
- **GET /cart**: Trong `CartServlet.doGet()` (dòng 42-54), nếu `session == null` hoặc `reader == null`, servlet gọi `response.sendRedirect(contextPath + "/login?redirect=" + URLEncoder.encode("/cart", "UTF-8"))` để chuyển về trang đăng nhập, kèm tham số `redirect` để sau khi đăng nhập xong có thể quay lại `/cart`.
- **POST /cart/add**: Tương tự, nếu chưa đăng nhập thì redirect về `/login` (không có redirect vì POST). Trên giao diện `book-detail.jsp`, nút "Thêm Vào Giỏ Hàng" chỉ hiển thị khi `!isGuest` (dòng 361), nên khách không thấy nút nếu chưa đăng nhập.

---

### Câu 4: Sự khác biệt giữa Cart của Reader và Cart của Seller là gì?

**Trả lời:**  
- **Reader Cart**: Gắn với `readerId` của chính người đăng nhập. Reader tự thêm sách, tự xem giỏ, tự thanh toán. Dùng `CartServlet`, view `web/cart/cart.jsp`.
- **Seller Cart**: Seller chọn khách hàng (Reader) qua `/seller/cart/select-customer`, lưu `readerId` vào session `sellerSelectedReaderId`. Mọi thao tác add/update/remove/clear đều thao tác trên giỏ của khách đó. Dùng `SellerCartServlet`, view `web/seller/cart.jsp`. Seller không có giỏ riêng; họ quản lý giỏ thay mặt khách.

---

### Câu 5: Khi cập nhật số lượng trong giỏ (nút +/- hoặc nhập trực tiếp), luồng xử lý từ frontend đến backend diễn ra như thế nào?

**Trả lời:**  
1. **Frontend** (`web/cart/cart.jsp`): JavaScript `updateQuantity(cartItemId, newQuantity)` được gọi khi nhấn nút +/- hoặc blur/Enter trên input.
2. **Validation client**: Kiểm tra `newQuantity` (1-999 hoặc theo stock), nếu < 1 thì hỏi xóa và gọi `removeCartItem()`.
3. **Submit**: Hàm `submitUpdateForm()` tạo form ẩn với `action=POST`, `action=update`, `cartItemId`, `quantity`, rồi `form.submit()`.
4. **Backend**: `CartServlet.doPost()` nhận request, gọi `handleUpdateCart()`. Validate cartItemId, quantity, kiểm tra cartItem thuộc reader, kiểm tra book còn tồn tại và stock. Gọi `CartDAO.updateCartItemQuantity()` (hoặc `removeCartItem` nếu quantity=0).
5. **Redirect**: `response.sendRedirect("/cart?message=cart_updated")` hoặc tham số lỗi tương ứng.

---

## 7. Sơ Đồ Luồng Tổng Quan

```
                    [book-detail.jsp]
                           |
              +------------+------------+
              |                         |
         Reader (user)              Seller (employee)
              |                         |
         POST /cart/add           POST /seller/cart/add
              |                         |
         CartServlet              SellerCartServlet
              |                         |
         handleAddToCart          handleAddToCart
              |                         |
         readerId from             selectedReaderId
         session (Reader)          from session
              |                         |
              +------------+------------+
                           |
                    CartDAO.addToCart()
                           |
                    getOrCreateCart()
                    getCartItem() → update or INSERT
                           |
                    Redirect với message/error
```

---

*Tài liệu được tạo từ phân tích mã nguồn dự án Digital Library.*
