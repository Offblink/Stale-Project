package com.vibeshop.servlet;

import com.google.gson.Gson;
import com.vibeshop.model.Cart;
import com.vibeshop.model.Order;
import com.vibeshop.service.CartService;
import com.vibeshop.service.OrderService;
import com.vibeshop.util.JsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/api/orders/*")
public class OrderServlet extends HttpServlet {
    private OrderService orderService = new OrderService();
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
                List<Order> orders = orderService.getOrdersByUserId(userId);
                response.getWriter().write(JsonUtil.success(orders));
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

        Integer userId = null;
        Integer addressId = null;
        List<Cart> cartItems = new ArrayList<>();

        if (data.get("userId") != null) {
            userId = ((Double) data.get("userId")).intValue();
        }
        if (data.get("addressId") != null) {
            addressId = ((Double) data.get("addressId")).intValue();
        }

        if ("/direct".equals(pathInfo)) {
            Integer productId = null;
            Integer quantity = 1;

            if (data.get("productId") != null) {
                productId = ((Double) data.get("productId")).intValue();
            }
            if (data.get("quantity") != null) {
                quantity = ((Double) data.get("quantity")).intValue();
            }

            Map<String, Object> result = orderService.directBuy(userId, addressId, productId, quantity);

            boolean success = (Boolean) result.get("success");
            String message = (String) result.get("message");
            if (success) {
                response.getWriter().write(JsonUtil.success(message, result.get("order")));
            } else {
                response.getWriter().write(JsonUtil.error(400, message));
            }
            return;
        }

        if (data.get("cartItems") != null) {
            List<Map<String, Object>> cartData = (List<Map<String, Object>>) data.get("cartItems");
            for (Map<String, Object> item : cartData) {
                Cart cart = new Cart();
                if (item.get("productId") != null) {
                    cart.setProductId(((Double) item.get("productId")).intValue());
                }
                if (item.get("quantity") != null) {
                    cart.setQuantity(((Double) item.get("quantity")).intValue());
                }
                cartItems.add(cart);
            }
        }

        if (cartItems.isEmpty()) {
            cartItems = cartService.getCartByUserId(userId);
        }

        Map<String, Object> result = orderService.createOrder(userId, addressId, cartItems);

        boolean success = (Boolean) result.get("success");
        String message = (String) result.get("message");
        if (success) {
            response.getWriter().write(JsonUtil.success(message, result.get("order")));
        } else {
            response.getWriter().write(JsonUtil.error(400, message));
        }
    }
}
