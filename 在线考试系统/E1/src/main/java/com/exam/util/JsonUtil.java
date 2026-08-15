package com.exam.util;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import com.google.gson.reflect.TypeToken;
import jakarta.servlet.ServletContext;
import java.io.*;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

public class JsonUtil {
    // 使用格式化输出，避免打印在同一行
    private static final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    private static ServletContext servletContext;

    // 新增：用于在系统启动时注入 ServletContext
    public static void setServletContext(ServletContext context) {
        servletContext = context;
    }

    // 获取文件的真实物理路径
    private static String getRealPath(String fileName) {
        if (servletContext == null) {
            throw new IllegalStateException("ServletContext未初始化，请检查InitServlet是否正确调用了JsonUtil.setServletContext");
        }
        // 文件存放在 webapp/data 目录下
        return servletContext.getRealPath("/data/" + fileName);
    }

    public static  List readList(String fileName, Class clazz) {
        String path = getRealPath(fileName);
        File file = new File(path);

        // 如果文件不存在，返回空列表
        if (!file.exists()) {
            return new ArrayList<>();
        }

        try (Reader reader = new FileReader(file)) {  // 1. 自动资源管理
            Type type = TypeToken.getParameterized(List.class, clazz).getType();  // 2. 获取泛型类型（AI)
            List list = gson.fromJson(reader, type);  // 3. 反序列化JSON（JSON->Java对象）
            return list == null ? new ArrayList<>() : list;  // 4. 空值处理
        } catch (IOException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public static void writeList(String fileName, List list) {
        String path = getRealPath(fileName);
        File file = new File(path);

        try {
            // 如果文件不存在，自动创建父目录和文件
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                file.createNewFile();
            }

            try (Writer writer = new FileWriter(file)) {
                gson.toJson(list, writer);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}