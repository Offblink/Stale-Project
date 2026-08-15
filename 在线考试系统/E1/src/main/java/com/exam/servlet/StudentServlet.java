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

@WebServlet("/student")
public class StudentServlet extends HttpServlet {
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
            // 加载试题和答案
            req.setAttribute("questions", examService.getRandomQuestions(5));
            req.setAttribute("myAnswers", examService.getAllAnswers().stream()
                    .filter(a -> a.getStudentUsername().equals(currentUser.getUsername()))
                    .collect(java.util.stream.Collectors.toList()));
            req.getRequestDispatcher("/student/main.jsp").forward(req, resp);
        } else if ("toInfo".equals(method)) {
            // 跳转到信息修改页
            req.getRequestDispatcher("/student/info.jsp").forward(req, resp);
        } else if ("submit".equals(method)) {
            // 提交试卷
            String[] questionIds = req.getParameterValues("questionId");
            if (questionIds != null) {
                for (String qid : questionIds) {
                    String answer = req.getParameter("answer_" + qid);
                    if (answer != null && !answer.isEmpty()) {
                        examService.submitAnswer(qid, currentUser.getUsername(), answer);
                    }
                }
            }
            resp.sendRedirect("student?method=main");
        } else if ("updateInfo".equals(method)) {
            String newUsername = req.getParameter("newUsername");
            String newPassword = req.getParameter("newPassword");
            String confirmPassword = req.getParameter("confirmPassword"); // 获取确认密码

            // 验证逻辑：如果输入了新密码，检查两次是否一致
            if (newPassword != null && !newPassword.isEmpty()) {
                if (!newPassword.equals(confirmPassword)) {
                    req.setAttribute("msg", "两次输入的密码不一致！");
                    req.getRequestDispatcher("/student/info.jsp").forward(req, resp);
                    return; // 终止执行
                }
            }

            // 验证通过，更新信息
            userService.updateUserInfo(currentUser.getUsername(), newUsername, newPassword);
            currentUser.setUsername(newUsername);
            // 注意：如果密码为空，service层应保留原密码！
            if (newPassword != null && !newPassword.isEmpty()) {
                currentUser.setPassword(newPassword);
            }
            req.getSession().setAttribute("currentUser", currentUser);
            resp.sendRedirect("student?method=main");
        } else if ("deleteAccount".equals(method)) {
            // 注销账户
            userService.deleteUser(currentUser.getUsername());
            req.getSession().invalidate();
            resp.sendRedirect("index.jsp");
        }
    }
}
