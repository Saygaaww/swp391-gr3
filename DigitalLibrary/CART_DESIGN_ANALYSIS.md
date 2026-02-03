# Phân Tích Thiết Kế Cart: Seller vs User - Đánh Giá Tính Hợp Lý

## 1. THIẾT KẾ HIỆN TẠI

### 1.1 Kiến Trúc Hiện Tại

```
┌─────────────────────────────────────────────────────────┐
│                    THIẾT KẾ HIỆN TẠI                     │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  USER (Reader)                                           │
│  ├─ CartServlet                                          │
│  ├─ CheckoutServlet                                      │
│  └─ Cart của chính Reader đó                             │
│     └─ readerId từ session.getAttribute("reader")       │
│                                                           │
│  SELLER (Employee)                                       │
│  ├─ SellerCartServlet                                    │
│  ├─ SellerCheckoutServlet                                │
│  └─ Cart của KHÁCH HÀNG (Reader)                         │
│     └─ readerId từ session.getAttribute(                │
│        "sellerSelectedReaderId")                         │
│                                                           │
│  CẢ HAI DÙNG CHUNG:                                      │
│  ├─ CartDAO (cùng bảng Cart, Cart_Item)                  │
│  ├─ Model Cart, CartItem                                │
│  └─ Database: Cart(reader_id), Cart_Item                │
│                                                           │
└─────────────────────────────────────────────────────────┘
```

### 1.2 Đặc Điểm Thiết Kế

**Điểm chung:**
- Cùng bảng `Cart` và `Cart_Item` trong database
- Cùng `CartDAO` để truy cập dữ liệu
- Cùng model `Cart` và `CartItem`
- Cart luôn gắn với `reader_id` (không có cart của Seller)

**Điểm khác biệt:**
- **User**: `readerId` lấy từ session của chính Reader đăng nhập
- **Seller**: `readerId` lấy từ session `sellerSelectedReaderId` (khách hàng đã chọn)
- Seller phải chọn khách hàng trước (`/seller/cart/select-customer`)
- Seller có servlet riêng (`SellerCartServlet`, `SellerCheckoutServlet`)

---

## 2. ĐÁNH GIÁ TÍNH HỢP LÝ

### 2.1 ✅ ƯU ĐIỂM

#### a) **Đơn giản và nhất quán về dữ liệu**
- ✅ Chỉ có một bảng `Cart` duy nhất, không phân biệt User hay Seller
- ✅ Logic nghiệp vụ rõ ràng: Cart luôn thuộc về Reader (người mua)
- ✅ Không có dữ liệu trùng lặp hoặc phức tạp

#### b) **Phân quyền rõ ràng**
- ✅ Seller không có cart riêng → Tránh nhầm lẫn
- ✅ Seller chỉ quản lý cart của khách → Đúng nghiệp vụ bán hàng
- ✅ User chỉ thấy và quản lý cart của chính mình

#### c) **Tái sử dụng code tốt**
- ✅ `CartDAO` được dùng chung cho cả User và Seller
- ✅ Model `Cart`, `CartItem` không cần duplicate
- ✅ Logic validation, stock check giống nhau

#### d) **Phù hợp với mô hình POS (Point of Sale)**
- ✅ Seller chọn khách → Thêm sách → Checkout → Tạo đơn cho khách
- ✅ Giống mô hình bán hàng tại cửa hàng: nhân viên quét mã, khách thanh toán

---

### 2.2 ⚠️ NHƯỢC ĐIỂM VÀ VẤN ĐỀ

#### a) **Phụ thuộc Session - Rủi ro mất dữ liệu**
```java
// SellerCartServlet.java - Dòng 195
session.setAttribute("sellerSelectedReaderId", readerId);
```
- ❌ Nếu Seller đóng trình duyệt hoặc session timeout → Mất selection
- ❌ Seller không thể "lưu tạm" giỏ hàng đang làm dở
- ❌ Nếu Seller đăng nhập trên nhiều tab → Có thể nhầm lẫn khách hàng

#### b) **Không có cơ chế "Draft Cart" hoặc "Temporary Cart"**
- ❌ Seller đang thêm sách cho khách A → Chuyển sang khách B → Giỏ khách A bị mất context
- ❌ Không có lịch sử "đang làm việc với khách nào"
- ❌ Không thể "tạm dừng" một giao dịch để làm giao dịch khác

#### c) **Trùng lặp code giữa CartServlet và SellerCartServlet**
```java
// CartServlet.handleAddToCart() - Dòng 127-234
// SellerCartServlet.handleAddToCart() - Dòng 207-231
// Logic gần như giống nhau, chỉ khác cách lấy readerId
```
- ⚠️ Code duplication → Khó maintain
- ⚠️ Nếu sửa validation ở một nơi, phải nhớ sửa nơi kia

#### d) **Thiếu audit trail cho Seller**
- ❌ Không biết Seller nào đã thêm sách vào giỏ của khách
- ❌ Không có log "Seller X đã thêm Book Y vào giỏ của Reader Z"
- ❌ Khó trace khi có vấn đề

#### e) **Vấn đề đồng thời (Concurrency)**
- ❌ Reader đang tự thêm sách vào giỏ → Seller đồng thời thêm sách khác → Có thể conflict
- ❌ Không có lock mechanism cho cart
- ❌ Stock check có thể race condition

#### f) **Thiếu tính năng "Cart Template" hoặc "Quick Add"**
- ❌ Seller không thể lưu "giỏ hàng mẫu" để add nhanh cho nhiều khách
- ❌ Không có "favorites" hoặc "recent items" cho Seller

---

## 3. SO SÁNH VỚI CÁC MÔ HÌNH THIẾT KẾ KHÁC

### 3.1 MÔ HÌNH 1: Cart riêng cho Seller (KHÔNG NÊN)

```
┌─────────────────────────────────────────┐
│  Seller có cart riêng (seller_cart_id)  │
│  Khi checkout → Copy sang cart của khách│
└─────────────────────────────────────────┘
```

**Nhược điểm:**
- ❌ Phức tạp: Phải copy items từ seller_cart sang customer_cart
- ❌ Dữ liệu trùng lặp
- ❌ Không phù hợp: Seller không "mua", chỉ "bán"

**Kết luận:** ❌ **KHÔNG NÊN** - Thiết kế hiện tại tốt hơn

---

### 3.2 MÔ HÌNH 2: Cart có thêm field `seller_id` (ĐÁNG XEM XÉT)

```sql
ALTER TABLE Cart ADD COLUMN seller_id INT NULL;
-- seller_id = NULL → User tự mua
-- seller_id = X → Seller X đang bán cho khách
```

**Ưu điểm:**
- ✅ Audit trail: Biết Seller nào đã thêm sách
- ✅ Có thể query "Các cart đang được Seller X quản lý"
- ✅ Có thể thêm tính năng "Chuyển giao" giữa các Seller

**Nhược điểm:**
- ⚠️ Phức tạp hơn một chút
- ⚠️ Cần migration database

**Kết luận:** ✅ **NÊN XEM XÉT** - Cải thiện audit và traceability

---

### 3.3 MÔ HÌNH 3: Cart có status "draft" và "active" (ĐÁNG XEM XÉT)

```sql
-- Cart.status: 'active', 'draft', 'checked_out', 'abandoned'
-- Seller có thể tạo nhiều draft carts cho nhiều khách
```

**Ưu điểm:**
- ✅ Seller có thể làm việc với nhiều khách cùng lúc
- ✅ Có thể "tạm dừng" một giao dịch
- ✅ Không mất dữ liệu khi session timeout

**Nhược điểm:**
- ⚠️ Phức tạp hơn: Phải quản lý nhiều carts
- ⚠️ UI phức tạp hơn: Phải chọn "cart nào" đang làm việc

**Kết luận:** ⚠️ **TÙY YÊU CẦU** - Chỉ cần nếu Seller thường xuyên làm việc với nhiều khách đồng thời

---

### 3.4 MÔ HÌNH 4: Shared Service Layer (REFACTOR CODE)

```java
// Tạo CartService chung
public class CartService {
    public void addToCart(int readerId, int bookId, int quantity) {
        // Logic chung
    }
}

// CartServlet và SellerCartServlet chỉ gọi CartService
```

**Ưu điểm:**
- ✅ Loại bỏ code duplication
- ✅ Dễ maintain: Sửa một chỗ, áp dụng cho cả hai
- ✅ Dễ test: Test logic ở CartService

**Nhược điểm:**
- ⚠️ Cần refactor code hiện tại

**Kết luận:** ✅ **NÊN LÀM** - Cải thiện code quality

---

## 4. KHUYẾN NGHỊ

### 4.1 ✅ THIẾT KẾ HIỆN TẠI LÀ HỢP LÝ

**Lý do:**
1. ✅ Phù hợp với nghiệp vụ: Cart luôn thuộc về người mua (Reader)
2. ✅ Đơn giản, dễ hiểu, dễ maintain
3. ✅ Không có dữ liệu trùng lặp
4. ✅ Phù hợp với mô hình POS truyền thống

### 4.2 🔧 CẢI THIỆN ĐỀ XUẤT

#### **Ưu tiên CAO:**

**1. Thêm `seller_id` vào Cart (nếu có Seller thao tác)**
```sql
ALTER TABLE Cart ADD COLUMN seller_id INT NULL;
ALTER TABLE Cart ADD CONSTRAINT FK_Cart_Seller 
    FOREIGN KEY (seller_id) REFERENCES Employee(employee_id);
```
- Mục đích: Audit trail, biết Seller nào đã thêm sách
- Khi nào: Khi Seller thêm sách → set `seller_id`
- Khi User tự thêm → `seller_id = NULL`

**2. Refactor: Tạo CartService để loại bỏ code duplication**
```java
public class CartService {
    private CartDAO cartDAO;
    private BookDAO bookDAO;
    
    public CartResult addToCart(int readerId, int bookId, int quantity, Integer sellerId) {
        // Validation chung
        // Stock check chung
        // Add to cart
        // Return result với message/error
    }
}
```

#### **Ưu tiên TRUNG BÌNH:**

**3. Thêm CartActivityLog để tracking**
```sql
CREATE TABLE Cart_Activity_Log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    cart_id INT NOT NULL,
    activity_type NVARCHAR(50), -- 'add', 'update', 'remove', 'clear'
    book_id INT NULL,
    quantity INT NULL,
    seller_id INT NULL, -- NULL nếu User tự làm
    reader_id INT NOT NULL,
    created_at DATETIME2 DEFAULT SYSUTCDATETIME()
);
```
- Mục đích: Audit trail chi tiết
- Khi nào: Mỗi thao tác add/update/remove đều log

**4. Cải thiện session management cho Seller**
- Lưu `sellerSelectedReaderId` vào database thay vì chỉ session
- Hoặc thêm "Recent Customers" để Seller dễ chọn lại

#### **Ưu tiên THẤP:**

**5. Thêm tính năng "Draft Cart" nếu cần**
- Chỉ nếu Seller thường xuyên làm việc với nhiều khách đồng thời
- Nếu không → Không cần thiết

---

## 5. KẾT LUẬN

### ✅ **THIẾT KẾ HIỆN TẠI LÀ HỢP LÝ VÀ PHÙ HỢP**

**Điểm mạnh:**
- Đơn giản, rõ ràng, dễ hiểu
- Phù hợp với nghiệp vụ bán hàng
- Không có dữ liệu trùng lặp
- Dễ maintain và mở rộng

**Điểm cần cải thiện:**
- Thêm `seller_id` vào Cart để có audit trail
- Refactor code để loại bỏ duplication
- Cải thiện session management cho Seller

**Không nên:**
- ❌ Tạo cart riêng cho Seller (phức tạp, không cần thiết)
- ❌ Thay đổi cấu trúc database lớn (hiện tại đã tốt)

---

## 6. SO SÁNH TỔNG QUAN

| Tiêu chí | Thiết kế hiện tại | Cart riêng Seller | Cart có seller_id |
|----------|-------------------|-------------------|-------------------|
| **Độ phức tạp** | ⭐⭐ Thấp | ⭐⭐⭐⭐ Cao | ⭐⭐⭐ Trung bình |
| **Phù hợp nghiệp vụ** | ⭐⭐⭐⭐⭐ Rất tốt | ⭐⭐ Kém | ⭐⭐⭐⭐ Tốt |
| **Audit trail** | ⭐⭐ Kém | ⭐⭐⭐ Trung bình | ⭐⭐⭐⭐⭐ Rất tốt |
| **Code maintainability** | ⭐⭐⭐ Tốt | ⭐⭐ Kém | ⭐⭐⭐ Tốt |
| **Performance** | ⭐⭐⭐⭐⭐ Rất tốt | ⭐⭐⭐ Trung bình | ⭐⭐⭐⭐ Tốt |
| **Tổng điểm** | **18/25** | **13/25** | **20/25** |

**Kết luận:** Thiết kế hiện tại **đã tốt**, nhưng nếu thêm `seller_id` vào Cart sẽ **tốt hơn**.

---

*Tài liệu phân tích thiết kế Cart - Digital Library Project*
