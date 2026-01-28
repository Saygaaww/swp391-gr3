/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {

    private static final String DB_URL =
            "jdbc:sqlserver://localhost:1433;databaseName=Library;encrypt=true;trustServerCertificate=true";
    private static final String USER = "sa";
    private static final String PASS = "sa"; // sửa cho đúng máy bạn

    public static Connection getConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(DB_URL, USER, PASS);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
