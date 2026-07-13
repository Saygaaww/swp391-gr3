import os

# Define replacement pairs
REPLACEMENTS = {
    # cart.jsp specific heavily corrupted lines
    "Gi?? hng c?a b?n ?ang tr?ng.": "Giỏ hàng của bạn đang trống.",
    "Xem ??n hng": "Xem đơn hàng",
    "Mua sch": "Mua sách",
    "V?? Kho Sch": "Về Kho Sách",
    "Thnh Ti??n": "Thành Tiền",
    "S? L??ng": "Số Lượng",
    "Xa Sch Ny?": "Xóa Sách Này?",
    "Xa": "Xóa",
    "Sch": "Sách",
    "Gi": "Giá",
    "Cn": "Còn",
    "cu?n": "cuốn",
    "T?ng": "Tổng",
    
    # Common ones
    "VN?": "VNĐ",
    "ch?n": "chọn",
    "Ch?n": "Chọn",
    "h?c": "học",
    "ngư?i": "người",
    "Ngư?i": "Người",
    "quy?n": "quyền",
    "Ti?n": "Tiền",
    "ti?n": "tiền",
    "th?i": "thời",
    "Th?i": "Thời",
    "? Trang chủ": "Về Trang chủ",
    "? Quay lại": "Quay lại",
    "? Duyệt sách": "Duyệt sách",
    "? My Library": "Về My Library",
    "??c": "Đọc",
    "?ể": "Để",
    "đư?ng": "đường",
    "Đư?ng": "Đường",
    "gi?": "giỏ",
    "Gi?": "Giỏ",
    "g?n": "gọn",
    "bộ l?c": "bộ lọc",
    "l?c nhanh": "lọc nhanh",
    "h?": "họ",
    "?nh": "Ánh" # Nguyễn Nhật Ánh
}

def fix_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except UnicodeDecodeError:
        return False
        
    original_content = content
    for bad_str, good_str in REPLACEMENTS.items():
        content = content.replace(bad_str, good_str)
        # Also handle standard ? instead of  if they decay differently
        bad_with_q = bad_str.replace("", "?")
        if bad_with_q != bad_str:
            content = content.replace(bad_with_q, good_str)
            
    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False

def main():
    root_dir = "web/jsp"
    fixed_count = 0
    for dirpath, _, filenames in os.walk(root_dir):
        for filename in filenames:
            if filename.endswith(".jsp"):
                filepath = os.path.join(dirpath, filename)
                if fix_file(filepath):
                    print(f"Fixed: {filepath}")
                    fixed_count += 1
    print(f"Done. Fixed {fixed_count} files.")

if __name__ == "__main__":
    main()
