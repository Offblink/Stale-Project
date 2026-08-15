package com.vibeshop.service;

import com.vibeshop.dao.UserDao;
import com.vibeshop.model.User;
import java.util.HashMap;
import java.util.Map;

public class UserService {
    private UserDao userDao = new UserDao();

    public Map<String, Object> register(String phone) {
        Map<String, Object> result = new HashMap<>();

        if (phone == null || phone.trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "手机号不能为空");
            return result;
        }

        if (!phone.matches("^1[3-9]\\d{9}$")) {
            result.put("success", false);
            result.put("message", "手机号格式不正确");
            return result;
        }

        User existingUser = userDao.findByPhone(phone);
        if (existingUser != null) {
            result.put("success", true);
            result.put("message", "用户已存在，登录成功");
            result.put("user", existingUser);
            return result;
        }

        User user = new User(phone);
        int id = userDao.insert(user);

        if (id > 0) {
            user.setId(id);
            result.put("success", true);
            result.put("message", "注册成功");
            result.put("user", user);
        } else {
            result.put("success", false);
            result.put("message", "注册失败");
        }

        return result;
    }

    public User getUserById(Integer id) {
        return userDao.findById(id);
    }
}
