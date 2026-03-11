package dao;

import model.ReadingHistory;
import util.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReadingHistoryDAO {

    public List<ReadingHistory> getByReader(int readerId) {
        List<ReadingHistory> list = new ArrayList<>();
        String sql = """
            SELECT rh.*, b.title AS book_title, b.cover_url AS book_cover_url, b.total_pages AS book_total_pages
            FROM Reading_History rh
            JOIN Book b ON rh.book_id = b.book_id
            WHERE rh.reader_id = ?
            ORDER BY rh.last_read_at DESC
        """;
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Cập nhật hoặc tạo mới: 1 dòng (reader_id, book_id), cập nhật last_read_position và last_read_at. */
    public boolean upsert(int readerId, int bookId, int lastReadPosition) {
        if (bookId <= 0 || readerId <= 0) return false;
        String sql = """
            MERGE Reading_History AS t
            USING (SELECT ? AS reader_id, ? AS book_id, ? AS last_read_position) AS s
            ON t.reader_id = s.reader_id AND t.book_id = s.book_id
            WHEN MATCHED THEN
                UPDATE SET t.last_read_position = s.last_read_position, t.last_read_at = SYSUTCDATETIME()
            WHEN NOT MATCHED THEN
                INSERT (reader_id, book_id, last_read_position, last_read_at)
                VALUES (s.reader_id, s.book_id, s.last_read_position, SYSUTCDATETIME());
            """;
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            ps.setInt(2, bookId);
            ps.setInt(3, lastReadPosition);
            int n = ps.executeUpdate();
            return n > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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
