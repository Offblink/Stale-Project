-- 学生信息管理系统数据备份文件
-- 备份时间: 2025-12-18T19:08:11.107540500
-- 备份模式: 仅数据备份
SET FOREIGN_KEY_CHECKS = 0;
SET NAMES utf8mb4;

-- 表: admin
DELETE FROM `admin`;
INSERT INTO `admin` (`admin_id`, `user_name`, `dept_id`, `position`, `contact_phone`, `is_super`) VALUES
('A03010001', '教务处管理员', 'D003', '教务主任', '13800138111', 1),
('A04010001', '学生处管理员', 'D004', '学生处长', '13800138112', 0);

-- 表: class
DELETE FROM `class`;
INSERT INTO `class` (`class_id`, `class_name`, `major_id`, `grade`, `head_teacher_id`, `admission_time`, `graduation_time`, `total_students`, `is_graduated`) VALUES
('C2301001', '计科202301班', 'M00101', 2023, 'T010100001', '2023-09-01', '2027-07-01', 0, 0),
('C2301002', '计科202302班', 'M00101', 2023, 'T010100002', '2023-09-01', '2027-07-01', 0, 0),
('C2302001', '软件202301班', 'M00102', 2023, 'T010100003', '2023-09-01', '2027-07-01', 0, 0),
('C2303001', '电信202301班', 'M00201', 2023, 'T020100001', '2023-09-01', '2027-07-01', 0, 0);

-- 表: course
DELETE FROM `course`;
INSERT INTO `course` (`course_id`, `course_name`, `course_code`, `credit`, `total_hours`, `theory_hours`, `practice_hours`, `course_type`, `dept_id`, `capacity`, `min_capacity`, `current_selected`, `semester`, `academic_year`) VALUES
('CS0101010', '哈哈哈', '12345', 3, 100, 50, 50, 1, 'D001', 50, 15, 0, 1, NULL),
('CS1010001', '数据结构设计', 'CS101', 4, 64, 48, 16, 1, 'D001', 50, 15, 0, 1, NULL),
('CS1010002', '数据库系统', 'CS102', 3, 48, 36, 12, 1, 'D001', 50, 15, 0, 1, NULL),
('CS1010101', '大学英语', '142857', 5, 20, 10, 10, 1, 'D001', 50, 15, 0, 1, NULL),
('CS2010001', '软件工程', 'CS201', 3, 48, 36, 12, 1, 'D001', 50, 15, 0, 1, NULL),
('CS2020001', '计算机网络', 'CS202', 4, 64, 48, 16, 1, 'D001', 50, 15, 0, 1, NULL),
('CS3010001', 'Java程序设计', 'CS301', 3, 48, 32, 16, 2, 'D001', 50, 15, 0, 1, NULL),
('EE1010001', '电路原理', 'EE101', 3, 48, 40, 8, 1, 'D002', 50, 15, 0, 1, NULL),
('EN1010001', '大学英语', 'EN101', 4, 64, 48, 16, 1, 'D001', 50, 15, 0, 1, NULL),
('MA1010001', '高等数学', 'MA101', 5, 80, 72, 8, 1, 'D001', 50, 15, 0, 1, NULL);

-- 表: department
DELETE FROM `department`;
INSERT INTO `department` (`dept_id`, `dept_name`, `parent_dept_id`, `dept_type`, `leader_id`, `contact_phone`, `office_location`, `create_time`, `is_valid`) VALUES
('D001', '计算机学院', NULL, 1, NULL, '010-62780001', '主楼101', '2025-12-16T12:09:38', 1),
('D002', '信息工程学院', NULL, 1, NULL, '010-62780002', '主楼201', '2025-12-16T12:09:38', 1),
('D003', '教务处', NULL, 2, 'A03010001', '010-62780003', '行政楼101', '2025-12-16T12:09:38', 1),
('D004', '学生处', NULL, 2, 'A04010001', '010-62780004', '行政楼201', '2025-12-16T12:09:38', 1);

-- 表: dept
DELETE FROM `dept`;
INSERT INTO `dept` (`dept_id`, `dept_name`) VALUES
('D002', '信息工程学院'),
('D001', '计算机学院');

-- 表: grades
DELETE FROM `grades`;
INSERT INTO `grades` (`grade_id`, `id`, `regular_score`, `midterm_score`, `final_score`, `total_score`, `grade_point`, `grade_level`, `credit_earned`, `exam_date`, `exam_type`, `status`, `teacher_id`, `created_time`, `updated_time`, `remark`) VALUES
(1, 1, 85.00, 90.00, 88.00, 88.20, 3.70, 'B', 4.0, '2024-01-15', '正常考试', 1, 'T010100001', '2025-12-16T12:09:38', '2025-12-16T12:09:38', NULL),
(2, 2, 90.00, 85.00, 92.00, 89.90, 3.90, 'B', 3.0, '2024-01-20', '正常考试', 1, 'T010100002', '2025-12-16T12:09:38', '2025-12-16T12:09:38', NULL),
(3, 3, 78.00, 82.00, 80.00, 80.40, 3.00, 'B', 5.0, '2024-01-18', '正常考试', 1, 'T010100001', '2025-12-16T12:09:38', '2025-12-16T12:09:38', NULL),
(4, 4, 88.00, 92.00, 90.00, 90.40, 4.00, 'A', 4.0, '2024-01-15', '正常考试', 1, 'T010100001', '2025-12-16T12:09:38', '2025-12-16T12:09:38', NULL),
(5, 5, 76.00, 80.00, 78.00, 78.40, 2.80, 'C', 3.0, '2024-01-22', '正常考试', 1, 'T010100003', '2025-12-16T12:09:38', '2025-12-16T12:09:38', NULL),
(6, 6, 82.00, 85.00, 84.00, 84.10, 3.40, 'B', 3.0, '2024-01-20', '正常考试', 1, 'T010100002', '2025-12-16T12:09:38', '2025-12-16T12:09:38', NULL),
(7, 7, 90.00, 88.00, 89.00, 89.20, 3.90, 'B', 4.0, '2024-01-25', '正常考试', 1, 'T010100001', '2025-12-16T12:09:38', '2025-12-16T12:09:38', NULL);

-- 表: major
DELETE FROM `major`;
INSERT INTO `major` (`major_id`, `major_name`, `dept_id`, `major_code`, `director_id`, `education_length`, `degree`, `establish_time`, `is_valid`) VALUES
('M00101', '计算机科学与技术', 'D001', '080901', 'T010100001', 4, '工学学士', NULL, 1),
('M00102', '软件工程', 'D001', '080902', 'T010100002', 4, '工学学士', NULL, 1),
('M00201', '电子信息工程', 'D002', '080701', 'T020100001', 4, '工学学士', NULL, 1);

-- 表: rewardpunishmenttypes
DELETE FROM `rewardpunishmenttypes`;
INSERT INTO `rewardpunishmenttypes` (`TypeID`, `TypeName`, `Category`, `Level`, `Description`) VALUES
(1, '奖学金', '奖励', 1, '各类奖学金'),
(2, '三好学生', '奖励', 2, '三好学生荣誉称号'),
(3, '优秀干部', '奖励', 2, '优秀学生干部'),
(4, '警告', '惩罚', 1, '口头或书面警告'),
(5, '记过', '惩罚', 2, '记过处分'),
(6, '留校察看', '惩罚', 3, '留校察看处分'),
(7, '开除学籍', '惩罚', 5, '开除学籍处分');

-- 表: sc
DELETE FROM `sc`;
INSERT INTO `sc` (`student_id`, `course_id`, `academic_year`, `semester`, `selection_date`, `status`, `teacher_id`, `created_time`, `id`) VALUES
('202301010001', 'CS1010001', '2023-2024', 1, '2023-09-01T08:30', 1, 'T010100001', '2023-09-01T08:30', 1),
('202301010001', 'MA1010001', '2023-2024', 1, '2023-09-01T10:15', 1, 'T010100002', '2023-09-01T10:15', 2),
('202301010001', 'EN1010001', '2023-2024', 1, '2023-09-01T14:20', 1, 'T010100003', '2023-09-01T14:20', 3),
('202301010002', 'CS1010001', '2023-2024', 1, '2023-09-01T09:45', 1, 'T010100001', '2023-09-01T09:45', 4),
('202301010002', 'CS1010002', '2023-2024', 1, '2023-09-01T11:30', 1, 'T010100001', '2023-09-01T11:30', 5),
('202301010002', 'MA1010001', '2023-2024', 1, '2023-09-01T15:10', 1, 'T010100002', '2023-09-01T15:10', 6),
('202301010003', 'CS1010001', '2023-2024', 1, '2023-09-02T08:45', 0, 'T010100001', '2023-09-02T08:45', 7),
('202301010003', 'CS2010001', '2023-2024', 1, '2023-09-02T10:30', 1, 'T010100001', '2023-09-02T10:30', 8),
('202301010003', 'MA1010001', '2023-2024', 1, '2023-09-02T13:15', 1, 'T010100002', '2023-09-02T13:15', 9),
('202301010001', 'CS3010001', '2024-2025', 1, '2024-09-01T09:00', 1, 'T010100003', '2024-09-01T09:00', 10),
('202302010001', 'EE1010001', '2023-2024', 1, '2023-09-01T10:00', 1, 'T020100001', '2023-09-01T10:00', 11);

-- 表: studentrewardspunishments
DELETE FROM `studentrewardspunishments`;
INSERT INTO `studentrewardspunishments` (`RecordID`, `StudentID`, `TypeID`, `RecordDate`, `Reason`, `Description`, `IssuedBy`, `IsEffective`, `EffectiveDate`, `ExpiryDate`, `CreatedBy`, `CreatedTime`, `UpdatedTime`) VALUES
(1, '202301010001', 1, '2024-01-20', '学习成绩优异，获得一等奖学金', '在2023-2024学年第一学期获得一等奖学金', '学生处', 1, '2024-01-20', NULL, 'A04010001', '2025-12-16T12:09:38', NULL),
(2, '202301010002', 2, '2024-01-20', '品学兼优，被评为三好学生', '在2023-2024学年被评为三好学生', '学生处', 1, '2024-01-20', NULL, 'A04010001', '2025-12-16T12:09:38', NULL),
(3, '202301010003', 3, '2024-01-20', '工作认真负责，被评为优秀学生干部', '担任班级学习委员，工作认真负责', '学生处', 1, '2024-01-20', NULL, 'A04010001', '2025-12-16T12:09:38', NULL);

-- 表: students
DELETE FROM `students`;
INSERT INTO `students` (`StudentID`, `StudentName`, `Gender`, `BirthDate`, `DepartmentID`, `EnrollmentDate`, `CurrentStatus`, `TotalCredits`, `Email`, `Phone`, `Address`, `CreatedTime`) VALUES
('202301010001', '张三', '男', '2002-05-15', 'D001', '2023-09-01', '在读', 0.0, 'zhangsan@example.com', '13800138000', NULL, '2025-12-16T12:09:38'),
('202301010002', '李四', '女', '2003-08-20', 'D001', '2023-09-01', '在读', 0.0, 'lisi@example.com', '13800138001', NULL, '2025-12-16T12:09:38'),
('202301010003', '王五', '男', '2002-12-10', 'D001', '2023-09-01', '在读', 0.0, 'wangwu@example.com', '13800138002', NULL, '2025-12-16T12:09:38'),
('202301020001', '赵六', '女', '2004-02-28', 'D001', '2023-09-01', '在读', 0.0, 'zhaoliu@example.com', '13800138003', NULL, '2025-12-16T12:09:38'),
('202302010001', '钱七', '男', '2003-07-15', 'D002', '2023-09-01', '在读', 0.0, 'qianqi@example.com', '13800138004', NULL, '2025-12-16T12:09:38'),
('202302010002', '孙八', '女', '2004-01-20', 'D002', '2023-09-01', '在读', 0.0, 'sunba@example.com', '13800138005', NULL, '2025-12-16T12:09:38');

-- 表: studentstatushistory
DELETE FROM `studentstatushistory`;
INSERT INTO `studentstatushistory` (`HistoryID`, `StudentID`, `OldStatus`, `NewStatus`, `ChangeReason`, `ChangeDate`, `Operator`) VALUES
-- 表 studentstatushistory 无数据

-- 表: teacher
DELETE FROM `teacher`;
INSERT INTO `teacher` (`teacher_id`, `user_name`, `gender`, `id_card`, `dept_id`, `title`, `education`, `graduation`, `hire_time`, `teacher_status`, `contact_phone`, `office`, `email`) VALUES
('T010100001', '张教授', '男', '110101198001010011', 'D001', '教授', '博士', '清华大学', '2010-08-01', 1, '13800138001', NULL, 'zhang@example.com'),
('T010100002', '李副教授', '女', '110101198502020022', 'D001', '副教授', '博士', '北京大学', '2012-08-01', 1, '13800138002', NULL, 'li@example.com'),
('T010100003', '王讲师', '男', '110101199003030033', 'D001', '讲师', '硕士', '北京师范大学', '2015-08-01', 1, '13800138003', NULL, 'wang@example.com'),
('T020100001', '刘教授', '女', '110101198510100044', 'D002', '教授', '博士', '复旦大学', '2011-08-01', 1, '13800138004', NULL, 'liu@example.com');

-- 表: teaching
DELETE FROM `teaching`;
INSERT INTO `teaching` (`teaching_id`, `course_id`, `teacher_id`, `class_id`, `teaching_week`, `class_time`, `class_place`) VALUES
(1, 'CS1010001', 'T010100001', 'C2301001', '1-16周', '周一 1-2节', '主楼301'),
(2, 'CS1010001', 'T010100001', 'C2301002', '1-16周', '周二 1-2节', '主楼301'),
(3, 'CS1010002', 'T010100002', 'C2301001', '1-16周', '周三 3-4节', '主楼302'),
(4, 'CS2010001', 'T010100003', 'C2302001', '1-16周', '周四 5-6节', '主楼303'),
(5, 'EE1010001', 'T020100001', 'C2303001', '1-16周', '周五 7-8节', '主楼304');

-- 表: userpermission
DELETE FROM `userpermission`;
INSERT INTO `userpermission` (`user_id`, `user_type`, `password`, `last_login_time`, `login_count`, `permission_ids`, `is_locked`) VALUES
('202301010001', 1, 'student123', NULL, 0, '1,2,3', 0),
('202301010002', 1, 'student456', NULL, 0, '1,2,3', 0),
('A03010001', 3, 'admin123', NULL, 0, '7,8,9,10', 0),
('T010100001', 2, 'teacher123', NULL, 0, '4,5,6', 0);

-- 表: validstatustransitions
DELETE FROM `validstatustransitions`;
INSERT INTO `validstatustransitions` (`OldStatus`, `NewStatus`, `Description`) VALUES
('休学', '在读', '复学'),
('休学', '退学', '休学期间退学'),
('在读', '休学', '正常休学'),
('在读', '毕业', '正常毕业'),
('在读', '退学', '申请退学'),
('毕业', '肄业', '特殊情况'),
('退学', '在读', '重新入学');


-- 备份完成
-- 成功备份表: 16/16
-- 总数据行数: 79
SET FOREIGN_KEY_CHECKS = 1;
