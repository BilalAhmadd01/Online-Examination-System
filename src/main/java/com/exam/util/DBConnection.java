package com.exam.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {
    private static Properties properties = new Properties();

    static {
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                System.err.println("Sorry, unable to find db.properties inside classpath. Falling back to default values.");
                properties.setProperty("db.driver", "com.mysql.cj.jdbc.Driver");
                properties.setProperty("db.url", "jdbc:mysql://localhost:3306/online_exam_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
                properties.setProperty("db.username", "root");
                properties.setProperty("db.password", "");
            } else {
                properties.load(input);
            }
            // Load Driver Class
            Class.forName(properties.getProperty("db.driver"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Establish and return a new Database Connection.
     */
    public static Connection getConnection() throws SQLException {
        String url = properties.getProperty("db.url");
        String user = properties.getProperty("db.username");
        String pass = properties.getProperty("db.password");
        return DriverManager.getConnection(url, user, pass);
    }
}

