package com.vibeshop.util;

// 这里使用HikariCP
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

public class DBUtil {
    private static HikariDataSource dataSource;

    static {
        try {
            // 引入配置文件
            Properties props = new Properties();
            InputStream is = DBUtil.class.getClassLoader().getResourceAsStream("db.properties");
            if (is == null) {
                throw new RuntimeException("Cannot find db.properties");
            }
            props.load(is);

            // 读取配置信息
            HikariConfig config = new HikariConfig();
            config.setDriverClassName(props.getProperty("db.driver"));
            config.setJdbcUrl(props.getProperty("db.url"));
            config.setUsername(props.getProperty("db.username"));
            config.setPassword(props.getProperty("db.password"));

            config.setMinimumIdle(Integer.parseInt(props.getProperty("db.pool.minimumIdle", "5")));
            config.setMaximumPoolSize(Integer.parseInt(props.getProperty("db.pool.maximumPoolSize", "20")));
            config.setConnectionTimeout(Long.parseLong(props.getProperty("db.pool.connectionTimeout", "30000")));
            config.setIdleTimeout(Long.parseLong(props.getProperty("db.pool.idleTimeout", "600000")));
            config.setMaxLifetime(Long.parseLong(props.getProperty("db.pool.maxLifetime", "1800000")));

            dataSource = new HikariDataSource(config);
            is.close();
        } catch (IOException e) {
            throw new RuntimeException("Failed to initialize database connection pool", e);
        }
    }

    // 从池中获取一个连接
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    // 归还连接
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 关闭连接池（适用于有结果集ResultSet的连接请求，例如查询等）
    public static void close(ResultSet rs, PreparedStatement pstmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            closeConnection(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 适用于无结果集（例如插入请求等）
    public static void close(PreparedStatement pstmt, Connection conn) {
        close(null, pstmt, conn);
    }

    public static void shutdown() {
        if (dataSource != null) {
            dataSource.close();
        }
    }
}