package com.vibeshop.service;

import com.vibeshop.dao.CartDao;
import com.vibeshop.dao.ProductDao;
import com.vibeshop.model.Cart;
import com.vibeshop.model.Product;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CartService {
    private CartDao cartDao = new CartDao();
    private ProductDao productDao = new ProductDao();

    public List<Cart> getCartByUserId(Integer userId) {
        return cartDao.findByUserId(userId);
    }

    public Map<String, Object> addToCart(Integer userId, Integer productId, Integer quantity) {
        Map<String, Object> result = new HashMap<>();

        if (userId == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        if (productId == null) {
            result.put("success", false);
            result.put("message", "商品不存在");
            return result;
        }

        if (quantity == null || quantity < 1) {
            quantity = 1;
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

        Cart existingCart = cartDao.findByUserIdAndProductId(userId, productId);
        if (existingCart != null) {
            int newQuantity = existingCart.getQuantity() + quantity;
            if (product.getStock() < newQuantity) {
                result.put("success", false);
                result.put("message", "库存不足");
                return result;
            }
            cartDao.updateQuantity(existingCart.getId(), newQuantity);
            result.put("success", true);
            result.put("message", "购物车数量已更新");
        } else {
            Cart cart = new Cart(userId, productId, quantity);
            int id = cartDao.insert(cart);
            if (id > 0) {
                result.put("success", true);
                result.put("message", "已添加到购物车");
            } else {
                result.put("success", false);
                result.put("message", "添加购物车失败");
            }
        }

        return result;
    }

    public Map<String, Object> updateCartQuantity(Integer cartId, Integer quantity) {
        Map<String, Object> result = new HashMap<>();

        if (cartId == null) {
            result.put("success", false);
            result.put("message", "购物车项ID不能为空");
            return result;
        }

        if (quantity == null || quantity < 1) {
            result.put("success", false);
            result.put("message", "数量不能小于1");
            return result;
        }

        Cart cart = cartDao.findById(cartId);
        if (cart == null) {
            result.put("success", false);
            result.put("message", "购物车项不存在");
            return result;
        }

        Product product = productDao.findById(cart.getProductId());
        if (product == null) {
            result.put("success", false);
            result.put("message", "商品不存在");
            return result;
        }

        if (product.getStock() < quantity) {
            result.put("success", false);
            result.put("message", "库存不足，当前库存：" + product.getStock());
            return result;
        }

        boolean success = cartDao.updateQuantity(cartId, quantity);
        if (success) {
            result.put("success", true);
            result.put("message", "数量已更新");
        } else {
            result.put("success", false);
            result.put("message", "数量更新失败");
        }

        return result;
    }

    public Map<String, Object> removeFromCart(Integer cartId) {
        Map<String, Object> result = new HashMap<>();
        boolean success = cartDao.delete(cartId);

        if (success) {
            result.put("success", true);
            result.put("message", "已从购物车移除");
        } else {
            result.put("success", false);
            result.put("message", "移除失败");
        }

        return result;
    }

}
