package controller.admin;

import dal.BookDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet xóa sách
 * @author Member E - Dũng
 */
@WebServlet("/admin/book-delete")
public class AdminBookDeleteServlet extends HttpServlet {
    
    private BookDAO bookDAO;
    
    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }
    
    /**
     * GET - Xử lý xóa sách
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Kiểm tra login
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("employee") == null) {
            response.sendRedirect(request.getContextPath() + "/mock-login");
            return;
        }
        
        try {
            // Lấy ID sách từ parameter
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/books-list");
                return;
            }
            
            int bookId = Integer.parseInt(idStr);
            
            // Xóa sách
            boolean success = bookDAO.deleteBook(bookId);
            
            if (success) {
                System.out.println("✅ Xóa sách thành công - ID: " + bookId);
            } else {
                System.out.println("❌ Không thể xóa sách - ID: " + bookId);
            }
            
            // Redirect về danh sách sách
            response.sendRedirect(request.getContextPath() + "/books-list");
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/books-list");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/books-list");
        }
    }
    
    /**
     * POST - Cũng xử lý xóa (nếu gọi từ form)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}