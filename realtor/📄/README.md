# 🏠 MC Realtor - 房产管理系统

一个基于 Java Servlet + Vue.js 的现代化房产管理系统，采用分层架构设计，提供用户注册登录、房产浏览、收藏管理和管理员审核等功能。

## 📋 目录

- [技术栈](#技术栈)
- [项目结构](#项目结构)
- [功能特性](#功能特性)
- [数据库设计](#数据库设计)
- [API 接口](#api-接口)
- [快速开始](#快速开始)
- [部署说明](#部署说明)
- [项目亮点](#项目亮点)

## 🛠 技术栈

| 层次 | 技术 | 版本 |
| :--- | :--- | :--- |
| **后端语言** | Java | 17 |
| **Web框架** | Jakarta Servlet | 5.0 |
| **数据库** | MySQL | 8.0+ |
| **连接池** | HikariCP | 5.0.1 |
| **JSON处理** | Gson | 2.8.9 |
| **前端框架** | Vue.js | 3.x |
| **UI框架** | Bootstrap | 5.3 |
| **构建工具** | Maven | 3.6+ |

## 🏗️ 项目结构

```
realtor/
├── src/main/java/com/example/realtor/
│   ├── controller/     # 控制器层（处理HTTP请求）
│   │   ├── AdminServlet.java
│   │   ├── CaptchaServlet.java
│   │   ├── FavoriteServlet.java
│   │   ├── InitServlet.java
│   │   ├── PropertyServlet.java
│   │   ├── UploadServlet.java
│   │   └── UserServlet.java
│   ├── service/        # 业务逻辑层
│   │   ├── FavoriteService.java
│   │   ├── PropertyService.java
│   │   └── UserService.java
│   ├── dao/            # 数据访问层
│   │   ├── FavoriteDAO.java
│   │   ├── PropertyDAO.java
│   │   └── UserDAO.java
│   ├── model/          # 数据模型
│   │   ├── Favorite.java
│   │   ├── Property.java
│   │   └── User.java
│   ├── config/         # 配置类
│   │   ├── DBConnection.java
│   │   └── EncodingFilter.java
│   └── utils/          # 工具类
│       └── AESUtil.java
├── src/main/resources/
│   ├── db.properties   # 数据库配置
│   └── sql/init.sql    # 初始化脚本
├── src/main/webapp/
│   ├── WEB-INF/web.xml
│   ├── index.jsp       # 登录/注册页面
│   ├── captcha.jsp     # 验证码页面
│   ├── admin/          # 管理员后台
│   ├── user/           # 用户页面
│   ├── images/         # 用户头像
│   ├── img/            # 房产图片
│   └── js/             # JavaScript文件
├── target/             # 编译输出目录
├── pom.xml             # Maven配置
└── README.md           # 项目说明
```

## ✨ 功能特性

### 用户功能
- **注册登录**: 支持用户名/密码注册，密码采用 AES 加密存储
- **用户信息管理**: 修改个人信息、上传头像、修改密码
- **房产浏览**: 查看所有已发布的房产信息
- **房产搜索**: 支持关键词搜索和条件筛选（类型、区域、价格）
- **收藏管理**: 添加/取消收藏房产，查看收藏列表

### 管理员功能
- **用户管理**: 查看所有用户列表，支持搜索
- **房产审核**: 审核待发布的房产（通过/拒绝）
- **房产管理**: 查看所有房产状态

## 🗄️ 数据库设计

### 表结构

**users（用户表）**

| 字段 | 类型 | 说明 |
| :--- | :--- | :--- |
| id | INT | 主键，自增 |
| username | VARCHAR(50) | 用户名，唯一 |
| password | VARCHAR(255) | 密码（AES加密） |
| email | VARCHAR(100) | 邮箱，唯一 |
| avatar | VARCHAR(255) | 头像路径 |
| role | VARCHAR(20) | 角色（user/admin） |
| created_at | TIMESTAMP | 创建时间 |

**properties（房产表）**

| 字段 | 类型 | 说明 |
| :--- | :--- | :--- |
| id | INT | 主键，自增 |
| title | VARCHAR(100) | 房产标题 |
| type | VARCHAR(20) | 户型类型 |
| area | DECIMAL(10,2) | 面积（平米） |
| price | DECIMAL(12,2) | 价格（万元） |
| region | VARCHAR(50) | 区域 |
| address | VARCHAR(200) | 详细地址 |
| description | TEXT | 描述 |
| image_url | VARCHAR(500) | 图片路径 |
| status | VARCHAR(20) | 状态（pending/released） |
| created_at | TIMESTAMP | 创建时间 |

**favorites（收藏表）**

| 字段 | 类型 | 说明 |
| :--- | :--- | :--- |
| id | INT | 主键，自增 |
| user_id | INT | 用户ID（外键） |
| property_id | INT | 房产ID（外键） |

### ER图

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│    users    │       │  properties │       │  favorites  │
├─────────────┤       ├─────────────┤       ├─────────────┤
│ id (PK)     │◄──────│ id (PK)     │◄──────│ id (PK)     │
│ username    │       │ title       │       │ user_id (FK)│
│ password    │       │ type        │       │property_id(FK)│
│ email       │       │ area        │       └─────────────┘
│ avatar      │       │ price       │
│ role        │       │ region      │
│ created_at  │       │ address     │
└─────────────┘       │ description │
                      │ image_url   │
                      │ status      │
                      │ created_at  │
                      └─────────────┘
```

## 🔌 API 接口

### 用户接口

| 方法 | 路径 | 描述 |
| :--- | :--- | :--- |
| POST | `/api/user/login` | 用户登录 |
| POST | `/api/user/register` | 用户注册 |
| GET | `/api/user/info/{id}` | 获取用户信息 |
| POST | `/api/user/update` | 更新用户信息 |
| POST | `/api/user/updatePassword` | 修改密码 |
| POST | `/api/user/updateAvatar` | 上传头像 |

### 房产接口

| 方法 | 路径 | 描述 |
| :--- | :--- | :--- |
| GET | `/api/property` | 获取已发布房产列表 |
| GET | `/api/property/detail/{id}` | 获取房产详情 |
| GET | `/api/property/search?keyword=xxx` | 搜索房产 |
| GET | `/api/property/filter` | 筛选房产 |
| GET | `/api/property/types` | 获取所有户型类型 |
| GET | `/api/property/regions` | 获取所有区域 |
| POST | `/api/property` | 添加房产 |
| PUT | `/api/property/update` | 更新房产 |
| DELETE | `/api/property/{id}` | 删除房产 |

### 收藏接口

| 方法 | 路径 | 描述 |
| :--- | :--- | :--- |
| GET | `/api/favorite/{userId}` | 获取用户收藏列表 |
| POST | `/api/favorite/add` | 添加收藏 |
| POST | `/api/favorite/remove` | 取消收藏 |

### 管理员接口

| 方法 | 路径 | 描述 |
| :--- | :--- | :--- |
| GET | `/api/admin/users` | 获取所有用户 |
| GET | `/api/admin/properties` | 获取所有房产 |
| GET | `/api/admin/pending` | 获取待审核房产 |
| POST | `/api/admin/approve` | 审核通过 |
| POST | `/api/admin/reject` | 拒绝审核 |

## 🚀 快速开始

### 环境要求

- JDK 17+
- MySQL 8.0+
- Maven 3.6+

### 数据库配置

1. 创建数据库并执行初始化脚本：

```sql
CREATE DATABASE IF NOT EXISTS e3 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE e3;
SOURCE src/main/resources/sql/init.sql;
```

2. 修改 `src/main/resources/db.properties`：

```properties
jdbc.driver=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/e3?useSSL=false&serverTimezone=UTC&characterEncoding=utf8&allowPublicKeyRetrieval=true
jdbc.username=your_username
jdbc.password=your_password
hikari.maximum-pool-size=10
hikari.minimum-idle=5
hikari.connection-timeout=30000
```

### 编译运行

```bash
# 进入项目目录
cd realtor

# 编译项目
mvn clean compile

# 打包项目
mvn package

# 运行（需部署到 Servlet 容器如 Tomcat）
```

### IDE 运行（推荐）

1. 使用 IntelliJ IDEA 打开项目
2. 配置 Tomcat 服务器（推荐 Tomcat 10+）
3. 运行 `InitServlet` 初始化管理员账户
4. 访问 http://localhost:8080/realtor

## 📦 部署说明

### Tomcat 部署

1. 将 `target/realtor.war` 复制到 Tomcat 的 `webapps` 目录
2. 启动 Tomcat：`bin/startup.sh`（Linux）或 `bin/startup.bat`（Windows）
3. 访问 http://localhost:8080/realtor

### 管理员账户

系统启动时 `InitServlet` 会自动创建管理员账户：
- 用户名：`admin`
- 密码：`admin123`

## 💡 项目亮点

1. **分层架构**: 采用 Controller-Service-DAO-Model 四层架构，职责清晰
2. **密码加密**: 使用 AES 算法加密存储用户密码，保障数据安全
3. **连接池**: 使用 HikariCP 高性能数据库连接池
4. **响应式前端**: 使用 Vue.js 3 构建现代化 UI，支持响应式布局
5. **Neumorphism 设计**: 登录页面采用新拟态设计风格
6. **验证码验证**: 登录/注册时需先通过验证码验证（验证码在密码校验之前），有效防止自动化攻击
7. **文件上传**: 支持用户头像上传，自动保存到运行时和源码目录

## 📝 许可证

MIT License

---

**项目状态**: 已完成开发，可直接部署使用