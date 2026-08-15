<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>安全验证</title>
    <link rel="icon" href="/realtor/favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" href="/realtor/favicon.ico" type="image/x-icon">
    <script src="js/vue.global.js"></script>
    <script src="js/axios.min.js"></script>
    <script src="js/api.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { min-height: 100vh; display: flex; align-items: center; justify-content: center; background: #E0E5EC; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; overflow: hidden; }
        .card { background: #E0E5EC; border-radius: 32px; box-shadow: 9px 9px 16px rgb(163,177,198,0.6), -9px -9px 16px rgba(255,255,255,0.5); padding: 35px; width: 100%; max-width: 500px; position: relative; }
        .card-header { text-align: center; margin-bottom: 20px; }
        .card-header h3 { color: #3D4852; font-size: 22px; font-weight: 600; margin: 0; }
        .card-header p { color: #6B7280; margin-top: 8px; font-size: 14px; }
        .captcha-container { width: 100%; height: 280px; background: linear-gradient(180deg, #74b9ff 0%, #0984e3 100%); border-radius: 24px; position: relative; overflow: hidden; cursor: crosshair; box-shadow: inset 6px 6px 10px rgb(163,177,198,0.4), inset -6px -6px 10px rgba(255,255,255,0.3); }
        .fish-wrapper { position: absolute; cursor: pointer; font-size: 45px; user-select: none; transition: none; }
        .fish-wrapper:hover { filter: brightness(1.15); }
        .fish-emoji { display: inline-block; animation: fishWiggle 0.5s ease-in-out infinite; }
        .fish-emoji.catched { animation: catchPulse 0.6s ease-out; }
        @keyframes fishWiggle { 0%, 100% { transform: rotate(-5deg); } 50% { transform: rotate(5deg); } }
        @keyframes catchPulse { 0% { transform: scale(1); } 50% { transform: scale(1.3); opacity: 0.8; } 100% { transform: scale(1); opacity: 1; } }
        .bubble { position: absolute; background: rgba(255, 255, 255, 0.6); border-radius: 50%; bottom: -20px; }
        .seaweed { position: absolute; bottom: 0; font-size: 30px; animation: seaweedSway 3s ease-in-out infinite; }
        @keyframes seaweedSway { 0%, 100% { transform: rotate(-5deg); } 50% { transform: rotate(5deg); } }
        @keyframes bubbleRise { 0% { bottom: -20px; opacity: 0.6; } 100% { bottom: 300px; opacity: 0; } }
        .status-text { text-align: center; margin-top: 20px; color: #6B7280; font-size: 15px; min-height: 24px; transition: all 0.3s; }
        .status-text.success { color: #38B2AC; font-weight: 600; }
        .status-text.error { color: #E53E3E; }
        .progress-bar { width: 100%; height: 12px; background: #E0E5EC; border-radius: 6px; margin-top: 15px; overflow: hidden; box-shadow: inset 3px 3px 6px rgb(163,177,198,0.6), inset -3px -3px 6px rgba(255,255,255,0.5); }
        .progress-fill { height: 100%; background: linear-gradient(90deg, #6C63FF 0%, #8B84FF 100%); width: 0%; transition: width 0.3s; border-radius: 6px; box-shadow: 3px 3px 6px rgb(163,177,198,0.3), -3px -3px 6px rgba(255,255,255,0.3); }
        .hint-text { text-align: center; margin-top: 10px; color: #6B7280; font-size: 13px; }
    </style>
</head>
<body>
    <!-- ========== Vue 根元素 ========== -->
    <div id="app" class="card">
        <div class="card-header">
            <h3>🎣 点击小鱼验证</h3>
            <p>请点击游动的小鱼完成验证</p>
        </div>

        <!-- 验证码容器：点击空白处判定为"没点到" -->
        <div class="captcha-container" @click="handleMiss">
            <!-- 5 棵海草，随机延迟错开摆动节奏 -->
            <div class="seaweed" style="left: 5%; animation-delay: 0s;">🌿</div>
            <div class="seaweed" style="left: 20%; animation-delay: 0.3s;">🌿</div>
            <div class="seaweed" style="left: 45%; animation-delay: 0.6s;">🌿</div>
            <div class="seaweed" style="left: 70%; animation-delay: 0.2s;">🌿</div>
            <div class="seaweed" style="left: 85%; animation-delay: 0.5s;">🌿</div>

            <!-- 气泡列表：v-for 渲染 8 个，大小/位置/动画延迟随机 -->
            <div v-for="bubble in bubbles" :key="bubble.id" class="bubble" :style="{ width: bubble.size + 'px', height: bubble.size + 'px', left: bubble.x + 'px', animation: 'bubbleRise 3s linear infinite', animationDelay: bubble.delay + 's' }"></div>

            <!-- 小鱼：位置由 fishX/fishY 控制，scaleX(1/-1) 控制水平翻转方向 -->
            <div class="fish-wrapper" :style="{left: fishX + 'px', top: fishY + 'px', transform: 'scaleX(' + fishFlip + ')'}" @click.stop="catchFish">
                <span class="fish-emoji" :class="{catched: isCatched}">🐟</span>
            </div>
        </div>

        <!-- 进度条：宽度 = 已点击次数 / 需要次数 × 100% -->
        <div class="progress-bar">
            <div class="progress-fill" :style="{width: progressPercent + '%'}"></div>
        </div>

        <!-- 状态文字：根据 statusClass 应用不同颜色 -->
        <div class="status-text" :class="statusClass">{{ statusText }}</div>
        <div class="hint-text">进度: {{ clickCount }} / {{ requiredClicks }} 次</div>
    </div>

    <script>

        // 先引入vue组件中的生命周期钩子，以备后面使用
        const { createApp, ref, reactive, onMounted, onUnmounted } = Vue;

        createApp({
            /* ========== setup() = 所有响应式状态和业务逻辑写在这里 ========== */
            setup() {
                // 创建响应式数据
                // 一般地，ref（reflect）用于创建数据，而reactive用于创建对象
                // 它们都是响应式的，支持数据和视图之间的绑定
                const fishX = ref(100);                 // 小鱼当前 X 坐标（px，相对于容器）
                const fishY = ref(100);                 // 小鱼当前 Y 坐标
                const targetX = ref(100);               // 本轮目标点 X 坐标
                const targetY = ref(100);               // 本轮目标点 Y 坐标
                const isCatched = ref(false);           // 小鱼是否刚被捕获（触发脉冲动画）
                const isVerified = ref(false);          // 整体验证是否已完成
                const statusText = ref('点击游动的小鱼开始验证'); // 状态提示文字
                const statusClass = ref('');             // 状态 CSS 类名：success/error
                const progressPercent = ref(0);           // 进度条百分比 0~100
                const clickCount = ref(0);                // 当前已成功点击次数
                const requiredClicks = ref(3);          // 需要成功点击的次数
                const fishFlip = ref(1);                  // scaleX：1=向左（默认），-1=向右（翻转）

                const bubbles = ref([]);                 // 气泡数组
                let fishAnimationId = null;               // requestAnimationFrame ID，用于取消动画
                let moveProgress = 0;                     // 本轮移动进度 0~1
                const containerWidth = 460;               // 容器实际宽度（500 - padding×2）
                const containerHeight = 280;              // 容器高度

                /* 初始化气泡数据 */
                const initBubbles = () => {
                    bubbles.value = Array.from({length: 8}, (_, i) => ({
                        id: i,                          // v-for 的 :key 必须唯一
                        size: 8 + Math.random() * 12,  // 直径 8~20px
                        x: 20 + Math.random() * (containerWidth - 40), // X 在 20~420 之间
                        delay: Math.random() * 2         // 启动延迟 0~2s，错开动画节奏
                    }));
                };

                /*
                我们想要实现平滑移动的效果，不妨使用正态分布的概率密度函数
                公式：f(t) = exp(-(t-μ)² / (2σ²))
                特点：开始和结束时缓慢，中间区域快速移动
                 */
                const gaussianEasing = (t) => {
                    const mean = 0.5;      // 均值，峰值位置（0~1 之间）
                    const sigma = 0.12;     // 标准差，控制钟形宽度（越小越尖锐）
                    
                    // 高斯公式
                    const exponent = -Math.pow(t - mean, 2) / (2 * Math.pow(sigma, 2));
                    return Math.exp(exponent);
                };

                /* 小鱼移动逻辑：每帧调用（约60fps） */
                const moveFish = () => {
                    if (isVerified.value) return; // 验证完成则停止动画

                    if (!isCatched.value) { // 被捕获时暂停移动
                        moveProgress += 0.008; // 每帧进度增加（约 7.5 秒走完一轮）

                        if (moveProgress >= 1) { // 一轮走完，重置并设新目标
                            moveProgress = 0;
                            setNewTarget();
                        }

                        // 线性插值 + 高斯缓动函数：从当前位置向目标点平滑移动
                        // 高斯函数返回 0~1 之间的值，峰值在中间（0.5），两端趋近于 0
                        const easedProgress = gaussianEasing(moveProgress);
                        fishX.value = targetX.value - 22.5 + (fishX.value - targetX.value + 22.5) * (1 - easedProgress);
                        fishY.value = targetY.value - 22.5 + (fishY.value - targetY.value + 22.5) * (1 - easedProgress);

                        // 根据目标方向决定是否水平翻转：目标在右 → scaleX(-1)，目标在左 → scaleX(1)
                        const dx = targetX.value - fishX.value;
                        // 设置阈值，只有当 dx 超过一定范围才改变方向，避免到达目标时抖动
                        if (dx > 5) {
                            fishFlip.value = -1; // 朝右
                        } else if (dx < -5) {
                            fishFlip.value = 1;  // 朝左
                        }
                        // 当 dx 在 -5 到 5 之间时，保持当前朝向不变
                    }

                    fishAnimationId = requestAnimationFrame(moveFish); // 递归调用，持续驱动动画
                };

                /* 生成新的随机目标点 */
                const setNewTarget = () => {
                    const newTargetX = 50 + Math.random() * (containerWidth - 100);  // X 在 50~410
                    const newTargetY = 50 + Math.random() * (containerHeight - 150); // Y 在 50~180，留出海草空间
                    
                    // 在设置新目标前，根据新目标位置决定朝向
                    const dx = newTargetX - fishX.value;
                    if (dx > 10) {
                        fishFlip.value = -1; // 新目标在右边，朝右游
                    } else if (dx < -10) {
                        fishFlip.value = 1;  // 新目标在左边，朝左游
                    }
                    // 如果 dx 在 -10 到 10 之间，保持当前朝向不变
                    
                    targetX.value = newTargetX;
                    targetY.value = newTargetY;
                };

                /* 点击小鱼（捕获成功）：计数 + 动画 + 判断完成 */
                const catchFish = () => {
                    if (isCatched.value || isVerified.value) return; // 防重复点击

                    isCatched.value = true;                                // 触发脉冲动画
                    clickCount.value++;                                    // 成功次数 +1
                    progressPercent.value = (clickCount.value / requiredClicks.value) * 100; // 更新进度条
                    statusText.value = `🎯 成功捕获! (${clickCount.value}/${requiredClicks.value})`;
                    statusClass.value = 'success';

                    setTimeout(() => {                                     // 500ms 后重置小鱼，继续下一轮
                        isCatched.value = false;
                        setNewTarget();
                        moveProgress = 0;

                        if (clickCount.value >= requiredClicks.value) {     // 达到所需次数 → 完成验证
                            completeVerification();
                        } else {
                            statusText.value = '继续点击小鱼...';
                            statusClass.value = '';
                        }
                    }, 500);
                };

                /* 点击空白处（未捕获）：提示错误 */
                const handleMiss = () => {
                    if (isVerified.value) return;
                    statusText.value = '😅 没点到！再试一次';
                    statusClass.value = 'error';
                    setTimeout(() => {
                        statusText.value = '点击游动的小鱼';
                        statusClass.value = '';
                    }, 1500);
                };

                /* 验证完成 → 验证码通过后执行登录/注册，然后跳转到主页
                 * 注意：验证码通过后才进行后端密码校验，这样验证码才能真正起到防自动化攻击的作用
                 */
                const completeVerification = async () => {
                    statusText.value = '🎉 验证成功！正在处理...';
                    statusClass.value = 'success';
                    isVerified.value = true;

                    try {
                        const pendingAction = localStorage.getItem('pendingAction');

                        if (pendingAction === 'login') {
                            // 读取登录表单数据并调用登录 API
                            const loginData = JSON.parse(localStorage.getItem('pendingLogin') || '{}');
                            const response = await api.post('/user/login', loginData);

                            if (response.status === 'success') {
                                localStorage.setItem('user', JSON.stringify(response.data));
                                localStorage.removeItem('pendingLogin');
                                localStorage.removeItem('pendingAction');

                                // 1.5秒后跳转到主页
                                setTimeout(() => {
                                    const user = response.data;
                                    window.location.href = user.role === 'admin' ? 'admin/dashboard.jsp' : 'user/home.jsp';
                                }, 1500);
                            } else {
                                // 登录失败：跳回登录页并传递错误信息
                                localStorage.setItem('errorMessage', response.message);
                                localStorage.removeItem('pendingLogin');
                                localStorage.removeItem('pendingAction');
                                window.location.href = 'index.jsp';
                            }
                        } else if (pendingAction === 'register') {
                            // 读取注册表单数据并调用注册 API
                            const registerData = JSON.parse(localStorage.getItem('pendingRegister') || '{}');
                            const response = await api.post('/user/register', registerData);

                            if (response.status === 'success') {
                                localStorage.setItem('user', JSON.stringify(response.data));
                                localStorage.removeItem('pendingRegister');
                                localStorage.removeItem('pendingAction');

                                // 1.5秒后跳转到主页
                                setTimeout(() => {
                                    const user = response.data;
                                    window.location.href = user.role === 'admin' ? 'admin/dashboard.jsp' : 'user/home.jsp';
                                }, 1500);
                            } else {
                                // 注册失败：跳回注册页并传递错误信息
                                localStorage.setItem('errorMessage', response.message);
                                localStorage.removeItem('pendingRegister');
                                localStorage.removeItem('pendingAction');
                                window.location.href = 'index.jsp';
                            }
                        } else {
                            // 没有待执行的操作，跳转到主页（兜底）
                            statusText.value = '🎉 验证成功！正在跳转...';
                            setTimeout(() => {
                                window.location.href = 'user/home.jsp';
                            }, 1500);
                        }
                    } catch (error) {
                        // 网络错误：跳回登录页并传递错误信息
                        localStorage.setItem('errorMessage', '网络错误，请重试');
                        localStorage.removeItem('pendingLogin');
                        localStorage.removeItem('pendingRegister');
                        localStorage.removeItem('pendingAction');
                        window.location.href = 'index.jsp';
                    }
                };

                /* ========== 生命周期钩子 ========== */
                /*
                所谓生命周期钩子，其实就是一系列提前被定义好的回调函数
                我们需要先在前面从vue组件中导入才可以使用
                那么，这些回调函数干什么用的呢？请看VCR——
                 */
                onMounted(() => {           // 组件挂载时：初始化气泡、设置目标、启动动画
                    initBubbles();
                    setNewTarget();
                    moveFish();
                });

                onUnmounted(() => {        // 组件卸载时：取消动画帧，防止内存泄漏
                    if (fishAnimationId) cancelAnimationFrame(fishAnimationId);
                });

                /* ========== 暴露给模板的变量和方法 ========== */
                return {
                    fishX, fishY, isCatched, statusText, statusClass,
                    progressPercent, clickCount, requiredClicks, bubbles,
                    fishFlip, catchFish, handleMiss
                };
            }
        }).mount('#app'); // 也是挂载到 id 为 app 的 vue 根元素上
    </script>
</body>
</html>
