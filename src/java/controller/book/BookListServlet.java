package controller.book;

import dao.BookDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import model.Book;

public class BookListServlet extends HttpServlet {
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Book> books = bookDAO.listActive();
        request.setAttribute("books", books);
        request.getRequestDispatcher("/customer/books.jsp").forward(request, response);
    }
}
