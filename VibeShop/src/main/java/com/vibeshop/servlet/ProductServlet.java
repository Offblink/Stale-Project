package com.vibeshop.servlet;

import com.vibeshop.model.Product;
import com.vibeshop.service.ProductService;
import com.vibeshop.util.JsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/api/products/*")
public class ProductServlet extends HttpServlet {
    private ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            String pageStr = request.getParameter("page");
            String sizeStr = request.getParameter("size");

            int page = 1;
            int size = 10;

            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            if (sizeStr != null && !sizeStr.isEmpty()) {
                try {
                    size = Integer.parseInt(sizeStr);
                } catch (NumberFormatException e) {
                    size = 10;
                }
            }

            Map<String, Object> result = productService.getProductsByPage(page, size);
            response.getWriter().write(JsonUtil.success(result));
        } else {
            String idStr = pathInfo.substring(1);
            try {
                Integer productId = Integer.parseInt(idStr);
                Product product = productService.getProductById(productId);
                if (product != null) {
                    response.getWriter().write(JsonUtil.success(product));
                } else {
                    response.getWriter().write(JsonUtil.error(404, "商品不存在"));
                }
            } catch (NumberFormatException e) {
                response.getWriter().write(JsonUtil.error(400, "无效的商品ID"));
            }
        }
    }
}
