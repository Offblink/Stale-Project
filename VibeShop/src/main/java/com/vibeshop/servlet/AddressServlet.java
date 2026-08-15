package com.vibeshop.servlet;

import com.google.gson.Gson;
import com.vibeshop.model.Address;
import com.vibeshop.service.AddressService;
import com.vibeshop.util.JsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;
import java.util.Map;

// 这个servlet应用于所有前缀是/user/address/的API
@WebServlet("/api/user/address/*")
public class AddressServlet extends HttpServlet {
    private AddressService addressService = new AddressService();
    private Gson gson = new Gson();

    /*
    下面实现了四种请求方法：GET（获取）、POST（提交）、PUT（置入，更新）和DELETE（删除）
    分别读取请求体中的JSON数据并执行相应操作
    */

    @Override
    // 专门用于获取用户的地址
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo(); // 不读取请求体，而是从URL中直接获取用户ID

        if (pathInfo != null && pathInfo.length() > 1) {
            // 从第一个索引位置开始往后取，去掉第一位的"/"
            String idStr = pathInfo.substring(1);
            try {
                // 为什么URL可以转成ID？因为我们使用Restful API
                Integer userId = Integer.parseInt(idStr);
                List<Address> addresses = addressService.getAddressesByUserId(userId);
                response.getWriter().write(JsonUtil.success(addresses)); // 这里：将消息返回给前端
            } catch (NumberFormatException e) {
                response.getWriter().write(JsonUtil.error(400, "无效的用户ID"));
            }
        } else {
            response.getWriter().write(JsonUtil.error(400, "用户ID不能为空"));
        }
    }

    @Override
    // 专门用于读取请求并提交新地址
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BufferedReader reader = request.getReader(); // 接收到请求后，读取请求体中的信息
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line); // 一行一行添加到StringBuilder
        }

        // 由于请求体是JSON格式，呈现键值对的形式，所以我们用映射类型存储
        Map<String, Object> data = gson.fromJson(sb.toString(), Map.class);
        Address address = new Address();

        if (data.get("userId") != null) {
            // 这里：GSON默认返回可转换为Double类型的字符串，需要再次转换类型为int
            address.setUserId(((Double) data.get("userId")).intValue());
        }
        address.setReceiverName((String) data.get("receiverName"));
        address.setPhone((String) data.get("phone"));
        address.setProvince((String) data.get("province"));
        address.setCity((String) data.get("city"));
        address.setDistrict((String) data.get("district"));
        address.setDetailAddress((String) data.get("detailAddress"));

        if (data.get("isDefault") != null) {
            address.setIsDefault(((Double) data.get("isDefault")).intValue());
        } else {
            address.setIsDefault(0); // 设置默认值
        }

        Map<String, Object> result = addressService.addAddress(address); // 根据读取到的信息创建新地址

        boolean success = (Boolean) result.get("success");
        String message = (String) result.get("message");
        if (success) {
            response.getWriter().write(JsonUtil.success(message, result.get("address")));
        } else {
            response.getWriter().write(JsonUtil.error(400, message));
        }
    }

    @Override
    // 专门用于更新地址信息
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        // 地址一共有3栏，因此要求长度不小于2
        if (pathInfo == null || pathInfo.length() < 2) {
            response.getWriter().write(JsonUtil.error(400, "地址ID不能为空"));
            return;
        }

        String idStr = pathInfo.substring(1);
        Integer addressId;
        try {
            addressId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.getWriter().write(JsonUtil.error(400, "无效的地址ID"));
            return;
        }

        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        Map<String, Object> data = gson.fromJson(sb.toString(), Map.class);
        Address address = new Address();
        address.setId(addressId);

        if (data.get("userId") != null) {
            address.setUserId(((Double) data.get("userId")).intValue());
        }
        address.setReceiverName((String) data.get("receiverName"));
        address.setPhone((String) data.get("phone"));
        address.setProvince((String) data.get("province"));
        address.setCity((String) data.get("city"));
        address.setDistrict((String) data.get("district"));
        address.setDetailAddress((String) data.get("detailAddress"));

        if (data.get("isDefault") != null) {
            address.setIsDefault(((Double) data.get("isDefault")).intValue());
        } else {
            address.setIsDefault(0);
        }

        Map<String, Object> result = addressService.updateAddress(address);

        boolean success = (Boolean) result.get("success");
        String message = (String) result.get("message");
        if (success) {
            response.getWriter().write(JsonUtil.success(message));
        } else {
            response.getWriter().write(JsonUtil.error(400, message));
        }
    }

    @Override
    // 专门用于删除地址记录
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.length() < 2) {
            response.getWriter().write(JsonUtil.error(400, "地址ID不能为空"));
            return;
        }

        String idStr = pathInfo.substring(1);
        try {
            Integer addressId = Integer.parseInt(idStr);
            Map<String, Object> result = addressService.deleteAddress(addressId);

            boolean success = (Boolean) result.get("success");
            String message = (String) result.get("message");
            if (success) {
                response.getWriter().write(JsonUtil.success(message));
            } else {
                response.getWriter().write(JsonUtil.error(400, message));
            }
        } catch (NumberFormatException e) {
            response.getWriter().write(JsonUtil.error(400, "无效的地址ID"));
        }
    }
}