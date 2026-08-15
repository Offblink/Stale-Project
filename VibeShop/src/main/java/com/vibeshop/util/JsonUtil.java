package com.vibeshop.util;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;

// 专门用于处理各类JSON格式的消息
public class JsonUtil {
    private static final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();

    // 成功状态可能包含数据传递，所以要传递data参数
    public static String success(Object data) {
        JsonObject json = new JsonObject(); // Gson对象
        json.addProperty("code", 200);
        json.addProperty("message", "success");
        json.add("data", gson.toJsonTree(data)); // 消息内容
        return gson.toJson(json); // 返回Json -> Servlet -> API -> 前端
    }

    public static String success(String message, Object data) {
        JsonObject json = new JsonObject();
        json.addProperty("code", 200);
        json.addProperty("message", message);
        if (data != null) {
            json.add("data", gson.toJsonTree(data));
        }
        return gson.toJson(json);
    }

    public static String error(String message) {
        JsonObject json = new JsonObject();
        json.addProperty("code", 500);
        json.addProperty("message", message);
        return gson.toJson(json);
    }

    // 而失败则分为多种状态，因此要写明状态码
    public static String error(int code, String message) {
        JsonObject json = new JsonObject();
        json.addProperty("code", code);
        json.addProperty("message", message);
        return gson.toJson(json);
    }

}
