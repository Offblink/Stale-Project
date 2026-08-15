package com.exam.servlet;

import com.exam.pojo.Question;
import com.exam.pojo.User;
import com.exam.service.QuestionService;
import com.exam.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private UserService userService = new UserService();
    private QuestionService questionService = new QuestionService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String method = req.getParameter("method"); // 调用doPost方法后，获取method值，实现指定方法的调用

        if ("main".equals(method)) {
            req.getRequestDispatcher("/admin/main.jsp").forward(req, resp);
        } else if ("listUsers".equals(method)) {
            List<User> users = userService.getAllUsers();
            req.setAttribute("users", users); // 对 request 对象进行加工
            req.getRequestDispatcher("/admin/users.jsp").forward(req, resp); // 将新的 request 对象传递给users.jsp
        } else if ("manageQuestions".equals(method)) {
            List<Question> questions = questionService.getAllQuestions(); // 获取题目列表
            req.setAttribute("questions", questions);
            req.getRequestDispatcher("/admin/questions.jsp").forward(req, resp);
        } else if ("addQuestion".equals(method)) {
            String content = req.getParameter("content");
            questionService.addQuestion(new Question(null, content));
            resp.sendRedirect("admin?method=manageQuestions");
        } else if ("editQuestion".equals(method)) {
            String id = req.getParameter("id");
            String content = req.getParameter("content");
            questionService.updateQuestion(new Question(id, content));
            resp.sendRedirect("admin?method=manageQuestions");
        } else if ("deleteQuestion".equals(method)) {
            String id = req.getParameter("id");
            questionService.deleteQuestion(id);
            resp.sendRedirect("admin?method=manageQuestions");
        }
    }
}
