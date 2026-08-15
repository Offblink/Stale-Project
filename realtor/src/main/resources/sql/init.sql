CREATE DATABASE IF NOT EXISTS e3 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE e3;

DROP TABLE IF EXISTS favorites;
DROP TABLE IF EXISTS properties;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    avatar VARCHAR(255) NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE properties (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    type VARCHAR(20) NOT NULL,
    area DECIMAL(10,2) NOT NULL,
    price DECIMAL(12,2) NOT NULL,
    region VARCHAR(50) NOT NULL,
    address VARCHAR(200) NOT NULL,
    description TEXT NULL,
    image_url VARCHAR(500) NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE favorites (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (property_id) REFERENCES properties(id),
    UNIQUE KEY uk_user_property (user_id, property_id)
);

-- 管理员用户由 InitServlet 在应用启动时自动创建（密码使用 AES 加密）

INSERT INTO properties (title, type, area, price, region, address, description, image_url, status) VALUES
 ('薰衣草小屋', '一室一厅', 85.50, 16, '薰衣草原', '芳草小道88号', '很好看的粉色系小屋，门前种满了薰衣草🌷', '/realtor/img/house_10.webp', 'released'),
 ('竹韵屋', '两室两厅', 200.00, 32, '东方竹林', '翠竹林海深处', '纯木制小屋！朴素，但住起来可舒服了！！', '/realtor/img/house_02.webp', 'released'),
 ('茶坊', '小型别墅', 200.00,64 , '热带雨林', '云雾茶谷18号', '中国风建筑，门前栽满樱花树。\n客人若是渴了，随时进来喝杯茶🍵', '/realtor/img/house_03.webp', 'released'),
 ('现代庄园', '独栋别墅', 500.00, 9999, '海淀区', '中关村大街1号', '泳池、露天餐厅和SPA应有尽有❗️', '/realtor/img/house_04.webp', 'released'),
 ('苍橡别院', '三室两厅', 150.00, 100, '苍白橡树林', '橡树林路36号', '这其实是一户小型的客栈，屋顶风光独好，三间客房', '/realtor/img/house_05.webp', 'released'),
 ('虬枝木屋', '一室一厅', 145.20, 128, '蘑菇大陆', '蘑菇村77号', '这间木屋由一棵干枯的大树改造而来', '/realtor/img/house_06.webp', 'released'),
 ('枫园', '两厅一室', 90, 64, '枫林', '红叶坡23号', '采用枫树红木与苔痕石阶，收敛而不失设计感', '/realtor/img/house_07.webp', 'pending'),
 ('水之庄园', '中型别墅', 300.00, 500, '北冰洋之上', '浮冰群岛A区', '装饰典雅华丽，妙用水元素点缀庄园', '/realtor/img/house_08.webp', 'released'),
 ('千禧年代の卧室', '小小一间', 10.00, 1, '东百下大雨', '东百06巷', '落地窗、小鱼缸，窗外是经济上行期的夜景，是あたし的梦中情家~', '/realtor/img/house_09.jpg', 'released'),
 ('挖三填一', '一室无厅', 1, 0, '随处', '皆可', '累了，毁灭吧', '/realtor/img/house_01.png', 'released');