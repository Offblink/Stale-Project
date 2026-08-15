package com.vibeshop.service;

import com.vibeshop.dao.AddressDao;
import com.vibeshop.model.Address;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AddressService {
    private AddressDao addressDao = new AddressDao();

    public List<Address> getAddressesByUserId(Integer userId) {
        return addressDao.findByUserId(userId);
    }

    public Map<String, Object> addAddress(Address address) {
        Map<String, Object> result = new HashMap<>();

        if (address.getReceiverName() == null || address.getReceiverName().trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "收件人姓名不能为空");
            return result;
        }

        if (address.getPhone() == null || address.getPhone().trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "联系电话不能为空");
            return result;
        }

        if (address.getProvince() == null || address.getProvince().trim().isEmpty() ||
            address.getCity() == null || address.getCity().trim().isEmpty() ||
            address.getDistrict() == null || address.getDistrict().trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "省市区不能为空");
            return result;
        }

        if (address.getDetailAddress() == null || address.getDetailAddress().trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "详细地址不能为空");
            return result;
        }

        if (address.getIsDefault() == null) {
            address.setIsDefault(0);
        }

        int id = addressDao.insert(address);
        if (id > 0) {
            address.setId(id);
            result.put("success", true);
            result.put("message", "地址添加成功");
            result.put("address", address);
        } else {
            result.put("success", false);
            result.put("message", "地址添加失败");
        }

        return result;
    }

    public Map<String, Object> updateAddress(Address address) {
        Map<String, Object> result = new HashMap<>();

        if (address.getReceiverName() == null || address.getReceiverName().trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "收件人姓名不能为空");
            return result;
        }

        if (address.getPhone() == null || address.getPhone().trim().isEmpty()) {
            result.put("success", false);
            result.put("message", "联系电话不能为空");
            return result;
        }

        boolean success = addressDao.update(address);
        if (success) {
            result.put("success", true);
            result.put("message", "地址更新成功");
        } else {
            result.put("success", false);
            result.put("message", "地址更新失败");
        }

        return result;
    }

    public Map<String, Object> deleteAddress(Integer id) {
        Map<String, Object> result = new HashMap<>();
        boolean success = addressDao.delete(id);

        if (success) {
            result.put("success", true);
            result.put("message", "地址删除成功");
        } else {
            result.put("success", false);
            result.put("message", "地址删除失败");
        }

        return result;
    }
}
