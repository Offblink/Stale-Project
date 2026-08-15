package com.exam.servlet;

import com.exam.pojo.User;
import com.exam.service.ExamService;
import com.exam.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/teacher")
public class TeacherServlet extends HttpServlet {
    private UserService userService = new UserService();
    private ExamService examService = new ExamService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String method = req.getParameter("method");
        User currentUser = (User) req.getSession().getAttribute("currentUser");

        if ("main".equals(method)) {
            req.setAttribute("answers", examService.getAllAnswers());
            req.getRequestDispatcher("/teacher/main.jsp").forward(req, resp);
        } else if ("toInfo".equals(method)) {
            req.getRequestDispatcher("teacher/info.jsp").forward(req, resp);
        } else if ("grade".equals(method)) {
            String answerId = req.getParameter("answerId");
            String score = req.getParameter("score");
            examService.submitGrade(answerId, score, currentUser.getUsername());
            resp.sendRedirect("teacher?method=main");
        } else if ("updateInfo".equals(method)) {
            String newUsername = req.getParameter("newUsername");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword"); // 获取确认密码

            // 验证逻辑
            if (newPassword != null && !newPassword.isEmpty()) {
                if (!newPassword.equals(confirmPassword)) {
                    req.setAttribute("msg", "两次输入的密码不一致！");
                    req.getRequestDispatcher("teacher/info.jsp").forward(req, resp);
                    return;
                }
            }

            // 验证通过
            userService.updateUserInfo(currentUser.getUsername(), newUsername, newPassword);
            currentUser.setUsername(newUsername);
            if (newPassword != null && !newPassword.isEmpty()) {
                currentUser.setPassword(newPassword);
            }
            req.getSession().setAttribute("currentUser", currentUser);
            resp.sendRedirect("teacher?method=main");
        } else if ("deleteAccount".equals(method)) {
            userService.deleteUser(currentUser.getUsername());
            req.getSession().invalidate();
            resp.sendRedirect("index.jsp");
        }
    }
}
