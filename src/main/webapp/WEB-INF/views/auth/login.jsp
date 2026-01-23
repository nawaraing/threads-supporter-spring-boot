<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>로그인 - 스레드 서포터</title>
    <link href="/css/styles.css" rel="stylesheet">
</head>
<body>
    <div class="app-container">
        <div class="login-page">
            <!-- 상단 텍스트 영역 -->
            <div class="login-header">
                <p class="login-subtitle">브랜딩은 시간이 많이 든다?</p>
                <h1 class="login-title">스레드 서포터</h1>
                <p class="login-desc">마케팅 시간을 단축시켜줄 최고의 도구</p>
            </div>

            <!-- 이미지 캐러셀 영역 -->
            <div class="login-carousel">
                <div class="login-carousel-item">
                    <div class="login-carousel-card">
                        <img src="/images/login-carousel-1.jpg" alt="스크린샷 1">
                    </div>
                </div>
                <div class="login-carousel-item">
                    <div class="login-carousel-card">
                        <img src="/images/login-carousel-2.jpg" alt="스크린샷 2">
                    </div>
                </div>
                <div class="login-carousel-item">
                    <div class="login-carousel-card">
                        <img src="/images/login-carousel-3.jpg" alt="스크린샷 3">
                    </div>
                </div>
            </div>

            <!-- 로그인 버튼 -->
            <div class="login-footer">
                <c:if test="${not empty error}">
                    <div class="error-box mb-4">
                        <div class="error-box-content">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                            <p>${error}</p>
                        </div>
                    </div>
                </c:if>
                <a href="/auth/threads" class="login-btn">
                    로그인
                </a>
            </div>
        </div>
    </div>
</body>
</html>
