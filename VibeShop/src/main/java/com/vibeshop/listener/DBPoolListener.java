package com.vibeshop.listener;

import com.vibeshop.util.DBUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/*
写在前面：

首先，什么是连接池？这是一个奇怪的问题。
所谓 池，本质上是一个缓冲区。
我们可以从里面预先存储一些对象，
等到需要时再直接从里面取出，这就是 池 的用途。
比如上学期我们学到的缓冲流，某种程度上也是一种池。
而 连接池，则是专门用于临时存储连接，以便后续使用的数据结构。
 */

// 监听器通过重写基类方法，在服务器启动后与关闭前自动开启与关闭连接池
@WebListener
public class DBPoolListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("========================================");
        System.out.println("连接池，启动！");
        System.out.println("========================================");
        try {

        /*
        这里不是真的要关闭连接池，而是：

        我们知道，在JsonUtils中，我们是通过静态代码块初始化连接池的
        这个代码块，将会在所在类第一次被执行的时候加载
        这样一来，我们调用close方法，一来初始化了连接池，二来又不实际取得连接
        其实是连接池中的一种常见技巧
        */
            DBUtil.getConnection().close();

        } catch (Exception e) {
            System.err.println("Failed Message：" + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // 调用关闭方法
        DBUtil.shutdown();

        System.out.println("Pool's been closed ^_^");
    }
}
