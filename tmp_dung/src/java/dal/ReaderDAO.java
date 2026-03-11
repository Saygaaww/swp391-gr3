package dal;

import model.Reader;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReaderDAO extends DBContext {

    public int getTotalReaders() {
        String sql = "SELECT COUNT(*) FROM Reader";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.err.println("getTotalReaders Error: " + e.getMessage());
        }
        return 0;
    }

    // Lay danh sach doc gia co loc + phan trang (dung cho ReaderListServlet)
    public List<Reader> getReadersFiltered(String keyword, String status, int roleId,
                                            int page, int pageSize) {
        List<Reader> readers = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT r.*, ro.role_name ");
        sql.append("FROM Reader r ");
        sql.append("LEFT JOIN Role ro ON r.role_id = ro.role_id ");
        sql.append("WHERE 1=1 ");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (r.full_name LIKE ? OR r.email LIKE ? OR r.phone LIKE ?) ");
        }
        if (status != null && !status.isEmpty()) sql.append("AND r.status = ? ");
        if (roleId > 0) sql.append("AND r.role_id = ? ");

        sql.append("ORDER BY r.created_at DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (status != null && !status.isEmpty()) ps.setString(idx++, status);
            if (roleId > 0) ps.setInt(idx++, roleId);

            int offset = (page - 1) * pageSize;
            ps.setInt(idx++, offset);
            ps.setInt(idx++, pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    readers.add(mapResultSetToReader(rs));
                }
            }

        } catch (Exception e) {
            System.err.println("getReadersFiltered Error: " + e.getMessage());
            e.printStackTrace();
        }
        return readers;
    }

    // Dem so doc gia co loc (dung cho phan trang)
    public int countReadersFiltered(String keyword, String status, int roleId) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Reader r WHERE 1=1 ");

        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (r.full_name LIKE ? OR r.email LIKE ? OR r.phone LIKE ?) ");
        }
        if (status != null && !status.isEmpty()) sql.append("AND r.status = ? ");
        if (roleId > 0) sql.append("AND r.role_id = ? ");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (keyword != null && !keyword.isEmpty()) {
                String kw = "%" + keyword + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            if (status != null && !status.isEmpty()) ps.setString(idx++, status);
            if (roleId > 0) ps.setInt(idx++, roleId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (Exception e) {
            System.err.println("countReadersFiltered Error: " + e.getMessage());
        }
        return 0;
    }

    public Reader getReaderById(int readerId) {
        String sql = "SELECT r.*, ro.role_name FROM Reader r " +
                     "LEFT JOIN Role ro ON r.role_id = ro.role_id " +
                     "WHERE r.reader_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToReader(rs);
            }
        } catch (Exception e) {
            System.err.println("getReaderById Error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public Reader getReaderByEmail(String email) {
        String sql = "SELECT r.*, ro.role_name FROM Reader r " +
                     "LEFT JOIN Role ro ON r.role_id = ro.role_id " +
                     "WHERE r.email = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToReader(rs);
            }
        } catch (Exception e) {
            System.err.println("getReaderByEmail Error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean addReader(Reader reader) {
        String sql = "INSERT INTO Reader (full_name, email, password_hash, phone, avatar, status, role_id) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reader.getFullName());
            ps.setString(2, reader.getEmail());
            ps.setString(3, reader.getPasswordHash());
            ps.setString(4, reader.getPhone());
            ps.setString(5, reader.getAvatar());
            ps.setString(6, reader.getStatus() != null ? reader.getStatus() : "active");
            ps.setInt(7, reader.getRoleId() > 0 ? reader.getRoleId() : 4);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("addReader Error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateReader(Reader reader) {
        String sql = "UPDATE Reader SET full_name = ?, email = ?, phone = ?, " +
                     "avatar = ?, status = ?, role_id = ? WHERE reader_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reader.getFullName());
            ps.setString(2, reader.getEmail());
            ps.setString(3, reader.getPhone());
            ps.setString(4, reader.getAvatar());
            ps.setString(5, reader.getStatus());
            ps.setInt(6, reader.getRoleId() > 0 ? reader.getRoleId() : 4);
            ps.setInt(7, reader.getReaderId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("updateReader Error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateReaderPassword(int readerId, String newPasswordHash) {
        String sql = "UPDATE Reader SET password_hash = ? WHERE reader_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, readerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("updateReaderPassword Error: " + e.getMessage());
        }
        return false;
    }

    public boolean updateReaderStatus(int readerId, String status) {
        String sql = "UPDATE Reader SET status = ? WHERE reader_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, readerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("updateReaderStatus Error: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteReader(int readerId) {
        String sql = "DELETE FROM Reader WHERE reader_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, readerId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("deleteReader Error: " + e.getMessage());
        }
        return false;
    }

    public boolean isEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM Reader WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.err.println("isEmailExists Error: " + e.getMessage());
        }
        return false;
    }

    // Kiem tra trung so dien thoai
    public boolean isPhoneExists(String phone) {
        String sql = "SELECT COUNT(*) FROM Reader WHERE phone = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.err.println("isPhoneExists Error: " + e.getMessage());
        }
        return false;
    }

    // Kiem tra trung so dien thoai (tru 1 reader)
    public boolean isPhoneExistsExcept(String phone, int exceptReaderId) {
        String sql = "SELECT COUNT(*) FROM Reader WHERE phone = ? AND reader_id != ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setInt(2, exceptReaderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.err.println("isPhoneExistsExcept Error: " + e.getMessage());
        }
        return false;
    }

    public boolean isEmailExistsExcept(String email, int exceptReaderId) {
        String sql = "SELECT COUNT(*) FROM Reader WHERE email = ? AND reader_id != ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, exceptReaderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.err.println("isEmailExistsExcept Error: " + e.getMessage());
        }
        return false;
    }

    public int countReadersByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Reader WHERE status = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("countReadersByStatus Error: " + e.getMessage());
        }
        return 0;
    }
    
    // Login bang email + password hash
    public Reader loginByEmailPassword(String email, String passwordHash) {
        String sql = "SELECT r.*, ro.role_name FROM Reader r " +
                     "LEFT JOIN Role ro ON r.role_id = ro.role_id " +
                     "WHERE r.email = ? AND r.password_hash = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, passwordHash);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToReader(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Login bang Google
    public Reader loginByGoogle(model.GoogleUser gUser) {
        String checkSql = "SELECT r.*, ro.role_name FROM Reader r " +
                          "JOIN Role ro ON r.role_id = ro.role_id " +
                          "JOIN Reader_Account ra ON r.reader_id = ra.reader_id " +
                          "WHERE ra.provider = 'GOOGLE' AND ra.provider_user_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            ps.setString(1, gUser.getId());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapResultSetToReader(rs);

            // Chua co → tao reader moi
            String insertReader = "INSERT INTO Reader(full_name, email, password_hash, avatar, status, role_id) " +
                                  "VALUES (?, ?, 'google_oauth', ?, 'active', 4)";
            PreparedStatement ps1 = conn.prepareStatement(insertReader, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, gUser.getName());
            ps1.setString(2, gUser.getEmail());
            ps1.setString(3, gUser.getPicture());
            ps1.executeUpdate();

            ResultSet key = ps1.getGeneratedKeys();
            if (key.next()) {
                int readerId = key.getInt(1);
                String insertAccount = "INSERT INTO Reader_Account(reader_id, provider, provider_user_id) " +
                                       "VALUES (?, 'GOOGLE', ?)";
                PreparedStatement ps2 = conn.prepareStatement(insertAccount);
                ps2.setInt(1, readerId);
                ps2.setString(2, gUser.getId());
                ps2.executeUpdate();
            }
            return loginByGoogle(gUser);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Dang ky bang email
    public boolean registerByEmail(String fullName, String email, String passwordHash) {
        String insertReader = "INSERT INTO Reader(full_name, email, password_hash, status, role_id) " +
                              "VALUES (?, ?, ?, 'active', 4)";
        String insertAccount = "INSERT INTO Reader_Account(reader_id, provider) VALUES (?, 'LOCAL')";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            PreparedStatement ps1 = conn.prepareStatement(insertReader, Statement.RETURN_GENERATED_KEYS);
            ps1.setString(1, fullName);
            ps1.setString(2, email);
            ps1.setString(3, passwordHash);
            ps1.executeUpdate();

            ResultSet rs = ps1.getGeneratedKeys();
            if (!rs.next()) { conn.rollback(); return false; }

            PreparedStatement ps2 = conn.prepareStatement(insertAccount);
            ps2.setInt(1, rs.getInt(1));
            ps2.executeUpdate();
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cap nhat mat khau theo email
    public boolean updatePasswordByEmail(String email, String hashedPassword) {
        String sql = "UPDATE Reader SET password_hash = ? WHERE email = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Map ResultSet thanh Reader object
    private Reader mapResultSetToReader(ResultSet rs) throws SQLException {
        Reader reader = new Reader();
        reader.setReaderId(rs.getInt("reader_id"));
        reader.setFullName(rs.getString("full_name"));
        reader.setEmail(rs.getString("email"));
        reader.setPasswordHash(rs.getString("password_hash"));
        reader.setPhone(rs.getString("phone"));
        reader.setAvatar(rs.getString("avatar"));
        reader.setStatus(rs.getString("status"));
        reader.setCreatedAt(rs.getTimestamp("created_at"));
        reader.setRoleId(rs.getInt("role_id"));
        try {
            reader.setRoleName(rs.getString("role_name"));
        } catch (SQLException e) {
            // Khong co JOIN Role thi bo qua
        }
        return reader;
    }
}