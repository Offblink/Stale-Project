package com.exam.servlet;

import com.exam.dao.UserDao;
import com.exam.pojo.User;
import com.exam.util.JsonUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class InitServlet extends HttpServlet {
    @Override
    public void init() throws ServletException {
        // 初始化工具类路径
        JsonUtil.setServletContext(getServletContext());

        System.out.println("系统初始化开始...");
        UserDao userDao = new UserDao();
        if (userDao.findUserByUsername("admin") == null) {
            //实际运用中，管理员信息应存在配置文件中，并通过加密
            User admin = new User("admin", "zy142857", "admin");
            userDao.addUser(admin);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.getWriter().write("System Initialized.");
    }
}
