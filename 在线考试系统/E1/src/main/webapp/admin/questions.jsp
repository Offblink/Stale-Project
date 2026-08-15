<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.exam.pojo.*, java.util.*" %>
<%
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    String keyword = (String) request.getAttribute("keyword");
    if (keyword == null) keyword = "";
%>
<html>
<head>
    <title>试题库管理 - 在线考试系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <style>
        :root {
            --primary: #4e73df;
            --primary-dark: #2e59d9;
            --success: #1cc88a;
            --danger: #e74a3b;
            --warning: #f6c23e;
            --light: #f8f9fc;
        }

        body {
            background-color: #f8f9fc;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px;
        }

        .main-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        /* 返回按钮 */
        .btn-back {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            transition: all 0.2s;
            margin-bottom: 25px;
        }

        .btn-back:hover {
            background-color: #5a6268;
            color: white;
            text-decoration: none;
            transform: translateY(-1px);
        }

        /* 主卡片容器 */
        .management-card {
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08),
            0 6px 20px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }

        .card-header-custom {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 25px 30px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .card-body-custom {
            padding: 30px;
        }

        /* 搜索区域样式 */
        .search-section {
            background-color: #f8f9fe;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid #e3e6f0;
        }

        .search-title {
            color: #5a5c69;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .search-title i {
            color: var(--primary);
            margin-right: 10px;
        }

        /* 表单控件自定义样式 */
        .form-control-custom {
            border: 1.5px solid #e1e5eb;
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 1rem;
            transition: all 0.2s;
        }

        .form-control-custom:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(78, 115, 223, 0.15);
        }

        /* 按钮样式 */
        .btn-search {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-search:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 12px rgba(78, 115, 223, 0.25);
        }

        .btn-reset {
            background-color: #858796;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-reset:hover {
            background-color: #6c757d;
            color: white;
            transform: translateY(-1px);
            text-decoration: none;
        }

        /* 新增试题区域 */
        .add-section {
            background-color: #f0f9f0;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 30px;
            border: 1px solid #d4edda;
        }

        .add-title {
            color: #155724;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .add-title i {
            color: var(--success);
            margin-right: 10px;
        }

        .btn-add {
            background: linear-gradient(135deg, var(--success) 0%, #13855c 100%);
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-add:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 12px rgba(28, 200, 138, 0.25);
        }

        /* 试题列表表格 */
        .questions-table-container {
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
            border: 1px solid #e3e6f0;
        }

        .table-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            padding: 18px 20px;
        }

        .questions-table {
            margin-bottom: 0;
        }

        .questions-table thead th {
            background-color: #f8f9fe;
            color: #5a5c69;
            border-bottom: 2px solid #e3e6f0;
            padding: 18px 20px;
            font-weight: 600;
        }

        .questions-table tbody td {
            padding: 20px;
            vertical-align: middle;
            border-bottom: 1px solid #e3e6f0;
        }

        .questions-table tbody tr:hover {
            background-color: #f8f9fe;
        }

        /* ID徽章样式 */
        .question-id {
            background-color: #e3e6f0;
            color: #5a5c69;
            padding: 6px 12px;
            border-radius: 6px;
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
        }

        /* 内联编辑表单 */
        .inline-edit-form {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .edit-input {
            flex: 1;
            border: 1.5px solid #e1e5eb;
            border-radius: 8px;
            padding: 10px 14px;
            transition: all 0.2s;
        }

        .edit-input:focus {
            border-color: var(--warning);
            box-shadow: 0 0 0 3px rgba(246, 194, 62, 0.15);
        }

        .btn-save {
            background-color: var(--warning);
            color: #856404;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .btn-save:hover {
            background-color: #e0a800;
            transform: translateY(-1px);
        }

        .btn-delete {
            background: linear-gradient(135deg, var(--danger) 0%, #c82333 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.2s;
            display: inline-block;
        }

        .btn-delete:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 12px rgba(231, 74, 59, 0.25);
            color: white;
            text-decoration: none;
        }

        /* 空状态提示 */
        .empty-state {
            padding: 60px 20px;
            text-align: center;
            color: #858796;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 20px;
            color: #d1d3e2;
        }

        /* 响应式调整 */
        @media (max-width: 768px) {
            body {
                padding: 15px;
            }

            .card-body-custom {
                padding: 20px;
            }

            .search-section, .add-section {
                padding: 20px;
            }

            .inline-edit-form {
                flex-direction: column;
                align-items: stretch;
            }

            .questions-table thead th,
            .questions-table tbody td {
                padding: 15px 12px;
            }
        }
    </style>
</head>
<body>
<div class="main-container">
    <!-- 返回按钮 -->
    <a href="admin?method=main" class="btn btn-back">
        <i class="bi bi-arrow-left me-2"></i>返回控制台主页
    </a>

    <!-- 主管理卡片 -->
    <div class="management-card">
        <!-- 卡片头部 -->
        <div class="card-header-custom">
            <h4 class="mb-2"><i class="bi bi-journal-text me-2"></i>试题库管理</h4>
            <p class="mb-0 opacity-75">搜索、添加、编辑和删除系统中的试题</p>
        </div>

        <!-- 卡片主体 -->
        <div class="card-body-custom">

            <!-- 新增试题区域 -->
            <div class="add-section">
                <h5 class="add-title">
                    <i class="bi bi-plus-circle"></i>新增试题
                </h5>
                <form action="admin?method=addQuestion" method="post" class="row g-3">
                    <div class="col-md-10 col-lg-11">
                        <input type="text" class="form-control form-control-custom"
                               name="content" placeholder="请输入新试题的内容"
                               required>
                    </div>
                    <div class="col-md-2 col-lg-1">
                        <button type="submit" class="btn btn-add w-100">
                            <i class="bi bi-plus-lg"></i>
                        </button>
                    </div>
                </form>
            </div>

            <!-- 试题列表 -->
            <div class="questions-table-container">
                <div class="table-header">
                    <h5 class="mb-0"><i class="bi bi-list-ul me-2"></i>试题列表</h5>
                </div>

                <% if (questions != null && !questions.isEmpty()) { %>
                <div class="table-responsive">
                    <table class="table questions-table">
                        <thead>
                        <tr>
                            <th style="width: 100px;">ID</th>
                            <th>题目内容</th>
                            <th style="width: 150px;">操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (Question q : questions) { %>
                        <tr>
                            <td>
                                        <span class="question-id" title="<%= q.getId() %>">
                                            <%= q.getId().substring(0, Math.min(5, q.getId().length())) %>...
                                        </span>
                            </td>
                            <td>
                                <form action="admin?method=editQuestion" method="post" class="inline-edit-form">
                                    <input type="hidden" name="id" value="<%= q.getId() %>">
                                    <input type="text" class="form-control edit-input"
                                           name="content" value="<%= q.getContent() %>"
                                           required>
                                    <button type="submit" class="btn btn-save" title="保存修改">
                                        <i class="bi bi-check-lg"></i>
                                    </button>
                                </form>
                            </td>
                            <td>
                                <a href="admin?method=deleteQuestion&id=<%= q.getId() %>"
                                   class="btn btn-delete"
                                   onclick="return confirm('确定要删除此试题吗？\n\n注意：此操作将同时删除所有学生对此题的答案和评分记录，且不可恢复！');">
                                    <i class="bi bi-trash me-1"></i>删除
                                </a>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <% } else { %>
                <div class="empty-state">
                    <i class="bi bi-journal-x"></i>
                    <h5 class="mt-3 mb-2">暂无试题</h5>
                    <p class="text-muted">
                        <% if (keyword != null && !keyword.isEmpty()) { %>
                        未找到包含"<strong><%= keyword %></strong>"的试题
                        <% } else { %>
                        试题库为空，请添加新的试题
                        <% } %>
                    </p>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>