<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.exam.pojo.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) { response.sendRedirect("index.jsp"); return; }
%>
<html>
<head>
    <title>管理员控制台</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <style>
        :root {
            --primary: #4e73df;
            --primary-dark: #2e59d9;
            --light: #f8f9fc;
            --gray: #858796;
        }
        body {
            background-color: #f8f9fc;
            font-family: 'Nunito', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        /* 顶部导航栏 - 新增 */
        .top-navbar {
            background: white;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
            padding: 0.75rem 1.5rem;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        /* 退出登录按钮样式 */
        .logout-btn {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: white;
            border: none;
            padding: 0.5rem 1.25rem;
            border-radius: 8px;
            font-weight: 500;
            display: flex;
            align-items: center;
            text-decoration: none;
            transition: all 0.2s;
        }

        .logout-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(78, 115, 223, 0.3);
            color: white;
            text-decoration: none;
        }

        .sidebar {
            background: linear-gradient(180deg, var(--primary) 0%, #224abe 100%);
            color: white;
            min-height: calc(100vh - 70px); /* 减去顶部导航栏高度 */
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }

        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            padding: 1rem 1.5rem;
            font-weight: 500;
        }

        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            color: white;
            background-color: rgba(255, 255, 255, 0.1);
        }

        .sidebar .nav-link i {
            margin-right: 0.75rem;
        }

        .main-content {
            padding: 2rem;
        }

        .welcome-card {
            border-left: 4px solid var(--primary);
            border-radius: 0.5rem;
        }

        .feature-card {
            border: none;
            border-radius: 1rem;
            transition: all 0.3s;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
            height: 100%;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.5rem 2rem 0 rgba(58, 59, 69, 0.2);
        }

        .feature-icon {
            width: 4rem;
            height: 4rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
            font-size: 1.75rem;
        }

        .icon-user { background-color: #e3f2fd; color: #1565c0; }
        .icon-question { background-color: #f3e5f5; color: #7b1fa2; }
    </style>
</head>
<body>
<!-- 顶部导航栏 - 包含退出登录入口 -->
<nav class="top-navbar">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center">
            <i class="bi bi-speedometer2 fs-4 text-primary me-2"></i>
            <span class="fw-bold text-gray-800">管理员控制台</span>
        </div>

        <!-- 右上角退出登录入口 -->
        <div class="d-flex align-items-center">
                <span class="me-3 text-muted d-none d-md-inline">
                    <i class="bi bi-person-circle me-1"></i> Admin
                </span>
            <a href="auth" class="logout-btn">
                <i class="bi bi-box-arrow-right me-2"></i> 退出登录
            </a>
        </div>
    </div>
</nav>

<div class="container-fluid">
    <div class="row">
        <!-- 侧边栏 -->
        <div class="col-auto col-md-3 col-xl-2 px-0 sidebar">
            <div class="d-flex flex-column align-items-center align-items-sm-start px-3 pt-4">
                <h4 class="mb-4"><i class="bi bi-menu-button-wide"></i> 功能菜单</h4>
                <hr class="w-100 text-white-50">
                <ul class="nav nav-pills flex-column mb-auto w-100">
                    <li class="nav-item">
                        <a href="admin?method=main" class="nav-link active">
                            <i class="bi bi-house-door"></i> 控制台主页
                        </a>
                    </li>
                    <li>
                        <a href="admin?method=listUsers" class="nav-link">
                            <i class="bi bi-people"></i> 用户查询
                        </a>
                    </li>
                    <li>
                        <a href="admin?method=manageQuestions" class="nav-link">
                            <i class="bi bi-journal-text"></i> 试题管理
                        </a>
                    </li>
                </ul>
                <hr class="w-100 text-white-50">
                <div class="text-white-50 small px-3 mb-3">
                    <i class="bi bi-info-circle me-1"></i> 在线考试系统 v1.0
                </div>
            </div>
        </div>

        <!-- 主内容区 -->
        <div class="col main-content">
            <!-- 欢迎卡片 -->
            <div class="card border-0 shadow-sm mb-4 welcome-card">
                <div class="card-body py-4">
                    <h5 class="card-title text-primary mb-1">欢迎回来，Admin</h5>
                    <p class="card-text text-muted">请从下方选择您要管理的功能模块，或使用左侧导航栏。</p>
                </div>
            </div>

            <!-- 功能模块 -->
            <h5 class="mb-3 text-gray-800">功能模块</h5>
            <div class="row g-4">
                <div class="col-md-6 col-lg-5 col-xl-4">
                    <a href="admin?method=listUsers" class="text-decoration-none">
                        <div class="card feature-card">
                            <div class="card-body p-4 text-center">
                                <div class="feature-icon icon-user mx-auto">
                                    <i class="bi bi-people-fill"></i>
                                </div>
                                <h5 class="card-title mb-2">用户查询</h5>
                                <p class="card-text text-muted small">查看与管理系统内的所有学生与教师账户信息。</p>
                            </div>
                        </div>
                    </a>
                </div>
                <div class="col-md-6 col-lg-5 col-xl-4">
                    <a href="admin?method=manageQuestions" class="text-decoration-none">
                        <div class="card feature-card">
                            <div class="card-body p-4 text-center">
                                <div class="feature-icon icon-question mx-auto">
                                    <i class="bi bi-journal-check"></i>
                                </div>
                                <h5 class="card-title mb-2">试题管理</h5>
                                <p class="card-text text-muted small">对题库进行增删改查操作，维护考试题目。</p>
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>