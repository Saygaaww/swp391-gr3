# 🔐 Hướng Dẫn Authorization - Librarian/Seller Only

## ✅ Đã Implement

Đã thêm **role-based access control** để chỉ **Librarian** và **Seller** mới có thể Create/Update Authors.

---

## 📁 Files Đã Tạo/Cập Nhật

### 1. **AuthUtil.java** - Utility Class
**File:** `src/java/util/AuthUtil.java`

**Chức năng:**
- Kiểm tra user đã login chưa
- Kiểm tra role của user
- Kiểm tra quyền truy cập (Librarian/Seller)

**Methods chính:**
```java
// Check if user can manage catalog (Authors/Categories)
AuthUtil.canManageCatalog(request)

// Check if user can manage books
AuthUtil.canManageBooks(request)

// Check specific role
AuthUtil.hasRole(request, "Librarian")

// Get employee ID from session
AuthUtil.getEmployeeId(request)
```

### 2. **AuthorController.java** - Updated
**File:** `src/java/controller/AuthorController.java`

**Thay đổi:**
- Thêm authorization check cho `/create`, `/edit`, `/update`
- Redirect đến unauthorized page nếu không có quyền
- Set `canManageCatalog` attribute cho JSP

### 3. **unauthorized.jsp** - Error Page
**File:** `web/WEB-INF/jsp/error/unauthorized.jsp`

**Chức năng:**
- Hiển thị thông báo không có quyền
- Link quay lại hoặc về trang chủ

### 4. **list.jsp** - Updated
**File:** `web/WEB-INF/jsp/authors/list.jsp`

**Thay đổi:**
- Ẩn nút "Thêm tác giả mới" nếu không có quyền
- Chỉ hiển thị cho Librarian/Seller

---

## 🔑 Session Attributes Cần Set

Khi user login thành công, cần set các session attributes sau:

```java
HttpSession session = request.getSession();
session.setAttribute(AuthUtil.SESSION_USER, userObject);
session.setAttribute(AuthUtil.SESSION_USER_ID, userId);
session.setAttribute(AuthUtil.SESSION_USER_ROLE, "Librarian"); // hoặc "Seller"
session.setAttribute(AuthUtil.SESSION_EMPLOYEE_ID, employeeId);
```

### Ví dụ trong Login Controller:

```java
// Sau khi verify login thành công
HttpSession session = request.getSession();
session.setAttribute(AuthUtil.SESSION_USER, user);
session.setAttribute(AuthUtil.SESSION_USER_ID, user.getUserId());
session.setAttribute(AuthUtil.SESSION_USER_ROLE, user.getRole()); // "Librarian" hoặc "Seller"
session.setAttribute(AuthUtil.SESSION_EMPLOYEE_ID, user.getEmployeeId());

// Redirect về trang trước đó hoặc trang chủ
String redirectURL = (String) session.getAttribute("redirectAfterLogin");
if (redirectURL != null) {
    session.removeAttribute("redirectAfterLogin");
    response.sendRedirect(redirectURL);
} else {
    response.sendRedirect(request.getContextPath() + "/");
}
```

---

## 🧪 Cách Test (Temporary)

Để test mà chưa có login system, có thể tạm thời set session trong Controller:

### Option 1: Set trong AuthorController (tạm thời)

```java
// Tạm thời để test - XÓA SAU KHI CÓ LOGIN SYSTEM
HttpSession session = request.getSession();
if (session.getAttribute(AuthUtil.SESSION_USER_ROLE) == null) {
    // Set test role
    session.setAttribute(AuthUtil.SESSION_USER_ROLE, "Librarian");
    session.setAttribute(AuthUtil.SESSION_USER_ID, 1);
    session.setAttribute(AuthUtil.SESSION_EMPLOYEE_ID, 1);
}
```

### Option 2: Tạo Test Servlet

```java
@WebServlet("/test-login")
public class TestLoginServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = request.getParameter("role"); // ?role=Librarian
        
        session.setAttribute(AuthUtil.SESSION_USER_ROLE, role != null ? role : "Librarian");
        session.setAttribute(AuthUtil.SESSION_USER_ID, 1);
        session.setAttribute(AuthUtil.SESSION_EMPLOYEE_ID, 1);
        
        response.sendRedirect(request.getContextPath() + "/authors");
    }
}
```

**Sử dụng:**
- `/test-login?role=Librarian` → Set role Librarian
- `/test-login?role=Seller` → Set role Seller
- `/test-login?role=Customer` → Set role Customer (không có quyền)

---

## 🔒 Protected URLs

Các URLs sau đây yêu cầu quyền **Librarian** hoặc **Seller**:

- `GET /authors/create` - Hiển thị form tạo mới
- `POST /authors/create` - Tạo tác giả mới
- `GET /authors/edit/{id}` - Hiển thị form chỉnh sửa
- `POST /authors/update/{id}` - Cập nhật tác giả

**Public URLs (không cần quyền):**
- `GET /authors` - Xem danh sách
- `GET /authors/detail/{id}` - Xem chi tiết

---

## 🎯 Behavior

### Nếu User Chưa Login:
- Redirect đến `/login?error=unauthorized`
- Lưu URL hiện tại để redirect sau khi login

### Nếu User Đã Login Nhưng Không Có Quyền:
- Hiển thị trang `unauthorized.jsp`
- Thông báo: "Chỉ Librarian/Seller mới có quyền"

### Nếu User Có Quyền:
- Cho phép truy cập bình thường
- Hiển thị nút "Thêm tác giả mới" trong list

---

## 📝 Integration với Login System

Khi có login system (từ branch `hoang-authentication`), cần:

1. **Import AuthUtil** vào LoginController
2. **Set session attributes** sau khi login thành công
3. **Verify role** từ database (Employee table)
4. **Remove test code** nếu có

### Ví dụ Integration:

```java
// Trong LoginController sau khi verify credentials
Employee employee = employeeDAO.getEmployeeByUsername(username);

if (employee != null && verifyPassword(password, employee.getPassword())) {
    HttpSession session = request.getSession();
    session.setAttribute(AuthUtil.SESSION_USER, employee);
    session.setAttribute(AuthUtil.SESSION_USER_ID, employee.getEmployeeId());
    session.setAttribute(AuthUtil.SESSION_USER_ROLE, employee.getRole());
    session.setAttribute(AuthUtil.SESSION_EMPLOYEE_ID, employee.getEmployeeId());
    
    // Redirect
    response.sendRedirect(request.getContextPath() + "/");
} else {
    // Login failed
    request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu");
    // Show login form again
}
```

---

## 🔄 Logout

Khi logout, cần clear session:

```java
HttpSession session = request.getSession(false);
if (session != null) {
    session.invalidate();
}
response.sendRedirect(request.getContextPath() + "/");
```

---

## ✅ Checklist

- [x] Tạo AuthUtil class
- [x] Thêm authorization check vào AuthorController
- [x] Tạo unauthorized.jsp
- [x] Ẩn nút "Thêm mới" trong JSP nếu không có quyền
- [ ] Integrate với login system (khi có)
- [ ] Test với các roles khác nhau
- [ ] Apply tương tự cho Categories (Task 2)
- [ ] Apply tương tự cho Books (Task 4, 5, 6)

---

## 🚀 Next Steps

1. **Task 2 (Categories)** - Áp dụng authorization tương tự
2. **Task 4-6 (Books)** - Áp dụng authorization cho Book management
3. **Integration** - Kết nối với login system từ branch `hoang-authentication`

---

**Authorization đã được implement! Chỉ Librarian/Seller mới có thể quản lý Authors.** 🔐
