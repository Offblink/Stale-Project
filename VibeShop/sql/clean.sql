-- 数据库清空脚本 --

USE vibeshop;

-- 禁用外键检查（因为有外键约束）
SET FOREIGN_KEY_CHECKS = 0;

-- 清空用户相关表（按依赖顺序）
TRUNCATE TABLE order_item;
TRUNCATE TABLE orders;
TRUNCATE TABLE cart;
TRUNCATE TABLE address;
TRUNCATE TABLE user;

-- 重新启用外键检查
SET FOREIGN_KEY_CHECKS = 1;

-- 重置自增ID
ALTER TABLE user AUTO_INCREMENT = 1;
ALTER TABLE address AUTO_INCREMENT = 1;
ALTER TABLE cart AUTO_INCREMENT = 1;
ALTER TABLE orders AUTO_INCREMENT = 1;
ALTER TABLE order_item AUTO_INCREMENT = 1;

SELECT '数据库已清空！用户和订单数据已删除，商品数据已保留。' AS result;
