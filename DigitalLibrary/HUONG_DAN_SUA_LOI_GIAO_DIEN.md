# Hướng Dẫn Sửa Lỗi Giao Diện

## 🔍 Vấn Đề

Giao diện hiển thị nhưng thiếu CSS styling (không có màu sắc, gradient, layout đẹp).

## ✅ Đã Sửa

1. **Cập nhật RootServlet** - Forward static resources (CSS, JS) đến default servlet
2. **Thêm inline styles** - Fallback styles trong `<head>` để đảm bảo trang hiển thị cơ bản

## 🧪 Cách Kiểm Tra

### Bước 1: Kiểm Tra CSS Có Được Load Không

1. Mở trình duyệt
2. Nhấn **F12** để mở Developer Tools
3. Vào tab **Network**
4. Reload trang (F5)
5. Tìm file `home.css`
6. Kiểm tra:
   - Status: **200** = OK ✅
   - Status: **404** = File không tìm thấy ❌
   - Status: **500** = Lỗi server ❌

### Bước 2: Kiểm Tra Console

1. Vào tab **Console** trong Developer Tools
2. Xem có lỗi nào không:
   - Lỗi load CSS
   - Lỗi JavaScript
   - Lỗi 404 cho resources

### Bước 3: Kiểm Tra Đường Dẫn CSS

Trong trang web, click chuột phải → **View Page Source**

Tìm dòng:
```html
<link rel="stylesheet" href="/DigitalLibrary/css/home.css">
```

Đảm bảo đường dẫn đúng với context path của bạn.

## 🔧 Cách Khắc Phục

### Nếu CSS Không Được Load (404 hoặc 500)

1. **Kiểm tra file có tồn tại:**
   ```
   web/css/home.css
   ```

2. **Clean and Build project:**
   - Right-click project → **Clean and Build**
   - Redeploy project

3. **Kiểm tra web.xml:**
   - Đảm bảo không có servlet mapping chặn `/css/*`

4. **Test trực tiếp:**
   - Truy cập: `http://localhost:8080/DigitalLibrary/css/home.css`
   - Nếu thấy nội dung CSS → File tồn tại ✅
   - Nếu 404 → File chưa được deploy ❌

### Nếu CSS Được Load Nhưng Không Áp Dụng

1. **Hard refresh:**
   - Nhấn **Ctrl + F5** (Windows)
   - Hoặc **Ctrl + Shift + R**

2. **Clear browser cache:**
   - Nhấn **Ctrl + Shift + Delete**
   - Chọn "Cached images and files"
   - Clear data

3. **Kiểm tra CSS có lỗi syntax:**
   - Mở file `web/css/home.css`
   - Kiểm tra có lỗi syntax không
   - Sử dụng CSS validator online

## 📝 Kiểm Tra Nhanh

### Test CSS Trực Tiếp

Truy cập trong trình duyệt:
```
http://localhost:8080/DigitalLibrary/css/home.css
```

**Kết quả mong đợi:**
- Thấy nội dung CSS (code) → ✅ File tồn tại và được serve
- 404 Not Found → ❌ File không tồn tại hoặc không được serve
- 500 Error → ❌ Lỗi server

### Test JavaScript

Truy cập:
```
http://localhost:8080/DigitalLibrary/js/home.js
```

## 🎨 Inline Styles Fallback

Đã thêm inline styles trong `<head>` của `home.jsp` để đảm bảo trang hiển thị cơ bản ngay cả khi CSS không load:

```html
<style>
    body {
        font-family: 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        margin: 0;
        padding: 0;
    }
    .hero {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
        color: white !important;
    }
    .navbar {
        background: rgba(255, 255, 255, 0.95) !important;
    }
</style>
```

## 🚀 Sau Khi Sửa

1. **Clean and Build** project
2. **Redeploy** lên Tomcat
3. **Hard refresh** trình duyệt (Ctrl + F5)
4. **Kiểm tra lại** giao diện

## 📞 Nếu Vẫn Không Được

1. Kiểm tra log trong NetBeans console
2. Kiểm tra log trong Tomcat
3. Kiểm tra Developer Tools → Network tab
4. Cho tôi biết:
   - Status code của `home.css` trong Network tab
   - Có lỗi nào trong Console không
   - Screenshot của giao diện hiện tại
