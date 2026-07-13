package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Role;
import util.DBUtil;

public class RoleDAO implements AutoCloseable {
    private static final Logger LOGGER = Logger.getLogger(RoleDAO.class.getName());
    private final Connection connection;

    public RoleDAO() throws SQLException {
        this.connection = DBUtil.getConnection();
    }

    public List<Role> getAllRoles() {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT * FROM Role ORDER BY role_id ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                roles.add(new Role(rs.getInt("role_id"), rs.getString("role_name")));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "getAllRoles Error", e);
        }
        return roles;
    }

    @Override
    public void close() throws SQLException {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    }
}
