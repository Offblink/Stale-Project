<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>错误 - PetShop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f5f5f5; }
        .error-container { max-width: 600px; margin: 100px auto; text-align: center; }
        .error-code { font-size: 8rem; font-weight: 700; color: #667eea; }
        .error-message { font-size: 1.5rem; color: #666; margin: 20px 0; }
        .btn-home { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; padding: 12px 30px; border-radius: 25px; color: #fff; text-decoration: none; display: inline-block; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-code">${pageContext.errorData.statusCode}</div>
        <div class="error-message">
            <%=
            request.getAttribute("javax.servlet.error.message") != null
                ? request.getAttribute("javax.servlet.error.message")
                : (request.getAttribute("javax.servlet.error.exception") != null
                    ? "服务器内部错误"
                    : "页面不存在")
            %>
        </div>
        <a href="${pageContext.request.contextPath}/index.jsp" class="btn-home">
            <i class="fas fa-home"></i> 返回首页
        </a>
    </div>
</body>
</html>
