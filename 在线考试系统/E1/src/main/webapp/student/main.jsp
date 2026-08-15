<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.exam.pojo.*, java.util.*, com.exam.service.*" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) { response.sendRedirect("index.jsp"); return; }

    List<Question> questions = (List<Question>) request.getAttribute("questions");
    List<Answer> myAnswers = (List<Answer>) request.getAttribute("myAnswers");
    ExamService examService = new ExamService();
%>
<html>
<head>
    <title>学生端 - 在线考试系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fc;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .navbar-custom {
            background-color: #fff;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
        }
        .main-container {
            max-width: 1200px;
        }
        .exam-card, .history-card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
        }
        .card-header-custom {
            background-color: #4e73df;
            color: white;
            border-radius: 1rem 1rem 0 0 !important;
            padding: 1.25rem 1.5rem;
        }
        .question-item {
            border-left: 4px solid #4e73df;
            padding-left: 1rem;
            margin-bottom: 1.5rem;
            background-color: #f8f9fe;
            padding: 1rem;
            border-radius: 0.5rem;
        }
        .answer-textarea {
            border-radius: 0.5rem;
            border: 1px solid #d1d3e2;
            transition: border-color 0.15s ease-in-out;
        }
        .answer-textarea:focus {
            border-color: #4e73df;
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
        }
        .table-custom {
            background-color: white;
            border-radius: 0.5rem;
            overflow: hidden;
            box-shadow: 0 0 0.875rem 0 rgba(33, 37, 41, 0.05);
        }
        .table-custom thead th {
            background-color: #4e73df;
            color: white;
            border: none;
            font-weight: 600;
        }
        .table-custom tbody tr:hover {
            background-color: rgba(78, 115, 223, 0.05);
        }
        .badge-graded {
            background-color: #1cc88a;
        }
        .badge-ungraded {
            background-color: #f6c23e;
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-light navbar-custom mb-4">
    <div class="container-fluid main-container">
        <a class="navbar-brand fw-bold text-primary" href="#">
            <i class="bi bi-journal-bookmark-fill me-2"></i>在线考试系统
        </a>
        <div class="d-flex align-items-center">
            <span class="me-3 text-dark">欢迎您，<strong><%= user.getUsername() %></strong> (学生)</span>
            <a href="student?method=toInfo" class="btn btn-outline-primary btn-sm me-2">
                <i class="bi bi-person-circle"></i> 账户信息
            </a>
            <a href="auth" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-box-arrow-right"></i> 退出
            </a>
        </div>
    </div>
</nav>

<div class="container main-container">
    <!-- 考试区域 -->
    <div class="card exam-card mb-4">
        <div class="card-header card-header-custom">
            <h5 class="card-title mb-0"><i class="bi bi-pencil-square me-2"></i>当前试题 (随机抽取)</h5>
        </div>
        <div class="card-body">
            <form action="student?method=submit" method="post">
                <% if (questions != null) {
                    for (int i = 0; i < questions.size(); i++) {
                        Question q = questions.get(i);
                %>
                <div class="question-item">
                    <p class="fw-bold mb-2">题目 <%= i+1 %>: <%= q.getContent() %></p>
                    <input type="hidden" name="questionId" value="<%= q.getId() %>">
                    <textarea class="form-control answer-textarea" name="answer_<%= q.getId() %>" rows="3" placeholder="请在此输入您的答案..." required></textarea>
                </div>
                <% } } else { %>
                <div class="text-center py-4 text-muted">
                    <i class="bi bi-inbox fs-1"></i>
                    <p class="mt-2">暂无待答试题</p>
                </div>
                <% } %>

                <% if (questions != null && !questions.isEmpty()) { %>
                <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-send-check me-2"></i>提交试卷
                    </button>
                </div>
                <% } %>
            </form>
        </div>
    </div>

    <!-- 历史记录区域 -->
    <div class="card history-card">
        <div class="card-header card-header-custom">
            <h5 class="card-title mb-0"><i class="bi bi-clock-history me-2"></i>已提交答案与评分</h5>
        </div>
        <div class="card-body">
            <% if (myAnswers != null && !myAnswers.isEmpty()) { %>
            <div class="table-responsive">
                <table class="table table-hover table-custom mb-0">
                    <thead>
                    <tr>
                        <th scope="col">题目内容</th>
                        <th scope="col" style="width: 25%;">我的答案</th>
                        <th scope="col" style="width: 15%;">评分</th>
                        <th scope="col" style="width: 20%;">评分教师</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Answer ans : myAnswers) {
                        Grade g = examService.getGradeByAnswerId(ans.getId());
                        String content = examService.getQuestionContent(ans.getQuestionId());
                    %>
                    <tr>
                        <td class="text-break"><%= content %></td>
                        <td class="text-break"><%= ans.getContent() %></td>
                        <td>
                            <% if (g != null) { %>
                            <span class="badge badge-graded rounded-pill bg-success p-2"><%= g.getScore() %></span>
                            <% } else { %>
                            <span class="badge badge-ungraded rounded-pill bg-warning p-2">未评分</span>
                            <% } %>
                        </td>
                        <td><%= g == null ? "-" : g.getTeacherUsername() %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } else { %>
            <div class="text-center py-5 text-muted">
                <i class="bi bi-journal-x fs-1"></i>
                <p class="mt-2">暂无历史提交记录</p>
            </div>
            <% } %>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>