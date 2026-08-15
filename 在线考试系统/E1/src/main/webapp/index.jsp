<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>在线考试系统 - 登录/注册</title>
    <link rel="stylesheet" href="layui/css/layui.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
        }
        .login-container {
            width: 420px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            overflow: hidden;
        }
        .login-header {
            background: linear-gradient(to right, #007bff, #0056b3);
            color: white;
            text-align: center;
            padding: 30px 20px;
        }
        .login-header h2 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
        }
        .login-header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
            font-size: 14px;
        }
        .login-body {
            padding: 30px;
        }
        /* 通用消息盒子样式 */
        .message-box {
            padding: 12px 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-size: 14px;
            border-left: 4px solid;
            display: ${empty msg ? 'none' : 'block'};
        }
        /* 成功消息样式 */
        .success-msg {
            background-color: #f0f9eb;
            border-left-color: #67c23a;
            color: #67c23a;
        }
        /* 错误消息样式 */
        .error-msg {
            background-color: #fff5f5;
            border-left-color: #ff5722;
            color: #f56c6c;
        }
        .layui-tab {
            margin: 0;
            border: none;
        }
        .layui-tab-title {
            border-bottom: 1px solid #e8e8e8;
        }
        .layui-tab-title li {
            font-size: 16px;
        }
        .layui-tab-title li.layui-this {
            color: #007bff;
        }
        .layui-tab-title li.layui-this:after {
            background-color: #007bff;
            height: 3px;
        }
        .layui-tab-content {
            padding: 25px 0 0 0;
        }
        .layui-form-item {
            margin-bottom: 22px;
        }
        .layui-form-label {
            width: 80px;
            padding: 9px 5px;
        }
        .layui-input-block {
            margin-left: 100px;
            min-height: 36px;
        }
        .layui-input {
            height: 40px;
            line-height: 40px;
            border-radius: 4px;
            border: 1px solid #dcdfe6;
            transition: border-color 0.2s;
        }
        .layui-input:focus {
            border-color: #007bff;
        }
        .layui-btn {
            height: 42px;
            line-height: 42px;
            border-radius: 4px;
            font-size: 16px;
        }
        .layui-btn-primary {
            border-color: #007bff;
            color: #007bff;
        }
        .login-footer {
            text-align: center;
            padding: 20px 0 0 0;
            color: #909399;
            font-size: 13px;
            border-top: 1px solid #e8e8e8;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-header">
        <h2>在线考试系统</h2>
        <p>欢迎使用，请登录或注册新账户</p>
    </div>

    <div class="login-body">
        <!-- 消息显示区域 (根据内容动态应用样式) -->
        <div class="message-box" id="msgBox">
            <i class="layui-icon" id="msgIcon" style="margin-right: 5px;"></i><span id="msgText">${msg}</span>
        </div>

        <div class="layui-tab">
            <ul class="layui-tab-title">
                <li class="layui-this">用户登录</li>
                <li>用户注册</li>
            </ul>
            <div class="layui-tab-content">
                <!-- 登录表单 -->
                <div class="layui-tab-item layui-show">

                    <%--1.AuthServlet--%>
                    <form class="layui-form" action="auth" method="post">
                        <input type="hidden" name="action" value="login">

                        <div class="layui-form-item">
                            <label class="layui-form-label">用户名</label>
                            <div class="layui-input-block">
                                <input type="text" name="username" required lay-verify="required"
                                       placeholder="请输入用户名" autocomplete="username" class="layui-input">
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">密码</label>
                            <div class="layui-input-block">
                                <input type="password" name="password" required lay-verify="required"
                                       placeholder="请输入密码" autocomplete="current-password" class="layui-input">
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <div class="layui-input-block" style="margin-left: 0;">
                                <button class="layui-btn layui-btn-fluid" lay-submit lay-filter="loginForm">
                                    <i class="layui-icon">&#xe66f;</i> 立即登录
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- 注册表单 -->
                <div class="layui-tab-item">
                    <form class="layui-form" action="auth" method="post" lay-filter="registerForm">
                        <input type="hidden" name="action" value="register">

                        <div class="layui-form-item">
                            <label class="layui-form-label">用户名</label>
                            <div class="layui-input-block">
                                <input type="text" name="username" required lay-verify="required"
                                       placeholder="请输入用户名" autocomplete="new-username" class="layui-input">
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">密码</label>
                            <div class="layui-input-block">
                                <input type="password" name="password" id="regPassword" required lay-verify="required|pass"
                                       placeholder="请输入密码" autocomplete="new-password" class="layui-input">
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">确认密码</label>
                            <div class="layui-input-block">
                                <input type="password" name="confirmPassword" required lay-verify="required|confirmPass"
                                       placeholder="请再次输入密码" autocomplete="new-password" class="layui-input">
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">身份</label>
                            <div class="layui-input-block">
                                <select name="role" lay-verify="required">
                                    <option value="">请选择身份</option>
                                    <option value="student">学生</option>
                                    <option value="teacher">教师</option>
                                </select>
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <div class="layui-input-block" style="margin-left: 0;">
                                <button class="layui-btn layui-btn-fluid layui-btn-normal" lay-submit>
                                    <i class="layui-icon">&#xe654;</i> 立即注册
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="login-footer">
            <p>© 2026 在线考试系统 | 技术支持</p>
        </div>
    </div>
</div>

<script src="layui/layui.js"></script>
<script>
    layui.use(['form', 'element'], function(){
        var form = layui.form;
        var element = layui.element;
        var $ = layui.$;

        // --- 页面加载时，动态设置消息框样式和图标 ---
        $(document).ready(function() {
            var msgText = $('#msgText').text();
            var $msgBox = $('#msgBox');
            var $msgIcon = $('#msgIcon');

            if (msgText && msgText.trim() !== '') {
                // 判断是否为成功消息（例如包含“成功”、“欢迎”等关键词）
                var lowerCaseMsg = msgText.toLowerCase();
                if (lowerCaseMsg.indexOf('成功') !== -1 || lowerCaseMsg.indexOf('欢迎') !== -1) {
                    $msgBox.addClass('success-msg');
                    $msgIcon.html('&#xe605;'); // LayUI 的“笑脸/成功”图标
                } else {
                    $msgBox.addClass('error-msg');
                    $msgIcon.html('&#xe69c;'); // LayUI 的“感叹号/提示”图标
                }
                $msgBox.show(); // 确保有消息时显示
            } else {
                $msgBox.hide(); // 无消息时隐藏
            }
        });
        // --- 动态样式设置结束 ---

        // 自定义验证规则
        form.verify({
            pass: [
                /^[\S]{6,12}$/,
                '密码必须6到12位，且不能出现空格'
            ],
            confirmPass: function(value){
                var password = $('#regPassword').val();
                if(value !== password){
                    return '两次输入的密码不一致';
                }
            }
        });

        // 监听提交
        form.on('submit(loginForm)', function(data){
            return true; // 表单正常提交
        });

        // 如果存在错误消息，且消息可能和注册相关，自动切换到注册标签页
        var errorMsg = '${msg}';
        if(errorMsg && (errorMsg.indexOf('注册') !== -1 || errorMsg.indexOf('存在') !== -1)) {
            element.tabChange('user', '1'); // 切换到注册标签页
        }
    });
</script>
</body>
</html>