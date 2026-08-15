package com.exam.dao;

import com.exam.pojo.User;
import com.exam.util.JsonUtil;
import java.util.List;

public class UserDao {
    public List<User> getAllUsers() {
        return JsonUtil.readList("users.json", User.class);
    }

    public void addUser(User user) {
        List<User> users = getAllUsers();
        users.add(user);
        JsonUtil.writeList("users.json", users);
    }

    // 使用了 反射 和 Stream API（AI)
    public User findUserByUsername(String username) {
        return getAllUsers().stream()           // 1. 获取用户列表并转为Stream
                .filter(u -> u.getUsername().equals(username))  // 2. 使用λ表达式，过滤出符合条件的用户
                .findFirst()                    // 3. 获取第一个匹配的用户
                .orElse(null);                  // 4. 如果没有匹配则返回null
    }

//    //这是原来的代码
//    public User findUserByUsername(String username) {
//        List<User> users = getAllUsers();
//        for (User user : users) {
//            if (user.getUsername().equals(username)) {
//                return user;  // 找到后立即返回
//            }
//        }
//        return null;  // 循环结束没找到
//    }

    /**
     * 更新用户信息。
     * 说明：原方法通过 user.getUsername() 查找，在用户改名时无法定位旧记录。
     * 由调用方明确指定要修改的目标用户（originalUsername），确保能准确定位。
     *
     */
    public void updateUser(String originalUsername, User newUserInfo) {
        List<User> users = getAllUsers();
        for (int i = 0; i < users.size(); i++) {
            // 通过原始用户名定位要修改的用户记录
            if (users.get(i).getUsername().equals(originalUsername)) {
                // 用新的用户信息（可能包含新用户名）替换原记录
                users.set(i, newUserInfo);
                break;
            }
        }
        JsonUtil.writeList("users.json", users);
    }

    public void deleteUser(String username) {
        List<User> users = getAllUsers();
        users.removeIf(u -> u.getUsername().equals(username));
        JsonUtil.writeList("users.json", users);
    }
}