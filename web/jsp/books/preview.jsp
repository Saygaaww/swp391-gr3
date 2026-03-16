<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xem trước: ${book.title}</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>
    <style>
        body { background:#1c1a17; color:#fff; font-family:'Outfit',sans-serif; margin:0; padding:20px; }
        h2   { text-align:center; margin-bottom:8px; }
        .sub { text-align:center; color:#aaa; margin-bottom:20px; font-size:14px; }
        #canvas-wrap { display:flex; flex-direction:column; align-items:center; gap:16px; }
        canvas { box-shadow:0 4px 24px rgba(0,0,0,.6); max-width:100%; }
        .nav  { display:flex; justify-content:center; align-items:center; gap:16px; margin:20px 0; }
        .nav button {
            background:#2d6a5e; color:#fff; border:none; padding:8px 20px;
            border-radius:6px; cursor:pointer; font-size:14px;
        }
        .nav button:disabled { opacity:.4; cursor:default; }
        .lock { text-align:center; background:#2a2520; border:1px solid #3d3830;
                padding:32px; border-radius:10px; margin-top:20px; }
        .lock a { color:#3d8b7a; }
    </style>
</head>
<body>
<h2>📖 Xem trước: ${book.title}</h2>
<p class="sub">Bạn đang xem ${allowedPages} trang đầu tiên miễn phí.</p>

<div class="nav">
    <button id="prev" onclick="changePage(-1)" disabled>◀ Trước</button>
    <span id="page-info">Trang 1 / ${allowedPages}</span>
    <button id="next" onclick="changePage(1)">Tiếp ▶</button>
</div>

<div id="canvas-wrap"><canvas id="pdf-canvas"></canvas></div>

<div class="lock" id="lock-msg" style="display:none">
    🔒 Bạn đã xem hết phần miễn phí.<br><br>
    <a href="${pageContext.request.contextPath}/customer/borrow-request?bookId=${book.bookId}">
        Mượn sách</a>,
    <a href="${pageContext.request.contextPath}/books/detail/${book.bookId}">
        Mua sách</a> hoặc
    <a href="${pageContext.request.contextPath}/customer/reservations">Đặt chỗ</a>
    để đọc toàn bộ.
</div>

<script>
    const pdfUrl    = '${pageContext.request.contextPath}/books/file/${book.bookId}';
    const maxPages  = ${allowedPages};
    let   pdfDoc    = null;
    let   curPage   = 1;

    pdfjsLib.GlobalWorkerOptions.workerSrc =
        'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';

    console.log('Preview PDF URL:', pdfUrl);

    pdfjsLib.getDocument(pdfUrl).promise
        .then(pdf => {
            pdfDoc = pdf;
            if (!pdfDoc || pdfDoc.numPages === 0) {
                console.error('PDF không có trang nào.');
                document.getElementById('lock-msg').style.display = 'block';
                document.getElementById('lock-msg').innerText = 'Không tải được file PDF để xem trước.';
                return;
            }
            renderPage(curPage);
        })
        .catch(err => {
            console.error('Lỗi tải PDF cho preview:', err);
            document.getElementById('lock-msg').style.display = 'block';
            document.getElementById('lock-msg').innerText =
                'Không tải được file PDF để xem trước. Vui lòng kiểm tra lại đường dẫn hoặc đăng nhập.';
        });

    function renderPage(num) {
        pdfDoc.getPage(num).then(page => {
            const canvas  = document.getElementById('pdf-canvas');
            const ctx     = canvas.getContext('2d');
            const vp      = page.getViewport({ scale: 1.5 });
            canvas.width  = vp.width;
            canvas.height = vp.height;
            page.render({ canvasContext: ctx, viewport: vp });

            document.getElementById('page-info').textContent =
                'Trang ' + num + ' / ' + Math.min(maxPages, pdfDoc.numPages);
            document.getElementById('prev').disabled = (num <= 1);
            document.getElementById('next').disabled = (num >= maxPages || num >= pdfDoc.numPages);
            document.getElementById('lock-msg').style.display =
                (num >= maxPages && num < pdfDoc.numPages) ? 'block' : 'none';
        });
    }

    function changePage(delta) {
        const next = curPage + delta;
        if (next < 1 || next > maxPages) return;
        curPage = next;
        renderPage(curPage);
    }
</script>
</body>
</html>