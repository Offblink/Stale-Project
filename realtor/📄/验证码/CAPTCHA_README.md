# 🎣 MC Realtor 验证码系统

一个**游戏化、交互式**的验证码系统，采用"点击游动小鱼"的创新验证方式，为用户提供有趣的验证体验。

## ✨ 设计特色

| 特色 | 说明 |
| :--- | :--- |
| **游戏化验证** | 点击游动的小鱼完成验证，而非传统文字输入 |
| **渐进式挑战** | 需要成功点击 3 次小鱼才能完成验证 |
| **精美的海底场景** | 包含气泡、海草、游动小鱼等动画元素 |
| **平滑动画效果** | 使用缓动函数实现自然的小鱼游动效果 |
| **防作弊机制** | 后端记录目标位置，验证点击精度 |

## 🎮 交互流程

```
用户登录/注册 → 进入验证码页面 → 点击游动的小鱼（3次）→ 验证成功 → 后端校验密码/邮箱 → 跳转主界面
     │                              │
     │                              └──→ 点击空白处 → 提示"没点到" → 继续尝试
     │
     └──→ 后端生成随机目标位置 → 存储到 Session → 返回给前端
```

> **重要设计**：验证码位于登录/注册流程的最前面，在密码校验之前执行。这样验证码能够真正起到防止自动化恶意登录/注册的作用。

## 📁 代码结构

```
src/main/java/com/example/realtor/controller/
├── CaptchaServlet.java      # 后端验证码逻辑
src/main/webapp/
├── captcha.jsp              # 前端验证码页面（Vue 3）
```

## 🔧 核心实现

### 后端：CaptchaServlet

**生成验证码** (`GET /api/captcha/generate`)

```java
// 生成 50~250 之间的随机目标位置
int targetPosition = new Random().nextInt(200) + 50;
// 存储到 Session，供后续验证使用
session.setAttribute("captchaPosition", targetPosition);
```

**验证点击** (`POST /api/captcha/verify`)

```java
int userPosition = Integer.parseInt(request.getParameter("position"));
Integer targetPosition = (Integer) session.getAttribute("captchaPosition");

int tolerance = 15;  // 容差 ±15px
boolean success = Math.abs(userPosition - targetPosition) <= tolerance;
```

**设计要点**：
- 使用 Session 存储目标位置，防止前端篡改
- 设置 15px 容差，允许用户有一定的点击误差

### 前端：Vue 3 验证码组件

**核心数据结构**

```javascript
const fishX = ref(100);           // 小鱼当前 X 坐标
const fishY = ref(100);           // 小鱼当前 Y 坐标
const targetX = ref(100);         // 本轮目标点 X 坐标
const targetY = ref(100);         // 本轮目标点 Y 坐标
const clickCount = ref(0);        // 当前成功点击次数
const requiredClicks = ref(3);    // 需要成功点击次数
const fishFlip = ref(1);          // 小鱼朝向：1=向左，-1=向右
```

**平滑移动算法**

```javascript
// 缓动函数：easeInOutCubic
const easeInOutCubic = (t) => {
    return t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2;
};

// 使用 requestAnimationFrame 实现流畅动画
const moveFish = () => {
    moveProgress += 0.008;
    const easedProgress = easeInOutCubic(moveProgress);
    fishX.value = targetX.value + (fishX.value - targetX.value) * (1 - easedProgress);
    fishY.value = targetY.value + (fishY.value - targetY.value) * (1 - easedProgress);
    
    fishAnimationId = requestAnimationFrame(moveFish);
};
```

**设计要点**：
- 使用 `easeInOutCubic` 缓动函数实现自然加速/减速效果
- 小鱼根据目标方向自动翻转朝向
- 使用 `requestAnimationFrame` 保证约 60fps 的流畅动画

## 🎨 视觉效果

### 动画元素

| 元素 | 动画效果 | 实现方式 |
| :--- | :--- | :--- |
| **小鱼** | 摆动身体 + 平滑游动 | CSS @keyframes + requestAnimationFrame |
| **气泡** | 从底部向上浮起 | CSS animation (bubbleRise) |
| **海草** | 左右摇摆 | CSS animation (seaweedSway) |
| **捕获反馈** | 脉冲放大效果 | CSS animation (catchPulse) |

### CSS 动画定义

```css
/* 小鱼摆动 */
@keyframes fishWiggle {
    0%, 100% { transform: rotate(-5deg); }
    50% { transform: rotate(5deg); }
}

/* 捕获脉冲 */
@keyframes catchPulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.3); opacity: 0.8; }
    100% { transform: scale(1); opacity: 1; }
}

/* 气泡上升 */
@keyframes bubbleRise {
    0% { bottom: -20px; opacity: 0.6; }
    100% { bottom: 300px; opacity: 0; }
}

/* 海草摇摆 */
@keyframes seaweedSway {
    0%, 100% { transform: rotate(-5deg); }
    50% { transform: rotate(5deg); }
}
```

## 🛡️ 安全机制

### 前端防护
- 防重复点击：捕获动画期间禁止再次点击
- 验证完成后停止动画
- 组件卸载时取消动画帧（防止内存泄漏）

### 后端验证
- 目标位置存储在 Session 中，前端无法篡改
- 设置合理容差（±15px），既保证安全性又不影响用户体验
- 需要先调用 `/generate` 获取目标位置，才能调用 `/verify` 验证

## 📊 交互流程状态图

```
         ┌─────────────────┐
         │   进入验证码页   │
         └────────┬────────┘
                  ▼
         ┌─────────────────┐
         │  小鱼开始游动    │◄──────────────┐
         └────────┬────────┘               │
                  ▼                        │
         ┌─────────────────┐               │
         │   用户点击屏幕   │               │
         └────────┬────────┘               │
                  │                        │
         ┌────────┴────────┐               │
         │                 │               │
         ▼                 ▼               │
   ┌───────────┐    ┌───────────┐         │
   │ 点击小鱼   │    │ 点击空白   │         │
   └─────┬─────┘    └─────┬─────┘         │
         │                │                │
         ▼                ▼                │
   ┌───────────┐    ┌───────────┐         │
   │ 成功捕获   │    │ 提示错误   │         │
   │ 进度+1    │    │ 继续尝试   │         │
   └─────┬─────┘    └─────┬─────┘         │
         │                └────────────────┘
         ▼
   ┌─────────────────┐
   │ 达到3次成功？   │
   └────────┬────────┘
            │
    ┌───────┴───────┐
    │               │
    ▼               ▼
 [是]            [否]
    │               │
    ▼               │
验证成功           └──→ 继续游动
    │
    ▼
┌─────────────────┐
│ 读取存储的表单数据 │
│ 调用登录/注册 API │
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
  成功      失败
    │         │
    ▼         ▼
跳转主页   显示错误
```

## 🎯 使用方式

### 页面入口

登录/注册时，输入完表单后先跳转到 `captcha.jsp`（验证码在密码校验之前）：

```javascript
// index.jsp 中：登录/注册时先存储表单数据，然后跳转到验证码页面
handleLogin() {
    // ... 表单验证
    localStorage.setItem('pendingLogin', JSON.stringify({ username, password }));
    localStorage.setItem('pendingAction', 'login');
    window.location.href = 'captcha.jsp';
}
```

### 验证成功后的跳转

根据用户角色跳转到对应界面：

```javascript
const completeVerification = () => {
    const user = JSON.parse(localStorage.getItem('user') || '{}');
    window.location.href = user.role === 'admin' 
        ? 'admin/dashboard.jsp' 
        : 'user/home.jsp';
};
```

## 💡 技术亮点

1. **游戏化体验**：将枯燥的验证过程转化为有趣的小游戏
2. **流畅动画**：使用 `requestAnimationFrame` + 缓动函数实现 60fps 流畅动画
3. **响应式设计**：使用 Vue 3 组合式 API 管理状态
4. **安全可靠**：后端验证机制防止作弊
5. **视觉精美**：完整的海底场景，包含气泡、海草等装饰元素
6. **渐进式难度**：需要点击 3 次才能完成，增加破解难度

## 📝 许可证

MIT License