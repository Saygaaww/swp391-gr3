<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Cart"%>
<%@page import="model.CartItem"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng - Digital Library</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .cart-table { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-md); }
        .cart-table th, .cart-table td { padding: 14px 18px; text-align: left; border-bottom: 1px solid var(--border); }
        .cart-table th { background: var(--bg-tertiary); }
        .cart-total { text-align: right; margin-top: 24px; font-size: 20px; font-weight: 700; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav-app.jsp"/>
    <section class="features" style="padding: 100px 0 80px;">
        <div class="container">
            <h2 class="section-title">Giỏ hàng (Mock) - Cart, Cart_Item</h2>
            <% Cart cart = (Cart) request.getAttribute("cart");
               List<CartItem> items = cart != null && cart.getItems() != null ? cart.getItems() : null;
               if (items != null && !items.isEmpty()) { %>
            <table class="cart-table">
                <thead><tr><th>Sách</th><th>Đơn giá</th><th>Số lượng</th><th>Thành tiền</th><th></th></tr></thead>
                <tbody>
                <% for (CartItem ci : items) { %>
                <tr>
                    <td><%= ci.getBook() != null ? ci.getBook().getTitle() : "Sách #" + ci.getBookId() %></td>
                    <td><%= ci.getBook() != null && ci.getBook().getPrice() != null ? String.format("%,.0f VND", ci.getBook().getPrice()) : "-" %></td>
                    <td><%= ci.getQuantity() %></td>
                    <td><%= ci.getSubtotal() != null ? String.format("%,.0f VND", ci.getSubtotal()) : "-" %></td>
                    <td><button type="button" style="padding: 6px 10px;">Xóa</button></td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <div class="cart-total">Tổng: <%= cart.getTotalAmount() != null ? String.format("%,.0f VND", cart.getTotalAmount()) : "0 VND" %></div>
            <p style="margin-top: 20px;"><a href="<%= request.getContextPath() %>/checkout/checkout.jsp" class="btn-primary">Thanh toán (checkout)</a></p>
            <% } else { %>
            <p style="text-align: center; color: var(--text-secondary);">Giỏ hàng trống.</p>
            <p style="text-align: center;"><a href="<%= request.getContextPath() %>/pages/browse" class="btn-primary">Duyệt sách</a></p>
            <% } %>
        </div>
    </section>
</body>
</html>
