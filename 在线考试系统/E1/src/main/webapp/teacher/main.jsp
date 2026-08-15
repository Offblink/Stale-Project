<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.exam.pojo.*, java.util.*, com.exam.service.*" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) { response.sendRedirect("index.jsp"); return; }

    List<Answer> answers = (List<Answer>) request.getAttribute("answers");
    ExamService examService = new ExamService();
%>
<html>
<head>
    <title>教师工作台 - 在线考试系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fc;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .navbar-custom {
            background: linear-gradient(90deg, #4e73df 0%, #224abe 100%);
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.2);
        }
        .main-container {
            max-width: 1400px;
        }
        .dashboard-card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
        }
        .card-header-custom {
            background-color: transparent;
            border-bottom: 1px solid #e3e6f0;
            padding: 1.25rem 1.5rem;
        }
        .table-container {
            background-color: white;
            border-radius: 0.75rem;
            overflow: hidden;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
        }
        .table thead th {
            background-color: #4e73df;
            color: white;
            border: none;
            font-weight: 600;
            padding: 1rem 1.5rem;
        }
        .table tbody td {
            padding: 1rem 1.5rem;
            vertical-align: middle;
        }
        .table tbody tr {
            border-bottom: 1px solid #e3e6f0;
            transition: background-color 0.15s;
        }
        .table tbody tr:hover {
            background-color: #f8f9fe;
        }
        .status-graded {
            color: #1cc88a;
            font-weight: 600;
        }
        .status-pending {
            color: #f6c23e;
            font-weight: 600;
        }
        .grade-form {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .grade-select {
            flex: 1;
            min-width: 100px;
        }
        .btn-grade {
            white-space: nowrap;
        }
        .answer-content {
            max-width: 300px;
            word-wrap: break-word;
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom mb-4">
    <div class="container-fluid main-container">
        <a class="navbar-brand fw-bold" href="#">
            <i class="bi bi-person-badge me-2"></i>教师工作台
        </a>
        <div class="d-flex align-items-center">
            <a href="teacher?method=toInfo" class="btn btn-outline-light btn-sm me-2">
                <i class="bi bi-gear"></i> 账户设置
            </a>
            <a href="auth" class="btn btn-outline-light btn-sm">
                <i class="bi bi-box-arrow-right"></i> 退出
            </a>
        </div>
    </div>
</nav>

<div class="container main-container">
    <div class="dashboard-card">
        <div class="card-header-custom">
            <h5 class="card-title mb-0 text-gray-800"><i class="bi bi-list-task me-2"></i>学生答案列表</h5>
            <p class="text-muted mb-0 mt-1">请对以下学生提交的答案进行评分。</p>
        </div>
        <div class="card-body p-0">
            <% if (answers != null && !answers.isEmpty()) { %>
            <div class="table-container">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead>
                        <tr>
                            <th scope="col" style="width: 12%;">学生</th>
                            <th scope="col" style="width: 28%;">题目内容</th>
                            <th scope="col" style="width: 25%;">答案内容</th>
                            <th scope="col" style="width: 15%;">提交时间</th>
                            <th scope="col" style="width: 10%;">评分状态</th>
                            <th scope="col" style="width: 10%;">操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Answer ans : answers) {
                            String content = examService.getQuestionContent(ans.getQuestionId());
                            Grade g = examService.getGradeByAnswerId(ans.getId());
                        %>
                        <tr>
                            <td class="fw-bold"><%= ans.getStudentUsername() %></td>
                            <td class="text-break"><%= content %></td>
                            <td class="answer-content text-break"><%= ans.getContent() %></td>
                            <td class="text-muted"><small><%= ans.getSubmitTime() %></small></td>
                            <td>
                                <% if (g != null) { %>
                                <span class="status-graded"><%= g.getScore() %></span>
                                <br><small class="text-muted">by <%= g.getTeacherUsername() %></small>
                                <% } else { %>
                                <span class="status-pending">未评分</span>
                                <% } %>
                            </td>
                            <td>
                                <% if (g == null) { %>
                                <form action="teacher?method=grade" method="post" class="grade-form">
                                    <input type="hidden" name="answerId" value="<%= ans.getId() %>">
                                    <select name="score" class="form-select form-select-sm grade-select" required>
                                        <option value="" disabled selected>选择评分</option>
                                        <option value="优秀">优秀</option>
                                        <option value="良好">良好</option>
                                        <option value="合格">合格</option>
                                    </select>
                                    <button type="submit" class="btn btn-primary btn-sm btn-grade">提交</button>
                                </form>
                                <% } else { %>
                                <span class="badge bg-light text-dark border">已评分</span>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
            <% } else { %>
            <div class="text-center py-5 text-muted">
                <i class="bi bi-inbox fs-1"></i>
                <p class="mt-2">暂无待评分的答案</p>
            </div>
            <% } %>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>