package com.vibeshop.dao;

import com.vibeshop.model.Address;
import com.vibeshop.model.Order;
import com.vibeshop.model.OrderItem;
import com.vibeshop.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {

    public int insert(Order order) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int generatedId = 0;

        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO orders (user_id, address_id, total_price, status) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, order.getUserId());
            pstmt.setInt(2, order.getAddressId());
            pstmt.setDouble(3, order.getTotalPrice().doubleValue());
            pstmt.setString(4, order.getStatus());
            pstmt.executeUpdate();

            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                generatedId = rs.getInt(1);
                order.setId(generatedId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }

        return generatedId;
    }

    public int insertItem(OrderItem item) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int generatedId = 0;

        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO order_item (order_id, product_id, product_name, price, quantity) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, item.getOrderId());
            pstmt.setInt(2, item.getProductId());
            pstmt.setString(3, item.getProductName());
            pstmt.setDouble(4, item.getPrice().doubleValue());
            pstmt.setInt(5, item.getQuantity());
            pstmt.executeUpdate();

            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                generatedId = rs.getInt(1);
                item.setId(generatedId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }

        return generatedId;
    }

    public List<Order> findByUserId(Integer userId) {
        List<Order> orders = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT o.*, a.receiver_name, a.phone, a.province, a.city, a.district, a.detail_address " +
                         "FROM orders o " +
                         "JOIN address a ON o.address_id = a.id " +
                         "WHERE o.user_id = ? ORDER BY o.created_at DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Order order = extractOrder(rs);
                Address address = new Address();
                address.setReceiverName(rs.getString("receiver_name"));
                address.setPhone(rs.getString("phone"));
                address.setProvince(rs.getString("province"));
                address.setCity(rs.getString("city"));
                address.setDistrict(rs.getString("district"));
                address.setDetailAddress(rs.getString("detail_address"));
                order.setAddress(address);

                List<OrderItem> items = findItemsByOrderId(order.getId());
                order.setItems(items);

                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }

        return orders;
    }

    public Order findById(Integer id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Order order = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT o.*, a.receiver_name, a.phone, a.province, a.city, a.district, a.detail_address " +
                         "FROM orders o " +
                         "JOIN address a ON o.address_id = a.id " +
                         "WHERE o.id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                order = extractOrder(rs);
                Address address = new Address();
                address.setReceiverName(rs.getString("receiver_name"));
                address.setPhone(rs.getString("phone"));
                address.setProvince(rs.getString("province"));
                address.setCity(rs.getString("city"));
                address.setDistrict(rs.getString("district"));
                address.setDetailAddress(rs.getString("detail_address"));
                order.setAddress(address);

                List<OrderItem> items = findItemsByOrderId(order.getId());
                order.setItems(items);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }

        return order;
    }

    private List<OrderItem> findItemsByOrderId(Integer orderId) {
        List<OrderItem> items = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM order_item WHERE order_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setPrice(rs.getBigDecimal("price"));
                item.setQuantity(rs.getInt("quantity"));
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }

        return items;
    }

    private Order extractOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setAddressId(rs.getInt("address_id"));
        order.setTotalPrice(rs.getBigDecimal("total_price"));
        order.setStatus(rs.getString("status"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        return order;
    }
}
