package com.vibeshop.dao;

import com.vibeshop.model.Address;
import com.vibeshop.util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AddressDao {

    public List<Address> findByUserId(Integer userId) {
        List<Address> addresses = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM address WHERE user_id = ? ORDER BY is_default DESC, created_at DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Address address = extractAddress(rs);
                addresses.add(address);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }

        return addresses;
    }

    public Address findById(Integer id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Address address = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM address WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                address = extractAddress(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(rs, pstmt, conn);
        }

        return address;
    }

    public int insert(Address address) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int generatedId = 0;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 先关闭自动提交，便于出错时回滚

            // 这里：IsDefault是地址的一个布尔属性，1表示默认
            // 基于这种设计，我们不能简单地使用新默认地址覆盖原默认地址
            if (address.getIsDefault() == 1) {
                // 而应该先将该用户下的所有地址的IsDefault属性设为0
                String resetSql = "UPDATE address SET is_default = 0 WHERE user_id = ?";
                pstmt = conn.prepareStatement(resetSql);
                pstmt.setInt(1, address.getUserId());
                pstmt.executeUpdate();
                pstmt.close();
            }

            // 然后再统一插入，并设置默认地址
            String sql = "INSERT INTO address (user_id, receiver_name, phone, province, city, district, detail_address, is_default) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            // 要求返回自增ID，用于初始化地址对象
            pstmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS); 
            pstmt.setInt(1, address.getUserId());
            pstmt.setString(2, address.getReceiverName());
            pstmt.setString(3, address.getPhone());
            pstmt.setString(4, address.getProvince());
            pstmt.setString(5, address.getCity());
            pstmt.setString(6, address.getDistrict());
            pstmt.setString(7, address.getDetailAddress());
            pstmt.setInt(8, address.getIsDefault()); // <-- Here 设置默认地址
            pstmt.executeUpdate();

            rs = pstmt.getGeneratedKeys(); // 从这里获取返回的自增ID
            // 结果集有且仅有一行，获取这一行并设为对象ID
            if (rs.next()) {
                generatedId = rs.getInt(1);
                address.setId(generatedId);
            }

            conn.commit(); // 如执行成功，提交事务
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // 如果执行失败，回滚事务
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true); // 将自动提交设置回true
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.close(rs, pstmt, conn);
        }

        return generatedId;
    }

    public boolean update(Address address) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            if (address.getIsDefault() == 1) {
                String resetSql = "UPDATE address SET is_default = 0 WHERE user_id = ?";
                pstmt = conn.prepareStatement(resetSql);
                pstmt.setInt(1, address.getUserId());
                pstmt.executeUpdate();
                pstmt.close();
            }

            String sql = "UPDATE address SET receiver_name = ?, phone = ?, province = ?, city = ?, district = ?, detail_address = ?, is_default = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, address.getReceiverName());
            pstmt.setString(2, address.getPhone());
            pstmt.setString(3, address.getProvince());
            pstmt.setString(4, address.getCity());
            pstmt.setString(5, address.getDistrict());
            pstmt.setString(6, address.getDetailAddress());
            pstmt.setInt(7, address.getIsDefault());
            pstmt.setInt(8, address.getId());
            success = pstmt.executeUpdate() > 0;

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.close(pstmt, conn);
        }

        return success;
    }

    public boolean delete(Integer id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        boolean success = false;

        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM address WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            success = pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(pstmt, conn);
        }

        return success;
    }

    private Address extractAddress(ResultSet rs) throws SQLException {
        Address address = new Address();
        address.setId(rs.getInt("id"));
        address.setUserId(rs.getInt("user_id"));
        address.setReceiverName(rs.getString("receiver_name"));
        address.setPhone(rs.getString("phone"));
        address.setProvince(rs.getString("province"));
        address.setCity(rs.getString("city"));
        address.setDistrict(rs.getString("district"));
        address.setDetailAddress(rs.getString("detail_address"));
        address.setIsDefault(rs.getInt("is_default"));
        address.setCreatedAt(rs.getTimestamp("created_at"));
        return address;
    }
}
