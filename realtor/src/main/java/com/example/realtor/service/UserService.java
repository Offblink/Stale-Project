package com.example.realtor.service;

import com.example.realtor.dao.UserDAO;
import com.example.realtor.model.User;
import com.example.realtor.utils.AESUtil;

import java.util.List;

public class UserService {
    private UserDAO userDAO = new UserDAO();

    public User login(String username, String password) throws Exception {
        User user = userDAO.findByUsername(username);
        if (user != null) {
            String decryptedPassword = AESUtil.decrypt(user.getPassword());
            if (decryptedPassword.equals(password)) {
                return user;
            }
        }
        return null;
    }

    public User register(String username, String password, String email) throws Exception {
        if (userDAO.usernameExists(username)) {
            throw new Exception("用户名已存在");
        }
        if (userDAO.emailExists(email)) {
            throw new Exception("邮箱已被注册");
        }
        String encryptedPassword = AESUtil.encrypt(password);
        User user = new User(username, encryptedPassword, email, "user");
        userDAO.add(user);
        return userDAO.findByUsername(username);
    }

    public User findById(int id) throws Exception {
        return userDAO.findById(id);
    }

    public User findByUsername(String username) throws Exception {
        return userDAO.findByUsername(username);
    }

    public void update(User user) throws Exception {
        userDAO.update(user);
    }

    public void updateAvatar(int userId, String avatar) throws Exception {
        userDAO.updateAvatar(userId, avatar);
    }

    public List<User> findAll() throws Exception {
        return userDAO.findAll();
    }

    public List<User> search(String keyword) throws Exception {
        return userDAO.search(keyword);
    }

    public void updatePassword(int userId, String newPassword) throws Exception {
        User user = userDAO.findById(userId);
        if (user != null) {
            String encryptedPassword = AESUtil.encrypt(newPassword);
            user.setPassword(encryptedPassword);
            userDAO.update(user);
        }
    }
}