package com.example.realtor.config;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/*")
public class EncodingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        // 仅对 /api/* 路径设置 JSON 响应类型，避免影响 HTML/JSP/CSS/JS 等静态资源
        String path = req.getRequestURI();
        String ctxPath = req.getContextPath();
        String relativePath = path.substring(ctxPath.length());
        if (relativePath.startsWith("/api")) {
            resp.setContentType("application/json");
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
