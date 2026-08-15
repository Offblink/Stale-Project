package com.exam.servlet;

import com.exam.pojo.User;
import com.exam.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    private final UserService userService = new UserService(); // 用户服务层，后续代码给出

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action"); // 获取变量action（注册/登录）

        if ("register".equals(action)) {
            // 注册逻辑
            String username = req.getParameter("username");
            String password = req.getParameter("password");
            String confirmPass = req.getParameter("confirmPassword"); // 确认密码
            String role = req.getParameter("role");

            if (!password.equals(confirmPass)) {
                req.setAttribute("msg", "两次密码不一致！"); // 设置信息，由前端显示
                req.getRequestDispatcher("index.jsp").forward(req, resp);
                return;
            }

            // 这里用到了userService的方法，查询用户名是否已存在
            if (userService.checkUsernameExists(username)) {
                req.setAttribute("msg", "用户名已存在！");

                // 跳转至本页面，相当于一次刷新
                req.getRequestDispatcher("index.jsp").forward(req, resp);
                return;
            }

            userService.register(username, password, role);
            req.setAttribute("msg", "注册成功，请登录！");
            req.getRequestDispatcher("index.jsp").forward(req, resp);

        } else if ("login".equals(action)) {
            // 登录逻辑（和注册逻辑大同小异）
            String username = req.getParameter("username");
            String password = req.getParameter("password");

            User user = userService.login(username, password);
            if (user != null) {
                HttpSession session = req.getSession(); // 这是session，用于临时存储用户信息
                session.setAttribute("currentUser", user);

                // 根据角色跳转（由于这里不需要传递数据，故使用重定向）
                switch (user.getRole()) {

                    // 这里使用了Java 17+ 的switch表达式
                    case "student" -> resp.sendRedirect("student?method=main");
                    case "teacher" -> resp.sendRedirect("teacher?method=main");
                    case "admin" -> resp.sendRedirect("admin?method=main");
                    case null, default -> resp.sendRedirect("index.jsp");

                }
            } else {
                req.setAttribute("msg", "用户名或密码错误！");
                req.getRequestDispatcher("index.jsp").forward(req, resp);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 退出登录
        req.getSession().invalidate(); // 最后不能忘了销毁session对象
        resp.sendRedirect("index.jsp");
    }
}
