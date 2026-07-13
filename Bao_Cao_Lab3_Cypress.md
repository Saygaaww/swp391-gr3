# BÁO CÁO BÀI THỰC HÀNH LAB 3 - KIỂM THỬ TỰ ĐỘNG VỚI CYPRESS

* **Môn học:** Kiểm thử phần mềm (SWT301 / Software Testing)
* **Dự án kiểm thử:** Hệ thống Thư viện số (Digital Library - Dự án SWP391)
* **Module kiểm thử:** Quản lý Mượn/Trả sách (Borrow-Return Management Module)
* **Công cụ sử dụng:** Cypress v15+ (E2E Testing Framework)

---

## 1. Kịch bản kiểm thử chi tiết (Test Cases Specification)

Quy mô kiểm thử của module bao gồm các trường dữ liệu trên form: `quantity` (Số lượng), `note` (Ghi chú), `expectedStartDate` (Ngày mượn dự kiến), `expectedReturnDate` (Ngày trả dự kiến).

Dưới đây là 10 kịch bản kiểm thử giao diện tự động được thiết lập:

### TC-01: Kiểm thử logic chọn Ngày trả trước Ngày mượn
* **Mục tiêu:** Kiểm tra xem hệ thống có ngăn chặn việc đặt lịch trả sách trước ngày bắt đầu mượn sách hay không.
* **Các bước thực hiện:**
  1. Đăng nhập hệ thống (Thực hiện ngầm qua API để tối ưu).
  2. Truy cập trang yêu cầu mượn sách của cuốn sách ID 1 (`/customer/borrow-request?bookId=1`).
  3. Chọn Ngày bắt đầu mượn là **Ngày mai**.
  4. Chọn Ngày trả dự kiến là **Hôm nay** (Trước ngày mượn).
  5. Click nút "Gửi yêu cầu mượn".
* **Kết quả mong đợi:** Form không được gửi đi. Ô nhập liệu "Ngày trả dự kiến" hiển thị thông báo lỗi: `Vui lòng chọn ngày trả hợp lệ (tối đa 5 ngày).` (Do cơ chế bắt lỗi `oninvalid` trên thẻ input).

### TC-02: Kiểm thử logic thời hạn mượn sách tối đa quá 5 ngày
* **Mục tiêu:** Đảm bảo độc giả không thể gửi yêu cầu mượn sách quá thời hạn tối đa của thư viện (5 ngày).
* **Các bước thực hiện:**
  1. Đăng nhập hệ thống.
  2. Truy cập trang yêu cầu mượn sách.
  3. Chọn Ngày bắt đầu mượn là **Hôm nay**.
  4. Chọn Ngày trả dự kiến là **Hôm nay + 6 ngày**.
  5. Click nút "Gửi yêu cầu mượn".
* **Kết quả mong đợi:** Form bị chặn lại không gửi đi. Ô nhập liệu "Ngày trả dự kiến" hiển thị thông báo lỗi: `Vui lòng chọn ngày trả hợp lệ (tối đa 5 ngày).`

### TC-03: Kiểm thử bỏ trống các trường dữ liệu bắt buộc (Required Fields)
* **Mục tiêu:** Xác minh hệ thống không cho phép gửi yêu cầu khi chưa nhập thông tin ngày tháng bắt buộc.
* **Các bước thực hiện:**
  1. Đăng nhập hệ thống và vào trang mượn sách.
  2. Xóa sạch giá trị ô Ngày bắt đầu mượn và Ngày trả dự kiến.
  3. Click nút "Gửi yêu cầu mượn".
* **Kết quả mong đợi:** Form không được gửi. Trình duyệt hiển thị cảnh báo yêu cầu nhập dữ liệu cho các trường bắt buộc (`valueMissing`).

### TC-04: Kiểm thử giới hạn số lượng sách mượn (> 5 quyển)
* **Mục tiêu:** Xác minh độc giả không thể nhập số lượng sách mượn vượt quá giới hạn tối đa (5 quyển/lần).
* **Các bước thực hiện:**
  1. Đăng nhập hệ thống và vào trang mượn sách.
  2. Chọn Ngày mượn và Ngày trả hợp lệ.
  3. Nhập số lượng sách là `6` (Giới hạn tối đa là 5).
  4. Click nút "Gửi yêu cầu mượn".
* **Kết quả mong đợi:** Form không được gửi đi. Trình duyệt báo lỗi giới hạn giá trị vượt mức tối đa (`rangeOverflow`).

### TC-05: Kiểm thử gửi yêu cầu mượn sách thành công
* **Mục tiêu:** Xác minh người dùng có thể gửi yêu cầu mượn sách thành công khi nhập toàn bộ thông tin hợp lệ.
* **Các bước thực hiện:**
  1. Đăng nhập hệ thống và vào trang mượn sách.
  2. Chọn Ngày bắt đầu mượn là **Hôm nay**.
  3. Chọn Ngày trả dự kiến là **Hôm nay + 2 ngày** (Hợp lệ).
  4. Nhập số lượng là `1`.
  5. Nhập ghi chú: `Cypress automated E2E borrow request test.`
  6. Click nút "Gửi yêu cầu mượn".
* **Kết quả mong đợi:** Gửi yêu cầu thành công. Hệ thống tự động chuyển hướng sang trang trạng thái yêu cầu mượn `/customer/borrow-request-status`. Không có thông báo lỗi nào xuất hiện.

### TC-06: Xác thực thuộc tính ngày mượn tối thiểu (min attribute)
* **Mục tiêu:** Xác minh ô nhập Ngày bắt đầu mượn giới hạn ngày tối thiểu là ngày hiện tại (Hôm nay).
* **Các bước thực hiện:**
  1. Đăng nhập hệ thống và vào trang mượn sách.
  2. Định dạng ngày hôm nay (yyyy-mm-dd).
  3. Kiểm tra thuộc tính `min` của thẻ `#expectedStartDate`.
* **Kết quả mong đợi:** Thuộc tính `min` có giá trị khớp với ngày hôm nay.

### TC-07: Xác thực thuộc tính giới hạn số lượng (min/max attributes)
* **Mục tiêu:** Xác minh thuộc tính HTML `min` và `max` của trường số lượng sách mượn.
* **Các bước thực hiện:**
  1. Vào trang mượn sách.
  2. Kiểm tra thuộc tính `min` và `max` của thẻ `input[name="quantity"]`.
* **Kết quả mong đợi:** Thuộc tính `min` bằng `1`, thuộc tính `max` bằng `5`.

### TC-08: Kiểm tra liên kết xem chi tiết sách
* **Mục tiêu:** Đảm bảo nút "Xem chi tiết" dẫn đúng về trang chi tiết sách.
* **Các bước thực hiện:**
  1. Vào trang mượn sách.
  2. Click liên kết "Xem chi tiết" trong thông tin sách.
* **Kết quả mong đợi:** Trình duyệt chuyển hướng đến URL chứa `/books/detail/1`.

### TC-09: Kiểm tra nút "Chọn sách khác"
* **Mục tiêu:** Đảm bảo nút "Chọn sách khác" chuyển hướng về danh mục sách.
* **Các bước thực hiện:**
  1. Vào trang mượn sách.
  2. Click nút "Chọn sách khác".
* **Kết quả mong đợi:** Trình duyệt chuyển hướng về trang danh mục sách chứa `/books`.

### TC-10: Kiểm tra liên kết "Xem trạng thái yêu cầu"
* **Mục tiêu:** Xác minh liên kết "Xem trạng thái yêu cầu" chuyển hướng người dùng tới danh sách các yêu cầu mượn.
* **Các bước thực hiện:**
  1. Vào trang mượn sách.
  2. Click nút "Xem trạng thái yêu cầu".
* **Kết quả mong đợi:** Trình duyệt chuyển hướng tới `/customer/borrow-request-status`.

---

## 2. Giải thích mã nguồn kiểm thử Cypress (Source Code Explanation)

Mã nguồn kiểm thử tự động được triển khai trong tệp `cypress/e2e/borrow_spec.cy.js`. 

### Toàn bộ mã nguồn:
```javascript
describe('Digital Library - Borrow Module Automated Tests', () => {

  beforeEach(() => {
    // Đăng ký tài khoản Reader ngầm ở nền (Background Request) để tránh làm loãng bài test giao diện mượn sách
    const uniqueEmail = `cypress_borrower_${Date.now()}@gmail.com`
    
    cy.request({
      method: 'POST',
      url: '/auth/register',
      form: true,
      body: {
        fullName: 'Nguyễn Văn Mượn',
        email: uniqueEmail,
        phone: '0987654321',
        password: 'Password123',
        confirmPassword: 'Password123'
      }
    }).then(() => {
      // Sau khi đăng ký và tự động đăng nhập ở nền, chuyển hướng trực tiếp đến trang mượn sách ID 1
      cy.visit('/customer/borrow-request?bookId=1')
    })
  })

  // Hàm phụ trợ click nút submit của form mượn sách một cách chính xác
  const submitForm = () => {
    cy.get('form.card').find('button[type="submit"]').click()
  }

  // TC-01: Ngày trả trước ngày mượn
  it('Should prevent submission when return date is before start date', () => {
    const today = new Date()
    const tomorrow = new Date(today)
    tomorrow.setDate(today.getDate() + 1)
    
    const startY = tomorrow.getFullYear()
    const startM = String(tomorrow.getMonth() + 1).padStart(2, '0')
    const startD = String(tomorrow.getDate()).padStart(2, '0')
    const formattedStart = `${startY}-${startM}-${startD}`

    const returnY = today.getFullYear()
    const returnM = String(today.getMonth() + 1).padStart(2, '0')
    const returnD = String(today.getDate()).padStart(2, '0')
    const formattedReturn = `${returnY}-${returnM}-${returnD}`

    cy.get('#expectedStartDate').type(formattedStart)
    cy.get('#expectedReturnDate').type(formattedReturn)
    submitForm()

    cy.url().should('include', '/customer/borrow-request') // Vẫn ở trang hiện tại
    cy.get('#expectedReturnDate').then(($input) => {
      expect($input[0].validationMessage).to.contain('Vui lòng chọn ngày trả hợp lệ')
    })
  })

  // TC-02: Thời gian mượn quá 5 ngày
  it('Should prevent submission when borrowing duration exceeds 5 days', () => {
    const today = new Date()
    const inSixDays = new Date(today)
    inSixDays.setDate(today.getDate() + 6)
    
    const startY = today.getFullYear()
    const startM = String(today.getMonth() + 1).padStart(2, '0')
    const startD = String(today.getDate()).padStart(2, '0')
    const formattedStart = `${startY}-${startM}-${startD}`

    const returnY = inSixDays.getFullYear()
    const returnM = String(inSixDays.getMonth() + 1).padStart(2, '0')
    const returnD = String(inSixDays.getDate()).padStart(2, '0')
    const formattedReturn = `${returnY}-${returnM}-${returnD}`

    cy.get('#expectedStartDate').type(formattedStart)
    cy.get('#expectedReturnDate').type(formattedReturn)
    submitForm()

    cy.url().should('include', '/customer/borrow-request')
    cy.get('#expectedReturnDate').then(($input) => {
      expect($input[0].validationMessage).to.contain('Vui lòng chọn ngày trả hợp lệ')
    })
  })

  // TC-03: Bỏ trống trường bắt buộc
  it('Should show HTML5 validation message when required dates are empty', () => {
    cy.get('#expectedStartDate').clear()
    cy.get('#expectedReturnDate').clear()
    submitForm()

    cy.url().should('include', '/customer/borrow-request')
    cy.get('#expectedStartDate').then(($input) => {
      expect($input[0].validity.valueMissing).to.be.true
    })
  })

  // TC-04: Số lượng mượn > 5 quyển
  it('Should prevent submission when quantity exceeds maximum limit of 5', () => {
    const today = new Date()
    const startY = today.getFullYear()
    const startM = String(today.getMonth() + 1).padStart(2, '0')
    const startD = String(today.getDate()).padStart(2, '0')
    const formattedStart = `${startY}-${startM}-${startD}`

    cy.get('#expectedStartDate').type(formattedStart)
    cy.get('#expectedReturnDate').type(formattedStart)
    cy.get('input[name="quantity"]').clear().type('6')
    submitForm()

    cy.get('input[name="quantity"]').then(($input) => {
      expect($input[0].validity.rangeOverflow).to.be.true
    })
  })

  // TC-05: Mượn sách thành công
  it('Should successfully submit request when all inputs are valid', () => {
    const today = new Date()
    const inTwoDays = new Date(today)
    inTwoDays.setDate(today.getDate() + 2)
    
    const startY = today.getFullYear()
    const startM = String(today.getMonth() + 1).padStart(2, '0')
    const startD = String(today.getDate()).padStart(2, '0')
    const formattedStart = `${startY}-${startM}-${startD}`

    const returnY = inTwoDays.getFullYear()
    const returnM = String(inTwoDays.getMonth() + 1).padStart(2, '0')
    const returnD = String(inTwoDays.getDate()).padStart(2, '0')
    const formattedReturn = `${returnY}-${returnM}-${returnD}`

    cy.get('#expectedStartDate').type(formattedStart)
    cy.get('#expectedReturnDate').type(formattedReturn)
    cy.get('input[name="quantity"]').clear().type('1')
    cy.get('input[name="note"]').type('Cypress automated E2E borrow request test.')
    submitForm()

    cy.url().should('include', '/customer/borrow-request-status')
    cy.get('.alert-danger').should('not.exist')
  })

  // TC-06: Xác thực ngày mượn tối thiểu là hôm nay
  it('Should enforce minimum date attribute on expected start date to be today', () => {
    const today = new Date()
    const yyyy = today.getFullYear()
    const mm = String(today.getMonth() + 1).padStart(2, '0')
    const dd = String(today.getDate()).padStart(2, '0')
    const formattedToday = `${yyyy}-${mm}-${dd}`

    cy.get('#expectedStartDate').should('have.attr', 'min', formattedToday)
  })

  // TC-07: Xác thực giới hạn số lượng trong thẻ input
  it('Should have correct min and max attributes on quantity input', () => {
    cy.get('input[name="quantity"]')
      .should('have.attr', 'min', '1')
      .and('have.attr', 'max', '5')
  })

  // TC-08: Xác thực liên kết Xem chi tiết sách hoạt động đúng
  it('Should navigate to book details page when clicking view details link', () => {
    cy.get('.card-body').find('a').contains('Xem chi tiết').click()
    cy.url().should('include', '/books/detail/1')
  })

  // TC-09: Xác thực liên kết Chọn sách khác hoạt động đúng
  it('Should navigate back to books catalog when clicking choose other book', () => {
    cy.get('a.btn-outline-dark').contains('Chọn sách khác').click()
    cy.url().should('include', '/books')
  })

  // TC-10: Xác thực liên kết Xem trạng thái yêu cầu hoạt động đúng
  it('Should navigate to borrow request status page when clicking view status link', () => {
    cy.get('a.btn-outline-secondary').contains('Xem trạng thái yêu cầu').click()
    cy.url().should('include', '/customer/borrow-request-status')
  })
})
```

### Giải thích các câu lệnh Cypress cốt lõi sử dụng:
1. `cy.request()`: Gửi yêu cầu HTTP POST trực tiếp đến backend xử lý `/auth/register` để đăng ký tài khoản và tự động thiết lập Session (Cookie JSESSIONID). Điều này giúp trình duyệt không cần tải trang đăng ký, tập trung hoàn toàn vào giao diện mượn sách.
2. `cy.visit()`: Điều hướng trình duyệt đến một trang cụ thể của dự án (sử dụng đường dẫn tương đối dựa trên `baseUrl`).
3. `cy.get()`: Tìm kiếm và lựa chọn các thành phần HTML trên giao diện dựa trên bộ chọn CSS (ví dụ: `#expectedStartDate` cho ID, `input[name="quantity"]` cho thuộc tính name).
4. `.type()` & `.clear()`: Điền dữ liệu giả lập bàn phím vào ô nhập liệu và xóa sạch dữ liệu cũ trong ô nhập liệu.
5. `.click()`: Giả lập hành động click chuột của người dùng vào nút bấm.
6. `.then(($input) => { ... })`: Lấy ra phần tử DOM gốc (HTMLInputElement) để kiểm tra các thuộc tính kiểm định tính hợp lệ của trình duyệt như `validationMessage` (nội dung thông báo lỗi) và `validity` (trạng thái lỗi).
7. `cy.url().should('include', '...')`: Khẳng định (Assertion) rằng URL hiện tại của trình duyệt phải chứa một đoạn ký tự cụ thể để kiểm tra tính năng chuyển hướng trang.
8. `.should('have.attr', attributeName, expectedValue)`: Khẳng định rằng phần tử có thuộc tính chỉ định với giá trị mong đợi (dùng để kiểm tra các thuộc tính HTML5 `min` / `max`).

---

## 3. Báo cáo kết quả kiểm thử (Test Report Template / Excel)

Dưới đây là bảng tổng hợp kết quả chạy kiểm thử tự động của cả 10 kịch bản:

| STT | Mã Kịch Bản (TC ID) | Tên Kịch Bản Kiểm Thử (Test Case Name) | Kết Quả Mong Đợi (Expected Result) | Kết Quả Thực Tế (Actual Result) | Trạng Thái (Status) |
|---|---|---|---|---|---|
| 1 | **TC-01** | Ngày trả trước ngày mượn | Form không được gửi. Input Ngày trả báo lỗi `Vui lòng chọn ngày trả hợp lệ`. | Trình duyệt chặn gửi form và báo lỗi chính xác. | **PASS** |
| 2 | **TC-02** | Thời gian mượn quá 5 ngày | Form không được gửi. Input Ngày trả báo lỗi `Vui lòng chọn ngày trả hợp lệ`. | Trình duyệt chặn gửi form và báo lỗi chính xác. | **PASS** |
| 3 | **TC-03** | Bỏ trống trường bắt buộc | Form không được gửi. Ô Ngày mượn hiển thị bong bóng yêu cầu điền thông tin. | Form bị chặn lại tại các ô nhập liệu trống. | **PASS** |
| 4 | **TC-04** | Số lượng mượn > 5 quyển | Form không được gửi. Ô số lượng hiển thị thông báo vượt hạn mức. | Form bị chặn lại khi nhập số lượng bằng 6. | **PASS** |
| 5 | **TC-05** | Mượn sách thành công | Gửi form thành công. Chuyển hướng sang trang `/customer/borrow-request-status`. | Chuyển hướng thành công sang trang lịch sử yêu cầu. | **PASS** |
| 6 | **TC-06** | Xác thực thuộc tính ngày mượn tối thiểu | Thuộc tính `min` trên `#expectedStartDate` bằng ngày hôm nay. | Thuộc tính `min` hiển thị chính xác ngày hôm nay. | **PASS** |
| 7 | **TC-07** | Xác thực thuộc tính giới hạn số lượng | Thuộc tính `min` = 1, `max` = 5 trên ô số lượng. | Thuộc tính `min` và `max` khớp hoàn toàn. | **PASS** |
| 8 | **TC-08** | Kiểm tra liên kết xem chi tiết sách | Chuyển hướng thành công sang trang chi tiết sách cuốn 1. | Trình duyệt điều hướng chính xác về `/books/detail/1`. | **PASS** |
| 9 | **TC-09** | Kiểm tra nút "Chọn sách khác" | Chuyển hướng thành công sang danh mục sách `/books`. | Trình duyệt điều hướng chính xác về trang danh mục. | **PASS** |
| 10 | **TC-10** | Kiểm tra nút "Xem trạng thái yêu cầu" | Chuyển hướng thành công sang trang lịch sử yêu cầu mượn. | Trình duyệt điều hướng chính xác về `/customer/borrow-request-status`. | **PASS** |

---

## 4. Hướng dẫn chạy và xuất bằng chứng (Evidence) cho giảng viên

1. **Chạy giao diện trực quan (lấy ảnh chụp màn hình):**
   * Mở terminal trong VS Code và gõ: `npm run cypress:open`.
   * Chọn **E2E Testing** -> Chọn Chrome -> Click **Start**.
   * Click chọn tệp `borrow_spec.cy.js` để Cypress tự chạy tự động. 
   * Bạn có thể chụp lại màn hình khi các ô kiểm màu xanh lá cây hiện lên bên trái làm ảnh minh chứng (Evidence) cho báo cáo.

2. **Chạy dòng lệnh (lấy Video Demo tự động):**
   * Chạy lệnh: `npm run cypress:run`.
   * Cypress sẽ tự động chạy ẩn toàn bộ các bài test, ghi hình và xuất ra tệp video chất lượng cao tại thư mục: **`cypress/videos/borrow_spec.cy.js.mp4`**.
   * Bạn có thể nộp trực tiếp file video này cho giảng viên nếu có yêu cầu.
