

  select * from book


UPDATE Book
SET 
    title = N'Tôi th?y hoa vàng trên c? xanh',
    summary = N'Câu chuy?n v? tu?i th? ? m?t làng quê Vi?t Nam',
    description = N'Câu chuy?n k? v? hai anh em và nh?ng k? ni?m tu?i th? trong sáng, gi?n d? n?i làng quê Vi?t Nam.'
WHERE book_id = 1;


UPDATE Book
SET 
    title = N'Truy?n Ki?u',
    summary = N'Tác ph?m kinh ?i?n c?a v?n h?c Vi?t Nam',
    description = N'Truy?n Ki?u là m?t trong nh?ng tác ph?m v?n h?c l?n nh?t c?a Vi?t Nam, k? v? cu?c ??i ??y bi?n c? c?a Thúy Ki?u.'
WHERE book_id = 2;


UPDATE Book
SET 
    title = N'Chí Phèo',
    summary = N'Tác ph?m n?i ti?ng c?a Nam Cao',
    description = N'Câu chuy?n v? s? ph?n c?a ng??i nông dân trong xã h?i c? và bi k?ch tha hóa c?a con ng??i.'
WHERE book_id = 3;


UPDATE Book
SET 
    title = N'A Brief History of Time',
    summary = N'L?ch s? v? tr?? Big Bang ??n l? ?en',
    description = N'Cu?n sách gi?i thích các khái ni?m v?t lý hi?n ??i nh? ngu?n g?c v? tr?, h? ?en và b?n ch?t c?a th?i gian.'
WHERE book_id = 4;


UPDATE Book
SET 
    title = N'Business @ the Speed of Thought',
    summary = N'T? duy kinh doanh trong th?i ??i s?',
    description = N'Bill Gates chia s? v? cách công ngh? thay ??i cách làm kinh doanh và qu?n tr? doanh nghi?p.'
WHERE book_id = 5;

