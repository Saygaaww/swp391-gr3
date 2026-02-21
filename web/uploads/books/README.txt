Cách thêm nội dung sách (PDF) để hiển thị trên trang đọc

1. Đặt file PDF vào thư mục này.
   - Tên theo book_id: 1.pdf, 2.pdf (dễ quản lý).
   - Hoặc tên có dấu cách: George Orwell - 1984.pdf (app đã encode URL tự động).

2. Cập nhật database (content_path = đường dẫn tương đối từ thư mục web):
   UPDATE Book SET content_path = 'uploads/books/George Orwell - 1984.pdf' WHERE book_id = <ID_SACH_1984>;

   Hoặc nếu đặt tên 1984.pdf:
   UPDATE Book SET content_path = 'uploads/books/1984.pdf' WHERE book_id = <ID_SACH_1984>;

   Dùng URL đầy đủ (file host bên ngoài):
   UPDATE Book SET content_path = 'https://example.com/path/to/book.pdf' WHERE book_id = 1;

3. Trang đọc sách sẽ hiển thị PDF trong iframe. Tên file có dấu cách được encode tự động.
