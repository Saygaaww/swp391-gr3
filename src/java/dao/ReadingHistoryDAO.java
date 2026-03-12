package dao;

import model.ReadingHistory;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReadingHistoryDAO {

    public List<ReadingHistory> getByReader(int readerId) {
        List<ReadingHistory> list = new ArrayList<>();
        String sql = """
            SELECT rh.*, b.Title AS book_title, b.CoverURL AS book_cover_url, b.TotalPages AS book_total_pages
            FROM Reading_History rh
            JOIN Book b ON rh.book_id = b.BookID
            WHERE rh.reader_id = ?
            ORDER BY rh.last_read_at DESC
        """;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Cập nhật hoặc tạo mới: 1 dòng (reader_id, book_id), cập nhật last_read_position và last_read_at. */
    public boolean upsert(int readerId, int bookId, int lastReadPosition) {
        String check = "SELECT history_id FROM Reading_History WHERE reader_id = ? AND book_id = ?";
        String update = "UPDATE Reading_History SET last_read_position = ?, last_read_at = SYSUTCDATETIME() WHERE reader_id = ? AND book_id = ?";
        String insert = "INSERT INTO Reading_History(reader_id, book_id, last_read_position, last_read_at) VALUES (?, ?, ?, SYSUTCDATETIME())";
        try (Connection con = DBUtil.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(check)) {
                ps.setInt(1, readerId);
                ps.setInt(2, bookId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    try (PreparedStatement u = con.prepareStatement(update)) {
                        u.setInt(1, lastReadPosition);
                        u.setInt(2, readerId);
                        u.setInt(3, bookId);
                        return u.executeUpdate() > 0;
                    }
                }
            }
            try (PreparedStatement ins = con.prepareStatement(insert)) {
                ins.setInt(1, readerId);
                ins.setInt(2, bookId);
                ins.setInt(3, lastReadPosition);
                return ins.executeUpdate() > 0;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    private ReadingHistory map(ResultSet rs) throws SQLException {
        ReadingHistory h = new ReadingHistory();
        h.setHistoryId(rs.getInt("history_id"));
        h.setReaderId(rs.getInt("reader_id"));
        h.setBookId(rs.getInt("book_id"));
        h.setLastReadPosition(rs.getObject("last_read_position") != null ? rs.getInt("last_read_position") : null);
        Timestamp t = rs.getTimestamp("last_read_at");
        h.setLastReadAt(t != null ? t.toLocalDateTime() : null);
        h.setBookTitle(rs.getString("book_title"));
        h.setBookCoverUrl(rs.getString("book_cover_url"));
        int tp = rs.getInt("book_total_pages");
        h.setBookTotalPages(rs.wasNull() ? null : tp);
        return h;
    }
}
