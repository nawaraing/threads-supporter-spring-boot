<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - Threads Supporter</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            max-width: 400px;
            width: 100%;
        }
        .login-card h1 {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .login-card p {
            color: #666;
            margin-bottom: 30px;
        }
        .btn-threads {
            background: #000;
            color: white;
            border: none;
            padding: 15px 30px;
            font-size: 16px;
            border-radius: 30px;
            width: 100%;
            transition: transform 0.2s;
        }
        .btn-threads:hover {
            background: #333;
            color: white;
            transform: scale(1.02);
        }
        .features {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .feature-item {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            font-size: 14px;
            color: #555;
        }
        .feature-item span {
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="text-center">
            <h1>Threads Supporter</h1>
            <p>Threads 자동 포스팅 서비스</p>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <a href="/auth/threads" class="btn btn-threads">
                Threads로 로그인
            </a>

            <div class="features">
                <div class="feature-item">
                    <span>📅</span> 원하는 시간에 자동 포스팅
                </div>
                <div class="feature-item">
                    <span>🔄</span> 반복 스케줄 설정
                </div>
                <div class="feature-item">
                    <span>📊</span> 포스팅 현황 확인
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
