package com.vibeshop.benchmark;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class ConnectionBenchmark {
    private static String driver;
    private static String url;
    private static String username;
    private static String password;

    // 使用HiKariCP（不能写在静态代码块中！否则静态代码块编译会报错！！）
    private static HikariDataSource dataSource;

    // 这个静态代码块，先于本类被编译，以便后续方法直接调用
    static {
        try {
            // 加载配置文件
            Properties props = new Properties();
            // 即用即删（超小声
            InputStream is = ConnectionBenchmark.class.getClassLoader().getResourceAsStream("db.properties");
            props.load(is);
            is.close();

            // 读取配置文件
            driver = props.getProperty("db.driver");
            url = props.getProperty("db.url");
            username = props.getProperty("db.username");
            password = props.getProperty("db.password");

            // 创建配置对象
            HikariConfig config = new HikariConfig();

            config.setDriverClassName(driver);
            config.setJdbcUrl(url);
            config.setUsername(username);
            config.setPassword(password);

            config.setMinimumIdle(5);
            config.setMaximumPoolSize(20);
            config.setConnectionTimeout(30000);
            config.setIdleTimeout(600000);
            config.setMaxLifetime(1800000);

            // new 一个连接池
            dataSource = new HikariDataSource(config);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        int iterations = 1000;
        // 注：如果尝试将迭代次数改为100000（很大的一个数），会出现老师说的“拒绝连接”问题

        System.out.println("正在测试...");

        long poolTime = testWithPool(iterations);
        long noPoolTime = testWithoutPool(iterations);

        System.out.println("使用连接池：" + poolTime + "ms");
        System.out.println("不使用连接池：" + noPoolTime + "ms");
        System.out.println("速度提升：" + (double)noPoolTime/poolTime + "倍");

        // 最后关闭连接池
        dataSource.close();
    }

    // 使用连接池
    private static long testWithPool(int iterations) {
        // 记下当前时间
        long startTime = System.currentTimeMillis();

        for (int i = 0; i < iterations; i++) {
            Connection conn;

            try {
                // 获取连接
                conn = dataSource.getConnection();
                // 归还连接
                conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
            }
        }

        // 记下结束时间
        long endTime = System.currentTimeMillis();
        // 计算出耗费的总时间
        long duration = endTime - startTime;
        // 最后返回
        return duration;
    }

    // 不使用连接池（只修改了获取连接的方式，其他地方和使用连接池的方法相同）
    private static long testWithoutPool(int iterations) {
        long startTime = System.currentTimeMillis();

        for (int i = 0; i < iterations; i++) {
            Connection conn;

            try {
                conn = DriverManager.getConnection(url, username, password);
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        long endTime = System.currentTimeMillis();
        long duration = endTime - startTime;

        return duration;
    }
}