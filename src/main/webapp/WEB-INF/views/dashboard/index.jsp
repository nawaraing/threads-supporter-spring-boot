<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>대시보드 - Threads Supporter</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="/css/styles.css" rel="stylesheet">
</head>
<body>
    <%@ include file="/WEB-INF/views/layout/header.jsp" %>

    <main class="container mt-4">
        <!-- User Info & Stats -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body text-center">
                        <c:if test="${not empty user.profilePictureUrl}">
                            <img src="${user.profilePictureUrl}" alt="Profile" class="rounded-circle mb-3" width="80" height="80">
                        </c:if>
                        <c:if test="${empty user.profilePictureUrl}">
                            <div class="bg-secondary rounded-circle d-inline-flex align-items-center justify-content-center mb-3" style="width:80px;height:80px;">
                                <i class="bi bi-person text-white" style="font-size:40px;"></i>
                            </div>
                        </c:if>
                        <h5 class="card-title">@${user.username}</h5>
                        <p class="text-muted">
                            <c:if test="${not empty user.followerCount}">
                                ${user.followerCount} followers
                            </c:if>
                        </p>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <div class="card bg-primary text-white h-100">
                            <div class="card-body">
                                <h6><i class="bi bi-calendar-check"></i> 예약된 포스트</h6>
                                <h2>${scheduledPosts.size()}</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="card bg-success text-white h-100">
                            <div class="card-body">
                                <h6><i class="bi bi-check-circle"></i> 발행 성공</h6>
                                <h2>${successCount}</h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="card bg-danger text-white h-100">
                            <div class="card-body">
                                <h6><i class="bi bi-x-circle"></i> 발행 실패</h6>
                                <h2>${failedCount}</h2>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mb-4">
            <div class="col-12">
                <a href="/posts/create" class="btn btn-primary">
                    <i class="bi bi-plus-circle"></i> 새 예약 만들기
                </a>
                <a href="/posts" class="btn btn-outline-secondary">
                    <i class="bi bi-list"></i> 전체 목록 보기
                </a>
            </div>
        </div>

        <!-- Scheduled Posts Table -->
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">예약된 포스트</h5>
            </div>
            <div class="card-body">
                <c:if test="${empty scheduledPosts}">
                    <div class="text-center py-5 text-muted">
                        <i class="bi bi-inbox" style="font-size: 48px;"></i>
                        <p class="mt-3">예약된 포스트가 없습니다.</p>
                        <a href="/posts/create" class="btn btn-primary">첫 예약 만들기</a>
                    </div>
                </c:if>
                <c:if test="${not empty scheduledPosts}">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>내용</th>
                                    <th>시간</th>
                                    <th>유형</th>
                                    <th>상태</th>
                                    <th>마지막 발행</th>
                                    <th>작업</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="post" items="${scheduledPosts}">
                                    <tr>
                                        <td style="max-width: 200px;">
                                            <c:choose>
                                                <c:when test="${post.content.length() > 50}">
                                                    ${post.content.substring(0, 50)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${post.content}
                                                </c:otherwise>
                                            </c:choose>
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
                                                <fmt:formatDate value="${post.lastPostedAt}" pattern="MM/dd HH:mm"/>
                                            </c:if>
                                            <c:if test="${post.lastPostedAt == null}">-</c:if>
                                        </td>
                                        <td>
                                            <a href="/posts/${post.id}/edit" class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <button class="btn btn-sm btn-outline-secondary toggle-btn" data-id="${post.id}">
                                                <i class="bi ${post.isActive ? 'bi-pause' : 'bi-play'}"></i>
                                            </button>
                                            <button class="btn btn-sm btn-outline-danger delete-btn" data-id="${post.id}">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Recent Activity -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">최근 활동</h5>
            </div>
            <div class="card-body">
                <c:if test="${empty recentLogs}">
                    <p class="text-muted text-center">아직 발행 기록이 없습니다.</p>
                </c:if>
                <c:if test="${not empty recentLogs}">
                    <ul class="list-group list-group-flush">
                        <c:forEach var="log" items="${recentLogs}">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <span>
                                    <span class="badge ${log.status == 'success' ? 'bg-success' : 'bg-danger'}">
                                        ${log.status == 'success' ? '성공' : '실패'}
                                    </span>
                                    포스트 발행
                                    <c:if test="${log.status == 'failed' and not empty log.errorMessage}">
                                        <small class="text-danger">- ${log.errorMessage}</small>
                                    </c:if>
                                </span>
                                <small class="text-muted">
                                    <fmt:formatDate value="${log.postedAt}" pattern="MM/dd HH:mm"/>
                                </small>
                            </li>
                        </c:forEach>
                    </ul>
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
