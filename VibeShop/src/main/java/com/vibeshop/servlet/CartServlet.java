package com.vibeshop.servlet;

import com.google.gson.Gson;
import com.vibeshop.model.Cart;
import com.vibeshop.service.CartService;
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

@WebServlet("/api/cart/*")
public class CartServlet extends HttpServlet {
    private CartService cartService = new CartService();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.length() > 1) {
            String userIdStr = pathInfo.substring(1);
            try {
                Integer userId = Integer.parseInt(userIdStr);
                List<Cart> carts = cartService.getCartByUserId(userId);
                response.getWriter().write(JsonUtil.success(carts));
            } catch (NumberFormatException e) {
                response.getWriter().write(JsonUtil.error(400, "无效的用户ID"));
            }
        } else {
            response.getWriter().write(JsonUtil.error(400, "用户ID不能为空"));
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        Map<String, Object> data = gson.fromJson(sb.toString(), Map.class);

        if ("/checkout".equals(pathInfo)) {
            response.getWriter().write(JsonUtil.error(400, "请使用订单接口进行结算"));
            return;
        }

        Integer userId = null;
        Integer productId = null;
        Integer quantity = 1;

        if (data.get("userId") != null) {
            userId = ((Double) data.get("userId")).intValue();
        }
        if (data.get("productId") != null) {
            productId = ((Double) data.get("productId")).intValue();
        }
        if (data.get("quantity") != null) {
            quantity = ((Double) data.get("quantity")).intValue();
        }

        Map<String, Object> result = cartService.addToCart(userId, productId, quantity);

        boolean success = (Boolean) result.get("success");
        String message = (String) result.get("message");
        if (success) {
            response.getWriter().write(JsonUtil.success(message));
        } else {
            response.getWriter().write(JsonUtil.error(400, message));
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.length() < 2) {
            response.getWriter().write(JsonUtil.error(400, "购物车项ID不能为空"));
            return;
        }

        String idStr = pathInfo.substring(1);
        Integer cartId;
        try {
            cartId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.getWriter().write(JsonUtil.error(400, "无效的购物车项ID"));
            return;
        }

        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        Map<String, Object> data = gson.fromJson(sb.toString(), Map.class);
        Integer quantity = 1;

        if (data.get("quantity") != null) {
            quantity = ((Double) data.get("quantity")).intValue();
        }

        Map<String, Object> result = cartService.updateCartQuantity(cartId, quantity);

        boolean success = (Boolean) result.get("success");
        String message = (String) result.get("message");
        if (success) {
            response.getWriter().write(JsonUtil.success(message));
        } else {
            response.getWriter().write(JsonUtil.error(400, message));
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.length() < 2) {
            response.getWriter().write(JsonUtil.error(400, "购物车项ID不能为空"));
            return;
        }

        String idStr = pathInfo.substring(1);
        try {
            Integer cartId = Integer.parseInt(idStr);
            Map<String, Object> result = cartService.removeFromCart(cartId);

            boolean success = (Boolean) result.get("success");
            String message = (String) result.get("message");
            if (success) {
                response.getWriter().write(JsonUtil.success(message));
            } else {
                response.getWriter().write(JsonUtil.error(400, message));
            }
        } catch (NumberFormatException e) {
            response.getWriter().write(JsonUtil.error(400, "无效的购物车项ID"));
        }
    }
}
