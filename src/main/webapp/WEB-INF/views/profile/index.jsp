<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>프로필 - 스레드 서포터</title>
    <link href="/css/styles.css" rel="stylesheet">
</head>
<body>
    <div class="profile-page">
        <!-- 헤더 -->
        <header class="header">
            <h1 class="header-title">프로필</h1>
            <form action="/profile/sync" method="post" style="margin: 0;">
                <button type="submit" class="header-btn" id="refreshBtn" aria-label="프로필 새로고침">
                    <svg width="24" height="24" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                    </svg>
                </button>
            </form>
        </header>

        <!-- 프로필 정보 -->
        <div class="profile-content">
            <!-- 프로필 이미지 -->
            <div class="profile-avatar-wrapper">
                <c:choose>
                    <c:when test="${not empty user.profilePictureUrl}">
                        <img src="${user.profilePictureUrl}" alt="${user.username}" class="profile-avatar">
                    </c:when>
                    <c:otherwise>
                        <div class="profile-avatar-placeholder">
                            <svg fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm0 14.2c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08 1.99 0 5.97 1.09 6 3.08-1.29 1.94-3.5 3.22-6 3.22z"/>
                            </svg>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 사용자 이름 -->
            <div class="profile-name">
                <h2>${user.username}</h2>
                <p>@${user.username}</p>
            </div>

            <!-- 팔로워 수 -->
            <c:if test="${not empty user.followerCount}">
                <div class="profile-followers">
                    <p>팔로워</p>
                    <p><fmt:formatNumber value="${user.followerCount}" /></p>
                </div>
            </c:if>

            <!-- 구분선 -->
            <div class="profile-divider"></div>

            <!-- 지원 메뉴 섹션 -->
            <div style="margin-bottom: 2rem;">
                <h3 class="profile-section-title">지원</h3>
                <div class="profile-menu">
                    <a href="mailto:nawaddaing@gmail.com?subject=새 기능 제안" target="_blank" rel="noopener noreferrer" class="profile-menu-item">
                        <div class="profile-menu-item-left">
                            <div class="profile-menu-icon blue">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
                                </svg>
                            </div>
                            <span class="profile-menu-text">새 기능 제안하기</span>
                        </div>
                        <div class="profile-menu-arrow">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                            </svg>
                        </div>
                    </a>
                    <a href="mailto:nawaddaing@gmail.com?subject=1:1 문의" target="_blank" rel="noopener noreferrer" class="profile-menu-item">
                        <div class="profile-menu-item-left">
                            <div class="profile-menu-icon green">
                                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z" />
                                </svg>
                            </div>
                            <span class="profile-menu-text">1:1 문의하기</span>
                        </div>
                        <div class="profile-menu-arrow">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                            </svg>
                        </div>
                    </a>
                </div>
            </div>

            <!-- 로그아웃 버튼 -->
            <div>
                <button type="button" class="btn btn-danger btn-block" onclick="showLogoutModal()">
                    로그아웃
                </button>
            </div>
        </div>

        <!-- 로그아웃 확인 모달 -->
        <div id="logoutModal" class="modal-overlay center hidden animate-fadeIn" onclick="hideLogoutModal()">
            <div class="modal-content center animate-fadeIn" style="max-width: 24rem;" onclick="event.stopPropagation()">
                <div style="padding: 1.5rem;">
                    <h3 class="modal-title mb-2">로그아웃</h3>
                    <p style="font-size: 0.875rem; color: var(--gray-600); margin-bottom: 1.5rem;">
                        정말 로그아웃 하시겠습니까?
                    </p>
                    <div class="btn-row">
                        <button type="button" class="btn btn-secondary" onclick="hideLogoutModal()">
                            취소
                        </button>
                        <a href="/auth/logout" class="btn btn-danger" style="text-decoration: none;">
                            로그아웃
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- 하단 네비게이션 -->
        <nav class="bottom-nav">
            <div class="bottom-nav-inner">
                <ul class="bottom-nav-list">
                    <li class="bottom-nav-item">
                        <a href="/posts" class="bottom-nav-link">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                            <span>예약</span>
                        </a>
                    </li>
                    <li class="bottom-nav-item">
                        <a href="/insights" class="bottom-nav-link">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                            </svg>
                            <span>통계</span>
                        </a>
                    </li>
                    <li class="bottom-nav-item">
                        <a href="/profile" class="bottom-nav-link active">
                            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                            </svg>
                            <span>프로필</span>
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
    </div>

    <script>
        function showLogoutModal() {
            document.getElementById('logoutModal').classList.remove('hidden');
        }

        function hideLogoutModal() {
            document.getElementById('logoutModal').classList.add('hidden');
        }
    </script>
</body>
</html>
