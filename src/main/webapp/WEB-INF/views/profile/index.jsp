<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>프로필 - Threads Supporter</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="/css/styles.css" rel="stylesheet">
</head>
<body>
    <%@ include file="/WEB-INF/views/layout/header.jsp" %>

    <main class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body text-center">
                        <c:if test="${not empty user.profilePictureUrl}">
                            <img src="${user.profilePictureUrl}" alt="Profile" class="rounded-circle mb-3" width="120" height="120">
                        </c:if>
                        <c:if test="${empty user.profilePictureUrl}">
                            <div class="bg-secondary rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width:120px;height:120px;">
                                <i class="bi bi-person text-white" style="font-size:60px;"></i>
                            </div>
                        </c:if>

                        <h4>@${user.username}</h4>

                        <c:if test="${not empty user.followerCount}">
                            <p class="text-muted">${user.followerCount} followers</p>
                        </c:if>

                        <hr>

                        <div class="text-start">
                            <p><strong>Threads ID:</strong> ${user.threadsUserId}</p>
                            <p><strong>가입일:</strong> <fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd"/></p>
                            <p><strong>토큰 만료:</strong>
                                <c:if test="${not empty user.tokenExpiresAt}">
                                    <fmt:formatDate value="${user.tokenExpiresAt}" pattern="yyyy-MM-dd HH:mm"/>
                                </c:if>
                                <c:if test="${empty user.tokenExpiresAt}">-</c:if>
                            </p>
                        </div>

                        <hr>

                        <div class="d-grid gap-2">
                            <form action="/profile/sync" method="post" class="d-grid">
                                <button type="submit" class="btn btn-outline-primary">
                                    <i class="bi bi-arrow-clockwise"></i> 프로필 동기화
                                </button>
                            </form>
                            <a href="/auth/logout" class="btn btn-outline-danger">
                                <i class="bi bi-box-arrow-right"></i> 로그아웃
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/layout/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
