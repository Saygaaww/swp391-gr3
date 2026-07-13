# BÁO CÁO LAB 4: KIỂM THỬ HỘP ĐEN (BLACKBOX TESTING)
**Dự án:** Hệ thống Thư viện số (Digital Library - SWP391)

---

## MỤC LỤC
1. [Nhiệm vụ chung: Template Test Case Nhóm](#nhiệm-vụ-chung-template-test-case-nhóm)
2. [Thành viên 1: Chức năng Đăng ký tài khoản (Register)](#thành-viên-1-chức-năng-đăng-ký-tài-khoản-register)
3. [Thành viên 2: Chức năng Thêm/Sửa Sách (Book Form)](#thành-viên-2-chức-năng-thêmsửa-sách-book-form)
4. [Thành viên 3: Chức năng Quản lý Độc giả (Reader Form)](#thành-viên-3-chức-năng-quản-lý-độc-giả-reader-form)
5. [Thành viên 4: Chức năng Cập nhật Hồ sơ (Edit Profile)](#thành-viên-4-chức-năng-cập-nhật-hồ-sơ-edit-profile)
6. [Thành viên 5: Chức năng Yêu cầu Mượn Sách (Borrow Request)](#thành-viên-5-chức-năng-yêu-cầu-mượn-sách-borrow-request)

---

## NHIỆM VỤ CHUNG: TEMPLATE TEST CASE NHÓM
Dưới đây là mẫu Test Case chuẩn được cả nhóm thống nhất sử dụng để thiết kế kịch bản kiểm thử:

| STT | Test Case ID | Test Scenario (Kịch bản/Mục tiêu) | Preconditions (Điều kiện tiên quyết) | Test Steps (Các bước thực hiện) | Test Data (Dữ liệu thử) | Expected Result (Kết quả mong đợi) | Actual Result (Thực tế) | Status | Defect ID |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| 1 | `[Mã TC]` | `[Mô tả mục tiêu test]` | `[Trạng thái hệ thống/Dữ liệu có sẵn]` | `[1. Bước 1...]`<br>`[2. Bước 2...]` | `[Giá trị nhập vào]` | `[Kết quả đúng phải hiển thị/xử lý]` | *(Bỏ trống để điền khi chạy test)* | Pass/Fail | *(Nếu Fail)* |

> Các thành viên sẽ điền kết quả vào cột **Actual Result**, **Status** và **Defect ID** sau khi chạy thử trực tiếp trên ứng dụng web thực tế.

---

## THÀNH VIÊN 1: CHỨC NĂNG ĐĂNG KÝ TÀI KHOẢN (REGISTER)

### 1.1. Yêu cầu giao diện (Mockup Requirements)
Chức năng đăng ký tài khoản mới (`/auth/register.jsp`) bao gồm các ràng buộc:
*   **Trường Text:**
    *   **Họ và tên:** Độ dài từ 5 đến 50 ký tự.
    *   **Email:** Phải đúng định dạng chuẩn (`*@*.*`).
*   **Trường Number (Text giới hạn số):**
    *   **Số điện thoại:** Chỉ chứa chữ số, độ dài chính xác 10 ký tự.
*   **Trường List/Checkbox:**
    *   **Vai trò (Role):** Dropdown có 3 tùy chọn (Độc giả, Thủ thư, Người bán).
*   **2 Quy tắc nghiệp vụ (Business Rules) thay thế cho trường Date:**
    *   **BR1:** Mật khẩu và Xác nhận mật khẩu phải khớp nhau hoàn toàn.
    *   **BR2:** Email đăng ký không được phép trùng lặp với bất kỳ tài khoản nào đã có trong hệ thống.

### 1.2. Phân tích kiểm thử (Analysis Test)
Sử dụng kỹ thuật Phân vùng tương đương (EP) và Phân tích giá trị biên (BVA):
*   **Họ và tên (5-50 ký tự):**
    *   *Biên (BVA):* 4 (Fail), 5 (Pass), 50 (Pass), 51 (Fail).
*   **Số điện thoại (10 số):**
    *   *EP:* Chứa chữ cái/ký tự đặc biệt (Fail), <10 số (Fail), đúng 10 số (Pass), >10 số (Fail).

### 1.3. Thiết kế Test Cases
| STT | Test Case ID | Test Scenario | Preconditions | Test Steps | Test Data | Expected Result | Status |
|:---|:---|:---|:---|:---|:---|:---|:---|
| 1 | `TC_REG_01` | Đăng ký thành công với dữ liệu hợp lệ | Database hoạt động | 1. Mở trang Đăng ký<br>2. Nhập thông tin<br>3. Chọn Vai trò<br>4. Nhấn Đăng ký | Name: `Nguyen Van A`<br>Email: `test1@gmail.com`<br>Phone: `0123456789`<br>Role: `Độc giả`<br>Pass: `123456`, Confirm: `123456` | Form submit thành công, chuyển hướng trang Login. | |
| 2 | `TC_REG_02` | Test biên giới hạn dưới của Họ và tên (4 ký tự) | | 1. Mở trang Đăng ký<br>2. Nhập thông tin<br>3. Nhấn Đăng ký | Name: `Nguy`<br>(Các trường khác hợp lệ) | Hiển thị lỗi: "Họ tên phải từ 5-50 ký tự." Form bị chặn. | |
| 3 | `TC_REG_03` | Lỗi độ dài số điện thoại (< 10 số) | | 1. Mở trang Đăng ký<br>2. Nhập thông tin<br>3. Nhấn Đăng ký | Phone: `012345678`<br>(Các trường khác hợp lệ) | Hiển thị lỗi: "Số điện thoại phải đủ 10 số." Form bị chặn. | |
| 4 | `TC_REG_04` | Vi phạm Business Rule (Xác nhận mật khẩu sai) | | 1. Mở trang Đăng ký<br>2. Nhập thông tin<br>3. Nhấn Đăng ký | Pass: `123456`<br>Confirm: `1234567` | Hiển thị lỗi: "Mật khẩu xác nhận không khớp." | |
| 5 | `TC_REG_05` | Vi phạm Business Rule (Email đã tồn tại) | Đã có user `admin@gmail.com` | 1. Mở trang Đăng ký<br>2. Nhập thông tin<br>3. Nhấn Đăng ký | Email: `admin@gmail.com` | Hiển thị lỗi: "Email đã được sử dụng, vui lòng chọn email khác." | |

---

## THÀNH VIÊN 2: CHỨC NĂNG THÊM/SỬA SÁCH (BOOK FORM)

### 2.1. Yêu cầu giao diện (Mockup Requirements)
Chức năng quản lý kho sách dành cho Admin/Thủ thư (`/admin/book-form.jsp`):
*   **Trường Text:**
    *   **Tên sách:** Từ 5 đến 200 ký tự. Không được để trống.
*   **Trường Number:**
    *   **Giá tiền (Price):** Phải nằm trong khoảng 10,000 đến 5,000,000 VNĐ.
*   **Trường Date:**
    *   **Ngày xuất bản (Publication Date):** Phải lớn hơn `01/01/1900` và không được lớn hơn (vượt quá) ngày hiện tại.
*   **Trường List/Checkbox:**
    *   **Thể loại (Category):** Bảng danh sách chọn nhiều (Multi-select) với ít nhất 4 lựa chọn (CNTT, Văn học, Kinh tế, Lịch sử). Phải chọn ít nhất 1.

### 2.2. Phân tích kiểm thử (Analysis Test)
*   **Giá tiền (10,000 - 5,000,000):**
    *   *Biên (BVA):* 9,999 (Fail), 10,000 (Pass), 5,000,000 (Pass), 5,000,001 (Fail).
*   **Ngày xuất bản:**
    *   *EP:* Quá khứ < 1900 (Fail), 1900 -> Hôm nay (Pass), Tương lai (Fail).

### 2.3. Thiết kế Test Cases
| STT | Test Case ID | Test Scenario | Preconditions | Test Steps | Test Data | Expected Result | Status |
|:---|:---|:---|:---|:---|:---|:---|:---|
| 1 | `TC_BOK_01` | Thêm sách mới thành công | Đăng nhập quyền Admin | 1. Vào trang Thêm Sách<br>2. Nhập thông tin<br>3. Nhấn Lưu | Tên: `Sách KTPM`<br>Giá: `150000`<br>Ngày XB: `01/01/2023`<br>Thể loại: `CNTT` | Thông báo "Thêm sách thành công", sách hiện trên danh sách. | |
| 2 | `TC_BOK_02` | Test biên giới hạn dưới Giá tiền (9,999 VNĐ) | Đăng nhập quyền Admin | 1. Vào trang Thêm Sách<br>2. Nhập Giá tiền<br>3. Nhấn Lưu | Giá: `9999`<br>(Các trường khác hợp lệ) | Lỗi: "Giá tiền phải từ 10,000 VNĐ trở lên." | |
| 3 | `TC_BOK_03` | Lỗi Ngày xuất bản ở tương lai | Đăng nhập quyền Admin | 1. Vào trang Thêm Sách<br>2. Nhập Ngày xuất bản<br>3. Nhấn Lưu | Ngày XB: Ngày mai (ví dụ: `01/01/2099`) | Lỗi: "Ngày xuất bản không được lớn hơn ngày hiện tại." | |
| 4 | `TC_BOK_04` | Lỗi không chọn Thể loại sách (List item) | Đăng nhập quyền Admin | 1. Vào trang Thêm Sách<br>2. Bỏ qua ô Thể loại<br>3. Nhấn Lưu | Thể loại: Để trống | Lỗi: "Vui lòng chọn ít nhất 1 thể loại." | |

---

## THÀNH VIÊN 3: CHỨC NĂNG QUẢN LÝ ĐỘC GIẢ (READER FORM)

### 3.1. Yêu cầu giao diện (Mockup Requirements)
Chức năng tạo thẻ độc giả mới (`/admin/reader-form.jsp`):
*   **Trường Text:**
    *   **CCCD/CMND:** Độ dài 12 chữ số.
*   **Trường Number:**
    *   **Số tiền cọc ban đầu (Deposit):** Yêu cầu nạp tối thiểu 50,000 VNĐ và tối đa 10,000,000 VNĐ.
*   **Trường Date:**
    *   **Ngày hết hạn thẻ (Expiry Date):** Bắt buộc phải là ngày ở tương lai (lớn hơn ngày hiện tại).
*   **Trường List/Checkbox:**
    *   **Loại thẻ (Membership Type):** Radio button chọn 1 trong 4 loại (Standard, Silver, Gold, VIP).

### 3.2. Phân tích kiểm thử (Analysis Test)
*   **Tiền cọc (50,000 - 10,000,000):**
    *   *Biên (BVA):* 49,999 (Fail), 50,000 (Pass), 10,000,000 (Pass), 10,000,001 (Fail).
*   **Ngày hết hạn:**
    *   *Biên (BVA):* Hôm qua (Fail), Hôm nay (Fail), Ngày mai (Pass).

### 3.3. Thiết kế Test Cases
| STT | Test Case ID | Test Scenario | Preconditions | Test Steps | Test Data | Expected Result | Status |
|:---|:---|:---|:---|:---|:---|:---|:---|
| 1 | `TC_RDR_01` | Tạo thẻ độc giả hợp lệ | Đăng nhập quyền Admin | 1. Mở trang Tạo thẻ<br>2. Nhập thông tin<br>3. Nhấn Lưu | CCCD: `001234567890`<br>Tiền cọc: `100000`<br>Hết hạn: [Ngày mai]<br>Loại thẻ: `VIP` | Thông báo "Tạo thẻ độc giả thành công." | |
| 2 | `TC_RDR_02` | Tiền cọc vượt quá giới hạn tối đa | Đăng nhập quyền Admin | 1. Mở trang Tạo thẻ<br>2. Nhập số tiền<br>3. Nhấn Lưu | Tiền cọc: `10000001` | Lỗi: "Số tiền cọc không được vượt quá 10,000,000 VNĐ." | |
| 3 | `TC_RDR_03` | Lỗi Ngày hết hạn bằng với ngày hiện tại | Đăng nhập quyền Admin | 1. Mở trang Tạo thẻ<br>2. Nhập Ngày hết hạn<br>3. Nhấn Lưu | Ngày hết hạn: [Hôm nay] | Lỗi: "Ngày hết hạn phải lớn hơn ngày hiện tại." | |
| 4 | `TC_RDR_04` | CCCD thiếu số lượng ký tự | Đăng nhập quyền Admin | 1. Mở trang Tạo thẻ<br>2. Nhập CCCD<br>3. Nhấn Lưu | CCCD: `00123456789` (11 số) | Lỗi: "CCCD phải đúng 12 chữ số." | |

---

## THÀNH VIÊN 4: CHỨC NĂNG CẬP NHẬT HỒ SƠ (EDIT PROFILE)

### 4.1. Yêu cầu giao diện (Mockup Requirements)
Người dùng cập nhật thông tin cá nhân (`/customer/profile.jsp`):
*   **Trường Text:**
    *   **Địa chỉ:** Từ 10 đến 200 ký tự.
*   **Trường Date:**
    *   **Ngày sinh (Date of Birth):** Khách hàng phải đủ 15 tuổi (Ngày sinh <= Hiện tại - 15 năm).
*   **Trường List/Checkbox:**
    *   **Giới tính (Gender):** Radio có 3 lựa chọn (Nam, Nữ, Khác).
*   **2 Quy tắc nghiệp vụ (Business Rules) thay thế trường Number:**
    *   **BR1:** Số điện thoại nhập mới không được trùng với bất kỳ User nào khác trong hệ thống.
    *   **BR2:** Nếu có nhập trường "Đổi mật khẩu", mật khẩu cũ phải khớp với database.

### 4.2. Phân tích kiểm thử (Analysis Test)
*   **Ngày sinh (Độ tuổi >= 15):**
    *   *EP/BVA:* Tuổi 14 (Fail), Tuổi 15 (Pass). Giả sử hiện tại là 2026, ngày sinh phải <= 2011.
*   **Quy tắc số điện thoại (Unique):**
    *   *EP:* SĐT đã tồn tại (Fail), SĐT chưa tồn tại (Pass).

### 4.3. Thiết kế Test Cases
| STT | Test Case ID | Test Scenario | Preconditions | Test Steps | Test Data | Expected Result | Status |
|:---|:---|:---|:---|:---|:---|:---|:---|
| 1 | `TC_PRO_01` | Cập nhật hồ sơ thành công | Đã đăng nhập Reader | 1. Vào trang Profile<br>2. Nhập dữ liệu<br>3. Nhấn Cập nhật | Địa chỉ: `123 Đường A, TPHCM`<br>Ngày sinh: `01/01/2000`<br>Giới tính: `Nam` | Thông báo "Cập nhật hồ sơ thành công", tải lại trang thấy dữ liệu mới. | |
| 2 | `TC_PRO_02` | Lỗi chưa đủ 15 tuổi | Đã đăng nhập Reader | 1. Vào trang Profile<br>2. Sửa Ngày sinh<br>3. Nhấn Cập nhật | Ngày sinh: Chọn ngày để tuổi = 14 | Lỗi: "Bạn phải đủ 15 tuổi để sử dụng dịch vụ." | |
| 3 | `TC_PRO_03` | Vi phạm BR1: SĐT bị trùng | Đã có SĐT `0999999999` trong DB | 1. Vào trang Profile<br>2. Đổi Số điện thoại<br>3. Nhấn Cập nhật | SĐT mới: `0999999999` | Lỗi: "Số điện thoại này đã được tài khoản khác sử dụng." | |
| 4 | `TC_PRO_04` | Vi phạm BR2: Nhập sai mật khẩu cũ | Đã đăng nhập Reader | 1. Vào trang Profile<br>2. Điền Form đổi mật khẩu<br>3. Nhấn Cập nhật | Pass cũ: `SaiPass123`<br>Pass mới: `NewPass123` | Lỗi: "Mật khẩu cũ không chính xác." | |

---

## THÀNH VIÊN 5: CHỨC NĂNG YÊU CẦU MƯỢN SÁCH (BORROW REQUEST)

### 5.1. Yêu cầu giao diện (Mockup Requirements)
Màn hình Độc giả tạo yêu cầu mượn sách (`/customer/borrow-request.jsp`):
*   **Trường Text:**
    *   **Ghi chú (Note):** Tối đa 250 ký tự. Không bắt buộc nhập.
*   **Trường Number:**
    *   **Số lượng mượn (Quantity):** Giới hạn từ 1 đến 5 quyển cho mỗi yêu cầu.
*   **Trường Date:**
    *   **Ngày mượn (Start Date):** Phải >= Ngày hôm nay.
    *   **Ngày trả dự kiến (Return Date):** Phải >= Ngày mượn, và thời gian mượn tối đa không vượt quá 5 ngày (Return Date <= Start Date + 5).
*   **2 Quy tắc nghiệp vụ (Business Rules) thay thế List:**
    *   **BR1:** Độc giả không được phép mượn sách nếu đang có bất kỳ sách nào bị quá hạn trả.
    *   **BR2:** Tổng số sách đang mượn + Số lượng sách trong yêu cầu mới <= 5.

### 5.2. Phân tích kiểm thử (Analysis Test)
*   **Số lượng (1-5):**
    *   *Biên (BVA):* 0 (Fail), 1 (Pass), 5 (Pass), 6 (Fail).
*   **Thời gian mượn (<= 5 ngày):**
    *   *Biên (BVA):* Khoảng cách 0 ngày (Pass - mượn trả trong ngày), 5 ngày (Pass), 6 ngày (Fail).

### 5.3. Thiết kế Test Cases
| STT | Test Case ID | Test Scenario | Preconditions | Test Steps | Test Data | Expected Result | Status |
|:---|:---|:---|:---|:---|:---|:---|:---|
| 1 | `TC_BRW_01` | Gửi yêu cầu mượn thành công | Độc giả không nợ sách, chưa mượn cuốn nào | 1. Vào Yêu cầu mượn<br>2. Chọn ngày<br>3. Nhập số lượng<br>4. Nhấn Gửi | Start: [Hôm nay]<br>Return: [Hôm nay + 3 ngày]<br>Quantity: `2` | Chuyển hướng sang trang Trạng thái yêu cầu, thông báo thành công. | |
| 2 | `TC_BRW_02` | Lỗi số lượng mượn vượt giới hạn (> 5) | Độc giả không nợ sách | 1. Vào Yêu cầu mượn<br>2. Nhập số lượng<br>3. Nhấn Gửi | Quantity: `6` | Form báo lỗi: "Chỉ được mượn tối đa 5 quyển/lần." | |
| 3 | `TC_BRW_03` | Lỗi ngày trả cách ngày mượn quá 5 ngày | Độc giả không nợ sách | 1. Vào Yêu cầu mượn<br>2. Chọn ngày<br>3. Nhấn Gửi | Start: [Hôm nay]<br>Return: [Hôm nay + 6 ngày] | Lỗi: "Thời gian mượn sách không được vượt quá 5 ngày." | |
| 4 | `TC_BRW_04` | Vi phạm BR1: Đang có sách nợ | Độc giả A đang có 1 phiếu mượn quá hạn (Overdue) | 1. Vào Yêu cầu mượn<br>2. Điền Form đúng<br>3. Nhấn Gửi | Dữ liệu hợp lệ | Bị chặn, hiển thị lỗi: "Bạn đang có sách nợ chưa trả, không thể mượn thêm." | |
| 5 | `TC_BRW_05` | Vi phạm BR2: Tổng sách mượn > 5 | Độc giả đang giữ 4 cuốn sách (Chưa trả) | 1. Vào Yêu cầu mượn<br>2. Nhập số lượng<br>3. Nhấn Gửi | Quantity: `2`<br>(Tổng = 6) | Bị chặn, hiển thị lỗi: "Tổng số sách mượn không được vượt quá 5. Bạn đang mượn 4 cuốn." | |

---

> Hướng dẫn: Các thành viên chỉ việc mang các Test Case này gắn vào form Excel/Word của nhóm để chuẩn bị chạy nộp báo cáo Lab.
