package com.vibeshop.service;

import com.vibeshop.dao.ProductDao;
import com.vibeshop.model.Product;
import java.util.Map;

public class ProductService {
    private ProductDao productDao = new ProductDao();

    public Map<String, Object> getProductsByPage(int page, int size) {
        if (page < 1) page = 1;
        if (size < 1) size = 10;
        if (size > 50) size = 50;

        return productDao.findByPage(page, size);
    }

    public Product getProductById(Integer id) {
        return productDao.findById(id);
    }

}
