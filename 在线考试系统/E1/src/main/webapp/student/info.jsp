<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.exam.pojo.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    if (user == null) { response.sendRedirect("index.jsp"); return; }
%>
<html>
<head>
    <title>账户管理 - 在线考试系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <style>
        /* 基础样式 - 解决紧贴边框问题 */
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e3e8f0 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20px; /* 为body添加基础内边距 */
            margin: 0;
        }

        /* 主容器 - 创建清晰的视觉边界 */
        .main-container {
            max-width: 520px; /* 限制最大宽度 */
            margin: 0 auto; /* 水平居中 */
            padding: 20px;
        }

        /* 返回按钮区域 - 与主卡片分离 */
        .nav-back {
            margin-bottom: 25px;
            padding: 0 5px; /* 确保按钮不贴边 */
        }

        .btn-back {
            background-color: #6c757d;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            transition: all 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
        }

        .btn-back:hover {
            background-color: #5a6268;
            transform: translateY(-1px);
            color: white;
            text-decoration: none;
        }

        /* 主卡片 - 核心视觉容器 */
        .account-card {
            background-color: white;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08),
            0 6px 20px rgba(0, 0, 0, 0.05);
            overflow: hidden; /* 确保内部元素圆角生效 */
            border: 1px solid rgba(0, 0, 0, 0.05); /* 极细边框定义边缘 */
        }

        /* 卡片头部 - 与内容区有明显区分 */
        .card-header-custom {
            background: linear-gradient(135deg, #4e73df 0%, #2e59d9 100%);
            color: white;
            padding: 30px 35px 25px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .card-header-custom h4 {
            font-weight: 600;
            margin-bottom: 8px;
        }

        .card-header-custom p {
            opacity: 0.9;
            font-size: 0.95rem;
            margin-bottom: 0;
        }

        /* 卡片主体 - 充足的内边距 */
        .card-body-custom {
            padding: 35px;
        }

        /* 表单区域样式 */
        .form-section {
            margin-bottom: 30px;
        }

        .section-title {
            color: #4a4a4a;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f2f5;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 10px;
            color: #4e73df;
        }

        /* 表单控件样式 */
        .form-label {
            font-weight: 500;
            color: #555;
            margin-bottom: 8px;
        }

        .form-control-custom {
            border: 1.5px solid #e1e5eb;
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 1rem;
            transition: all 0.2s;
        }

        .form-control-custom:focus {
            border-color: #4e73df;
            box-shadow: 0 0 0 3px rgba(78, 115, 223, 0.15);
        }

        .form-text-custom {
            color: #6c757d;
            font-size: 0.85rem;
            margin-top: 6px;
        }

        /* 按钮样式 */
        .btn-save {
            background: linear-gradient(135deg, #4e73df 0%, #2e59d9 100%);
            color: white;
            border: none;
            padding: 14px 24px;
            border-radius: 10px;
            font-weight: 600;
            width: 100%;
            transition: all 0.2s;
            margin-top: 10px;
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(78, 115, 223, 0.25);
        }

        /* 分割线 */
        .section-divider {
            display: flex;
            align-items: center;
            margin: 35px 0;
            color: #adb5bd;
        }

        .section-divider::before,
        .section-divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #e9ecef;
        }

        .section-divider span {
            padding: 0 15px;
            font-size: 0.9rem;
        }

        /* 危险操作区域 */
        .danger-section {
            background-color: #fff5f5;
            border-radius: 12px;
            padding: 25px;
            border: 1px solid #f8d7da;
        }

        .danger-title {
            color: #dc3545;
            font-weight: 600;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }

        .danger-title i {
            margin-right: 10px;
        }

        .danger-text {
            color: #856404;
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 20px;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 14px 24px;
            border-radius: 10px;
            font-weight: 600;
            width: 100%;
            transition: all 0.2s;
        }

        .btn-delete:hover {
            background-color: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(220, 53, 69, 0.25);
        }

        /* 消息提示样式 */
        .alert-custom {
            border-radius: 10px;
            border: 1px solid transparent;
            padding: 16px 20px;
            margin-bottom: 25px;
        }

        /* 响应式调整 */
        @media (max-width: 576px) {
            body {
                padding: 15px;
            }

            .main-container {
                padding: 10px;
            }

            .card-header-custom,
            .card-body-custom {
                padding: 25px 20px;
            }

            .danger-section {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
<!-- 主容器：定义明确边界 -->
<div class="main-container">
    <!-- 返回按钮区域：与卡片分离 -->
    <div class="nav-back">
        <a href="student?method=main" class="btn btn-back">
            <i class="bi bi-arrow-left me-2"></i>返回主界面
        </a>
    </div>

    <!-- 主卡片：所有内容的视觉容器 -->
    <div class="account-card">
        <!-- 卡片头部 -->
        <div class="card-header-custom">
            <h4><i class="bi bi-person-gear me-2"></i>账户管理</h4>
            <p>管理您的账户信息与安全设置</p>
        </div>

        <!-- 卡片主体 -->
        <div class="card-body-custom">

            <!-- 第一部分：修改账户信息 -->
            <div class="form-section">
                <h5 class="section-title">
                    <i class="bi bi-pencil-square"></i>更改账户信息
                </h5>

                <form action="student?method=updateInfo" method="post">
                    <div class="mb-4">
                        <label for="newUsername" class="form-label">新用户名</label>
                        <input type="text" class="form-control form-control-custom"
                               id="newUsername" name="newUsername"
                               value="<%= user.getUsername() %>" required>
                    </div>

                    <div class="mb-4">
                        <label for="newPassword" class="form-label">新密码</label>
                        <input type="password" class="form-control form-control-custom"
                               id="newPassword" name="newPassword"
                               placeholder="输入新密码 (不修改请留空)">
                        <div class="form-text form-text-custom">
                            若不修改密码，请将此栏留空。建议密码长度至少8位，包含字母和数字。
                        </div>
                    </div>

                    <button type="submit" class="btn btn-save">
                        <i class="bi bi-check-circle me-2"></i>保存更改
                    </button>
                </form>
            </div>

            <!-- 分割线 -->
            <div class="section-divider">
                <span>或</span>
            </div>

            <!-- 第二部分：危险操作 -->
            <div class="danger-section">
                <h6 class="danger-title">
                    <i class="bi bi-exclamation-triangle"></i>危险操作
                </h6>

                <p class="danger-text">
                    <strong>警告：</strong>注销账户将永久删除您的所有数据，包括考试记录、提交的答案和个人信息。此操作不可撤销，请谨慎操作。
                </p>

                <form action="student?method=deleteAccount" method="post"
                      onsubmit="return confirm('您确定要注销账户吗？此操作将永久删除您的所有信息，且无法恢复！');">
                    <button type="submit" class="btn btn-delete">
                        <i class="bi bi-trash me-2"></i>注销账户
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>