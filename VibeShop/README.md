# VibeShop - 宠物用品电商平台

## 项目简介

VibeShop 是一个基于 **Java Servlet + JSP** 的宠物用品电商平台，采用前后端分离架构，前端使用 Vue.js 3 构建单页面应用（SPA），后端采用 RESTful API 风格提供数据服务。

## 技术栈

### 后端技术
- **Java** (JDK 8+)
- **Jakarta Servlet 5.0** - Web 应用程序框架
- **JSP** (JavaServer Pages) - 动态网页技术
- **三层架构** - DAO（数据访问层）→ Service（业务逻辑层）→ Servlet（控制层）
- **MySQL 8.0** - 关系型数据库
- **HikariCP** - 高性能数据库连接池
- **Google Gson** - JSON 序列化/反序列化
- **Maven** - 项目构建与依赖管理
- **Tomcat** - Servlet 容器/Web 服务器

### 前端技术
- **Vue.js 3** - 渐进式 JavaScript 框架（CDN 加载）
- **Axios** - Promise-based HTTP 客户端
- **Bootstrap 5** - CSS 框架/响应式布局
- **Font Awesome 6** - 图标库
- **原生 JavaScript** - DOM 操作、事件处理

### 开发工具
- **IntelliJ IDEA** - Java IDE
- **Maven** - 项目构建
- **Git** - 版本控制

## 项目架构

### 三层架构详解

```
┌─────────────────────────────────────────────────────────────┐
│                    表示层 (Presentation Layer)               │
│                        index.jsp                            │
│                   (Vue.js 单页面应用)                        │
└─────────────────────────────┬───────────────────────────────┘
                              │ HTTP/REST API
┌─────────────────────────────▼───────────────────────────────┐
│                   控制层 (Controller Layer)                 │
│                    Servlet (RESTful API)                    │
│   ProductServlet | UserServlet | CartServlet | OrderServlet  │
└─────────────────────────────┬───────────────────────────────┘
                              │ 调用
┌─────────────────────────────▼───────────────────────────────┐
│                   业务逻辑层 (Service Layer)                 │
│   ProductService | UserService | CartService | OrderService  │
└─────────────────────────────┬───────────────────────────────┘
                              │ 调用
┌─────────────────────────────▼───────────────────────────────┐
│                   数据访问层 (DAO Layer)                     │
│     ProductDao | UserDao | CartDao | OrderDao | AddressDao   │
└─────────────────────────────┬───────────────────────────────┘
                              │ JDBC
┌─────────────────────────────▼───────────────────────────────┐
│                       MySQL 数据库                           │
│        products | users | carts | orders | addresses         │
└─────────────────────────────────────────────────────────────┘
```

## 项目结构

```
VibeShop/
├── src/main/java/com/vibeshop/
│   ├── dao/                    # 数据访问层 (Data Access Object)
│   │   ├── UserDao.java
│   │   ├── ProductDao.java
│   │   ├── CartDao.java
│   │   ├── OrderDao.java
│   │   └── AddressDao.java
│   ├── model/                  # 实体类 (Entity/Model)
│   │   ├── User.java
│   │   ├── Product.java
│   │   ├── Cart.java
│   │   ├── Order.java
│   │   ├── OrderItem.java
│   │   └── Address.java
│   ├── service/                # 业务逻辑层 (Business Logic)
│   │   ├── UserService.java
│   │   ├── ProductService.java
│   │   ├── CartService.java
│   │   ├── OrderService.java
│   │   └── AddressService.java
│   ├── servlet/                # 控制层 (RESTful API Controllers)
│   │   ├── UserServlet.java
│   │   ├── ProductServlet.java
│   │   ├── CartServlet.java
│   │   ├── OrderServlet.java
│   │   └── AddressServlet.java
│   ├── filter/                # 过滤器 (Filters)
│   │   └── EncodingFilter.java
│   ├── listener/               # 监听器 (Listeners)
│   │   └── DBPoolListener.java
│   └── util/                   # 工具类 (Utilities)
│       ├── DBUtil.java
│       └── JsonUtil.java
├── src/main/webapp/
│   ├── index.jsp               # 主页面 (Vue.js SPA 入口)
│   ├── js/
│   │   ├── api.js              # API 请求封装
│   │   └── app.js              # Vue 应用逻辑
│   ├── WEB-INF/
│   │   └── web.xml             # Web 应用配置
│   ├── views/                  # JSP 视图
│   ├── images/                 # 静态资源
│   │   └── products/           # 商品图片
│   └── backup/                 # 备份文件
├── src/main/resources/
│   └── db.properties           # 数据库配置
├── sql/
│   └── clean.sql               # 数据库初始化脚本
├── target/                     # Maven 编译输出
├── pom.xml                     # Maven 项目配置
└── README.md                   # 项目说明文档
```

## 功能模块

### 1. 用户模块 (User Module)
- ✅ 手机号注册/登录
- ✅ localStorage 持久化登录状态
- ✅ 用户会话管理
- ✅ 退出登录

### 2. 商品模块 (Product Module)
- ✅ 商品列表分页展示
- ✅ 商品详情查看
- ✅ 商品图片展示（支持错误处理）
- ✅ 商品搜索和筛选

### 3. 地址模块 (Address Module)
- ✅ 收货地址 CRUD 操作
- ✅ 设置默认收货地址
- ✅ 地址表单验证（手机号格式验证）
- ✅ 地址选择器

### 4. 购物车模块 (Cart Module)
- ✅ 添加商品到购物车
- ✅ 修改商品数量
- ✅ 删除购物车商品
- ✅ 实时计算总价
- ✅ 购物车数量徽章显示

### 5. 订单模块 (Order Module)
- ✅ 购物车结算下单
- ✅ 直接购买
- ✅ 订单历史查询
- ✅ 订单状态展示
- ✅ 订单时间格式化

## API 接口文档 (RESTful API)

### 用户接口 (User API)

| 操作 | HTTP 方法 | URL 路径 | 说明 | 请求体/参数 |
|------|----------|---------|------|------------|
| 注册 | POST | `/api/user/register` | 手机号注册 | `{phone: "13800138000"}` |
| 获取用户 | GET | `/api/user/{id}` | 获取用户信息 | - |
| 地址列表 | GET | `/api/user/address/{userId}` | 获取用户地址 | - |
| 添加地址 | POST | `/api/user/address` | 新增收货地址 | 见 Address 数据结构 |
| 更新地址 | PUT | `/api/user/address/{id}` | 修改收货地址 | 见 Address 数据结构 |
| 删除地址 | DELETE | `/api/user/address/{id}` | 删除收货地址 | - |

### 商品接口 (Product API)

| 操作 | HTTP 方法 | URL 路径 | 说明 | 参数 |
|------|----------|---------|------|------|
| 商品列表 | GET | `/api/products` | 分页获取商品 | `page`, `size` |
| 商品详情 | GET | `/api/products/{id}` | 获取单个商品 | - |

### 购物车接口 (Cart API)

| 操作 | HTTP 方法 | URL 路径 | 说明 | 请求体 |
|------|----------|---------|------|--------|
| 获取购物车 | GET | `/api/cart/{userId}` | 获取用户购物车 | - |
| 添加商品 | POST | `/api/cart` | 添加到购物车 | `{userId, productId, quantity}` |
| 更新数量 | PUT | `/api/cart/{cartId}` | 更新商品数量 | `{quantity}` |
| 删除商品 | DELETE | `/api/cart/{cartId}` | 从购物车移除 | - |

### 订单接口 (Order API)

| 操作 | HTTP 方法 | URL 路径 | 说明 | 请求体 |
|------|----------|---------|------|--------|
| 订单列表 | GET | `/api/orders/{userId}` | 获取用户订单 | - |
| 结算下单 | POST | `/api/orders` | 购物车结算 | `{userId, addressId, cartItems}` |
| 直接购买 | POST | `/api/orders/direct` | 直接购买 | `{userId, addressId, productId, quantity}` |

### 响应格式

所有 API 响应均采用统一 JSON 格式：

```json
{
    "code": 200,
    "message": "操作成功",
    "data": { /* 业务数据 */ }
}
```

错误响应：
```json
{
    "code": 400,
    "message": "错误信息",
    "data": null
}
```

## 数据库设计

### 数据表结构

#### users 表
```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    phone VARCHAR(11) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### products 表
```sql
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    description TEXT,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### addresses 表
```sql
CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    receiver_name VARCHAR(50) NOT NULL,
    phone VARCHAR(11) NOT NULL,
    province VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    district VARCHAR(50) NOT NULL,
    detail_address VARCHAR(255) NOT NULL,
    is_default TINYINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

#### carts 表
```sql
CREATE TABLE carts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
```

#### orders 和 order_items 表
```sql
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    address_id INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
```

## 前端架构

### Vue.js 3 Composition API

项目使用 Vue 3 的 Composition API，主要特性：

```javascript
const app = createApp({
    setup() {
        // 响应式数据
        const products = ref([]);          // 声明响应式变量
        const currentUser = ref(null);
        
        // 计算属性
        const cartCount = computed(() => cartItems.value.length);
        const cartTotal = computed(() => {
            return cartItems.value.reduce((sum, item) => {
                return sum + (item.product.price * item.quantity);
            }, 0);
        });
        
        // 生命周期钩子
        onMounted(() => {
            loadProducts();
            loadUserData();
        });
        
        return { /* 导出给模板使用的变量和方法 */ };
    }
});

app.mount('#app');  // 挂载到 DOM 元素
```

### API 封装 (api.js)

统一的 API 请求封装，提供四种 HTTP 方法：

```javascript
const api = {
    get: apiGet,      // GET 请求 - 查询
    post: apiPost,    // POST 请求 - 创建
    put: apiPut,      // PUT 请求 - 更新
    delete: apiDelete // DELETE 请求 - 删除
};

// 使用示例
await api.get('/products', {page: 1, size: 12});
await api.post('/user/register', {phone: '13800138000'});
```

## 环境配置

### 数据库配置

修改 `src/main/resources/db.properties`：

```properties
# 数据库连接配置
url=jdbc:mysql://localhost:3306/vibeshop?useSSL=false&serverTimezone=UTC
username=root
password=your_password

# 连接池配置
maximumPoolSize=10
minimumIdle=5
connectionTimeout=300000
```

### 运行配置

1. 创建数据库：`CREATE DATABASE vibeshop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
2. 执行初始化脚本：`sql/clean.sql`
3. 配置数据库连接信息
4. 使用 IDE 运行或部署到 Tomcat

## 构建与部署

### 开发环境运行

1. 使用 IntelliJ IDEA 打开项目
2. 配置 Tomcat 服务器
3. 运行项目

### 生产环境部署

```bash
# 1. 清理并打包
mvn clean package

# 2. 部署 WAR 文件
# 将 target/VibeShop.war 复制到 Tomcat 的 webapps 目录

# 3. 启动 Tomcat
cd $CATALINA_HOME/bin
./startup.sh  # Linux/Mac
startup.bat   # Windows
```

### 访问应用

启动 Tomcat 后访问：`http://localhost:8080/VibeShop/`

## 核心知识点

本项目涵盖了以下核心技术点：

### 后端知识点
- **Servlet 生命周期** - init(), service(), destroy()
- **HttpServlet 请求分发** - doGet(), doPost(), doPut(), doDelete()
- **RESTful API 设计** - 资源导向的 URL 设计
- **三层架构** - DAO, Service, Servlet 分层
- **JDBC 数据库操作** - 增删改查
- **连接池技术** - HikariCP 高性能连接池
- **JSON 数据交换** - Gson 序列化
- **过滤器与监听器** - 编码过滤、资源监听

### 前端知识点
- **Vue.js 3 Composition API** - ref, computed, onMounted
- **Axios HTTP 客户端** - 异步请求处理
- **async/await 异步编程** - 异步代码同步化
- **localStorage 本地存储** - 浏览器持久化
- **Promise.all 并行请求** - 优化加载性能
- **DOM 事件处理** - 点击、键盘、变化事件
- **CSS 响应式设计** - Bootstrap 栅格系统

### 项目知识点
- **Maven 项目管理** - 依赖管理、构建打包
- **Git 版本控制** - 代码管理
- **前后端分离架构** - REST API 通信
- **SPA 单页面应用** - 无刷新用户体验
- **模态框交互** - 自定义弹窗设计
- **分页组件** - 前端分页逻辑

## 代码规范

- 所有 Java 文件使用 UTF-8 编码
- 遵循 Java 命名规范（驼峰命名）
- JSP 使用 `<%@ page %>` 声明编码
- API 返回统一 JSON 格式
- 前端使用 ES6+ 语法

## 注意事项

1. **数据库编码**：确保使用 utf8mb4 编码支持表情符号
2. **跨域问题**：生产环境需配置 CORS
3. **安全性**：实际生产环境需添加密码加密、会话管理等
4. **性能优化**：大型项目建议添加缓存（Redis）
5. **错误处理**：完善的异常处理和日志记录

## 许可证

本项目仅供学习和教学参考使用。

## 作者

VibeShop 开发团队

## 版本历史

- **v1.0** - 初始版本，包含基础电商功能

## 致谢

感谢 Java Web 开发课程教学团队！
