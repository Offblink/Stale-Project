package com.exam.service;

import com.exam.dao.AnswerDao;
import com.exam.dao.GradeDao;
import com.exam.dao.UserDao;
import com.exam.pojo.User;
import java.util.List;

public class UserService {
    private UserDao userDao = new UserDao();
    // 引入 AnswerDao和GradeDao以操作关联数据
    private AnswerDao answerDao = new AnswerDao();
    private GradeDao gradeDao = new GradeDao();

    // 为了逻辑统一，直接调用userDao中的方法
    public List<User> getAllUsers() {
        return userDao.getAllUsers();
    }

    // 传递username参数，调用userDao中的方法查询
    public boolean checkUsernameExists(String username) {
        // 若查询到用户，则不为空，返回true，反之亦然
        return userDao.findUserByUsername(username) != null;
    }

    public void register(String username, String password, String role) {
        userDao.addUser(new User(username, password, role));
    }

    public User login(String username, String password) {
        User user = userDao.findUserByUsername(username);

        // 如果用户存在，且密码正确，则视为成功
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }

    public void updateUserInfo(String oldUsername, String newUsername, String newPassword) {
        User user = userDao.findUserByUsername(oldUsername);
        if (user != null) {
            // 1. 级联更新关联数据
            if (!oldUsername.equals(newUsername)) {
                answerDao.updateStudentUsername(oldUsername, newUsername);
                gradeDao.updateTeacherUsername(oldUsername, newUsername);
            }

            // 2. 更新用户名
            user.setUsername(newUsername);

            // 只有当 newPassword 非空且不是空白字符串时，才认为用户意图修改密码
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                user.setPassword(newPassword.trim()); // 去除首尾空格后设置新密码
            }
            // 如果 newPassword 为空，则跳过密码设置，保持原密码不变

            // 3. 持久化更新用户信息
            userDao.updateUser(oldUsername, user);
        }
    }

    public void deleteUser(String username) {
        userDao.deleteUser(username);
    }
}