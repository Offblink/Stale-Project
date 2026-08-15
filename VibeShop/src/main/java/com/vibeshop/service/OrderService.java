package com.vibeshop.service;

import com.vibeshop.dao.AddressDao;
import com.vibeshop.dao.CartDao;
import com.vibeshop.dao.OrderDao;
import com.vibeshop.dao.ProductDao;
import com.vibeshop.model.Address;
import com.vibeshop.model.Cart;
import com.vibeshop.model.Order;
import com.vibeshop.model.OrderItem;
import com.vibeshop.model.Product;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderService {
    private OrderDao orderDao = new OrderDao();
    private CartDao cartDao = new CartDao();
    private ProductDao productDao = new ProductDao();
    private AddressDao addressDao = new AddressDao();

    public Map<String, Object> createOrder(Integer userId, Integer addressId, List<Cart> cartItems) {
        Map<String, Object> result = new HashMap<>();

        if (userId == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        if (addressId == null) {
            result.put("success", false);
            result.put("message", "请选择收货地址");
            return result;
        }

        Address address = addressDao.findById(addressId);
        if (address == null || !address.getUserId().equals(userId)) {
            result.put("success", false);
            result.put("message", "收货地址无效");
            return result;
        }

        if (cartItems == null || cartItems.isEmpty()) {
            result.put("success", false);
            result.put("message", "购物车为空");
            return result;
        }

        BigDecimal totalPrice = BigDecimal.ZERO;
        for (Cart cartItem : cartItems) {
            Product product = productDao.findById(cartItem.getProductId());
            if (product == null) {
                result.put("success", false);
                result.put("message", "商品不存在");
                return result;
            }
            if (product.getStock() < cartItem.getQuantity()) {
                result.put("success", false);
                result.put("message", "商品[" + product.getName() + "]库存不足");
                return result;
            }
            totalPrice = totalPrice.add(product.getPrice().multiply(new BigDecimal(cartItem.getQuantity())));
        }

        Order order = new Order(userId, addressId, totalPrice, "pending");
        int orderId = orderDao.insert(order);

        if (orderId <= 0) {
            result.put("success", false);
            result.put("message", "订单创建失败");
            return result;
        }

        order.setId(orderId);

        for (Cart cartItem : cartItems) {
            Product product = productDao.findById(cartItem.getProductId());
            OrderItem item = new OrderItem(
                orderId,
                product.getId(),
                product.getName(),
                product.getPrice(),
                cartItem.getQuantity()
            );
            orderDao.insertItem(item);
            productDao.updateStock(product.getId(), cartItem.getQuantity());
        }

        cartDao.clearByUserId(userId);

        result.put("success", true);
        result.put("message", "订单创建成功");
        result.put("order", order);

        return result;
    }

    public List<Order> getOrdersByUserId(Integer userId) {
        return orderDao.findByUserId(userId);
    }

    public Map<String, Object> directBuy(Integer userId, Integer addressId, Integer productId, Integer quantity) {
        Map<String, Object> result = new HashMap<>();

        if (userId == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        if (addressId == null) {
            result.put("success", false);
            result.put("message", "请选择收货地址");
            return result;
        }

        Address address = addressDao.findById(addressId);
        if (address == null || !address.getUserId().equals(userId)) {
            result.put("success", false);
            result.put("message", "收货地址无效");
            return result;
        }

        Product product = productDao.findById(productId);
        if (product == null) {
            result.put("success", false);
            result.put("message", "商品不存在");
            return result;
        }

        if (product.getStock() < quantity) {
            result.put("success", false);
            result.put("message", "库存不足");
            return result;
        }

        BigDecimal totalPrice = product.getPrice().multiply(new BigDecimal(quantity));

        Order order = new Order(userId, addressId, totalPrice, "pending");
        int orderId = orderDao.insert(order);

        if (orderId <= 0) {
            result.put("success", false);
            result.put("message", "订单创建失败");
            return result;
        }

        order.setId(orderId);

        OrderItem item = new OrderItem(
            orderId,
            product.getId(),
            product.getName(),
            product.getPrice(),
            quantity
        );
        orderDao.insertItem(item);

        productDao.updateStock(product.getId(), quantity);

        result.put("success", true);
        result.put("message", "订单创建成功");
        result.put("order", order);

        return result;
    }
}
