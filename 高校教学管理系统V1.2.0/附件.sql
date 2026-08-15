-- 重新设置
SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;

-- 1. 删除所有表（从最底层的表开始）
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS sc;
DROP TABLE IF EXISTS Teaching;
DROP TABLE IF EXISTS StudentRewardsPunishments;
DROP TABLE IF EXISTS RewardPunishmentTypes;
DROP TABLE IF EXISTS ValidStatusTransitions;
DROP TABLE IF EXISTS StudentStatusHistory;
DROP TABLE IF EXISTS UserPermission;
DROP TABLE IF EXISTS Students;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Admin;
DROP TABLE IF EXISTS class;
DROP TABLE IF EXISTS Teacher;
DROP TABLE IF EXISTS major;
DROP TABLE IF EXISTS Dept;
DROP TABLE IF EXISTS department;

-- 3. 重新创建部门表
CREATE TABLE department (
    dept_id CHAR(4) NOT NULL PRIMARY KEY COMMENT '部门编号（PK）',
    dept_name VARCHAR(50) NOT NULL COMMENT '部门名称',
    parent_dept_id CHAR(4) DEFAULT NULL COMMENT '上级部门编号（FK，关联自身dept_id）',
    dept_type TINYINT NOT NULL COMMENT '部门类型：1=教学院系，2=行政部门',
    leader_id CHAR(10) DEFAULT NULL COMMENT '部门负责人ID（FK，关联管理员表admin_id）',
    contact_phone VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
    office_location VARCHAR(100) DEFAULT NULL COMMENT '办公地点',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    is_valid TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否有效：0=已撤销，1=正常'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='高校部门信息表';

-- 4. 创建自引用外键
ALTER TABLE department
ADD CONSTRAINT fk_dept_parent
FOREIGN KEY (parent_dept_id) REFERENCES department(dept_id)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- 5. 创建临时部门表
CREATE TABLE Dept (
    dept_id CHAR(4) NOT NULL PRIMARY KEY,
    dept_name NVARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. 创建专业表
CREATE TABLE major (
    major_id CHAR(6) NOT NULL PRIMARY KEY COMMENT '专业编号（PK）',
    major_name VARCHAR(50) NOT NULL COMMENT '专业名称',
    dept_id CHAR(4) NOT NULL COMMENT '所属院系编号（FK，关联部门表dept_id）',
    major_code VARCHAR(20) NOT NULL COMMENT '专业国标代码',
    director_id CHAR(10) DEFAULT NULL COMMENT '专业负责人ID（FK，关联教师表teacher_id）',
    education_length TINYINT NOT NULL COMMENT '学制（年）',
    degree VARCHAR(20) NOT NULL COMMENT '授予学位',
    establish_time DATE DEFAULT NULL COMMENT '获批设立时间',
    is_valid TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否招生：0=停止招生，1=正常招生'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='高校专业信息表';

-- 7. 创建教师表
CREATE TABLE Teacher (
    teacher_id CHAR(10) PRIMARY KEY,
    user_name NVARCHAR(20) NOT NULL COMMENT '姓名',
    gender CHAR(1) NOT NULL COMMENT '性别',
    id_card CHAR(18) NOT NULL UNIQUE COMMENT '身份证号',
    dept_id CHAR(4) NOT NULL COMMENT '所属部门编号(关联部门表)',
    title NVARCHAR(20) COMMENT '职称',
    education NVARCHAR(20) COMMENT '最高学历',
    graduation NVARCHAR(100) COMMENT '毕业院校',
    hire_time DATE NOT NULL COMMENT '入职时间',
    teacher_status TINYINT NOT NULL COMMENT '状态（1=在职, 2=离职, 3=退休, 4=病假）',
    contact_phone VARCHAR(20) NOT NULL COMMENT '联系电话',
    office NVARCHAR(50) COMMENT '办公室地址',
    email VARCHAR(50) COMMENT '邮箱'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. 创建班级表
CREATE TABLE class (
    class_id CHAR(8) NOT NULL PRIMARY KEY COMMENT '班级编号（PK）',
    class_name VARCHAR(30) NOT NULL COMMENT '班级名称',
    major_id CHAR(6) NOT NULL COMMENT '所属专业编号（FK，关联专业表major_id）',
    grade SMALLINT NOT NULL COMMENT '年级（如2021）',
    head_teacher_id CHAR(10) DEFAULT NULL COMMENT '班主任ID（FK，关联教师表teacher_id）',
    admission_time DATE NOT NULL COMMENT '入学时间',
    graduation_time DATE DEFAULT NULL COMMENT '预计毕业时间',
    total_students INT NOT NULL DEFAULT 0 COMMENT '班级总人数',
    is_graduated TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否已毕业：0=未毕业，1=已毕业'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='高校班级信息表';

-- 9. 创建管理员表
CREATE TABLE Admin (
    admin_id CHAR(10) PRIMARY KEY COMMENT '管理员ID，主键，规则："A"+部门编号+序号',
    user_name NVARCHAR(20) NOT NULL COMMENT '姓名',
    dept_id CHAR(4) NOT NULL COMMENT '所属部门编号，外键关联部门表',
    position NVARCHAR(30) COMMENT '职务',
    contact_phone VARCHAR(20) COMMENT '联系电话',
    is_super BIT NOT NULL DEFAULT 0 COMMENT '是否超级管理员，1=可分配权限，默认0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 10. 创建课程表
CREATE TABLE Course (
    course_id CHAR(9) NOT NULL PRIMARY KEY COMMENT '课程ID',
    course_name NVARCHAR(100) NOT NULL COMMENT '课程名称',
    course_code VARCHAR(20) UNIQUE NOT NULL COMMENT '课程代码',
    credit TINYINT NOT NULL COMMENT '学分',
    total_hours SMALLINT NOT NULL COMMENT '总学时',
    theory_hours SMALLINT NOT NULL COMMENT '理论学时',
    practice_hours SMALLINT NOT NULL COMMENT '实践学时',
    course_type TINYINT NOT NULL COMMENT '课程类型：1=必修课，2=选修课，3=通识课',
    dept_id CHAR(4) NOT NULL COMMENT '开课部门'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 11. 创建学生表
CREATE TABLE Students (
    StudentID VARCHAR(12) PRIMARY KEY COMMENT '学号，主键',
    StudentName NVARCHAR(20) NOT NULL COMMENT '姓名',
    Gender CHAR(2) COMMENT '性别',
    BirthDate DATE COMMENT '出生日期',
    DepartmentID VARCHAR(20) NOT NULL COMMENT '所属院系',
    EnrollmentDate DATE NOT NULL COMMENT '入学日期',
    CurrentStatus VARCHAR(20) NOT NULL DEFAULT '在读' COMMENT '学籍状态：在读、休学、退学、毕业、肄业',
    TotalCredits DECIMAL(5,1) DEFAULT 0 COMMENT '已修总学分',
    Email VARCHAR(50) COMMENT '邮箱',
    Phone VARCHAR(20) COMMENT '电话',
    Address NVARCHAR(200) COMMENT '住址',
    CreatedTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 12. 创建奖惩类型表
CREATE TABLE RewardPunishmentTypes (
    TypeID INT PRIMARY KEY AUTO_INCREMENT COMMENT '类型ID',
    TypeName NVARCHAR(20) NOT NULL COMMENT '类型名称（如：奖学金、警告、记过）',
    Category VARCHAR(10) COMMENT '类别',
    Level INT DEFAULT 1 COMMENT '等级（1-5，数值越大影响越重要）',
    Description NVARCHAR(200) COMMENT '类型描述'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 13. 创建学生奖惩表
CREATE TABLE StudentRewardsPunishments (
    RecordID INT PRIMARY KEY AUTO_INCREMENT COMMENT '记录ID',
    StudentID VARCHAR(12) NOT NULL COMMENT '学号，外键',
    TypeID INT NOT NULL COMMENT '奖惩类型ID，外键',
    RecordDate DATE NOT NULL DEFAULT (CURRENT_DATE) COMMENT '奖惩日期',
    Reason NVARCHAR(500) NOT NULL COMMENT '事由/原因',
    Description NVARCHAR(1000) COMMENT '详细描述',
    IssuedBy NVARCHAR(50) COMMENT '颁发/处理单位',
    IsEffective BIT DEFAULT 1 COMMENT '是否有效（1有效，0已撤销）',
    EffectiveDate DATE COMMENT '生效日期',
    ExpiryDate DATE COMMENT '失效日期',
    CreatedBy VARCHAR(20) COMMENT '记录人',
    CreatedTime DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UpdatedTime DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 14. 创建授课表
CREATE TABLE Teaching (
    teaching_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '授课ID',
    course_id CHAR(9) NOT NULL COMMENT '课程编号',
    teacher_id CHAR(10) NOT NULL COMMENT '授课教师ID',
    class_id CHAR(8) COMMENT '授课班级ID',
    teaching_week NVARCHAR(50) NOT NULL COMMENT '授课周次',
    class_time NVARCHAR(100) NOT NULL COMMENT '上课时间',
    class_place NVARCHAR(50) NOT NULL COMMENT '上课地点'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 15. 创建与Java INSERT语句完全匹配的选课表
CREATE TABLE sc (
    -- 原有字段（与旧DDL一致）
    student_id VARCHAR(12) NOT NULL COMMENT '学生ID',
    course_id CHAR(9) NOT NULL COMMENT '课程ID',
    academic_year VARCHAR(9) NOT NULL COMMENT '学年（如：2024-2025）',
    semester TINYINT NOT NULL COMMENT '学期（1：第一学期，2：第二学期）',
    selection_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '选课时间',
    status TINYINT DEFAULT 1 COMMENT '选课状态（1：成功，0：已退选）',
    
    -- 新增字段（来自Java INSERT语句）
    teacher_id VARCHAR(20) COMMENT '教师ID',
    created_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    
    -- 自增主键（最佳实践，不影响Java语句）
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '自增主键',
    
    -- 唯一约束：避免同一学生在同一学年学期重复选同一门课
    UNIQUE KEY uk_student_course_year_semester (student_id, course_id, academic_year, semester),
    
    -- 复合索引设计
    INDEX idx_student_course (student_id, course_id) COMMENT '学生-课程查询索引',
    INDEX idx_student_year_semester (student_id, academic_year, semester) COMMENT '学生学年学期查询索引',
    INDEX idx_course_year_semester (course_id, academic_year, semester) COMMENT '课程学年学期统计索引',
    INDEX idx_teacher_course (teacher_id, course_id) COMMENT '教师授课查询索引',
    
    -- 单字段索引
    INDEX idx_student_id (student_id) COMMENT '按学生查询索引',
    INDEX idx_course_id (course_id) COMMENT '按课程查询索引',
    INDEX idx_teacher_id (teacher_id) COMMENT '按教师查询索引',
    INDEX idx_academic_year (academic_year) COMMENT '按学年查询索引',
    INDEX idx_semester (semester) COMMENT '按学期查询索引',
    INDEX idx_status (status) COMMENT '按状态查询索引',
    INDEX idx_selection_date (selection_date) COMMENT '按选课时间查询索引',
    INDEX idx_created_time (created_time) COMMENT '按创建时间查询索引',
    
    -- 检查约束（MySQL 8.0.16+）
    CONSTRAINT chk_semester CHECK (semester IN (1, 2)),
    CONSTRAINT chk_status CHECK (status IN (0, 1)),
    CONSTRAINT chk_academic_year CHECK (academic_year REGEXP '^[0-9]{4}-[0-9]{4}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='学生选课表（兼容原Java代码）';

-- 16. 创建成绩表
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '成绩记录ID',
    id INT NOT NULL COMMENT '选课记录ID',
    regular_score DECIMAL(5,2) COMMENT '平时成绩',
    midterm_score DECIMAL(5,2) COMMENT '期中成绩',
    final_score DECIMAL(5,2) COMMENT '期末成绩',
    total_score DECIMAL(5,2) NOT NULL COMMENT '总评成绩',
    grade_point DECIMAL(3,2) COMMENT '绩点',
    grade_level VARCHAR(10) COMMENT '等级（A,B,C,D,F或优,良,中,及格,不及格）',
    credit_earned DECIMAL(3,1) DEFAULT 0 COMMENT '获得学分',
    exam_date DATE COMMENT '考试日期',
    exam_type ENUM('正常考试', '补考', '重修', '缓考') DEFAULT '正常考试' COMMENT '考试类型',
    status TINYINT DEFAULT 1 COMMENT '成绩状态（1：有效，0：无效，2：待审核）',
    teacher_id CHAR(10) COMMENT '录入教师ID',
    created_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    remark TEXT COMMENT '备注'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 17. 创建用户权限表
CREATE TABLE UserPermission (
    user_id CHAR(12) PRIMARY KEY COMMENT '对应学生教师管理员的id',
    user_type TINYINT NOT NULL COMMENT '1=学生,2=教师,3=管理员',
    `password` VARCHAR(100) NOT NULL COMMENT '密码,不加密存储',
    last_login_time DATETIME COMMENT '最后登录时间',
    login_count INT NOT NULL DEFAULT 0 COMMENT '登录次数,默认为0',
    permission_ids VARCHAR(100) COMMENT '权限id集合如"1,3,5",关联系统权限字典',
    is_locked BIT NOT NULL DEFAULT 0 COMMENT '是否锁定(1=密码错误次数过多锁定),默认0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. 重新开启外键检查
SET FOREIGN_KEY_CHECKS = 1;

-- 18. 添加约束
-- 添加教师ID格式检查约束
ALTER TABLE Teacher
ADD CONSTRAINT teacher_id_check
CHECK (
    teacher_id LIKE 'T_________' AND
    LENGTH(teacher_id) = 10 AND
    SUBSTRING(teacher_id, 2, 4) BETWEEN '0000' AND '9999' AND
    SUBSTRING(teacher_id, 6, 5) BETWEEN '00000' AND '99999'
);

-- 添加课程表学时检查
ALTER TABLE Course
ADD CONSTRAINT hours_check
CHECK (theory_hours + practice_hours = total_hours);

-- 添加用户类型检查
ALTER TABLE UserPermission
ADD CONSTRAINT user_type_check
CHECK (user_type IN (1,2,3));

-- 添加成绩表分数检查
ALTER TABLE grades
ADD CONSTRAINT score_check
CHECK (
    regular_score IS NULL OR (regular_score >= 0 AND regular_score <= 100) AND
    midterm_score IS NULL OR (midterm_score >= 0 AND midterm_score <= 100) AND
    final_score IS NULL OR (final_score >= 0 AND final_score <= 100) AND
    total_score >= 0 AND total_score <= 100
);

-- 添加学分检查
ALTER TABLE grades
ADD CONSTRAINT credit_check
CHECK (credit_earned >= 0 AND credit_earned <= credit_earned);

-- 19. 先插入基础数据
-- 插入部门
INSERT INTO department (dept_id, dept_name, dept_type, contact_phone, office_location) VALUES
('D001', '计算机学院', 1, '010-62780001', '主楼101'),
('D002', '信息工程学院', 1, '010-62780002', '主楼201'),
('D003', '教务处', 2, '010-62780003', '行政楼101'),
('D004', '学生处', 2, '010-62780004', '行政楼201');

-- 插入Dept表
INSERT INTO Dept (dept_id, dept_name) VALUES
('D001', '计算机学院'),
('D002', '信息工程学院');

-- 插入专业
INSERT INTO major (major_id, major_name, dept_id, major_code, education_length, degree) VALUES
('M00101', '计算机科学与技术', 'D001', '080901', 4, '工学学士'),
('M00102', '软件工程', 'D001', '080902', 4, '工学学士'),
('M00201', '电子信息工程', 'D002', '080701', 4, '工学学士');

-- 插入教师
INSERT INTO Teacher (teacher_id, user_name, gender, id_card, dept_id, title, education, graduation, hire_time, teacher_status, contact_phone, email) VALUES
('T010100001', '张教授', '男', '110101198001010011', 'D001', '教授', '博士', '清华大学', '2010-08-01', 1, '13800138001', 'zhang@example.com'),
('T010100002', '李副教授', '女', '110101198502020022', 'D001', '副教授', '博士', '北京大学', '2012-08-01', 1, '13800138002', 'li@example.com'),
('T010100003', '王讲师', '男', '110101199003030033', 'D001', '讲师', '硕士', '北京师范大学', '2015-08-01', 1, '13800138003', 'wang@example.com'),
('T020100001', '刘教授', '女', '110101198510100044', 'D002', '教授', '博士', '复旦大学', '2011-08-01', 1, '13800138004', 'liu@example.com');

-- 插入管理员
INSERT INTO Admin (admin_id, user_name, dept_id, position, contact_phone, is_super) VALUES
('A03010001', '教务处管理员', 'D003', '教务主任', '13800138111', 1),
('A04010001', '学生处管理员', 'D004', '学生处长', '13800138112', 0);

-- 更新部门负责人
UPDATE department SET leader_id = 'A03010001' WHERE dept_id = 'D003';
UPDATE department SET leader_id = 'A04010001' WHERE dept_id = 'D004';

-- 更新专业负责人
UPDATE major SET director_id = 'T010100001' WHERE major_id = 'M00101';
UPDATE major SET director_id = 'T010100002' WHERE major_id = 'M00102';
UPDATE major SET director_id = 'T020100001' WHERE major_id = 'M00201';

-- 插入班级
INSERT INTO class (class_id, class_name, major_id, grade, head_teacher_id, admission_time, graduation_time) VALUES
('C2301001', '计科202301班', 'M00101', 2023, 'T010100001', '2023-09-01', '2027-07-01'),
('C2301002', '计科202302班', 'M00101', 2023, 'T010100002', '2023-09-01', '2027-07-01'),
('C2302001', '软件202301班', 'M00102', 2023, 'T010100003', '2023-09-01', '2027-07-01'),
('C2303001', '电信202301班', 'M00201', 2023, 'T020100001', '2023-09-01', '2027-07-01');

-- 继续插入数据
INSERT INTO Course (course_id, course_name, course_code, credit, total_hours, theory_hours, practice_hours, course_type, dept_id) VALUES
('CS1010001', '数据结构', 'CS101', 4, 64, 48, 16, 1, 'D001'),
('CS1010002', '数据库系统', 'CS102', 3, 48, 36, 12, 1, 'D001'),
('CS2010001', '软件工程', 'CS201', 3, 48, 36, 12, 1, 'D001'),
('CS2020001', '计算机网络', 'CS202', 4, 64, 48, 16, 1, 'D001'),
('CS3010001', 'Java程序设计', 'CS301', 3, 48, 32, 16, 2, 'D001'),
('EE1010001', '电路原理', 'EE101', 3, 48, 40, 8, 1, 'D002'),
('MA1010001', '高等数学', 'MA101', 5, 80, 72, 8, 1, 'D001'),
('EN1010001', '大学英语', 'EN101', 4, 64, 48, 16, 1, 'D001');

INSERT INTO Students (StudentID, StudentName, Gender, BirthDate, DepartmentID, EnrollmentDate, CurrentStatus, Email, Phone) VALUES
('202301010001', '张三', '男', '2002-05-15', 'D001', '2023-09-01', '在读', 'zhangsan@example.com', '13800138000'),
('202301010002', '李四', '女', '2003-08-20', 'D001', '2023-09-01', '在读', 'lisi@example.com', '13800138001'),
('202301010003', '王五', '男', '2002-12-10', 'D001', '2023-09-01', '在读', 'wangwu@example.com', '13800138002'),
('202301020001', '赵六', '女', '2004-02-28', 'D001', '2023-09-01', '在读', 'zhaoliu@example.com', '13800138003'),
('202302010001', '钱七', '男', '2003-07-15', 'D002', '2023-09-01', '在读', 'qianqi@example.com', '13800138004'),
('202302010002', '孙八', '女', '2004-01-20', 'D002', '2023-09-01', '在读', 'sunba@example.com', '13800138005');

-- 插入10条测试数据，所有学号、课程号、教师号都来自已有数据
INSERT INTO sc (student_id, course_id, academic_year, semester, 
                selection_date, status, teacher_id, created_time) 
VALUES 
-- 202301010001 张三的选课记录
('202301010001', 'CS1010001', '2023-2024', 1, '2023-09-01 08:30:00', 1, 'T010100001', '2023-09-01 08:30:00'),
('202301010001', 'MA1010001', '2023-2024', 1, '2023-09-01 10:15:00', 1, 'T010100002', '2023-09-01 10:15:00'),
('202301010001', 'EN1010001', '2023-2024', 1, '2023-09-01 14:20:00', 1, 'T010100003', '2023-09-01 14:20:00'),

-- 202301010002 李四的选课记录
('202301010002', 'CS1010001', '2023-2024', 1, '2023-09-01 09:45:00', 1, 'T010100001', '2023-09-01 09:45:00'),
('202301010002', 'CS1010002', '2023-2024', 1, '2023-09-01 11:30:00', 1, 'T010100001', '2023-09-01 11:30:00'),
('202301010002', 'MA1010001', '2023-2024', 1, '2023-09-01 15:10:00', 1, 'T010100002', '2023-09-01 15:10:00'),

-- 202301010003 王五的选课记录（包含退选记录）
('202301010003', 'CS1010001', '2023-2024', 1, '2023-09-02 08:45:00', 0, 'T010100001', '2023-09-02 08:45:00'),  -- 已退选
('202301010003', 'CS2010001', '2023-2024', 1, '2023-09-02 10:30:00', 1, 'T010100001', '2023-09-02 10:30:00'),
('202301010003', 'MA1010001', '2023-2024', 1, '2023-09-02 13:15:00', 1, 'T010100002', '2023-09-02 13:15:00'),

-- 2024-2025学年的选课记录
('202301010001', 'CS3010001', '2024-2025', 1, '2024-09-01 09:00:00', 1, 'T010100003', '2024-09-01 09:00:00'),

-- 202302010001 钱七的选课记录（电气工程专业）
('202302010001', 'EE1010001', '2023-2024', 1, '2023-09-01 10:00:00', 1, 'T020100001', '2023-09-01 10:00:00');

INSERT INTO Teaching (course_id, teacher_id, class_id, teaching_week, class_time, class_place) VALUES
('CS1010001', 'T010100001', 'C2301001', '1-16周', '周一 1-2节', '主楼301'),
('CS1010001', 'T010100001', 'C2301002', '1-16周', '周二 1-2节', '主楼301'),
('CS1010002', 'T010100002', 'C2301001', '1-16周', '周三 3-4节', '主楼302'),
('CS2010001', 'T010100003', 'C2302001', '1-16周', '周四 5-6节', '主楼303'),
('EE1010001', 'T020100001', 'C2303001', '1-16周', '周五 7-8节', '主楼304');

INSERT INTO grades (id, regular_score, midterm_score, final_score, total_score, grade_point, grade_level, credit_earned, exam_date, exam_type, teacher_id) VALUES
(1, 85.00, 90.00, 88.00, 88.20, 3.70, 'B', 4.0, '2024-01-15', '正常考试', 'T010100001'),
(2, 90.00, 85.00, 92.00, 89.90, 3.90, 'B', 3.0, '2024-01-20', '正常考试', 'T010100002'),
(3, 78.00, 82.00, 80.00, 80.40, 3.00, 'B', 5.0, '2024-01-18', '正常考试', 'T010100001'),
(4, 88.00, 92.00, 90.00, 90.40, 4.00, 'A', 4.0, '2024-01-15', '正常考试', 'T010100001'),
(5, 76.00, 80.00, 78.00, 78.40, 2.80, 'C', 3.0, '2024-01-22', '正常考试', 'T010100003'),
(6, 82.00, 85.00, 84.00, 84.10, 3.40, 'B', 3.0, '2024-01-20', '正常考试', 'T010100002'),
(7, 90.00, 88.00, 89.00, 89.20, 3.90, 'B', 4.0, '2024-01-25', '正常考试', 'T010100001');

INSERT INTO RewardPunishmentTypes (TypeName, Category, Level, Description) VALUES
('奖学金', '奖励', 1, '各类奖学金'),
('三好学生', '奖励', 2, '三好学生荣誉称号'),
('优秀干部', '奖励', 2, '优秀学生干部'),
('警告', '惩罚', 1, '口头或书面警告'),
('记过', '惩罚', 2, '记过处分'),
('留校察看', '惩罚', 3, '留校察看处分'),
('开除学籍', '惩罚', 5, '开除学籍处分');

INSERT INTO StudentRewardsPunishments (StudentID, TypeID, RecordDate, Reason, Description, IssuedBy, EffectiveDate, CreatedBy) VALUES
('202301010001', 1, '2024-01-20', '学习成绩优异，获得一等奖学金', '在2023-2024学年第一学期获得一等奖学金', '学生处', '2024-01-20', 'A04010001'),
('202301010002', 2, '2024-01-20', '品学兼优，被评为三好学生', '在2023-2024学年被评为三好学生', '学生处', '2024-01-20', 'A04010001'),
('202301010003', 3, '2024-01-20', '工作认真负责，被评为优秀学生干部', '担任班级学习委员，工作认真负责', '学生处', '2024-01-20', 'A04010001');

INSERT INTO UserPermission (user_id, user_type, `password`, permission_ids) VALUES
('202301010001', 1, 'student123', '1,2,3'),
('202301010002', 1, 'student456', '1,2,3'),
('T010100001', 2, 'teacher123', '4,5,6'),
('A03010001', 3, 'admin123', '7,8,9,10');

-- 创建允许的状态转换表
CREATE TABLE IF NOT EXISTS ValidStatusTransitions (
    OldStatus VARCHAR(20) NOT NULL,
    NewStatus VARCHAR(20) NOT NULL,
    Description NVARCHAR(200) COMMENT '转换描述',
    PRIMARY KEY (OldStatus, NewStatus)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 创建学籍状态变更历史表
CREATE TABLE IF NOT EXISTS StudentStatusHistory (
    HistoryID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID VARCHAR(12) NOT NULL,
    OldStatus VARCHAR(20) NOT NULL,
    NewStatus VARCHAR(20) NOT NULL,
    ChangeReason NVARCHAR(500),
    ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Operator VARCHAR(20)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO ValidStatusTransitions (OldStatus, NewStatus, Description) VALUES
('在读', '休学', '正常休学'),
('在读', '退学', '申请退学'),
('在读', '毕业', '正常毕业'),
('休学', '在读', '复学'),
('休学', '退学', '休学期间退学'),
('退学', '在读', '重新入学'),
('毕业', '肄业', '特殊情况');

-- 验证数据
SELECT 
    d.table_name, d.table_comment, d.table_rows
FROM information_schema.tables d
WHERE d.table_schema = DATABASE() 
AND d.table_type = 'BASE TABLE'
ORDER BY d.table_name;

-- 1. 修改 Course 表，添加容量限制
ALTER TABLE Course ADD COLUMN capacity INT DEFAULT 50 COMMENT '课程容量';
ALTER TABLE Course ADD COLUMN min_capacity INT DEFAULT 15 COMMENT '最小开课人数';
ALTER TABLE Course ADD COLUMN current_selected INT DEFAULT 0 COMMENT '当前选课人数';
ALTER TABLE Course ADD COLUMN semester TINYINT DEFAULT 1 COMMENT '开课学期: 1=春季, 2=秋季';
ALTER TABLE Course ADD COLUMN academic_year VARCHAR(9) COMMENT '开课学年, 如: 2024-2025';

-- 1. 为Students表创建索引
-- 姓名索引（常用于学生信息查询）
CREATE INDEX idx_students_name ON Students(StudentName);
-- 院系索引（常用于按院系查询）
CREATE INDEX idx_students_department ON Students(DepartmentID);
-- 状态索引（常用于状态筛选）
CREATE INDEX idx_students_status ON Students(CurrentStatus);
-- 入学时间索引（常用于时间范围查询）
CREATE INDEX idx_students_enrollment ON Students(EnrollmentDate);
-- 组合索引：院系+状态（常用查询组合）
CREATE INDEX idx_students_dept_status ON Students(DepartmentID, CurrentStatus);

-- 3. 为grades表（成绩表）创建索引
-- 选课记录索引（核心查询）
CREATE INDEX idx_grades_selection ON grades(id);
-- 成绩索引
CREATE INDEX idx_grades_total_score ON grades(total_score);
-- 考试类型索引
CREATE INDEX idx_grades_exam_type ON grades(exam_type);
-- 教师索引
CREATE INDEX idx_grades_teacher ON grades(teacher_id);
-- 时间索引
CREATE INDEX idx_grades_exam_date ON grades(exam_date);
CREATE INDEX idx_grades_created_time ON grades(created_time);
-- 组合索引：成绩+状态
CREATE INDEX idx_grades_score_status ON grades(total_score, status);

-- 4. 为Teacher表创建索引
-- 部门索引
CREATE INDEX idx_teacher_dept ON Teacher(dept_id);
-- 职称索引
CREATE INDEX idx_teacher_title ON Teacher(title);
-- 状态索引
CREATE INDEX idx_teacher_status ON Teacher(teacher_status);
-- 入职时间索引
CREATE INDEX idx_teacher_hire_time ON Teacher(hire_time);
-- 组合索引：部门+职称
CREATE INDEX idx_teacher_dept_title ON Teacher(dept_id, title);

-- 5. 为Course表创建索引
-- 课程代码索引（唯一约束已有，但可加普通索引）
CREATE INDEX idx_course_code ON Course(course_code);
-- 课程类型索引
CREATE INDEX idx_course_type ON Course(course_type);
-- 部门索引
CREATE INDEX idx_course_dept ON Course(dept_id);
-- 学分索引
CREATE INDEX idx_course_credit ON Course(credit);
-- 组合索引：学年+学期
CREATE INDEX idx_course_year_semester ON Course(academic_year, semester);
-- 组合索引：部门+类型
CREATE INDEX idx_course_dept_type ON Course(dept_id, course_type);

-- 6. 为class表创建索引
-- 专业索引
CREATE INDEX idx_class_major ON class(major_id);
-- 年级索引
CREATE INDEX idx_class_grade ON class(grade);
-- 班主任索引
CREATE INDEX idx_class_head_teacher ON class(head_teacher_id);
-- 毕业状态索引
CREATE INDEX idx_class_graduated ON class(is_graduated);
-- 组合索引：专业+年级
CREATE INDEX idx_class_major_grade ON class(major_id, grade);
-- 组合索引：年级+毕业状态
CREATE INDEX idx_class_grade_graduated ON class(grade, is_graduated);

-- 7. 为department表创建索引
-- 部门类型索引
CREATE INDEX idx_department_type ON department(dept_type);
-- 负责人索引
CREATE INDEX idx_department_leader ON department(leader_id);
-- 父部门索引
CREATE INDEX idx_department_parent ON department(parent_dept_id);
-- 有效性索引
CREATE INDEX idx_department_valid ON department(is_valid);
-- 组合索引：类型+有效性
CREATE INDEX idx_department_type_valid ON department(dept_type, is_valid);

-- 8. 为major表创建索引
-- 院系索引
CREATE INDEX idx_major_dept ON major(dept_id);
-- 负责人索引
CREATE INDEX idx_major_director ON major(director_id);
-- 有效性索引
CREATE INDEX idx_major_valid ON major(is_valid);
-- 学制索引
CREATE INDEX idx_major_length ON major(education_length);
-- 组合索引：院系+有效性
CREATE INDEX idx_major_dept_valid ON major(dept_id, is_valid);

-- 9. 为Admin表创建索引
-- 部门索引
CREATE INDEX idx_admin_dept ON Admin(dept_id);
-- 超级管理员索引
CREATE INDEX idx_admin_super ON Admin(is_super);
-- 组合索引：部门+超级管理员
CREATE INDEX idx_admin_dept_super ON Admin(dept_id, is_super);

-- 10. 为Teaching表（授课表）创建索引
-- 课程+教师组合索引
CREATE INDEX idx_teaching_course_teacher ON Teaching(course_id, teacher_id);
-- 班级索引
CREATE INDEX idx_teaching_class ON Teaching(class_id);
-- 教师索引
CREATE INDEX idx_teaching_teacher ON Teaching(teacher_id);
-- 组合索引：教师+班级
CREATE INDEX idx_teaching_teacher_class ON Teaching(teacher_id, class_id);
-- 组合索引：课程+班级
CREATE INDEX idx_teaching_course_class ON Teaching(course_id, class_id);

-- 11. 为StudentRewardsPunishments表创建索引
-- 学生索引
CREATE INDEX idx_reward_student ON StudentRewardsPunishments(StudentID);
-- 类型索引
CREATE INDEX idx_reward_type ON StudentRewardsPunishments(TypeID);
-- 日期索引
CREATE INDEX idx_reward_date ON StudentRewardsPunishments(RecordDate);
-- 有效性索引
CREATE INDEX idx_reward_effective ON StudentRewardsPunishments(IsEffective);
-- 组合索引：学生+类型
CREATE INDEX idx_reward_student_type ON StudentRewardsPunishments(StudentID, TypeID);
-- 组合索引：学生+日期
CREATE INDEX idx_reward_student_date ON StudentRewardsPunishments(StudentID, RecordDate);
-- 组合索引：类型+有效性
CREATE INDEX idx_reward_type_effective ON StudentRewardsPunishments(TypeID, IsEffective);

-- 12. 为UserPermission表创建索引
-- 用户类型索引
CREATE INDEX idx_user_type ON UserPermission(user_type);
-- 最后登录时间索引
CREATE INDEX idx_user_last_login ON UserPermission(last_login_time);
-- 锁定状态索引
CREATE INDEX idx_user_locked ON UserPermission(is_locked);
-- 组合索引：用户类型+锁定状态
CREATE INDEX idx_user_type_locked ON UserPermission(user_type, is_locked);

-- 13. 为StudentStatusHistory表创建索引
-- 学生索引
CREATE INDEX idx_status_student ON StudentStatusHistory(StudentID);
-- 变更日期索引
CREATE INDEX idx_status_date ON StudentStatusHistory(ChangeDate);
-- 操作人索引
CREATE INDEX idx_status_operator ON StudentStatusHistory(Operator);
-- 组合索引：学生+变更日期
CREATE INDEX idx_status_student_date ON StudentStatusHistory(StudentID, ChangeDate);
-- 组合索引：新旧状态
CREATE INDEX idx_status_old_new ON StudentStatusHistory(OldStatus, NewStatus);

-- 14. 为ValidStatusTransitions表创建索引
-- 旧状态索引
CREATE INDEX idx_transition_old ON ValidStatusTransitions(OldStatus);
-- 新状态索引
CREATE INDEX idx_transition_new ON ValidStatusTransitions(NewStatus);

-- 15. 为RewardPunishmentTypes表创建索引
-- 类别索引
CREATE INDEX idx_type_category ON RewardPunishmentTypes(Category);
-- 等级索引
CREATE INDEX idx_type_level ON RewardPunishmentTypes(Level);
-- 组合索引：类别+等级
CREATE INDEX idx_type_category_level ON RewardPunishmentTypes(Category, Level);

-- 16. 为Dept表创建索引
-- 部门名称索引
CREATE INDEX idx_dept_name ON Dept(dept_name);

-- 17. 创建组合索引优化联合查询
-- Students表的常用组合查询
CREATE INDEX idx_students_dept_enroll ON Students(DepartmentID, EnrollmentDate, CurrentStatus);

-- grades表的成绩统计优化
CREATE INDEX idx_grades_teacher_date ON grades(teacher_id, exam_date, status);
CREATE INDEX idx_grades_selection_status ON grades(id, status, exam_type);

-- 18. 添加外键约束（如果之前没有完全添加）
-- Students表的外键约束
ALTER TABLE Students 
ADD CONSTRAINT fk_students_department
FOREIGN KEY (DepartmentID) REFERENCES department(dept_id)
ON UPDATE CASCADE ON DELETE RESTRICT;

-- 检查所有索引创建情况
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    INDEX_TYPE,
    COLUMN_NAME,
    CARDINALITY
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
ORDER BY TABLE_NAME, INDEX_NAME;