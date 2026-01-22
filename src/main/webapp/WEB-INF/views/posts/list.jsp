<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>예약 발행 - 스레드 서포터</title>
    <link href="/css/styles.css" rel="stylesheet">
</head>
<body>
    <div class="app-container">
        <!-- 삭제 로딩 화면 -->
        <div id="deleteLoading" class="loading-overlay hidden">
            <div class="loading-box">
                <div class="loading-spinner animate-spin"></div>
                <p class="loading-text">삭제 중...</p>
            </div>
        </div>

        <!-- 헤더 -->
        <header class="header">
            <h1 class="header-title">예약 발행</h1>
            <div class="header-actions">
                <button type="button" class="header-btn" onclick="openFilterModal()" aria-label="필터">
                    <svg width="24" height="24" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z" />
                    </svg>
                </button>
                <button type="button" class="header-btn primary" onclick="openCreateModal()" aria-label="새 글 작성">
                    <svg width="24" height="24" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                </button>
            </div>
        </header>

        <!-- 정렬 옵션 -->
        <div class="sort-options">
            <div class="sort-options-list">
                <button type="button" class="sort-btn active" data-sort="recently_updated" onclick="setSortBy('recently_updated', this)">
                    최근 수정 순
                </button>
                <button type="button" class="sort-btn" data-sort="schedule_time" onclick="setSortBy('schedule_time', this)">
                    시간 순
                </button>
            </div>
        </div>

        <!-- 예약된 글 목록 -->
        <div class="post-list" id="postList">
            <c:if test="${empty posts}">
                <div class="empty-state">
                    <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <p>예약된 글이 없습니다</p>
                    <p class="hint">새 글을 작성해보세요!</p>
                </div>
            </c:if>
            <c:forEach var="post" items="${posts}">
                <article class="post-item" data-post-id="${post.id}" data-hour="${post.hour}" data-minute="${post.minute}" data-updated="${post.updatedAt.toLocalDate().toEpochDay()}" data-days="<c:forEach var="d" items="${post.daysOfWeek}" varStatus="s">${d}<c:if test="${!s.last}">,</c:if></c:forEach>">
                    <!-- 예약 시간 -->
                    <div class="post-schedule-info">
                        <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        <span class="schedule-text">
                            <c:set var="days" value="${['일', '월', '화', '수', '목', '금', '토']}"/>
                            <%-- 요일 배열을 Set으로 변환하여 체크 --%>
                            <c:set var="daySet" value="${post.daysOfWeek}"/>
                            <c:set var="hasWeekdays" value="${false}"/>
                            <c:set var="hasWeekend" value="${false}"/>
                            <c:set var="weekdayCount" value="${0}"/>
                            <c:set var="weekendCount" value="${0}"/>
                            <c:forEach var="d" items="${daySet}">
                                <c:if test="${d >= 1 && d <= 5}"><c:set var="weekdayCount" value="${weekdayCount + 1}"/></c:if>
                                <c:if test="${d == 0 || d == 6}"><c:set var="weekendCount" value="${weekendCount + 1}"/></c:if>
                            </c:forEach>
                            <c:choose>
                                <c:when test="${post.daysOfWeek.length == 7}">매일</c:when>
                                <c:when test="${weekdayCount == 5 && weekendCount == 0}">평일</c:when>
                                <c:when test="${weekendCount == 2 && weekdayCount == 0}">주말</c:when>
                                <c:otherwise>
                                    매주 <c:forEach var="day" items="${post.daysOfWeek}" varStatus="status">${days[day]}<c:if test="${!status.last}">, </c:if></c:forEach>
                                </c:otherwise>
                            </c:choose>
                            <fmt:formatNumber value="${post.hour}" minIntegerDigits="2"/>:<fmt:formatNumber value="${post.minute}" minIntegerDigits="2"/>
                        </span>
                        <c:if test="${!post.isRecurring}">
                            <span class="badge-once">1회</span>
                        </c:if>
                    </div>

                    <!-- 글 내용 -->
                    <div class="post-content-wrapper">
                        <!-- 토글 버튼 -->
                        <div class="post-toggle">
                            <button type="button" class="toggle-switch ${post.isActive ? 'active' : ''}"
                                    onclick="toggleActive('${post.id}', ${post.isActive})"
                                    data-post-id="${post.id}">
                                <span class="toggle-switch-knob"></span>
                            </button>
                        </div>

                        <div class="post-body" onclick="openEditModal('${post.id}')">
                            <!-- 프로필 이미지 -->
                            <c:choose>
                                <c:when test="${not empty user.profilePictureUrl}">
                                    <img src="${user.profilePictureUrl}" alt="${user.username}" class="post-avatar">
                                </c:when>
                                <c:otherwise>
                                    <div class="post-avatar-placeholder">
                                        <svg fill="currentColor" viewBox="0 0 24 24">
                                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm0 14.2c-2.5 0-4.71-1.28-6-3.22.03-1.99 4-3.08 6-3.08 1.99 0 5.97 1.09 6 3.08-1.29 1.94-3.5 3.22-6 3.22z"/>
                                        </svg>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <div class="post-main">
                                <div class="post-meta">
                                    <span class="post-username">${user.username}</span>
                                    <span class="post-date">
                                        <c:if test="${post.updatedAt != null}">
                                            ${post.updatedAt.year}. ${post.updatedAt.monthValue}. ${post.updatedAt.dayOfMonth}.
                                        </c:if>
                                    </span>
                                </div>
                                <p class="post-text">${post.content}</p>
                            </div>
                        </div>
                    </div>
                </article>
            </c:forEach>
        </div>

        <!-- 새 글 작성/수정 모달 -->
        <div id="postModal" class="modal-overlay hidden animate-fadeIn" onclick="closeModal()">
            <div class="modal-content animate-slideUp" onclick="event.stopPropagation()">
                <div class="modal-header">
                    <h2 class="modal-title" id="modalTitle">새 글 작성</h2>
                    <button type="button" class="modal-close" onclick="closeModal()">
                        <svg width="24" height="24" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>

                <form id="postForm" onsubmit="submitPost(event)">
                    <input type="hidden" id="postId" name="postId" value="">

                    <div class="modal-body space-y-6">
                        <!-- 예약 시간 -->
                        <div class="form-group">
                            <label class="form-label">예약 발행 시간</label>
                            <div class="time-select-row">
                                <select id="hour" name="hour" class="form-select">
                                    <c:forEach begin="0" end="23" var="h">
                                        <option value="${h}"><fmt:formatNumber value="${h}" minIntegerDigits="2"/>시</option>
                                    </c:forEach>
                                </select>
                                <span class="time-separator">:</span>
                                <select id="minute" name="minute" class="form-select">
                                    <c:forEach var="m" items="${['00', '05', '10', '15', '20', '25', '30', '35', '40', '45', '50', '55']}">
                                        <option value="${m}">${m}분</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- 예약 요일 -->
                        <div class="form-group">
                            <div class="form-label-row">
                                <label class="form-label mb-0">예약 발행 요일</label>
                                <div class="checkbox-group">
                                    <input type="checkbox" id="selectAllDays" checked onchange="toggleAllDays(this.checked)">
                                    <label for="selectAllDays">전체 선택</label>
                                </div>
                            </div>
                            <div class="day-selector" id="daySelector">
                                <button type="button" class="day-btn active" data-day="0" onclick="toggleDay(this)">일</button>
                                <button type="button" class="day-btn active" data-day="1" onclick="toggleDay(this)">월</button>
                                <button type="button" class="day-btn active" data-day="2" onclick="toggleDay(this)">화</button>
                                <button type="button" class="day-btn active" data-day="3" onclick="toggleDay(this)">수</button>
                                <button type="button" class="day-btn active" data-day="4" onclick="toggleDay(this)">목</button>
                                <button type="button" class="day-btn active" data-day="5" onclick="toggleDay(this)">금</button>
                                <button type="button" class="day-btn active" data-day="6" onclick="toggleDay(this)">토</button>
                            </div>
                        </div>

                        <!-- 반복 발행 -->
                        <div class="recurring-box">
                            <input type="checkbox" id="isRecurring" name="isRecurring" checked>
                            <label for="isRecurring">반복 발행 (체크 해제 시 1회만 발행)</label>
                        </div>

                        <!-- 글 내용 -->
                        <div class="form-group">
                            <label class="form-label" for="content">글 내용</label>
                            <textarea id="content" name="content" class="form-textarea" placeholder="스레드에 공유할 내용을 작성하세요..." oninput="updateCharCount()"></textarea>
                            <div class="form-hint">
                                <span id="charCount">0</span> / 500
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <!-- 수정 모드일 때만 삭제 버튼 표시 -->
                        <div id="editModeButtons" class="hidden space-y-3">
                            <button type="button" class="btn btn-danger-outline btn-block" onclick="confirmDelete()">
                                삭제
                            </button>
                            <div class="btn-row">
                                <button type="button" class="btn btn-secondary" onclick="closeModal()">
                                    취소
                                </button>
                                <button type="submit" class="btn btn-primary" id="submitEditBtn">
                                    수정 완료
                                </button>
                            </div>
                        </div>
                        <!-- 생성 모드일 때 버튼 -->
                        <div id="createModeButtons" class="btn-row">
                            <button type="button" class="btn btn-secondary" onclick="closeModal()">
                                취소
                            </button>
                            <button type="submit" class="btn btn-primary" id="submitCreateBtn">
                                예약 등록
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- 삭제 확인 모달 -->
        <div id="deleteConfirmModal" class="modal-overlay center hidden animate-fadeIn" onclick="closeDeleteConfirm()">
            <div class="modal-content center animate-fadeIn" style="max-width: 24rem;" onclick="event.stopPropagation()">
                <div style="padding: 1.5rem;">
                    <h3 class="modal-title mb-2">예약 글 삭제</h3>
                    <p style="font-size: 0.875rem; color: var(--gray-600); margin-bottom: 1.5rem;">
                        이 예약 글을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.
                    </p>
                    <div class="btn-row">
                        <button type="button" class="btn btn-secondary" onclick="closeDeleteConfirm()">
                            취소
                        </button>
                        <button type="button" class="btn btn-danger" onclick="deletePost()">
                            삭제
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 필터 모달 -->
        <div id="filterModal" class="modal-overlay hidden animate-fadeIn" onclick="closeFilterModal()">
            <div class="modal-content animate-slideUp" onclick="event.stopPropagation()">
                <div class="modal-header">
                    <h2 class="modal-title">필터</h2>
                    <button type="button" class="modal-close" onclick="closeFilterModal()">
                        <svg width="24" height="24" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>

                <div class="modal-body space-y-6">
                    <!-- 요일 필터 -->
                    <div class="form-group">
                        <div class="form-label-row">
                            <label class="form-label mb-0">요일 선택</label>
                            <div class="checkbox-group">
                                <input type="checkbox" id="filterSelectAllDays" checked onchange="toggleAllFilterDays(this.checked)">
                                <label for="filterSelectAllDays">전체 선택</label>
                            </div>
                        </div>
                        <div class="day-selector" id="filterDaySelector">
                            <button type="button" class="day-btn active" data-day="0" onclick="toggleFilterDay(this)">일</button>
                            <button type="button" class="day-btn active" data-day="1" onclick="toggleFilterDay(this)">월</button>
                            <button type="button" class="day-btn active" data-day="2" onclick="toggleFilterDay(this)">화</button>
                            <button type="button" class="day-btn active" data-day="3" onclick="toggleFilterDay(this)">수</button>
                            <button type="button" class="day-btn active" data-day="4" onclick="toggleFilterDay(this)">목</button>
                            <button type="button" class="day-btn active" data-day="5" onclick="toggleFilterDay(this)">금</button>
                            <button type="button" class="day-btn active" data-day="6" onclick="toggleFilterDay(this)">토</button>
                        </div>
                    </div>

                    <!-- 시간 필터 -->
                    <div class="form-group">
                        <label class="form-label">시간 범위 선택</label>

                        <div class="mb-4">
                            <label style="display: block; font-size: 0.75rem; color: var(--gray-600); margin-bottom: 0.5rem;">시작 시간</label>
                            <div class="time-select-row">
                                <select id="filterStartHour" class="form-select">
                                    <c:forEach begin="0" end="23" var="h">
                                        <option value="${h}"><fmt:formatNumber value="${h}" minIntegerDigits="2"/>시</option>
                                    </c:forEach>
                                </select>
                                <select id="filterStartMinute" class="form-select">
                                    <c:forEach var="m" items="${['00', '05', '10', '15', '20', '25', '30', '35', '40', '45', '50', '55']}">
                                        <option value="${m}">${m}분</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label style="display: block; font-size: 0.75rem; color: var(--gray-600); margin-bottom: 0.5rem;">끝 시간</label>
                            <div class="time-select-row">
                                <select id="filterEndHour" class="form-select">
                                    <c:forEach begin="0" end="23" var="h">
                                        <option value="${h}" ${h == 23 ? 'selected' : ''}><fmt:formatNumber value="${h}" minIntegerDigits="2"/>시</option>
                                    </c:forEach>
                                </select>
                                <select id="filterEndMinute" class="form-select">
                                    <c:forEach var="m" items="${['00', '05', '10', '15', '20', '25', '30', '35', '40', '45', '50', '55']}">
                                        <option value="${m}" ${m == '55' ? 'selected' : ''}>${m}분</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="filter-info">
                            <p><strong>선택된 시간:</strong> <span id="filterTimeRange">00:00 ~ 23:55</span></p>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <div class="btn-row">
                        <button type="button" class="btn btn-secondary" onclick="resetFilter()">
                            초기화
                        </button>
                        <button type="button" class="btn btn-primary" onclick="applyFilter()">
                            적용
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 하단 네비게이션 -->
        <nav class="bottom-nav">
            <div class="bottom-nav-inner">
                <ul class="bottom-nav-list">
                    <li class="bottom-nav-item">
                        <a href="/posts" class="bottom-nav-link active">
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
                        <a href="/profile" class="bottom-nav-link">
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

    <script src="/js/posts.js"></script>
</body>
</html>
