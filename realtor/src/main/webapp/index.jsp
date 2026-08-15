<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MC Realtor - 登录</title>

    <%--自定义图标--%>
    <link rel="icon" href="/realtor/favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" href="/realtor/favicon.ico" type="image/x-icon">

    <script src="js/vue.global.js"></script>
    <script src="js/axios.min.js"></script>
    <script src="js/api.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            min-height: 100vh;
            background: #E0E5EC;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .login-card {
            width: 100%;
            max-width: 450px;
            background: #E0E5EC;
            border-radius: 32px;
            box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
            overflow: hidden;
        }
        .card-header {
            background: linear-gradient(135deg, #6C63FF 0%, #8B84FF 100%);
            padding: 30px;
            text-align: center;
        }
        .card-header h2 {
            color: white;
            font-size: 28px;
            font-weight: 700;
            margin: 0;
        }
        .card-header p {
            color: rgba(255, 255, 255, 0.85);
            margin-top: 8px;
            font-size: 14px;
        }
        .card-body {
            padding: 30px;
        }
        .nav-tabs {
            border-bottom: none;
            margin-bottom: 25px;
            display: flex;
            gap: 12px;
        }
        .nav-tabs .nav-link {
            border: none;
            color: #6B7280;
            font-weight: 600;
            padding: 12px 24px;
            border-radius: 16px;
            background: #E0E5EC;
            box-shadow: 5px 5px 10px rgb(163,177,198,0.6), -5px -5px 10px rgba(255,255,255,0.5);
            transition: all 0.3s ease;
        }
        .nav-tabs .nav-link.active {
            color: white;
            background: #6C63FF;
            box-shadow: inset 3px 3px 6px rgb(163,177,198,0.6), inset -3px -3px 6px rgba(255,255,255,0.3);
        }
        .nav-tabs .nav-link:hover:not(.active) {
            color: #3D4852;
            transform: translateY(-1px);
            box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-label {
            font-weight: 600;
            color: #3D4852;
            margin-bottom: 8px;
            display: block;
        }
        .form-control {
            width: 100%;
            padding: 14px 16px;
            border: none;
            border-radius: 16px;
            font-size: 15px;
            transition: all 0.3s;
            background: #E0E5EC;
            box-shadow: inset 6px 6px 10px rgb(163,177,198,0.6), inset -6px -6px 10px rgba(255,255,255,0.5);
            color: #3D4852;
        }
        .form-control:focus {
            outline: none;
            box-shadow: inset 10px 10px 20px rgb(163,177,198,0.7), inset -10px -10px 20px rgba(255,255,255,0.6);
        }
        .form-control::placeholder {
            color: #A0AEC0;
        }
        .btn-primary {
            width: 100%;
            padding: 14px;
            background: #6C63FF;
            border: none;
            border-radius: 16px;
            color: white;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 12px 12px 20px rgb(163,177,198,0.7), -12px -12px 20px rgba(255,255,255,0.6);
        }
        .btn-primary:active {
            transform: translateY(1px);
            box-shadow: inset 6px 6px 10px rgba(0,0,0,0.2), inset -6px -6px 10px rgba(255,255,255,0.1);
        }
        .alert {
            padding: 12px 16px;
            border-radius: 16px;
            border: none;
            margin-top: 15px;
            font-size: 14px;
        }
        .alert-success {
            background: #38B2AC;
            color: white;
            box-shadow: inset 4px 4px 8px rgba(0,0,0,0.15), inset -4px -4px 8px rgba(255,255,255,0.1);
        }
        .alert-danger {
            background: #E53E3E;
            color: white;
            box-shadow: inset 4px 4px 8px rgba(0,0,0,0.15), inset -4px -4px 8px rgba(255,255,255,0.1);
        }
        .tab-content {
            animation: fadeIn 0.3s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .neumorphic-toast {
            position: fixed; bottom: 50px; left: 50%; transform: translateX(-50%) translateY(100px);
            padding: 15px 25px; background: #3D4852; color: white;
            border-radius: 16px; z-index: 2000; opacity: 0; transition: all 0.3s ease;
            font-size: 14px; box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5);
        }
        .neumorphic-toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }
        /* 背景装饰 */
        .bg-decoration { position: fixed; pointer-events: none; z-index: 0; }
        .bg-circle {
            position: absolute; border-radius: 50%;
            background: #E0E5EC;
        }
        .bg-circle.extruded {
            box-shadow: 9px 9px 16px rgb(163,177,198,0.4), -9px -9px 16px rgba(255,255,255,0.4);
        }
        .bg-circle.inset {
            box-shadow: inset 6px 6px 10px rgb(163,177,198,0.35), inset -6px -6px 10px rgba(255,255,255,0.35);
        }
        .bg-ring {
            position: absolute; border-radius: 50%;
            background: transparent;
            border: 3px solid rgba(163,177,198,0.15);
            box-shadow: 3px 3px 6px rgb(163,177,198,0.2), -3px -3px 6px rgba(255,255,255,0.3);
        }
        @keyframes floatSlow {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-15px) rotate(3deg); }
        }
        @keyframes floatSlowReverse {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-12px) rotate(-2deg); }
        }
        .float-1 { animation: floatSlow 6s ease-in-out infinite; }
        .float-2 { animation: floatSlowReverse 8s ease-in-out infinite; }
        .float-3 { animation: floatSlow 7s ease-in-out infinite 1s; }
    </style>
</head>
<body>
    <div class="bg-decoration">
        <div class="bg-circle extruded float-1" style="width:320px;height:320px;top:-120px;left:-100px;"></div>
        <div class="bg-circle inset" style="width:220px;height:220px;top:40px;left:90px;"></div>
        <div class="bg-ring float-2" style="width:180px;height:180px;top:-60px;left:180px;"></div>

        <div class="bg-circle extruded float-2" style="width:280px;height:280px;bottom:-100px;right:-80px;"></div>
        <div class="bg-circle inset" style="width:180px;height:180px;bottom:50px;right:100px;"></div>
        <div class="bg-ring float-3" style="width:150px;height:150px;bottom:-30px;right:200px;"></div>

        <div class="bg-circle extruded float-3" style="width:200px;height:200px;top:50%;right:-60px;transform:translateY(-50%);"></div>
        <div class="bg-ring float-1" style="width:260px;height:260px;top:40%;left:-100px;"></div>
    </div>

    <div class="container" style="position:relative;z-index:1;">
        <!-- ========== Vue 根元素 ========== -->
        <div class="login-card" id="app">
            <div class="card-header">
                <h2>🏠 MC Realtor</h2>
                <p>欢迎登录或注册账号</p>
            </div>
            <div class="card-body">
                <ul class="nav nav-tabs">
                    <!--
                    写在开头：

                    我们在使用vue时，常常会在元素的属性列表中，看见以v-开头的语句，这些其实是vue指令：

                    常用的有
                    v-bind、v-on、v-model：属于响应式系统的范畴，下面会详细介绍
                    v-show、v-if与else：属于条件渲染的范畴。后面接布尔值，如果为true就渲染该元素
                    v-for：和for循环类似，常用来渲染表单等复合元素
                    -->

                    <li class="nav-item">

                        <%--
                        这里的：
                        “:”其实是v-bind（单向绑定，数据改变视图自动响应）的简写，
                        “@”其实是v-on（监听事件）的简写
                        --%>
                        <button class="nav-link" :class="{active: activeTab === 'login'}" @click="activeTab = 'login'">登录</button>

                    </li>
                    <li class="nav-item">
                        <button class="nav-link" :class="{active: activeTab === 'register'}" @click="activeTab = 'register'">注册</button>
                    </li>
                </ul>

                <!-- v-show 条件渲染-->
                <div class="tab-content">
                    <div v-show="activeTab === 'login'">
                        <div class="form-group">
                            <label class="form-label">用户名</label>

                            <%--v-model是老师课上提到的双向绑定，意味着数据改变视图会响应，视图改变数据也会自动改变--%>
                            <input type="text" v-model="loginForm.username" class="form-control" placeholder="请输入用户名">

                        </div>
                        <div class="form-group">
                            <label class="form-label">密码</label>
                            <input type="password" v-model="loginForm.password" class="form-control" placeholder="请输入密码">
                        </div>

                        <button class="btn btn-primary" @click="handleLogin">登录</button>
                    </div>

                    <div v-show="activeTab === 'register'">
                        <div class="form-group">
                            <label class="form-label">用户名</label>
                            <input type="text" v-model="registerForm.username" class="form-control" placeholder="请输入用户名">
                        </div>
                        <div class="form-group">
                            <label class="form-label">邮箱</label>
                            <input type="email" v-model="registerForm.email" class="form-control" placeholder="请输入邮箱">
                        </div>
                        <div class="form-group">
                            <label class="form-label">密码</label>
                            <input type="password" v-model="registerForm.password" class="form-control" placeholder="请输入密码">
                        </div>
                        <div class="form-group">
                            <label class="form-label">确认密码</label>
                            <input type="password" v-model="registerForm.confirmPassword" class="form-control" placeholder="请再次输入密码">
                        </div>
                        <button class="btn btn-primary" @click="handleRegister">注册</button>
                    </div>
                </div>

                <!-- v-if 条件渲染，{{}} 插值表达式显示数据 -->
                <div v-if="message" class="alert" :class="messageType === 'success' ? 'alert-success' : 'alert-danger'">
                    {{ message }}
                </div>

                <!-- Toast 通知：动态绑定 show 类实现显示/隐藏动画 -->
                <div class="neumorphic-toast" :class="{show: isToastVisible}">{{ toastMessage }}</div>
            </div>
        </div>
    </div>

    <script>

        /*
        这一部分负责初始化vue组件，并挂载到静态代码库中
        一旦挂载到静态库，就意味着这个组件可以在全局访问了
         */
        const { createApp } = Vue;

        createApp({
            /* ========== data() = 响应式状态（选项式 API）========== */
            data() {
                return {
                    activeTab: 'login', // login / register
                    loginForm: { username: '', password: '' },      // 登录表单
                    registerForm: { username: '', email: '', password: '', confirmPassword: '' }, // 注册表单
                    message: '', messageType: 'success',            // 消息提示
                    isToastVisible: false, toastMessage: ''          // Toast 状态和内容
                };
            },
            /* ========== methods = 事件处理函数 ========== */
            methods: {
                /* 登录：先跳转到验证码页面，存储表单数据，验证码通过后再进行后端校验
                 * 注意：验证码放在密码校验之前，防止自动化恶意登录
                 */
                handleLogin() {
                    if (!this.loginForm.username || !this.loginForm.password) {
                        this.showToast('请填写完整信息'); return;
                    }
                    // 将登录表单数据存储到 localStorage，验证码通过后使用
                    localStorage.setItem('pendingLogin', JSON.stringify({
                        username: this.loginForm.username,
                        password: this.loginForm.password
                    }));
                    localStorage.setItem('pendingAction', 'login'); // 标记待执行操作
                    localStorage.setItem('savedUsername', this.loginForm.username);
                    // 跳转到验证码页面
                    window.location.href = 'captcha.jsp';
                },
                /* 注册：先跳转到验证码页面，存储表单数据，验证码通过后再进行后端校验
                 * 注意：验证码放在邮箱/密码校验之前，防止自动化恶意注册
                 */
                handleRegister() {
                    if (!this.registerForm.username || !this.registerForm.email || !this.registerForm.password || !this.registerForm.confirmPassword) {
                        this.showToast('请填写完整信息'); return;
                    }
                    if (this.registerForm.password !== this.registerForm.confirmPassword) {
                        this.showToast('两次密码不一致'); return;
                    }
                    // 将注册表单数据存储到 localStorage，验证码通过后使用
                    localStorage.setItem('pendingRegister', JSON.stringify({
                        username: this.registerForm.username,
                        email: this.registerForm.email,
                        password: this.registerForm.password,
                        confirmPassword: this.registerForm.confirmPassword
                    }));
                    localStorage.setItem('pendingAction', 'register'); // 标记待执行操作
                    // 跳转到验证码页面
                    window.location.href = 'captcha.jsp';
                },

                /* Toast 通知：3秒后自动隐藏 */
                showToast(msg) {
                    this.toastMessage = msg;
                    this.isToastVisible = true;
                    setTimeout(() => { this.isToastVisible = false; }, 3000);
                }

            },
            /* ========== mounted() = 组件挂载后 ========== */
            mounted() {
                // 页面加载时检查是否有错误信息需要显示
                const errorMsg = localStorage.getItem('errorMessage');
                if (errorMsg) {
                    this.showToast(errorMsg);
                    localStorage.removeItem('errorMessage');
                }
            }

        }).mount('#app'); // 挂载到 id 为 app 的元素上，也就是第 211 行 vue 根元素
    </script>
</body>
</html>
