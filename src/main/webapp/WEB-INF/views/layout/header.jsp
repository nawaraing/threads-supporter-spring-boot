<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="/dashboard">
            <strong>Threads Supporter</strong>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/dashboard">대시보드</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/posts">예약 포스트</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/profile">프로필</a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <span class="nav-link text-light">
                        <c:if test="${not empty sessionScope.username}">
                            @${sessionScope.username}
                        </c:if>
                    </span>
                </li>
                <li class="nav-item">
                    <form action="/auth/logout" method="post" style="display: inline;">
                        <button type="submit" class="nav-link btn btn-link" style="border: none; background: none; cursor: pointer;">로그아웃</button>
                    </form>
                </li>
            </ul>
        </div>
    </div>
</nav>
