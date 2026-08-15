package com.example.realtor.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;
import java.io.InputStream;
import java.util.Properties;

public class DBConnection {
    private static HikariDataSource dataSource;

    static {
        try {
            Properties props = new Properties();
            InputStream is = DBConnection.class.getClassLoader().getResourceAsStream("db.properties");
            props.load(is);

            HikariConfig config = new HikariConfig();
            config.setDriverClassName(props.getProperty("jdbc.driver"));
            config.setJdbcUrl(props.getProperty("jdbc.url"));
            config.setUsername(props.getProperty("jdbc.username"));
            config.setPassword(props.getProperty("jdbc.password"));
            config.setMaximumPoolSize(Integer.parseInt(props.getProperty("hikari.maximum-pool-size")));
            config.setMinimumIdle(Integer.parseInt(props.getProperty("hikari.minimum-idle")));
            config.setConnectionTimeout(Long.parseLong(props.getProperty("hikari.connection-timeout")));

            dataSource = new HikariDataSource(config);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static DataSource getDataSource() {
        return dataSource;
    }

    public static java.sql.Connection getConnection() throws Exception {
        return dataSource.getConnection();
    }
}