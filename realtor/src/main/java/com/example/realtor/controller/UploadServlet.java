package com.example.realtor.controller;

import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.UUID;

@WebServlet("/api/upload")
@MultipartConfig(maxFileSize = 10485760, maxRequestSize = 20971520)
public class UploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        JsonObject result = new JsonObject();

        try {
            Part filePart = request.getPart("image");
            if (filePart == null || filePart.getSize() == 0) {
                result.addProperty("status", "error");
                result.addProperty("message", "未选择文件");
                out.println(result.toString());
                return;
            }

            String submittedFileName = filePart.getSubmittedFileName();
            String ext = "";
            int dot = submittedFileName.lastIndexOf('.');
            if (dot > 0) ext = submittedFileName.substring(dot);

            String newName = "img_" + UUID.randomUUID().toString().substring(0, 8) + ext;

            String realPath = getServletContext().getRealPath("/img");
            File dir = new File(realPath);
            if (!dir.exists()) dir.mkdirs();

            filePart.write(realPath + File.separator + newName);

            result.addProperty("status", "success");
            result.addProperty("url", "/realtor/img/" + newName);
            result.addProperty("message", "上传成功");
        } catch (Exception e) {
            result.addProperty("status", "error");
            result.addProperty("message", "上传失败: " + e.getMessage());
        }
        out.println(result.toString());
    }
}
