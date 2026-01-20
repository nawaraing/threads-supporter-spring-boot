<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>예약 포스트 - Threads Supporter</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="/css/styles.css" rel="stylesheet">
</head>
<body>
    <%@ include file="/WEB-INF/views/layout/header.jsp" %>

    <main class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>예약 포스트</h2>
            <a href="/posts/create" class="btn btn-primary">
                <i class="bi bi-plus-circle"></i> 새 예약 만들기
            </a>
        </div>

        <div class="card">
            <div class="card-body">
                <c:if test="${empty posts}">
                    <div class="text-center py-5 text-muted">
                        <i class="bi bi-inbox" style="font-size: 48px;"></i>
                        <p class="mt-3">예약된 포스트가 없습니다.</p>
                        <a href="/posts/create" class="btn btn-primary">첫 예약 만들기</a>
                    </div>
                </c:if>
                <c:if test="${not empty posts}">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>내용</th>
                                    <th>요일</th>
                                    <th>시간</th>
                                    <th>유형</th>
                                    <th>상태</th>
                                    <th>마지막 발행</th>
                                    <th>작업</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="post" items="${posts}">
                                    <tr>
                                        <td style="max-width: 250px;">
                                            <c:choose>
                                                <c:when test="${post.content.length() > 60}">
                                                    ${post.content.substring(0, 60)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${post.content}
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${not empty post.imageUrls}">
                                                <br><small class="text-muted">
                                                    <i class="bi bi-image"></i> ${post.imageUrls.length}개 이미지
                                                </small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:if test="${not empty post.daysOfWeek}">
                                                <c:set var="days" value="${['일', '월', '화', '수', '목', '금', '토']}"/>
                                                <c:forEach var="day" items="${post.daysOfWeek}" varStatus="status">
                                                    ${days[day]}<c:if test="${!status.last}">,</c:if>
                                                </c:forEach>
                                            </c:if>
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${post.hour}" minIntegerDigits="2"/>:<fmt:formatNumber value="${post.minute}" minIntegerDigits="2"/>
                                        </td>
                                        <td>
                                            <span class="badge ${post.isRecurring ? 'bg-info' : 'bg-secondary'}">
                                                ${post.isRecurring ? '반복' : '일회성'}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge ${post.isActive ? 'bg-success' : 'bg-warning'}">
                                                ${post.isActive ? '활성' : '비활성'}
                                            </span>
                                        </td>
                                        <td>
                                            <c:if test="${post.lastPostedAt != null}">
                                                <fmt:formatDate value="${post.lastPostedAt}" pattern="yyyy-MM-dd HH:mm"/>
                                            </c:if>
                                            <c:if test="${post.lastPostedAt == null}">-</c:if>
                                        </td>
                                        <td>
                                            <div class="btn-group">
                                                <a href="/posts/${post.id}/edit" class="btn btn-sm btn-outline-primary" title="수정">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <button class="btn btn-sm btn-outline-secondary toggle-btn" data-id="${post.id}" title="${post.isActive ? '비활성화' : '활성화'}">
                                                    <i class="bi ${post.isActive ? 'bi-pause' : 'bi-play'}"></i>
                                                </button>
                                                <button class="btn btn-sm btn-outline-danger delete-btn" data-id="${post.id}" title="삭제">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/layout/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/app.js"></script>
    <script src="/js/posts.js"></script>
</body>
</html>
