# 🎨 MC Realtor 前端 UI 风格指南

本文档定义了 MC Realtor 项目的前端设计规范，确保后续开发保持一致的视觉风格和交互体验。

## 📋 目录

- [设计风格概述](#设计风格概述)
- [颜色规范](#颜色规范)
- [Neumorphism 设计](#neumorphism-设计)
- [按钮样式](#按钮样式)
- [输入框样式](#输入框样式)
- [卡片样式](#卡片样式)
- [模态框设计](#模态框设计)
- [Toast 通知设计](#toast-通知设计)
- [导航栏设计](#导航栏设计)
- [表格样式](#表格样式)
- [侧边栏设计](#侧边栏设计)
- [动画效果](#动画效果)
- [Vue 组件开发规范](#vue-组件开发规范)

---

## 🎯 设计风格概述

### 整体风格
- **设计模式**: Neumorphism（新拟态）
- **主色调**: 紫色渐变 (#6C63FF → #8B84FF)
- **背景色**: 浅灰蓝色 (#E0E5EC)
- **字体**: Segoe UI, Tahoma, Geneva, Verdana, sans-serif

### 设计原则
1. 柔和的阴影效果，模拟物理材质感
2. 圆角设计（16px ~ 32px）
3. 柔和的色彩过渡
4. 微动效增强交互反馈

---

## 🎨 颜色规范

### 主色调

| 颜色名称 | HEX | 用途 |
| :--- | :--- | :--- |
| **Primary** | `#6C63FF` | 主按钮、强调文字、链接 |
| **Primary Light** | `#8B84FF` | 悬停状态、渐变 |
| **Background** | `#E0E5EC` | 页面背景、卡片背景 |
| **Text Primary** | `#3D4852` | 主标题、正文 |
| **Text Secondary** | `#6B7280` | 辅助文字、提示 |
| **Text Muted** | `#A0AEC0` | 占位符、次要信息 |

### 状态颜色

| 颜色名称 | HEX | 用途 |
| :--- | :--- | :--- |
| **Success** | `#38B2AC` | 成功状态、通过按钮 |
| **Error** | `#E53E3E` | 错误状态、删除按钮 |
| **Warning** | `#ED8936` | 警告状态、待审核 |
| **Info** | `#63B3ED` | 信息提示 |

### 阴影颜色

| 类型 | CSS 值 | 用途 |
| :--- | :--- | :--- |
| **Outer Dark** | `rgb(163,177,198,0.6)` | 外阴影深色部分 |
| **Outer Light** | `rgba(255,255,255,0.5)` | 外阴影浅色部分 |
| **Inner Dark** | `rgb(163,177,198,0.6)` | 内阴影深色部分 |
| **Inner Light** | `rgba(255,255,255,0.5)` | 内阴影浅色部分 |

---

## 🔮 Neumorphism 设计

### 核心原理

Neumorphism（新拟态）通过柔和的阴影创造出凸起或凹陷的视觉效果：

```css
/* 凸起效果（外阴影）*/
.neumorphic-raised {
    background: #E0E5EC;
    box-shadow: 
        9px 9px 16px rgb(163,177,198,0.6),   /* 右下深色阴影 */
        -9px -9px 16px rgba(255,255,255,0.5); /* 左上浅色阴影 */
}

/* 凹陷效果（内阴影）*/
.neumorphic-inset {
    background: #E0E5EC;
    box-shadow: 
        inset 6px 6px 10px rgb(163,177,198,0.6),   /* 内深色阴影 */
        inset -6px -6px 10px rgba(255,255,255,0.5); /* 内浅色阴影 */
}
```

### 交互状态

```css
/* 悬停状态 - 更强的凸起效果 */
.neumorphic-raised:hover {
    box-shadow: 
        12px 12px 20px rgb(163,177,198,0.7),
        -12px -12px 20px rgba(255,255,255,0.6);
    transform: translateY(-2px);
}

/* 按下状态 - 凹陷效果 */
.neumorphic-raised:active {
    box-shadow: 
        inset 6px 6px 10px rgba(0,0,0,0.15),
        inset -6px -6px 10px rgba(255,255,255,0.1);
    transform: translateY(1px);
}
```

---

## 🔘 按钮样式

### 主按钮 (Primary)

```css
.btn-primary {
    background: linear-gradient(135deg, #6C63FF 0%, #8B84FF 100%);
    border: none;
    color: white;
    padding: 14px 24px;
    border-radius: 16px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 
        9px 9px 16px rgb(163,177,198,0.6),
        -9px -9px 16px rgba(255,255,255,0.5);
}

.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 
        12px 12px 20px rgb(163,177,198,0.7),
        -12px -12px 20px rgba(255,255,255,0.6);
}

.btn-primary:active {
    transform: translateY(1px);
    box-shadow: 
        inset 6px 6px 10px rgba(0,0,0,0.15),
        inset -6px -6px 10px rgba(255,255,255,0.1);
}
```

### 次要按钮 (Secondary)

```css
.btn-secondary {
    background: #E0E5EC;
    border: none;
    color: #6B7280;
    padding: 14px 24px;
    border-radius: 16px;
    font-size: 16px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 
        5px 5px 10px rgb(163,177,198,0.6),
        -5px -5px 10px rgba(255,255,255,0.5);
}

.btn-secondary:hover {
    color: #3D4852;
    transform: translateY(-1px);
}
```

### 危险按钮 (Danger)

```css
.btn-danger {
    background: #E53E3E;
    border: none;
    color: white;
    padding: 14px 24px;
    border-radius: 16px;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    box-shadow: 
        9px 9px 16px rgb(163,177,198,0.6),
        -9px -9px 16px rgba(255,255,255,0.5);
}
```

---

## 📝 输入框样式

### 基础输入框

```css
input.form-control, textarea.form-control {
    width: 100%;
    padding: 14px 16px;
    border: none;
    border-radius: 16px;
    font-size: 15px;
    background: #E0E5EC;
    color: #3D4852;
    box-shadow: 
        inset 6px 6px 10px rgb(163,177,198,0.6),
        inset -6px -6px 10px rgba(255,255,255,0.5);
    transition: all 0.3s ease;
}

input.form-control:focus, textarea.form-control:focus {
    outline: none;
    box-shadow: 
        inset 10px 10px 20px rgb(163,177,198,0.7),
        inset -10px -10px 20px rgba(255,255,255,0.6);
}

input.form-control::placeholder {
    color: #A0AEC0;
}
```

### 下拉选择框

```css
select.filter-select {
    border: none;
    border-radius: 16px;
    padding: 10px 15px;
    background: #E0E5EC;
    color: #3D4852;
    font-size: 14px;
    cursor: pointer;
    box-shadow: 
        inset 4px 4px 8px rgb(163,177,198,0.6),
        inset -4px -4px 8px rgba(255,255,255,0.5);
    transition: all 0.3s ease;
}

select.filter-select:focus {
    outline: none;
    box-shadow: 
        inset 8px 8px 14px rgb(163,177,198,0.7),
        inset -8px -8px 14px rgba(255,255,255,0.6);
}
```

---

## 🃏 卡片样式

### 基础卡片

```css
.property-card {
    background: #E0E5EC;
    border-radius: 32px;
    overflow: hidden;
    transition: all 0.3s ease;
    cursor: pointer;
    box-shadow: 
        9px 9px 16px rgb(163,177,198,0.6),
        -9px -9px 16px rgba(255,255,255,0.5);
}

.property-card:hover {
    transform: translateY(-3px);
    box-shadow: 
        12px 12px 20px rgb(163,177,198,0.7),
        -12px -12px 20px rgba(255,255,255,0.6);
}
```

### 卡片内容布局

```html
<div class="property-card">
    <div class="property-card-image">
        <img :src="property.imageUrl" alt="房源图片">
    </div>
    <div class="property-card-body">
        <h5 class="property-title">{{ property.title }}</h5>
        <p class="property-info">{{ property.type }} | {{ property.area }}㎡</p>
        <p class="property-price">{{ property.price }}💎</p>
    </div>
</div>
```

---

## 🪟 模态框设计

### 模态框结构

```css
/* 遮罩层 */
.custom-modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    justify-content: center;
    align-items: center;
    z-index: 1000;
    animation: fadeIn 0.2s ease;
}

.custom-modal.show {
    display: flex;
}

/* 内容区域 */
.modal-content {
    background: #E0E5EC;
    border-radius: 32px;
    padding: 30px;
    max-width: 600px;
    width: 90%;
    max-height: 80vh;
    overflow-y: auto;
    position: relative;
    box-shadow: 
        12px 12px 24px rgb(163,177,198,0.7),
        -12px -12px 24px rgba(255,255,255,0.7);
    animation: slideUp 0.3s ease;
    color: #3D4852;
    /* 隐藏滚动条 - 保持视觉一致性 */
    scrollbar-width: none;      /* Firefox */
    -ms-overflow-style: none;   /* IE/Edge */
}

/* 隐藏 Chrome/Safari 滚动条 */
.modal-content::-webkit-scrollbar {
    display: none;
}

/* 关闭按钮 */
.close-btn {
    position: absolute;
    top: 15px;
    right: 15px;
    font-size: 28px;
    cursor: pointer;
    color: #6B7280;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    transition: all 0.2s;
    background: #E0E5EC;
    border: none;
    box-shadow: 
        3px 3px 6px rgb(163,177,198,0.6),
        -3px -3px 6px rgba(255,255,255,0.5);
}

.close-btn:hover {
    color: #3D4852;
    box-shadow: 
        inset 3px 3px 6px rgb(163,177,198,0.6),
        inset -3px -3px 6px rgba(255,255,255,0.5);
}

/* 动画 */
@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

@keyframes slideUp {
    from { 
        opacity: 0; 
        transform: translateY(20px); 
    }
    to { 
        opacity: 1; 
        transform: translateY(0); 
    }
}
```

### Vue 使用示例

```html
<!-- 模态框 -->
<div class="custom-modal" :class="{show: showModal}">
    <div class="modal-content">
        <button class="close-btn" @click="showModal = false">×</button>
        <h4>模态框标题</h4>
        <!-- 内容 -->
    </div>
</div>
```

```javascript
const showModal = ref(false);

// 打开模态框
const openModal = () => {
    showModal.value = true;
};

// 关闭模态框
const closeModal = () => {
    showModal.value = false;
};
```

---

## 🍞 Toast 通知设计

### Toast 样式

```css
.neumorphic-toast {
    position: fixed;
    bottom: 50px;
    left: 50%;
    transform: translateX(-50%) translateY(100px);
    padding: 15px 25px;
    background: #3D4852;
    color: white;
    border-radius: 16px;
    z-index: 2000;
    opacity: 0;
    transition: all 0.3s ease;
    font-size: 14px;
    box-shadow: 
        9px 9px 16px rgb(163,177,198,0.6),
        -9px -9px 16px rgba(255,255,255,0.5);
}

.neumorphic-toast.show {
    opacity: 1;
    transform: translateX(-50%) translateY(0);
}
```

### Vue 使用示例

```html
<!-- Toast 通知 -->
<div class="neumorphic-toast" :class="{show: showToast}">{{ toastMessage }}</div>
```

```javascript
const showToast = ref(false);
const toastMessage = ref('');

const showToastMsg = (msg) => {
    toastMessage.value = msg;
    showToast.value = true;
    setTimeout(() => {
        showToast.value = false;
    }, 3000);
};

// 使用示例
showToastMsg('操作成功！');
```

---

## 🧭 导航栏设计

### 导航栏样式

```css
.navbar {
    background: #E0E5EC;
    box-shadow: 0 4px 16px rgb(163,177,198,0.4);
    padding: 15px 0;
}

.navbar-brand {
    font-size: 20px;
    font-weight: 700;
    color: #3D4852 !important;
}
```

### 头像组件

```css
.avatar-circle {
    width: 45px;
    height: 45px;
    border-radius: 50%;
    overflow: hidden;
    background: linear-gradient(135deg, #6C63FF 0%, #8B84FF 100%);
    cursor: pointer;
    border: 3px solid #E0E5EC;
    box-shadow: 
        5px 5px 10px rgb(163,177,198,0.6),
        -5px -5px 10px rgba(255,255,255,0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-weight: 600;
    font-size: 18px;
    transition: transform 0.2s, box-shadow 0.3s;
}

.avatar-circle:hover {
    transform: scale(1.05);
    box-shadow: 
        9px 9px 16px rgb(163,177,198,0.6),
        -9px -9px 16px rgba(255,255,255,0.5);
}

.avatar-circle img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}
```

---

## 📊 表格样式

```css
.table {
    background: #E0E5EC;
    border-radius: 16px;
    overflow: hidden;
}

.table th {
    font-weight: 600;
    color: #6B7280;
    border-bottom: none;
    padding: 14px;
}

.table td {
    color: #3D4852;
    border-bottom: none;
    padding: 14px;
}

.table tbody tr:hover {
    background: rgba(108, 99, 255, 0.05);
}
```

---

## 📑 侧边栏设计

```css
.sidebar {
    min-height: 100vh;
    background: #E0E5EC;
    padding: 25px;
    position: fixed;
    width: 220px;
    left: 0;
    top: 0;
    box-shadow: 
        6px 0 16px rgb(163,177,198,0.4),
        -3px 0 10px rgba(255,255,255,0.3);
}

.sidebar-link {
    color: #6B7280;
    text-decoration: none;
    display: block;
    padding: 12px 15px;
    margin-bottom: 8px;
    border-radius: 16px;
    transition: all 0.3s;
    font-size: 15px;
    font-weight: 500;
    cursor: pointer;
    box-shadow: 
        3px 3px 6px rgb(163,177,198,0.3),
        -3px -3px 6px rgba(255,255,255,0.3);
}

.sidebar-link:hover {
    color: #3D4852;
    box-shadow: 
        5px 5px 10px rgb(163,177,198,0.4),
        -5px -5px 10px rgba(255,255,255,0.4);
    transform: translateY(-1px);
}

.sidebar-link.active {
    color: white;
    background: #6C63FF;
    box-shadow: 
        inset 4px 4px 8px rgba(0,0,0,0.2),
        inset -4px -4px 8px rgba(255,255,255,0.1);
}
```

---

## ✨ 动画效果

### 缓动函数

```css
/* easeInOutCubic - 平滑的加速/减速 */
@keyframes easeInOutCubic {
    0% { transform: scale(0.8); opacity: 0; }
    50% { transform: scale(1.05); }
    100% { transform: scale(1); opacity: 1; }
}

/* 脉冲效果 */
@keyframes catchPulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.3); opacity: 0.8; }
    100% { transform: scale(1); opacity: 1; }
}

/* 浮动效果 */
@keyframes floatSlow {
    0%, 100% { transform: translateY(0) rotate(0deg); }
    50% { transform: translateY(-15px) rotate(3deg); }
}
```

---

## 🧩 Vue 组件开发规范

### 代码结构

```javascript
const { createApp, ref, reactive, onMounted, onUnmounted, computed } = Vue;

createApp({
    setup() {
        // 1. 响应式状态定义
        const showModal = ref(false);
        const formData = reactive({ username: '', email: '' });
        
        // 2. 计算属性
        const isFormValid = computed(() => {
            return formData.username && formData.email;
        });
        
        // 3. 方法定义
        const openModal = () => {
            showModal.value = true;
        };
        
        const closeModal = () => {
            showModal.value = false;
        };
        
        // 4. 生命周期钩子
        onMounted(() => {
            console.log('组件挂载');
        });
        
        onUnmounted(() => {
            console.log('组件卸载');
        });
        
        // 5. 暴露给模板
        return {
            showModal,
            formData,
            isFormValid,
            openModal,
            closeModal
        };
    }
}).mount('#app');
```

### 事件修饰符使用

| 修饰符 | 用途 |
| :--- | :--- |
| `.stop` | 阻止事件冒泡 |
| `.prevent` | 阻止默认行为 |
| `.self` | 只有点击元素本身才触发 |
| `.enter` | 回车键触发 |

---

## 📁 项目文件结构

```
src/main/webapp/
├── js/
│   ├── vue.global.js      # Vue 3 核心库
│   ├── axios.min.js       # HTTP 客户端
│   └── api.js             # API 封装
├── images/                # 用户头像
├── img/                   # 房源图片
├── user/                  # 用户页面
│   ├── home.jsp           # 首页
│   ├── profile.jsp        # 个人中心
│   └── favorites.jsp      # 收藏列表
├── admin/                 # 管理员页面
│   └── dashboard.jsp      # 管理面板
├── index.jsp              # 登录/注册页
└── captcha.jsp            # 验证码页面
```

---

## 📝 总结

本指南定义了 MC Realtor 项目的前端 UI 设计规范：

1. **Neumorphism 设计**：统一使用凸起/凹陷的阴影效果
2. **紫色主题**：主色调为 `#6C63FF`，背景为 `#E0E5EC`
3. **圆角设计**：按钮 16px，卡片 32px
4. **微动效**：悬停、按下状态有明显反馈
5. **响应式**：适配不同屏幕尺寸

后续开发时，请严格遵循此规范，确保视觉一致性。

---

**文档版本**: v1.0  
**最后更新**: 2026-06-06